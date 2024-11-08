--
-- PostgreSQL database dump
--

-- Dumped from database version 12.17 (Ubuntu 12.17-0ubuntu0.20.04.1)
-- Dumped by pg_dump version 15.8 (Ubuntu 15.8-1.pgdg20.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: article; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.article (
    id integer NOT NULL,
    reviewed integer DEFAULT 0 NOT NULL,
    audited integer DEFAULT 0 NOT NULL,
    flagged integer DEFAULT 0 NOT NULL,
    accepted integer DEFAULT 0 NOT NULL,
    blocked integer DEFAULT 0 NOT NULL,
    skipped integer DEFAULT 0 NOT NULL,
    language_detection_method_id integer,
    language_code character varying(15) DEFAULT NULL::character varying,
    language_name character varying(100) DEFAULT NULL::character varying,
    priority_score double precision,
    priority_method character varying(100) DEFAULT NULL::character varying,
    unique_hash character varying(64) NOT NULL,
    hashed_value character varying(2000) NOT NULL,
    flag_comments text,
    original_priority_score double precision,
    suggested_priority_score double precision
);


--
-- Name: article_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.article_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.article_id_seq OWNED BY public.article.id;


--
-- Name: article_reviewdata_field; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.article_reviewdata_field (
    id integer NOT NULL,
    enable_nlp smallint NOT NULL,
    enable_translation smallint NOT NULL,
    content_html_id integer,
    name character varying(100) NOT NULL,
    description character varying(512) NOT NULL
);


--
-- Name: article_reviewdata_field_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.article_reviewdata_field_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_reviewdata_field_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.article_reviewdata_field_id_seq OWNED BY public.article_reviewdata_field.id;


--
-- Name: article_reviewdata_point; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.article_reviewdata_point (
    id integer NOT NULL,
    article_id integer,
    article_reviewdata_field_id integer,
    translation_status_id integer,
    value character varying NOT NULL,
    value_with_nlp character varying,
    value_original_language character varying,
    extra character varying
);


--
-- Name: article_reviewdata_point_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.article_reviewdata_point_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_reviewdata_point_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.article_reviewdata_point_id_seq OWNED BY public.article_reviewdata_point.id;


--
-- Name: article_reviewdata_point_nlp; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.article_reviewdata_point_nlp (
    id integer NOT NULL,
    article_reviewdata_point_id integer,
    nlp_index integer NOT NULL,
    display_text character varying NOT NULL,
    value character varying NOT NULL,
    category character varying(10) NOT NULL
);


--
-- Name: article_reviewdata_point_nlp_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.article_reviewdata_point_nlp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_reviewdata_point_nlp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.article_reviewdata_point_nlp_id_seq OWNED BY public.article_reviewdata_point_nlp.id;


--
-- Name: article_trace; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.article_trace (
    id integer NOT NULL,
    article_id integer NOT NULL,
    collection_process_execution_log_id integer NOT NULL
);


--
-- Name: article_trace_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.article_trace_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: article_trace_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.article_trace_id_seq OWNED BY public.article_trace.id;


--
-- Name: colours_api; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.colours_api (
    id integer NOT NULL,
    color_hex character varying(16)
);


--
-- Name: country_data; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.country_data (
    id integer NOT NULL,
    country_name character varying(50) NOT NULL,
    iso3 character varying(3) NOT NULL,
    iso2 character varying(2),
    latitude double precision NOT NULL,
    longitude double precision NOT NULL,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    hindi_translation character varying(255)
);


--
-- Name: disease; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.disease (
    id integer NOT NULL,
    disease character varying(100) NOT NULL,
    active smallint NOT NULL,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    hindi_translation character varying(255),
    colour character varying(32)
);


--
-- Name: regions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    region character varying(50) NOT NULL,
    iso3 character varying(3) NOT NULL
);


--
-- Name: report; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report (
    id integer NOT NULL,
    article_id integer NOT NULL,
    last_updated timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: report_data_field; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_data_field (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(512) NOT NULL,
    report_data_field_type_id integer NOT NULL,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: report_data_field_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_data_field_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(512) NOT NULL,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: report_data_point; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_data_point (
    id integer NOT NULL,
    report_id integer,
    report_data_field_id integer,
    value character varying NOT NULL
);


--
-- Name: report_data_point_disease; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_data_point_disease (
    id integer NOT NULL,
    report_id integer NOT NULL,
    disease_id integer NOT NULL
);


--
-- Name: report_data_point_location; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_data_point_location (
    id bigint NOT NULL,
    report_id bigint NOT NULL,
    latitude double precision,
    longitude double precision,
    district text,
    city text,
    metro_area text,
    sub_region text,
    region text,
    country_id bigint NOT NULL
);


--
-- Name: report_data_point_syndrome; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.report_data_point_syndrome (
    id bigint NOT NULL,
    report_id bigint NOT NULL,
    syndrome_id bigint NOT NULL
);


--
-- Name: subregions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.subregions (
    id integer NOT NULL,
    subregion character varying(50),
    iso3 character varying(3),
    hindi_translation character varying(128) DEFAULT NULL::character varying
);


--
-- Name: syndrome; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.syndrome (
    id bigint NOT NULL,
    syndrome character varying(100) NOT NULL,
    active smallint NOT NULL,
    last_updated timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    hindi_translation character varying(255),
    colour character varying(16)
);


--
-- Name: article id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article ALTER COLUMN id SET DEFAULT nextval('public.article_id_seq'::regclass);


--
-- Name: article_reviewdata_field id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_reviewdata_field ALTER COLUMN id SET DEFAULT nextval('public.article_reviewdata_field_id_seq'::regclass);


--
-- Name: article_reviewdata_point id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_reviewdata_point ALTER COLUMN id SET DEFAULT nextval('public.article_reviewdata_point_id_seq'::regclass);


--
-- Name: article_reviewdata_point_nlp id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_reviewdata_point_nlp ALTER COLUMN id SET DEFAULT nextval('public.article_reviewdata_point_nlp_id_seq'::regclass);


--
-- Name: article_trace id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_trace ALTER COLUMN id SET DEFAULT nextval('public.article_trace_id_seq'::regclass);


--
-- Data for Name: article; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.article (id, reviewed, audited, flagged, accepted, blocked, skipped, language_detection_method_id, language_code, language_name, priority_score, priority_method, unique_hash, hashed_value, flag_comments, original_priority_score, suggested_priority_score) FROM stdin;
\.


--
-- Data for Name: article_reviewdata_field; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.article_reviewdata_field (id, enable_nlp, enable_translation, content_html_id, name, description) FROM stdin;
1	0	0	1	url	The url to an article
2	1	1	2	title	The title of an article
3	1	1	3	body-text	The main content of an article
4	1	1	2	publication-date	The publication date of an article
5	1	1	3	summary-text	A short summary of an article
\.


--
-- Data for Name: article_reviewdata_point; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.article_reviewdata_point (id, article_id, article_reviewdata_field_id, translation_status_id, value, value_with_nlp, value_original_language, extra) FROM stdin;
\.


--
-- Data for Name: article_reviewdata_point_nlp; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.article_reviewdata_point_nlp (id, article_reviewdata_point_id, nlp_index, display_text, value, category) FROM stdin;
\.


--
-- Data for Name: article_trace; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.article_trace (id, article_id, collection_process_execution_log_id) FROM stdin;
\.


--
-- Data for Name: colours_api; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.colours_api (id, color_hex) FROM stdin;
0	#34de16
1	#c79fa7
2	#eb3db1
3	#6affe8
4	#287944
5	#c6cb76
6	#188970
7	#f6a0da
8	#1e287b
9	#a8d281
10	#bc5c75
11	#5739c7
12	#d2b81e
13	#24b98
14	#eeb0ec
15	#3f41dc
16	#17b4d5
17	#63dff9
18	#762909
19	#fa720b
20	#3ede8
21	#4f20e0
22	#5d58fd
23	#e200f2
24	#3ffb65
25	#8b1281
26	#45bb18
27	#57b77f
28	#d2b803
29	#e69ee7
30	#343e3a
31	#3bb63d
32	#cab74a
33	#f451a3
34	#32fb79
35	#bac7f7
36	#2b6875
37	#6221cd
38	#b797e4
39	#1ecf25
40	#72687e
41	#acc7cc
42	#8e7786
43	#fe085
44	#9da443
45	#58268c
46	#e3e266
47	#ac7ac5
48	#3eb4f2
49	#8ffaf9
50	#182e8d
51	#ab3094
52	#493e0b
53	#7debba
54	#e6f401
55	#9b082c
56	#4ce1b7
57	#4e9966
58	#200d61
59	#2827fc
60	#7b2b6d
61	#4908f5
62	#f0636f
63	#9c5875
64	#aaedc3
65	#be398e
66	#af499e
67	#ab95c
68	#3de5e1
69	#4b6f20
70	#1bafba
71	#ffcd9c
72	#5afd4
73	#f15142
74	#984c23
75	#35dd8b
76	#afd123
77	#a2e32e
78	#a7e451
79	#f05f59
80	#ebde36
81	#cdba5
82	#304db1
83	#5097a0
84	#b5a414
85	#422a5f
86	#4ac00d
87	#66f7
88	#fd7677
89	#d161e3
90	#d9779c
91	#c8818c
92	#c52476
93	#b30a16
94	#2a1baa
95	#535857
96	#3ce760
97	#83e75e
98	#4ac97f
99	#c872da
100	#4dc5cd
101	#5810e7
102	#649e8e
103	#4e1f46
104	#9c3bfd
105	#8ca47a
106	#cf48ac
107	#fb45ad
108	#6575ca
109	#91f9d2
110	#bbc115
111	#2d5e00
112	#3fb514
113	#ba0d98
114	#84bff5
115	#44f57b
116	#265672
117	#e76c52
118	#9d881d
119	#f37c80
120	#e84d5b
121	#f51521
122	#c708d
123	#f2d537
124	#48dfd5
125	#cb9e93
126	#8d9a45
127	#c4d510
128	#df40a8
129	#ae7ab4
130	#41df8
131	#529fbe
132	#acdf8c
133	#decd8b
134	#1affd2
135	#addc06
136	#8dcdf8
137	#63c741
138	#f4b07f
139	#5178c2
140	#c326aa
141	#4c02ce
142	#61da34
143	#6914ea
144	#d6e386
145	#89b235
146	#a29ec
147	#abb3c8
148	#c650f9
149	#ec2353
150	#e0735a
151	#b39af4
152	#f9a959
153	#2c278f
154	#14c593
155	#fa5385
156	#cac321
157	#979404
158	#3f540f
159	#9df0d7
160	#2e3f74
161	#2ff4eb
162	#b6cf0c
163	#761967
164	#c0bab
165	#5630ac
166	#886f2d
167	#fccdd9
168	#78ca11
169	#f5806
170	#5dfe2a
171	#6ece93
172	#4253b3
173	#1e383e
174	#835e63
175	#464
176	#b0e2dd
177	#cb0f17
178	#7262e3
179	#ca1861
180	#479c97
181	#ed2741
182	#b4147f
183	#789baa
184	#849c8f
185	#f99110
186	#b35b7b
187	#f288c6
188	#1e49e1
189	#3738e1
190	#ba9fbb
191	#f0e01b
192	#191bac
193	#98b78a
194	#4d4862
195	#d2e80f
196	#ddc221
197	#a94eab
198	#55a5f9
199	#983357
200	#aba7
201	#3cccaf
202	#215020
203	#b58e95
204	#525e3f
205	#dcc312
206	#4ec1ca
207	#639ef6
208	#40ca82
209	#741bec
210	#1020b2
211	#797c07
212	#11c451
213	#da18f6
214	#45676a
215	#124e7f
216	#f892cb
217	#d382c1
218	#5f404a
219	#f29004
220	#3103c5
221	#c7a68e
222	#87bc1b
223	#2c996c
224	#d173b6
225	#c89fc0
226	#a1879f
227	#b5615a
228	#7c6bcb
229	#7627f0
230	#d46185
231	#d08652
232	#ff17d9
233	#12b48c
234	#2978fe
235	#87db0a
236	#23c20b
237	#bf913b
238	#f910f3
239	#a51319
240	#e4c0dd
241	#f65f6b
242	#5b2df6
243	#3f4d13
244	#32a286
245	#af4b0a
246	#faeea2
247	#606318
248	#efeffa
249	#9f061b
250	#4600e9
251	#1d7aad
252	#b90f0
253	#2c1132
254	#5bf379
255	#424696
256	#32c38f
257	#ebb9f5
258	#4efb4b
259	#5579b5
260	#931734
261	#c77e86
262	#cb3801
263	#31c352
264	#5a13fd
265	#f4b2bc
266	#51516a
267	#331214
268	#109561
269	#173912
270	#a1c570
271	#b9a632
272	#d18f14
273	#455d89
274	#a8f538
275	#768b1
276	#7e4089
277	#404021
278	#aebb1e
279	#ae7877
280	#37db3a
281	#690766
282	#aeb6b5
283	#2cce6
284	#b44033
285	#92f428
286	#6a5e18
287	#b3b8b7
288	#39b058
289	#e58aed
290	#7d170a
291	#3adcb2
292	#9891b4
293	#a803a6
294	#2ba1e7
295	#2e6e9f
296	#9fd6cb
297	#ef95a0
298	#f99b7a
299	#7e2bf5
300	#94f56a
301	#d92aee
302	#2176c3
303	#ea247f
304	#1ff91
305	#ee2af1
306	#a808c0
307	#43446b
308	#4ec884
309	#13268c
310	#67586d
311	#638b02
312	#f991db
313	#7c2c18
314	#bc42a1
315	#aa0922
316	#94fca9
317	#f27539
318	#169d67
319	#8f3747
320	#254671
321	#d519ed
322	#411551
323	#497c3f
324	#1bfc47
325	#de58e
326	#1e2fa9
327	#f84bfa
328	#eb8339
329	#d51cf0
330	#db5c08
331	#aab784
332	#8bdb58
333	#1b46bb
334	#e9e278
335	#30d8c1
336	#510aec
337	#94a90f
338	#26d456
339	#af5fab
340	#3c14fa
341	#f8713e
342	#11a9e0
343	#d4c87
344	#9c85fb
345	#1161ac
346	#f24de5
347	#f56fa
348	#970109
349	#5f8ca9
350	#521a9d
351	#3b7fa9
352	#172da9
353	#20867
354	#4e61e6
355	#846808
356	#3f7a05
357	#415238
358	#6a2bd4
359	#abb922
360	#bb9872
361	#3cd718
362	#855ac2
363	#7e1061
364	#edb24e
365	#afaa47
366	#84c2d6
367	#34f71
368	#3ea86d
369	#59b062
370	#1cbf3a
371	#9204d7
372	#c3f7d1
373	#2d0008
374	#e79db9
375	#3b1b1
376	#961c3d
377	#54b84e
378	#3dfc74
379	#4384ee
380	#fa5115
381	#d2810f
382	#1ae980
383	#905dc7
384	#39cec5
385	#3113e4
386	#585573
387	#f3527e
388	#aafcab
389	#a2b251
390	#c48f3
391	#bda34a
392	#4fb6db
393	#3046b0
394	#58f0b1
395	#7d6685
396	#94c15f
397	#1d5532
398	#b59581
399	#d162e5
400	#579460
401	#35664a
402	#21ce32
403	#1b7375
404	#af8681
405	#ad7e05
406	#2c4a3e
407	#1bcb14
408	#53e304
409	#405679
410	#f1c103
411	#8bcdc
412	#c9331d
413	#4a920a
414	#242393
415	#a7a05a
416	#cb1f62
417	#d1539
418	#54dd6b
419	#b1dd04
420	#886985
421	#c08325
422	#43344a
423	#a8a26
424	#80fd12
425	#16fa1a
426	#c7c34b
427	#1a110a
428	#e4bcd5
429	#7c18bf
430	#c70c1a
431	#67918e
432	#269e72
433	#4dca8f
434	#cf8e2e
435	#33d873
436	#eef560
437	#5700a
438	#f8c0e0
439	#fd0ec1
440	#7d6bd8
441	#47be91
442	#173217
443	#177049
444	#e222a6
445	#6b8ccd
446	#95daa0
447	#d4c79d
448	#56dd36
449	#f01266
450	#35558
451	#3da968
452	#56522f
453	#986d8d
454	#b6d743
455	#af049c
456	#6d3bcd
457	#6c2990
458	#9dfdd7
459	#cb973e
460	#3f0dea
461	#33078a
462	#8fb6b2
463	#b3c15f
464	#54c3bc
465	#645453
466	#bfe543
467	#54e01e
468	#f98830
469	#5492ea
470	#62a922
471	#d0fc7a
472	#35259b
473	#672132
474	#e9ab22
475	#e461fe
476	#99bccb
477	#ed97cb
478	#533f55
479	#d8cf72
480	#7fa057
481	#1f3449
482	#803f3b
483	#ed9c6a
484	#348c8
485	#718f10
486	#e367d0
487	#615d81
488	#96b7bd
489	#29b505
490	#61b2dd
491	#6f7161
492	#37a6c6
493	#c065c
494	#dc34fc
495	#b014c0
496	#2f1bf3
497	#64b5
498	#611044
499	#d0412c
\.


--
-- Data for Name: country_data; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.country_data (id, country_name, iso3, iso2, latitude, longitude, last_updated, hindi_translation) FROM stdin;
1	Aruba	ABW	AW	12.5167	-70.0167	2023-08-14 08:43:59	अरूबा
2	Afghanistan	AFG	AF	34.5228	69.1761	2023-08-14 08:43:59	अफ़ग़ानिस्तान‌
3	Angola	AGO	AO	-8.81155	13.242	2023-08-14 08:43:59	अंगोला
4	Albania	ALB	AL	41.3317	19.8172	2023-08-14 08:43:59	अल्बानिया
5	Andorra	AND	AD	42.5075	1.5218	2023-08-14 08:43:59	अंडोरा
6	United Arab Emirates	ARE	AE	24.4764	54.3705	2023-08-14 08:43:59	संयुक्त‌ अर‌ब‌ अमीरात‌
7	Argentina	ARG	AR	-34.6118	-58.4173	2023-08-14 08:43:59	आर्जेंटीना
8	Armenia	ARM	AM	40.1596	44.509	2023-08-14 08:43:59	आर्मीनिया
9	American Samoa	ASM	AS	-14.2846	-170.691	2023-08-14 08:43:59	अमरीकी स‌मोआ
10	Antigua and Barbuda	ATG	AG	17.1175	-61.8456	2023-08-14 08:43:59	अंटिग्वा और‌ बार‌बुडा
11	Australia	AUS	AU	-35.282	149.129	2023-08-14 08:43:59	ऑस्ट्रेलिया
12	Austria	AUT	AT	48.2201	16.3798	2023-08-14 08:43:59	ऑस्ट्रिया
13	Azerbaijan	AZE	AZ	40.3834	49.8932	2023-08-14 08:43:59	आज़र‌बायजान‌
14	Burundi	BDI	BI	-3.3784	29.3639	2023-08-14 08:43:59	बुरुंडी
15	Belgium	BEL	BE	50.8371	4.36761	2023-08-14 08:43:59	बेल्जिय‌म‌
16	Benin	BEN	BJ	6.4779	2.6323	2023-08-14 08:43:59	बेनिन‌
17	Burkina Faso	BFA	BF	12.3605	-1.53395	2023-08-14 08:43:59	बुर्कीना फ़ासो
18	Bangladesh	BGD	BD	23.7055	90.4113	2023-08-14 08:43:59	बांग्लादेश
19	Bulgaria	BGR	BG	42.7105	23.3238	2023-08-14 08:43:59	बल्गारिया
20	Bahrain	BHR	BH	26.1921	50.5354	2023-08-14 08:43:59	बाहरैन
21	Bahamas, The	BHS	BS	25.0661	-77.339	2023-08-14 08:43:59	ब‌हामाज़
22	Bosnia and Herzegovina	BIH	BA	43.8607	18.4214	2023-08-14 08:43:59	बोस‌निया और‌ ह‌र्ज़ेगोविना
23	Belarus	BLR	BY	53.9678	27.5766	2023-08-14 08:43:59	बेलारूस‌
24	Belize	BLZ	BZ	17.2534	-88.7713	2023-08-14 08:43:59	बेलीज़
25	Bermuda	BMU	BM	32.3293	-64.706	2023-08-14 08:43:59	ब‌र‌मुडा
26	Bolivia	BOL	BO	-13.9908	-66.1936	2023-08-14 08:43:59	बोलिविया
27	Brazil	BRA	BR	-15.7801	-47.9292	2023-08-14 08:43:59	ब्राज़ील
28	Barbados	BRB	BB	13.0935	-59.6105	2023-08-14 08:43:59	बारबेडॉस
29	Brunei Darussalam	BRN	BN	4.94199	114.946	2023-08-14 08:43:59	ब्रूनई दारुस्सलाम‌
30	Bhutan	BTN	BT	27.5768	89.6177	2023-08-14 08:43:59	भूटान‌
31	Botswana	BWA	BW	-24.6544	25.9201	2023-08-14 08:43:59	बोत्स्वाना
32	Central African Republic	CAF	CF	5.63056	21.6407	2023-08-14 08:43:59	मध्य अफ़्रीकी गणराज्य
33	Canada	CAN	CA	45.4215	-75.6919	2023-08-14 08:43:59	कैनेडा
34	Switzerland	CHE	CH	46.948	7.44821	2023-08-14 08:43:59	स्विट्ज़र‌लैंड‌
35	Chile	CHL	CL	-33.475	-70.6475	2023-08-14 08:43:59	चिली
36	China	CHN	CN	40.0495	116.286	2023-08-14 08:43:59	चीन‌
37	Cote d'Ivoire	CIV	CI	5.332	-4.0305	2023-08-14 08:43:59	कोत द’ईवोआर
38	Cameroon	CMR	CM	3.8721	11.5174	2023-08-14 08:43:59	कैम‌रून‌
39	Congo, Dem. Rep.	COD	CD	-4.325	15.3222	2023-08-14 08:43:59	कांगो, लोक‌तांत्रिक‌ ग‌ण‌राज्य‌
40	Congo, Rep.	COG	CG	-4.2767	15.2662	2023-08-14 08:43:59	कांगो, ग‌ण‌राज्य
41	Colombia	COL	CO	4.60987	-74.082	2023-08-14 08:43:59	कोलंबिया
42	Comoros	COM	KM	-11.6986	43.2418	2023-08-14 08:43:59	कोमोरोस‌
43	Cabo Verde	CPV	CV	14.9218	-23.5087	2023-08-14 08:43:59	केप वर्दे
44	Costa Rica	CRI	CR	9.63701	-84.0089	2023-08-14 08:43:59	कोस्टारीका
45	Cuba	CUB	CU	23.1333	-82.3667	2023-08-14 08:43:59	क्यूबा
46	Cayman Islands	CYM	KY	19.3022	-81.3857	2023-08-14 08:43:59	केमैन‌ द्वीप‌
47	Cyprus	CYP	CY	35.1676	33.3736	2023-08-14 08:43:59	साइप्रस‌
48	Czech Republic	CZE	CZ	50.0878	14.4205	2023-08-14 08:43:59	चेक‌ ग‌ण‌राज्य‌
49	Germany	DEU	DE	52.5235	13.4115	2023-08-14 08:43:59	ज‌र्म‌नी
50	Djibouti	DJI	DJ	11.5806	43.1425	2023-08-14 08:43:59	जिबूती
51	Dominica	DMA	DM	15.2976	-61.39	2023-08-14 08:43:59	डोमिनिका
52	Denmark	DNK	DK	55.6763	12.5681	2023-08-14 08:43:59	डेन‌मार्क‌
53	Dominican Republic	DOM	DO	18.479	-69.8908	2023-08-14 08:43:59	डोमिनिक‌न‌ ग‌ण‌राज्य‌
54	Algeria	DZA	DZ	36.7397	3.05097	2023-08-14 08:43:59	अल्जीरिया
55	Ecuador	ECU	EC	-0.229498	-78.5243	2023-08-14 08:43:59	इक्वादोर‌
56	Egypt, Arab Rep.	EGY	EG	30.0982	31.2461	2023-08-14 08:43:59	ज़म्हूरियत मिस्र अल अरबिया
57	Eritrea	ERI	ER	15.3315	38.9183	2023-08-14 08:43:59	एरिट्रिया
58	Spain	ESP	ES	40.4167	-3.70327	2023-08-14 08:43:59	स्पेन‌
59	Estonia	EST	EE	59.4392	24.7586	2023-08-14 08:43:59	एस्टोनिया
60	Ethiopia	ETH	ET	9.02274	38.7468	2023-08-14 08:43:59	ईथियोपिया
61	Finland	FIN	FI	60.1608	24.9525	2023-08-14 08:43:59	फ़िन‌लैंड‌
62	Fiji	FJI	FJ	-18.1149	178.399	2023-08-14 08:43:59	फ़ीजी
63	France	FRA	FR	48.8566	2.35097	2023-08-14 08:43:59	फ़्राँस
64	Faroe Islands	FRO	FO	61.8926	-6.91181	2023-08-14 08:43:59	फ़ारोअ द्वीप‌
65	Micronesia, Fed. Sts.	FSM	FM	6.91771	158.185	2023-08-14 08:43:59	संघीकृत राज्य माइक्रोनेशिया
66	Gabon	GAB	GA	0.38832	9.45162	2023-08-14 08:43:59	गाबों
67	United Kingdom	GBR	GB	51.5002	-0.126236	2023-08-14 08:43:59	ब्रिटेन‌
68	Georgia	GEO	GE	41.71	44.793	2023-08-14 08:43:59	जॉर्जिया
69	Ghana	GHA	GH	5.57045	-0.20795	2023-08-14 08:43:59	गाना
70	Guinea	GIN	GN	9.51667	-13.7	2023-08-14 08:43:59	गिनी
71	Gambia, The	GMB	GM	13.4495	-16.5885	2023-08-14 08:43:59	गाम्बिया
144	Nauru	NRU	NR	-0.5477	166.920867	2023-08-14 08:43:59	नाउरू
72	Guinea-Bissau	GNB	GW	11.8037	-15.1804	2023-08-14 08:43:59	गिनी बीसो
73	Equatorial Guinea	GNQ	GQ	3.7523	8.7741	2023-08-14 08:43:59	इक्वटोरियल गिनी
74	Greece	GRC	GR	37.9792	23.7166	2023-08-14 08:43:59	यूनान
75	Grenada	GRD	GD	12.0653	-61.7449	2023-08-14 08:43:59	ग्रेनाडा
76	Greenland	GRL	GL	64.1836	-51.7214	2023-08-14 08:43:59	ग्रीन‌लैंड‌
77	Guatemala	GTM	GT	14.6248	-90.5328	2023-08-14 08:43:59	ग्वातेमाला
78	Guam	GUM	GU	13.4443	144.794	2023-08-14 08:43:59	ग्वाम
79	Guyana	GUY	GY	6.80461	-58.1548	2023-08-14 08:43:59	ग‌याना
80	Hong Kong SAR, China	HKG	HK	22.3964	114.109	2023-08-14 08:43:59	हॉङ्कॉङ विशेष प्रशासनिक क्षेत्र चीन‌
81	Honduras	HND	HN	15.1333	-87.4667	2023-08-14 08:43:59	होंदूरास‌
82	Croatia	HRV	HR	45.8069	15.9614	2023-08-14 08:43:59	क्रोएशिया
83	Haiti	HTI	HT	18.5392	-72.3288	2023-08-14 08:43:59	हाईती
84	Hungary	HUN	HU	47.4984	19.0408	2023-08-14 08:43:59	हंग‌री
85	Indonesia	IDN	ID	-6.19752	106.83	2023-08-14 08:43:59	इंडोनेशिया
86	Isle of Man	IMN	IM	54.1509	-4.47928	2023-08-14 08:43:59	आइल ऑफ़ मैन
87	India	IND	IN	28.6353	77.225	2023-08-14 08:43:59	भार‌त‌
88	Ireland	IRL	IE	53.3441	-6.26749	2023-08-14 08:43:59	आय‌र‌लैंड‌
89	Iran, Islamic Rep.	IRN	IR	35.6878	51.4447	2023-08-14 08:43:59	ईरान इस्लामी गणराज्य
90	Iraq	IRQ	IQ	33.3302	44.394	2023-08-14 08:43:59	इराक‌
91	Iceland	ISL	IS	64.1353	-21.8952	2023-08-14 08:43:59	आइस‌लैंड‌
92	Israel	ISR	IL	31.7717	35.2035	2023-08-14 08:43:59	इस्राईल‌
93	Italy	ITA	IT	41.8955	12.4823	2023-08-14 08:43:59	इट‌ली
94	Jamaica	JAM	JM	17.9927	-76.792	2023-08-14 08:43:59	जमाइका
95	Jordan	JOR	JO	31.9497	35.9263	2023-08-14 08:43:59	जोर्ड‌न‌
96	Japan	JPN	JP	35.67	139.77	2023-08-14 08:43:59	जापान‌
97	Kazakhstan	KAZ	KZ	51.1879	71.4382	2023-08-14 08:43:59	क‌ज़ाक‌स्तान‌
98	Kenya	KEN	KE	-1.27975	36.8126	2023-08-14 08:43:59	कीनिया
99	Kyrgyz Republic	KGZ	KG	42.8851	74.6057	2023-08-14 08:43:59	का हिंदी में मतलब
100	Cambodia	KHM	KH	11.5556	104.874	2023-08-14 08:43:59	कंबोडिया
101	Kiribati	KIR	KI	1.32905	172.979	2023-08-14 08:43:59	किरिबास
102	St. Kitts and Nevis	KNA	KN	17.3	-62.7309	2023-08-14 08:43:59	सेंट किट्स एंड नेविस
103	Korea, Rep.	KOR	KR	37.5323	126.957	2023-08-14 08:43:59	दक्षिण कोरिया
104	Kuwait	KWT	KW	29.3721	47.9824	2023-08-14 08:43:59	कुवैत‌
105	Lao PDR	LAO	LA	18.5826	102.177	2023-08-14 08:43:59	लाओ पीपुल्स डेमोक्रेटिक रिपब्लिक
106	Lebanon	LBN	LB	33.8872	35.5134	2023-08-14 08:43:59	लेब‌नान‌
107	Liberia	LBR	LR	6.30039	-10.7957	2023-08-14 08:43:59	लाइबीरिया
108	Libya	LBY	LY	32.8578	13.1072	2023-08-14 08:43:59	लीबिया
109	St. Lucia	LCA	LC	14	-60.9832	2023-08-14 08:43:59	सेण्ट लूसिया
110	Liechtenstein	LIE	LI	47.1411	9.52148	2023-08-14 08:43:59	लीक्टेनस्टाइन
111	Sri Lanka	LKA	LK	6.92148	79.8528	2023-08-14 08:43:59	श्रीलंका
112	Lesotho	LSO	LS	-29.5208	27.7167	2023-08-14 08:43:59	लेसुटू
113	Lithuania	LTU	LT	54.6896	25.2799	2023-08-14 08:43:59	लिथुआनिया
114	Luxembourg	LUX	LU	49.61	6.1296	2023-08-14 08:43:59	ल‌ग्ज़मबर्ग‌
115	Latvia	LVA	LV	56.9465	24.1048	2023-08-14 08:43:59	लातविया
116	Macao SAR, China	MAC	MO	22.1667	113.55	2023-08-14 08:43:59	जनवादी गणराज्य चीन का मकाउ विशेष प्रशासनिक क्षेत्र
117	Morocco	MAR	MA	33.9905	-6.8704	2023-08-14 08:43:59	मोर‌क्को
118	Monaco	MCO	MC	43.7325	7.41891	2023-08-14 08:43:59	मोनाको
119	Moldova	MDA	MD	47.0167	28.8497	2023-08-14 08:43:59	मोल‌डोवा
120	Madagascar	MDG	MG	-20.4667	45.7167	2023-08-14 08:43:59	मैडागास्क‌र‌
121	Maldives	MDV	MV	4.1742	73.5109	2023-08-14 08:43:59	माल‌दीव‌
122	Mexico	MEX	MX	19.427	-99.1276	2023-08-14 08:43:59	मेक्सिको
123	Marshall Islands	MHL	MH	7.11046	171.135	2023-08-14 08:43:59	मार्श‌ल‌ द्वीप‌
124	North Macedonia	MKD	MK	42.0024	21.4361	2023-08-14 08:43:59	उत्तर मैसिडोनिया
125	Mali	MLI	ML	13.5667	-7.50034	2023-08-14 08:43:59	माली
126	Malta	MLT	MT	35.9042	14.5189	2023-08-14 08:43:59	माल्टा
127	Myanmar	MMR	MM	21.914	95.9562	2023-08-14 08:43:59	म्यांमार‌
128	Montenegro	MNE	ME	42.4602	19.2595	2023-08-14 08:43:59	मॉन्टेंगरो
129	Mongolia	MNG	MN	47.9129	106.937	2023-08-14 08:43:59	मंगोलिया
130	Northern Mariana Islands	MNP	MP	15.1935	145.765	2023-08-14 08:43:59	उत्त‌री मारिआना द्वीप‌
131	Mozambique	MOZ	MZ	-25.9664	32.5713	2023-08-14 08:43:59	मोजा़म्बीक‌
132	Mauritania	MRT	MR	18.2367	-15.9824	2023-08-14 08:43:59	मोरीतानिया
133	Mauritius	MUS	MU	-20.1605	57.4977	2023-08-14 08:43:59	मोरिशिय‌स‌
134	Malawi	MWI	MW	-13.9899	33.7703	2023-08-14 08:43:59	म‌लावी
135	Malaysia	MYS	MY	3.12433	101.684	2023-08-14 08:43:59	मलेशिया
136	Namibia	NAM	NA	-22.5648	17.0931	2023-08-14 08:43:59	नामीबिया
137	New Caledonia	NCL	NC	-22.2677	166.464	2023-08-14 08:43:59	न्यू कैलडोनिया
138	Niger	NER	NE	13.514	2.1073	2023-08-14 08:43:59	नीजेर
139	Nigeria	NGA	NG	9.05804	7.48906	2023-08-14 08:43:59	नाइजीरिया
140	Nicaragua	NIC	NI	12.1475	-86.2734	2023-08-14 08:43:59	नीकाराग्वा
141	Netherlands	NLD	NL	52.3738	4.89095	2023-08-14 08:43:59	नेद‌र‌लैंड‌
142	Norway	NOR	NO	59.9138	10.7387	2023-08-14 08:43:59	नॉर्वे
143	Nepal	NPL	NP	27.6939	85.3157	2023-08-14 08:43:59	नेपाल‌
145	New Zealand	NZL	NZ	-41.2865	174.776	2023-08-14 08:43:59	न्यूज़ीलैंड‌
146	Oman	OMN	OM	23.6105	58.5874	2023-08-14 08:43:59	ओमान‌
147	Pakistan	PAK	PK	30.5167	72.8	2023-08-14 08:43:59	पाकिस्तान‌
148	Panama	PAN	PA	8.99427	-79.5188	2023-08-14 08:43:59	पानामा
149	Peru	PER	PE	-12.0931	-77.0465	2023-08-14 08:43:59	पेरू
150	Philippines	PHL	PH	14.5515	121.035	2023-08-14 08:43:59	फ़िलीपीन‌
151	Palau	PLW	PW	7.34194	134.479	2023-08-14 08:43:59	पालाऊ
152	Papua New Guinea	PNG	PG	-9.47357	147.194	2023-08-14 08:43:59	पापुआ न्यू गिनी
153	Poland	POL	PL	52.26	21.02	2023-08-14 08:43:59	पोलैंड‌
154	Puerto Rico	PRI	PR	18.23	-66	2023-08-14 08:43:59	प्वेर्तो रीको
155	Korea, Dem. People’s Rep.	PRK	KP	39.0319	125.754	2023-08-14 08:43:59	कोरिया जनवादी लोकतान्त्रिक गणराज्य
156	Portugal	PRT	PT	38.7072	-9.13552	2023-08-14 08:43:59	पुर्त‌गाल‌
157	Paraguay	PRY	PY	-25.3005	-57.6362	2023-08-14 08:43:59	पाराग्वे
158	French Polynesia	PYF	PF	-17.535	-149.57	2023-08-14 08:43:59	फ़्राँसीसी पॉलिनेशिया
159	Qatar	QAT	QA	25.2948	51.5082	2023-08-14 08:43:59	क‌त‌र‌
160	Romania	ROU	RO	44.4479	26.0979	2023-08-14 08:43:59	रुमानिया
161	Russian Federation	RUS	RU	55.7558	37.6176	2023-08-14 08:43:59	रूसी संघ‌
162	Rwanda	RWA	RW	-1.95325	30.0587	2023-08-14 08:43:59	रवांडा
163	Saudi Arabia	SAU	SA	24.6748	46.6977	2023-08-14 08:43:59	स‌ऊदी अर‌ब‌
164	Sudan	SDN	SD	15.5932	32.5363	2023-08-14 08:43:59	सुदान
165	Senegal	SEN	SN	14.7247	-17.4734	2023-08-14 08:43:59	सेनेग‌ाल‌
166	Singapore	SGP	SG	1.28941	103.85	2023-08-14 08:43:59	सिंगापुर‌
167	Solomon Islands	SLB	SB	-9.42676	159.949	2023-08-14 08:43:59	सोलोम‌न‌ द्वीप‌
168	Sierra Leone	SLE	SL	8.4821	-13.2134	2023-08-14 08:43:59	सियेरा लियोन‌
169	El Salvador	SLV	SV	13.7034	-89.2073	2023-08-14 08:43:59	एल‌ साल्वादोर
170	San Marino	SMR	SM	43.9322	12.4486	2023-08-14 08:43:59	सान‌ मारीनो
171	Somalia	SOM	SO	2.07515	45.3254	2023-08-14 08:43:59	सोमालिया
172	Serbia	SRB	RS	44.8024	20.4656	2023-08-14 08:43:59	सर्बिया
173	South Sudan	SSD	SS	4.85	31.6	2023-08-14 08:43:59	दक्षिण सूडान
174	Sao Tome and Principe	STP	ST	0.20618	6.6071	2023-08-14 08:43:59	सांव तोमे और‌ प्रीनसीप
175	Suriname	SUR	SR	5.8232	-55.1679	2023-08-14 08:43:59	सूरीनाम‌
176	Slovak Republic	SVK	SK	48.1484	17.1073	2023-08-14 08:43:59	स्लोवाक गणराज्य
177	Slovenia	SVN	SI	46.0546	14.5044	2023-08-14 08:43:59	स्लोवेनिया
178	Sweden	SWE	SE	59.3327	18.0645	2023-08-14 08:43:59	स्वीड‌न‌
179	Eswatini	SWZ	SZ	-26.5225	31.4659	2023-08-14 08:43:59	एस्वातीनी
180	Seychelles	SYC	SC	-4.6309	55.4466	2023-08-14 08:43:59	सेशेल्स‌
181	Syrian Arab Republic	SYR	SY	33.5146	36.3119	2023-08-14 08:43:59	सीरियाई अर‌ब‌ ग‌ण‌राज्य‌
182	Turks and Caicos Islands	TCA	TC	21.4602778	-71.141389	2023-08-14 08:43:59	तुर्क‌ और‌ केकोस‌ द्वीप‌
183	Chad	TCD	TD	12.1048	15.0445	2023-08-14 08:43:59	चाड‌
184	Togo	TGO	TG	6.1228	1.2255	2023-08-14 08:43:59	टोगो
185	Thailand	THA	TH	13.7308	100.521	2023-08-14 08:43:59	थाईलैंड‌
186	Tajikistan	TJK	TJ	38.5878	68.7864	2023-08-14 08:43:59	ताजीकिस्तान‌
187	Turkmenistan	TKM	TM	37.9509	58.3794	2023-08-14 08:43:59	तुर्क‌मेनिस्तान‌
188	Timor-Leste	TLS	TL	-8.56667	125.567	2023-08-14 08:43:59	तीमोर‌-लेस्त‌
189	Tonga	TON	TO	-21.136	-175.216	2023-08-14 08:43:59	टोंगा
190	Trinidad and Tobago	TTO	TT	10.6596	-61.4789	2023-08-14 08:43:59	ट्रिनिडाड‌ और‌ टोबोगो
191	Tunisia	TUN	TN	36.7899	10.21	2023-08-14 08:43:59	ट्यूनीशिया
192	Turkey	TUR	TR	39.7153	32.3606	2023-08-14 08:43:59	तुर्की
193	Tuvalu	TUV	TV	-8.6314877	179.089567	2023-08-14 08:43:59	तुवालू
194	Tanzania	TZA	TZ	-6.17486	35.7382	2023-08-14 08:43:59	तांज़ानिया, संयुक्त‌ ग‌ण‌राज्य‌
195	Uganda	UGA	UG	0.314269	32.5729	2023-08-14 08:43:59	युगांडा
196	Ukraine	UKR	UA	50.4536	30.5038	2023-08-14 08:43:59	यूक्रेन‌
197	Uruguay	URY	UY	-34.8941	-56.0675	2023-08-14 08:43:59	उरुग्वाय
198	United States	USA	US	38.8895	-77.032	2023-08-14 08:43:59	संयुक्त‌ राज्य‌ अम‌रीका
199	Uzbekistan	UZB	UZ	41.3052	69.269	2023-08-14 08:43:59	उज़्बेकिस्तान‌
200	St. Vincent and the Grenadines	VCT	VC	13.2035	-61.2653	2023-08-14 08:43:59	सेंट विंसेंट एवं ग्रेनाडींस
201	Venezuela, RB	VEN	VE	9.08165	-69.8371	2023-08-14 08:43:59	वेनेजुएला के बोलीवियाई गणराज्य
202	British Virgin Islands	VGB	VG	18.431389	-64.623056	2023-08-14 08:43:59	ब्रिटिश वर्जिन द्वीपसमूह
203	Virgin Islands (U.S.)	VIR	VI	18.3358	-64.8963	2023-08-14 08:43:59	का हिन्दी अर्थ. प्रायोजित कड़ी 
204	Vietnam	VNM	VN	21.0069	105.825	2023-08-14 08:43:59	विय‌त‌नाम‌
205	Vanuatu	VUT	VU	-17.7404	168.321	2023-08-14 08:43:59	वानुआतु
206	Samoa	WSM	WS	-13.8314	-171.752	2023-08-14 08:43:59	सैमोआ
207	Kosovo	XKX	XK	42.565	20.926	2023-08-14 08:43:59	कोसोवो
208	Yemen, Rep.	YEM	YE	15.352	44.2075	2023-08-14 08:43:59	यमन गणराज्य
209	South Africa	ZAF	ZA	-25.746	28.1871	2023-08-14 08:43:59	द‌क्षिण‌ अफ़्रीका
210	Zambia	ZMB	ZM	-15.3982	28.2937	2023-08-14 08:43:59	ज़ाम्बीया
211	Zimbabwe	ZWE	ZW	-17.8312	31.0672	2023-08-14 08:43:59	ज़िम्बाब्व
212	Reunion	REU	RE	-21.1306889	55.5264794	2023-08-14 08:43:59	रीयूनिय‌न‌
213	French Guyana	GUF	GF	3.9332383	-53.0875742	2023-08-14 08:43:59	फ्रांसीसी गुयाना या फ़्रेंच गयाना
214	Taiwan	TWN	TW	23.553118	121.0211024	2023-08-14 08:43:59	ताइवान चीनी गणराज्य
215	Vatican City	VAT	VA	41.9038795	12.4520834	2023-08-14 08:43:59	वेटिकन शहर राज्य
216	Christmas Island	CXR	CX	-10.4912311	105.6229817	2023-08-14 08:43:59	क्रिस‌म‌स‌ द्वीप‌
217	Cocos (Keeling) Islands	CCK	CC	-12.1708739	96.8417393	2023-08-14 08:43:59	कोकोस (कीलिंग‌) द्वीप‌
218	Guadeloupe	GLP	GP	16.1730949	-61.4054001	2023-08-14 08:43:59	ग्वादलूप‌
219	Martinique	MTQ	MQ	14.6336817	-61.0198104	2023-08-14 08:43:59	मार्टीनीक‌
220	Mayotte	MYT	YT	-12.8210325	45.1590997	2023-08-14 08:43:59	मायोत‌
221	Norfolk Island	NFK	NF	-29.0328267	167.9543925	2023-08-14 08:43:59	नॉर‌फ़ोक‌ द्वीप‌
222	Saint Helena	SHN	SH	-15.9655282	-5.7114846	2023-08-14 08:43:59	सेंट हेलेना
223	St. Barthelemy	BLM	BL	17.9139222	-62.8338521	2023-08-14 08:43:59	सेंट बार्थेलेमी
224	World	WWW	\N	34.476624	-40.896274	2023-08-14 08:43:59	दुनिया
225	Asia	ABB	\N	34.047863	100.619652	2023-08-14 08:43:59	एशिया
226	Europe	EEE	\N	54.525963	15.255119	2023-08-14 08:43:59	यूरोप
227	Africa	FFF	\N	-8.783195	34.508522	2023-08-14 08:43:59	अफ़्रीका
228	North America	NNN	\N	48.922499	-101.733095	2023-08-14 08:43:59	उत्तरी अमेरिका
229	South America	SRR	\N	-10.487812	-60.221021	2023-08-14 08:43:59	दक्षिण अमेरिका
230	Oceania	UUU	\N	-29.630426	155.722393	2023-08-14 08:43:59	ओशिनिया
231	Palestine	PSE	PS	31.947351	35.227163	2023-08-14 08:43:59	फिलिस्तीन
232	Guernsey	GGY	GG	49.4630653	-2.5881123	2023-08-14 08:43:59	ग्वेर्नसे
233	Antarctica	ATA	AQ	-69.6354154	0	2023-08-14 08:43:59	अंटार्क‌टिका
234	Arctic	ARC	\N	66.5666644	0	2023-08-14 08:43:59	आर्कटिक
\.


--
-- Data for Name: disease; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.disease (id, disease, active, last_updated, hindi_translation, colour) FROM stdin;
2	other	1	2023-08-14 08:43:59	अन्य	#16c7e2
4	anthrax/gastrointestinal	1	2023-08-14 08:43:59	गैस्ट्रोइंटेस्टाइनल एंथ्रेक्स	#2c57a0
5	anthrax/inhalation	1	2023-08-14 08:43:59	इनहेलेशनल एंथ्रेक्स	#4859c4
6	botulism	1	2023-08-14 08:43:59	बोटुलिज़्म	#1602cc
7	brucellosis	1	2023-08-14 08:43:59	ब्रूसलोसिस	#621af2
8	chikungunya	1	2023-08-14 08:43:59	चिकनगुनिया	#601d91
9	cholera	1	2023-08-14 08:43:59	हैज़ा	#c040dd
10	covid19	1	2023-08-14 08:43:59	कोविड 19	#ea59e0
14	dengue	1	2023-08-14 08:43:59	डेंगू	#d1413e
16	ebola haemorrhagic fever	1	2023-08-14 08:43:59	इबोला रक्तस्रावी बुखार	#f28807
29	hepatitis a	1	2023-08-14 08:43:59	हेपेटाइटिस ए	#457cd3
30	hepatitis b	1	2023-08-14 08:43:59	हेपेटाइटिस बी	#6479ef
35	hiv/aids	1	2023-08-14 08:43:59	एचआईवी/एड्स	#f96bf2
36	lassa fever	1	2023-08-14 08:43:59	लस्सा बुखार	#c60d92
37	malaria	1	2023-08-14 08:43:59	मलेरिया	#db257d
38	marburg virus disease	1	2023-08-14 08:43:59	मारबर्ग वायरस की बीमारी रोग	#d8385d
39	measles	1	2023-08-14 08:43:59	खसरा	#ef5953
40	MERS	1	2023-08-14 08:43:59	एम ई आर एस	#cc7459
42	nipah virus	1	2023-08-14 08:43:59	निपाह वायरस	#d39f26
44	pertussis	1	2023-08-14 08:43:59	काली खांसी	#d2f759
45	plague	1	2023-08-14 08:43:59	प्लेग	#a5d660
47	poliomyelitis	1	2023-08-14 08:43:59	पोलियो	#35ce27
48	q fever	1	2023-08-14 08:43:59	क्यू बुखार	#41ea5b
49	rabies	1	2023-08-14 08:43:59	रेबीज	#5cf9a3
51	rotavirus infection	1	2023-08-14 08:43:59	रोटावायरस संक्रमण	#11ad9b
52	rubella	1	2023-08-14 08:43:59	रूबेला	#26b2c1
53	salmonellosis	1	2023-08-14 08:43:59	साल्मोनेलोसिस	#42ace5
55	shigellosis	1	2023-08-14 08:43:59	शिगेलोसिस	#02197f
56	smallpox	1	2023-08-14 08:43:59	चेचक	#1c12a8
58	typhoid fever	1	2023-08-14 08:43:59	टाइफाइड टाइफायड बुखार	#a147ef
59	tuberculosis	1	2023-08-14 08:43:59	क्षय रोग	#bc54d8
60	tularemia	1	2023-08-14 08:43:59	टुलरेमिया	#ce06c7
63	west nile virus	1	2023-08-14 08:43:59	वेस्ट नील वायरस	#f94d7b
64	yellow fever	1	2023-08-14 08:43:59	पीला बुखार	#db57ba
67	legionnaires	1	2023-08-14 08:43:59	लीजियोनेयर्स	#efc137
69	monkeypox	1	2023-08-14 08:43:59	मंकीपॉक्स	#c1d858
71	influenza	1	2023-08-14 08:43:59	इंफ्लुएंजा	#5cd81e
73	avian influenza/unspecified	1	2023-08-14 08:43:59	अनिर्दिष्ट एवियन इन्फ्लूएंजा	#41c651
80	E Coli	1	2023-08-14 08:43:59	ई कोलाई	#0d30bf
82	Staphylococcus	1	2023-08-14 08:43:59	स्टैफिलोकोकस	#492591
86	leptospirosis	1	2023-08-14 08:43:59	लेप्टोस्पायरोसिस	#f72ac4
91	Ross River Fever	1	2023-08-14 08:43:59	रॉस नदी रिवर बुखार	#fc8a2d
93	Syphilis	1	2023-08-14 08:43:59	सिफलिस	#e8d955
94	respiratory syncytial virus	1	2023-08-14 08:43:59	रेस्पिरेटरी सिंकाइटियल वायरस	#a7c401
96	Tetanus	1	2023-08-14 08:43:59	टेटनस	#4fa31f
98	Melioidosis	1	2023-08-14 08:43:59	मेलियोइडोसिस	#56e264
101	campylobacteriosis	1	2023-08-14 08:43:59	कम्प्य्लोबक्तेरिओसिस	#22ad93
104	Scrub typhus	1	2023-08-14 08:43:59	स्क्रब टाइफस	#0665d8
120	Japanese Encephalitis	1	2023-08-14 08:43:59	जापानी मस्तिष्ककोप	#6fa518
125	Kyasanur forest disease	1	2023-08-14 08:43:59	कयासनूर वन रोग	#1cb271
126	Streptococcus suis	1	2023-08-14 08:43:59	स्ट्रेप्टोकोकस सूइस	#35d6b8
131	meningococcal	1	2023-08-14 08:43:59	मेनिंगोकोकल	#3333c6
132	Murray Valley Encephalitis	1	2023-08-14 08:43:59	मरे घाटी इंसेफेलाइटिस	#7752e5
143	gonorrhea	1	2023-08-14 08:43:59	गोनोरिया	#c9af04
146	buruli ulcer	1	2023-08-14 08:43:59	बुरुली अल्सर	#82ef47
1	unknown	1	2023-08-14 08:43:59	अनजान	#6aede0
3	anthrax/cutaneous	1	2023-08-14 08:43:59	त्वचीय एंथ्रेक्स	#164c75
12	cryptosporidiosis	1	2023-08-14 08:43:59	क्रिप्टोस्पोरिडियोसिस	#fc1e82
46	pneumococcus pneumonia	1	2023-08-14 08:43:59	न्यूमोकोकस निमोनिया	#40a30e
79	anthrax/unspecified	1	2023-08-14 08:43:59	अनिर्दिष्ट एंथ्रेक्स	#5586c6
177	Group A Streptococcus	1	2023-08-14 08:43:59	ग्रुप ए स्ट्रेप्टोकोकस	#5ed1d1
188	Paratyphoid fever	1	2023-08-14 08:43:59	पैराटाइफाइड बुखार	#ea1962
211	mycoplasma pneumoniae	1	2023-11-23 15:12:42	\N	#f469df
\.


--
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.regions (id, region, iso3) FROM stdin;
0	Africa	DZA
1	Africa	EGY
2	Africa	LBY
3	Africa	MAR
4	Africa	SDN
5	Africa	TUN
6	Africa	ESH
7	Africa	IOT
8	Africa	BDI
9	Africa	COM
10	Africa	DJI
11	Africa	ERI
12	Africa	ETH
13	Africa	ATF
14	Africa	KEN
15	Africa	MDG
16	Africa	MWI
17	Africa	MUS
18	Africa	MYT
19	Africa	MOZ
20	Africa	REU
21	Africa	RWA
22	Africa	SYC
23	Africa	SOM
24	Africa	SSD
25	Africa	UGA
26	Africa	TZA
27	Africa	ZMB
28	Africa	ZWE
29	Africa	AGO
30	Africa	CMR
31	Africa	CAF
32	Africa	TCD
33	Africa	COG
34	Africa	COD
35	Africa	GNQ
36	Africa	GAB
37	Africa	STP
38	Africa	BWA
39	Africa	SWZ
40	Africa	LSO
41	Africa	NAM
42	Africa	ZAF
43	Africa	BEN
44	Africa	BFA
45	Africa	CPV
46	Africa	CIV
47	Africa	GMB
48	Africa	GHA
49	Africa	GIN
50	Africa	GNB
51	Africa	LBR
52	Africa	MLI
53	Africa	MRT
54	Africa	NER
55	Africa	NGA
56	Africa	SHN
57	Africa	SEN
58	Africa	SLE
59	Africa	TGO
60	Americas	AIA
61	Americas	ATG
62	Americas	ABW
63	Americas	BHS
64	Americas	BRB
65	Americas	BES
66	Americas	VGB
67	Americas	CYM
68	Americas	CUB
69	Americas	CUW
70	Americas	DMA
71	Americas	DOM
72	Americas	GRD
73	Americas	GLP
74	Americas	HTI
75	Americas	JAM
76	Americas	MTQ
77	Americas	MSR
78	Americas	PRI
79	Americas	BLM
80	Americas	KNA
81	Americas	LCA
82	Americas	MAF
83	Americas	VCT
84	Americas	SXM
85	Americas	TTO
86	Americas	TCA
87	Americas	VIR
88	Americas	BLZ
89	Americas	CRI
90	Americas	SLV
91	Americas	GTM
92	Americas	HND
93	Americas	MEX
94	Americas	NIC
95	Americas	PAN
96	Americas	ARG
97	Americas	BOL
98	Americas	BVT
99	Americas	BRA
100	Americas	CHL
101	Americas	COL
102	Americas	ECU
103	Americas	FLK
104	Americas	GUF
105	Americas	GUY
106	Americas	PRY
107	Americas	PER
108	Americas	SGS
109	Americas	SUR
110	Americas	URY
111	Americas	VEN
112	Americas	BMU
113	Americas	CAN
114	Americas	GRL
115	Americas	SPM
116	Americas	USA
117	Asia	KAZ
118	Asia	KGZ
119	Asia	TJK
120	Asia	TKM
121	Asia	UZB
122	Asia	CHN
123	Asia	HKG
124	Asia	MAC
125	Asia	PRK
126	Asia	JPN
127	Asia	MNG
128	Asia	KOR
129	Asia	BRN
130	Asia	KHM
131	Asia	IDN
132	Asia	LAO
133	Asia	MYS
134	Asia	MMR
135	Asia	PHL
136	Asia	SGP
137	Asia	THA
138	Asia	TLS
139	Asia	VNM
140	Asia	AFG
141	Asia	BGD
142	Asia	BTN
143	Asia	IND
144	Asia	IRN
145	Asia	MDV
146	Asia	NPL
147	Asia	PAK
148	Asia	LKA
149	Asia	ARM
150	Asia	AZE
151	Asia	BHR
152	Asia	CYP
153	Asia	GEO
154	Asia	IRQ
155	Asia	ISR
156	Asia	JOR
157	Asia	KWT
158	Asia	LBN
159	Asia	OMN
160	Asia	QAT
161	Asia	SAU
162	Asia	PSE
163	Asia	SYR
164	Asia	TUR
165	Asia	ARE
166	Asia	YEM
167	Asia	TWN
168	Europe	BLR
169	Europe	BGR
170	Europe	CZE
171	Europe	HUN
172	Europe	POL
173	Europe	MDA
174	Europe	ROU
175	Europe	RUS
176	Europe	SVK
177	Europe	UKR
178	Europe	ALA
179	Europe	GGY
180	Europe	JEY
181	Europe	DNK
182	Europe	EST
183	Europe	FRO
184	Europe	FIN
185	Europe	ISL
186	Europe	IRL
187	Europe	IMN
188	Europe	LVA
189	Europe	LTU
190	Europe	NOR
191	Europe	SJM
192	Europe	SWE
193	Europe	GBR
194	Europe	ALB
195	Europe	AND
196	Europe	BIH
197	Europe	HRV
198	Europe	GIB
199	Europe	GRC
200	Europe	VAT
201	Europe	ITA
202	Europe	MLT
203	Europe	MNE
204	Europe	MKD
205	Europe	PRT
206	Europe	SMR
207	Europe	SRB
208	Europe	SVN
209	Europe	ESP
210	Europe	AUT
211	Europe	BEL
212	Europe	FRA
213	Europe	DEU
214	Europe	LIE
215	Europe	LUX
216	Europe	MCO
217	Europe	NLD
218	Europe	CHE
219	Oceania	AUS
220	Oceania	CXR
221	Oceania	CCK
222	Oceania	HMD
223	Oceania	NZL
224	Oceania	NFK
225	Oceania	FJI
226	Oceania	NCL
227	Oceania	PNG
228	Oceania	SLB
229	Oceania	VUT
230	Oceania	GUM
231	Oceania	KIR
232	Oceania	MHL
233	Oceania	FSM
234	Oceania	NRU
235	Oceania	MNP
236	Oceania	PLW
237	Oceania	UMI
238	Oceania	ASM
239	Oceania	COK
240	Oceania	PYF
241	Oceania	NIU
242	Oceania	PCN
243	Oceania	WSM
244	Oceania	TKL
245	Oceania	TON
246	Oceania	TUV
247	Oceania	WLF
248	Antarctica	ATA
249	Arctic	ARC
\.


--
-- Data for Name: report; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report (id, article_id, last_updated) FROM stdin;
162030	1112332	2023-09-01 11:24:24
162057	1113846	2023-09-02 08:04:51
162058	1113841	2023-09-02 08:05:09
162059	1113832	2023-09-02 08:06:04
162062	1113831	2023-09-02 08:06:19
162063	1113805	2023-09-02 11:01:33
162064	1113804	2023-09-02 11:02:10
162065	1113804	2023-09-02 11:02:10
162066	1113804	2023-09-02 11:02:10
162067	1113763	2023-09-02 11:02:27
162068	1113732	2023-09-02 11:03:02
162069	1113709	2023-09-02 11:04:11
162070	1113658	2023-09-02 11:05:36
162071	1113658	2023-09-02 11:05:36
162072	1113658	2023-09-02 11:05:36
162073	1113656	2023-09-02 11:07:01
162074	1113656	2023-09-02 11:07:01
162075	1113651	2023-09-02 11:11:25
162076	1113651	2023-09-02 11:11:25
162077	1113651	2023-09-02 11:11:25
162078	1113651	2023-09-02 11:11:25
162079	1113627	2023-09-02 11:11:34
162080	1113575	2023-09-02 11:12:16
162081	1113497	2023-09-02 11:13:18
162082	1113478	2023-09-02 11:13:24
162083	1113477	2023-09-02 11:13:33
162084	1113451	2023-09-02 11:13:38
162085	1113448	2023-09-02 11:13:42
162086	1113418	2023-09-02 11:14:09
162087	1113418	2023-09-02 11:14:09
162088	1113412	2023-09-02 11:15:04
162089	1113408	2023-09-02 11:15:31
162090	1113404	2023-09-02 11:15:56
162091	1113352	2023-09-02 11:18:30
162092	1113342	2023-09-02 11:25:35
162093	1113318	2023-09-02 11:26:47
162094	1113273	2023-09-02 11:27:06
162095	1113271	2023-09-02 11:27:21
162096	1113211	2023-09-02 11:27:38
162097	1113205	2023-09-02 11:28:19
162098	1113205	2023-09-02 11:28:19
162099	1113196	2023-09-02 11:28:41
162100	1113191	2023-09-02 11:28:54
162101	1113189	2023-09-02 11:29:15
162102	1113188	2023-09-02 11:29:24
162103	1113181	2023-09-02 11:30:05
162104	1113155	2023-09-02 11:33:15
162105	1113153	2023-09-02 11:33:35
162106	1113139	2023-09-02 12:24:28
162107	1113119	2023-09-02 12:26:59
162108	1113079	2023-09-02 12:27:18
162109	1113064	2023-09-02 12:27:36
162110	1113040	2023-09-02 12:28:49
162111	1113034	2023-09-02 12:29:04
162112	1112950	2023-09-02 12:31:44
162113	1112949	2023-09-02 12:33:48
162114	1112926	2023-09-02 12:34:12
162115	1112914	2023-09-02 12:35:16
162116	1112914	2023-09-02 12:35:16
162117	1112899	2023-09-02 12:38:03
162118	1112889	2023-09-02 12:38:15
162119	1112886	2023-09-02 12:38:28
162120	1112881	2023-09-02 12:38:45
162121	1112877	2023-09-02 12:39:25
162122	1112863	2023-09-02 12:39:34
162123	1112861	2023-09-02 12:40:18
162124	1112857	2023-09-02 12:40:30
162125	1112855	2023-09-02 12:40:50
162126	1112844	2023-09-02 12:42:19
162127	1112838	2023-09-02 12:42:50
162128	1112807	2023-09-02 12:42:56
162129	1112806	2023-09-02 12:43:10
162130	1112799	2023-09-02 12:45:19
162131	1112791	2023-09-02 12:45:28
162132	1112779	2023-09-02 12:45:57
162133	1112773	2023-09-02 12:46:21
162134	1112761	2023-09-02 12:46:26
162135	1112746	2023-09-02 12:46:58
162136	1112679	2023-09-02 12:47:15
162138	1112667	2023-09-02 12:55:02
162139	1112667	2023-09-02 12:55:02
162140	1112667	2023-09-02 12:57:35
162141	1112666	2023-09-02 12:58:41
162142	1112665	2023-09-02 12:58:45
162143	1112664	2023-09-02 12:58:48
162144	1112663	2023-09-02 12:58:51
162145	1112644	2023-09-02 13:00:31
162146	1112617	2023-09-02 13:03:01
162147	1112609	2023-09-02 13:03:31
162148	1112609	2023-09-02 13:03:31
162149	1112608	2023-09-02 13:03:45
162150	1112606	2023-09-02 13:04:01
162151	1112605	2023-09-02 13:04:17
162152	1112568	2023-09-02 13:05:10
162153	1112545	2023-09-02 13:07:48
162154	1112543	2023-09-02 13:08:09
162155	1112543	2023-09-02 13:08:09
162156	1112543	2023-09-02 13:08:09
162157	1112530	2023-09-02 13:08:42
162158	1112530	2023-09-02 13:08:42
162159	1112529	2023-09-02 13:09:13
162160	1112526	2023-09-02 13:09:29
162161	1112508	2023-09-02 13:09:36
162162	1112501	2023-09-02 13:09:51
162163	1112482	2023-09-02 13:19:31
162164	1112479	2023-09-02 13:19:44
162165	1112467	2023-09-02 13:20:34
162166	1112458	2023-09-02 13:20:41
162167	1112450	2023-09-02 13:20:48
162168	1112435	2023-09-02 13:21:02
162169	1112412	2023-09-02 13:21:18
162170	1112406	2023-09-02 13:23:08
162171	1112406	2023-09-02 13:23:08
162172	1112362	2023-09-02 13:23:20
162173	1112358	2023-09-02 13:24:10
162175	1113854	2023-09-02 13:26:03
162176	1113854	2023-09-02 13:26:03
162177	1113828	2023-09-02 13:30:57
162178	1113827	2023-09-02 13:31:30
162179	1113806	2023-09-02 13:40:46
162180	1113788	2023-09-02 13:41:12
162181	1113787	2023-09-02 13:43:02
162182	1113771	2023-09-02 13:43:23
162185	1113724	2023-09-02 13:44:24
162186	1113723	2023-09-02 13:57:39
162187	1113712	2023-09-02 14:05:50
162188	1113712	2023-09-02 14:05:50
162189	1113712	2023-09-02 14:05:50
162190	1113712	2023-09-02 14:05:50
162191	1113712	2023-09-02 14:05:50
162192	1113712	2023-09-02 14:05:50
162193	1113712	2023-09-02 14:05:50
162194	1113712	2023-09-02 14:05:50
162195	1113712	2023-09-02 14:05:50
162196	1113712	2023-09-02 14:05:50
162197	1113712	2023-09-02 14:05:50
162198	1113701	2023-09-02 14:06:21
162200	1113691	2023-09-02 14:07:14
162201	1113625	2023-09-02 14:18:11
162202	1113620	2023-09-02 14:18:26
162203	1113598	2023-09-02 14:19:07
162204	1113596	2023-09-02 14:19:18
162208	1113535	2023-09-02 14:23:53
162209	1113498	2023-09-02 14:24:17
162210	1113498	2023-09-02 14:24:17
162211	1113498	2023-09-02 14:24:17
162212	1113474	2023-09-02 14:25:02
162213	1113461	2023-09-02 14:25:17
162214	1113450	2023-09-02 14:26:13
162215	1113406	2023-09-02 14:27:33
162216	1113403	2023-09-02 14:28:19
162217	1113372	2023-09-02 14:54:56
162218	1113341	2023-09-02 14:56:03
162219	1113306	2023-09-11 09:09:48
162220	1113291	2023-09-02 15:05:45
162221	1113290	2023-09-02 15:07:50
162222	1113283	2023-09-02 15:08:16
162223	1113282	2023-09-02 15:09:16
162226	1113236	2023-09-02 15:15:20
162227	1113230	2023-09-02 15:16:12
162228	1113207	2023-09-02 15:16:34
162229	1113206	2023-09-02 15:17:18
162230	1113197	2023-09-02 15:19:08
162231	1113190	2023-09-02 15:19:47
162232	1113180	2023-09-02 15:20:33
162233	1113165	2023-09-02 15:20:56
162234	1113134	2023-09-02 15:22:06
162235	1113132	2023-09-02 15:24:08
162236	1113131	2023-09-02 15:25:19
162237	1113120	2023-09-02 15:25:34
162238	1113118	2023-09-02 15:25:49
162239	1113087	2023-09-02 15:26:16
162240	1113084	2023-09-02 15:27:44
162241	1113081	2023-09-02 15:27:55
162242	1113080	2023-09-02 15:29:25
162243	1113078	2023-09-02 15:30:00
162244	1113077	2023-09-02 15:30:45
162245	1113045	2023-09-02 15:32:15
162246	1113030	2023-09-02 15:33:32
162248	1113018	2023-09-02 15:33:51
162249	1112999	2023-09-02 15:34:10
162250	1112978	2023-09-02 15:34:17
162251	1112976	2023-09-02 15:34:25
162252	1112973	2023-09-02 15:34:36
162253	1112956	2023-09-02 15:35:35
162254	1112955	2023-09-02 15:37:04
162255	1112954	2023-09-02 15:37:44
162256	1112951	2023-09-02 15:43:05
162257	1112934	2023-09-02 15:44:17
162258	1112921	2023-09-02 15:44:25
162259	1112888	2023-09-02 15:45:07
162260	1112873	2023-09-02 15:45:42
162261	1112871	2023-09-02 15:48:53
162262	1112860	2023-09-02 15:52:17
162264	1112856	2023-09-02 16:08:11
162265	1112848	2023-09-02 16:08:23
162266	1112834	2023-09-02 16:08:54
162267	1112834	2023-09-02 16:08:54
162268	1112805	2023-09-02 16:10:02
162269	1112804	2023-09-02 16:10:20
162270	1112795	2023-09-02 16:13:01
162271	1112778	2023-09-02 16:13:45
162272	1112767	2023-09-02 16:14:02
162273	1112745	2023-09-02 16:15:15
162274	1112744	2023-09-02 16:15:24
162275	1112733	2023-09-02 16:15:56
162276	1112732	2023-09-02 16:16:10
162277	1112726	2023-09-02 16:18:06
162278	1112724	2023-09-02 16:18:35
162279	1112718	2023-09-02 16:19:32
162280	1112697	2023-09-02 16:20:07
162281	1112638	2023-09-02 16:21:32
162282	1112623	2023-09-02 16:22:08
162283	1112621	2023-09-02 16:22:22
162284	1112615	2023-09-02 16:22:42
162285	1112599	2023-09-02 16:22:52
162286	1112598	2023-09-02 16:22:57
162287	1112588	2023-09-02 16:23:14
162288	1112576	2023-09-02 16:23:29
162289	1112547	2023-09-02 16:24:01
162290	1112507	2023-09-02 16:25:00
162291	1112477	2023-09-02 16:28:16
162292	1112447	2023-09-02 16:29:00
162293	1112437	2023-09-02 16:29:08
162294	1112422	2023-09-02 16:29:37
162295	1112421	2023-09-02 16:29:52
162296	1112421	2023-09-02 16:29:52
162297	1112399	2023-09-02 16:30:29
162298	1112393	2023-09-02 16:30:39
162299	1112382	2023-09-02 16:31:07
162300	1112381	2023-09-02 16:31:17
162302	1112361	2023-09-02 16:32:02
162303	1112361	2023-09-02 16:32:02
162304	1113866	2023-09-02 16:35:10
162305	1113866	2023-09-02 16:35:10
162306	1113866	2023-09-02 16:35:10
162308	1113865	2023-09-02 16:36:14
162309	1113861	2023-09-02 16:36:28
162310	1113496	2023-09-02 16:36:42
162311	1113389	2023-09-02 16:36:45
162312	1113270	2023-09-02 16:36:49
162313	1113249	2023-09-02 16:36:59
162314	1113226	2023-09-02 16:37:34
162315	1113140	2023-09-02 16:37:43
162317	1113102	2023-09-02 16:38:02
162318	1112925	2023-09-02 16:38:16
162319	1112887	2023-09-02 16:38:26
162320	1112754	2023-09-02 16:38:31
162321	1112730	2023-09-02 16:38:40
162322	1112662	2023-09-02 16:38:50
162323	1112637	2023-09-02 16:38:55
162324	1112549	2023-09-02 16:39:38
162325	1112548	2023-09-02 16:40:06
162326	1112433	2023-09-02 16:40:23
162328	1114950	2023-09-03 09:04:35
162329	1114949	2023-09-03 09:05:18
162330	1114948	2023-09-03 09:05:25
162331	1114931	2023-09-03 09:06:03
162332	1114929	2023-09-03 09:06:07
162333	1114928	2023-09-03 09:06:22
162334	1114927	2023-09-03 09:06:30
162335	1114925	2023-09-03 09:06:37
162336	1114903	2023-09-03 09:06:57
162337	1114902	2023-09-03 09:07:07
162338	1114878	2023-09-03 09:07:57
162339	1114876	2023-09-11 09:07:07
162340	1114870	2023-09-03 14:57:39
162341	1114869	2023-09-03 14:58:03
162342	1114863	2023-09-03 14:58:55
162343	1114857	2023-09-03 14:59:10
162344	1114854	2023-09-03 14:59:23
162345	1114853	2023-09-03 14:59:31
162346	1114823	2023-09-03 14:59:55
162347	1114822	2023-09-03 15:00:17
162348	1114735	2023-09-03 15:01:31
162349	1114721	2023-09-03 15:01:41
162350	1114718	2023-09-03 15:02:01
162351	1114705	2023-09-03 15:02:18
162352	1114703	2023-09-03 15:02:47
162353	1114702	2023-09-03 15:03:00
162354	1114696	2023-09-03 15:06:47
162355	1114695	2023-09-03 15:06:55
162356	1114693	2023-09-03 15:07:50
162357	1114676	2023-09-03 15:08:13
162358	1114671	2023-09-03 15:08:33
162359	1114670	2023-09-03 15:12:23
162360	1114653	2023-09-03 15:14:41
162361	1114634	2023-09-03 15:15:26
162362	1114614	2023-09-03 15:18:40
162363	1114613	2023-09-03 15:19:20
162364	1114590	2023-09-03 15:20:41
162365	1114387	2023-09-03 15:23:03
162366	1114386	2023-09-03 15:23:19
162367	1114383	2023-09-03 15:26:47
162368	1114381	2023-09-03 15:27:19
162369	1114374	2023-09-03 15:32:10
162370	1114368	2023-09-03 15:32:35
162371	1114368	2023-09-03 15:32:35
162372	1114356	2023-09-03 15:32:42
162373	1114353	2023-09-03 15:33:45
162374	1114352	2023-09-03 15:34:02
162375	1114351	2023-09-03 15:34:10
162376	1114346	2023-09-03 15:35:03
162377	1114322	2023-09-03 15:41:49
162378	1114312	2023-09-03 15:43:29
162379	1114305	2023-09-03 15:43:39
162380	1114304	2023-09-03 15:43:57
162381	1114288	2023-09-03 15:44:08
162382	1114268	2023-09-03 15:44:37
162383	1114259	2023-09-03 15:44:53
162385	1114241	2023-09-03 15:45:46
162386	1114221	2023-09-03 15:49:48
162387	1114219	2023-09-03 15:51:46
162388	1114039	2023-09-03 16:03:40
162389	1114038	2023-09-03 16:03:53
162390	1114022	2023-09-03 16:04:51
162391	1114021	2023-09-03 16:06:05
162392	1114021	2023-09-03 16:06:05
162393	1114020	2023-09-03 16:13:31
162394	1114013	2023-09-03 16:13:44
162395	1114011	2023-09-03 16:17:33
162396	1114010	2023-09-03 16:18:21
162397	1114008	2023-09-03 16:18:39
162398	1113999	2023-09-03 16:18:56
162399	1113998	2023-09-03 16:18:59
162400	1113997	2023-09-03 16:19:09
162401	1113992	2023-09-03 16:19:12
162402	1113991	2023-09-03 16:19:20
162403	1113986	2023-09-03 16:19:42
162404	1113982	2023-09-03 16:19:55
162405	1113973	2023-09-03 16:20:12
162406	1113972	2023-09-08 09:46:20
162407	1113971	2023-09-03 16:30:43
162408	1113969	2023-09-03 16:30:48
162409	1113968	2023-09-03 16:30:55
162410	1113967	2023-09-03 16:31:08
162411	1113966	2023-09-03 16:31:18
162412	1113963	2023-09-03 16:31:31
162413	1113962	2023-09-03 16:31:41
162414	1113954	2023-09-03 16:31:50
162415	1113944	2023-09-03 16:33:03
162416	1113939	2023-09-03 16:33:28
162417	1113938	2023-09-03 16:33:49
162418	1113937	2023-09-03 16:34:28
162419	1113936	2023-09-03 16:36:00
162420	1113935	2023-09-03 16:39:36
162421	1113921	2023-09-03 16:40:40
162422	1113911	2023-09-03 16:40:53
162423	1113910	2023-09-03 16:41:06
162424	1113909	2023-09-03 16:49:49
162425	1113908	2023-09-03 16:50:07
162426	1113907	2023-09-03 16:51:25
162427	1113893	2023-09-03 16:52:41
162428	1113893	2023-09-03 16:52:41
162429	1113892	2023-09-03 16:53:05
162430	1113892	2023-09-03 16:53:05
162431	1113891	2023-09-03 16:53:35
162432	1113890	2023-09-03 16:53:56
162433	1113885	2023-09-03 16:54:55
162434	1114563	2023-09-03 16:58:47
162435	1114561	2023-09-03 16:59:05
162436	1114561	2023-09-03 16:59:05
162437	1114560	2023-09-03 17:00:27
162438	1114558	2023-09-03 17:01:02
162439	1114555	2023-09-03 17:01:16
162440	1114534	2023-09-03 17:01:31
162441	1114529	2023-09-03 17:01:46
162442	1114508	2023-09-03 17:04:05
162443	1114497	2023-09-03 17:04:26
162444	1114496	2023-09-03 17:04:37
162445	1114495	2023-09-03 17:04:46
162447	1114483	2023-09-03 17:05:03
162448	1114476	2023-09-11 09:10:41
162449	1114473	2023-09-03 17:06:04
162450	1114472	2023-09-03 17:06:39
162451	1114471	2023-09-03 17:07:01
162452	1114467	2023-09-03 17:07:22
162453	1114461	2023-09-03 17:13:14
162454	1114459	2023-09-03 17:15:09
162455	1114430	2023-09-03 17:15:35
162456	1114429	2023-09-03 17:15:42
162458	1114422	2023-09-03 17:16:02
162459	1114420	2023-09-03 17:16:08
162460	1114419	2023-09-03 17:16:14
162461	1114416	2023-09-03 17:16:24
162462	1114415	2023-09-03 17:16:37
162463	1114415	2023-09-03 17:16:37
162464	1114193	2023-09-03 17:16:58
162465	1114192	2023-09-03 17:17:01
162466	1114190	2023-09-03 17:17:12
162467	1114187	2023-09-08 10:00:41
162468	1114185	2023-09-03 17:17:52
162469	1114179	2023-09-03 17:18:01
162470	1114169	2023-09-03 17:22:13
162471	1114159	2023-09-03 17:28:11
162472	1114146	2023-09-03 17:28:44
162473	1114133	2023-09-03 17:29:23
162474	1114133	2023-09-03 17:29:23
162475	1114130	2023-09-03 17:29:33
162476	1114123	2023-09-03 17:29:59
162477	1114120	2023-09-03 17:30:13
162478	1114116	2023-09-03 17:30:30
162479	1114106	2023-09-03 17:31:09
162480	1114102	2023-09-03 17:32:22
162481	1114093	2023-09-03 17:33:30
162482	1114092	2023-09-03 17:33:36
162483	1114080	2023-09-03 17:33:49
162484	1114078	2023-09-03 17:33:56
162485	1114068	2023-09-03 17:34:29
162486	1114056	2023-09-03 17:34:35
162487	1114055	2023-09-03 17:34:41
162488	1114051	2023-09-03 17:35:20
162489	1114049	2023-09-03 17:35:42
162490	1114048	2023-09-03 17:35:49
162491	1114015	2023-09-03 17:36:02
162492	1116158	2023-09-04 09:40:00
162493	1116072	2023-09-04 09:40:45
162494	1115986	2023-09-04 09:41:04
162495	1115967	2023-09-04 09:41:44
162499	1115933	2023-09-04 09:43:37
162502	1115756	2023-09-04 09:46:24
162507	1115386	2023-09-04 09:53:11
162508	1115386	2023-09-04 09:53:11
162509	1115386	2023-09-04 09:53:11
162512	1115373	2023-09-04 09:54:39
162514	1115371	2023-09-04 09:55:30
162516	1115313	2023-09-04 09:56:32
162517	1115238	2023-09-04 09:56:46
162523	1116290	2023-09-04 10:03:26
162524	1116276	2023-09-04 10:04:10
162527	1116181	2023-09-04 10:06:41
162532	1116042	2023-09-04 10:10:22
162534	1115985	2023-09-04 10:11:34
162535	1115984	2023-09-04 10:11:47
162539	1115979	2023-09-04 10:14:06
162540	1115965	2023-09-04 10:14:26
162541	1115934	2023-09-04 10:14:50
162542	1115917	2023-09-04 10:15:45
162543	1115905	2023-09-04 10:15:56
162549	1115819	2023-09-04 10:21:28
162550	1115819	2023-09-04 10:21:28
162551	1115733	2023-09-04 10:24:20
162552	1115717	2023-09-04 10:25:56
162553	1115712	2023-09-04 10:26:44
162555	1115692	2023-09-04 10:28:59
162557	1115666	2023-09-04 10:30:29
162560	1115654	2023-09-04 10:32:46
162562	1115617	2023-09-04 10:34:27
162565	1115552	2023-09-04 10:36:36
162568	1115530	2023-09-04 10:39:03
162569	1115518	2023-09-04 10:39:26
162574	1115350	2023-09-04 10:44:27
162575	1115315	2023-09-04 10:46:12
162576	1115311	2023-09-04 10:46:31
162578	1115268	2023-09-04 10:48:39
162579	1115240	2023-09-04 10:49:04
162580	1115223	2023-09-04 10:49:41
162581	1115213	2023-09-04 10:50:29
162587	1115132	2023-09-08 11:26:53
162592	1115061	2023-09-04 11:02:44
162593	1115060	2023-09-04 11:03:01
162594	1115053	2023-09-04 11:03:54
162596	1115030	2023-09-04 11:06:48
162598	1115008	2023-09-04 11:08:32
162599	1116291	2023-09-04 11:18:03
162601	1116202	2023-09-04 11:24:03
162602	1116192	2023-09-04 11:25:29
162603	1116191	2023-09-04 11:25:55
162604	1116156	2023-09-04 11:27:48
162605	1116133	2023-09-04 11:29:05
162606	1116070	2023-09-04 11:31:08
162607	1116036	2023-09-04 11:33:20
162608	1116001	2023-09-04 11:36:44
162609	1115995	2023-09-04 11:37:34
162610	1115932	2023-09-04 11:39:56
162611	1115924	2023-09-04 11:40:39
162612	1115912	2023-09-04 11:41:21
162613	1115873	2023-09-04 11:45:38
162614	1115873	2023-09-04 11:45:38
162615	1115872	2023-09-04 11:45:57
162616	1115818	2023-09-04 11:48:58
162618	1115786	2023-09-04 11:52:19
162620	1115760	2023-09-04 11:53:58
162621	1115759	2023-09-04 11:55:20
162622	1115759	2023-09-04 11:55:20
162624	1115730	2023-09-04 11:56:25
162625	1115716	2023-09-04 11:57:09
162627	1115664	2023-09-04 12:00:39
162628	1115652	2023-09-04 12:02:58
162629	1115630	2023-09-04 12:05:00
162630	1115621	2023-09-04 12:07:02
162631	1115620	2023-09-04 12:07:28
162632	1115594	2023-09-04 12:08:39
162634	1115534	2023-09-04 12:11:33
162636	1115495	2023-09-04 12:14:39
162637	1115490	2023-09-04 12:15:34
162638	1115472	2023-09-04 12:17:54
162639	1115472	2023-09-04 12:17:54
162640	1115456	2023-09-04 12:19:40
162641	1115456	2023-09-04 12:19:40
162642	1115452	2023-09-04 12:20:16
162643	1115415	2023-09-04 12:22:33
162645	1115403	2023-09-04 12:24:44
162646	1115396	2023-09-04 12:26:09
162647	1115341	2023-09-04 12:28:09
162648	1115305	2023-09-04 12:29:47
162649	1115258	2023-09-04 12:31:45
162650	1115244	2023-09-04 12:33:49
162651	1115242	2023-09-04 12:34:32
162652	1115239	2023-09-04 12:34:50
162653	1115211	2023-09-11 09:09:20
162654	1115193	2023-09-04 12:38:19
162655	1115192	2023-09-04 12:38:49
162656	1115179	2023-09-04 12:39:49
162657	1115177	2023-09-04 12:40:36
162658	1115165	2023-09-04 12:41:07
162659	1115163	2023-09-04 12:41:29
162661	1115107	2023-09-04 12:45:28
162662	1115106	2023-09-04 12:45:55
162663	1115094	2023-09-04 12:47:17
162664	1115093	2023-09-04 12:47:40
162665	1115092	2023-09-04 12:48:05
162668	1115082	2023-09-04 12:50:42
162669	1115080	2023-09-04 12:51:07
162670	1115018	2023-09-04 12:52:18
162671	1115009	2023-09-04 12:54:16
162672	1115007	2023-09-04 12:54:36
162673	1114998	2023-09-04 12:55:41
162674	1114998	2023-09-04 12:55:41
162675	1116318	2023-09-04 16:05:14
162676	1117542	2023-09-05 09:02:39
162677	1117523	2023-09-05 09:07:45
162678	1117519	2023-09-05 09:08:01
162679	1117512	2023-09-05 09:08:46
162680	1117510	2023-09-05 09:08:57
162681	1117508	2023-09-05 09:09:06
162682	1117502	2023-09-05 09:10:10
162683	1117502	2023-09-05 09:10:10
162684	1117501	2023-09-05 09:18:42
162685	1117484	2023-09-05 09:19:19
162687	1117481	2023-09-05 09:19:31
162688	1117470	2023-09-05 09:19:40
162689	1117466	2023-09-05 09:21:00
162690	1117465	2023-09-05 09:21:20
162691	1117457	2023-09-05 09:22:03
162692	1117422	2023-09-05 09:23:13
162693	1117417	2023-09-05 09:23:26
162694	1117389	2023-09-05 09:23:56
162695	1117370	2023-09-05 09:30:45
162696	1117356	2023-09-05 09:30:53
162697	1117339	2023-09-05 09:31:45
162698	1117337	2023-09-05 09:32:00
162699	1117319	2023-09-05 09:32:05
162700	1117318	2023-09-05 09:32:18
162701	1117288	2023-09-05 09:34:19
162702	1117062	2023-09-05 09:35:26
162703	1117061	2023-09-05 09:36:00
162704	1117059	2023-09-05 09:37:37
162705	1117056	2023-09-05 09:42:48
162706	1117052	2023-09-05 09:44:48
162707	1117038	2023-09-05 09:49:06
162708	1117038	2023-09-05 09:49:06
162709	1117035	2023-09-05 09:50:29
162710	1117028	2023-09-05 09:50:44
162711	1117023	2023-09-05 09:51:40
162712	1117020	2023-09-05 09:52:10
162713	1117019	2023-09-05 09:52:19
162714	1117017	2023-09-05 09:53:31
162715	1117011	2023-09-05 09:53:48
162716	1116999	2023-09-08 10:00:09
162717	1116998	2023-09-05 09:58:22
162718	1116988	2023-09-05 09:59:42
162719	1116987	2023-09-05 09:59:48
162720	1116986	2023-09-05 09:59:52
162721	1116984	2023-09-05 10:00:20
162722	1116968	2023-09-05 10:03:45
162723	1117285	2023-09-05 10:45:18
162724	1117284	2023-09-05 10:45:35
162725	1117274	2023-09-05 10:46:08
162726	1117253	2023-09-05 10:47:59
162727	1117246	2023-09-05 10:57:00
162728	1117244	2023-09-05 11:01:13
162729	1117197	2023-09-05 11:05:01
162730	1117196	2023-09-05 11:05:10
162731	1117189	2023-09-05 11:05:40
162732	1117189	2023-09-05 11:05:40
162733	1117175	2023-09-05 11:06:02
162734	1117157	2023-09-05 11:06:55
162735	1117153	2023-09-05 11:07:00
162736	1117150	2023-09-05 11:07:38
162737	1117144	2023-09-05 11:08:35
162738	1117128	2023-09-05 11:09:11
162739	1117127	2023-09-05 11:12:28
162740	1117125	2023-09-05 11:14:09
162741	1117084	2023-09-05 11:15:58
162742	1117083	2023-09-05 11:16:05
162743	1117082	2023-09-05 11:16:59
162744	1116752	2023-09-05 11:22:03
162745	1116742	2023-09-05 11:22:08
162746	1116741	2023-09-05 11:23:31
162747	1116741	2023-09-05 11:23:31
162748	1116741	2023-09-05 11:23:31
162749	1116741	2023-09-05 11:23:31
162750	1116741	2023-09-05 11:23:31
162751	1116731	2023-09-05 11:24:01
162752	1116731	2023-09-05 11:24:01
162753	1116729	2023-09-05 11:24:20
162754	1116724	2023-09-05 11:24:49
162755	1116722	2023-09-05 11:24:55
162756	1116710	2023-09-05 11:25:31
162757	1116706	2023-09-05 11:25:43
162758	1116691	2023-09-05 11:26:34
162759	1116663	2023-09-05 11:28:40
162760	1116660	2023-09-05 11:29:38
162761	1116659	2023-09-05 11:29:45
162762	1116658	2023-09-05 11:29:51
162763	1116656	2023-09-05 11:30:03
162764	1116635	2023-09-05 11:32:19
162765	1116966	2023-09-05 11:33:22
162766	1116955	2023-09-05 11:34:48
162767	1116955	2023-09-05 11:34:48
162768	1116955	2023-09-05 11:34:48
162769	1116955	2023-09-05 11:34:48
162770	1116955	2023-09-05 11:34:48
162771	1116955	2023-09-05 11:34:48
162772	1116953	2023-09-05 11:35:09
162773	1116952	2023-09-05 12:11:22
162774	1116874	2023-09-05 12:12:33
162775	1116951	2023-09-05 13:03:54
162777	1116950	2023-09-05 13:09:05
162779	1116948	2023-09-05 13:18:08
162781	1116946	2023-09-05 13:19:33
162782	1116909	2023-09-05 13:28:07
162783	1116908	2023-09-05 13:30:52
162784	1116907	2023-09-05 13:32:19
162785	1116840	2023-09-05 13:36:43
162786	1116840	2023-09-05 13:36:43
162787	1116839	2023-09-05 13:38:52
162788	1116827	2023-09-05 13:47:32
162789	1116827	2023-09-05 13:47:32
162790	1116820	2023-09-05 13:48:22
162791	1116819	2023-09-05 13:50:41
162794	1116781	2023-09-05 13:54:40
162796	1116614	2023-09-05 14:04:58
162797	1116613	2023-09-05 14:06:03
162799	1116611	2023-09-05 14:08:37
162801	1116586	2023-09-05 14:12:16
162802	1116586	2023-09-05 14:12:16
162803	1116586	2023-09-05 14:12:16
162804	1116586	2023-09-05 14:12:16
162805	1116574	2023-09-05 14:16:27
162806	1116573	2023-09-05 14:18:09
162807	1116572	2023-09-05 14:19:43
162809	1116549	2023-09-05 14:24:23
162810	1116549	2023-09-05 14:24:23
162811	1116548	2023-09-05 14:29:13
162812	1116547	2023-09-05 14:31:46
162813	1116497	2023-09-05 14:33:35
162814	1116494	2023-09-05 14:35:58
162815	1116494	2023-09-05 14:35:58
162816	1116493	2023-09-05 14:37:10
162817	1116487	2023-09-05 14:38:17
162818	1116486	2023-09-05 14:41:26
162819	1116484	2023-09-05 14:43:58
162820	1116483	2023-09-05 14:50:56
162821	1116483	2023-09-05 14:50:56
162822	1116483	2023-09-05 14:50:56
162823	1116483	2023-09-05 14:50:56
162824	1116483	2023-09-05 14:50:56
162825	1116483	2023-09-05 14:50:56
162826	1116483	2023-09-05 14:50:56
162827	1116482	2023-09-05 14:56:02
162828	1116482	2023-09-05 14:56:02
162829	1116482	2023-09-05 14:56:02
162830	1116482	2023-09-05 14:56:02
162831	1116482	2023-09-05 14:56:02
162832	1116482	2023-09-05 14:56:02
162833	1116482	2023-09-05 14:56:02
162834	1116466	2023-09-05 14:56:54
162835	1116465	2023-09-05 14:57:59
162836	1116442	2023-09-05 15:04:02
162837	1116437	2023-09-05 15:09:29
162839	1116432	2023-09-05 15:12:52
162840	1116432	2023-09-05 15:12:52
162841	1116429	2023-09-05 15:14:18
162842	1116428	2023-09-05 15:19:35
162843	1116424	2023-09-05 15:26:01
162844	1116422	2023-09-05 15:27:37
162845	1116369	2023-09-05 15:31:17
162846	1116369	2023-09-05 15:31:17
162847	1116883	2023-09-05 15:33:08
162848	1116876	2023-09-08 09:35:52
162849	1116873	2023-09-05 15:37:54
162850	1116842	2023-09-05 15:42:38
162851	1116841	2023-09-05 15:44:02
162852	1116841	2023-09-05 15:44:02
162853	1116610	2023-09-05 15:44:27
162854	1116608	2023-09-05 15:46:27
162855	1116608	2023-09-05 15:46:27
162856	1116544	2023-09-05 16:45:44
162857	1116541	2023-09-05 16:46:19
162858	1116540	2023-09-05 16:47:02
162859	1116527	2023-09-05 16:48:17
162860	1116450	2023-09-05 16:49:59
162861	1116449	2023-09-05 16:50:43
162862	1116448	2023-09-05 16:51:09
162863	1116443	2023-09-05 16:53:28
162864	1116400	2023-09-05 16:57:17
162866	1116353	2023-09-05 17:02:22
162867	1116336	2023-09-05 17:06:16
162868	1116331	2023-09-05 17:11:08
162869	1116331	2023-09-05 17:11:08
162870	1116330	2023-09-05 17:12:11
162873	1116324	2023-09-05 17:21:00
162874	1116813	2023-09-05 17:25:58
162875	1116812	2023-09-05 17:27:59
162876	1116809	2023-09-05 17:30:11
162877	1116808	2023-09-05 17:31:24
162878	1116800	2023-09-05 17:32:32
162879	1116789	2023-09-05 17:33:58
162880	1116789	2023-09-05 17:33:58
162881	1116784	2023-09-05 17:36:10
162882	1116396	2023-09-05 17:37:20
162883	1116379	2023-09-05 17:39:30
162884	1116379	2023-09-05 17:39:30
162885	1116375	2023-09-08 09:18:37
162886	1116373	2023-09-05 17:43:54
162887	1116372	2023-09-05 17:44:39
162888	1116367	2023-09-05 17:47:09
162889	1116365	2023-09-05 17:49:46
162890	1116359	2023-09-05 17:51:11
162891	1116359	2023-09-05 17:51:11
162892	1116359	2023-09-05 17:51:11
162894	1116509	2023-09-05 17:59:53
162895	1116498	2023-09-05 18:02:51
162896	1116498	2023-09-05 18:02:51
162897	1116498	2023-09-05 18:02:51
162898	1116464	2023-09-05 18:03:47
162899	1116458	2023-09-05 18:08:11
162900	1116452	2023-09-05 18:11:15
162901	1118696	2023-09-06 09:08:36
162903	1118692	2023-09-06 09:15:24
162905	1118653	2023-09-06 09:27:38
162906	1118649	2023-09-06 09:29:19
162907	1118638	2023-09-06 09:32:36
162908	1118637	2023-09-06 09:35:34
162909	1118635	2023-09-06 09:36:03
162910	1118620	2023-09-06 09:41:18
162911	1118618	2023-09-06 09:43:44
162912	1118609	2023-09-06 09:47:36
162913	1118598	2023-09-06 09:49:50
162914	1118592	2023-09-06 09:50:41
162915	1118588	2023-09-06 09:52:47
162916	1118587	2023-09-06 09:54:34
162917	1118579	2023-09-06 09:55:57
162918	1118570	2023-09-06 09:57:27
162919	1118569	2023-09-06 09:58:19
162920	1118568	2023-09-06 09:58:49
162921	1118565	2023-09-06 10:00:48
162922	1118559	2023-09-06 10:04:25
162923	1118522	2023-09-06 10:08:56
162924	1118521	2023-09-06 10:09:18
162925	1118520	2023-09-06 10:10:35
162926	1118519	2023-09-06 10:11:03
162927	1118518	2023-09-06 10:11:30
162928	1118517	2023-09-06 10:16:05
162929	1118517	2023-09-06 10:16:05
162930	1118517	2023-09-06 10:16:05
162931	1118517	2023-09-06 10:16:05
162932	1118517	2023-09-06 10:16:05
162933	1118517	2023-09-06 10:16:05
162934	1118517	2023-09-06 10:16:05
162935	1118201	2023-09-06 10:19:34
162936	1118192	2023-09-06 10:20:17
162937	1118188	2023-09-06 10:25:28
162938	1118186	2023-09-06 10:27:32
162939	1118177	2023-09-06 10:29:16
162940	1118173	2023-09-06 10:30:50
162941	1118171	2023-09-06 10:32:32
162942	1118169	2023-09-06 10:34:03
162943	1118168	2023-09-06 10:36:30
162944	1118160	2023-09-11 09:11:17
162945	1118156	2023-09-06 10:42:50
162946	1118155	2023-09-06 10:43:39
162947	1118139	2023-09-06 10:44:31
162948	1118138	2023-09-06 10:45:52
162949	1118137	2023-09-06 10:49:19
162950	1118136	2023-09-06 10:52:19
162951	1118136	2023-09-06 10:52:19
162952	1118136	2023-09-06 10:52:19
162953	1118134	2023-09-06 10:53:44
162954	1118134	2023-09-06 10:54:11
162955	1118112	2023-09-06 10:57:25
162957	1118110	2023-09-06 10:58:51
162958	1118102	2023-09-06 11:00:32
162959	1118102	2023-09-06 11:01:09
162960	1118096	2023-09-06 11:07:11
162961	1118094	2023-09-06 11:17:06
162962	1118083	2023-09-06 11:20:27
162963	1118069	2023-09-06 11:23:06
162964	1118045	2023-09-06 11:31:55
162965	1118034	2023-09-06 11:38:18
162966	1118240	2023-09-06 11:41:04
162967	1118024	2023-09-06 11:45:41
162968	1118023	2023-09-06 11:48:26
162969	1118021	2023-09-06 11:50:55
162970	1118017	2023-09-06 11:54:04
162971	1118008	2023-09-06 11:58:20
162972	1118006	2023-09-06 11:59:54
162973	1118005	2023-09-06 12:01:32
162974	1118000	2023-09-06 12:03:27
162975	1117990	2023-09-06 12:06:56
162976	1118516	2023-09-06 12:32:09
162977	1118488	2023-09-06 12:36:43
162978	1118405	2023-09-06 12:39:30
162979	1118404	2023-09-06 12:41:24
162980	1118391	2023-09-06 12:42:34
162981	1118388	2023-09-06 12:44:27
162982	1118384	2023-09-06 12:47:35
162983	1118384	2023-09-06 12:47:06
162984	1118383	2023-09-06 12:48:15
162985	1118380	2023-09-06 12:48:25
162986	1118379	2023-09-06 12:48:46
162987	1118378	2023-09-06 12:48:55
162989	1118282	2023-09-06 12:52:21
162990	1118249	2023-09-06 12:55:14
162991	1118241	2023-09-06 12:55:52
162992	1117933	2023-09-06 12:56:05
162993	1117931	2023-09-06 12:57:08
162994	1117764	2023-09-06 14:12:05
162998	1117588	2023-09-06 14:36:52
162999	1117588	2023-09-06 14:37:19
163001	1117588	2023-09-06 14:38:28
163003	1117768	2023-09-06 14:42:27
163004	1117881	2023-09-06 14:47:38
163005	1117862	2023-09-06 14:48:33
163006	1117830	2023-09-06 14:48:53
163010	1117683	2023-09-06 14:51:04
163011	1117763	2023-09-06 14:51:35
163015	1117686	2023-09-06 15:05:54
163017	1117653	2023-09-06 15:06:47
163018	1117765	2023-09-06 15:06:57
163019	1118371	2023-09-06 15:18:54
163020	1117726	2023-09-06 15:22:45
163021	1117840	2023-09-06 15:25:17
163022	1117783	2023-09-06 15:25:32
163023	1117661	2023-09-06 15:30:07
163024	1118419	2023-09-06 15:48:32
163026	1117869	2023-09-06 15:51:35
163028	1117899	2023-09-06 15:52:46
163029	1117899	2023-09-06 15:53:17
163030	1117816	2023-09-06 15:54:06
163032	1117794	2023-09-06 15:56:10
163033	1118329	2023-09-06 15:58:37
163036	1117735	2023-09-06 16:11:33
163037	1117735	2023-09-06 16:11:33
163038	1117735	2023-09-06 16:11:33
163039	1117784	2023-09-06 16:11:57
163040	1117842	2023-09-06 16:12:46
163041	1118450	2023-09-06 16:13:33
163042	1117945	2023-09-06 16:14:22
163044	1117597	2023-09-06 16:19:07
163045	1117829	2023-09-06 16:19:42
163046	1117758	2023-09-06 16:20:02
163049	1117699	2023-09-06 16:23:05
163050	1117700	2023-09-06 16:23:12
163051	1117902	2023-09-06 16:23:58
163053	1117679	2023-09-06 16:26:34
163054	1117800	2023-09-06 16:27:19
163057	1117615	2023-09-06 16:30:14
163058	1117615	2023-09-06 16:30:36
163059	1117725	2023-09-06 16:31:42
163060	1118365	2023-09-11 09:07:58
163061	1118414	2023-09-06 16:33:19
163062	1118414	2023-09-06 16:33:19
163063	1118414	2023-09-06 16:33:19
163064	1117944	2023-09-06 16:34:47
163065	1117618	2023-09-06 16:35:35
163066	1117717	2023-09-06 16:36:01
163068	1117724	2023-09-06 16:45:28
163069	1117825	2023-09-06 16:47:57
163070	1117682	2023-09-06 16:48:37
163071	1117949	2023-09-06 16:48:50
163072	1117626	2023-09-06 16:49:47
163073	1117670	2023-09-06 16:50:39
163074	1117799	2023-09-06 16:52:24
163075	1117616	2023-09-06 16:54:06
163076	1117719	2023-09-06 16:56:42
163078	1117885	2023-09-06 17:01:31
163080	1118449	2023-09-06 17:06:34
163081	1117766	2023-09-06 17:11:22
163088	1118458	2023-09-06 17:21:45
163090	1117629	2023-09-06 17:26:48
163091	1117733	2023-09-06 17:29:52
163092	1117733	2023-09-06 17:30:16
163093	1118356	2023-09-06 17:31:12
163094	1117967	2023-09-06 17:40:12
163095	1118413	2023-09-06 17:41:13
163096	1117809	2023-09-06 17:43:07
163097	1117740	2023-09-06 17:44:35
163098	1117740	2023-09-06 17:44:35
163161	1120340	2023-09-07 09:04:00
163162	1120290	2023-09-07 09:12:18
163163	1120287	2023-09-07 09:17:17
163168	1120243	2023-09-07 09:36:16
163169	1120240	2023-09-07 09:37:49
163170	1120208	2023-09-07 09:45:49
163171	1120186	2023-09-07 09:49:06
163172	1120185	2023-09-07 09:50:34
163173	1120183	2023-09-07 09:51:27
163174	1120168	2023-09-07 09:55:27
163175	1120166	2023-09-07 09:58:34
163176	1119897	2023-09-07 09:59:32
163179	1119855	2023-09-07 10:14:51
163180	1119855	2023-09-07 10:14:51
163181	1119855	2023-09-07 10:14:51
163182	1119849	2023-09-07 10:17:23
163184	1119748	2023-09-07 10:35:07
163185	1119748	2023-09-07 10:35:42
163187	1119728	2023-09-07 10:41:45
163188	1119700	2023-09-07 10:48:08
163189	1119699	2023-09-07 10:49:18
163190	1119694	2023-09-07 10:51:30
163191	1119684	2023-09-07 10:55:01
163192	1119674	2023-09-07 11:02:13
163194	1119661	2023-09-07 11:06:25
163195	1119570	2023-09-07 11:09:04
163196	1119541	2023-09-07 11:13:20
163197	1119527	2023-09-07 11:18:58
163198	1119526	2023-09-07 11:20:30
163199	1119501	2023-09-07 11:25:28
163200	1119493	2023-09-07 11:27:01
163201	1119484	2023-09-07 11:30:00
163202	1119484	2023-09-07 11:31:03
163203	1119482	2023-09-07 11:32:17
163204	1119478	2023-09-07 11:32:58
163205	1119471	2023-09-07 11:34:41
163206	1119447	2023-09-07 11:39:46
163207	1119446	2023-09-07 11:41:00
163208	1119422	2023-09-07 11:46:08
163209	1119420	2023-09-07 11:48:18
163210	1119417	2023-09-07 11:49:41
163211	1119409	2023-09-07 11:51:19
163212	1119403	2023-09-07 11:58:20
163213	1119393	2023-09-07 12:00:56
163214	1119377	2023-09-07 12:04:21
163215	1119375	2023-09-07 12:06:59
163216	1119374	2023-09-07 12:08:16
163217	1119362	2023-09-07 12:14:32
163218	1119360	2023-09-07 12:16:04
163219	1119342	2023-09-07 12:21:43
163220	1119338	2023-09-07 12:24:33
163221	1119183	2023-09-07 12:27:12
163222	1119180	2023-09-07 12:28:45
163223	1119179	2023-09-07 12:29:47
163224	1119178	2023-09-07 12:30:17
163225	1119164	2023-09-07 12:34:54
163227	1119158	2023-09-07 12:38:51
163228	1119135	2023-09-07 12:41:44
163231	1119129	2023-09-07 12:48:05
163233	1119123	2023-09-07 12:52:43
163234	1119123	2023-09-07 12:53:30
163235	1119121	2023-09-07 12:56:31
163236	1119120	2023-09-07 12:58:13
163237	1119080	2023-09-07 13:10:53
163238	1119080	2023-09-07 13:11:55
163239	1119080	2023-09-07 13:12:43
163240	1119079	2023-09-07 13:13:38
163241	1119079	2023-09-07 13:14:01
163242	1119079	2023-09-07 13:14:37
163243	1119070	2023-09-07 13:16:46
163244	1119062	2023-09-07 13:20:30
163245	1120165	2023-09-07 13:26:09
163246	1120164	2023-09-07 13:26:23
163247	1120159	2023-09-07 13:26:42
163248	1120152	2023-09-07 13:27:05
163249	1120145	2023-09-07 14:07:35
163250	1118779	2023-09-07 14:12:02
163251	1120146	2023-09-07 14:13:19
163252	1120141	2023-09-07 14:13:35
163253	1120140	2023-09-07 14:16:56
163254	1120139	2023-09-07 14:19:00
163255	1118763	2023-09-07 14:19:08
163256	1120132	2023-09-07 14:19:28
163257	1120130	2023-09-07 14:19:36
163258	1118762	2023-09-07 14:20:19
163259	1118761	2023-09-07 14:23:57
163260	1118756	2023-09-07 14:26:38
163261	1118754	2023-09-07 14:28:28
163262	1118748	2023-09-07 14:30:20
163263	1118730	2023-09-07 14:32:28
163264	1118729	2023-09-07 14:33:27
163265	1118728	2023-09-07 14:33:51
163266	1120100	2023-09-07 14:37:39
163267	1120084	2023-09-07 14:37:56
163268	1120043	2023-09-07 14:39:16
163270	1120038	2023-09-07 14:41:48
163271	1120037	2023-09-07 14:42:12
163272	1120028	2023-09-07 14:42:24
163273	1120016	2023-09-07 14:42:40
163274	1119998	2023-09-07 14:56:21
163275	1119983	2023-09-07 14:56:27
163276	1119980	2023-09-07 14:56:41
163277	1119962	2023-09-07 14:57:04
163278	1119960	2023-09-07 14:57:18
163279	1119948	2023-09-07 15:42:13
163280	1119947	2023-09-07 15:43:33
163281	1119946	2023-09-07 15:43:45
163282	1119936	2023-09-07 15:43:54
163283	1119935	2023-09-07 15:44:59
163284	1119925	2023-09-07 15:45:11
163285	1119923	2023-09-07 15:45:30
163286	1119921	2023-09-07 15:46:54
163287	1119920	2023-09-07 15:47:04
163288	1119912	2023-09-07 15:47:10
163289	1119907	2023-09-07 15:47:22
163290	1119645	2023-09-07 15:49:49
163291	1119644	2023-09-07 15:50:01
163292	1119640	2023-09-07 15:51:23
163293	1119632	2023-09-07 15:52:33
163294	1119626	2023-09-07 15:52:39
163295	1119623	2023-09-07 15:53:24
163296	1119618	2023-09-07 15:54:05
163297	1119617	2023-09-07 15:54:13
163298	1119604	2023-09-07 15:54:32
163299	1119603	2023-09-07 15:54:41
163300	1119594	2023-09-07 15:55:58
163301	1119587	2023-09-07 15:56:03
163302	1119586	2023-09-07 15:56:14
163303	1119578	2023-09-07 15:56:57
163304	1119333	2023-09-07 15:58:20
163305	1119330	2023-09-07 15:59:56
163307	1119047	2023-09-07 16:00:07
163309	1119034	2023-09-07 16:03:16
163310	1119021	2023-09-07 16:04:25
163311	1119005	2023-09-07 16:05:32
163312	1119003	2023-09-07 16:06:19
163313	1118992	2023-09-07 16:07:13
163314	1118984	2023-09-07 16:07:19
163315	1118983	2023-09-07 16:07:43
163316	1118982	2023-09-07 16:07:58
163317	1118961	2023-09-07 16:08:14
163318	1118955	2023-09-07 16:08:26
163319	1118952	2023-09-07 16:09:05
163320	1118951	2023-09-07 16:09:15
163321	1118949	2023-09-07 16:09:28
163322	1118948	2023-09-07 16:09:36
163323	1118947	2023-09-07 16:10:40
163324	1118946	2023-09-07 16:12:22
163325	1118932	2023-09-07 16:13:40
163326	1118929	2023-09-07 16:13:49
163327	1118912	2023-09-07 16:14:09
163328	1118894	2023-09-07 16:14:59
163329	1118892	2023-09-07 16:15:37
163330	1118891	2023-09-07 16:15:45
163331	1118878	2023-09-07 16:16:49
163332	1118869	2023-09-07 16:17:05
163333	1118866	2023-09-07 16:17:42
163334	1119326	2023-09-07 16:18:36
163335	1119325	2023-09-07 16:19:48
163336	1119323	2023-09-07 16:20:08
163337	1119312	2023-09-07 16:20:48
163338	1119292	2023-09-07 16:21:38
163339	1119277	2023-09-07 16:22:01
163340	1119276	2023-09-07 16:22:07
163341	1119266	2023-09-07 16:23:14
163342	1119265	2023-09-07 16:23:21
163343	1119263	2023-09-07 16:23:49
163344	1119263	2023-09-07 16:23:49
163345	1119261	2023-09-07 16:24:25
163346	1119259	2023-09-07 16:24:37
163347	1119248	2023-09-07 16:25:37
163348	1119246	2023-09-07 16:26:04
163349	1119241	2023-09-07 16:26:14
163350	1119237	2023-09-07 16:26:30
163351	1119234	2023-09-07 16:26:58
163352	1119234	2023-09-07 16:26:58
163353	1119233	2023-09-07 16:27:36
163354	1119232	2023-09-07 16:27:56
163355	1119232	2023-09-07 16:27:56
163356	1119231	2023-09-07 16:28:21
163357	1119230	2023-09-07 16:28:29
163358	1119224	2023-09-07 16:28:38
163359	1119223	2023-09-07 16:29:26
163360	1119221	2023-09-07 16:30:37
163361	1119221	2023-09-07 16:30:37
163362	1119204	2023-09-07 16:32:40
163363	1119203	2023-09-07 16:32:51
163364	1119201	2023-09-07 16:33:05
163365	1119200	2023-09-07 16:34:33
163366	1119059	2023-09-07 16:34:36
163367	1119048	2023-09-07 16:34:57
163368	1118852	2023-09-07 16:35:58
163369	1118847	2023-09-07 16:36:30
163371	1118831	2023-09-07 16:37:36
163372	1118828	2023-09-07 16:39:54
163373	1118825	2023-09-07 16:40:12
163374	1118821	2023-09-07 16:40:29
163375	1118820	2023-09-07 16:40:41
163376	1118819	2023-09-07 16:40:52
163377	1118811	2023-09-07 16:41:02
163378	1118804	2023-09-07 16:41:53
163379	1118804	2023-09-07 16:41:53
163380	1118804	2023-09-07 16:41:53
163381	1118796	2023-09-08 09:59:32
163382	1118788	2023-09-07 16:43:11
163383	1118787	2023-09-07 16:43:18
163384	1121517	2023-09-08 08:04:00
163385	1121461	2023-09-08 08:10:15
163386	1121441	2023-09-08 08:12:38
163387	1121418	2023-09-08 08:14:22
163388	1121240	2023-09-08 08:16:02
163389	1121239	2023-09-08 08:17:54
163390	1121165	2023-09-08 08:20:49
163391	1121154	2023-09-08 08:23:10
163392	1121136	2023-09-08 08:24:39
163393	1120848	2023-09-08 08:28:21
163394	1120730	2023-09-08 08:38:34
163395	1121363	2023-09-08 09:14:15
163396	1121362	2023-09-08 09:16:21
163397	1121361	2023-09-08 09:17:41
163399	1121489	2023-09-08 09:34:28
163400	1121485	2023-09-08 09:36:14
163401	1121467	2023-09-08 09:39:42
163402	1121446	2023-09-08 09:42:49
163403	1121440	2023-09-08 09:45:38
163404	1121407	2023-09-08 09:50:03
163405	1121406	2023-09-08 09:53:01
163406	1121397	2023-09-08 09:57:32
163408	1121289	2023-09-08 10:04:15
163409	1121288	2023-09-08 10:07:04
163410	1121261	2023-09-08 10:11:53
163411	1121208	2023-09-08 10:14:14
163412	1121208	2023-09-08 10:14:14
163413	1121155	2023-09-08 10:17:18
163414	1121137	2023-09-08 10:23:29
163416	1121111	2023-09-08 10:26:27
163417	1121062	2023-09-08 10:28:00
163418	1121062	2023-09-08 10:28:00
163419	1121045	2023-09-08 10:29:47
163420	1120982	2023-09-08 10:32:06
163421	1120976	2023-09-08 10:32:45
163422	1120951	2023-09-08 10:38:57
163423	1120946	2023-09-08 10:41:16
163425	1120935	2023-09-08 10:45:24
163426	1120881	2023-09-08 10:50:26
163427	1120864	2023-09-08 10:54:45
163428	1120849	2023-09-08 10:56:08
163429	1120836	2023-09-08 11:05:54
163430	1120794	2023-09-08 11:13:10
163431	1120793	2023-09-08 11:15:35
163432	1120785	2023-09-08 11:21:15
163433	1120723	2023-09-08 11:27:22
163434	1120716	2023-09-08 11:28:48
163435	1120597	2023-09-08 11:29:43
163436	1120589	2023-09-08 11:31:11
163437	1120578	2023-09-08 11:32:54
163438	1120578	2023-09-08 11:32:54
163439	1119097	2023-09-08 11:33:01
163440	1120532	2023-09-08 11:34:32
163441	1120513	2023-09-08 11:39:36
163442	1120507	2023-09-08 11:41:30
163443	1120483	2023-09-08 11:46:49
163444	1120482	2023-09-08 11:47:37
163445	1120474	2023-09-08 11:48:52
163446	1120454	2023-09-08 11:51:33
163447	1120417	2023-09-08 11:52:23
163448	1120411	2023-09-08 11:54:42
163449	1120410	2023-09-08 11:56:44
163450	1120382	2023-09-08 12:03:36
163451	1115288	2023-09-08 12:08:31
163452	1121526	2023-09-08 12:08:57
163453	1121526	2023-09-08 12:08:57
163454	1115287	2023-09-08 12:09:00
163455	1120705	2023-09-08 12:11:33
163456	1120666	2023-09-08 12:12:23
163457	1120580	2023-09-08 12:14:31
163458	1120580	2023-09-08 12:14:31
163459	1114993	2023-09-08 12:14:44
163460	1120577	2023-09-08 12:15:21
163461	1120673	2023-09-08 13:03:14
163462	1121512	2023-09-08 13:08:17
163464	1120643	2023-09-08 13:13:24
163465	1120641	2023-09-08 13:14:07
163467	1121468	2023-09-08 13:27:24
163468	1121466	2023-09-08 13:30:49
163469	1120609	2023-09-08 13:37:17
163471	1120592	2023-09-08 13:43:34
163472	1120579	2023-09-08 13:47:43
163473	1120579	2023-09-08 13:47:43
163474	1120555	2023-09-08 14:16:02
163475	1120444	2023-09-08 14:24:55
163476	1120443	2023-09-08 14:25:38
163477	1120422	2023-09-08 14:30:40
163478	1121428	2023-09-08 14:31:40
163479	1120420	2023-09-08 14:32:37
163480	1120388	2023-09-08 14:35:08
163481	1121417	2023-09-08 14:37:32
163482	1120384	2023-09-08 14:38:09
163483	1120535	2023-09-08 14:43:06
163484	1120535	2023-09-08 14:43:06
163485	1120534	2023-09-08 14:44:10
163486	1120533	2023-09-08 14:44:29
163487	1121410	2023-09-08 14:46:27
163488	1121409	2023-09-08 14:55:57
163489	1120416	2023-09-08 14:56:36
163492	1120865	2023-09-08 15:05:21
163493	1120837	2023-09-08 15:07:29
163494	1120778	2023-09-08 15:13:30
163495	1121306	2023-09-08 15:14:20
163496	1121306	2023-09-08 15:14:20
163497	1121296	2023-09-08 15:14:51
163498	1121295	2023-09-08 15:22:51
163499	1121290	2023-09-08 15:23:32
163501	1121260	2023-09-08 15:35:28
163502	1121251	2023-09-08 15:37:57
163504	1121250	2023-09-08 15:39:07
163505	1121249	2023-09-08 15:41:10
163507	1121237	2023-09-08 15:49:53
163508	1121198	2023-09-08 16:07:24
163509	1121168	2023-09-08 16:09:40
163511	1121141	2023-09-08 16:12:26
163512	1121126	2023-09-08 16:21:58
163513	1121121	2023-09-08 16:26:40
163514	1121113	2023-09-08 16:27:03
163517	1121001	2023-09-15 12:49:44
163518	1120998	2023-09-08 16:45:54
163520	1120682	2023-09-08 17:16:04
163521	1120680	2023-09-08 17:18:18
163523	1120665	2023-09-08 17:21:35
163524	1120664	2023-09-08 17:24:37
163787	1114476	2023-09-11 09:10:41
163788	1118160	2023-09-11 09:11:17
163800	1123204	2023-09-12 09:21:10
163802	1123199	2023-09-12 09:24:09
163803	1123199	2023-09-12 09:24:09
163804	1123199	2023-09-12 09:24:09
163805	1123199	2023-09-12 09:24:09
163806	1123198	2023-09-12 09:25:24
163807	1123197	2023-09-12 09:25:53
163809	1122731	2023-09-12 09:27:12
163813	1122521	2023-09-12 09:29:57
163814	1122480	2023-09-12 09:30:37
163816	1122395	2023-09-12 09:31:37
163819	1122363	2023-09-12 09:33:36
163823	1122243	2023-09-12 09:36:00
163830	1122052	2023-09-12 09:38:31
163833	1122045	2023-09-12 09:39:16
163836	1121984	2023-09-12 09:39:40
163838	1126689	2023-09-12 09:39:49
163840	1121971	2023-09-12 09:40:29
163842	1121862	2023-09-12 09:41:25
163843	1121811	2023-09-12 09:41:57
163844	1121796	2023-09-12 09:42:49
163847	1121637	2023-09-12 09:45:10
163849	1123172	2023-09-12 09:48:28
163850	1123146	2023-09-12 09:48:56
163864	1123003	2023-09-12 09:55:41
163867	1122996	2023-09-12 09:56:13
163876	1122793	2023-09-12 10:01:42
163879	1122694	2023-09-12 10:02:52
163882	1122502	2023-09-12 10:05:04
163883	1122484	2023-09-12 10:05:37
163884	1122481	2023-09-12 10:06:18
163886	1122433	2023-09-12 10:07:18
163888	1122419	2023-09-12 10:08:13
163895	1122362	2023-09-12 10:11:02
163897	1122344	2023-09-12 10:12:23
163898	1122334	2023-09-12 10:13:12
163899	1122302	2023-09-12 10:13:55
163904	1122267	2023-09-12 10:15:58
163907	1122261	2023-09-12 10:16:43
163913	1122242	2023-09-12 10:18:41
163915	1122196	2023-09-12 10:21:04
163916	1122194	2023-09-12 10:21:57
163923	1122131	2023-09-12 10:24:31
163924	1122130	2023-09-12 10:25:02
163925	1122121	2023-09-12 10:26:27
163930	1122046	2023-09-12 10:29:07
163931	1122038	2023-09-12 10:29:41
163932	1122029	2023-09-12 10:30:12
163945	1121906	2023-09-12 10:33:57
163951	1121858	2023-09-12 10:37:24
163954	1121812	2023-09-12 10:38:25
163955	1121810	2023-09-12 10:38:43
163957	1121795	2023-09-12 10:40:28
163960	1121779	2023-09-12 10:41:38
163962	1121769	2023-09-12 10:42:05
163963	1121754	2023-09-12 10:44:05
163968	1121721	2023-09-12 10:45:09
163971	1121717	2023-09-12 10:47:00
163972	1121717	2023-09-12 10:47:00
163978	1121706	2023-09-12 10:48:19
163982	1121667	2023-09-12 10:51:33
163983	1121667	2023-09-12 10:51:33
163984	1121667	2023-09-12 10:51:33
163987	1121656	2023-09-12 10:53:03
163989	1121636	2023-09-12 10:54:06
163990	1121617	2023-09-12 10:54:30
163991	1121598	2023-09-12 10:55:17
163993	1121546	2023-09-12 10:57:10
164007	1123148	2023-09-12 11:19:25
164008	1123143	2023-09-12 11:20:12
164010	1123034	2023-09-12 11:24:17
164012	1123010	2023-09-12 11:26:37
164018	1122850	2023-09-12 11:36:54
164026	1122801	2023-09-12 11:40:27
164028	1122792	2023-09-12 11:41:06
164029	1122791	2023-09-12 11:41:32
164041	1122520	2023-09-12 11:56:00
164043	1122518	2023-09-12 11:56:53
164044	1122491	2023-09-12 11:58:06
164045	1122490	2023-09-12 11:58:55
164046	1122489	2023-09-12 11:59:22
164049	1122483	2023-09-12 12:02:10
164050	1122479	2023-09-12 12:02:51
164051	1122467	2023-09-12 12:03:52
164053	1122457	2023-09-12 12:04:37
164054	1122452	2023-09-12 12:05:01
164055	1122435	2023-09-12 12:07:09
164056	1122434	2023-09-12 12:07:49
164059	1122336	2023-09-12 12:11:31
164061	1122268	2023-09-12 12:21:04
164062	1122266	2023-09-12 12:22:02
164064	1122244	2023-09-12 12:23:06
164067	1122082	2023-09-12 12:29:47
164068	1122081	2023-09-12 12:30:12
164069	1122080	2023-09-12 12:30:37
164070	1122053	2023-09-12 12:38:42
164071	1122024	2023-09-12 12:40:09
164073	1122014	2023-09-12 12:44:05
164074	1122005	2023-09-12 12:44:45
164075	1121991	2023-09-12 12:45:20
164077	1121973	2023-09-12 12:46:40
164078	1121968	2023-09-12 12:47:17
164079	1121916	2023-09-12 12:49:22
164080	1121864	2023-09-12 12:50:21
164082	1121768	2023-09-12 12:53:35
164083	1121755	2023-09-12 12:54:08
164084	1121742	2023-09-12 12:55:29
164085	1121731	2023-09-12 12:56:44
164086	1121719	2023-09-12 12:57:24
164087	1121709	2023-09-12 12:58:37
164089	1121704	2023-09-12 12:59:49
164090	1121662	2023-09-15 12:55:19
164091	1121654	2023-09-12 13:03:59
164092	1121616	2023-09-12 13:05:12
164096	1121587	2023-09-12 13:09:48
164097	1121583	2023-09-12 13:10:33
164098	1121573	2023-09-12 13:10:55
164099	1121545	2023-09-12 13:11:40
164259	1120920	2023-09-13 12:48:47
164263	1120877	2023-09-13 12:53:59
164265	1120834	2023-09-13 13:00:33
164266	1120834	2023-09-13 13:00:33
164275	1120722	2023-09-13 13:11:53
164279	1120541	2023-09-13 13:19:26
164281	1120523	2023-09-13 13:23:15
164284	1120522	2023-09-13 13:27:01
164285	1120522	2023-09-13 13:27:01
164293	1120515	2023-09-13 13:31:11
164415	1120485	2023-09-13 17:03:42
164416	1120628	2023-09-13 17:03:58
164417	1120787	2023-09-13 17:06:28
164418	1120787	2023-09-13 17:06:47
164419	1120627	2023-09-13 17:08:07
164420	1120615	2023-09-13 17:09:38
164421	1120484	2023-09-13 17:10:57
164422	1120484	2023-09-13 17:10:57
164423	1120484	2023-09-13 17:10:57
164424	1120610	2023-09-13 17:11:26
164425	1120398	2023-09-13 17:13:02
164426	1120621	2023-09-13 17:13:40
164427	1120629	2023-09-13 17:14:09
164428	1120613	2023-09-13 17:15:03
164429	1120622	2023-09-13 17:16:05
164430	1120418	2023-09-13 17:17:17
164431	1120915	2023-09-13 17:18:02
164432	1120751	2023-09-13 17:18:31
164433	1120779	2023-09-13 17:19:42
164434	1120405	2023-09-13 17:20:14
164435	1120452	2023-09-13 17:22:07
164438	1120905	2023-09-13 19:27:44
164439	1120901	2023-09-13 19:32:58
164440	1120886	2023-09-13 19:34:17
164445	1120759	2023-09-13 19:47:25
164446	1120759	2023-09-13 19:48:05
164447	1120759	2023-09-13 19:48:28
164448	1120752	2023-09-13 19:49:51
164449	1120623	2023-09-13 19:53:12
164450	1120611	2023-09-13 19:54:27
164451	1120500	2023-09-13 19:55:29
164788	1121001	2023-09-15 12:49:44
\.


--
-- Data for Name: report_data_field; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report_data_field (id, name, description, report_data_field_type_id, last_updated) FROM stdin;
3	publication-date	The publication date of an article	3	2021-01-26 12:13:59
4	event-date	The date the event / outbreak was first reported	3	2021-01-26 12:13:59
\.


--
-- Data for Name: report_data_field_type; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report_data_field_type (id, name, description, last_updated) FROM stdin;
1	text	Normal text input	2021-01-26 12:13:58
3	date	Use a calendar widget to insert data	2021-01-26 12:13:58
4	textarea	Use a larger textbox to insert data	2021-01-26 12:13:58
\.


--
-- Data for Name: report_data_point; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report_data_point (id, report_id, report_data_field_id, value) FROM stdin;
549102	162122	3	2023-09-01
548776	162030	3	2023-09-01
548904	162057	3	2023-09-01
548907	162058	3	2023-09-01
548910	162059	3	2023-09-01
548919	162062	3	2023-09-01
548922	162063	3	2023-09-01
548925	162064	3	2023-09-01
548928	162065	3	2023-09-01
548931	162066	3	2023-09-01
548934	162067	3	2023-09-01
548937	162068	3	2023-09-01
548941	162069	3	2023-09-01
548944	162070	3	2023-09-01
548947	162071	3	2023-09-01
548950	162072	3	2023-09-01
548953	162073	3	2023-09-01
548956	162074	3	2023-09-01
548959	162075	3	2023-09-01
548962	162076	3	2023-09-01
548965	162077	3	2023-09-01
548968	162078	3	2023-09-01
549120	162128	3	2023-09-01
548971	162079	3	2023-09-01
548974	162080	3	2023-09-01
548977	162081	3	2023-09-01
548980	162082	3	2023-09-01
548983	162083	3	2023-09-01
548986	162084	3	2023-09-01
548989	162085	3	2023-09-01
548992	162086	3	2023-09-01
548995	162087	3	2023-09-01
548998	162088	3	2023-09-01
549001	162089	3	2023-09-01
549004	162090	3	2023-09-01
549007	162091	3	2023-09-01
549010	162092	3	2023-09-01
549013	162093	3	2023-09-01
549016	162094	3	2023-09-01
549019	162095	3	2023-09-01
549022	162096	3	2023-09-01
549025	162097	3	2023-09-01
549028	162098	3	2023-09-01
549031	162099	3	2023-09-01
549034	162100	3	2023-09-01
549037	162101	3	2023-09-01
549040	162102	3	2023-09-01
549043	162103	3	2023-09-01
549046	162104	3	2023-09-01
549049	162105	3	2023-09-01
549052	162106	3	2023-09-01
549055	162107	3	2023-09-01
549058	162108	3	2023-09-01
549061	162109	3	2023-09-01
549064	162110	3	2023-09-01
549068	162111	3	2023-09-01
549072	162112	3	2023-09-01
549075	162113	3	2023-09-01
549078	162114	3	2023-09-01
549081	162115	3	2023-09-01
549084	162116	3	2023-09-01
549087	162117	3	2023-09-01
549090	162118	3	2023-09-01
549093	162119	3	2023-09-01
549096	162120	3	2023-09-01
549099	162121	3	2023-09-01
549105	162123	3	2023-09-01
549108	162124	3	2023-09-01
549111	162125	3	2023-09-01
549114	162126	3	2023-09-01
549117	162127	3	2023-09-01
549123	162129	3	2023-09-01
549126	162130	3	2023-09-01
549129	162131	3	2023-09-01
549132	162132	3	2023-09-01
549135	162133	3	2023-09-01
549138	162134	3	2023-09-01
549141	162135	3	2023-09-01
549144	162136	3	2023-09-01
549150	162138	3	2023-09-01
549153	162139	3	2023-09-01
549156	162140	3	2023-09-01
549159	162141	3	2023-09-01
549162	162142	3	2023-09-01
549165	162143	3	2023-09-01
549168	162144	3	2023-09-01
549171	162145	3	2023-09-01
549174	162146	3	2023-09-01
549177	162147	3	2023-09-01
549180	162148	3	2023-09-01
549361	162208	3	2023-09-01
549183	162149	3	2023-09-01
549186	162150	3	2023-09-01
549189	162151	3	2023-09-01
549192	162152	3	2023-09-01
549195	162153	3	2023-09-01
549198	162154	3	2023-09-01
549201	162155	3	2023-09-01
549204	162156	3	2023-09-01
549207	162157	3	2023-09-01
549210	162158	3	2023-09-01
549213	162159	3	2023-09-01
549216	162160	3	2023-09-01
549219	162161	3	2023-09-01
549222	162162	3	2023-09-01
549225	162163	3	2023-09-01
549228	162164	3	2023-09-01
549231	162165	3	2023-09-01
549234	162166	3	2023-09-01
549237	162167	3	2023-09-01
549240	162168	3	2023-09-01
549243	162169	3	2023-09-01
549246	162170	3	2023-09-01
549249	162171	3	2023-09-01
549252	162172	3	2023-09-01
549255	162173	3	2023-09-01
549262	162175	3	2023-09-01
549265	162176	3	2023-09-01
549268	162177	3	2023-09-01
549271	162178	3	2023-09-01
549274	162179	3	2023-09-01
549453	162238	3	2023-09-01
549277	162180	3	2023-09-01
549280	162181	3	2023-09-01
549283	162182	3	2023-09-01
549292	162185	3	2023-09-01
549295	162186	3	2023-09-01
549298	162187	3	2023-09-01
549301	162188	3	2023-09-01
549304	162189	3	2023-09-01
549307	162190	3	2023-09-01
549310	162191	3	2023-09-01
549313	162192	3	2023-09-01
549316	162193	3	2023-09-01
549319	162194	3	2023-09-01
549322	162195	3	2023-09-01
549325	162196	3	2023-09-01
549328	162197	3	2023-09-01
549331	162198	3	2023-09-01
549337	162200	3	2023-09-01
549340	162201	3	2023-09-01
549343	162202	3	2023-09-01
549346	162203	3	2023-09-01
549349	162204	3	2023-09-01
549364	162209	3	2023-09-01
549367	162210	3	2023-09-01
549370	162211	3	2023-09-01
549373	162212	3	2023-09-01
549376	162213	3	2023-09-01
549379	162214	3	2023-09-01
549382	162215	3	2023-09-01
549385	162216	3	2023-09-01
549388	162217	3	2023-09-01
549391	162218	3	2023-09-01
549397	162220	3	2023-09-01
549400	162221	3	2023-09-01
549403	162222	3	2023-09-01
549407	162223	3	2023-09-01
549417	162226	3	2023-09-01
549420	162227	3	2023-09-01
549423	162228	3	2023-09-01
549426	162229	3	2023-09-01
549429	162230	3	2023-09-01
549432	162231	3	2023-09-01
549435	162232	3	2023-09-01
549438	162233	3	2023-09-01
549441	162234	3	2023-09-01
549679	162311	3	2023-09-01
549444	162235	3	2023-09-01
549447	162236	3	2023-09-01
549450	162237	3	2023-09-01
549456	162239	3	2023-09-01
549460	162240	3	2023-09-01
549463	162241	3	2023-09-01
549466	162242	3	2023-09-01
549469	162243	3	2023-09-01
549472	162244	3	2023-09-01
549475	162245	3	2023-09-01
549478	162246	3	2023-09-01
549484	162248	3	2023-09-01
549487	162249	3	2023-09-01
549490	162250	3	2023-09-01
549493	162251	3	2023-09-01
549496	162252	3	2023-09-01
549499	162253	3	2023-09-01
549502	162254	3	2023-09-01
549505	162255	3	2023-09-01
549508	162256	3	2023-09-01
549511	162257	3	2023-09-01
549976	162410	3	2023-09-02
549514	162258	3	2023-09-01
549517	162259	3	2023-09-01
549520	162260	3	2023-09-01
549523	162261	3	2023-09-01
549527	162262	3	2023-09-01
549611	162289	3	2023-09-01
549533	162264	3	2023-09-01
549536	162265	3	2023-09-01
549539	162266	3	2023-09-01
549542	162267	3	2023-09-01
549545	162268	3	2023-09-01
549549	162269	3	2023-09-01
549553	162270	3	2023-09-01
549556	162271	3	2023-09-01
549559	162272	3	2023-09-01
549562	162273	3	2023-09-01
549565	162274	3	2023-09-01
549568	162275	3	2023-09-01
549571	162276	3	2023-09-01
549574	162277	3	2023-09-01
549577	162278	3	2023-09-01
549580	162279	3	2023-09-01
549584	162280	3	2023-09-01
549587	162281	3	2023-09-01
549590	162282	3	2023-09-01
549593	162283	3	2023-09-01
549596	162284	3	2023-09-01
549599	162285	3	2023-09-01
549602	162286	3	2023-09-01
549605	162287	3	2023-09-01
549608	162288	3	2023-09-01
549614	162290	3	2023-09-01
549617	162291	3	2023-09-01
549620	162292	3	2023-09-01
549623	162293	3	2023-09-01
549626	162294	3	2023-09-01
549629	162295	3	2023-09-01
549632	162296	3	2023-09-01
549635	162297	3	2023-09-01
549638	162298	3	2023-09-01
549641	162299	3	2023-09-01
549644	162300	3	2023-09-01
549650	162302	3	2023-09-01
549653	162303	3	2023-09-01
549656	162304	3	2023-09-01
549659	162305	3	2023-09-01
549662	162306	3	2023-09-01
549669	162308	3	2023-09-01
549673	162309	3	2023-09-01
549676	162310	3	2023-09-01
549682	162312	3	2023-09-01
549685	162313	3	2023-09-01
549688	162314	3	2023-09-01
549691	162315	3	2023-09-01
549775	162343	3	2023-09-02
549697	162317	3	2023-09-01
549700	162318	3	2023-09-01
549703	162319	3	2023-09-01
549706	162320	3	2023-09-01
549709	162321	3	2023-09-01
549712	162322	3	2023-09-01
549715	162323	3	2023-09-01
549718	162324	3	2023-09-01
549721	162325	3	2023-09-01
549724	162326	3	2023-09-01
549730	162328	3	2023-09-02
549733	162329	3	2023-09-02
549736	162330	3	2023-09-02
549739	162331	3	2023-09-02
549742	162332	3	2023-09-02
549745	162333	3	2023-09-02
549748	162334	3	2023-09-02
549751	162335	3	2023-09-02
549754	162336	3	2023-09-02
549757	162337	3	2023-09-02
549760	162338	3	2023-09-02
549766	162340	3	2023-09-02
549769	162341	3	2023-09-02
549772	162342	3	2023-09-02
549778	162344	3	2023-09-02
549781	162345	3	2023-09-02
549784	162346	3	2023-09-02
549787	162347	3	2023-09-02
549790	162348	3	2023-09-02
549793	162349	3	2023-09-02
549796	162350	3	2023-09-02
549799	162351	3	2023-09-02
549802	162352	3	2023-09-02
549805	162353	3	2023-09-02
549808	162354	3	2023-09-02
549811	162355	3	2023-09-02
549814	162356	3	2023-09-02
549817	162357	3	2023-09-02
549820	162358	3	2023-09-02
549823	162359	3	2023-09-02
549826	162360	3	2023-09-02
549829	162361	3	2023-09-02
549832	162362	3	2023-09-02
549835	162363	3	2023-09-02
549838	162364	3	2023-09-02
549841	162365	3	2023-09-02
549844	162366	3	2023-09-02
549847	162367	3	2023-09-02
549850	162368	3	2023-09-02
549853	162369	3	2023-09-02
549856	162370	3	2023-09-02
549859	162371	3	2023-09-02
549862	162372	3	2023-09-02
549865	162373	3	2023-09-02
549868	162374	3	2023-09-02
549871	162375	3	2023-09-02
549874	162376	3	2023-09-02
549877	162377	3	2023-09-02
549880	162378	3	2023-09-02
549883	162379	3	2023-09-02
549886	162380	3	2023-09-02
549889	162381	3	2023-09-02
549892	162382	3	2023-09-02
549895	162383	3	2023-09-02
549901	162385	3	2023-09-02
549904	162386	3	2023-09-02
549907	162387	3	2023-09-02
549910	162388	3	2023-09-02
549913	162389	3	2023-09-02
549916	162390	3	2023-09-02
549919	162391	3	2023-09-02
549922	162392	3	2023-09-02
549925	162393	3	2023-09-02
549928	162394	3	2023-09-02
549931	162395	3	2023-09-02
549934	162396	3	2023-09-02
549937	162397	3	2023-09-02
549940	162398	3	2023-09-02
549943	162399	3	2023-09-02
549946	162400	3	2023-09-02
549949	162401	3	2023-09-02
549952	162402	3	2023-09-02
549955	162403	3	2023-09-02
549958	162404	3	2023-09-02
549961	162405	3	2023-09-02
549967	162407	3	2023-09-02
549970	162408	3	2023-09-02
549973	162409	3	2023-09-02
549979	162411	3	2023-09-02
549982	162412	3	2023-09-02
549985	162413	3	2023-09-02
549988	162414	3	2023-09-02
549991	162415	3	2023-09-02
549994	162416	3	2023-09-02
549997	162417	3	2023-09-02
550000	162418	3	2023-09-02
550003	162419	3	2023-09-02
550006	162420	3	2023-09-02
550009	162421	3	2023-09-02
550012	162422	3	2023-09-02
550015	162423	3	2023-09-02
550018	162424	3	2023-09-02
550021	162425	3	2023-09-02
550024	162426	3	2023-09-02
550027	162427	3	2023-09-02
550030	162428	3	2023-09-02
550033	162429	3	2023-09-02
550036	162430	3	2023-09-02
550039	162431	3	2023-09-02
550042	162432	3	2023-09-02
550045	162433	3	2023-09-02
550048	162434	3	2023-09-02
550051	162435	3	2023-09-02
550054	162436	3	2023-09-02
550057	162437	3	2023-09-02
550060	162438	3	2023-09-02
550063	162439	3	2023-09-02
550066	162440	3	2023-09-02
550069	162441	3	2023-09-02
550072	162442	3	2023-09-02
550075	162443	3	2023-09-02
550078	162444	3	2023-09-02
550081	162445	3	2023-09-02
550087	162447	3	2023-09-02
550093	162449	3	2023-09-02
550096	162450	3	2023-09-02
550099	162451	3	2023-09-02
550102	162452	3	2023-09-02
550105	162453	3	2023-09-02
550108	162454	3	2023-09-02
550111	162455	3	2023-09-02
550114	162456	3	2023-09-02
550120	162458	3	2023-09-02
550123	162459	3	2023-09-02
550126	162460	3	2023-09-02
550129	162461	3	2023-09-02
550132	162462	3	2023-09-02
550135	162463	3	2023-09-02
550138	162464	3	2023-09-02
550141	162465	3	2023-09-02
550144	162466	3	2023-09-02
550150	162468	3	2023-09-02
550153	162469	3	2023-09-02
550156	162470	3	2023-09-02
550159	162471	3	2023-09-02
550162	162472	3	2023-09-02
550165	162473	3	2023-09-02
550168	162474	3	2023-09-02
550171	162475	3	2023-09-02
550174	162476	3	2023-09-02
550177	162477	3	2023-09-02
550180	162478	3	2023-09-02
550183	162479	3	2023-09-02
550186	162480	3	2023-09-02
550189	162481	3	2023-09-02
550192	162482	3	2023-09-02
550195	162483	3	2023-09-02
550198	162484	3	2023-09-02
550201	162485	3	2023-09-02
550204	162486	3	2023-09-02
550207	162487	3	2023-09-02
550210	162488	3	2023-09-02
550213	162489	3	2023-09-02
550216	162490	3	2023-09-02
550219	162491	3	2023-09-02
550222	162492	3	2023-09-01
550223	162492	4	2023-09-01
550227	162493	3	2023-09-03
550228	162493	4	2023-09-03
550232	162494	3	2023-09-03
550233	162494	4	2023-09-03
550237	162495	3	2023-09-03
550238	162495	4	2023-09-02
550257	162499	3	2023-09-03
550258	162499	4	2023-09-03
550272	162502	3	2023-09-03
550273	162502	4	2023-09-02
550297	162507	3	2023-09-03
550298	162507	4	2023-09
550302	162508	3	2023-09-03
550303	162508	4	2023-09
550307	162509	3	2023-09-03
550308	162509	4	2023-09
550322	162512	3	2023-09-03
550323	162512	4	2023-09
550332	162514	3	2023-09-03
550333	162514	4	2023-09
550342	162516	3	2023-09-03
550343	162516	4	2023-09
550347	162517	3	2023-09-03
550348	162517	4	2023-09-03
550377	162523	3	2023-09-03
550378	162523	4	2023-09
550382	162524	3	2023-09-03
550383	162524	4	2023-09-03
550397	162527	3	2023-09-03
550398	162527	4	2023-09
550422	162532	3	2023-09-03
550423	162532	4	2023-09-03
550432	162534	3	2023-09-03
550433	162534	4	2023-09-03
550437	162535	3	2023-09-03
550438	162535	4	2023-09-03
550457	162539	3	2023-09-03
550458	162539	4	2023-09-02
550462	162540	3	2023-09-03
550463	162540	4	2023-09-03
550467	162541	3	2023-09-03
550468	162541	4	2023-09
550472	162542	3	2023-09-03
550473	162542	4	2023-09
550477	162543	3	2023-09-03
550478	162543	4	2023-09-03
550507	162549	3	2023-09-01
550508	162549	4	2023-09-01
550512	162550	3	2023-09-01
550513	162550	4	2023-09-01
550517	162551	3	2023-09-03
550518	162551	4	2023-09-03
550607	162569	3	2023-09-03
550522	162552	3	2023-09-03
550523	162552	4	2023-09
550527	162553	3	2023-09-03
550528	162553	4	2023-09
550537	162555	3	2023-09-03
550538	162555	4	2023-09
550547	162557	3	2023-09-03
550548	162557	4	2023-09
550562	162560	3	2023-09-03
550563	162560	4	2023-09-03
550572	162562	3	2023-09-03
550573	162562	4	2023-09
550587	162565	3	2023-09-03
550588	162565	4	2023-09-03
550602	162568	3	2023-09-03
550603	162568	4	2023-09-03
550608	162569	4	2023-09-03
550632	162574	3	2023-09-03
550633	162574	4	2023-09-02
550637	162575	3	2023-09-03
550638	162575	4	2023-09-01
550642	162576	3	2023-09-03
550643	162576	4	2023-09-03
550652	162578	3	2023-09-03
550653	162578	4	2023-09
550657	162579	3	2023-09-03
550658	162579	4	2023-09
550662	162580	3	2023-09-03
550663	162580	4	2023-09
550667	162581	3	2023-09-03
550668	162581	4	2023-09
550722	162592	3	2023-09-03
550723	162592	4	2023-09
550727	162593	3	2023-09-03
550728	162593	4	2023-09
550732	162594	3	2023-09-03
550733	162594	4	2023-09
550742	162596	3	2023-09-03
550743	162596	4	2023-09-03
550752	162598	3	2023-09-03
550753	162598	4	2023-09
550757	162599	3	2023-09-03
550758	162599	4	2023-09-03
550767	162601	3	2023-09-03
550768	162601	4	2023-09
550772	162602	3	2023-09-03
550773	162602	4	2023-09
550777	162603	3	2023-09-03
550778	162603	4	2023-09
550782	162604	3	2023-09-01
550783	162604	4	2023-09-01
550787	162605	3	2023-09-03
550788	162605	4	2023-09
550792	162606	3	2023-09-03
550793	162606	4	2023-09
550973	162642	4	2023-09
550797	162607	3	2023-09-03
550798	162607	4	2023-09
550802	162608	3	2023-09-03
550803	162608	4	2023-09-03
550807	162609	3	2023-09-03
550808	162609	4	2023-09
550812	162610	3	2023-09-03
550813	162610	4	2023-09-03
550817	162611	3	2023-09-03
550818	162611	4	2023-09
550822	162612	3	2023-09-03
550823	162612	4	2023-09-03
550827	162613	3	2023-09-03
550828	162613	4	2023-09
550832	162614	3	2023-09-03
550833	162614	4	2023-09
550837	162615	3	2023-09-03
550838	162615	4	2023-09-03
550842	162616	3	2023-09-03
550843	162616	4	2023-09
550852	162618	3	2023-09-03
550853	162618	4	2023-09
550862	162620	3	2023-09-03
550863	162620	4	2023-09-02
550867	162621	3	2023-09-03
550868	162621	4	2023-09-02
550872	162622	3	2023-09-03
550873	162622	4	2023-09-02
550882	162624	3	2023-09-03
550883	162624	4	2023-09-02
550887	162625	3	2023-09-03
550888	162625	4	2023-09
550897	162627	3	2023-09-03
550898	162627	4	2023-09-02
550902	162628	3	2023-09-03
550903	162628	4	2023-09-03
550907	162629	3	2023-09-03
550908	162629	4	2023-09
550912	162630	3	2023-09-03
550913	162630	4	2023-09
550917	162631	3	2023-09-03
550918	162631	4	2023-09
550922	162632	3	2023-09-03
550923	162632	4	2023-09-03
550932	162634	3	2023-09-03
550933	162634	4	2023-09
550942	162636	3	2023-09-03
550943	162636	4	2023-09
550947	162637	3	2023-09-03
550948	162637	4	2023-09-03
550952	162638	3	2023-09-03
550953	162638	4	2023-09
550957	162639	3	2023-09-03
550958	162639	4	2023-09
550962	162640	3	2023-09-03
550963	162640	4	2023-09
550967	162641	3	2023-09-03
550968	162641	4	2023-09
550972	162642	3	2023-09-03
550977	162643	3	2023-09-03
550978	162643	4	2023-09
550987	162645	3	2023-09-03
550988	162645	4	2023-09
550992	162646	3	2023-09-03
550993	162646	4	2023-09-03
550997	162647	3	2023-09-03
550998	162647	4	2023-09
551002	162648	3	2023-09-03
551003	162648	4	2023-09-03
551007	162649	3	2023-09-03
551008	162649	4	2023-09
551012	162650	3	2023-09-03
551013	162650	4	2023-09
551017	162651	3	2023-09-03
551018	162651	4	2023-09
551022	162652	3	2023-09-03
551023	162652	4	2023-09-03
551032	162654	3	2023-09-03
551033	162654	4	2023-09
551037	162655	3	2023-09-03
551038	162655	4	2023-09-03
551042	162656	3	2023-09-03
551043	162656	4	2023-09
551047	162657	3	2023-09-03
551048	162657	4	2023-09
551052	162658	3	2023-09-03
551053	162658	4	2023-09
551057	162659	3	2023-09-03
551058	162659	4	2023-09
551067	162661	3	2023-09-03
551068	162661	4	2023-09
551072	162662	3	2023-09-03
551073	162662	4	2023-09
551077	162663	3	2023-09-03
551078	162663	4	2023-09
551082	162664	3	2023-09-03
551083	162664	4	2023-09
551087	162665	3	2023-09-03
551088	162665	4	2023-09
551102	162668	3	2023-09-03
551103	162668	4	2023-09
551107	162669	3	2023-09-03
551108	162669	4	2023-09
551112	162670	3	2023-09-03
551113	162670	4	2023-09
551117	162671	3	2023-09-03
551118	162671	4	2023-09
551122	162672	3	2023-09-03
551123	162672	4	2023-09
551127	162673	3	2023-09-03
551128	162673	4	2023-09
551132	162674	3	2023-09-03
551133	162674	4	2023-09
551137	162675	3	2023-09-03
551140	162676	3	2023-09-04
551143	162677	3	2023-09-04
551146	162678	3	2023-09-04
551149	162679	3	2023-09-04
551152	162680	3	2023-09-04
551155	162681	3	2023-09-04
551158	162682	3	2023-09-04
551161	162683	3	2023-09-04
551164	162684	3	2023-09-04
551167	162685	3	2023-09-04
551173	162687	3	2023-09-04
551176	162688	3	2023-09-04
551179	162689	3	2023-09-04
551182	162690	3	2023-09-04
551185	162691	3	2023-09-04
551188	162692	3	2023-09-04
551191	162693	3	2023-09-04
551194	162694	3	2023-09-04
551197	162695	3	2023-09-04
551200	162696	3	2023-09-04
551203	162697	3	2023-09-04
551206	162698	3	2023-09-04
551209	162699	3	2023-09-04
551212	162700	3	2023-09-04
551215	162701	3	2023-09-04
551218	162702	3	2023-09-04
551221	162703	3	2023-09-04
551224	162704	3	2023-09-04
551227	162705	3	2023-09-04
551230	162706	3	2023-09-04
551308	162732	3	2023-09-04
551233	162707	3	2023-09-04
551236	162708	3	2023-09-04
551239	162709	3	2023-09-04
551242	162710	3	2023-09-04
551245	162711	3	2023-09-04
551248	162712	3	2023-09-04
551251	162713	3	2023-09-04
551254	162714	3	2023-09-04
551257	162715	3	2023-09-04
551263	162717	3	2023-09-04
551266	162718	3	2023-09-04
551269	162719	3	2023-09-04
551272	162720	3	2023-09-04
551275	162721	3	2023-09-04
551278	162722	3	2023-09-04
551281	162723	3	2023-09-04
551284	162724	3	2023-09-04
551287	162725	3	2023-09-04
551365	162751	3	2023-09-04
551290	162726	3	2023-09-04
551293	162727	3	2023-09-04
551296	162728	3	2023-09-04
551299	162729	3	2023-09-04
551302	162730	3	2023-09-04
551305	162731	3	2023-09-04
551311	162733	3	2023-09-04
551314	162734	3	2023-09-04
551317	162735	3	2023-09-04
551320	162736	3	2023-09-04
551323	162737	3	2023-09-04
551326	162738	3	2023-09-04
551329	162739	3	2023-09-04
551332	162740	3	2023-09-04
551335	162741	3	2023-09-04
551338	162742	3	2023-09-04
551341	162743	3	2023-09-04
551344	162744	3	2023-09-04
551347	162745	3	2023-09-04
551350	162746	3	2023-09-04
551353	162747	3	2023-09-04
551356	162748	3	2023-09-04
551359	162749	3	2023-09-04
551362	162750	3	2023-09-04
551597	162822	3	2023-09-04
551368	162752	3	2023-09-04
551371	162753	3	2023-09-04
551374	162754	3	2023-09-04
551377	162755	3	2023-09-04
551380	162756	3	2023-09-04
551383	162757	3	2023-09-04
551386	162758	3	2023-09-04
551389	162759	3	2023-09-04
551392	162760	3	2023-09-04
551395	162761	3	2023-09-04
551398	162762	3	2023-09-04
551401	162763	3	2023-09-04
551404	162764	3	2023-09-04
551407	162765	3	2023-09-04
551410	162766	3	2023-09-04
551413	162767	3	2023-09-04
551416	162768	3	2023-09-04
551419	162769	3	2023-09-04
551422	162770	3	2023-09-04
551425	162771	3	2023-09-04
551428	162772	3	2023-09-04
551431	162773	3	2023-09-04
551432	162773	4	2023-09
551436	162774	3	2023-09-04
551439	162775	3	2023-09-04
551445	162777	3	2023-09-04
551452	162779	3	2023-09-04
551453	162779	4	2023-09-02
551460	162781	3	2023-09-04
551463	162782	3	2023-09-04
551466	162783	3	2023-09-04
551469	162784	3	2023-09-04
551472	162785	3	2023-09-04
551475	162786	3	2023-09-04
551478	162787	3	2023-09-04
551481	162788	3	2023-09-04
551484	162789	3	2023-09-04
551487	162790	3	2023-09-04
551490	162791	3	2023-09-04
551491	162791	4	2023-09-03
551502	162794	3	2023-09-04
551503	162794	4	2023-09-03
551510	162796	3	2023-09-04
551513	162797	3	2023-09-04
551520	162799	3	2023-09-04
551526	162801	3	2023-09-04
551529	162802	3	2023-09-04
551532	162803	3	2023-09-04
551535	162804	3	2023-09-04
551538	162805	3	2023-09-04
551539	162805	4	2023-09-03
551542	162806	3	2023-09-04
551543	162806	4	2023-09-03
551546	162807	3	2023-09-04
551553	162809	3	2023-09-04
551556	162810	3	2023-09-04
551559	162811	3	2023-09-04
551562	162812	3	2023-09-04
551563	162812	4	2023-09
551566	162813	3	2023-09-04
551569	162814	3	2023-09-04
551570	162814	4	2023-09
551573	162815	3	2023-09-04
551574	162815	4	2023-09
551577	162816	3	2023-09-04
551578	162816	4	2023-09-03
551581	162817	3	2023-09-04
551582	162817	4	2023-09
551585	162818	3	2023-09-04
551588	162819	3	2023-09-04
551591	162820	3	2023-09-04
551594	162821	3	2023-09-04
551600	162823	3	2023-09-04
551603	162824	3	2023-09-04
551606	162825	3	2023-09-04
551609	162826	3	2023-09-04
551612	162827	3	2023-09-04
551615	162828	3	2023-09-04
551618	162829	3	2023-09-04
551621	162830	3	2023-09-04
551624	162831	3	2023-09-04
551627	162832	3	2023-09-04
551630	162833	3	2023-09-04
551631	162833	4	2023-09
551634	162834	3	2023-09-04
551637	162835	3	2023-09-04
551640	162836	3	2023-09-04
551641	162836	4	2023-09-01
551644	162837	3	2023-09-04
551645	162837	4	2023-09-03
551651	162839	3	2023-09-04
551654	162840	3	2023-09-04
551657	162841	3	2023-09-04
551660	162842	3	2023-09-04
551664	162843	3	2023-09-04
551665	162843	4	2023-09
551668	162844	3	2023-09-04
551671	162845	3	2023-09-04
551674	162846	3	2023-09-04
551677	162847	3	2023-09-04
551683	162849	3	2023-09-04
551686	162850	3	2023-09-04
551687	162850	4	2023-09-02
551690	162851	3	2023-09-04
551693	162852	3	2023-09-04
551696	162853	3	2023-09-04
551699	162854	3	2023-09-04
551702	162855	3	2023-09-04
551705	162856	3	2023-09-04
551708	162857	3	2023-09-04
551711	162858	3	2023-09-04
551714	162859	3	2023-09-04
551717	162860	3	2023-09-04
551720	162861	3	2023-09-04
551723	162862	3	2023-09-04
551726	162863	3	2023-09-04
551729	162864	3	2023-09-04
551736	162866	3	2023-09-04
551740	162867	3	2023-09-04
551743	162868	3	2023-09-04
551746	162869	3	2023-09-04
551749	162870	3	2023-09-04
551760	162873	3	2023-09-04
551764	162874	3	2023-09-04
551767	162875	3	2023-09-04
551770	162876	3	2023-09-04
551773	162877	3	2023-09-04
551776	162878	3	2023-09-04
551779	162879	3	2023-09-04
551782	162880	3	2023-09-04
551785	162881	3	2023-09-04
551788	162882	3	2023-09-04
551791	162883	3	2023-09-04
551794	162884	3	2023-09-04
551801	162886	3	2023-09-04
551804	162887	3	2023-09-04
551807	162888	3	2023-09-04
551810	162889	3	2023-09-04
551813	162890	3	2023-09-04
551816	162891	3	2023-09-04
551819	162892	3	2023-09-04
551826	162894	3	2023-09-04
551829	162895	3	2023-09-04
551832	162896	3	2023-09-04
551835	162897	3	2023-09-04
551838	162898	3	2023-09-04
551841	162899	3	2023-09-04
551845	162900	3	2023-09-04
551846	162900	4	2023-09
551849	162901	3	2023-09-05
551850	162901	4	2023-09
551857	162903	3	2023-09-05
551858	162903	4	2023-09
551869	162905	3	2023-09-05
551870	162905	4	2023-09
551873	162906	3	2023-09-05
551874	162906	4	2023-09
551877	162907	3	2023-09-05
551878	162907	4	2023-09
551881	162908	3	2023-09-05
551882	162908	4	2023-09
551885	162909	3	2023-09-05
551886	162909	4	2023-09
551889	162910	3	2023-09-05
551890	162910	4	2023-09
551894	162911	3	2023-09-05
551895	162911	4	2023-09
551898	162912	3	2023-09-05
551899	162912	4	2023-09
551902	162913	3	2023-09-05
551906	162914	3	2023-09-05
551909	162915	3	2023-09-05
551913	162916	3	2023-09-05
551914	162916	4	2023-09
551917	162917	3	2023-09-05
551918	162917	4	2023-09
551921	162918	3	2023-09-05
551922	162918	4	2023-09
551925	162919	3	2023-09-05
551926	162919	4	2023-09
551929	162920	3	2023-09-05
551930	162920	4	2023-09
551933	162921	3	2023-09-05
551936	162922	3	2023-09-05
551937	162922	4	2023-09
551940	162923	3	2023-09-05
551941	162923	4	2023-09
551944	162924	3	2023-09-05
551945	162924	4	2023-09
551948	162925	3	2023-09-05
551949	162925	4	2023-09
551953	162926	3	2023-09-05
551954	162926	4	2023-09
551957	162927	3	2023-09-05
551958	162927	4	2023-09
551961	162928	3	2023-09-05
551965	162929	3	2023-09-05
551969	162930	3	2023-09-05
551973	162931	3	2023-09-05
551977	162932	3	2023-09-05
551981	162933	3	2023-09-05
551985	162934	3	2023-09-05
551989	162935	3	2023-09-05
551990	162935	4	2023-09
551993	162936	3	2023-09-05
551994	162936	4	2023-09
551997	162937	3	2023-09-05
551998	162937	4	2023-09
552002	162938	3	2023-09-05
552003	162938	4	2023-09
552007	162939	3	2023-09-05
552011	162940	3	2023-09-05
552012	162940	4	2023-09
552015	162941	3	2023-09-05
552016	162941	4	2023-09
552019	162942	3	2023-09-05
552020	162942	4	2023-09
552023	162943	3	2023-09-05
552024	162943	4	2023-09-04
552030	162945	3	2023-09-05
552033	162946	3	2023-09-05
552034	162946	4	2023-09
552037	162947	3	2023-09-05
552040	162948	3	2023-09-05
552130	162972	4	2023-09
552043	162949	3	2023-09-05
552044	162949	4	2023-09
552047	162950	3	2023-09-05
552048	162950	4	2023-09
552051	162951	3	2023-09-05
552052	162951	4	2023-09
552055	162952	3	2023-09-05
552056	162952	4	2023-09
552059	162953	3	2023-09-05
552063	162954	3	2023-09-05
552067	162955	3	2023-09-05
552075	162957	3	2023-09-05
552078	162958	3	2023-09-05
552081	162959	3	2023-09-05
552085	162960	3	2023-09-05
552088	162961	3	2023-09-05
552089	162961	4	2023-09
552092	162962	3	2023-09-05
552093	162962	4	2023-09
552096	162963	3	2023-09-05
552097	162963	4	2023-09-05
552100	162964	3	2023-09-05
552103	162965	3	2023-09-05
552104	162965	4	2023-09-04
552108	162966	3	2023-09-05
552109	162966	4	2023-09
552112	162967	3	2023-09-05
552115	162968	3	2023-09-05
552116	162968	4	2023-09
552119	162969	3	2023-09-05
552120	162969	4	2023-09
552123	162970	3	2023-09-05
552126	162971	3	2023-09-05
552129	162972	3	2023-09-05
552133	162973	3	2023-09-05
552136	162974	3	2023-09-05
552139	162975	3	2023-09-05
552143	162976	3	2023-09-05
552146	162977	3	2023-09-05
552149	162978	3	2023-09-05
552152	162979	3	2023-09-05
552155	162980	3	2023-09-05
552158	162981	3	2023-09-05
552165	162983	3	2023-09-05
552166	162983	4	2023-09-04
552170	162982	3	2023-09-05
552171	162982	4	2023-09-04
552175	162984	3	2023-09-05
552178	162985	3	2023-09-05
552181	162986	3	2023-09-05
552184	162987	3	2023-09-05
552190	162989	3	2023-09-05
552193	162990	3	2023-09-05
552194	162990	4	2023-09
553094	163199	3	2023-09-06
552197	162991	3	2023-09-05
552200	162992	3	2023-09-05
552203	162993	3	2023-09-05
552206	162994	3	2023-09-05
552207	162994	4	2023-09
552315	163021	3	2023-09-05
552222	162998	3	2023-09-05
552223	162998	4	2023-09-04
552226	162999	3	2023-09-05
552227	162999	4	2023-09-05
552234	163001	3	2023-09-05
552235	163001	4	2023-09-05
552242	163003	3	2023-09-05
552243	163003	4	2023-09
552246	163004	3	2023-09-05
552250	163005	3	2023-09-05
552251	163005	4	2023-09
552255	163006	3	2023-09-05
552256	163006	4	2023-09-04
552271	163010	3	2023-09-05
552272	163010	4	2023-09-04
552275	163011	3	2023-09-05
552276	163011	4	2023-09
552292	163015	3	2023-09-05
552293	163015	4	2023-09-04
552300	163017	3	2023-09-05
552301	163017	4	2023-09-03
552304	163018	3	2023-09-05
552305	163018	4	2023-09
552308	163019	3	2023-09-05
552309	163019	4	2023-09-05
552312	163020	3	2023-09-05
552318	163022	3	2023-09-05
552319	163022	4	2023-09-05
552322	163023	3	2023-09-05
552325	163024	3	2023-09-05
552332	163026	3	2023-09-05
552333	163026	4	2023-09
552340	163028	3	2023-09-05
552341	163028	4	2023-09-02
552344	163029	3	2023-09-05
552345	163029	4	2023-09-02
552348	163030	3	2023-09-05
552349	163030	4	2023-09
552356	163032	3	2023-09-05
552357	163032	4	2023-09
552360	163033	3	2023-09-05
552361	163033	4	2023-09-04
552374	163036	3	2023-09-05
552375	163036	4	2023-09
552378	163037	3	2023-09-05
552379	163037	4	2023-09
552382	163038	3	2023-09-05
552383	163038	4	2023-09
552386	163039	3	2023-09-05
552387	163039	4	2023-09-04
552390	163040	3	2023-09-05
552391	163040	4	2023-09
552394	163041	3	2023-09-05
552397	163042	3	2023-09-05
552398	163042	4	2023-09-04
552405	163044	3	2023-09-05
552406	163044	4	2023-09
552409	163045	3	2023-09-05
552410	163045	4	2023-09-01
552413	163046	3	2023-09-05
552414	163046	4	2023-09-01
552426	163049	3	2023-09-05
552429	163050	3	2023-09-05
552432	163051	3	2023-09-05
552433	163051	4	2023-09-04
552440	163053	3	2023-09-05
552441	163053	4	2023-09
552444	163054	3	2023-09-05
552445	163054	4	2023-09
552456	163057	3	2023-09-05
552457	163057	4	2023-09
552460	163058	3	2023-09-05
552461	163058	4	2023-09
552464	163059	3	2023-09-05
552465	163059	4	2023-09
552472	163061	3	2023-09-05
552476	163062	3	2023-09-05
552480	163063	3	2023-09-05
552484	163064	3	2023-09-05
552485	163064	4	2023-09-04
552488	163065	3	2023-09-05
552489	163065	4	2023-09-01
552492	163066	3	2023-09-05
552973	163170	4	2023-09
552500	163068	3	2023-09-05
552503	163069	3	2023-09-05
552504	163069	4	2023-09-04
552507	163070	3	2023-09-05
552508	163070	4	2023-09-04
552511	163071	3	2023-09-05
552512	163071	4	2023-09-01
552515	163072	3	2023-09-05
552516	163072	4	2023-09-01
552519	163073	3	2023-09-05
552520	163073	4	2023-09-02
552523	163074	3	2023-09-05
552524	163074	4	2023-09
552528	163075	3	2023-09-05
552529	163075	4	2023-09-01
552532	163076	3	2023-09-05
552533	163076	4	2023-09
552540	163078	3	2023-09-05
552541	163078	4	2023-09-04
552548	163080	3	2023-09-05
552549	163080	4	2023-09
552552	163081	3	2023-09-05
552553	163081	4	2023-09
552580	163088	3	2023-09-05
552581	163088	4	2023-09-02
552588	163090	3	2023-09-05
552589	163090	4	2023-09
552593	163091	3	2023-09-05
552594	163091	4	2023-09
552597	163092	3	2023-09-05
552598	163092	4	2023-09
552601	163093	3	2023-09-05
552602	163093	4	2023-09-04
552605	163094	3	2023-09-05
552606	163094	4	2023-09
552609	163095	3	2023-09-05
552610	163095	4	2023-09
552613	163096	3	2023-09-05
552614	163096	4	2023-09-04
552617	163097	3	2023-09-05
552618	163097	4	2023-09
552621	163098	3	2023-09-05
552622	163098	4	2023-09
552934	163161	3	2023-09-06
552935	163161	4	2023-09
552938	163162	3	2023-09-06
552939	163162	4	2023-09
552942	163163	3	2023-09-06
552943	163163	4	2023-09
552966	163168	3	2023-09-06
552969	163169	3	2023-09-06
552972	163170	3	2023-09-06
552976	163171	3	2023-09-06
552979	163172	3	2023-09-06
552982	163173	3	2023-09-06
552985	163174	3	2023-09-06
552988	163175	3	2023-09-06
552991	163176	3	2023-09-06
552992	163176	4	2023-09
553010	163179	3	2023-09-06
553011	163179	4	2023-09
553015	163180	3	2023-09-06
553016	163180	4	2023-09
553020	163181	3	2023-09-06
553021	163181	4	2023-09
553025	163182	3	2023-09-06
553026	163182	4	2023-09
553035	163184	3	2023-09-06
553036	163184	4	2023-09
553040	163185	3	2023-09-06
553049	163187	3	2023-09-06
553050	163187	4	2023-09
553053	163188	3	2023-09-06
553054	163188	4	2023-09
553057	163189	3	2023-09-06
553058	163189	4	2023-09
553061	163190	3	2023-09-06
553062	163190	4	2023-09
553142	163211	4	2023-09
553065	163191	3	2023-09-06
553068	163192	3	2023-09-06
553069	163192	4	2023-09
553077	163194	3	2023-09-06
553080	163195	3	2023-09-06
553083	163196	3	2023-09-06
553084	163196	4	2023-09
553087	163197	3	2023-09-06
553090	163198	3	2023-09-06
553091	163198	4	2023-09
553098	163200	3	2023-09-06
553102	163201	3	2023-09-06
553103	163201	4	2023-09
553107	163202	3	2023-09-06
553108	163202	4	2023-09
553112	163203	3	2023-09-06
553116	163204	3	2023-09-06
553119	163205	3	2023-09-06
553122	163206	3	2023-09-06
553123	163206	4	2023-09
553126	163207	3	2023-09-06
553127	163207	4	2023-09
553130	163208	3	2023-09-06
553133	163209	3	2023-09-06
553134	163209	4	2023-09-04
553138	163210	3	2023-09-06
553141	163211	3	2023-09-06
553145	163212	3	2023-09-06
553149	163213	3	2023-09-06
553153	163214	3	2023-09-06
553156	163215	3	2023-09-06
553157	163215	4	2023-09
553160	163216	3	2023-09-06
553161	163216	4	2023-09
553164	163217	3	2023-09-06
553167	163218	3	2023-09-06
553168	163218	4	2023-09-05
553171	163219	3	2023-09-06
553175	163220	3	2023-09-06
553179	163221	3	2023-09-06
553182	163222	3	2023-09-06
553185	163223	3	2023-09-06
553188	163224	3	2023-09-06
553191	163225	3	2023-09-06
553192	163225	4	2023-09
553201	163227	3	2023-09-06
553205	163228	3	2023-09-06
553216	163231	3	2023-09-06
553217	163231	4	2023-09-06
553225	163233	3	2023-09-06
553226	163233	4	2023-09
553230	163234	3	2023-09-06
553231	163234	4	2023-09
553235	163235	3	2023-09-06
553236	163235	4	2023-09
553239	163236	3	2023-09-06
553240	163236	4	2023-09
553243	163237	3	2023-09-06
553244	163237	4	2023-09
553248	163238	3	2023-09-06
553249	163238	4	2023-09
553253	163239	3	2023-09-06
553254	163239	4	2023-09
553258	163240	3	2023-09-06
553259	163240	4	2023-09
553262	163241	3	2023-09-06
553263	163241	4	2023-09
553266	163242	3	2023-09-06
553267	163242	4	2023-09
553270	163243	3	2023-09-06
553271	163243	4	2023-09-06
553274	163244	3	2023-09-06
553277	163245	3	2023-09-06
553280	163246	3	2023-09-06
553283	163247	3	2023-09-06
553286	163248	3	2023-09-06
553289	163249	3	2023-09-06
553292	163250	3	2023-09-06
553295	163251	3	2023-09-06
553298	163252	3	2023-09-06
553301	163253	3	2023-09-06
553304	163254	3	2023-09-06
553307	163255	3	2023-09-06
553310	163256	3	2023-09-06
553313	163257	3	2023-09-06
553316	163258	3	2023-09-06
553317	163258	4	2023-09
553320	163259	3	2023-09-06
553324	163260	3	2023-09-06
553325	163260	4	2023-09-03
553328	163261	3	2023-09-06
553329	163261	4	2023-09
553333	163262	3	2023-09-06
553336	163263	3	2023-09-06
553337	163263	4	2023-09
553340	163264	3	2023-09-06
553343	163265	3	2023-09-06
553346	163266	3	2023-09-06
553349	163267	3	2023-09-06
553352	163268	3	2023-09-06
553359	163270	3	2023-09-06
553362	163271	3	2023-09-06
553365	163272	3	2023-09-06
553368	163273	3	2023-09-06
553371	163274	3	2023-09-06
553374	163275	3	2023-09-06
553377	163276	3	2023-09-06
553380	163277	3	2023-09-06
553458	163303	3	2023-09-06
553383	163278	3	2023-09-06
553386	163279	3	2023-09-06
553389	163280	3	2023-09-06
553392	163281	3	2023-09-06
553395	163282	3	2023-09-06
553398	163283	3	2023-09-06
553401	163284	3	2023-09-06
553404	163285	3	2023-09-06
553407	163286	3	2023-09-06
553410	163287	3	2023-09-06
553413	163288	3	2023-09-06
553416	163289	3	2023-09-06
553419	163290	3	2023-09-06
553422	163291	3	2023-09-06
553425	163292	3	2023-09-06
553428	163293	3	2023-09-06
553431	163294	3	2023-09-06
553434	163295	3	2023-09-06
553437	163296	3	2023-09-06
553440	163297	3	2023-09-06
553443	163298	3	2023-09-06
553446	163299	3	2023-09-06
553449	163300	3	2023-09-06
553452	163301	3	2023-09-06
553455	163302	3	2023-09-06
553461	163304	3	2023-09-06
553464	163305	3	2023-09-06
553470	163307	3	2023-09-06
553478	163309	3	2023-09-06
553481	163310	3	2023-09-06
553484	163311	3	2023-09-06
553487	163312	3	2023-09-06
553490	163313	3	2023-09-06
553493	163314	3	2023-09-06
553496	163315	3	2023-09-06
553499	163316	3	2023-09-06
553502	163317	3	2023-09-06
553505	163318	3	2023-09-06
553508	163319	3	2023-09-06
553511	163320	3	2023-09-06
553514	163321	3	2023-09-06
553517	163322	3	2023-09-06
553520	163323	3	2023-09-06
553523	163324	3	2023-09-06
553526	163325	3	2023-09-06
553529	163326	3	2023-09-06
553532	163327	3	2023-09-06
553535	163328	3	2023-09-06
553538	163329	3	2023-09-06
553691	163379	3	2023-09-06
553541	163330	3	2023-09-06
553544	163331	3	2023-09-06
553547	163332	3	2023-09-06
553550	163333	3	2023-09-06
553553	163334	3	2023-09-06
553556	163335	3	2023-09-06
553559	163336	3	2023-09-06
553562	163337	3	2023-09-06
553565	163338	3	2023-09-06
553568	163339	3	2023-09-06
553571	163340	3	2023-09-06
553574	163341	3	2023-09-06
553577	163342	3	2023-09-06
553580	163343	3	2023-09-06
553583	163344	3	2023-09-06
553586	163345	3	2023-09-06
553589	163346	3	2023-09-06
553592	163347	3	2023-09-06
553595	163348	3	2023-09-06
553598	163349	3	2023-09-06
553601	163350	3	2023-09-06
553604	163351	3	2023-09-06
553607	163352	3	2023-09-06
553610	163353	3	2023-09-06
553613	163354	3	2023-09-06
553616	163355	3	2023-09-06
553619	163356	3	2023-09-06
553622	163357	3	2023-09-06
553625	163358	3	2023-09-06
553628	163359	3	2023-09-06
553631	163360	3	2023-09-06
553634	163361	3	2023-09-06
553637	163362	3	2023-09-06
553640	163363	3	2023-09-06
553643	163364	3	2023-09-06
553646	163365	3	2023-09-06
553649	163366	3	2023-09-06
553652	163367	3	2023-09-06
553655	163368	3	2023-09-06
553658	163369	3	2023-09-06
553664	163371	3	2023-09-06
553667	163372	3	2023-09-06
553673	163373	3	2023-09-06
553676	163374	3	2023-09-06
553679	163375	3	2023-09-06
553682	163376	3	2023-09-06
553685	163377	3	2023-09-06
553688	163378	3	2023-09-06
553694	163380	3	2023-09-06
553700	163382	3	2023-09-06
553703	163383	3	2023-09-06
553706	163384	3	2023-09-07
553709	163385	3	2023-09-07
553712	163386	3	2023-09-07
553960	163455	3	2023-09-07
553715	163387	3	2023-09-07
553718	163388	3	2023-09-07
553721	163389	3	2023-09-07
553724	163390	3	2023-09-07
553727	163391	3	2023-09-07
553730	163392	3	2023-09-07
553733	163393	3	2023-09-07
553736	163394	3	2023-09-07
553740	163395	3	2023-09-07
553743	163396	3	2023-09-07
553746	163397	3	2023-09-07
553749	162885	3	2023-09-04
553760	163399	3	2023-09-07
553763	162848	3	2023-09-04
553766	163400	3	2023-09-07
553769	163401	3	2023-09-07
553772	163402	3	2023-09-07
553775	163403	3	2023-09-07
553778	162406	3	2023-09-02
553781	163404	3	2023-09-07
553785	163405	3	2023-09-07
553788	163406	3	2023-09-07
553791	163381	3	2023-09-06
553794	162716	3	2023-09-04
553797	162467	3	2023-09-02
553804	163408	3	2023-09-07
553807	163409	3	2023-09-07
553810	163410	3	2023-09-07
553813	163411	3	2023-09-07
553816	163412	3	2023-09-07
553819	163413	3	2023-09-07
553822	163414	3	2023-09-07
553828	163416	3	2023-09-07
553831	163417	3	2023-09-07
553834	163418	3	2023-09-07
553837	163419	3	2023-09-07
553840	163420	3	2023-09-07
553843	163421	3	2023-09-07
553846	163422	3	2023-09-07
553850	163423	3	2023-09-07
553857	163425	3	2023-09-07
553861	163426	3	2023-09-07
553864	163427	3	2023-09-07
553868	163428	3	2023-09-07
553871	163429	3	2023-09-07
553875	163430	3	2023-09-07
553878	163431	3	2023-09-07
553881	163432	3	2023-09-07
553884	162587	3	2023-09-03
553885	162587	4	2023-09
553889	163433	3	2023-09-07
553892	163434	3	2023-09-07
553895	163435	3	2023-09-07
553898	163436	3	2023-09-07
553901	163437	3	2023-09-07
553904	163438	3	2023-09-07
553907	163439	3	2023-09-06
553910	163440	3	2023-09-07
553913	163441	3	2023-09-07
553916	163442	3	2023-09-07
553919	163443	3	2023-09-07
553922	163444	3	2023-09-07
553925	163445	3	2023-09-07
553928	163446	3	2023-09-07
553931	163447	3	2023-09-07
553934	163448	3	2023-09-07
553937	163449	3	2023-09-07
553944	163450	3	2023-09-07
553948	163451	3	2023-09-03
553951	163452	3	2023-09-07
553954	163453	3	2023-09-07
553957	163454	3	2023-09-03
553963	163456	3	2023-09-07
553966	163457	3	2023-09-07
553969	163458	3	2023-09-07
553972	163459	3	2023-09-03
553975	163460	3	2023-09-07
553978	163461	3	2023-09-07
553981	163462	3	2023-09-07
553987	163464	3	2023-09-07
553990	163465	3	2023-09-07
553997	163467	3	2023-09-07
553998	163467	4	2023-09-07
554001	163468	3	2023-09-07
554002	163468	4	2023-09-06
554005	163469	3	2023-09-07
554011	163471	3	2023-09-07
554014	163472	3	2023-09-07
554017	163473	3	2023-09-07
554020	163474	3	2023-09-07
554023	163475	3	2023-09-07
554026	163476	3	2023-09-07
554029	163477	3	2023-09-07
554032	163478	3	2023-09-07
554033	163478	4	2023-09-05
554036	163479	3	2023-09-07
554039	163480	3	2023-09-07
554042	163481	3	2023-09-07
554045	163482	3	2023-09-07
554049	163483	3	2023-09-07
554052	163484	3	2023-09-07
554055	163485	3	2023-09-07
554058	163486	3	2023-09-07
554061	163487	3	2023-09-07
554062	163487	4	2023-09-07
554065	163488	3	2023-09-07
554066	163488	4	2023-09-07
554069	163489	3	2023-09-07
554080	163492	3	2023-09-07
554083	163493	3	2023-09-07
554086	163494	3	2023-09-07
554089	163495	3	2023-09-07
554090	163495	4	2023-09-04
554093	163496	3	2023-09-07
554094	163496	4	2023-09-04
554097	163497	3	2023-09-07
554098	163497	4	2023-09-04
554101	163498	3	2023-09-07
554102	163498	4	2023-09-06
554105	163499	3	2023-09-07
554106	163499	4	2023-09-07
554113	163501	3	2023-09-07
554114	163501	4	2023-09-07
554117	163502	3	2023-09-07
554118	163502	4	2023-09-02
554125	163504	3	2023-09-07
554126	163504	4	2023-09-02
554129	163505	3	2023-09-07
554130	163505	4	2023-09-02
554137	163507	3	2023-09-07
554138	163507	4	2023-09-06
554141	163508	3	2023-09-07
554142	163508	4	2023-09-07
554145	163509	3	2023-09-07
554146	163509	4	2023-09-05
554153	163511	3	2023-09-07
554154	163511	4	2023-09-07
554157	163512	3	2023-09-07
554158	163512	4	2023-09-07
554161	163513	3	2023-09-07
554162	163513	4	2023-09-07
554165	163514	3	2023-09-07
554166	163514	4	2023-09-07
554181	163518	3	2023-09-07
554182	163518	4	2023-09-07
554189	163520	3	2023-09-07
554190	163520	4	2023-09-06
554193	163521	3	2023-09-07
554194	163521	4	2023-09-06
554201	163523	3	2023-09-07
554202	163523	4	2023-09-07
554205	163524	3	2023-09-07
554206	163524	4	2023-09-04
555268	162339	3	2023-09-02
555271	163060	3	2023-09-05
555272	163060	4	2023-09
555275	162653	3	2023-09-03
555276	162653	4	2023-09
555280	162219	3	2023-09-01
555283	163787	3	2023-09-02
555286	162448	3	2023-09-02
555289	163788	3	2023-09-05
555292	162944	3	2023-09-05
555328	163800	3	2023-09-08
555329	163800	4	2023-09
555338	163802	3	2023-09-08
555339	163802	4	2023-09-04
555343	163803	3	2023-09-08
555344	163803	4	2023-09-04
555348	163804	3	2023-09-08
555349	163804	4	2023-09-04
555353	163805	3	2023-09-08
555354	163805	4	2023-09-04
555358	163806	3	2023-09-08
555359	163806	4	2023-09
555363	163807	3	2023-09-08
555364	163807	4	2023-09
555373	163809	3	2023-09-08
555374	163809	4	2023-09
555393	163813	3	2023-09-08
555394	163813	4	2023-09-05
555398	163814	3	2023-09-08
555399	163814	4	2023-09-07
555408	163816	3	2023-09-08
555409	163816	4	2023-09
555423	163819	3	2023-09-08
555424	163819	4	2023-09
555439	163823	3	2023-09-08
555440	163823	4	2023-09
555468	163830	3	2023-09-08
555469	163830	4	2023-09
555479	163833	3	2023-09-08
555480	163833	4	2023-09-08
555490	163836	3	2023-09-08
555491	163836	4	2023-09
555498	163838	3	2023-09-07
555504	163840	3	2023-09-08
555505	163840	4	2023-09-04
555514	163842	3	2023-09-08
555515	163842	4	2023-09-08
555519	163843	3	2023-09-08
555520	163843	4	2023-09
555524	163844	3	2023-09-08
555525	163844	4	2023-09
555539	163847	3	2023-09-08
555540	163847	4	2023-09
555549	163849	3	2023-09-08
555550	163849	4	2023-09
555678	163879	4	2023-09
555554	163850	3	2023-09-08
555555	163850	4	2023-09-08
555614	163864	3	2023-09-08
555615	163864	4	2023-09
555625	163867	3	2023-09-08
555626	163867	4	2023-09
555662	163876	3	2023-09-08
555663	163876	4	2023-09-08
555677	163879	3	2023-09-08
555692	163882	3	2023-09-08
555693	163882	4	2023-09
555697	163883	3	2023-09-08
555698	163883	4	2023-09
555702	163884	3	2023-09-08
555703	163884	4	2023-09
555712	163886	3	2023-09-08
555713	163886	4	2023-09
555720	163888	3	2023-09-08
555721	163888	4	2023-09-06
555751	163895	3	2023-09-08
555752	163895	4	2023-09-04
555766	163897	3	2023-09-08
555767	163897	4	2023-09
555771	163898	3	2023-09-08
555772	163898	4	2023-09
555776	163899	3	2023-09-08
555777	163899	4	2023-09-07
555799	163904	3	2023-09-08
555800	163904	4	2023-09
555810	163907	3	2023-09-08
555811	163907	4	2023-09
555836	163913	3	2023-09-08
555837	163913	4	2023-09
555844	163915	3	2023-09-08
555845	163915	4	2023-09
555849	163916	3	2023-09-08
555850	163916	4	2023-09
555878	163923	3	2023-09-08
555879	163923	4	2023-09-02
555883	163924	3	2023-09-08
555884	163924	4	2023-09-02
555888	163925	3	2023-09-08
555889	163925	4	2023-09-08
556021	163955	4	2023-09
555913	163930	3	2023-09-08
555914	163930	4	2023-09
555918	163931	3	2023-09-08
555919	163931	4	2023-09
555923	163932	3	2023-09-08
555924	163932	4	2023-09
555974	163945	3	2023-09-08
555975	163945	4	2023-09-08
556002	163951	3	2023-09-08
556003	163951	4	2023-09
556265	164012	3	2023-09-08
556266	164012	4	2023-09
556015	163954	3	2023-09-08
556016	163954	4	2023-09
556020	163955	3	2023-09-08
556030	163957	3	2023-09-08
556031	163957	4	2023-09
556041	163960	3	2023-09-08
556042	163960	4	2023-09
556049	163962	3	2023-09-08
556050	163962	4	2023-09
556054	163963	3	2023-09-08
556055	163963	4	2023-09
556077	163968	3	2023-09-08
556078	163968	4	2023-09
556090	163971	3	2023-09-08
556091	163971	4	2023-09
556095	163972	3	2023-09-08
556096	163972	4	2023-09
556117	163978	3	2023-09-08
556118	163978	4	2023-09-08
556135	163982	3	2023-09-08
556136	163982	4	2023-09
556140	163983	3	2023-09-08
556141	163983	4	2023-09
556145	163984	3	2023-09-08
556146	163984	4	2023-09
556160	163987	3	2023-09-08
556161	163987	4	2023-09
556170	163989	3	2023-09-08
556171	163989	4	2023-09
556175	163990	3	2023-09-08
556176	163990	4	2023-09
556180	163991	3	2023-09-08
556181	163991	4	2023-09
556190	163993	3	2023-09-08
556191	163993	4	2023-09
556240	164007	3	2023-09-08
556241	164007	4	2023-09
556245	164008	3	2023-09-08
556246	164008	4	2023-09
556255	164010	3	2023-09-08
556256	164010	4	2023-09
556576	164079	3	2023-09-08
556295	164018	3	2023-09-08
556296	164018	4	2023-09
556325	164026	3	2023-09-08
556326	164026	4	2023-09
556333	164028	3	2023-09-08
556334	164028	4	2023-09
556338	164029	3	2023-09-08
556339	164029	4	2023-09
556388	164041	3	2023-09-08
556389	164041	4	2023-09
556396	164043	3	2023-09-08
556397	164043	4	2023-09
556401	164044	3	2023-09-08
556402	164044	4	2023-09
556406	164045	3	2023-09-08
556407	164045	4	2023-09
556411	164046	3	2023-09-08
556412	164046	4	2023-09
556426	164049	3	2023-09-08
556427	164049	4	2023-09
556431	164050	3	2023-09-08
556432	164050	4	2023-09-08
556436	164051	3	2023-09-08
556437	164051	4	2023-09
556446	164053	3	2023-09-08
556447	164053	4	2023-09
556451	164054	3	2023-09-08
556452	164054	4	2023-09
556456	164055	3	2023-09-08
556457	164055	4	2023-09-05
556461	164056	3	2023-09-08
556462	164056	4	2023-09
556476	164059	3	2023-09-08
556477	164059	4	2023-09
556486	164061	3	2023-09-08
556487	164061	4	2023-09
556577	164079	4	2023-09
556491	164062	3	2023-09-08
556492	164062	4	2023-09
556501	164064	3	2023-09-08
556502	164064	4	2023-09
556516	164067	3	2023-09-08
556517	164067	4	2023-09
556521	164068	3	2023-09-08
556522	164068	4	2023-09
556526	164069	3	2023-09-08
556527	164069	4	2023-09
556531	164070	3	2023-09-08
556532	164070	4	2023-09
556536	164071	3	2023-09-08
556537	164071	4	2023-09
556546	164073	3	2023-09-08
556547	164073	4	2023-09
556551	164074	3	2023-09-08
556552	164074	4	2023-09
556556	164075	3	2023-09-08
556557	164075	4	2023-09
556566	164077	3	2023-09-08
556567	164077	4	2023-09
556571	164078	3	2023-09-08
556572	164078	4	2023-09
556581	164080	3	2023-09-08
556582	164080	4	2023-09-08
556591	164082	3	2023-09-08
556592	164082	4	2023-09
556596	164083	3	2023-09-08
556597	164083	4	2023-09
556601	164084	3	2023-09-08
556602	164084	4	2023-09
556606	164085	3	2023-09-08
556607	164085	4	2023-09
556611	164086	3	2023-09-08
556612	164086	4	2023-09
556616	164087	3	2023-09-08
556617	164087	4	2023-09
556626	164089	3	2023-09-08
556627	164089	4	2023-09-08
556635	164091	3	2023-09-08
556636	164091	4	2023-09
556640	164092	3	2023-09-08
556641	164092	4	2023-09
556657	164096	3	2023-09-08
556658	164096	4	2023-09
556662	164097	3	2023-09-08
556663	164097	4	2023-09
556667	164098	3	2023-09-08
556668	164098	4	2023-09
556672	164099	3	2023-09-08
556673	164099	4	2023-09
557235	164259	3	2023-09-07
557236	164259	4	2023-09-04
557249	164263	3	2023-09-07
557250	164263	4	2023-09-01
557257	164265	3	2023-09-07
557258	164265	4	2023-09-06
557261	164266	3	2023-09-07
557262	164266	4	2023-09-06
557296	164275	3	2023-09-07
557297	164275	4	2023-09-06
557312	164279	3	2023-09-07
557313	164279	4	2023-09-06
557319	164281	3	2023-09-07
557320	164281	4	2023-09-06
557331	164284	3	2023-09-07
557332	164284	4	2023-09-02
557335	164285	3	2023-09-07
557336	164285	4	2023-09-02
557362	164293	3	2023-09-07
557363	164293	4	2023-09-07
557863	164415	3	2023-09-07
557864	164415	4	2023-09-06
557867	164416	3	2023-09-07
557868	164416	4	2023-09-07
557871	164417	3	2023-09-07
557872	164417	4	2023-09-02
557875	164418	3	2023-09-07
557876	164418	4	2023-09-02
557879	164419	3	2023-09-07
557880	164419	4	2023-09
557883	164420	3	2023-09-07
557884	164420	4	2023-09
557888	164421	3	2023-09-07
557889	164421	4	2023-09
557892	164422	3	2023-09-07
557893	164422	4	2023-09
557896	164423	3	2023-09-07
557897	164423	4	2023-09
557900	164424	3	2023-09-07
557901	164424	4	2023-09-07
557904	164425	3	2023-09-07
557905	164425	4	2023-09-03
557908	164426	3	2023-09-07
557909	164426	4	2023-09
557912	164427	3	2023-09-07
557913	164427	4	2023-09-07
557916	164428	3	2023-09-07
557917	164428	4	2023-09
557920	164429	3	2023-09-07
557921	164429	4	2023-09
557924	164430	3	2023-09-07
557925	164430	4	2023-09
557929	164431	3	2023-09-07
557930	164431	4	2023-09-02
557933	164432	3	2023-09-07
557934	164432	4	2023-09-07
557938	164433	3	2023-09-07
557939	164433	4	2023-09
557942	164434	3	2023-09-07
557943	164434	4	2023-09
557946	164435	3	2023-09-07
557947	164435	4	2023-09-06
557958	164438	3	2023-09-07
557959	164438	4	2023-09
557963	164439	3	2023-09-07
557964	164439	4	2023-09-06
557967	164440	3	2023-09-07
557968	164440	4	2023-09-06
557988	164445	3	2023-09-07
557989	164445	4	2023-09-03
557992	164446	3	2023-09-07
557993	164446	4	2023-09-03
557996	164447	3	2023-09-07
557997	164447	4	2023-09-03
558000	164448	3	2023-09-07
558001	164448	4	2023-09-02
558004	164449	3	2023-09-07
558005	164449	4	2023-09
558008	164450	3	2023-09-07
558009	164450	4	2023-09
558012	164451	3	2023-09-07
558013	164451	4	2023-09-05
559309	164788	3	2023-09-07
559310	164788	4	2023-09-07
559313	163517	3	2023-09-07
559314	163517	4	2023-09-07
559317	164090	3	2023-09-08
\.


--
-- Data for Name: report_data_point_disease; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report_data_point_disease (id, report_id, disease_id) FROM stdin;
161180	162030	69
161217	162057	53
161218	162058	37
161219	162059	86
161222	162062	86
161223	162063	67
161224	162064	14
161225	162065	37
161226	162066	86
161227	162067	67
161228	162068	14
161229	162068	37
161230	162068	86
161231	162069	22
161232	162070	53
161233	162071	53
161234	162072	53
161235	162073	53
161236	162074	53
161237	162075	10
161238	162076	178
161239	162077	71
161240	162078	94
161241	162079	10
161242	162080	14
161243	162081	67
161244	162082	14
161245	162083	14
161246	162084	53
161247	162085	53
161248	162086	14
161249	162087	63
161250	162089	67
161251	162090	9
161252	162091	39
161253	162092	14
161254	162093	63
161255	162094	14
161256	162095	10
161257	162096	14
161258	162097	53
161259	162098	53
161260	162099	63
161261	162101	67
161262	162102	67
161263	162103	39
161264	162104	37
161265	162105	37
161266	162106	63
161267	162107	9
161268	162108	63
161269	162109	63
161270	162110	73
161271	162111	73
161272	162113	111
161273	162114	63
161274	162115	39
161275	162116	52
161276	162117	10
161277	162118	39
161278	162119	14
161279	162120	39
161280	162121	67
161281	162122	29
161282	162123	33
161283	162124	10
161284	162125	53
161285	162126	73
161286	162127	49
161287	162128	14
161288	162129	14
161289	162130	14
161290	162131	6
161291	162132	138
161292	162133	15
161293	162134	14
161294	162135	95
161296	162138	10
161297	162139	14
161298	162140	175
161299	162142	14
161300	162143	14
161301	162144	14
161302	162145	14
161303	162146	67
161304	162149	63
161305	162150	15
161306	162151	15
161307	162152	63
161308	162153	67
161309	162154	67
161310	162155	67
161311	162156	67
161312	162157	28
161313	162158	28
161314	162159	28
161315	162161	9
161316	162162	14
161317	162163	67
161318	162164	63
161319	162165	10
161320	162166	67
161321	162167	67
161322	162168	14
161323	162169	131
161324	162170	14
161325	162171	37
161326	162172	39
161327	162173	49
161329	162175	39
161330	162176	52
161331	162179	1
161332	162180	14
161333	162180	37
161334	162180	86
161335	162181	37
161336	162181	14
161337	162182	86
161340	162185	53
161341	162186	53
161342	162187	53
161343	162188	53
161344	162189	53
161345	162190	53
161346	162191	53
161347	162192	53
161348	162193	53
161349	162194	53
161350	162195	53
161351	162196	53
161352	162197	53
161353	162198	10
161355	162200	95
161356	162201	67
161357	162202	67
161358	162203	67
161359	162204	67
161363	162208	67
161364	162209	67
161365	162210	67
161366	162211	67
161367	162212	49
161368	162213	67
161369	162214	53
161370	162215	156
161371	162216	9
161372	162217	37
161373	162218	10
161375	162220	62
161376	162221	62
161377	162222	73
161378	162223	73
161381	162226	14
161382	162227	15
161383	162228	53
161384	162229	53
161385	162230	63
161386	162232	39
161387	162234	156
161388	162235	73
161389	162236	10
161390	162237	9
161391	162238	9
161392	162239	19
161393	162240	131
161394	162241	161
161395	162242	64
161396	162243	63
161397	162244	63
161398	162245	14
161399	162246	117
161401	162249	67
161402	162250	67
161403	162251	9
161404	162252	10
161405	162253	104
161406	162254	104
161407	162255	104
161408	162257	95
161409	162258	10
161410	162259	14
161411	162260	37
161412	162261	2
161413	162262	14
161415	162264	10
161416	162265	67
161417	162266	39
161418	162267	52
161419	162268	1
161420	162269	1
161421	162270	14
161422	162271	39
161423	162272	161
161424	162273	95
161425	162274	140
161426	162275	160
161427	162276	95
161428	162279	73
161429	162280	67
161430	162281	14
161431	162282	44
161432	162283	67
161433	162284	39
161434	162285	69
161435	162286	69
161436	162287	67
161437	162288	29
161438	162290	9
161439	162291	95
161440	162292	43
161441	162293	14
161442	162294	39
161443	162295	52
161444	162296	39
161445	162297	73
161446	162299	131
161447	162300	131
161449	162302	39
161450	162303	52
161451	162304	47
161452	162305	47
161453	162306	47
161455	162308	2
161456	162309	33
161457	162310	67
161458	162311	67
161459	162312	9
161460	162313	63
161461	162314	14
161462	162315	63
161464	162317	14
161465	162318	14
161466	162319	14
161467	162320	67
161468	162321	69
161469	162322	9
161470	162323	14
161472	162328	14
161473	162329	86
161474	162330	86
161475	162332	67
161476	162333	37
161477	162334	37
161478	162336	73
161479	162337	14
161480	162338	49
161481	162340	87
161482	162341	67
161483	162342	86
161484	162346	63
161485	162347	63
161486	162348	53
161487	162349	63
161488	162350	67
161489	162351	14
161490	162354	67
161491	162355	67
161492	162356	71
161493	162357	14
161494	162358	63
161495	162359	63
161496	162360	37
161497	162361	9
161498	162362	6
161499	162363	6
161500	162364	76
161501	162365	71
161502	162366	14
161503	162367	71
161504	162368	59
161505	162369	14
161506	162370	73
161507	162371	73
161508	162372	9
161509	162373	138
161510	162374	14
161511	162375	14
161512	162376	9
161513	162377	95
161514	162378	83
161515	162379	73
161516	162380	10
161517	162381	14
161518	162382	10
161519	162383	131
161520	162385	67
161521	162386	37
161522	162387	37
161523	162388	138
161524	162390	131
161525	162391	12
161526	162392	80
161527	162394	10
161528	162395	10
161529	162396	10
161530	162397	10
161531	162398	67
161532	162399	67
161533	162400	67
161534	162401	67
161535	162402	67
161536	162403	138
161537	162404	43
161538	162405	39
161539	162408	67
161540	162409	67
161541	162410	67
161542	162411	30
161543	162412	15
161544	162413	15
161545	162415	14
161546	162417	73
161547	162418	73
161548	162419	73
161549	162421	131
161550	162422	53
161551	162423	53
161552	162424	69
161553	162425	69
161554	162426	69
161555	162427	39
161556	162428	52
161557	162429	39
161558	162430	52
161559	162431	49
161560	162432	49
161561	162433	71
161562	162434	37
161563	162435	37
161564	162436	37
161565	162437	14
161566	162438	35
161567	162439	119
161568	162440	49
161569	162441	15
161570	162442	62
161571	162443	68
161572	162444	68
161573	162445	68
161575	162449	71
161576	162450	1
161577	162451	14
161578	162452	10
161579	162453	15
161580	162454	63
161581	162455	63
161582	162456	63
161584	162458	14
161585	162459	63
161586	162460	63
161587	162461	39
161588	162462	39
161589	162463	52
161590	162464	39
161591	162465	14
161592	162466	1
161594	162468	14
161595	162469	49
161596	162470	53
161597	162471	39
161598	162472	27
161599	162473	14
161600	162474	37
161601	162475	10
161602	162476	95
161603	162477	49
161604	162478	12
161605	162479	37
161606	162480	55
161607	162481	14
161608	162482	14
161609	162483	59
161610	162484	59
161611	162486	67
161612	162487	110
161613	162488	98
161614	162489	63
161615	162490	63
161616	162491	44
161617	162492	63
161618	162493	67
161619	162494	67
161620	162495	14
161624	162499	67
161627	162502	14
161632	162507	14
161633	162508	8
161634	162509	120
161637	162512	63
161639	162514	63
161640	162516	66
161641	162517	67
161644	162523	87
161645	162524	67
161647	162527	1
161651	162532	67
161653	162534	67
161654	162535	67
161659	162539	14
161660	162540	67
161661	162541	63
161662	162543	67
161668	162549	7
161669	162550	59
161670	162551	67
161672	162555	63
161674	162557	9
161677	162560	67
161679	162562	63
161682	162565	67
161685	162568	67
161686	162569	67
161691	162575	66
161692	162576	67
161694	162578	13
161695	162579	19
161696	162580	67
161697	162581	63
161706	162594	19
161708	162596	67
161709	162598	53
161710	162599	67
161712	162602	86
161713	162603	86
161714	162604	63
161715	162605	87
161716	162606	68
161717	162607	67
161718	162608	67
161719	162609	53
161720	162610	67
161721	162611	156
161722	162612	67
161723	162613	12
161724	162614	80
161725	162615	67
161726	162616	14
161728	162618	19
161730	162620	10
161731	162621	14
161732	162622	27
161734	162624	10
161736	162627	9
161737	162628	67
161738	162629	14
161739	162630	63
161740	162631	63
161741	162632	67
161742	162634	104
161744	162636	39
161745	162637	67
161746	162638	80
161747	162639	12
161748	162640	12
161749	162641	80
161750	162642	73
161751	162643	14
161753	162645	2
161754	162646	67
161755	162647	66
161756	162648	67
161757	162649	67
161758	162650	63
161759	162651	73
161760	162652	67
161762	162654	67
161763	162655	67
161764	162656	49
161765	162657	63
161766	162658	138
161767	162659	138
161769	162661	140
161770	162662	87
161771	162663	98
161772	162664	98
161773	162665	98
161776	162668	67
161777	162669	67
161778	162670	87
161779	162671	53
161780	162672	73
161781	162673	80
161782	162674	12
161783	162675	39
161784	162676	67
161785	162677	98
161786	162678	67
161787	162680	14
161788	162681	14
161789	162682	14
161790	162683	8
161791	162685	67
161793	162687	14
161794	162688	87
161795	162689	73
161796	162690	87
161797	162691	66
161798	162692	67
161799	162693	87
161800	162694	76
161801	162695	15
161802	162696	73
161803	162697	120
161804	162698	67
161805	162699	67
161806	162700	68
161807	162701	14
161808	162702	62
161809	162703	14
161810	162704	95
161811	162705	10
161812	162706	131
161813	162707	14
161814	162708	27
161815	162709	63
161816	162710	73
161817	162711	10
161818	162712	8
161819	162713	131
161820	162714	10
161821	162715	10
161823	162717	63
161824	162718	39
161825	162719	39
161826	162720	39
161827	162721	69
161828	162723	14
161829	162724	131
161830	162725	67
161831	162726	53
161832	162727	67
161833	162728	10
161834	162729	14
161835	162730	14
161836	162731	14
161837	162732	71
161838	162733	67
161839	162734	27
161840	162735	37
161841	162736	139
161842	162737	14
161843	162738	37
161844	162739	14
161845	162740	14
161846	162741	62
161847	162742	62
161848	162743	62
161849	162744	44
161850	162745	9
161851	162746	9
161852	162747	9
161853	162748	9
161854	162749	9
161855	162750	9
161856	162751	14
161857	162752	37
161858	162753	109
161859	162754	10
161860	162755	10
161861	162756	8
161862	162757	39
161863	162758	14
161864	162760	39
161865	162761	39
161866	162762	39
161867	162763	66
161868	162764	131
161869	162766	63
161870	162767	63
161871	162768	63
161872	162769	63
161873	162770	63
161874	162771	63
161875	162772	63
161876	162773	156
161877	162774	67
161878	162775	156
161880	162777	14
161882	162779	14
161884	162781	87
161885	162782	14
161886	162783	63
161887	162784	14
161888	162785	14
161889	162786	104
161890	162787	104
161891	162788	156
161892	162789	156
161893	162790	14
161894	162791	14
161897	162794	14
161899	162796	87
161900	162797	87
161902	162799	69
161904	162801	14
161905	162802	58
161906	162803	37
161907	162804	8
161908	162805	14
161909	162806	14
161910	162807	14
161912	162809	14
161913	162810	8
161914	162811	63
161915	162812	8
161916	162813	14
161917	162814	67
161918	162815	67
161919	162816	67
161920	162817	14
161921	162818	14
161922	162819	14
161923	162820	14
161924	162821	37
161925	162822	70
161926	162823	8
161927	162824	66
161928	162825	28
161929	162826	69
161930	162827	14
161931	162828	37
161932	162829	70
161933	162830	8
161934	162831	66
161935	162832	28
161936	162833	69
161937	162834	9
161938	162835	9
161939	162836	67
161940	162837	131
161942	162839	14
161943	162840	37
161944	162841	131
161945	162842	2
161946	162843	44
161947	162844	44
161948	162845	39
161949	162846	15
161950	162847	69
161951	162849	67
161952	162850	131
161953	162851	14
161954	162852	104
161955	162853	69
161956	162854	12
161957	162855	80
161958	162856	69
161959	162857	67
161960	162858	67
161961	162859	67
161962	162860	69
161963	162861	69
161964	162862	69
161965	162863	53
161966	162864	67
161968	162866	73
161969	162867	22
161970	162868	39
161971	162869	52
161972	162870	14
161975	162873	49
161976	162874	19
161977	162875	73
161978	162876	95
161979	162877	95
161980	162878	14
161981	162879	39
161982	162880	52
161983	162881	69
161984	162882	138
161985	162883	52
161986	162884	39
161988	162886	67
161989	162887	67
161990	162888	156
161991	162889	89
161992	162890	14
161993	162891	37
161994	162892	8
161996	162894	63
161997	162895	14
161998	162896	37
161999	162897	8
162000	162898	22
162001	162899	49
162002	162900	68
162003	162901	131
162005	162903	10
162008	162905	14
162009	162906	49
162010	162907	86
162011	162908	98
162012	162909	98
162013	162911	14
162014	162912	22
162015	162913	73
162016	162914	14
162017	162915	67
162018	162916	22
162019	162917	49
162020	162918	49
162021	162919	49
162022	162920	67
162023	162921	49
162024	162922	44
162025	162923	63
162026	162924	63
162027	162925	63
162028	162926	63
162029	162927	63
162030	162928	63
162031	162929	63
162032	162930	63
162033	162931	63
162034	162932	63
162035	162933	63
162036	162934	63
162037	162935	7
162038	162936	9
162039	162937	2
162040	162938	62
162041	162939	6
162042	162940	49
162043	162941	35
162044	162942	14
162045	162943	15
162046	162945	9
162047	162946	9
162048	162947	15
162049	162948	14
162050	162949	14
162051	162950	14
162052	162951	14
162053	162952	14
162054	162953	59
162055	162954	7
162056	162955	69
162058	162957	69
162059	162958	7
162060	162959	59
162061	162960	37
162062	162961	37
162063	162962	76
162064	162963	14
162065	162964	73
162066	162965	9
162067	162966	156
162068	162967	67
162069	162968	105
162070	162969	14
162071	162970	69
162072	162971	62
162073	162972	39
162074	162973	39
162075	162974	67
162076	162975	14
162077	162977	45
162078	162978	119
162079	162979	119
162080	162980	63
162081	162981	14
162083	162983	8
162084	162982	14
162085	162984	44
162086	162985	63
162087	162986	63
162088	162987	63
162090	162989	39
162091	162990	36
162092	162991	156
162093	162992	69
162094	162993	67
162095	162994	14
162099	162998	86
162100	162999	69
162102	163001	131
162104	163003	36
162105	163004	1
162106	163005	49
162107	163006	14
162110	163010	80
162111	163011	14
162115	163015	9
162117	163018	14
162118	163019	14
162119	163020	62
162120	163021	138
162121	163022	14
162122	163023	53
162124	163026	14
162126	163028	14
162127	163029	8
162128	163030	93
162130	163032	51
162131	163033	67
162135	163039	14
162136	163040	39
162137	163041	93
162138	163042	14
162140	163044	98
162141	163045	14
162142	163046	156
162145	163049	138
162146	163050	138
162147	163051	10
162149	163053	35
162150	163054	27
162153	163058	30
162154	163059	65
162156	163061	87
162157	163062	87
162158	163063	87
162159	163064	39
162160	163065	63
162161	163066	67
162163	163068	65
162164	163069	59
162165	163070	80
162166	163071	14
162167	163072	69
162168	163073	39
162169	163074	49
162170	163075	10
162171	163076	35
162173	163078	14
162175	163080	93
162176	163081	15
162183	163088	67
162185	163090	60
162186	163091	15
162187	163092	37
162188	163093	14
162189	163094	67
162190	163095	63
162191	163096	10
162192	163097	67
162193	163098	67
162249	163161	80
162250	163162	49
162251	163163	66
162254	163168	138
162255	163169	14
162256	163170	156
162257	163171	66
162258	163172	66
162259	163173	49
162260	163174	49
162261	163175	49
162262	163176	87
162266	163179	14
162267	163180	14
162268	163181	14
162269	163182	14
162271	163184	37
162272	163185	14
162274	163187	156
162275	163188	9
162276	163189	9
162277	163190	62
162278	163191	14
162279	163192	14
162281	163194	9
162282	163195	36
162283	163196	14
162284	163197	71
162285	163198	14
162286	163199	59
162287	163200	44
162288	163201	110
162289	163202	83
162290	163203	69
162291	163204	49
162292	163205	28
162293	163206	10
162294	163207	14
162295	163208	10
162296	163209	9
162297	163210	156
162298	163211	69
162299	163212	131
162300	163213	37
162301	163214	69
162302	163215	14
162303	163216	10
162304	163217	69
162305	163218	10
162306	163219	62
162307	163220	67
162308	163222	66
162309	163223	66
162310	163224	66
162311	163225	14
162313	163227	69
162314	163228	66
162317	163233	12
162318	163234	80
162319	163235	156
162320	163236	156
162321	163238	14
162322	163239	58
162323	163241	58
162324	163242	14
162325	163243	13
162326	163244	14
162327	163245	53
162328	163246	53
162329	163247	86
162330	163248	22
162331	163249	44
162332	163250	156
162333	163251	44
162334	163252	66
162335	163253	66
162336	163254	66
162337	163255	69
162338	163256	10
162339	163257	39
162340	163258	69
162341	163259	44
162342	163260	22
162343	163261	66
162344	163263	49
162345	163264	49
162346	163265	49
162347	163266	63
162348	163267	15
162349	163268	67
162351	163270	120
162352	163271	120
162353	163272	10
162354	163273	59
162355	163274	10
162356	163275	14
162357	163276	63
162358	163277	63
162359	163278	63
162360	163279	67
162361	163280	67
162362	163281	67
162363	163282	119
162364	163283	119
162365	163284	63
162366	163285	53
162367	163286	49
162368	163287	49
162369	163288	14
162370	163289	14
162371	163290	63
162372	163291	10
162373	163292	39
162374	163293	10
162375	163294	14
162376	163295	15
162377	163296	14
162378	163297	14
162379	163300	10
162380	163301	10
162381	163303	9
162382	163304	69
162383	163305	73
162385	163307	160
162387	163309	66
162388	163310	59
162389	163311	65
162390	163312	65
162391	163313	67
162392	163314	49
162393	163315	49
162394	163316	49
162395	163317	67
162396	163318	67
162397	163319	14
162398	163320	14
162399	163321	28
162400	163322	28
162401	163323	28
162402	163325	14
162403	163326	9
162404	163327	14
162405	163328	161
162406	163329	80
162407	163330	80
162408	163331	10
162409	163332	63
162410	163333	49
162411	163334	53
162412	163335	53
162413	163336	67
162414	163337	73
162415	163338	14
162416	163339	49
162417	163340	49
162418	163341	14
162419	163342	14
162420	163343	9
162421	163344	47
162422	163345	39
162423	163346	37
162424	163347	14
162425	163348	138
162426	163350	66
162427	163351	8
162428	163352	14
162429	163353	8
162430	163354	14
162431	163355	8
162432	163356	39
162433	163357	39
162434	163358	14
162435	163359	14
162436	163360	1
162437	163362	49
162438	163363	49
162439	163364	14
162440	163365	104
162441	163366	9
162442	163367	67
162443	163368	79
162444	163369	138
162446	163371	14
162448	163373	67
162449	163374	15
162450	163375	15
162451	163376	15
162452	163377	35
162453	163378	14
162454	163379	37
162455	163380	8
162456	163382	60
162457	163383	60
162458	163384	69
162459	163386	14
162460	163387	14
162461	163388	63
162462	163389	63
162463	163390	104
162464	163391	63
162465	163392	9
162466	163393	9
162467	163394	2
162468	163395	14
162469	163396	63
162470	163397	63
162471	163399	14
162472	162848	10
162473	163400	39
162474	163401	67
162475	163403	49
162476	163404	1
162477	163405	53
162478	163406	44
162479	162716	63
162480	162467	39
162482	163408	14
162483	163409	14
162484	163410	14
162485	163411	14
162486	163412	8
162487	163413	63
162488	163414	9
162492	163416	14
162493	163417	15
162494	163418	15
162495	163419	14
162496	163420	14
162497	163421	14
162498	163422	2
162499	163423	14
162501	163425	1
162502	163426	8
162503	163427	19
162504	163428	9
162505	163429	2
162506	163430	112
162507	163431	63
162508	163432	67
162509	163433	156
162510	163434	37
162511	163435	14
162512	163436	14
162513	163437	14
162514	163438	8
162515	163439	49
162516	163440	49
162517	163441	67
162518	163442	14
162519	163443	80
162520	163444	80
162521	163445	15
162522	163447	49
162523	163448	10
162524	163449	69
162526	163450	49
162527	163451	49
162528	163452	10
162529	163453	10
162530	163454	49
162531	163455	10
162532	163456	80
162533	163457	14
162534	163458	8
162535	163459	49
162536	163460	14
162537	163461	1
162538	163462	35
162540	163464	14
162541	163465	14
162542	163468	67
162543	163469	49
162545	163471	175
162546	163472	14
162547	163473	8
162548	163474	49
162549	163475	14
162550	163476	14
162551	163477	14
162552	163479	10
162553	163480	59
162554	163481	14
162555	163482	49
162556	163483	15
162557	163484	15
162558	163485	67
162559	163486	67
162560	163487	67
162561	163488	67
162562	163489	104
162565	163492	14
162566	163493	14
162567	163494	14
162568	163495	67
162569	163496	67
162570	163497	67
162571	163498	68
162572	163499	14
162574	163501	87
162575	163502	119
162577	163504	119
162578	163505	119
162580	163507	53
162581	163508	1
162582	163509	14
162584	163511	120
162585	163512	14
162586	163513	22
162587	163514	10
162591	163518	73
162593	163520	39
162594	163521	160
162596	163523	80
162597	163524	80
162835	163060	10
162836	162653	15
162837	162219	1
162838	163787	94
162839	162448	10
162840	163788	94
162841	162944	10
162852	163800	10
162854	163806	87
162855	163807	19
162857	163809	53
162860	163813	9
162861	163814	14
162863	163816	9
162866	163819	162
162869	163823	19
162876	163830	172
162879	163833	14
162882	163836	10
162884	163838	66
162886	163840	10
162888	163842	67
162889	163843	63
162890	163844	14
162893	163847	53
162895	163849	10
162896	163850	67
162911	163867	6
162920	163876	67
162923	163879	63
162926	163882	63
162927	163883	15
162928	163884	94
162930	163886	81
162937	163895	71
162940	163897	63
162941	163898	14
162942	163899	10
162947	163904	104
162955	163913	19
162957	163915	28
162958	163916	69
162964	163923	10
162965	163924	10
162966	163925	67
162971	163930	14
162972	163931	49
162985	163945	14
162989	163951	79
162991	163954	63
162992	163955	63
162994	163957	1
162997	163960	15
162999	163962	28
163000	163963	79
163005	163968	10
163008	163971	14
163014	163978	10
163018	163982	62
163019	163984	160
163023	163989	53
163024	163990	6
163025	163991	10
163040	164007	87
163042	164012	104
163048	164018	63
163056	164026	87
163058	164028	67
163059	164029	67
163069	164041	2
163071	164043	14
163074	164049	94
163075	164050	14
163076	164051	15
163078	164053	63
163079	164056	81
163082	164059	63
163084	164061	147
163085	164062	104
163087	164064	69
163090	164067	82
163091	164068	82
163092	164069	82
163093	164070	172
163094	164071	51
163096	164073	66
163097	164074	10
163098	164075	51
163100	164077	49
163101	164078	22
163102	164079	79
163103	164080	67
163105	164082	28
163106	164083	79
163107	164084	9
163108	164085	68
163109	164086	14
163110	164087	7
163112	164089	10
163114	164091	67
163115	164092	6
163118	164096	10
163119	164098	126
163120	164099	49
163273	164259	14
163277	164263	111
163278	164265	66
163279	164266	66
163287	164275	156
163290	164279	55
163292	164281	69
163294	164284	8
163295	164285	14
163301	164293	67
163417	164415	9
163418	164417	162
163419	164418	94
163420	164419	131
163421	164420	49
163422	164421	9
163423	164422	9
163424	164423	9
163425	164424	27
163426	164425	14
163427	164426	156
163428	164427	160
163429	164429	156
163430	164430	49
163431	164431	39
163432	164432	49
163433	164433	14
163434	164434	87
163437	164438	49
163438	164439	14
163439	164440	63
163444	164446	10
163445	164447	71
163446	164448	49
163447	164449	156
163448	164450	27
163449	164451	138
163766	164788	94
163767	163517	94
163768	164090	73
\.


--
-- Data for Name: report_data_point_location; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report_data_point_location (id, report_id, latitude, longitude, district, city, metro_area, sub_region, region, country_id) FROM stdin;
161532	162030	37.780077	-122.420162		San Francisco		San Francisco	CA	198
161570	162057	51.5002	-0.126236						67
161571	162058	26.897459	90.347462					Sarpang	30
161572	162059	48.403843	23.275736					Zakarpattia Oblast	196
161573	162062	48.403843	23.275736					Zakarpattia Oblast	196
161574	162063	40.4167	-3.70327						58
161575	162064	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161576	162065	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161577	162066	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161578	162067	52.26	21.02						153
161579	162068	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161580	162069	12.976746	77.575278		Bengaluru		Bengaluru	Karnataka	87
161581	162070	48.2201	16.3798						12
161582	162071	50.8371	4.36761						15
161583	162072	55.6763	12.5681						52
161584	162073	48.2201	16.3798						12
161585	162074	55.6763	12.5681						52
161586	162075	41.797973	1.528531					Catalonia	58
161587	162076	41.797973	1.528531					Catalonia	58
161588	162077	41.797973	1.528531					Catalonia	58
161589	162078	41.797973	1.528531					Catalonia	58
161590	162079	42.641901	18.106485		Dubrovnik			County of Dubrovnik-Neretva	82
161591	162080	14.6248	-90.5328						77
161592	162081	39.561559	-6.416811		Casar de Cáceres		Cáceres	Extremadura	58
161593	162082	41.8955	12.4823						93
161594	162083	23.553118	121.0211024						214
161595	162084	40.4167	-3.70327						58
161596	162085	48.2201	16.3798						12
161597	162086	48.8566	2.35097						63
161598	162087	48.8566	2.35097						63
161599	162088	41.885983	23.466528		Razlog			Blagoevgrad	19
161600	162089	52.26	21.02						153
161601	162090	27.712017	85.31295		Kathmandu			Bagmati	143
161602	162091	-1.27975	36.8126						98
161603	162092	14.6248	-90.5328						77
161604	162093	42.262118	-71.802239		Worcester		Worcester	MA	198
161605	162094	21.0069	105.825						204
161606	162095	21.0069	105.825						204
161607	162096	21.0069	105.825						204
161608	162097	48.2201	16.3798						12
161609	162098	50.8371	4.36761						15
161610	162099	43.818406	7.778421		San Remo		Imperia	Liguria	93
161611	162100	31.209399	46.342336					Dhi Qar	90
161612	162101	52.26	21.02						153
161613	162102	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
161614	162103	15.361979	44.201955						208
161615	162104	30.5167	72.8						147
161616	162105	30.5167	72.8						147
161617	162106	42.275674	-71.839675					MA	198
161618	162107	35.56655	45.38676		Sulaymaniyah		Sulaymaniyah	Sulaymaniyah	90
161619	162108	45.651089	9.204841		Seregno		Monza e Brianza	Lombardy	93
161620	162109	44.4479	26.0979						160
161621	162110	-50.01964	-68.525725		Puerto Santa Cruz		Corpen Aike	Santa Cruz	7
161622	162111	-34.6118	-58.4173						7
161623	162112	33.3302	44.394						90
161624	162113	19.427	-99.1276						122
161625	162114	38.115664	13.361471		Palermo		Palermo	Sicily	93
161626	162115	15.361979	44.201955						208
161627	162116	15.361979	44.201955						208
161628	162117	45.4215	-75.6919						33
161629	162118	15.361979	44.201955						208
161630	162119	14.6248	-90.5328						77
161631	162120	-3.113175	104.304266	Kasai	Muara Enim			South Sumatra	85
161632	162121	52.26	21.02						153
161633	162122	33.8872	35.5134						106
161634	162123	-22.2677	166.464						137
161635	162124	35.67	139.77						96
161636	162125	51.5002	-0.126236						67
161637	162126	-34.609026	-58.373222		Buenos Aires				7
161638	162127	11.228397	108.726044	Liên Hương	Tuy Phong		Tuy Phong	Binh Thuan	204
161639	162128	23.7055	90.4113						18
161640	162129	-6.19752	106.83						85
161641	162130	14.6248	-90.5328						77
161642	162131	40.4167	-3.70327						58
161643	162132	26.644652	83.799371	Barwa Mansingh	Deoria Sadar		Deoria	Uttar Pradesh	87
161644	162133	-7.977272	112.634099		Malang			East Java	85
161645	162134	23.7055	90.4113						18
161646	162135	30.264979	-97.746598		Austin			TX	198
161647	162136	23.01451	72.591759		Ahmedabad		Ahmedabad	Gujarat	87
161648	162138	35.67	139.77						96
161649	162139	35.67	139.77						96
161650	162140	35.67	139.77						96
161651	162141	34.052238	-118.243344		Los Angeles		Los Angeles	CA	198
161652	162142	14.6248	-90.5328						77
161653	162143	14.6248	-90.5328						77
161654	162144	14.6248	-90.5328						77
161655	162145	31.639773	74.83876		Amritsar		Amritsar	Punjab	87
161656	162146	52.26	21.02						153
161657	162147	38.291962	-122.458003		Sonoma		Sonoma	CA	198
161658	162148	38.291962	-122.458003		Sonoma		Sonoma	CA	198
161659	162149	38.635355	-90.200986		Saint Louis		Saint Louis City	MO	198
161660	162150	28.207275	79.54071		Faridpur		Bareilly	Uttar Pradesh	87
161661	162151	30.132027	79.205337					Uttarakhand	87
161662	162152	42.275674	-71.839675					MA	198
161663	162153	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
161664	162154	40.4167	-3.70327						58
161665	162155	52.5235	13.4115						49
161666	162156	52.26	21.02						153
161667	162157	38.892062	-77.019912		Washington		District of Columbia	DC	198
161668	162158	33.042102	-96.372353		Nevada		Collin	TX	198
161669	162159	47.530072	-122.032904		Issaquah		King	WA	198
161670	162160	21.203509	72.839227		Surat		Surat	Gujarat	87
161671	162161	33.3302	44.394						90
161672	162162	-6.19752	106.83						85
161673	162163	52.26	21.02						153
161674	162164	42.275674	-71.839675					MA	198
161675	162165	28.6353	77.225						87
161676	162166	52.26	21.02						153
161677	162167	52.26	21.02						153
161678	162168	3.12433	101.684						135
161679	162169	47.523153	-92.538658		Virginia		Saint Louis	MN	198
161680	162170	23.01451	72.591759		Ahmedabad		Ahmedabad	Gujarat	87
161681	162171	23.01451	72.591759		Ahmedabad		Ahmedabad	Gujarat	87
161682	162172	15.361979	44.201955						208
161683	162173	46.164992	-123.929293		Warrenton		Clatsop	OR	198
161684	162175	15.352	44.2075						208
161685	162176	15.361979	44.201955						208
161686	162177	15.877055	74.455046		Belagavi		Belagavi	Karnataka	87
161687	162178	15.877055	74.455046		Belagavi		Belagavi	Karnataka	87
161688	162179	17.361719	78.475169		Hyderabad		Hyderabad	Telangana	87
161689	162180	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161690	162181	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161691	162182	50.786695	25.266879		Lutska miska hromada		Lutskyi raion	Volyn Oblast	196
161692	162185	48.2201	16.3798						12
161693	162186	48.2201	16.3798						12
161694	162187	48.2201	16.3798						12
161695	162188	50.8371	4.36761						15
161696	162189	55.6763	12.5681						52
161697	162190	52.5235	13.4115						49
161698	162191	53.3441	-6.26749						88
161699	162192	52.3738	4.89095						141
161700	162193	59.9138	10.7387						142
161701	162194	46.051426	14.505965						177
161702	162195	60.1608	24.9525						61
161703	162196	48.8566	2.35097						63
161704	162197	59.3327	18.0645						178
161705	162198	48.8566	2.35097						63
161707	162200	42.201024	-85.70631		Texas		Kalamazoo	MI	198
161708	162201	52.26	21.02						153
161709	162202	52.26	21.02						153
161710	162203	52.26	21.02						153
161711	162204	52.26	21.02						153
161712	162208	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
161713	162209	51.759052	19.458603		Lodz		Lodz	Lodz	153
161714	162210	51.893566	18.958049		Poddębice		Poddębicki	Lodz	153
161715	162211	51.591551	18.729325		Sieradz		Sieradzki	Lodz	153
161716	162212	13.7308	100.521						185
161717	162213	52.26	21.02						153
161718	162214	54.525963	15.255119						226
161719	162215	54.219527	12.798214				Vorpommern-Rügen	Mecklenburg-West Pomerania	49
161720	162216	33.3302	44.394						90
161721	162217	27.5768	89.6177						30
161722	162218	51.5002	-0.126236						67
161724	162220	34.486874	72.089469					Khyber Pakhtunkhwa	147
161725	162221	30.5167	72.8						147
161726	162222	-34.6118	-58.4173						7
161727	162223	44.4479	26.0979						160
161728	162226	21.028279	105.853881		Hanoi		Hanoi	Hanoi	204
161729	162227	10.058654	-9.104422				Kankan	Kankan	70
161730	162228	54.525963	15.255119						226
161731	162229	54.525963	15.255119						226
161732	162230	45.317092	8.858649		Vigevano		Pavia	Lombardy	93
161733	162231	33.314694	44.376762		Baghdad		Karkh	Baghdad	90
161734	162232	15.361979	44.201955						208
161735	162233	29.076358	31.096999		Beni Suef			Beni Suef	56
161736	162234	36.728187	-76.583192		Suffolk		Suffolk	VA	198
161737	162235	-34.6118	-58.4173						7
161738	162236	13.7308	100.521						185
161739	162237	36.191865	44.009876		Erbil		Erbil	Erbil	90
161740	162238	33.3302	44.394						90
161741	162239	41.8955	12.4823						93
161742	162240	39.949825	-90.210483		Virginia		Cass	IL	198
161743	162241	4.60987	-74.082						41
161744	162242	3.8721	11.5174						38
161745	162243	41.8955	12.4823						93
161746	162244	41.8955	12.4823						93
161747	162245	41.8955	12.4823						93
161748	162246	34.009286	-81.037094		Columbia			SC	198
161749	162248	24.871938	66.988063		Karachi			Sind	147
161750	162249	52.26	21.02						153
161751	162250	52.26	21.02						153
161752	162251	33.3302	44.394						90
161753	162252	52.192035	-2.223532		Worcester		Worcestershire	ENG	67
161754	162253	31.097519	77.193104		Shimla		Shimla	Himachal Pradesh	87
161755	162254	31.923566	77.236214					Himachal Pradesh	87
161756	162255	31.923566	77.236214					Himachal Pradesh	87
161757	162256	36.191865	44.009876		Erbil		Erbil	Erbil	90
161758	162257	32.800108	-96.473952		Travis Ranch		Kaufman	TX	198
161759	162258	52.5235	13.4115						49
161760	162259	14.64198	-90.51324		Guatemala			Guatemala	77
161761	162260	12.1048	15.0445						183
161762	162261	40.416691	-3.700345		Madrid		Madrid	Community of Madrid	58
161763	162262	21.0069	105.825						204
161764	162264	35.67	139.77						96
161765	162265	52.26	21.02						153
161766	162266	15.361979	44.201955						208
161767	162267	15.361979	44.201955						208
161768	162268	25.432227	78.721837	Bhupnagar	Jhansi Tehsil		Jhansi	Uttar Pradesh	87
161769	162269	25.167613	85.535677		Bihar		Nalanda	Bihar	87
161770	162270	1.833648	-76.967291		Bolívar			Cauca	41
161771	162271	48.476093	135.060536		Khabarovsk		Khabarovsk Krai	Far Eastern Federal District	161
161772	162272	4.60987	-74.082						41
161773	162273	31.556825	-97.130022		Waco		McLennan	TX	198
161774	162274	42.201024	-85.70631		Texas		Kalamazoo	MI	198
161775	162275	55.7558	37.6176						161
161776	162276	30.264979	-97.746598		Austin			TX	198
161777	162277	51.1879	71.4382						97
161778	162278	51.1879	71.4382						97
161779	162279	60.1608	24.9525						61
161780	162280	52.26	21.02						153
161781	162281	23.7055	90.4113						18
161782	162282	-41.2865	174.776						145
161783	162283	52.26	21.02						153
161784	162284	55.7558	37.6176						161
161785	162285	3.12433	101.684						135
161786	162286	3.12433	101.684						135
161787	162287	40.4167	-3.70327						58
161788	162288	51.602593	64.015383					Kostanay Region	97
161789	162289	29.187	78.8619		Thakurdwara		Moradabad	Uttar Pradesh	87
161790	162290	33.3302	44.394						90
161791	162291	30.264979	-97.746598		Austin			TX	198
161792	162292	45.8069	15.9614						82
161793	162293	21.0069	105.825						204
161794	162294	15.361979	44.201955						208
161795	162295	15.361979	44.201955						208
161796	162296	15.361979	44.201955						208
161797	162297	-34.6118	-58.4173						7
161798	162298	35.67	139.77						96
161799	162299	39.949825	-90.210483		Virginia		Cass	IL	198
161800	162300	39.949825	-90.210483		Virginia		Cass	IL	198
161801	162302	15.361979	44.201955						208
161802	162303	15.361979	44.201955						208
161803	162304	12.1048	15.0445						183
161804	162305	15.361979	44.201955						208
161805	162306	-4.325	15.3222						39
161806	162308	43.645565	-94.934258		Wisconsin		Jackson	MN	198
161807	162309	-22.2677	166.464						137
161808	162310	39.561559	-6.416811		Casar de Cáceres		Cáceres	Extremadura	58
161809	162311	52.26	21.02						153
161810	162312	33.3302	44.394						90
161811	162313	40.694592	-89.590362		Peoria		Peoria	IL	198
161812	162314	30.829097	72.144242					Punjab	147
161813	162315	38.703147	-112.099028		Central Valley		Sevier	UT	198
161814	162317	23.7055	90.4113						18
161815	162318	23.7055	90.4113						18
161816	162319	-12.0931	-77.0465						149
161817	162320	38.8895	-77.032						198
161818	162321	22.282154	114.156885						80
161819	162322	33.3302	44.394						90
161820	162323	23.7055	90.4113						18
161821	162324	26.296843	84.149745	Khurwasia Uttar	Bhatparrani		Deoria	Uttar Pradesh	87
161822	162325	26.17363	83.869757	Balia Uttar	Berhaj		Deoria	Uttar Pradesh	87
161823	162326	28.114449	77.914315	Keoli Khurd	Khurja		Bulandsahar	Uttar Pradesh	87
161825	162328	30.7938	75.476097		Jagraon		Ludhiana	Punjab	87
161826	162329	48.403843	23.275736					Zakarpattia Oblast	196
161827	162330	48.403843	23.275736					Zakarpattia Oblast	196
161828	162331	24.871938	66.988063		Karachi			Sind	147
161829	162332	52.26	21.02						153
161830	162333	26.17363	83.869757	Balia Uttar	Berhaj		Deoria	Uttar Pradesh	87
161831	162334	28.351839	79.409555		Bareilly		Bareilly	Uttar Pradesh	87
161832	162335	25.347405	83.256818		Sakaldiha		Chandauli	Uttar Pradesh	87
161833	162336	60.1608	24.9525						61
161834	162337	12.976746	77.575278		Bengaluru		Bengaluru	Karnataka	87
161835	162338	48.654697	34.874902		Dnipropetrovskyi raion		Dniprovskyi raion	Dnipropetrovsk Oblast	196
161837	162340	26.515784	72.173749	Kerala	Shergarh		Jodhpur	Rajasthan	87
161838	162341	40.4167	-3.70327						58
161839	162342	50.4536	30.5038						196
161840	162343	12.7201	77.283401		Ramanagara		Ramanagara	Karnataka	87
161841	162344	50.449749	30.523718		Kyiv		Kyiv	Kyiv	196
161842	162345	50.449749	30.523718		Kyiv		Kyiv	Kyiv	196
161843	162346	44.756963	19.694092		Sabac		Mačvanski	Central Serbia	172
161844	162347	44.8024	20.4656						172
161845	162348	53.046908	-2.991673		Wrexham		Clwyd	WAL	67
161846	162349	35.1676	33.3736						47
161847	162350	52.26	21.02						153
161848	162351	41.8955	12.4823						93
161849	162352	41.797973	1.528531					Catalonia	58
161850	162353	41.797973	1.528531					Catalonia	58
161851	162354	39.561559	-6.416811		Casar de Cáceres		Cáceres	Extremadura	58
161852	162355	39.561559	-6.416811		Casar de Cáceres		Cáceres	Extremadura	58
161853	162356	43.216645	27.911806		Varna			Varna	19
161854	162357	14.6248	-90.5328						77
161855	162358	45.400639	20.077984					Vojvodina	172
161856	162359	45.400639	20.077984					Vojvodina	172
161857	162360	37.568295	126.997785						103
161858	162361	15.5932	32.5363						164
161859	162362	44.4479	26.0979						160
161860	162363	35.128414	-117.960172		California City		Kern	CA	198
161861	162364	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161862	162365	31.9497	35.9263						95
161863	162366	45.463618	9.188116		Milan		Milan	Lombardy	93
161864	162367	13.7308	100.521						185
161865	162368	29.425171	-98.494614		San Antonio			TX	198
161866	162369	45.416194	11.89516	Fiera	Padua		Padua	Veneto	93
161867	162370	6.15367	-75.37413		Río Negro			Antioquia	41
161868	162371	-42.604196	-70.457881	Costa del Chubut	Cushamen		Cushamen	Chubut	7
161869	162372	15.5932	32.5363						164
161870	162373	23.7055	90.4113						18
161871	162374	22.700409	90.37499		Barisal			Barisal	18
161872	162375	14.6248	-90.5328						77
161873	162376	33.3302	44.394						90
161874	162377	30.264979	-97.746598		Austin			TX	198
161875	162378	45.979811	12.303313		Vittorio Veneto		Treviso	Veneto	93
161876	162379	-34.6118	-58.4173						7
161877	162380	38.8895	-77.032						198
161878	162381	34.00935	72.002482	Nowshera	Peshawar			Khyber Pakhtunkhwa	147
161879	162382	48.856895	2.350849		Paris		Paris	Île-de-France	63
161880	162383	36.845127	-75.975437		Virginia Beach		Virginia Beach	VA	198
161881	162385	52.26	21.02						153
161882	162386	26.17363	83.869757	Balia Uttar	Berhaj		Deoria	Uttar Pradesh	87
161883	162387	26.17363	83.869757	Balia Uttar	Berhaj		Deoria	Uttar Pradesh	87
161884	162388	21.21813	72.77948	Jahangirabad	Surat		Surat	Gujarat	87
161885	162389	-8.534862	115.404209		Klungkung			Bali	85
161886	162390	36.845127	-75.975437		Virginia Beach		Virginia Beach	VA	198
161887	162391	45.854954	-97.021085		Minnesota		Roberts	SD	198
161888	162392	45.854954	-97.021085		Minnesota		Roberts	SD	198
161889	162393	-6.174757	106.827073		Jakarta			Jakarta	85
161890	162394	48.8566	2.35097						63
161891	162395	28.6353	77.225						87
161892	162396	28.632425	77.218791		New Delhi		New Delhi	Delhi	87
161893	162397	48.8566	2.35097						63
161894	162398	52.26	21.02						153
161895	162399	52.26	21.02						153
161896	162400	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
161897	162401	52.26	21.02						153
161898	162402	52.26	21.02						153
161899	162403	20.609964	72.930655		Valsad		Valsad	Gujarat	87
161900	162404	45.8069	15.9614						82
161901	162405	15.352	44.2075						208
161903	162407	26.17363	83.869757	Balia Uttar	Berhaj		Deoria	Uttar Pradesh	87
161904	162408	52.26	21.02						153
161905	162409	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
161906	162410	52.26	21.02						153
161907	162411	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161908	162412	28.207275	79.54071		Faridpur		Bareilly	Uttar Pradesh	87
161909	162413	9.05804	7.48906						139
161910	162414	23.553118	121.0211024						214
161911	162415	23.01451	72.591759		Ahmedabad		Ahmedabad	Gujarat	87
161912	162416	34.063352	-117.652398		Ontario		San Bernardino	CA	198
161913	162417	38.892062	-77.019912		Washington		District of Columbia	DC	198
161914	162418	38.892062	-77.019912		Washington		District of Columbia	DC	198
161915	162419	38.892062	-77.019912		Washington		District of Columbia	DC	198
161916	162420	35.67	139.77						96
161917	162421	36.845127	-75.975437		Virginia Beach		Virginia Beach	VA	198
161918	162422	14.417812	-89.181726		Ocotepeque			Ocotepeque	81
161919	162423	55.6763	12.5681						52
161920	162424	24.871938	66.988063		Karachi			Sind	147
161921	162425	32.8578	13.1072						108
161922	162426	37.780077	-122.420162		San Francisco		San Francisco	CA	198
161923	162427	42.884419	74.576619						99
161924	162428	42.884419	74.576619						99
161925	162429	15.352	44.2075						208
161926	162430	15.352	44.2075						208
161927	162431	32.939862	-97.078367		Grapevine			TX	198
161928	162432	40.758478	-111.888142		Salt Lake City		Salt Lake	UT	198
161929	162433	40.0495	116.286						36
161930	162434	4.937995	-52.335052		Cayenne		French Guiana	French Guiana	213
161931	162435	27.5768	89.6177						30
161932	162436	27.5768	89.6177						30
161933	162437	14.6248	-90.5328						77
161934	162438	43.686597	-70.166314		Long Island		Cumberland	ME	198
161935	162439	41.654538	-74.684913		Thompson		Sullivan	NY	198
161936	162440	-25.746	28.1871						209
161937	162441	22.828218	104.980886		Hà Giang		Hà Giang	Ha Giang	204
161938	162442	30.5167	72.8						147
161939	162443	45.108959	-93.346331		Brooklyn Park		Hennepin	MN	198
161940	162444	45.108959	-93.346331		Brooklyn Park		Hennepin	MN	198
161941	162445	45.108959	-93.346331		Brooklyn Park		Hennepin	MN	198
161943	162447	42.201024	-85.70631		Texas		Kalamazoo	MI	198
161945	162449	23.028083	72.563637	Maharashtra Society	Ahmedabad		Ahmedabad	Gujarat	87
161946	162450	17.361719	78.475169		Hyderabad		Hyderabad	Telangana	87
161947	162451	41.8955	12.4823						93
161948	162452	41.8955	12.4823						93
161949	162453	22.828218	104.980886		Hà Giang		Hà Giang	Ha Giang	204
161950	162454	41.866128	-88.106633				DuPage	IL	198
161951	162455	43.818406	7.778421		San Remo		Imperia	Liguria	93
161952	162456	43.818406	7.778421		San Remo		Imperia	Liguria	93
161953	162458	14.6248	-90.5328						77
161954	162459	42.407795	-88.029788		Lindenhurst		Lake	IL	198
161955	162460	40.693015	-74.271549		Connecticut Farms		Union	NJ	198
161956	162461	15.352	44.2075						208
161957	162462	15.352	44.2075						208
161958	162463	15.352	44.2075						208
161959	162464	15.352	44.2075						208
161960	162465	23.7055	90.4113						18
161961	162466	25.432227	78.721837	Bhupnagar	Jhansi Tehsil		Jhansi	Uttar Pradesh	87
161963	162468	23.707306	90.415483		Dhaka			Dhaka	18
161964	162469	56.128477	40.407241		Vladimir		Vladimir Oblast	Central Federal District	161
161965	162470	53.046908	-2.991673		Wrexham		Clwyd	WAL	67
161966	162471	48.476093	135.060536		Khabarovsk		Khabarovsk Krai	Far Eastern Federal District	161
161967	162472	25.643641	-81.042103		Everglades-Monroe County		Monroe	FL	198
161968	162473	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161969	162474	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
161970	162475	51.5002	-0.126236						67
161971	162476	30.264979	-97.746598		Austin			TX	198
161972	162477	55.7558	37.6176						161
161973	162478	45.854954	-97.021085		Minnesota		Roberts	SD	198
161974	162479	21.14363	72.834538	Udhna	Surat		Surat	Gujarat	87
161975	162480	46.602234	-120.506093		Yakima		Yakima	WA	198
161976	162481	22.991622	120.185034		Tainan City			Tainan City	214
161977	162482	14.6248	-90.5328						77
161978	162483	43.682859	51.281793	Mangystau	Мангистауский сельский округ		Мунайлинский район	Mangistau Region	97
161979	162484	59.598944	60.564831		Serov		Sverdlovsk Oblast	Ural Federal District	161
161980	162485	2.94314	101.719001		Putrajaya		Putrajaya	Putrajaya Federal Territory	135
161981	162486	52.26	21.02						153
161982	162487	56.488404	84.946831		Tomsk		Tomsk Oblast	Siberian Federal District	161
161983	162488	12.107	75.209396	Payyannur	Taliparamba		Kannur	Kerala	87
161984	162489	34.42137	-106.10839					NM	198
161985	162490	38.835224	-104.819798		Colorado Springs		El Paso	CO	198
161986	162491	-36.853611	174.764988		Auckland		Auckland	North Island	145
161987	162492	\N	\N						172
161988	162493	\N	\N		Rzeszow				153
161989	162494	\N	\N		Rzeszow				153
161990	162495	\N	\N		Karachi				147
161994	162499	52.26	21.02						153
161997	162502	\N	\N		Rawalpindi				147
162002	162507	\N	\N					Jharkhand	87
162003	162508	\N	\N					Jharkhand	87
162004	162509	\N	\N					Jharkhand	87
162007	162512	\N	\N						93
162009	162514	\N	\N						93
162011	162516	\N	\N		Kolhapur				87
162012	162517	52.26	21.02						153
162018	162523	\N	\N					Kirovohrad	196
162019	162524	52.26	21.02						153
162022	162527	\N	\N		Hyderbad				87
162027	162532	\N	\N		Rzeszow				153
162029	162534	52.26	21.02						153
162030	162535	52.26	21.02						153
162034	162539	23.7055	90.4113						18
162035	162540	\N	\N		Rzeszow				153
162036	162541	\N	\N					New Mexico	198
162037	162542	\N	\N		Thondi				87
162038	162543	52.26	21.02						153
162044	162549	\N	\N						122
162045	162550	\N	\N						122
162046	162551	52.26	21.02						153
162047	162552	\N	\N		Al-Khams				108
162048	162553	\N	\N		Cubla				58
162050	162555	\N	\N					Andulasia	58
162052	162557	\N	\N					Garmian	90
162055	162560	\N	\N		Rzeszow				153
162057	162562	\N	\N					Niagra	33
162060	162565	52.26	21.02						153
162063	162568	\N	\N		Rzeszow				153
162064	162569	\N	\N		Rzeszow				153
162069	162574	\N	\N		Cchindwara				87
162070	162575	\N	\N		Mumbai				87
162071	162576	\N	\N		Rzeszow				153
162073	162578	\N	\N		Amreli				87
162074	162579	60.1608	24.9525						61
162075	162580	\N	\N					New York State	198
162076	162581	\N	\N					Colorado	198
162087	162592	35.67	139.77						96
162088	162593	35.67	139.77						96
162089	162594	\N	\N					Washington	198
162091	162596	\N	\N		Rzeszow				153
162093	162598	\N	\N		Sirahama				96
162094	162599	52.26	21.02						153
162096	162601	\N	\N					Odisha	87
162097	162602	\N	\N					Transcarpathia	196
162098	162603	\N	\N					Transcarpathia	196
162099	162604	\N	\N						172
162100	162605	\N	\N		Karbinci				124
162101	162606	\N	\N						198
162102	162607	\N	\N		Helsingor				52
162103	162608	\N	\N						153
162104	162609	\N	\N						12
162105	162610	\N	\N		Rzezzow				153
162106	162611	\N	\N						49
162107	162612	\N	\N		Rzeszow				153
162108	162613	\N	\N					Minnesota	198
162109	162614	\N	\N					Minnesota	198
162110	162615	52.26	21.02						153
162111	162616	\N	\N		San Felice Circeo				93
162113	162618	\N	\N						7
162115	162620	21.0069	105.825						204
162116	162621	\N	\N		Ho Chi Minh				204
162117	162622	\N	\N		Ho Chi Minh				204
162119	162624	21.0069	105.825						204
162120	162625	\N	\N		Al-khams				108
162122	162627	\N	\N					Kurdistan	90
162123	162628	\N	\N		Rzeszow				153
162124	162629	\N	\N						93
162125	162630	\N	\N		Badajoz				58
162126	162631	\N	\N		Badajoz				58
162127	162632	\N	\N		Rzeszow				153
162129	162634	\N	\N		Shimla			Hindustan	87
162131	162636	\N	\N		Kasongo				39
162132	162637	\N	\N		Rzeszow				153
162133	162638	\N	\N					Minnesota	198
162134	162639	\N	\N					Minnesota	198
162135	162640	\N	\N					Minnesota	198
162136	162641	\N	\N					Minnesota	198
162137	162642	\N	\N					Washington State	198
162138	162643	\N	\N		Hanoi				204
162140	162645	\N	\N		Indore				87
162141	162646	\N	\N		Rzeszow				153
162142	162647	\N	\N		Kolhapur				87
162143	162648	\N	\N		Rzeszow				153
162144	162649	\N	\N						153
162145	162650	\N	\N		Rostov				161
162146	162651	\N	\N					Khabarovsk Territory	161
162147	162652	52.26	21.02						153
162149	162654	\N	\N						196
162150	162655	52.26	21.02						153
162151	162656	\N	\N		Chandauli				87
162152	162657	\N	\N				DuPage County	Illinois	198
162153	162658	-6.19752	106.83						85
162154	162659	\N	\N		Surat				87
162156	162661	\N	\N		Austin			Texas	198
162157	162662	43.8607	18.4214						22
162158	162663	\N	\N		Payyannur				87
162159	162664	\N	\N		Payyannur				87
162160	162665	\N	\N		Payyannur				87
162163	162668	\N	\N						196
162164	162669	\N	\N						196
162165	162670	\N	\N		Kerala				87
162166	162671	\N	\N		Sirahama				96
162167	162672	\N	\N						198
162168	162673	\N	\N					Minnesota	198
162169	162674	\N	\N					Minnesota	198
162170	162675	31.134774	-99.334949				McCulloch	TX	198
162171	162676	52.26	21.02						153
162172	162677	22.777709	72.324999	Kerala	Bavla		Ahmedabad	Gujarat	87
162173	162678	52.26	21.02						153
162174	162679	25.901008	93.720303		Dimapur		Dimapur	Nagaland	87
162175	162680	30.341389	76.401842		Patiala		Patiala	Punjab	87
162176	162681	13.933706	75.573037		Shivamogga		Shivamogga	Karnataka	87
162177	162682	30.115992	77.286896		Yamunanagar		Yamunanagar	Haryana	87
162178	162683	30.115992	77.286896		Yamunanagar		Yamunanagar	Haryana	87
162179	162684	13.735488	79.10906	Udayamanikyam	Yerravaripalem		Tirupati	Andhra Pradesh	87
162180	162685	52.26	21.02						153
162181	162687	12.976746	77.575278		Bengaluru		Bengaluru	Karnataka	87
162182	162688	27.945679	80.779297		Lakhimpur		Lakhimpur Kheri	Uttar Pradesh	87
162183	162689	22.839592	86.216091	Jharkhand Colony	Jamshedpur		Jamshedpur	Jharkhand	87
162184	162690	48.472261	32.081964					Kirovohrad Oblast	196
162185	162691	16.6887	74.4589		Ichalkaranji		Kolhapur	Maharashtra	87
162186	162692	52.26	21.02						153
162187	162693	25.512729	92.76148	Assam Quarry	Umrangso		Dima Hasao	Assam	87
162188	162694	30.5167	72.8						147
162189	162695	-7.816149	112.614246					East Java	85
162190	162696	56.9465	24.1048						115
162191	162697	25.512729	92.76148	Assam Quarry	Umrangso		Dima Hasao	Assam	87
162192	162698	52.26	21.02						153
162193	162699	52.26	21.02						153
162194	162700	38.8895	-77.032						198
162195	162701	12.976746	77.575278		Bengaluru		Bengaluru	Karnataka	87
162196	162702	15.494605	73.933024	Old Goa	Panaji		North Goa	Goa	87
162197	162703	21.028279	105.853881				Hanoi	Hanoi	204
162198	162704	29.425171	-98.494614		San Antonio			TX	198
162199	162705	21.0069	105.825						204
162200	162706	36.845127	-75.975437		Virginia Beach		Virginia Beach	VA	198
162201	162707	12.411393	108.173601		Lắk		Lắk	Dak Lak	204
162202	162708	12.411393	108.173601		Lắk		Lắk	Dak Lak	204
162203	162709	35.278119	-93.133723		Illinois		Pope	AR	198
162204	162710	-53.652396	-69.442353				Tierra del Fuego	Magallanes & the Chilean Antarctica	35
162205	162711	21.0069	105.825						204
162206	162712	14.7247	-17.4734						165
162207	162713	36.845127	-75.975437		Virginia Beach		Virginia Beach	VA	198
162208	162714	-12.0931	-77.0465						149
162209	162715	21.0069	105.825						204
162211	162717	40.4167	-3.70327						58
162212	162718	15.361979	44.201955						208
162213	162719	15.352	44.2075						208
162214	162720	15.352	44.2075						208
162215	162721	13.7308	100.521						185
162216	162722	30.043488	31.235292		Cairo			Cairo	56
162217	162723	27.6939	85.3157						143
162315	162823	8.99427	-79.5188						148
162218	162724	36.845127	-75.975437		Virginia Beach		Virginia Beach	VA	198
162219	162725	52.26	21.02						153
162220	162726	52.26	21.02						153
162221	162727	37.469487	130.8544		Ulsan			Ulreuno-Do	103
162222	162728	50.309706	6.729391		Kerpen (Eifel)		Vulkaneifel	Rhineland-Palatinate	49
162223	162729	6.92148	79.8528						111
162224	162730	6.92148	79.8528						111
162225	162731	32.066018	75.879397	Sinhala	Fetehpur		Kangra	Himachal Pradesh	87
162226	162732	32.066018	75.879397	Sinhala	Fetehpur		Kangra	Himachal Pradesh	87
162227	162733	52.26	21.02						153
162228	162734	44.8024	20.4656						172
162229	162735	6.92148	79.8528						111
162230	162736	37.568295	126.997785						103
162231	162737	45.62067	9.769167					Lombardy	93
162232	162738	37.568295	126.997785						103
162233	162739	16.325858	-95.237419		Santo Domingo Tehuantepec			Oaxaca	122
162234	162740	18.533269	-69.811719		Santo Domingo Este			Santo Domingo	53
162235	162741	22.184024	72.939628	Chitral	Padra		Vadodara	Gujarat	87
162236	162742	25.802616	78.042174	Mastura	Bhitarwar Tehsil		Gwalior	Madhya Pradesh	87
162237	162743	22.184024	72.939628	Chitral	Padra		Vadodara	Gujarat	87
162238	162744	-29.707755	-51.1184	Rondônia	Novo Hamburgo			Rio Grande do Sul	27
162239	162745	-25.9664	32.5713						131
162240	162746	34.5228	69.1761						2
162241	162747	9.02274	38.7468						60
162242	162748	18.5392	-72.3288						83
162243	162749	-4.273897	15.281513						40
162244	162750	-17.8312	31.0672						211
162245	162751	26.462892	80.323359		Kanpur		Kanpur	Uttar Pradesh	87
162246	162752	26.462892	80.323359		Kanpur		Kanpur	Uttar Pradesh	87
162247	162753	43.320905	-1.984515		San Sebastián		Gipuzkoa	Basque Country	58
162248	162754	51.5002	-0.126236						67
162249	162755	28.6353	77.225						87
162250	162756	27.616271	75.152436		Sikar		Sikar	Rajasthan	87
162251	162757	15.352	44.2075						208
162252	162758	23.707306	90.415483		Dhaka			Dhaka	18
162253	162759	25.29965	79.87027		Mahoba		Mahoba	Uttar Pradesh	87
162254	162760	58.006755	56.228574		Perm		Perm Krai	Volga Federal District	161
162255	162761	48.476093	135.060536		Khabarovsk		Khabarovsk Krai	Far Eastern Federal District	161
162256	162762	40.1596	44.509						8
162257	162763	23.028083	72.563637	Maharashtra Society	Ahmedabad		Ahmedabad	Gujarat	87
162258	162764	36.845127	-75.975437		Virginia Beach		Virginia Beach	VA	198
162259	162765	32.8578	13.1072						108
162260	162766	37.9792	23.7166						74
162261	162767	44.4479	26.0979						160
162262	162768	48.8566	2.35097						63
162263	162769	47.4984	19.0408						84
162264	162770	40.4167	-3.70327						58
162265	162771	44.8024	20.4656						172
162266	162772	39.191325	-6.150897					Extremadura	58
162267	162773	\N	\N						198
162268	162774	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162269	162775	38.8895	-77.032						198
162270	162777	10.77653	106.700977		Ho Chi Minh City		Ho Chi Minh City	Ho Chi Minh City	204
162272	162779	21.028279	105.853881		Hanoi		Hanoi	Hanoi	204
162274	162781	22.143439	105.828908		Bac Kan		Bắc Kạn	Bac Kan	204
162275	162782	41.8955	12.4823						93
162276	162783	45.053773	9.695142		Piacenza		Piacenza	Emilia Romagna	93
162277	162784	41.8955	12.4823						93
162278	162785	26.584324	73.850131					Rajasthan	87
162279	162786	26.584324	73.850131					Rajasthan	87
162280	162787	26.584324	73.850131					Rajasthan	87
162281	162788	41.325436	-73.446897				Western Connecticut	CT	198
162282	162789	40.713047	-74.00723		New York			NY	198
162283	162790	23.7055	90.4113						18
162284	162791	23.7055	90.4113						18
162287	162794	30.201923	71.453062	Multan	Islamabad			Punjab	147
162289	162796	25.512729	92.76148	Assam Quarry	Umrangso		Dima Hasao	Assam	87
162290	162797	27.169563	94.181864		North Lakhimpur Block		Lakhimpur	Assam	87
162292	162799	13.7308	100.521						185
162293	162801	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162294	162802	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162295	162803	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162296	162804	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162297	162805	40.0495	116.286						36
162298	162806	23.7055	90.4113						18
162299	162807	24.976242	101.481596					Yunnan	36
162301	162809	31.623236	74.82685	Kot Khalsa	Amritsar		Amritsar	Punjab	87
162302	162810	31.623236	74.82685	Kot Khalsa	Amritsar		Amritsar	Punjab	87
162303	162811	41.8955	12.4823						93
162304	162812	12.841487	-12.198259					Kédougou	165
162305	162813	24.633953	85.226562		Fatehpur		Gaya	Bihar	87
162306	162814	52.26	21.02						153
162307	162815	50.325221	19.133596		Będzin		Będziński	Silesia	153
162308	162816	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162309	162817	26.283341	73.021858		Jodhpur		Jodhpur	Rajasthan	87
162310	162818	22.720788	88.120339	Rajibpur	Jangipara		Hooghly	West Bengal	87
162311	162819	8.99427	-79.5188						148
162312	162820	8.99427	-79.5188						148
162313	162821	8.99427	-79.5188						148
162314	162822	8.99427	-79.5188						148
162316	162824	8.99427	-79.5188						148
162317	162825	8.99427	-79.5188						148
162318	162826	8.99427	-79.5188						148
162319	162827	8.99427	-79.5188						148
162320	162828	8.99427	-79.5188						148
162321	162829	8.99427	-79.5188						148
162322	162830	8.99427	-79.5188						148
162323	162831	8.99427	-79.5188						148
162324	162832	8.99427	-79.5188						148
162325	162833	8.99427	-79.5188						148
162326	162834	-3.218383	28.258551					South Kivu	39
162327	162835	-8.783195	34.508522						227
162328	162836	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162329	162837	47.523153	-92.538658		Virginia		Saint Louis	MN	198
162330	162839	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162331	162840	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162332	162841	39.949825	-90.210483		Virginia		Cass	IL	198
162333	162842	44.639955	-89.732953					WI	198
162334	162843	-41.2865	174.776						145
162335	162844	-17.111326	-63.599532		Santa Rosa del Sara		Sara	Santa Cruz	26
162336	162845	15.352	44.2075						208
162337	162846	9.51667	-13.7						70
162338	162847	13.7308	100.521						185
162340	162849	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162341	162850	39.949825	-90.210483		Virginia		Cass	IL	198
162342	162851	25.192183	75.850837		Kota		Kota	Rajasthan	87
162343	162852	25.192183	75.850837		Kota		Kota	Rajasthan	87
162344	162853	13.7308	100.521						185
162345	162854	38.8895	-77.032						198
162346	162855	38.8895	-77.032						198
162347	162856	13.7308	100.521						185
162348	162857	52.26	21.02						153
162349	162858	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162350	162859	49.985946	36.27354		Kharkiv		Kharkivskyi raion	Kharkiv Oblast	196
162351	162860	13.753958	100.502243		Bangkok		Bangkok	Bangkok	185
162352	162861	13.753958	100.502243		Bangkok		Bangkok	Bangkok	185
162353	162862	13.753958	100.502243		Bangkok		Bangkok	Bangkok	185
162354	162863	55.6763	12.5681						52
162355	162864	49.985946	36.27354		Kharkiv		Kharkivskyi raion	Kharkiv Oblast	196
162356	162866	-34.6118	-58.4173						7
162357	162867	10.945464	79.377584	Tamil Nadu Housing Board	Kumbakonam		Thanjavur	Tamil Nadu	87
162358	162868	15.361979	44.201955						208
162359	162869	15.361979	44.201955						208
162360	162870	22.768676	86.198786		Jamshedpur		Jamshedpur	Jharkhand	87
162361	162873	33.669865	-93.246841		Georgia		Nevada	AR	198
162362	162874	-12.622028	-47.866212		Paranã			Tocantins	27
162363	162875	-15.7801	-47.9292						27
162364	162876	30.5167	72.8						147
162365	162877	30.5167	72.8						147
162366	162878	41.8955	12.4823						93
162367	162879	15.361979	44.201955						208
162368	162880	15.361979	44.201955						208
162369	162881	13.7308	100.521						185
162370	162882	21.203509	72.839227		Surat		Surat	Gujarat	87
162371	162883	15.361979	44.201955						208
162372	162884	15.361979	44.201955						208
162374	162886	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162375	162887	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162376	162888	38.8895	-77.032						198
162377	162889	-2.953969	115.387987					South Kalimantan	85
162378	162890	21.203509	72.839227		Surat		Surat	Gujarat	87
162379	162891	21.203509	72.839227		Surat		Surat	Gujarat	87
162380	162892	21.203509	72.839227		Surat		Surat	Gujarat	87
162382	162894	45.78265	-108.504578		Billings		Yellowstone	MT	198
162383	162895	23.369904	85.325276		Ranchi		Ranchi	Jharkhand	87
162384	162896	23.369904	85.325276		Ranchi		Ranchi	Jharkhand	87
162385	162897	23.369904	85.325276		Ranchi		Ranchi	Jharkhand	87
162386	162898	12.678351	78.620469		Vaniyambadi		Tiruppattur	Tamil Nadu	87
162387	162899	54.97976	73.410639		Omsk		Omsk Oblast	Siberian Federal District	161
162388	162900	37.130242	-113.509895		Washington		Washington	UT	198
162389	162901	39.949825	-90.210483		Virginia		Cass	IL	198
162391	162903	\N	\N		Delaware				198
162394	162905	\N	\N		Jalandhar				87
162395	162906	\N	\N	Vinnytsia region 					196
162396	162907	\N	\N		 Lviv				196
162397	162908	\N	\N	Korom village					87
162398	162909	11.871988	75.379077		Kannur		Kannur	Kerala	87
162399	162910	\N	\N	Cherkasy					196
162400	162911	\N	\N		Chhatrapati Sambhajinagar				87
162401	162912	11.9338	76.934097		Chamarajanagara		Chamarajanagara	Karnataka	87
162402	162913	\N	\N						7
162403	162914	\N	\N		 Bengaluru				87
162404	162915	52.26	21.02						153
162405	162916	\N	\N	Kerala					87
162406	162917	\N	\N		Ghaziabad				87
162407	162918	\N	\N	Vinnytsia region 					196
162408	162919	\N	\N	Vinnytsia region 					196
162409	162920	52.26	21.02						153
162410	162921	\N	\N					Vinnytsia region 	196
162411	162922	\N	\N					Rivne region	196
162412	162923	\N	\N						172
162413	162924	44.8024	20.4656						172
162414	162925	44.8024	20.4656						172
162415	162926	44.8024	20.4656						172
162416	162927	44.8024	20.4656						172
162417	162928	\N	\N						74
162418	162929	\N	\N						172
162419	162930	\N	\N						49
162420	162931	\N	\N						63
162421	162932	\N	\N						58
162422	162933	\N	\N						160
162423	162934	\N	\N						84
162424	162935	\N	\N	West Bengal 					87
162425	162936	-3.218383	28.258551					South Kivu	39
162426	162937	40.4167	-3.70327						58
162427	162938	\N	\N	Upper Chitral					147
162428	162939	42.846747	-2.647362	Salburua	Vitoria-Gasteiz		Araba/Álava	Basque Country	58
162429	162940	\N	\N	Utah					198
162430	162941	19.043679	-98.199039		Puebla			Puebla	122
162431	162942	\N	\N		Hanoi				204
162432	162943	\N	\N		Kankan				70
162434	162945	\N	\N	Kivu					39
162435	162946	\N	\N						39
162436	162947	10.058654	-9.104422				Kankan	Kankan	70
162437	162948	\N	\N						147
162438	162949	\N	\N		 Islamabad				147
162439	162950	\N	\N		Faisalabad				147
162440	162951	31.561917	74.348079	Lahore	Islamabad			Punjab	147
162441	162952	33.601922	73.038081	Rawalpindi	Islamabad			Punjab	147
162442	162953	\N	\N	Sharkia					56
162443	162954	\N	\N	Sharkia					56
162444	162955	13.7308	100.521						185
162446	162957	13.7308	100.521						185
162447	162958	\N	\N						56
162448	162959	\N	\N						56
162449	162960	\N	\N	Sindh					147
162450	162961	24.871938	66.988063		Karachi			Sind	147
162451	162962	\N	\N		Rawalpindi				147
162452	162963	\N	\N						18
162453	162964	\N	\N						7
162454	162965	\N	\N	Nsama					210
162455	162966	25.775084	-80.194702		Miami		Miami-Dade	FL	198
162456	162967	\N	\N						153
162457	162968	\N	\N		Buenos Aires				7
162458	162969	\N	\N	 Macau 					116
162459	162970	13.7308	100.521						185
162460	162971	24.023158	-104.671237		Durango			Durango	122
162461	162972	\N	\N	Maniema					39
162462	162973	\N	\N		Kindu				39
162463	162974	\N	\N	Montequinto					122
162464	162975	\N	\N						185
162465	162976	\N	\N					Northern Territory (NT) 	11
162466	162977	\N	\N	Kunčice pod Ondřejník					48
162467	162978	\N	\N					worcester county	198
162468	162979	\N	\N					worcester county	198
162469	162980	\N	\N						172
162470	162981	\N	\N						143
162472	162983	\N	\N		 Yamunanagar				87
162473	162982	\N	\N		 Yamunanagar				87
162474	162984	48.306089	14.286437		Linz		Linz	Upper Austria	12
162475	162985	44.8024	20.4656						172
162476	162986	\N	\N						172
162477	162987	44.8024	20.4656						172
162478	162989	\N	\N						208
162479	162990	\N	\N	Parakou					16
162480	162991	38.8895	-77.032						198
162481	162992	13.7308	100.521						185
162482	162993	\N	\N						153
162483	162994	23.7055	90.4113						18
162487	162998	13.4443	144.794						78
162488	162999	-32.166648	147.010285					New South Wales	11
162490	163001	-43.543042	171.579794				Canterbury	South Island	145
162492	163003	9.353165	2.608119				Parakou	Borgou	16
162493	163004	24.857846	87.774589		Barharwa		Sahibganj	Jharkhand	87
162494	163005	48.920427	28.685418					Vinnytsia Oblast	196
162495	163006	23.7055	90.4113						18
162499	163010	51.047306	-114.05797		Calgary			AB	33
162500	163011	23.7055	90.4113						18
162504	163015	-11.904869	28.950812		Nsama		Mansa	Luapula	210
162506	163017	35.67	139.77						96
162507	163018	23.7055	90.4113						18
162508	163019	23.553118	121.0211024						214
162509	163020	34.486874	72.089469					Khyber Pakhtunkhwa	147
162510	163021	23.65613	85.564135					Jharkhand	87
162511	163022	23.553118	121.0211024						214
162512	163023	56.167709	101.622949		Bratsk		Irkutsk Oblast	Siberian Federal District	161
162513	163024	27.712017	85.31295		Kathmandu			Bagmati	143
162515	163026	22.565573	88.370215		Kolkata		Kolkata	West Bengal	87
162516	163028	23.65613	85.564135					Jharkhand	87
162517	163029	23.65613	85.564135					Jharkhand	87
162518	163030	-43.789427	-68.526525					Chubut	7
162520	163032	-19.484485	133.370188					Northern Territory	11
162521	163033	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162523	163036	17.800676	79.009629					Telangana	87
162524	163037	14.710424	76.167912					Karnataka	87
162525	163038	10.945464	79.377584	Tamil Nadu Housing Board	Kumbakonam		Thanjavur	Tamil Nadu	87
162526	163039	24.9929	121.300966		Taoyuan City			Taoyuan City	214
162527	163040	50.4536	30.5038						196
162528	163041	-43.789427	-68.526525					Chubut	7
162529	163042	21.028279	105.853881				Hanoi	Hanoi	204
162531	163044	12.867997	74.842687		Mangaluru		Dakshina Kannada	Karnataka	87
162532	163045	41.8955	12.4823						93
162533	163046	38.8895	-77.032						198
162536	163049	-6.19752	106.83						85
162537	163050	-6.19752	106.83						85
162538	163051	51.5002	-0.126236						67
162540	163053	2.15362	117.494733		Berau			East Kalimantan	85
162541	163054	1.128784	104.040344		Batam			Riau Islands	85
162544	163057	26.939034	81.332461				Barabanki	Uttar Pradesh	87
162545	163058	26.939034	81.332461				Barabanki	Uttar Pradesh	87
162546	163059	56.244299	56.252801	Bashkortostan	Kazanchinskiy		Republic of Bashkortostan	Volga Federal District	161
162548	163061	45.129232	9.031332		Zinasco		Pavia	Lombardy	93
162549	163062	45.185888	9.156563		Pavia		Pavia	Lombardy	93
162550	163063	45.62067	9.769167					Lombardy	93
162551	163064	32.322671	35.717738					Ajlun	95
162552	163065	57.187612	39.427411		Rostov		Yaroslavl Oblast	Central Federal District	161
162553	163066	54.525963	15.255119						226
162555	163068	53.390296	58.836112	Krasnaya Bashkiriya	Krasnobashkirskiy		Republic of Bashkortostan	Volga Federal District	161
162556	163069	-6.919792	107.601809					West Java	85
162557	163070	51.047306	-114.05797		Calgary			AB	33
162558	163071	20.811577	105.335312		Hòa Bình		Hòa Bình	Hoa Binh	204
162559	163072	13.7308	100.521						185
162560	163073	31.499069	-99.36232					TX	198
162561	163074	43.850674	-73.430797		Ticonderoga		Essex	NY	198
162562	163075	25.059354	121.431372	Taishan District	New Taipei City			New Taipei City	214
162563	163076	31.3412	76.7631		Bilaspur		Bilaspur	Himachal Pradesh	87
162565	163078	-0.445914	117.1579	Sempaja Timur	Samarinda			East Kalimantan	85
162567	163080	-43.789427	-68.526525					Chubut	7
162568	163081	9.05804	7.48906						139
162575	163088	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162577	163090	48.7598	8.239792		Baden-Baden		Baden-Baden	Baden-Württemberg	49
162578	163091	27.892515	79.908843		Shahjahanpur		Shahjahanpur	Uttar Pradesh	87
162579	163092	27.892515	79.908843		Shahjahanpur		Shahjahanpur	Uttar Pradesh	87
162580	163093	28.56142	77.32978	Botanic Garden of Indian Republic	Noida		Noida	Uttar Pradesh	87
162581	163094	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162582	163095	25.450522	-80.485328		Florida City		Miami-Dade	FL	198
162583	163096	33.596961	130.408068		Fukuoka			Kyushu	96
162584	163097	49.985946	36.27354		Kharkiv		Kharkivskyi raion	Kharkiv Oblast	196
162585	163098	52.26	21.02						153
162648	163161	51.047306	-114.05797		Calgary			AB	33
162649	163162	\N	\N					Uttar Pradesh	87
162650	163163	\N	\N	Kurla					87
162655	163168	23.65613	85.564135					Jharkhand	87
162656	163169	\N	\N	Khordha district					87
162657	163170	\N	\N						198
162658	163171	\N	\N		Ichalkaranji taluka				87
162659	163172	\N	\N		Kolhapur				87
162660	163173	\N	\N		Ghaziabad				87
162661	163174	\N	\N	Oleksandrivka					196
162662	163175	\N	\N					Vinnytsia 	196
162663	163176	47.9129	106.937						129
162667	163179	\N	\N	Gampaha 					111
162668	163180	\N	\N	Colombo					111
162669	163181	\N	\N	Kalutara					111
162670	163182	\N	\N						93
162672	163184	\N	\N						148
162673	163185	\N	\N						148
162675	163187	\N	\N						198
162676	163188	\N	\N		Nsama				210
162677	163189	\N	\N		Nsama				210
162678	163190	\N	\N					 Khyber Pakhtunkhwa 	147
162679	163191	\N	\N						164
162680	163192	\N	\N		Hanoi 				204
162682	163194	\N	\N		Montrouis				83
162683	163195	6.4779	2.6323						16
162684	163196	\N	\N		Chandannagar				87
162685	163197	26.20047	127.72858		Naha			Okinawa	96
162686	163198	\N	\N		Lampang				185
162687	163199	\N	\N						204
162688	163200	-13.9908	-66.1936						26
162689	163201	\N	\N						59
162690	163202	\N	\N						59
162691	163203	13.7308	100.521						185
162692	163204	\N	\N	Gia Lai					204
162693	163205	\N	\N	Mount Laguna					198
162694	163206	\N	\N					 Delaware	198
162695	163207	\N	\N	Pirojpur					18
162696	163208	\N	\N						191
162697	163209	33.3302	44.394						90
162698	163210	38.8895	-77.032						198
162699	163211	\N	\N	Querétaro					122
162700	163212	\N	\N					Virginia 	198
162701	163213	\N	\N						198
162702	163214	\N	\N						185
162703	163215	\N	\N		LAHORE				147
162704	163216	\N	\N		Islamabad				147
162705	163217	\N	\N		Querétaro				122
162706	163218	39.158828	-75.521139		Dover		Kent	DE	198
162707	163219	\N	\N	Tamaulipas					122
162708	163220	\N	\N					Rzeszow region	153
162709	163221	\N	\N		 Hathras				87
162710	163222	\N	\N		Mumbai				87
162711	163223	\N	\N		Mumbai				87
162712	163224	\N	\N		Mumbai				87
162713	163225	23.553118	121.0211024						214
162715	163227	\N	\N						185
162716	163228	\N	\N		Mumbai				87
162719	163231	\N	\N	Karachay-Cherkessia					161
162721	163233	\N	\N	Morrison County					198
162722	163234	\N	\N	Morrison County					198
162723	163235	\N	\N						198
162724	163236	\N	\N						198
162725	163237	\N	\N		ahmedabad				87
162726	163238	\N	\N		ahmedabad				87
162727	163239	\N	\N		ahmedabad				87
162728	163240	\N	\N		Ahmedabad				87
162729	163241	\N	\N		ahmedabad				87
162730	163242	\N	\N		ahmedabad				87
162731	163243	\N	\N		Quetta				147
162732	163244	22.991622	120.185034		Tainan City			Tainan City	214
162733	163245	46.428323	34.249359	Kryvyi Rih	Novotroitska selyshchna hromada		Henicheskyi raion	Kherson Oblast	196
162734	163246	50.911895	34.80139	Sumy	Sumska Miska Hromada		Sumskyi raion	Sumy Oblast	196
162735	163247	49.839683	24.029717		Lvivska miska hromada		Lvivskyi raion	Lviv Oblast	196
162736	163248	22.777709	72.324999	Kerala	Bavla		Ahmedabad	Gujarat	87
162737	163249	50.613057	26.255016		Rivnenska miska hromada		Rivnenskyi raion	Rivne Oblast	196
162738	163250	\N	\N						198
162739	163251	50.613057	26.255016		Rivnenska miska hromada		Rivnenskyi raion	Rivne Oblast	196
162740	163252	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
162741	163253	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
162742	163254	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
162743	163255	13.7308	100.521						185
162744	163256	9.207571	-80.130373		Salud		Chagres	Colón	148
162745	163257	50.4536	30.5038						196
162746	163258	\N	\N						185
162747	163259	\N	\N					Samara region	161
162748	163260	\N	\N		Vaniyambadi				87
162749	163261	\N	\N		Mumbai				87
162750	163262	35.67	139.77						96
162751	163263	\N	\N		GHAZIABAD				87
162752	163264	\N	\N		GHAZIABAD				87
162753	163265	\N	\N		GHAZIABAD				87
162754	163266	52.058385	17.096947		Śrem Gmina		Śremski	Greater Poland	153
162755	163267	-7.977272	112.634099		Malang			East Java	85
162756	163268	50.0878	14.4205						48
162758	163270	23.723592	79.078801	Nawalpur	Rehli		Sagar	Madhya Pradesh	87
162759	163271	23.723592	79.078801	Nawalpur	Rehli		Sagar	Madhya Pradesh	87
162760	163272	38.8895	-77.032						198
162761	163273	2.038166	102.592674	Kampung Kelantan	Muar		Muar	Johor	135
162762	163274	31.7717	35.2035						92
162763	163275	27.6939	85.3157						143
162764	163276	43.106641	-79.065209		Niagara Falls			ON	33
162765	163277	37.9792	23.7166						74
162766	163278	35.1676	33.3736						47
162767	163279	39.446168	-6.505743		Malpartida de Cáceres		Cáceres	Extremadura	58
162768	163280	39.446168	-6.505743		Malpartida de Cáceres		Cáceres	Extremadura	58
162769	163281	39.446168	-6.505743		Malpartida de Cáceres		Cáceres	Extremadura	58
162770	163282	42.358994	-71.058629		Boston		Suffolk	MA	198
162771	163283	42.358994	-71.058629		Boston		Suffolk	MA	198
162772	163284	44.8024	20.4656						172
162773	163285	54.525963	15.255119						226
162774	163286	31.7717	35.2035						92
162775	163287	31.7717	35.2035						92
162776	163288	41.8955	12.4823						93
162777	163289	45.574662	10.707705		Garda		Verona	Veneto	93
162778	163290	41.929921	-88.751347		DeKalb		DeKalb	IL	198
162779	163291	35.278119	-93.133723		Illinois		Pope	AR	198
162780	163292	15.352	44.2075						208
162781	163293	21.0069	105.825						204
162782	163294	15.5932	32.5363						164
162783	163295	51.5002	-0.126236						67
162784	163296	33.72	73.06		Islamabad			Punjab	147
162785	163297	31.561917	74.348079	Lahore	Islamabad			Punjab	147
162786	163298	10.77653	106.700977		Ho Chi Minh City		Ho Chi Minh City	Ho Chi Minh City	204
162787	163299	10.77653	106.700977		Ho Chi Minh City		Ho Chi Minh City	Ho Chi Minh City	204
162788	163300	42.201024	-85.70631		Texas		Kalamazoo	MI	198
162789	163301	13.7308	100.521						185
162790	163302	33.962127	45.103611					Diyala	90
162791	163303	-3.382268	29.36358		Bujumbura		Bujumbura-Mairie	Bujumbura Mairie	14
162792	163304	-15.7801	-47.9292						27
162793	163305	40.4167	-3.70327						58
162795	163307	52.007673	47.82555		Balakovo		Saratov Oblast	Volga Federal District	161
162797	163309	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
162798	163310	5.27771	102.028305					Kelantan	135
162799	163311	53.390296	58.836112	Krasnaya Bashkiriya	Krasnobashkirskiy		Republic of Bashkortostan	Volga Federal District	161
162800	163312	56.244299	56.252801	Bashkortostan	Kazanchinskiy		Republic of Bashkortostan	Volga Federal District	161
162801	163313	52.26	21.02						153
162802	163314	28.6353	77.225						87
162803	163315	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
162804	163316	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
162805	163317	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162806	163318	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162807	163319	28.783001	79.017502		Rampur		Rampur	Uttar Pradesh	87
162808	163320	28.833143	78.765278		Moradabad		Moradabad	Uttar Pradesh	87
162809	163321	32.867408	-116.418748		Mount Laguna		San Diego	CA	198
162810	163322	32.867408	-116.418748		Mount Laguna		San Diego	CA	198
162811	163323	32.71576	-117.163817		San Diego		San Diego	CA	198
162812	163324	28.6353	77.225						87
162813	163325	26.460702	79.5105		Auraiya		Auraiya	Uttar Pradesh	87
162814	163326	9.02274	38.7468						60
162815	163327	-7.613085	111.496861	Grobogan	Madiun			East Java	85
162816	163328	22.565573	88.370215		Kolkata		Kolkata	West Bengal	87
162817	163329	51.047306	-114.05797		Calgary			AB	33
162818	163330	51.047306	-114.05797		Calgary			AB	33
162819	163331	28.632425	77.218791		New Delhi		New Delhi	Delhi	87
162820	163332	48.70959	44.51417		Volgograd		Volgograd Oblast	Southern Federal District	161
162821	163333	-2.94145	119.377877		Mamasa			West Sulawesi	85
162822	163334	38.192358	-0.555182		Santa Pola		Alicante	Community of Valencia	58
162823	163335	54.525963	15.255119						226
162824	163336	52.26	21.02						153
162825	163337	-34.6118	-58.4173						7
162826	163338	41.8955	12.4823						93
162827	163339	18.922005	105.603598	Diễn An	Diễn Châu		Diễn Châu	Nghe An	204
162828	163340	21.091555	106.207382	Đại Lai	Gia Bình		Gia Bình	Bac Ninh	204
162829	163341	21.161887	105.520424	Vĩnh Ninh	Vĩnh Tường		Vĩnh Tường	Vinh Phuc	204
162830	163342	21.028279	105.853881		Hanoi		Hanoi	Hanoi	204
162831	163343	15.352	44.2075						208
162832	163344	15.352	44.2075						208
162833	163345	10.992533	25.241758					Southern Darfur	164
162834	163346	24.914105	80.804667		Majhgawan		Satna	Madhya Pradesh	87
162835	163347	29.794178	76.401991		Kaithal		Kaithal	Haryana	87
162836	163348	23.252321	77.431095		Bhopal		Bhopal	Madhya Pradesh	87
162837	163349	53.393547	89.892484				Republic of Khakassia	Siberian Federal District	161
162838	163350	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
162839	163351	30.338433	76.830092		Ambala		Ambala	Haryana	87
162840	163352	30.338433	76.830092		Ambala		Ambala	Haryana	87
162841	163353	30.338433	76.830092		Ambala		Ambala	Haryana	87
162842	163354	23.369904	85.325276		Ranchi		Ranchi	Jharkhand	87
162843	163355	23.369904	85.325276		Ranchi		Ranchi	Jharkhand	87
162844	163356	51.5002	-0.126236						67
162845	163357	42.884419	74.576619						99
162846	163358	-7.027351	110.914784		Grobogan			Central Java	85
162847	163359	-6.174757	106.827073		Jakarta			Jakarta	85
162848	163360	25.432227	78.721837	Bhupnagar	Jhansi Tehsil		Jhansi	Uttar Pradesh	87
162849	163361	25.432227	78.721837	Bhupnagar	Jhansi Tehsil		Jhansi	Uttar Pradesh	87
162850	163362	55.7558	37.6176						161
162851	163363	55.7558	37.6176						161
162852	163364	25.038412	121.563705		Taipei City			Taipei City	214
162853	163365	28.6353	77.225						87
162854	163366	-15.3982	28.2937						210
162855	163367	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162856	163368	51.1879	71.4382						97
162857	163369	22.839592	86.216091	Jharkhand Colony	Jamshedpur		Jamshedpur	Jharkhand	87
162858	163371	3.12433	101.684						135
162859	163372	28.409912	77.870727		Bulandsahar		Bulandsahar	Uttar Pradesh	87
162861	163373	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162862	163374	51.5002	-0.126236						67
162863	163375	51.5002	-0.126236						67
162864	163376	51.5002	-0.126236						67
162865	163377	54.19214	37.616451		Tula		Tula Oblast	Central Federal District	161
162866	163378	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162867	163379	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162868	163380	22.310051	70.739684		Rajkot		Rajkot	Gujarat	87
162870	163382	47.784324	9.609834		Ravensburg		Ravensburg	Baden-Württemberg	49
162871	163383	47.784324	9.609834		Ravensburg		Ravensburg	Baden-Württemberg	49
162872	163384	1.619319	18.061492		Impfondo		Impfondo	Likouala	40
162873	163385	50.449749	30.523718		Kyiv		Kyiv	Kyiv	196
162874	163386	17.800676	79.009629					Telangana	87
162875	163387	12.976746	77.575278		Bengaluru		Bengaluru	Karnataka	87
162876	163388	37.9792	23.7166						74
162877	163389	37.9792	23.7166						74
162878	163390	31.923566	77.236214					Himachal Pradesh	87
162879	163391	40.604148	-122.496727		Shasta		Shasta	CA	198
162880	163392	-3.3784	29.3639						14
162976	163483	27.568485	78.646817		Etah		Etah	Uttar Pradesh	87
162881	163393	36.293297	44.058902	Kurdistan City	Erbil		Erbil	Erbil	90
162882	163394	23.091125	72.512512	Sola	Ahmedabad		Ahmedabad	Gujarat	87
162883	163395	23.707306	90.415483						18
162884	163396	45.400639	20.077984					Vojvodina	172
162885	163397	45.400639	20.077984					Vojvodina	172
162886	162885	28.256297	77.845623		Khurja		Bulandsahar	Uttar Pradesh	87
162889	163399	32.259539	75.632071		Pathankot		Pathankot	Punjab	87
162890	162848	23.7055	90.4113						18
162891	163400	49.985946	36.27354		Kharkiv		Kharkivskyi raion	Kharkiv Oblast	196
162892	163401	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162893	163402	24.871938	66.988063		Karachi			Sind	147
162894	163403	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
162895	162406	25.917	80.801498		Fatehpur		Fatehpur	Uttar Pradesh	87
162896	163404	50.449552	30.589361	Dniprovskyi	Kyiv		Kyiv	Kyiv	196
162897	163405	50.911895	34.80139	Sumy	Sumska Miska Hromada		Sumskyi raion	Sumy Oblast	196
162898	163406	45.50001	33.799794	Rivne	Susaninska silska rada		Pervomaiskyi raion	Autonomous Republic of Crimea	196
162899	163381	35.67	139.77						96
162900	162716	37.130677	-6.484857	El Rocío	Almonte		Huelva	Andalusia	58
162901	162467	15.352	44.2075						208
162903	163408	23.7055	90.4113						18
162904	163409	23.7055	90.4113						18
162905	163410	41.8955	12.4823						93
162906	163411	23.65613	85.564135					Jharkhand	87
162907	163412	23.65613	85.564135					Jharkhand	87
162908	163413	34.798393	-106.707137		Valencia		Valencia	NM	198
162909	163414	-3.3784	29.3639						14
162911	163416	23.7055	90.4113						18
162912	163417	22.828218	104.980886		Hà Giang		Hà Giang	Ha Giang	204
162913	163418	21.293002	103.008356		Dien Bien		Điện Biên	Dien Bien	204
162914	163419	21.0069	105.825						204
162915	163420	23.7055	90.4113						18
162916	163421	23.7055	90.4113						18
162917	163422	34.679171	-1.919241		Oujda		Oujda Angad	Oriental	117
162918	163423	44.318877	11.801391		Castel Bolognese		Ravenna	Emilia Romagna	93
162919	163425	43.603949	1.444509		Toulouse		Haute-Garonne	Occitania	63
162920	163426	19.427	-99.1276						122
162921	163427	-34.6118	-58.4173						7
162922	163428	-3.3784	29.3639						14
162923	163429	43.310643	-3.928877		Castañeda		Cantabria	Cantabria	58
162924	163430	35.67	139.77						96
162925	163431	30.391755	-95.696711		Montgomery		Montgomery	TX	198
162926	163432	52.26	21.02						153
162927	162587	50.449749	30.523718		Kyiv		Kyiv	Kyiv	196
162928	163433	38.8895	-77.032						198
162929	163434	28.351839	79.409555		Bareilly		Bareilly	Uttar Pradesh	87
162930	163435	23.7055	90.4113						18
162931	163436	9.63701	-84.0089						44
162932	163437	23.65613	85.564135					Jharkhand	87
162933	163438	23.65613	85.564135					Jharkhand	87
162934	163439	40.717844	-111.882619		South Salt Lake		Salt Lake	UT	198
162935	163440	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
162936	163441	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162937	163442	23.7055	90.4113						18
162938	163443	51.047306	-114.05797		Calgary			AB	33
162939	163444	51.047306	-114.05797		Calgary			AB	33
162940	163445	51.5002	-0.126236						67
162941	163446	35.67	139.77						96
162942	163447	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
162943	163448	52.660909	53.673682		Sverdlovskiy		Orenburg Oblast	Volga Federal District	161
162944	163449	22.282154	114.156885						80
162946	163450	39.190665	-106.819201				Pitkin	CO	198
162947	163451	47.91285	-122.093048		Snohomish		Snohomish	WA	198
162948	163452	34.047863	100.619652						225
162949	163453	54.525963	15.255119						226
162950	163454	27.842026	-82.791255		Seminole		Pinellas	FL	198
162951	163455	28.6353	77.225						87
162952	163456	51.047306	-114.05797		Calgary			AB	33
162953	163457	23.65613	85.564135					Jharkhand	87
162954	163458	23.65613	85.564135					Jharkhand	87
162955	163459	40.717844	-111.882619		South Salt Lake		Salt Lake	UT	198
162956	163460	21.0069	105.825						204
162957	163461	27.014242	84.054951		Piprasi		Pashchim Champaran	Bihar	87
162958	163462	59.9138	10.7387						142
162959	163464	23.7055	90.4113						18
162960	163465	23.7055	90.4113						18
162961	163467	10.77653	106.700977				Ho Chi Minh City	Ho Chi Minh City	204
162962	163468	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162963	163469	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
162964	163471	35.67	139.77						96
162965	163472	23.65613	85.564135					Jharkhand	87
162966	163473	23.65613	85.564135					Jharkhand	87
162967	163474	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
162968	163475	23.7055	90.4113						18
162969	163476	23.7055	90.4113						18
162970	163477	23.7055	90.4113						18
162971	163478	31.1429	74.561699	Khemkaran	Patti		Tarn Taran	Punjab	87
162972	163479	38.8895	-77.032						198
162973	163480	5.27771	102.028305					Kelantan	135
162974	163481	12.976746	77.575278		Bengaluru		Bengaluru	Karnataka	87
162975	163482	32.77647	-79.931027		Charleston			SC	198
162977	163484	27.596664	78.048021		Hathras		Hathras	Uttar Pradesh	87
162978	163485	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162979	163486	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162980	163487	50.040147	21.979795		Rzeszów		Rzeszów	Subcarpathia	153
162981	163488	52.234979	21.008492		Warsaw		Warsaw	Mazovia	153
162982	163489	28.6353	77.225						87
162985	163492	41.8955	12.4823						93
162986	163493	18.479	-69.8908						53
162987	163494	23.7055	90.4113						18
162988	163495	52.26	21.02						153
162989	163496	49.47176	17.971554		Valašské Meziříčí		Vsetín	Zlín	48
162990	163497	49.436836	14.575192		Meziříčí		Tábor	South Bohemia	48
162991	163498	51.5002	-0.126236						67
162992	163499	23.7055	90.4113						18
162994	163501	59.3327	18.0645						178
162995	163502	44.305913	-78.320087		Peterborough			ON	33
162996	163504	44.305913	-78.320087		Peterborough			ON	33
162997	163505	45.4215	-75.6919						33
162999	163507	46.0546	14.5044						177
163000	163508	26.155119	73.226821	Birami	Jodhpur Tehsil		Jodhpur	Rajasthan	87
163294	163805	\N	\N						194
163001	163509	9.920129	78.110878		Madurai		Madurai	Tamil Nadu	87
163003	163511	37.5323	126.957						103
163004	163512	33.26131	126.618839	Seogwipo	Jeju			Cheju-Do	103
163005	163513	52.3738	4.89095						141
163006	163514	44.8024	20.4656						172
163010	163518	-34.8941	-56.0675						197
163012	163520	42.884419	74.576619						99
163013	163521	26.061882	94.46818					Nagaland	87
163014	163523	51.047306	-114.05797		Calgary			AB	33
163015	163524	51.047306	-114.05797		Calgary			AB	33
163270	162339	52.26	21.02						153
163271	163060	-29.689233	-51.467059		Montenegro			Rio Grande do Sul	27
163272	162653	25.922679	82.999176	Uttar Gaona	Nizamabad		Azamgarh	Uttar Pradesh	87
163273	162219	51.5002	-0.126236						67
163274	163787	-6.542189	-37.713504		Mato Grosso			Paraíba	27
163275	162448	-6.542189	-37.713504		Mato Grosso			Paraíba	27
163276	163788	-15.939051	-50.140237		Goiás			Goiás	27
163277	162944	\N	\N	Goiás					27
163289	163800	51.5002	-0.126236						67
163291	163802	19.427	-99.1276						39
163292	163803	\N	\N						98
163293	163804	\N	\N						98
163295	163806	59.3327	18.0645						178
163296	163807	\N	\N				Jefferson County	Washington	198
163298	163809	54.525963	15.255119						226
163302	163813	\N	\N						39
163303	163814	\N	\N		Lahore				147
163305	163816	\N	\N					Sulaymaniyah	90
163308	163819	\N	\N					Kingston, Frontenac, Lennox and Addington	33
163312	163823	-15.7801	-47.9292						27
163319	163830	\N	\N						93
163322	163833	\N	\N						18
163325	163836	\N	\N					Norfolk	67
163327	163838	18.969047	72.821181		Mumbai		Mumbai	Maharashtra	87
163329	163840	\N	\N						172
163331	163842	\N	\N		Rzeszow				153
163332	163843	\N	\N				Los Angeles County	California	198
163333	163844	\N	\N		Kuberpur				147
163336	163847	\N	\N	Kirov	St Petersburg				161
163338	163849	\N	\N					Norfolk	67
163339	163850	\N	\N		Rzeszow				153
163353	163864	\N	\N	Jogulamba Gadwal				Telengana	87
163356	163867	\N	\N		Mykolaiv				196
163365	163876	\N	\N		Caceres				58
163368	163879	\N	\N					Connecticut	198
163371	163882	\N	\N				Lawrence County	Pennsylvania	198
163372	163883	21.0069	105.825						204
163373	163884	\N	\N						198
163375	163886	\N	\N						27
163377	163888	\N	\N		Oujda				117
163384	163895	\N	\N		Kagoshima				96
163387	163897	\N	\N						58
163388	163898	\N	\N		Imbersago				93
163389	163899	\N	\N						18
163394	163904	\N	\N					Udayapur	143
163397	163907	\N	\N					Diyala Prefecture	90
163403	163913	\N	\N						27
163405	163915	\N	\N					Chaco	7
163406	163916	\N	\N					Queretaro	122
163413	163923	\N	\N		Saitama				96
163414	163924	\N	\N		Saitama				96
163415	163925	\N	\N		Rzeszow				153
163420	163930	\N	\N		Bengaluru				87
163421	163931	\N	\N		Moscow				161
163422	163932	\N	\N	Kirov	St Petersburg				161
163435	163945	23.7055	90.4113						18
163441	163951	\N	\N		Voronezh				161
163444	163954	\N	\N					Connecticut	198
163445	163955	\N	\N					Connecticut	198
163447	163957	\N	\N		Shahkund				87
163450	163960	21.0069	105.825						204
163452	163962	\N	\N					Chaco	7
163453	163963	\N	\N		Voronezh				161
163458	163968	\N	\N					Norfolk	67
163461	163971	\N	\N					Gujurat	87
163462	163972	\N	\N					Gujarat	87
163468	163978	\N	\N						87
163472	163982	\N	\N		Elektrogorsk				161
163473	163983	\N	\N		Elektrogorsk				161
163474	163984	\N	\N		Elektrogorsk				161
163477	163987	\N	\N		Bilochpura				87
163479	163989	\N	\N	Kirov	St Petersburg				161
163480	163990	\N	\N		Mykolaiv				196
163481	163991	\N	\N					Norfolk	67
163483	163993	\N	\N		Kurume				96
163497	164007	\N	\N					Kirovrohad	196
163498	164008	\N	\N		Davengere				87
163500	164010	\N	\N		Penukonda				87
163502	164012	\N	\N						87
163508	164018	\N	\N						47
163516	164026	59.3327	18.0645						178
163518	164028	\N	\N		Caceres				58
163519	164029	\N	\N		Caceres				58
163531	164041	\N	\N						198
163533	164043	\N	\N		Imbersago				93
163534	164044	\N	\N					Bang Khen	185
163535	164045	\N	\N		Bangkok				185
163536	164046	\N	\N		Bangkok				185
163539	164049	\N	\N						198
163540	164050	\N	\N						147
163541	164051	\N	\N						204
163543	164053	40.4167	-3.70327						58
163544	164054	\N	\N					Diyala Prefecture	90
163545	164055	\N	\N		Ho Chi Minh				204
163546	164056	\N	\N					Mato Grosso do Sol	27
163549	164059	\N	\N				Los Angeles County	California	198
163551	164061	\N	\N						204
163552	164062	28.6353	77.225						87
163554	164064	\N	\N					Queretaro	122
163557	164067	\N	\N		Lgov			Kursk	161
163558	164068	\N	\N		Lgov			Kursk	161
163559	164069	\N	\N		Lgov			Kursk	161
163560	164070	\N	\N						93
163561	164071	\N	\N		Sochi				161
163563	164073	\N	\N		Mumbai				87
163564	164074	\N	\N						96
163565	164075	\N	\N		Sochi				161
163567	164077	\N	\N					Buryatia	161
163568	164078	\N	\N						178
163569	164079	\N	\N		Voronezh				161
163570	164080	\N	\N		Rzeszow				153
163572	164082	\N	\N					Chaco	7
163573	164083	\N	\N		Voronezh				161
163574	164084	\N	\N					Bujumbura	14
163575	164085	59.3327	18.0645						178
163576	164086	\N	\N		Ahmedabad				147
163577	164087	\N	\N		Pekalongan				85
163579	164089	\N	\N						87
163581	164091	52.26	21.02						153
163582	164092	\N	\N		Mykolaiv				196
163586	164096	35.67	139.77						96
163587	164097	\N	\N		Buraby				97
163588	164098	\N	\N		Hanoi				204
163589	164099	\N	\N		Ghaziabad				87
163748	164259	30.5167	72.8						147
163752	164263	25.661742	-100.135983	Coahuila	Juárez			Nuevo León	122
163754	164265	28.6353	77.225						87
163755	164266	16.6887	74.4589		Ichalkaranji		Kolhapur	Maharashtra	87
163764	164275	38.8895	-77.032						198
163768	164279	24.772087	-107.693322	Nayarit	Navolato			Sinaloa	122
163770	164281	-8.532221	140.48527		Merauke			Papua	85
163773	164284	5.420251	100.311923				Penang	Pinang	135
163774	164285	5.420251	100.311923				Penang	Pinang	135
163781	164293	52.26	21.02						153
163904	164415	-3.3784	29.3639						14
163905	164416	59.938484	30.312485		Saint Petersburg		Saint Petersburg	Northwestern Federal District	161
163906	164417	-24.814313	-65.435891		Salta		Capital	Salta	7
163907	164418	-24.814313	-65.435891		Salta		Capital	Salta	7
163908	164419	38.041934	-78.520726		University of Virginia			VA	198
163909	164420	28.669081	77.430413		Ghaziabad		Ghaziabad	Uttar Pradesh	87
163910	164421	0.314269	32.5729						195
163911	164422	15.5932	32.5363						164
163912	164423	-4.2767	15.2662						40
163913	164424	1.07208	104.467451		Bintan			Riau Islands	85
163914	164425	23.65613	85.564135					Jharkhand	87
163915	164426	38.8895	-77.032						198
163916	164427	56.326557	44.00811		Nizhny Novgorod		Nizhny Novgorod Oblast	Volga Federal District	161
163917	164428	17.361719	78.475169		Hyderabad		Hyderabad	Telangana	87
163918	164429	38.8895	-77.032						198
163919	164430	31.499069	-99.36232					TX	198
163920	164431	34.486874	72.089469					Khyber Pakhtunkhwa	147
163921	164432	21.0069	105.825						204
163922	164433	23.7055	90.4113						18
163923	164434	59.3327	18.0645						178
163924	164435	22.1667	113.55						116
163927	164438	26.245611	68.406732	Nawabshah	Karachi			Sind	147
163928	164439	23.7055	90.4113						18
163929	164440	31.760106	-106.492292		El Paso		El Paso	TX	198
163934	164445	32.800929	130.700642	Kumamoto	Fukuoka			Kyushu	96
163935	164446	32.800929	130.700642	Kumamoto	Fukuoka			Kyushu	96
163936	164447	32.800929	130.700642	Kumamoto	Fukuoka			Kyushu	96
163937	164448	13.797595	108.240955					Gia Lai	204
163938	164449	38.8895	-77.032						198
163939	164450	1.07208	104.467451		Bintan			Riau Islands	85
163940	164451	26.861253	83.933396				Kushinagar	Uttar Pradesh	87
164274	164788	\N	\N					Florida	198
164275	163517	\N	\N					Georgia	198
164276	164090	-25.746	28.1871						209
\.


--
-- Data for Name: report_data_point_syndrome; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.report_data_point_syndrome (id, report_id, syndrome_id) FROM stdin;
12854	162088	3
12855	162100	1
12856	162112	1
12857	162136	3
12858	162141	7
12859	162147	3
12860	162148	7
12861	162160	7
12862	162177	3
12863	162178	3
12864	162231	1
12865	162233	3
12866	162248	21
12867	162256	1
12868	162277	3
12869	162278	3
12870	162289	7
12871	162298	3
12873	162324	7
12874	162325	7
12875	162326	7
12876	162331	21
12877	162335	21
13001	162339	10
12879	162343	7
12880	162344	3
12881	162345	3
12882	162352	3
12883	162353	3
12885	162389	10
12886	162393	10
12962	162406	7
12888	162407	7
12889	162414	7
12890	162416	9
12891	162420	3
12892	162447	9
12895	162485	21
12902	162542	7
12903	162552	3
12904	162553	3
12905	162574	3
12964	162587	3
12908	162592	3
12909	162593	3
12911	162601	4
12912	162625	3
12914	162679	21
12915	162684	7
12917	162722	3
12918	162759	7
12919	162765	3
12958	162885	7
12922	162910	3
12924	162976	3
12926	163017	3
12927	163024	3
12928	163036	7
12929	163037	7
12930	163038	7
12931	163057	7
12941	163221	7
12942	163231	3
12944	163237	3
12945	163240	3
12946	163262	3
12947	163298	21
12948	163299	21
12949	163302	1
12950	163324	7
12951	163347	7
12952	163349	10
12953	163361	7
12954	163372	7
12963	163381	3
12957	163385	3
12961	163402	21
12965	163446	3
12967	163467	21
12968	163478	7
12969	163498	9
12970	163511	7
13003	163802	2
13004	163803	2
13005	163804	2
13006	163805	2
13010	163864	7
13011	163888	3
13013	163907	1
13015	163932	3
13019	163972	7
13020	163983	10
13021	163987	7
13022	163993	5
13023	164008	3
13025	164010	3
13028	164044	3
13029	164045	3
13030	164046	3
13031	164054	1
13032	164055	21
13034	164097	3
13044	164263	7
13048	164279	3
13059	164416	3
13060	164428	7
13061	164435	3
13062	164445	3
\.


--
-- Data for Name: subregions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subregions (id, subregion, iso3, hindi_translation) FROM stdin;
7	Sub-Saharan Africa	IOT	उप-सहारा अफ्रीका
8	Sub-Saharan Africa	BDI	उप-सहारा अफ्रीका
9	Sub-Saharan Africa	COM	उप-सहारा अफ्रीका
60	Latin America and the Caribbean	AIA	लैटिन अमेरिका और कैरेबियना
61	Latin America and the Caribbean	ATG	लैटिन अमेरिका और कैरेबियना
62	Latin America and the Caribbean	ABW	लैटिन अमेरिका और कैरेबियना
63	Latin America and the Caribbean	BHS	लैटिन अमेरिका और कैरेबियना
64	Latin America and the Caribbean	BRB	लैटिन अमेरिका और कैरेबियना
65	Latin America and the Caribbean	BES	लैटिन अमेरिका और कैरेबियना
66	Latin America and the Caribbean	VGB	लैटिन अमेरिका और कैरेबियना
67	Latin America and the Caribbean	CYM	लैटिन अमेरिका और कैरेबियना
68	Latin America and the Caribbean	CUB	लैटिन अमेरिका और कैरेबियना
69	Latin America and the Caribbean	CUW	लैटिन अमेरिका और कैरेबियना
70	Latin America and the Caribbean	DMA	लैटिन अमेरिका और कैरेबियना
71	Latin America and the Caribbean	DOM	लैटिन अमेरिका और कैरेबियना
72	Latin America and the Caribbean	GRD	लैटिन अमेरिका और कैरेबियना
73	Latin America and the Caribbean	GLP	लैटिन अमेरिका और कैरेबियना
74	Latin America and the Caribbean	HTI	लैटिन अमेरिका और कैरेबियना
75	Latin America and the Caribbean	JAM	लैटिन अमेरिका और कैरेबियना
76	Latin America and the Caribbean	MTQ	लैटिन अमेरिका और कैरेबियना
77	Latin America and the Caribbean	MSR	लैटिन अमेरिका और कैरेबियना
78	Latin America and the Caribbean	PRI	लैटिन अमेरिका और कैरेबियना
79	Latin America and the Caribbean	BLM	लैटिन अमेरिका और कैरेबियना
112	Northern America	BMU	उत्तरी अमेरिका
113	Northern America	CAN	उत्तरी अमेरिका
114	Northern America	GRL	उत्तरी अमेरिका
115	Northern America	SPM	उत्तरी अमेरिका
116	Northern America	USA	उत्तरी अमेरिका
117	Central Asia	KAZ	मध्य एशिया
118	Central Asia	KGZ	मध्य एशिया
119	Central Asia	TJK	मध्य एशिया
120	Central Asia	TKM	मध्य एशिया
121	Central Asia	UZB	मध्य एशिया
122	Eastern Asia	CHN	पूर्वी एशिया
123	Eastern Asia	HKG	पूर्वी एशिया
124	Eastern Asia	MAC	पूर्वी एशिया
125	Eastern Asia	PRK	पूर्वी एशिया
126	Eastern Asia	JPN	पूर्वी एशिया
127	Eastern Asia	MNG	पूर्वी एशिया
128	Eastern Asia	KOR	पूर्वी एशिया
129	South-eastern Asia	BRN	दक्षिण-पूर्वी एशिया
130	South-eastern Asia	KHM	दक्षिण-पूर्वी एशिया
0	Northern Africa	DZA	उत्तरी अफ्रीका
1	Northern Africa	EGY	उत्तरी अफ्रीका
2	Northern Africa	LBY	उत्तरी अफ्रीका
3	Northern Africa	MAR	उत्तरी अफ्रीका
4	Northern Africa	SDN	उत्तरी अफ्रीका
5	Northern Africa	TUN	उत्तरी अफ्रीका
6	Northern Africa	ESH	उत्तरी अफ्रीका
10	Sub-Saharan Africa	DJI	उप-सहारा अफ्रीका
11	Sub-Saharan Africa	ERI	उप-सहारा अफ्रीका
12	Sub-Saharan Africa	ETH	उप-सहारा अफ्रीका
13	Sub-Saharan Africa	ATF	उप-सहारा अफ्रीका
14	Sub-Saharan Africa	KEN	उप-सहारा अफ्रीका
15	Sub-Saharan Africa	MDG	उप-सहारा अफ्रीका
16	Sub-Saharan Africa	MWI	उप-सहारा अफ्रीका
17	Sub-Saharan Africa	MUS	उप-सहारा अफ्रीका
18	Sub-Saharan Africa	MYT	उप-सहारा अफ्रीका
19	Sub-Saharan Africa	MOZ	उप-सहारा अफ्रीका
20	Sub-Saharan Africa	REU	उप-सहारा अफ्रीका
21	Sub-Saharan Africa	RWA	उप-सहारा अफ्रीका
140	Southern Asia	AFG	दक्षिणी एशिया
141	Southern Asia	BGD	दक्षिणी एशिया
142	Southern Asia	BTN	दक्षिणी एशिया
143	Southern Asia	IND	दक्षिणी एशिया
144	Southern Asia	IRN	दक्षिणी एशिया
145	Southern Asia	MDV	दक्षिणी एशिया
149	Western Asia	ARM	पश्चिमी एशिया
150	Western Asia	AZE	पश्चिमी एशिया
151	Western Asia	BHR	पश्चिमी एशिया
152	Western Asia	CYP	पश्चिमी एशिया
167	Eastern Europe	BLR	पूर्वी यूरोप
168	Eastern Europe	BGR	पूर्वी यूरोप
169	Eastern Europe	CZE	पूर्वी यूरोप
170	Eastern Europe	HUN	पूर्वी यूरोप
171	Eastern Europe	POL	पूर्वी यूरोप
172	Eastern Europe	MDA	पूर्वी यूरोप
173	Eastern Europe	ROU	पूर्वी यूरोप
174	Eastern Europe	RUS	पूर्वी यूरोप
175	Eastern Europe	SVK	पूर्वी यूरोप
176	Eastern Europe	UKR	पूर्वी यूरोप
177	Northern Europe	ALA	उत्तरी यूरोप
178	Northern Europe	GGY	उत्तरी यूरोप
179	Northern Europe	JEY	उत्तरी यूरोप
180	Northern Europe	DNK	उत्तरी यूरोप
181	Northern Europe	EST	उत्तरी यूरोप
193	Southern Europe	ALB	दक्षिणी यूरोप
194	Southern Europe	AND	दक्षिणी यूरोप
195	Southern Europe	BIH	दक्षिणी यूरोप
196	Southern Europe	HRV	दक्षिणी यूरोप
197	Southern Europe	GIB	दक्षिणी यूरोप
198	Southern Europe	GRC	दक्षिणी यूरोप
199	Southern Europe	VAT	दक्षिणी यूरोप
200	Southern Europe	ITA	दक्षिणी यूरोप
209	Western Europe	AUT	पश्चिमी यूरोप
210	Western Europe	BEL	पश्चिमी यूरोप
211	Western Europe	FRA	पश्चिमी यूरोप
212	Western Europe	DEU	पश्चिमी यूरोप
213	Western Europe	LIE	पश्चिमी यूरोप
214	Western Europe	LUX	पश्चिमी यूरोप
215	Western Europe	MCO	पश्चिमी यूरोप
216	Western Europe	NLD	पश्चिमी यूरोप
217	Western Europe	CHE	पश्चिमी यूरोप
218	Australia and New Zealand	AUS	ऑस्ट्रेलिया और न्यूजीलैंड
219	Australia and New Zealand	CXR	ऑस्ट्रेलिया और न्यूजीलैंड
220	Australia and New Zealand	CCK	ऑस्ट्रेलिया और न्यूजीलैंड
224	Melanesia	FJI	मेलानेशिया
225	Melanesia	NCL	मेलानेशिया
226	Melanesia	PNG	मेलानेशिया
227	Melanesia	SLB	मेलानेशिया
229	Micronesia	GUM	माइक्रोनेशिया
230	Micronesia	KIR	माइक्रोनेशिया
231	Micronesia	MHL	माइक्रोनेशिया
237	Polynesia	ASM	पोलीनेशियाा
238	Polynesia	COK	पोलीनेशियाा
239	Polynesia	PYF	पोलीनेशियाा
240	Polynesia	NIU	पोलीनेशियाा
241	Polynesia	PCN	पोलीनेशियाा
22	Sub-Saharan Africa	SYC	उप-सहारा अफ्रीका
23	Sub-Saharan Africa	SOM	उप-सहारा अफ्रीका
24	Sub-Saharan Africa	SSD	उप-सहारा अफ्रीका
25	Sub-Saharan Africa	UGA	उप-सहारा अफ्रीका
26	Sub-Saharan Africa	TZA	उप-सहारा अफ्रीका
27	Sub-Saharan Africa	ZMB	उप-सहारा अफ्रीका
28	Sub-Saharan Africa	ZWE	उप-सहारा अफ्रीका
29	Sub-Saharan Africa	AGO	उप-सहारा अफ्रीका
30	Sub-Saharan Africa	CMR	उप-सहारा अफ्रीका
31	Sub-Saharan Africa	CAF	उप-सहारा अफ्रीका
32	Sub-Saharan Africa	TCD	उप-सहारा अफ्रीका
33	Sub-Saharan Africa	COG	उप-सहारा अफ्रीका
34	Sub-Saharan Africa	COD	उप-सहारा अफ्रीका
35	Sub-Saharan Africa	GNQ	उप-सहारा अफ्रीका
36	Sub-Saharan Africa	GAB	उप-सहारा अफ्रीका
37	Sub-Saharan Africa	STP	उप-सहारा अफ्रीका
38	Sub-Saharan Africa	BWA	उप-सहारा अफ्रीका
39	Sub-Saharan Africa	SWZ	उप-सहारा अफ्रीका
40	Sub-Saharan Africa	LSO	उप-सहारा अफ्रीका
41	Sub-Saharan Africa	NAM	उप-सहारा अफ्रीका
42	Sub-Saharan Africa	ZAF	उप-सहारा अफ्रीका
43	Sub-Saharan Africa	BEN	उप-सहारा अफ्रीका
44	Sub-Saharan Africa	BFA	उप-सहारा अफ्रीका
45	Sub-Saharan Africa	CPV	उप-सहारा अफ्रीका
46	Sub-Saharan Africa	CIV	उप-सहारा अफ्रीका
47	Sub-Saharan Africa	GMB	उप-सहारा अफ्रीका
48	Sub-Saharan Africa	GHA	उप-सहारा अफ्रीका
49	Sub-Saharan Africa	GIN	उप-सहारा अफ्रीका
50	Sub-Saharan Africa	GNB	उप-सहारा अफ्रीका
51	Sub-Saharan Africa	LBR	उप-सहारा अफ्रीका
52	Sub-Saharan Africa	MLI	उप-सहारा अफ्रीका
53	Sub-Saharan Africa	MRT	उप-सहारा अफ्रीका
54	Sub-Saharan Africa	NER	उप-सहारा अफ्रीका
55	Sub-Saharan Africa	NGA	उप-सहारा अफ्रीका
56	Sub-Saharan Africa	SHN	उप-सहारा अफ्रीका
57	Sub-Saharan Africa	SEN	उप-सहारा अफ्रीका
58	Sub-Saharan Africa	SLE	उप-सहारा अफ्रीका
59	Sub-Saharan Africa	TGO	उप-सहारा अफ्रीका
80	Latin America and the Caribbean	KNA	लैटिन अमेरिका और कैरेबियना
192	Northern Europe	GBR	उत्तरी यूरोप
81	Latin America and the Caribbean	LCA	लैटिन अमेरिका और कैरेबियना
82	Latin America and the Caribbean	MAF	लैटिन अमेरिका और कैरेबियना
83	Latin America and the Caribbean	VCT	लैटिन अमेरिका और कैरेबियना
84	Latin America and the Caribbean	SXM	लैटिन अमेरिका और कैरेबियना
85	Latin America and the Caribbean	TTO	लैटिन अमेरिका और कैरेबियना
86	Latin America and the Caribbean	TCA	लैटिन अमेरिका और कैरेबियना
87	Latin America and the Caribbean	VIR	लैटिन अमेरिका और कैरेबियना
88	Latin America and the Caribbean	BLZ	लैटिन अमेरिका और कैरेबियना
89	Latin America and the Caribbean	CRI	लैटिन अमेरिका और कैरेबियना
90	Latin America and the Caribbean	SLV	लैटिन अमेरिका और कैरेबियना
91	Latin America and the Caribbean	GTM	लैटिन अमेरिका और कैरेबियना
92	Latin America and the Caribbean	HND	लैटिन अमेरिका और कैरेबियना
93	Latin America and the Caribbean	MEX	लैटिन अमेरिका और कैरेबियना
94	Latin America and the Caribbean	NIC	लैटिन अमेरिका और कैरेबियना
95	Latin America and the Caribbean	PAN	लैटिन अमेरिका और कैरेबियना
96	Latin America and the Caribbean	ARG	लैटिन अमेरिका और कैरेबियना
97	Latin America and the Caribbean	BOL	लैटिन अमेरिका और कैरेबियना
98	Latin America and the Caribbean	BVT	लैटिन अमेरिका और कैरेबियना
99	Latin America and the Caribbean	BRA	लैटिन अमेरिका और कैरेबियना
100	Latin America and the Caribbean	CHL	लैटिन अमेरिका और कैरेबियना
101	Latin America and the Caribbean	COL	लैटिन अमेरिका और कैरेबियना
102	Latin America and the Caribbean	ECU	लैटिन अमेरिका और कैरेबियना
103	Latin America and the Caribbean	FLK	लैटिन अमेरिका और कैरेबियना
104	Latin America and the Caribbean	GUF	लैटिन अमेरिका और कैरेबियना
105	Latin America and the Caribbean	GUY	लैटिन अमेरिका और कैरेबियना
106	Latin America and the Caribbean	PRY	लैटिन अमेरिका और कैरेबियना
107	Latin America and the Caribbean	PER	लैटिन अमेरिका और कैरेबियना
108	Latin America and the Caribbean	SGS	लैटिन अमेरिका और कैरेबियना
109	Latin America and the Caribbean	SUR	लैटिन अमेरिका और कैरेबियना
110	Latin America and the Caribbean	URY	लैटिन अमेरिका और कैरेबियना
111	Latin America and the Caribbean	VEN	लैटिन अमेरिका और कैरेबियना
131	South-eastern Asia	IDN	दक्षिण-पूर्वी एशिया
132	South-eastern Asia	LAO	दक्षिण-पूर्वी एशिया
133	South-eastern Asia	MYS	दक्षिण-पूर्वी एशिया
134	South-eastern Asia	MMR	दक्षिण-पूर्वी एशिया
135	South-eastern Asia	PHL	दक्षिण-पूर्वी एशिया
136	South-eastern Asia	SGP	दक्षिण-पूर्वी एशिया
137	South-eastern Asia	THA	दक्षिण-पूर्वी एशिया
138	South-eastern Asia	TLS	दक्षिण-पूर्वी एशिया
139	South-eastern Asia	VNM	दक्षिण-पूर्वी एशिया
146	Southern Asia	NPL	दक्षिणी एशिया
147	Southern Asia	PAK	दक्षिणी एशिया
148	Southern Asia	LKA	दक्षिणी एशिया
153	Western Asia	GEO	पश्चिमी एशिया
154	Western Asia	IRQ	पश्चिमी एशिया
155	Western Asia	ISR	पश्चिमी एशिया
156	Western Asia	JOR	पश्चिमी एशिया
157	Western Asia	KWT	पश्चिमी एशिया
158	Western Asia	LBN	पश्चिमी एशिया
159	Western Asia	OMN	पश्चिमी एशिया
160	Western Asia	QAT	पश्चिमी एशिया
161	Western Asia	SAU	पश्चिमी एशिया
162	Western Asia	PSE	पश्चिमी एशिया
163	Western Asia	SYR	पश्चिमी एशिया
164	Western Asia	TUR	पश्चिमी एशिया
165	Western Asia	ARE	पश्चिमी एशिया
166	Western Asia	YEM	पश्चिमी एशिया
182	Northern Europe	FRO	उत्तरी यूरोप
183	Northern Europe	FIN	उत्तरी यूरोप
184	Northern Europe	ISL	उत्तरी यूरोप
185	Northern Europe	IRL	उत्तरी यूरोप
186	Northern Europe	IMN	उत्तरी यूरोप
187	Northern Europe	LVA	उत्तरी यूरोप
188	Northern Europe	LTU	उत्तरी यूरोप
189	Northern Europe	NOR	उत्तरी यूरोप
190	Northern Europe	SJM	उत्तरी यूरोप
191	Northern Europe	SWE	उत्तरी यूरोप
201	Southern Europe	MLT	दक्षिणी यूरोप
202	Southern Europe	MNE	दक्षिणी यूरोप
203	Southern Europe	MKD	दक्षिणी यूरोप
204	Southern Europe	PRT	दक्षिणी यूरोप
205	Southern Europe	SMR	दक्षिणी यूरोप
206	Southern Europe	SRB	दक्षिणी यूरोप
207	Southern Europe	SVN	दक्षिणी यूरोप
208	Southern Europe	ESP	दक्षिणी यूरोप
221	Australia and New Zealand	HMD	ऑस्ट्रेलिया और न्यूजीलैंड
222	Australia and New Zealand	NZL	ऑस्ट्रेलिया और न्यूजीलैंड
223	Australia and New Zealand	NFK	ऑस्ट्रेलिया और न्यूजीलैंड
228	Melanesia	VUT	मेलानेशिया
232	Micronesia	FSM	माइक्रोनेशिया
233	Micronesia	NRU	माइक्रोनेशिया
234	Micronesia	MNP	माइक्रोनेशिया
235	Micronesia	PLW	माइक्रोनेशिया
236	Micronesia	UMI	माइक्रोनेशिया
242	Polynesia	WSM	पोलीनेशियाा
243	Polynesia	TKL	पोलीनेशियाा
244	Polynesia	TON	पोलीनेशियाा
245	Polynesia	TUV	पोलीनेशियाा
246	Polynesia	WLF	पोलीनेशियाा
\.


--
-- Data for Name: syndrome; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.syndrome (id, syndrome, active, last_updated, hindi_translation, colour) FROM stdin;
1	Haemorrhagic Fever	1	2023-08-14 08:43:59	रक्तस्रावी बुखार	#07a304
2	Acute Flaccid Paralysis	1	2023-08-14 08:43:59	तीव्र झूलता हुआ शिथिल पक्षाघात	#1ace3e
3	Acute gastroenteritis	1	2023-08-14 08:43:59	तीव्र आंत्रशोथ	#34ed87
5	Influenza-like illness	1	2023-08-14 08:43:59	इंफ्लूएंजा जैसी बीमारी	#56d8cd
6	Acute fever and rash	1	2023-08-14 08:43:59	तेज बुखार और दाने चकत्ते	#088ba5
8	Encephalitis 	1	2023-08-14 08:43:59	दिमागी बुखार	#377aef
9	Meningitis	1	2023-08-14 08:43:59	मस्तिष्कावरण शोथ	#2f3b93
10	pneumonia	1	2023-08-14 08:43:59	न्यूमोनिया	#5a4cba
16	Jaundice	1	2023-08-14 08:43:59	पीलिया	#ce0e61
\.


--
-- Name: article_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.article_id_seq', 1, false);


--
-- Name: article_reviewdata_field_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.article_reviewdata_field_id_seq', 1, false);


--
-- Name: article_reviewdata_point_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.article_reviewdata_point_id_seq', 1, false);


--
-- Name: article_reviewdata_point_nlp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.article_reviewdata_point_nlp_id_seq', 1, false);


--
-- Name: article_trace_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.article_trace_id_seq', 1, false);


--
-- Name: article article_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article
    ADD CONSTRAINT article_pkey PRIMARY KEY (id);


--
-- Name: article_reviewdata_field article_reviewdata_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_reviewdata_field
    ADD CONSTRAINT article_reviewdata_field_pkey PRIMARY KEY (id);


--
-- Name: article_reviewdata_point_nlp article_reviewdata_point_nlp_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_reviewdata_point_nlp
    ADD CONSTRAINT article_reviewdata_point_nlp_pkey PRIMARY KEY (id);


--
-- Name: article_reviewdata_point article_reviewdata_point_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_reviewdata_point
    ADD CONSTRAINT article_reviewdata_point_pkey PRIMARY KEY (id);


--
-- Name: article_trace article_trace_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.article_trace
    ADD CONSTRAINT article_trace_pkey PRIMARY KEY (id);


--
-- Name: colours_api colours_api_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.colours_api
    ADD CONSTRAINT colours_api_pkey PRIMARY KEY (id);


--
-- Name: country_data country_data_iso3_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_data
    ADD CONSTRAINT country_data_iso3_key UNIQUE (iso3);


--
-- Name: country_data country_data_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.country_data
    ADD CONSTRAINT country_data_pkey PRIMARY KEY (id);


--
-- Name: disease disease_colour_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.disease
    ADD CONSTRAINT disease_colour_key UNIQUE (colour);


--
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- Name: report_data_field report_data_field_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_field
    ADD CONSTRAINT report_data_field_name_key UNIQUE (name);


--
-- Name: report_data_field report_data_field_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_field
    ADD CONSTRAINT report_data_field_pkey PRIMARY KEY (id);


--
-- Name: report_data_field_type report_data_field_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_field_type
    ADD CONSTRAINT report_data_field_type_pkey PRIMARY KEY (id);


--
-- Name: report_data_point_disease report_data_point_disease_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_point_disease
    ADD CONSTRAINT report_data_point_disease_pkey PRIMARY KEY (id);


--
-- Name: report_data_point_location report_data_point_location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_point_location
    ADD CONSTRAINT report_data_point_location_pkey PRIMARY KEY (id);


--
-- Name: report_data_point_location report_data_point_location_report_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_point_location
    ADD CONSTRAINT report_data_point_location_report_id_key UNIQUE (report_id);


--
-- Name: report_data_point report_data_point_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_point
    ADD CONSTRAINT report_data_point_pkey PRIMARY KEY (id);


--
-- Name: report_data_point_syndrome report_data_point_syndrome_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_point_syndrome
    ADD CONSTRAINT report_data_point_syndrome_pkey PRIMARY KEY (id);


--
-- Name: report_data_point_syndrome report_data_point_syndrome_report_id_syndrome_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report_data_point_syndrome
    ADD CONSTRAINT report_data_point_syndrome_report_id_syndrome_id_key UNIQUE (report_id, syndrome_id);


--
-- Name: report report_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.report
    ADD CONSTRAINT report_pkey PRIMARY KEY (id);


--
-- Name: subregions subregions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.subregions
    ADD CONSTRAINT subregions_pkey PRIMARY KEY (id);


--
-- Name: syndrome syndrome_colour_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.syndrome
    ADD CONSTRAINT syndrome_colour_key UNIQUE (colour);


--
-- Name: syndrome syndrome_colour_key1; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.syndrome
    ADD CONSTRAINT syndrome_colour_key1 UNIQUE (colour);


--
-- Name: syndrome syndrome_colour_key2; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.syndrome
    ADD CONSTRAINT syndrome_colour_key2 UNIQUE (colour);


--
-- Name: syndrome syndrome_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.syndrome
    ADD CONSTRAINT syndrome_pkey PRIMARY KEY (id);


--
-- Name: syndrome syndrome_syndrome_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.syndrome
    ADD CONSTRAINT syndrome_syndrome_key UNIQUE (syndrome);


--
-- PostgreSQL database dump complete
--

