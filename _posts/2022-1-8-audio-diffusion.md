---
layout: post
title: "Generating music using images with Hugging Face’s new diffusers package"
permalink: /latency/
---
[**UPDATE**: I’ve also trained the model on 30,000 samples that have been used in music, sourced from [WhoSampled](https://whosampled.com) and [YouTube](https://youtube.com). The idea is that the model could be used to generate loops or “breaks” that can be sampled to make new tracks. People (“crate diggers”) go to a lot of lengths or are willing to pay a lot of money to find breaks in old records.]

I have been astonished by the recent improvements in Deep Learning models in the domains of image generation ([DALL-E 2](https://openai.com/dall-e-2/), [MidJourney](https://www.midjourney.com/home/), [Imagen](https://imagen.research.google/), [Make-A-Scene](https://ai.facebook.com/blog/greater-creative-control-for-ai-image-generation/), etc.) and text generation ([GPT-3](https://openai.com/api/), [BLOOM](https://huggingface.co/bigscience/bloom), [BART](https://huggingface.co/facebook/bart-large), [T5](https://huggingface.co/google/t5-v1_1-xl), etc.) but, at the same time, surprised by the relative lack of progress with audio generation. Two notable exceptions come to mind: [MuseNet](https://openai.com/blog/musenet/) treats sheet music as sequential tokens (similar to text) and leverages GPT-2, while [Jukebox](https://openai.com/blog/jukebox/) generates music from raw wave forms. Even so, is audio generation a laggard because there is less interest in it, or because it is intrinsically more challenging?
<!--more-->

Whatever the case, audio can easily be converted to an image and vice versa, by way of a [mel spectrogram](https://en.wikipedia.org/wiki/Mel-frequency_cepstrum).

![Mel spectrogram](https://github.com/teticio/audio-diffusion/blob/main/mel.png?raw=true)

The horizontal axis of the spectrogram is time, the vertical axis is frequency (on a log scale) and the shade represents amplitude (also on a log scale). The mel spectrogram is supposed to correspond closely to how the human ear perceives sound.

If we can now easily generate convincing looking photos of celebrities using AI, why not try to generate plausible spectrograms and convert them into audio? This is exactly what I have done using the new Hugging Face `diffusers` package.

### TL;DR

So, how well does it work? [Here](https://soundcloud.com/teticio2/sets/audio-diffusion-loops) are a few examples I have generated. You can also generate more for yourself using a model trained on almost 500 tracks (around 20,000 spectrograms) from my Spotify “liked” playlist on [Google Colab](https://colab.research.google.com/github/teticio/audio-diffusion/blob/master/notebooks/test_model.ipynb) or [Hugging Face Spaces](https://huggingface.co/spaces/teticio/audio-diffusion).

### Tell me more...

In the [repo](https://github.com/teticio/audio-diffusion), you will find utilities to create a dataset of spectrogram images from a directory of audio files, train a model to generate similar spectrograms and convert the generated spectrograms into audio. You will also find notebooks that allow you to play around with the pre-trained model.

If you are interested in the details of the model, then I recommend you read the [Denoising Diffusion Probabilistic Models](https://arxiv.org/abs/2006.11239) paper. According to Open AI, [diffusion models beat GANs at their own game](https://arxiv.org/pdf/2105.05233.pdf). The basic idea is that a model is trained to recover images from a version that has been corrupted by gaussian noise. If the model is trained with photos of celebrities, for example, it will come to learn what typical (or maybe not so typical!) facial features look like. To generate a random face of a celebrity, the model is given a completely random image and, each time it is run, the output image is slightly less noisy than before and looks a little more like a face (or a spectrogam in our case).

For simplicity, I chose to create square spectrogram images of 256 x 256 pixels, which correspond to five seconds of reasonable quality audio. I used Hugging Face’s accelerate package to split the batches into shards that would fit on my single RTX 2080 Ti GPU. The training took about 40 hours.

Bear in mind that my Spotify playlist is a bit of a mix of different styles of music. I felt it was important to use a training dataset that I knew intimately, so that I would be able to judge how much the model was creating and how much it was just regurgitating (as well as there being a good chance I might actually like the results). In the same way that the celebrities dataset is relatively homegenous, it would be interesting to train the model with piano only music, or just techno music, for example, to see whether it is able to learn anything about a particular genre.

### What’s next?

Music changed for ever with the advent of samplers. At first they were contraversial ([A Tribe Called Quest had to pay all the proceeds from “Can I Kick It?” to Lou Reed for the sample of “Walk on the Wild Side”](https://www.rollingstone.com/music/music-features/tribe-called-quest-lou-reed-got-all-the-money-for-can-i-kick-it-71760/)) but then they were [embraced by almost every genre](https://www.whosampled.com/). Finding a new hook to sample can be big business, so why not use AI to create new ones? What I would love to see is the equivalent of DALL-E 2 and company, but for prompt driven audio generation…