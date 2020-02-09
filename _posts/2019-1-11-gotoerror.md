---
layout: post
title: "Goto Error"
permalink: /gotoerror/
---
When programming in Python, it can be quite overwhelming when you hit an error deep down in a stack of nested function calls. Inspired by Google Colab, I wrote a Jupyter notebook extension that takes you to the relevant line of source code by clicking on the item in the stack trace.
<!--more-->

![gotoerror](https://github.com/teticio/nbextension-gotoerror/blob/master/demo.gif?raw=true)

If you have not already installed [Jupyter notebook extensions](https://jupyter-contrib-nbextensions.readthedocs.io/en/latest/install.html), you can do this by typing

```
pip install jupyter_contrib_nbextensions
```

Download the Goto Error code from GitHub with

```
git clone git://github.com/teticio/nbextension-gotoerror
```

install it like so

```
jupyter nbextension install nbextension-gotoerror
```

and finally, enable it thusly

```
jupyter nbextension enable nbextension-gotoerror/main
```

If all goes to plan, you should be able to configure the Goto Error extension in the nbextensions tab of Jupyter notebook.

As the Jupyter server is only able to access files in the directory in which it is run or a subdirectory, for the notebook to be able to open the source files it is necessary to provide a soft link to the source file directory. For example, if you don’t use virtual environments, make soft link in the Jupyter launch directory to the site-packages directory of your Python installation (e.g. `~/lib/python3.6/site-packages`) and call this site-packages. Then set the prefix parameter in the nbextension configuration to `~/lib/python3.6`.

If you do use virtual environments, then point the soft link to the envs directory and set the prefix parameter accordingly.

To make a soft link in Linux:

```
ln -s ~/.local/lib/python3.6/site-packages site-packages
```

To make a soft link in Windows:

```
mklink -d envs C:\users\teticio\Anaconda\python\envs
```

You can find the GitHub repo for this project [here](https://github.com/teticio/nbextension-gotoerror).