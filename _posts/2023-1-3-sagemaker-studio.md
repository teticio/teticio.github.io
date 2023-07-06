---
layout: post
title: "SageMaker Studio for Team Collaboration"
permalink: /sagemaker/
---
AWS SageMaker Studio is a very compelling choice as a development platform for Data Scientists and Machine Learning Engineers, but it is not easy to set up and it is heavily geared towards using AWS services for everything.
<!--more-->

Some advantages of SageMaker Studio are that

* You only pay for the resources you use.
* You can develop using exactly the same environment that you use for launching SageMaker model training and inference jobs.
* Everybody is using the same operating system so it is much easier to collaborate. In particular, a relatively new feature called “Spaces” allows users to work on the same machine and on the same files, an experience much like that of collaborating on a shared Google Document.
* You have easy access to AWS resources and services.

Nevertheless, out of the box it is lacking several very important features. Some of these can be found in various repos, gists and Stack Overflow answers and others not, but in any case it is not at all obvious how to combine them. This article and accompanying [GitHub repo](https://github.com/clarityai-eng/sagemaker-studio-for-teams) aim to solve this by providing IAC (Infrastructure As Code) and tools to

* Configure user profiles so that they can only access their own workspace.
* Provide commands to start and stop workspaces.
* Conveniently and securely handle authentication with GitLab.
* Persist Python environments across sessions and automatically install system packages.
* SSH into SageMaker containers, allowing for remote debugging and web apps (e.g., Streamlit).
* Run Docker in a SageMaker container.
* Monitor EFS disk usage per user.
* Automatically send emails reminding users to shut down long standing instances.
* Run lightweight Jupyter notebooks without having to spin up an instance.

## Overview of SageMaker Studio

(Feel free to skip this section if you are already familiar with it.)

SageMaker Studio provides a hosted JupyterLab platform. At first sight, it looks very similar to SageMaker Notebooks, SageMaker Studio Lab or even Google Colab. It is worth understanding the differences and the basic architecture.

### Architecture

![SageMaker Studio Architecture](https://d2908q01vomqb2.cloudfront.net/f1f836cb4ea6efb2a0b1b99f41ad8b103eff4b59/2021/08/30/3-3172-large.jpg)

SageMaker Studio runs JupyterLab on a central JupyterServer and uses [KernelGateways](https://jupyter-kernel-gateway.readthedocs.io/en/latest/) to run your notebooks and terminals on separate EC2 instances. This gives the user the sensation of working on a single machine when, in fact, they can be working on several projects on machines of different sizes at the same time, all sharing the same workspace (via the EFS) and that can be spun up or down with just one click. The only time you may notice anything odd is when you realize the same home directory is mounted on the JupyterServer (an AWS Linux `ml.t3.medium instance`) at `/home/sagemaker-user` and on the KernelGateways (Ubuntu instances) at `/root`!

![SageMaker Studio instances](/assets/sagemaker.jpg)

In the example above, I have two Kernel Sessions (notebooks) running on a single `ml.t3.large` instance and a Terminal Session on a `ml.t3.medium` instance. One of the notebooks is running in a Python 3.10 container and the other in a Data Science (Python 3.7 conda) container.

You are charged for the KernelGateway instances at a 15%-40% premium over the equivalent EC2 cost, while the JupyterServer instances are free. You will also incur costs per GB of EFS storage, as well as for network traffic.

### Differences with SageMaker Notebooks, SageMaker Studio Lab and Google Colab

SageMaker Notebooks are associated with the AWS account and not a particular user, which makes them unsuitable for developing in a team. SageMaker Studio Lab is a free, cut-down version of SageMaker Studio which gives you 12 hour blocks of uninterrupted compute on a `ml.t3.medium` instance and 15 GB of persistent EFS storage. Note that it is not possible to install system packages on SageMaker Lab. Google Colab has a similar free tier which also includes a limited use of GPUs, but each notebook runs on a separate instance, which makes doing anything more than demos or self-contained tasks difficult. Beware that if you get caught trying to [SSH into Google Colab](https://research.google.com/colaboratory/faq.html#limitations-and-restrictions), you might find your account blocked!

## Remote Debugging

Jupyter notebooks are a great way to iterate (REPL — Read Eval Print Loop) but — especially with production code — you often need to be able to step line by line using VSCode, PyCharm or similar.

It is possible to run [code-server](https://github.com/coder/code-server) on SageMaker Studio and connect to it via a URL of the form `https://<domain>.studio.<region>.sagemaker.aws/jupyter/default/proxy/<port>/` but this will be running on the same instance as JupyterLab, and not where you are doing the heavy lifting.

The good news is that both PyCharm and VSCode allow you to debug remotely over SSH in such a way that you barely notice you are not running on your local machine.

## SSH

How is it possible to SSH into a SageMaker instance without a public IP address? One way would be to SSH into a trusted third machine from both your local machine and from the SageMaker instance, and to use this machine as a “jump server”. Apart from requiring a jump server to be running 24x7, this opens up a whole host of security concerns.

AWS allows you to set up a SSH session to any EC2 or SageMaker instance via an SSM (Systems Manager) agent. No extra machine is needed, and a private key and sufficient AWS credentials are required to connect (for belt and braces security!). Commands are provided in the linked repo that hide the details and make connecting using SSH seamless.

## Lifecycle Configurations, Python environments and Custom Images

Managing versions can easily become a full time job. In what follows I am going to distinguish between Python packages and everything else — which I will call “system packages” — because I am assuming you are a Data Scientist or Machine Learning Engineer. This distinction is important because every time you start a new KernelGateway instance, none of the system packages you installed last time will be there.

SageMaker Studio allows you to define scripts called “Lifecycle Configurations” which are run whenever you start up a JupyterServer or KernelGateway instance. In my view, these scripts should be standardised across the whole team and should set up the basic tools that everyone uses. If you want to install `terraform` by default, say, then a hook is provided in an `.on_start` file. Then, of course, you can configure `.bashrc` and `.profile` as you would on any Linux machine.

At [Clarity AI](https://clarity.ai/), we use `pipenv` to manage our Python environments but it is a simple matter to adapt the Lifecycle Configurations to use `poetry`, for example. The key is to make sure that the Python environments are stored under the home directory, so that they are persisted on the EFS (Elastic File System) from one session to the next. The KernelGateway Lifecycle Configuration provided automatically adds any Python environments created with `pipenv` as Jupyter kernels, so that they are available in notebooks. In some cases, it may be more convenient to install system packages via `pip` or to copy the executable files to the `bin` directory in the virtual environment you are running.

It is possible to create your own Custom Images for KernelGateway apps. My recommendation would be to only use these for tailor made production environments in which to run model training and inference. Any other packages (system or Python) you need for development can be installed as previously explained.

## Docker

At [Clarity AI](https://clarity.ai/), we make heavy use of Docker. When you are using SageMaker Studio, it feels as though you are on an EC2 instance, when in fact you are actually inside a container. It is possible to run Docker in a Docker container, but the `docker.sock` has to be passed in from the outside — and this is not the case in SageMaker Studio…

A solution is to resort to a remote Docker engine. This can be an EC2 instance on the same private subnet as your SageMaker Studio domain. Again, we can use SSM to set up a SSH session over which Docker can connect. This is all handled with a simple command in the repo where you can also find the IAC to set this up.

## EFS

While it is relatively straightforward to keep track of who is using what machines for how long, it is easy to lose sight of how much disk space people are using, especially when it is virtually infinite. EFS disk space is persisted across sessions and is charged at up to 36 cents per Gigabyte per month. You’d be surprised how quickly that mounts up!

We found it useful to be able to measure how much EFS disk space each user is consuming. In some cases, it may simply be that they have a number of large files in their `.Trash` without realising it.

The only practical way to do measure the usage per user is to mount the entire EFS volume on an EC2 instance and run a du command. As this is a time consuming task, this is run as a daily cron job and the results can be consulted at any time by running a `sm_studio status_all` command.

## SageMaker Police

Rather than have instances shut down automatically after a given period of idle time, I prefer to have an email sent to users of long-standing instances to remind them to do so. IAC is provided in the repo to set up a Lambda function that does just this.

## SageMaker Studio for Teams Repo

More details and code can be found [here](https://github.com/clarityai-eng/sagemaker-studio-for-teams)

## References

* [SageMaker SSH Helper](https://github.com/aws-samples/sagemaker-ssh-helper)
* [SageMaker Studio Lifecycle Configuration Samples](https://github.com/aws-samples/sagemaker-studio-lifecycle-config-examples)
