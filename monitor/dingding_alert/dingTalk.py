#!/usr/bin/python
# -*- coding: utf-8 -*-

import requests
import json
import sys
import os

headers = {'Content-Type': 'application/json;charset=utf-8'}
api_url = "https://oapi.dingtalk.com/robot/send?access_token=2e08472b761c36407e5475647ff1ba28d28dfdXXX.XXX.XXX.XXXxxxxxxxxxxxx"

def msg():
    json_text= {
     "msgtype": "text",
        "text": {
            "content": sys.argv[1]+"\n\n"+sys.argv[2]
        },
        "at": {
            "atMobiles": [
                "1xxxxxxxxxxxxx"
            ],
            "isAtAll": False
        }
    }
    print requests.post(api_url,json.dumps(json_text),headers=headers).content

if __name__ == '__main__':
    msg()
