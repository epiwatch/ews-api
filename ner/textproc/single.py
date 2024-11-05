import argparse
import copy
import datetime
import json
import os
import random
import re
import ssl
import sys
import time
from string import Template

import config as cfg
import requests
from imap_tools import AND, MailBox

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__),"../textproc")))
from text_proc import TextProc

sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__),"prioritymodel")))
from bs4 import BeautifulSoup


class AlertEmailsProcessor:

    _summary = None
    _error = None

    session = None
    do_not_log_out_session = False

    final_api_response = None
    final_request_object = None
    collection_process_execution_object = None
    articles_array = None

    how_many_filtered_out = 0

    block_enabled = None
    write_enabled = None
    azure_enabled = False
    collection_process_id = 19 
    conf = None
    server_url = None
    server_username = None
    server_password = None

    email_accounts = None
    email_account_username = None
    email_account_password = None

    collection_process_info = None

    emails_found_during_list_processing = None
    objects_found_during_list_processing = None
    mail_message_errors_during_list_processing = 0
    scraping_errors_during_list_processing = 0
    scraping_errors_during_textproc = 0

    articles_to_process = None
    article_urls_successfully_scraped = None

    limit_article_fetches = None



    def get_summary_stats(self):

        try:

            if not self._summary:
                self._compute_summary()

            ob = {}
            ob['group'] = str(self._summary['execution_group'])
            ob['id'] = str(self._summary['id'])
            ob['collection'] = str(self._summary['collection_process_name']) + ' (id:' + str(self._summary['collection_process_id']) + ')'
            ob['total_articles_found'] = (self._summary['article_urls_found_on_list_url'])
            ob['new_articles_found'] = (self._summary['articles_to_process'])
            ob['articles_scraped'] = (self._summary['articles_scraped'])
            ob['how_many_filtered_out'] = self._summary['how_many_filtered_out']

            ob['articles_added'] = (self._summary['outcome']['articles']['success'])
            ob['articles_failed'] = (self._summary['outcome']['articles']['fail'])

            ob['processes_added'] = (self._summary['outcome']['collection_process_execution']['success'])
            ob['processes_failed'] = (self._summary['outcome']['collection_process_execution']['fail'])
            
            ob['datapoints_added'] = (self._summary['outcome']['article_reviewdata_points']['success'])
            ob['datapoints_failed'] = (self._summary['outcome']['article_reviewdata_points']['fail'])

            ob['single_article_scraping_errors'] = self.scraping_errors_during_list_processing
            ob['single_article_textproc_errors'] = self.scraping_errors_during_textproc
            ob['full_mail_message_errors'] = self.mail_message_errors_during_list_processing
            
            ob['error'] = self._summary['error']
            ob['api_error'] = self._summary['api_error']

            return ob

        except Exception as e:
            raise Exception("Error whilst putting together summary: " + str(e))



    def select_unique_urls(self,list_items):

        if (len(list_items) < 1):
            return []

        request_object = { "values_to_check": list(map(lambda el: el['url'],list_items)) }
        response = self.session.post(self.server_url + "article/exists",json=request_object)

        print(response.status_code)

        if response.status_code != 200:
            raise Exception(str(response.text))

        return_data = None
        try:
            return_data = response.json()
        except:
            raise Exception('There was a problem reading the json returned by POST /article/exists')

        if len(return_data) != len(request_object['values_to_check']):
            raise Exception('The number of items returned by API is not equal to request size. Exiting')

        unique_list_items = []
        for el in list_items:
            already_found = list(filter(lambda x: x['url'] == str(el['url']),unique_list_items))
            if (len(already_found) == 0):
                unique_list_items.append(el)




        new_list = []
        for el in unique_list_items:
            this_url = el['url']
            database_check = list(filter(lambda x: x['value'] == str(this_url),return_data))
            if (len(database_check) == 0):
                raise Exception('One of the urls was not checked as a duplicate for some reason. Exiting.')
            if (database_check[0]['exists'] is False):
                new_list.append(el)

        return new_list


    def pretty_print(self,ob):

        for el in ob['articles']:
            for point in el['article_reviewdata_points']:
                if len(point['value']) > 100:
                    point['value'] = str(point['value'][0:95]) + "...etc"
        print(json.dumps(ob,indent=3))

    def pretty_print2(self,ob):

        for el in ob['_outcome_object']['articles']:
            for point in el['article_reviewdata_points']:
                if len(point['value']) > 100:
                    point['value'] = str(point['value'][0:95]) + "...etc"
        print(json.dumps(ob,indent=3))

    def __setup(self,args):

        print("\n== Starting: Setup")
        try:

            self.write_enabled = False
            if ('write_enabled' in args and args['write_enabled'] == True):
                self.write_enabled = True
                print("NOTE: API Writing is ENABLED")
            else:
                print("NOTE: API Writing is DISABLED")

            self.azure_enabled = False
            if ('azure_enabled' in args and args['azure_enabled'] == True):
                self.azure_enabled = True
                print("NOTE: Azure API calls are ENABLED")
            else:
                print("NOTE: Azure API calls are DISABLED")

            self.block_enabled = False
            if ('block_enabled' in args and args['block_enabled'] == True):
                self.block_enabled = True
                print("NOTE: 'block_articles' is ENABLED")
            else:
                print("NOTE: 'block_articles' is DISABLED")

            self.limit_article_fetches = None
            if ('limit_article_fetches' in args and args['limit_article_fetches'] is not None):  
                self.limit_article_fetches = int(args['limit_article_fetches'])
                print("NOTE: Limiting article fetches to " + str(self.limit_article_fetches))



            self.execution_group = None
            if ('execution_group' in args and args['execution_group'] is not None):
                self.execution_group = args['execution_group']
            else:
                dateTimeObj = datetime.now()
                timestamp = dateTimeObj.strftime("%Y%m%d%H%M%S")
                random_hex = '%05x' % random.randrange(16**5)
                self.execution_group = (str(timestamp) + "_" + str(random_hex)).upper()

            if len(self.execution_group) < 2:
                raise Exception("An execution group string is required")

            print("EXECUTION_GROUP: " + str(self.execution_group))

            self.conf = cfg.load()
            self.server_url = self.conf['server']['url']
            self.server_username = self.conf['server']['username']
            self.server_password = self.conf['server']['password']
            self.email_accounts = self.conf['alert_email_accounts']

            if ('requests_session' in args and args['requests_session'] is not None):
                self.session = args['requests_session']
                self.do_not_log_out_session = True
                print("Using the session passed in as argument")
            else:
                print("Authenticating....")
                self.session = requests.session()
                self.session.verify = False 
                api_response = self.session.post(self.server_url + "auth/login",{ "email": self.server_username, "password": self.server_password })
                if api_response.status_code != 200:
                    raise Exception(str(api_response.text))
                print("Authentication successful")

            if self.conf['logging']['on']:
                if 'dir' not in self.conf['logging']:
                    raise Exception('Logging is turned on, but no directory is given')
                if not os.access(self.conf['logging']['dir'], os.W_OK | os.X_OK):
                    raise Exception('Logging directory is not writable')

            


        except Exception as e:
            raise Exception("Error during setup: " + str(e))
        finally:
            print("== Finished: Setup\n")

    def cleanup(self):
        if self.session:
            if self.do_not_log_out_session is False:
                print("Logging out....")
                api_response = self.session.post(self.server_url + "auth/logout")
                if api_response.status_code != 200:
                    raise Exception(str(api_response.text))
                print("Logout successful")

    def __setup_collection_info(self):

        print("\n== Starting: Setup collection info")
        try:

            print("COLLECTION_PROCESS_ID: " + str(self.collection_process_id))



            response = self.session.get(self.server_url + "collection_process/" + str(self.collection_process_id))
            if response.status_code != 200:
                raise Exception(str(response.text))

            self.collection_process_info = None
            try:
                self.collection_process_info = response.json()[0]
            except:
                raise Exception('There was a problem reading the json returned by GET /collection_process' + str(collection_process_id))
        except Exception as e:
            raise Exception("Error during setup collection info: " + str(e))
        finally:
            print("== Finished: Setup collection info\n")

    def _find_alert_in_email(self, tag):
        if (tag.name != "a"):
            return False
        if (tag.string is None):
            return False
        if (tag.get('href') is None):
            return False
        if (tag.get('href').find('alerts/feedback') == -1):
            return False
        if (tag.string.find("Flag") == -1 or tag.string.find("irrelevant") == -1):
            return False
        if (tag.parent.name != "td"):
            return False
        if (tag.parent.parent.name != "tr"):
            return False
        return True


    def _process_emails(self):

        print('\n== Starting: email processing')

        try:
            list_items = []
            mailbox = MailBox('imap.gmail.com').login(self.email_account_username, self.email_account_password)
            res = mailbox.folder.set('alerts')
            if (res[0] != "OK"):
                raise Exception("Could not open the alerts folder")

            mail_list = mailbox.fetch(AND(subject="Google Alert",date_gte=datetime.date.today() - datetime.timedelta(days=3)))
            email_count = 0

            for msg in mail_list:
                email_count = email_count + 1
                try:
                    this_html = (msg.html)
                    this_date_ob = msg.date
                    this_date_str = msg.date_str

                    soup = BeautifulSoup(this_html, 'lxml')
                    alerts = soup.find_all(self._find_alert_in_email)

                    for i in range(len(alerts)):
                        try:
                            ob = alerts[i].parent.parent.parent.parent.parent
                            date = f'{this_date_ob.year:04d}-{this_date_ob.month:02d}-{this_date_ob.day:02d}'
                            title = " ".join((' '.join(ob.span.a.stripped_strings)).split())
                            body = " ".join((' '.join(ob.div.div.div.find_next("div").stripped_strings)).split())
                            url = requests.utils.unquote(re.sub("^.+url=(.+)&ct=.*$","\\1",ob.a.get('href')))
                            list_items.append({"url": url, "publication_date": date, "title": title, "body": body})
                        except Exception as e:
                            self.scraping_errors_during_list_processing = self.scraping_errors_during_list_processing + 1
                            print(str(e))


                except Exception as e:
                    self.mail_message_errors_during_list_processing = self.mail_message_errors_during_list_processing + 1
                    print(str(e))

            if (self.objects_found_during_list_processing is None):
                self.objects_found_during_list_processing = list_items
            else:
                self.objects_found_during_list_processing += list_items

            if (self.emails_found_during_list_processing is None):
                self.emails_found_during_list_processing = email_count
            else:
                self.emails_found_during_list_processing += email_count
            
            print("Number of alerts found in " + str(email_count) + " emails: " + str(len(list_items)))


        except Exception as e:
            raise Exception("Error in email processing: " + str(e))
        finally:
            try:
                mailbox.logout()
            except:
                pass
            print('== Finished: list url processing\n')
    

    def _remove_duplicate_urls(self):


        print('\n== Starting: finding duplicate urls to ignore')

        try:
            new_list = self.select_unique_urls(self.objects_found_during_list_processing)
            print("Total urls found: " + str(len(self.objects_found_during_list_processing)))
            print("  > Duplicates: " + str(len(self.objects_found_during_list_processing) - len(new_list)))
            print("  > New: " + str(len(new_list)))

            if self.limit_article_fetches is not None:
                print("  > NOTE: LIMITING ARTICLES TO " + str(self.limit_article_fetches))
                new_list = new_list[0:self.limit_article_fetches]

            self.articles_to_process = new_list
            print("  > After duplicate removal & limiting, articles left: " + str(len(self.articles_to_process)))

        except Exception as e:
            raise Exception("Error whilst finding duplicate urls: " + str(e))
        finally:
            print('== Finished: finding duplicate urls to ignore\n')


    def _filter_articles(self):


        print('\n== Starting: filtering articles')

        try:
            new_list = copy.deepcopy(self.articles_array)
            for post in self.articles_array:
                try:
                    title_text = list(filter(lambda el: el['field_id'] == 2, post['article_reviewdata_points']))[0]['value']
                    body_text = list(filter(lambda el: el['field_id'] == 5, post['article_reviewdata_points']))[0]['value']
                    url_text = list(filter(lambda el: el['field_id'] == 1, post['article_reviewdata_points']))[0]['value']
                    if (re.search("markets|business|stocks|research|studies|vaccination|vaccine",str(body_text) + " " + str(title_text) ,re.IGNORECASE) is not None):
                        new_list.remove(post)
                    elif (re.search("youtube\.com", str(url_text), re.IGNORECASE) is not None):
                        new_list.remove(post)
                except Exception as e:
                    pass
            self.how_many_filtered_out = len(self.articles_array) - len(new_list)
            self.articles_array = copy.deepcopy(new_list)

        except Exception as e:
            raise Exception("Error whilst filtering articles: " + str(e))
        finally:
            print('== Finished: filtering articles\n')

        
    
    def _block_articles(self):


        print('\n== Starting: flagging articles for blocking')

        final_articles_array = []

        try:
            if not self.block_enabled:
                raise Exception("Invalid state. The block_articles function can only be called when block_enabled flag is true")
            for el in self.articles_to_process:
                final_articles_array.append( { "action": "block",
                                            "value_to_hash": el['url'],
                                            "article_reviewdata_points": [] })

            self.articles_array = final_articles_array

        except Exception as e:
            raise Exception("Error whilst flagging articles for blocking: " + str(e))
        finally:
            print('== Finished: flagging articles for blocking\n')

    def _process_articles(self):


        print('\n== Starting: processing articles')

        try:

     
            disease_ob = None
            syndrome_ob = None
            try:
                d_response = self.session.get(self.server_url + "disease/all")
                if d_response.status_code == 200:            
                    disease_ob = d_response.json()
                s_response = self.session.get(self.server_url + "syndrome/all")
                if s_response.status_code == 200:            
                    syndrome_ob = s_response.json()
            except:
                pass 


            articles_list = []

            server_ping_counter = 0
            for post in self.articles_to_process:

               
                server_ping_counter = server_ping_counter + 1
                if (server_ping_counter % 20 == 0):
                    try:
                        tmptmptmptmp = self.session.get(self.server_url + "disease/all")
                        if tmptmptmptmp.status_code == 200:
                            pass
                    except:
                        pass  

                try:
                    the_url = post['url']
                    item_results = []
                    proc = TextProc(None,disease_ob,syndrome_ob,email_mode=True,azure_enabled=self.azure_enabled)

                    proc.detect_language(post['body'])
                    language_info = proc.get_language_info()

                    fields_to_get = ['publication_date','title','body'] 

                    for dom in fields_to_get:

                        this_result = proc.get_values_for_email(post,dom)
                        if (this_result is not None):
                            item_results.append(this_result)


                    if (the_url is None):
                        print("Note: found an entry without URL, skipping")
                        continue

                    xtitle = list(filter(lambda x: x['article_reviewdata_field_id'] == 2,item_results))
                    xbody = list(filter(lambda x: x['article_reviewdata_field_id'] == 5,item_results))
                    priority_method = "manually_set"
                    priority_score = float(0)
                    if (len(xtitle) == 1 and len(xbody) == 1):
                        if ((xtitle[0]['translation_status_id'] == 101 or xtitle[0]['translation_status_id'] == 103) and (xbody[0]['translation_status_id'] == 101 or xbody[0]['translation_status_id'] == 103)):
                            if (xbody[0]['value'] is not None and xtitle[0]['value'] is not None):
                                xbody_text = str(xbody[0]['value'])
                                xtitle_text = str(xtitle[0]['value'])
                                xtitle_text = xtitle_text.replace("<div><p>","")
                                xbody_text = xbody_text.replace("<div><p>","")
                                xtitle_text = xtitle_text.replace("</p></div>","")
                                xbody_text = xbody_text.replace("</p></div>","")
                                txt_to_send = str(xtitle_text + ". " + xbody_text)
                                priority_score = float(0.99)
                                priority_method = 1


                    priority_info = { 'priority_score': priority_score, 'priority_method': priority_method }
                    articles_list.append({ 'url': the_url, 'item_results': item_results, 'language_info': language_info, 'priority_info': priority_info })
                except Exception as e:
                    self.scraping_errors_during_textproc = self.scraping_errors_during_textproc + 1

            print("number of articles scraped: " + str(len(articles_list)))


            final_articles_array = []
            for ob in articles_list:
                article_to_add = {}
                article_to_add['value_to_hash'] = ob['url']
                article_to_add['action'] = "add"

                article_to_add['language_info'] = ob['language_info']


                article_to_add['priority_info'] = ob['priority_info']


                article_to_add['article_reviewdata_points'] = []


                url_point = {}
                url_point['field_id'] = 1 
                url_point['value'] = ob['url']
                article_to_add['article_reviewdata_points'].append(url_point)

                this_item_results = ob['item_results']
                for el in this_item_results:
                    new_point = {}
                    new_point['field_id'] = el['article_reviewdata_field_id']
                    new_point['value'] = el['value']
                    new_point['value_with_nlp'] = el['value_with_nlp']
                    new_point['value_original_language'] = el['value_original_language']
                    new_point['extra'] = el['extra']
                    new_point['translation_status_id'] = el['translation_status_id']
                    new_point['nlp_list'] = el['nlp_list']
                    article_to_add['article_reviewdata_points'].append(new_point)
                final_articles_array.append(article_to_add)

            self.articles_array = final_articles_array

        except Exception as e:
            raise Exception("Error whilst processing articles: " + str(e))
        finally:
            print('== Finished: Processing articles\n')

    def _create_final_request_object(self):

        print('\n== Starting: creating final request object')

        try:

            ob = {}
            ob['collection_process_id'] = self.collection_process_id
            ob['execution_group'] = self.execution_group

            ob['collection_process_execution_result_code_id'] = 1
            ob['message'] = ""

            self.collection_process_execution_object = ob

            self.final_request_object = {}
            self.final_request_object['articles'] = self.articles_array
            self.final_request_object['collection_process_execution'] = self.collection_process_execution_object

        except Exception as e:
            raise Exception("Error whilst creating final request object: " + str(e))
        finally:
            print('== Finished: creating final request object\n')

    def _print_request_object(self):

        print('\n== Starting: Printing final request object')

        try:
            tmp = copy.deepcopy(self.final_request_object)
            self.pretty_print(tmp)
        except Exception as e:
            raise Exception("Error whilst printing final request object: " + str(e))
        finally:
            print('== Finished: Printing final request object\n')

    def _submit_articles(self):

        print('\n== Starting: Submitting articles')

        try:
            api_response = self.session.post(self.server_url + "collection_process/articles",json=self.final_request_object)
            if api_response.status_code != 200:
                raise Exception(str(api_response.text))
            api_response_obj = None
            try:
                api_response_obj = api_response.json()
                self.final_api_response = api_response_obj
            except:
                raise Exception('There was a problem reading the json returned by POST /collection_process/articles')

        except Exception as e:
            raise Exception("Error whilst submitting articles: " + str(e))
        finally:
            print('== Finished: Submitting articles\n')



    def _compute_summary(self):

        print("\n== Starting: Computing summary of results")
        try:
            if self._summary:
                raise Exception('summary was already computed')

            ob = {}

            ob['id'] = "EMAIL"
            ob['how_many_filtered_out'] = self.how_many_filtered_out

            ob['collection_process_id'] = None
            ob['collection_process_name'] = None
            if self.collection_process_info is not None:
                ob['collection_process_id'] = self.collection_process_info['id']
                ob['collection_process_name'] = self.collection_process_info['name']

            
            ob['article_urls_found_on_list_url'] = None
            if self.objects_found_during_list_processing is not None:
                ob['article_urls_found_on_list_url'] = len(self.objects_found_during_list_processing)

            ob['execution_group'] = self.execution_group

            ob['articles_to_process'] = None
            if self.articles_to_process is not None:
                ob['articles_to_process'] = len(self.articles_to_process)

            ob['article_urls_duplicate_or_limited'] = None
            if self.articles_to_process is not None and self.objects_found_during_list_processing is not None:
                ob['article_urls_duplicate_or_limited'] = len(self.objects_found_during_list_processing) - len(self.articles_to_process)

            ob['articles_scraped'] = None
            if self.articles_array is not None:
                ob['articles_scraped'] = len(self.articles_array) + self.how_many_filtered_out

            ob['outcome'] = { "collection_process_execution": { "success" : 0, "fail": 0 }, "articles": { "success" : 0, "fail": 0 }, "article_reviewdata_points": { "success" : 0, "fail": 0 }}

            if self.final_api_response is not None:
                if self.final_api_response['_outcome_summary'] is not None:
                    outcome_summary = self.final_api_response['_outcome_summary']

                    ob['outcome']['collection_process_execution']['success'] = outcome_summary['collection_process_execution']['success']
                    total = sum(list(map(lambda el: el[1], outcome_summary['collection_process_execution'].items())))
                    ob['outcome']['collection_process_execution']['fail'] = total - ob['outcome']['collection_process_execution']['success']

                    ob['outcome']['articles']['success'] = outcome_summary['articles']['success']
                    total = sum(list(map(lambda el: el[1], outcome_summary['articles'].items())))
                    ob['outcome']['articles']['fail'] = total - ob['outcome']['articles']['success']

                    ob['outcome']['article_reviewdata_points']['success'] = outcome_summary['article_reviewdata_points']['success']
                    total = sum(list(map(lambda el: el[1], outcome_summary['article_reviewdata_points'].items())))
                    ob['outcome']['article_reviewdata_points']['fail'] = total - ob['outcome']['article_reviewdata_points']['success']

            ob['single_article_scraping_errors'] = self.scraping_errors_during_list_processing
            ob['single_article_textproc_errors'] = self.scraping_errors_during_textproc
            ob['full_mail_message_errors'] = self.mail_message_errors_during_list_processing

            ob['error'] = self._error
            ob['api_error'] = None
            if self.final_api_response is not None:
                if '_error' in self.final_api_response:
                    ob['api_error'] = self.final_api_response['_error']

            self._summary = ob

        except Exception as e:
            raise Exception("Error whilst computing summary of results: " + str(e))
        finally:
            print('== Finished: Computing summary of results\n')

    def get_summary(self):
        if self._summary is None:
            return None
        new_copy = copy.deepcopy(self._summary)
        return(new_copy)



    def _print_summary(self):

        print('\n== Starting: Printing results')

        try:
            if not self._summary:
                self._compute_summary()
            print(json.dumps(self._summary,indent=3))
        except Exception as e:
            raise Exception("Error whilst printing results: " + str(e))
        finally:
            print('== Finished: Printing results\n')

    def _log(self):

        print('== Starting: Logging\n')
        try:
            if not self.conf['logging']['on']:
                print("Logging is turned off")
                return


            path = str(self.conf['logging']['dir']) + '/'
            proc_id = "EMAIL"
            collection_id = self.collection_process_id
            start_of_filename = str(path) + str(self.execution_group) + "_" + str(proc_id) + "_" + str(collection_id) + "_"

            request_log =  start_of_filename + "request_object_log.json"
            response_log = start_of_filename + "response_object_log.json"
            with open(request_log, 'w') as writer:
                writer.write(json.dumps(self.final_request_object,indent=3))

            with open(response_log, 'w') as writer:
                writer.write(json.dumps(self.final_api_response,indent=3))


        except Exception as e:
            raise Exception("Error whilst logging: " + str(e))
        finally:
            print('== Finished: Logging\n')

    def go(self):
        
        try:
            self.__setup_collection_info()
            
            for email_account in self.email_accounts:
                self.email_account_username = email_account["user"]
                self.email_account_password = email_account["password"]
                self._process_emails()

            self._remove_duplicate_urls()
            if self.block_enabled:
                self._block_articles() 
            else:
                self._process_articles() 
                self._filter_articles()

            self._create_final_request_object()

            if self.write_enabled:
                self._submit_articles()
            else:
                self._print_request_object()
        except Exception as e:
            print("Error encountered: " + str(e))
            self._error = str(e)
            raise Exception("Error encountered: " + str(e))
        finally:
            try:
                self._log()
            except Exception as e:
                print("There was a problem writing log files")
                pass
            try:
                self.cleanup()
            except Exception as e:
                print("There was a problem logging out")
                pass
            self._compute_summary()
            self._print_summary()


    def __init__(self,arguments):

        self.__setup(arguments)
        

def main():
    
    return

if __name__ == "__main__":
   main()

   


