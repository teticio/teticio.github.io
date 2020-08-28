---
layout: post
title: "WordPro"
permalink: /wordpro/
---
A Professional Word Processor ;-)
<!--more-->

![wordpro.png](/assets/wordpro.png)

I'm probably not the only person to have come up with the cunning play on words WordPro - as in Word Processor and Word Professional - but I was probably one of the first to do so, as this was 1985 and I was 13 years old. This was my O Level Computer Studies project, which I taught myself and took two years early. I'm not quite sure what possesed me to do that, as it certainly wasn't my parents' idea. I was such a computer nerd at the time (and still am, if I am honest) that I decided I would program a word processor - ahem, more of a text editor really - in 6502 assembler language on my BBC Micro B.

I scanned in my listing using Dropbox and then converted the [PDF](https://github.com/teticio/WordPro/blob/master/WordPro.pdf) to text using [Tesseract OCR](https://github.com/tesseract-ocr/tesseract). It struggled with the outdated font and confused "D" with "0" and "&" with 4, 8 and sometimes even 2, but it did a very good job, all things considered. One of the problems with assembler language is that it is so economical that almost anything makes sense, but doesn't necessarily do what you want it to. It has been a very strange experience debugging* the program on a BBC Micro emulator running on Ubuntu via NoMachine on my Windows laptop. What a difference it makes to have so much screen real estate and the ability to consult the "[BBC Microcomputer Advanced User Guide](http://stardot.org.uk/mirrors/www.bbcdocs.com/filebase/essentials/BBC%20Microcomputer%20Advanced%20User%20Guide.pdf)" online. It was incredible how all this buried knowledge started coming back to me after 35 years! What was particularly surprising was that I felt that same feeling of unease and even fear that I used to feel whenever the computer crashed and started spitting out random coloured blocks and making odd beeping noises. That always used to freak me out when I was a kid and I would have to quickly unplug the computer. I haven't had that feeling with computers for years!

If you can be bothered, you can run this on a BBC Micro emulator such as [B2](https://github.com/tom-seddon/b2). You can either copy and paste the [WordPro.txt](https://raw.githubusercontent.com/teticio/WordPro/master/WordPro.txt) file into the console or `LOAD "WORDPRO"` from the [WordPro.sdd](https://raw.githubusercontent.com/teticio/WordPro/master/WordPro.sdd) disc image and then `RUN` it. To start WordPro, type `CALL &7500`. To return to the menu at any point, you can press the `ESCAPE` key.

(* Of course, the original program has no bugs whatsoever. I am referring to bugs introduced by the OCR.)