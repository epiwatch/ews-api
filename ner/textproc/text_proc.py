import argparse
import copy
import json
import math
import os
import random
import re
import ssl
import sys
import time
import uuid
from datetime import datetime
from string import Template
from textwrap import dedent

import dateparser
import regex
import requests
import scrapy
import spacy
from bs4 import BeautifulSoup, Comment, NavigableString
from spacy import displacy
from spacy.lang.en import English
from spacy.matcher import Matcher
from spacy.tokens import Span


class TextProc:

    _email_mode = False
    _error = ""
    _response_object = None
    _detected_language = None
    _detected_language_name = None
    _detected_language_method = None
    _disease_data = None
    _syndrome_data = None
    _azure_enabled = False
    
    _nlp = spacy.load("en_core_web_trf")
    

    def _get_clean_body(self,soup_arg):

        soup = copy.copy(soup_arg)
        body = soup.find('body')
        all_body_tags = body.find_all(True)
        for tag in all_body_tags:
            tag.attrs = None
        body.attrs = None
        all_body_tags = body.find_all(True)
        for tag in all_body_tags:
            if (tag.name in ["style","stylesheet","script","template","meta","svg","img"]):
                tag.decompose()
        all_tags = body.find_all(True)
        for tag in all_tags:
            if (tag.name in ["a","span"]):
                tag.unwrap()
            if (tag.name not in ["ol","ul","li","p","div","span","b","i","h1","h2","h3","h4","h5","h6","title","br","table","tr","td","th"]):
                tag.name = "span"
        for el in body.find_all(string=lambda x: isinstance(x,Comment)):
            el.extract()

        body.smooth()
        to_return = copy.copy(body)
        to_return.name = "div" 
        return to_return


    def _remove_all_html(self,body):

        body.smooth()

        for el in body.find_all(string=lambda x: isinstance(x,NavigableString) and not isinstance(x,Comment)):
            replacement = el.string.strip()
            if (len(replacement) == 0):
                el.replace_with(NavigableString(replacement))
            elif (len(replacement) < 50):
                el.replace_with(NavigableString(replacement + "; "))
            else:
                el.replace_with(NavigableString("\n" + replacement + "\n"))

        all_tags = body.find_all(True)
        for tag in all_tags:
            tag.unwrap()

        body.smooth()
        return body


    def _detect_language(self,custom_text=None):

        if (self._azure_enabled is not True):
            self._detected_language = None
            self._detected_language_name = None
            self._detected_language_method = 5 
            return

        soup = None
        if (self._email_mode):
            soup = BeautifulSoup(custom_text,'lxml')
        else:
            soup = BeautifulSoup(self._response_object.text,'lxml')

        body = self._get_clean_body(soup)

        subset = copy.copy(body)

      
        tags = subset.find_all(True)
        for tag in tags:
            if (tag.name in ["a","link","table","tr","td","th"]):
                tag.decompose()

        list_of_text = []
        for element in subset.next_elements:
            if isinstance(element,Comment):
                continue
            if isinstance(element,NavigableString):
                stripped = element.string.strip()
                if (len(stripped) > 0):
                    list_of_text.append({ 'string': stripped, 'length': len(stripped) })

        list_of_text.sort(key=lambda x: x['length'],reverse=True)

        text_to_detect = ""
        for el in list_of_text:
            if len(text_to_detect) < 300:
                text_to_detect = text_to_detect + str(el['string']) + " "
            else:
                break


        final_text = ''.join(text_to_detect) 
        final_text = final_text[:299]

        if (len(final_text) > 300):
            raise ValueError("Language detection string length error")
        endpoint = "https://epiwatchlanguagedetection.cognitiveservices.azure.com/"
        api_url = endpoint + "/text/analytics/v3.0/languages"
        
        to_send = {"documents": [{"id": 1,"text":final_text}]}
        headers = {"Ocp-Apim-Subscription-Key": ""}
        response = requests.post(api_url, headers=headers, json=to_send)
        languages = response.json()
        source_language = None
        source_language_name = None
        if (len(languages['documents']) > 0):
            source_language = (languages['documents'][0]['detectedLanguage']['iso6391Name'])
            source_language_name = (languages['documents'][0]['detectedLanguage']['name'])
            

        self._detected_language = source_language
        self._detected_language_name = source_language_name
        self._detected_language_method = 2

    def _do_translation(self,arg):
        body = copy.copy(arg)

        if (self._detected_language == "en" or self._detected_language is None):
            return body

        if (self._azure_enabled is not True):
            return body

        print("Starting translation to EN...")
        translate = None
        try:
            headers = {
                'Ocp-Apim-Subscription-Key': "",
                'Content-type': 'application/json',
                'X-ClientTraceId': str(uuid.uuid4())
                }
            endpoint = "https://epiwatchlanguagedetection.cognitiveservices.azure.com/"
            path = '/translate?api-version=3.0'
            params = '&to=en'
            api_url = endpoint + path + params
        except:
            return body
        
        for el in body.find_all(string=lambda x: isinstance(x,NavigableString) and not isinstance(x,Comment)):
            replacement = el.string.strip()
            if (len(replacement) > 0):
                try:
                    to_send = [{'text': replacement}]
                    request = requests.post(api_url, headers=headers, json=to_send)
                    response = request.json()
                    this_result = (response[0]['translations'][0]['text'])
                    el.replace_with(NavigableString(str(this_result)))
                except:
                    pass 

        return body

    def _parse_the_date(self,date):

        parsers = ['custom-formats','absolute-time']
        

        if re.search('^\s*\d{2,4}\s*$',date) != None:
            return None

        ans = dateparser.parse(date,settings={'PARSERS':parsers})
        if (ans == None):
            return None
        
        with_first = dateparser.parse(date,settings={'PARSERS':parsers,'PREFER_DAY_OF_MONTH': 'first'})
        with_last = dateparser.parse(date,settings={'PARSERS':parsers,'PREFER_DAY_OF_MONTH': 'last'})
        
        if (with_first.day != with_last.day):
            return str(str("{:04d}".format(with_first.year)) + "-" + str("{:02d}".format(with_first.month)))
       
        
        return str(str("{:04d}".format(ans.year)) + "-" + str("{:02d}".format(ans.month)) + "-" + str("{:02d}".format(ans.day)))

    def _nlp_spacy(self,text,nlp_ob):

        doc = self._nlp(text)

        doc.ents = [ent for ent in doc.ents if ent.label_ in ["GPE","LOC","DATE"]]

        elements = []
        for ent in list(doc.ents):
            if not regex.search(r"[\(|\[|#|\]|\)]", ent.text.strip()):
              
                elements.append({ "text": ent.text.strip(), "start": ent.start_char, "end": ent.end_char, "label": ent.label_})

       
        elements.sort(key=lambda x: x['start'],reverse=True)

        for el in elements:
            this_category = None
            if (el['label'] == "GPE" or el['label'] == "LOC"):
                this_category = "location"
            elif (el['label'] == "DATE"):
                this_category = "date"
            else:
                this_category = "unknown"

            this_value = el['text']

            if (this_category == "date"):
                this_date = self._parse_the_date(el['text'])
                if (this_date == None):
                    continue 
                this_value = str(this_date)

            if (this_category == "location"):
                check_substrs = [
                    { "substr": "the", "check": "start"}
                ]
                for i in check_substrs:
                    substr_in_val = None
                    check_substr = i["substr"]
                
                    if (i["check"] == "start"):
                        check_substr = check_substr + " "
                        substr_in_val = this_value.lower().startswith(check_substr)
                    if (i["check"] == "end"):
                        check_substr = " " + check_substr
                        substr_in_val = this_value.lower().endswith(check_substr)
                    
                    if (substr_in_val):
                        if (i["check"] == "start"):
                            el['start'] = el['start'] + len(check_substr)
                            this_value = this_value[len(check_substr):]
                        if (i["check"] == "end"):
                            el['end'] = el['end'] - len(check_substr)
                            this_value = this_value[:len(this_value) - len(check_substr)]
                        el['text'] = this_value

            if (el['end'] == el['start'] or this_value == ""):
                continue


            nlp_ob['nlp_index_counter'] += 1
            nlp_ob['nlp_list'].append({
                "nlp_index": nlp_ob['nlp_index_counter'],
                "display_text": el['text'],
                "value": this_value,
                "category": this_category })
            
            text = text[:el['start']] + self.__get_nlp_marker_text(str(nlp_ob['nlp_index_counter'])) + text[el['end']:]
        
        return text

    def __get_nlp_marker_text(self,txt):
        return str('(#[#[x:'+ str(txt) +']#]#)')
        

    def __nlp_fuzzy_regex(self,text,nlp_ob):
        how_many_times = 0
        original_text_length = len(text)


        illness_names = []
        disease_names = list(map(lambda z: {'name': z['disease_variation'], 'category': 'disease', 'id': z['disease_id']},self._disease_data))
        illness_names.extend(disease_names)
        syndrome_names = list(map(lambda z: {'name': z['syndrome_variation'], 'category': 'syndrome', 'id': z['syndrome_id']}, self._syndrome_data))
        illness_names.extend(syndrome_names)
        illness_names.sort(key=lambda s: len(s['name']), reverse=True)

        for illness in illness_names:
            illness_category = illness['category']
            illness_id = illness['id']
            illness_name = illness['name']

            if (illness_name == "unknown" or illness_name == "other"):
                continue
            el = None
            jic_counter = 0 
            while True:
                jic_counter = jic_counter + 1
                if (jic_counter > 1000):
                    print("hmm")
                    break
                el = None
                how_many_times = how_many_times + 1

                el = regex.search(rf"\b{illness_name}\b",text,flags=regex.IGNORECASE)
                
                if not el:
                    break
                subtext_found = el.group()
                location_found = el.span()


                nlp_ob['nlp_index_counter'] += 1
                nlp_ob['nlp_list'].append({
                    "nlp_index": nlp_ob['nlp_index_counter'],
                    "display_text": subtext_found,
                    "value": illness_id,
                    "category": illness_category })

                text = text[:location_found[0]] + self.__get_nlp_marker_text(str(nlp_ob['nlp_index_counter'])) + text[location_found[1]:]

        if (original_text_length > 50):
            for illness in illness_names:
                illness_category = illness['category']
                illness_id = illness['id']
                illness_name = illness['name']

                if (illness_name == "unknown" or illness_name == "other"):
                    continue
                diff_allowed = math.floor(len(illness_name)/7)
                el = None
                jic_counter = 0 
                while True:
                    jic_counter = jic_counter + 1
                    if (jic_counter > 1000):
                        print("hmm")
                        break
                    el = None
                    how_many_times = how_many_times + 1

                    if (len(illness_name) > 5):
                        el = regex.search(rf"\b{illness_name}\b" + f"{{e<={diff_allowed}}}",text,flags=regex.BESTMATCH+regex.IGNORECASE)
                    
                    if not el:
                        break
                    subtext_found = el.group()
                    location_found = el.span()


                    nlp_ob['nlp_index_counter'] += 1
                    nlp_ob['nlp_list'].append({
                        "nlp_index": nlp_ob['nlp_index_counter'],
                        "display_text": subtext_found,
                        "value": illness_id,
                        "category": illness_category })

                    text = text[:location_found[0]] + self.__get_nlp_marker_text(str(nlp_ob['nlp_index_counter'])) + text[location_found[1]:]
        return text


    def _do_nlp(self,arg):
        body = copy.copy(arg)

        nlp_ob = {'nlp_index_counter': 0, 'nlp_list': []}

        for segment in body.find_all(string=lambda x: isinstance(x,NavigableString) and not isinstance(x,Comment)):
            try:
                replacement = segment.string.strip()

                if (len(replacement) > 0):

                    try:
                        replacement = self.__nlp_fuzzy_regex(replacement,nlp_ob)
                    except:
                        pass
                    

                    try:
                        replacement = self._nlp_spacy(replacement,nlp_ob)
                    except:
                        pass 

                    segment.replace_with(NavigableString(" " + replacement + " ")) 
            except:
                pass

        return { 'content': body, 'nlp_list': nlp_ob['nlp_list'] }


    def main():

        keep_basic = True
        with open("who_2.html") as fp:
            soup = BeautifulSoup(fp,'lxml')

        body = clean(soup)
        language_detect(body)

        if keep_basic:
            pass
        else: 
            remove_all_html(body)

        do_translation(body)
        print("############ AFTER TRANSLATION ###########")
        print(body)

        do_nlp(body)
        print("############ AFTER NLP ###################")
        print(body)


    def _log(self):
        pass

    def _cleanup(self):
        pass

    def get_values_for_email(self,ob,what):
        if (self._email_mode is False):
            raise ValueError("We're not in email mode, so this function shouldn't be called!")

        if what != "url" and what != "publication_date" and what != "title" and what != "body" and what != "pacnet_body":
            raise ValueError("can only url, publication_date, title or body from email alerts")

        if ob is None:
            print("NOTE: TextProc was passed an empty object to process. Skipping")
            return None 

       
        
        item = None
        field_id = None
        enable_nlp = True
        enable_translation = True
        content_html_id = None

        if what == "url":
            item = ob.url
            field_id = 1
            content_html_id = 1
            enable_nlp = False
            enable_translation = False
        elif what == "publication_date":
            item = ob.pub_date
            field_id = 4
            content_html_id = 2
        elif what == "title":
            item = ob.title
            field_id = 2
            content_html_id = 2
        elif what == "body":
            item = ob.body
            field_id = 5
            content_html_id = 3
        elif what == "pacnet_body":
            field_id = 3
            content_html_id = 3

        if content_html_id == 1:
            return_this = {
                'article_reviewdata_field_id' : field_id,
                'value' : item,
                'value_with_nlp': None,
                'value_original_language': None,
                'translation_status_id': None,
                'extra': None,
                'nlp_list': None
                }
            return return_this

        soup = BeautifulSoup(item,'lxml')
        div = None

        if content_html_id == 2: 
            div = self._get_clean_body(soup)
            div = self._remove_all_html(div)
        elif content_html_id == 3:
            div = self._get_clean_body(soup)
        else:
            raise ValueError("Incorrect content type found")
        
        div_original_language = None
        div_value = None
        div_with_nlp = None
        translation_status_id = None

        if enable_translation:
            if self._detected_language == "en":  
                div_value = copy.copy(div)
                translation_status_id = 101 
            else:
                div_original_language = copy.copy(div)
                try:
                    div_value = self._do_translation(div)
                    if self._azure_enabled is not True:
                        translation_status_id = 104
                    elif self._detected_language is None:
                        translation_status_id = 102 
                    elif div_value == div:
                        translation_status_id = 102 
                    else:
                        translation_status_id = 103 
                except Exception as e:
                    print("Error during translation, ignoring: " + str(e))
                    div_value = copy.copy(div)
                    translation_status_id = 102 
        else:
            div_value = copy.copy(div)

        nlp_list = None
        if enable_nlp and enable_translation: 
          
            try:
                returned_from_nlp = self._do_nlp(div_value)
                div_with_nlp = returned_from_nlp['content']
                nlp_list = returned_from_nlp['nlp_list']
            except:
                div_with_nlp = None


        value_to_return = None
        value_original_language_to_return = None
        value_with_nlp_to_return = None
        if content_html_id == 1:
            raise ValueError("Don't support raw at the moment")
        elif content_html_id == 2:
            value_to_return = div_value.get_text('\n',strip=True)
            if (div_original_language is not None):
                value_original_language_to_return = div_original_language.get_text('\n',strip=True)
            if (div_with_nlp is not None):
                value_with_nlp_to_return = div_with_nlp.get_text('\n',strip=True)
        elif content_html_id == 3:
            value_to_return = str(div_value)
            if (div_original_language is not None):
                value_original_language_to_return = str(div_original_language)
            if (div_with_nlp is not None):
                value_with_nlp_to_return = str(div_with_nlp)

        extra_field = None
        if field_id == 4:

            extra_field = self._parse_the_date(value_to_return)
        
        ob_to_return = {
            'article_reviewdata_field_id' : field_id,
            'value' : value_to_return,
            'value_with_nlp': value_with_nlp_to_return,
            'value_original_language': value_original_language_to_return,
            'translation_status_id': translation_status_id,
            'extra': extra_field,
            'nlp_list': nlp_list
            }
        return ob_to_return


    
    def get_values(self,dom_element,just_return_raw=False):
        if (self._email_mode is True):
            raise ValueError("We're in email mode, so this function shouldn't be called!")

       
        
        xpath = dom_element['xpath']
        special_selector = dom_element['special_selector']
        regex_extract = dom_element['regex_extract']
        regex_replace_with = dom_element['regex_replace_with']
        article_reviewdata_field_id = dom_element['article_reviewdata_field']['id']
        enable_nlp = dom_element['article_reviewdata_field']['enable_nlp']
        enable_translation = dom_element['article_reviewdata_field']['enable_translation']
        content_html_id = dom_element['article_reviewdata_field']['content_html_id']

        el = self._response_object.xpath(xpath) 
        if len(el) < 1:
            print("NOTE: Did not find dom element in given page. Skipping")
            return None
      

        item = ''.join(el.getall())


        if (regex_extract is not None):
            if (re.match(regex_extract,item) is None):
                item = None
            else:
                try:
                    item = re.sub(regex_extract,regex_replace_with,item)
                except:
                    item = None

        if (just_return_raw):
            return item


        if content_html_id == 1: 
            return_this = {
                'value' : item,
                'value_with_nlp': None,
                'value_original_language': None,
                'translation_status_id': None,
                'extra': None,
                'nlp_list': None
                }
            return_this['wsp_dom_article_field_id'] = dom_element['wsp_dom_article_field_id']
            return return_this
          

        soup = BeautifulSoup(item,'lxml')
        div = None

        if content_html_id == 2:
            div = self._get_clean_body(soup)
            div = self._remove_all_html(div)
        elif content_html_id == 3: 
            div = self._get_clean_body(soup)
        else:
            raise ValueError("Incorrect content type found")
        
        div_original_language = None
        div_value = None
        div_with_nlp = None
        translation_status_id = None


        if enable_translation:
            if self._detected_language == "en":
                div_value = copy.copy(div)
                translation_status_id = 101 
            else:
                div_original_language = copy.copy(div)
                try:
                    div_value = self._do_translation(div)
                    if self._azure_enabled is not True:
                        translation_status_id = 104
                    elif self._detected_language is None:
                        translation_status_id = 102
                    elif div_value == div:
                        translation_status_id = 102
                    else:
                        translation_status_id = 103
                except Exception as e:
                    print("Error during translation, ignoring: " + str(e))
                    div_value = copy.copy(div)
                    translation_status_id = 102
        else:
            div_value = copy.copy(div)

        nlp_list = None
        if enable_nlp and enable_translation: 
          
            try:
                returned_from_nlp = self._do_nlp(div_value)
                div_with_nlp = returned_from_nlp['content']
                nlp_list = returned_from_nlp['nlp_list']
            except:
                div_with_nlp = None


        value_to_return = None
        value_original_language_to_return = None
        value_with_nlp_to_return = None
        if content_html_id == 1:
            raise ValueError("Don't support raw at the moment")
        elif content_html_id == 2: 
            value_to_return = div_value.get_text('\n',strip=True)
            if (div_original_language is not None):
                value_original_language_to_return = div_original_language.get_text('\n',strip=True)
            if (div_with_nlp is not None):
                value_with_nlp_to_return = div_with_nlp.get_text('\n',strip=True)
        elif content_html_id == 3:
            value_to_return = str(div_value)
            if (div_original_language is not None):
                value_original_language_to_return = str(div_original_language)
            if (div_with_nlp is not None):
                value_with_nlp_to_return = str(div_with_nlp)

        extra_field = None
        if article_reviewdata_field_id == 4:

            extra_field = self._parse_the_date(value_to_return)
        
        ob_to_return = {
            'value' : value_to_return,
            'value_with_nlp': value_with_nlp_to_return,
            'value_original_language': value_original_language_to_return,
            'translation_status_id': translation_status_id,
            'extra': extra_field,
            'nlp_list': nlp_list
            }

        ob_to_return['wsp_dom_article_field_id'] = dom_element['wsp_dom_article_field_id']
        return ob_to_return


    def go(self):
        
        try:

           

            self._do_things()
            
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

    def detect_language(self,custom_text = None):
        try:
            self._detect_language(custom_text)
        except Exception as e:
            print("Error during language detection. Set all to None: " + str(e))
            self._detected_language = None
            self._detected_language_name = None
            self._detected_language_method = 4

    def get_language_info(self):
        ob_to_return = { 'language_detection_method_id': self._detected_language_method,
            'language_code': self._detected_language,
            'language_name': self._detected_language_name }

        return ob_to_return

    def __init__(self,response_object,disease_data,syndrome_data,email_mode=False,azure_enabled=False):
        self._email_mode = email_mode
        self._response_object = response_object
        self._disease_data = disease_data
        self._syndrome_data = syndrome_data
        self._azure_enabled = azure_enabled





if __name__ == "__main__":
   main()

   


