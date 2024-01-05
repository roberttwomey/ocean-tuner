# Download the helper library from https://www.twilio.com/docs/python/install
import os
from twilio.rest import Client
import random

# Find your Account SID and Auth Token at twilio.com/console
# and set the environment variables. See http://twil.io/secure
account_sid = os.environ['TWILIO_ACCOUNT_SID']
auth_token = os.environ['TWILIO_AUTH_TOKEN']
client = Client(account_sid, auth_token)

# numbers = [
#     '2029973952',
#     '2029973952',
#     '2029973952'
#     ]
#                         # to='+19173125203', # ash
#                         to='+13082934901', # sam


numbers = [
    '2029973952'
    ]


# numbers = ['+1'+number for number in numbers]
# print(numbers)

fish_audio = [
    'multiple-fish.mp3',
    'fish01.mp3',
    'fish02.mp3'
    ]

this_number = '+1'+random.choice(numbers)
this_audio = 'https://roberttwomey.com/downloads/'+random.choice(fish_audio)

print(this_number, this_audio)

call = client.calls.create(
                        record=True,
                        recording_track='dual', #'inbound', # 'dual' # for both
                        url=this_audio,
                        to=this_number,
                        from_='+18557017864'
                    )

print(call.sid)