import msal
import requests

from ner.textproc.text_proc import TextProc


class TranslatedArticle:
	def __init__(
			self, 
			tran_title: str, 
			tran_body: str, 
			lang: str, 
			lang_code: str, 
			lang_detect_method: int, 
			nlp_list: list,
			with_nlp: list
		) -> None:
		self.tran_title = tran_title
		self.tran_body = tran_body
		self.lang = lang
		self.lang_code = lang_code
		self.lang_detect_method = lang_detect_method
		self.nlp_list = nlp_list
		self.with_nlp = with_nlp

class ScrapedGoogleArticle:
	def __init__(self, title, pub_date, body, url) -> None:
		self.title = title
		self.pub_date = pub_date
		self.body = body
		self.url = url
		

class NlpParser():
	
	azure_enabled = False
	proc = None
	def translate_article(self, article: ScrapedGoogleArticle) -> TranslatedArticle:
		
		try:
			
			self.proc.detect_language(article.body)
			
			language_info = self.proc.get_language_info()

			fields_to_get = ['publication_date','title','body'] # Don't add the url to the item_results
			item_results = []
			for dom in fields_to_get:
			# Get item from proc
				this_result = self.proc.get_values_for_email(article,dom)
				if (this_result is not None):
					item_results.append(this_result)

			if (article.url is None):
				print("Note: found an entry without URL, skipping")
				return
			
			xtitle = list(filter(lambda x: x['article_reviewdata_field_id'] == 2,item_results))
			xbody = list(filter(lambda x: x['article_reviewdata_field_id'] == 5,item_results))
			xtitle_text = article.title
			xbody_text = article.body

			if (len(xtitle) == 1 and len(xbody) == 1):
				# if both title and body are english or translated by azure
				if ((xtitle[0]['translation_status_id'] == 101 or xtitle[0]['translation_status_id'] == 103) and (xbody[0]['translation_status_id'] == 101 or xbody[0]['translation_status_id'] == 103)):
					if (xbody[0]['value'] is not None and xtitle[0]['value'] is not None):
						xbody_text = str(xbody[0]['value'])
						xtitle_text = str(xtitle[0]['value'])
						xtitle_text = xtitle_text.replace("<div><p>","")
						xbody_text = xbody_text.replace("<div><p>","")
						xtitle_text = xtitle_text.replace("</p></div>","")
						xbody_text = xbody_text.replace("</p></div>","")
			nlp_list = [nlp["nlp_list"] for nlp in item_results]
			with_nlp = [nlp["value_with_nlp"] for nlp in item_results]

			return TranslatedArticle(xtitle_text, xbody_text, language_info["language_name"], language_info["language_code"], language_info["language_detection_method_id"], nlp_list, with_nlp)
		except Exception as e:
			pass
	def __init__(self, azure_enabled=False, disease_ob=None, syndrome_ob=None):
		self.proc = TextProc(None,disease_ob,syndrome_ob,email_mode=True,azure_enabled=azure_enabled)
	


def process_articles(articles):
	print('\n== Starting: processing articles')
	#######################
	# Process the articles that were found in the emails

	articles_list = []
	disease_ob = None
	syndrome_ob = None
	proc = TextProc(None,disease_ob,syndrome_ob,email_mode=True,azure_enabled=True)
	server_ping_counter = 0
	disease_ob = None
	syndrome_ob = None
	for post in articles:

		try:
			the_url = post.url
			item_results = []
			proc.detect_language(post.body)
			language_info = proc.get_language_info()

			fields_to_get = ['publication_date','title','body'] # Don't add the url to the item_results

			for dom in fields_to_get:

			# Get item from proc
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
						priority_score = float(tmp_model.predict_prob(txt_to_send)[0])
						priority_method = tmp_model.get_model_id()


			priority_info = { 'priority_score': priority_score, 'priority_method': priority_method }
			articles_list.append({ 'url': the_url, 'item_results': item_results, 'language_info': language_info, 'priority_info': priority_info })
		except Exception as e:
			print("Error scraping")


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
	print("== Finished: Processing articles\n")

	return final_articles_array



if __name__ == "__main__":
	scraped = ScrapedGoogleArticle("test", "20/20/2024", "Not truly a test but fever", "test.com")
	correct = TranslatedArticle("test", "Not truly a test but fever", None, None, 5, [[], [], [{'nlp_index': 1, 'display_text': 'fever', 'value': 1, 'category': 'syndrome'}]], ['20/20/2024;', 'test;', '<div><p> Not truly a test but (#[#[x:1]#]#) </p></div>'])
	parser = NlpParser(False, [], [{'syndrome_id': 1, 'syndrome_variation': 'fever'}, {'syndrome_id': 2, 'syndrome_variation': 'diarrhoea'}])

	article = parser.translate_article(scraped)

	assert(article.tran_title == correct.tran_title)

	assert(article.tran_body == correct.tran_body)

	assert(article.lang == correct.lang)
	assert(article.lang_code == correct.lang_code)
	assert(article.lang_detect_method == correct.lang_detect_method)
	assert(article.nlp_list == correct.nlp_list)
	assert(article.with_nlp == correct.with_nlp)
