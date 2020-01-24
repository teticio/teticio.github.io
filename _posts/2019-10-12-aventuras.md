---
layout: post
title: "Aventuras con textos / Adventures with text"
permalink: /aventuras/
---
This is a set of Jupyter notebooks I have created (in both Spanish and English) to accompany classes I give in Masters in Artificial Intelligence on the latest developments in end-to-end NLP (Natural Language Processing) with neural networks.
<!--more-->

Some people say that 2018 was the "ImageNet" year for text. By this they are referring to the breakthroughs in image recognition and, in particular, *transfer learning*. That is to say, the possibility of training a large, computationally expensive model on a general data set, and being able to "fine-tune" this model for a specific task (for example, to tell the difference between dogs and cats). Up until recently, it has not been feasible to apply transfer learning to text based (or NLP) models.

* [References](https://github.com/teticio/aventuras-con-textos/blob/master/Referencias.ipynb). A list of links to all the relevant academic papers.
* [Classification of text with cutting edge models](https://github.com/teticio/aventuras-con-textos/blob/master/Clasificacion_de_texto_con_modelos_de_ultima_generacion.ipynb). An introduction to and comparison of Word2Vec, ELMo, BERT and XLNet models for classifying IMDB movie reviews as either positive or negative.
* [Attention](https://github.com/teticio/aventuras-con-textos/blob/master/Atencion.ipynb). A deep dive into the attention mechanism used in the Transformer - the main building block of BERT - starting from a simple Vec2Vec model to translate from English to Spanish.
* [BERT understands](https://github.com/teticio/aventuras-con-textos/blob/master/BERT_entiende.ipynb). Here we use a BERT model that has been fine-tuned on the SQuAD (Stanford Question Answering Dataset) to answer reading comprehension questions about a Harry Potter book.
* [BERT predicts](https://github.com/teticio/aventuras-con-textos/blob/master/BERT_predice.ipynb). BERT is trained to be able to fill in the missing words in a sentence.
* [Bertle](https://github.com/teticio/aventuras-con-textos/blob/master/Bertle.gif). A semantic search engine that uses BERT sentence embeddings to find relevant articles from Stack Overflow.
* [Dr BERT](https://github.com/teticio/aventuras-con-textos/blob/master/Dr_Bert.ipynb). A psychoanalyst inspired by [Eliza](http://psych.fullerton.edu/mbirnbaum/psych101/Eliza.htm) and trained using the transcripts of Dr Carl Rogers.
* [Language models](https://github.com/teticio/aventuras-con-textos/blob/master/Modelos_de_lenguaje.ipynb). A language model is a function that estimates the probability of the next word (or *token*) conditioned on the text that precedes it. Here we are going to use the GPT-2 language model to predict the continuation of a sentence and to draw attention to unlikely constructions.
* [Text generation with cutting edge models](https://github.com/teticio/aventuras-con-textos/blob/master/Modelos_generativos_de_texto_de_ultima_generacion.ipynb). Language Models XLNet and GPT-2 are used to generate random prose, from writing chapters of Game of Thrones to generating tweets in the style of Donald [Trump](/trumpy/).
* [Amazon opinions](https://github.com/teticio/aventuras-con-textos/blob/master/Amazon_Opiniones.ipynb). A Kaggle style competition to use what you have learned to create a model to classify Amazon reviews as either negative or positive. Extra challenges arise from having a very small, unbalanced data set in Spanish.
* [GPT-2](https://github.com/teticio/aventuras-con-textos/blob/master/GPT2.py). A Python script using Hugging Face's PyTorch implementation to generate text with the 1.5 billion parameter GPT-2 model released by [OpenAI](https://openai.com/blog/gpt-2-1-5b-release/) in November 2019.

All the notebooks can be run on [Google Colab](https://colab.research.google.com/github/teticio/aventuras-con-textos) and the pre-trained checkpoints downloaded to Google Drive.