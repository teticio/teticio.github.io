---
layout: post
title: "Web scraping with a proxy pool (the cheap way)"
permalink: /lambda-scraper/
---
Probably the hardest thing about Data Science is getting hold of the data. Companies are willing to give away “free” services in return for the data they collect on how you use them, and this gives them an edge over their competitors. It is not surprising then, that they don’t take too kindly to people relentlessly scraping data from their websites and employ a number of sophisticated detection algorithms to deny requests that come from the same IP address, are too similar or simply look fishy. While it is immoral (and sometimes illegal) to download unreasonable amounts of data, without data, the development of models is monopolized and therefore stifled. I’m not going to condone or decry web scraping, but I am going to show you a useful trick.
<!--more-->

## Proxy pools

The easiest way to spot when someone is scraping your data is if a large number of requests come from a particular IP address. For this reason, a number of services have sprung up that give you access to a large pool of servers that you can use as a proxy to access a website. The main drawback is the cost.

## Enter AWS Lambda functions

Lambda functions are an example of FaaS — Functions as a Service — and are one of the most well known components of a so-called serverless architecture. Previously, you would have to spin up a server to host your application, including any functions such as returning a value from a database, etc. With Lambda functions, you can build a fairly complicated system without running any servers by joining all the components — static web pages, databases and other functionality — with Lambda functions. Why would you want to do this? Because this way, you only pay for the use you give your application, rather than having to “leave the lights on” by running a server 24/7. If you expect sporadic or low volumes, going serverless is much more cost effective. You can make a million calls to a Lambda function a month without incurring any cost, except for the data you transfer out of them, which is charged at the same rate as an EC2 instance (currently $9 per 100 GB). By way of comparison, [oxylabs.io](https://oxylabs.io/products/residential-proxy-pool%C3%A7) charges $15 per GB.

Lambda functions can be written in most popular languages, but I am going to use Python as this is still the go-to language for Data Scientists. Luckily for us, Lambda functions are not guaranteed to preserve their IP address. I found that, if they are not accessed for more than 6 minutes, their IP address changes. Also, there is no real limit to the number of Lambda functions you create. So why not create as many as you want and cycle through them in a round robin fashion to scrape the web pages you are interested in? That’s exactly what we are going to do now.

## Terraform

Using the AWS console is tedious and, at times, bewildering, so we need an automatic way to create as many Lambda functions as we need. Terraform is a great tool for doing this. Once you have installed [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) and the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and linked this to your AWS account, you can run the following:

```bash
git clone https://github.com/teticio/lambda-scraper.git
cd lambda-scraper
terraform init
terraform apply -auto-approve
# run "terraform apply -destroy -auto-approve" in the same directory to tear all this down again
```

This will automatically create 10 Lambda functions called proxy-0 to proxy-9 that we can use to access a web page, as in this example:

```python
import json
import boto3
from base64 import b64decode

num_proxies = 10
url = 'https://ipinfo.io/ip'

lambda_client = boto3.client('lambda')
round_robin = 0
while True:
    response = json.loads(
        lambda_client.invoke(FunctionName=f'proxy-{round_robin}',
                             InvocationType='RequestResponse',
                             Payload=json.dumps({"url":
                                                 url}))['Payload'].read())
    print(f'{response["statusCode"]} {b64decode(response["body"])}')
    round_robin = (round_robin + 1) % num_proxies
```

(You will need to `pip install boto3` — the Python wrapper for programmatic AWS control.) If you run this, you should see 10 unique IP addresses repeating in a loop. Just replace the URL with the webpages you are interested in and away you go. You can configure the number of Lambda functions that are created in the file `variables.tf` as well as the region — which can be useful for web pages that can only be accessed from certain parts of the world.

The Lambda functions do have certain restrictions, however. In particular, the response payload must be less than 6 MB in size. To call the Lambda function “proxy” is probably bigging it up too much, as it can only handle GET requests as it stands, but it is perfectly adequate for scraping data from HTML pages using something like Beautiful soup.

## Selenium

Some web pages cannot simply be scraped by GETting them from an HTTP request. Instead, you may need to interact with them using a browser. The [`lambda-selenium`](https://github.com/teticio/lambda-selenium) repo allows you to run arbitrary code to control the browser using Selenium. An example is provided to illustrate how to perform searches using Google. You can even run the Lambda functions in parallel, which greatly speeds up the process.
