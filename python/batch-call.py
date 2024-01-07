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
# '3104821725' # novy

numbers = [
    '2029973952'
    # '9173125203'
    # '3104821725'
    # '5093076405',
    # '6037482588',
    # '4013017472',
    # '6173085688',
    # '4802015616',
    # '4126087544',
    # '3062413089',
    # '2016063114',
    # '2036458306',
    # '3035137288',
    # '8456089808',
    # '7706889097',
    # '8582059380',
    # '7033625262',
    # '6513362538',
    # '9179163989',
    # '4026019170',
    # '9175387413',
    # '7086426369'
    # '9496323126'
    # '4805937115'
    # '6129101121'
    # '3104821725',
    # '4359621134'
    # '5053104852'
    # '7202449284'
    # '3108668014'
    # '5405588744'
    # '3128046603'
    ]


# numbers = ['+1'+number for number in numbers]
# print(numbers)

fish_audio = [
    'mixdown-2track.mp3',
    'newplaytest3.mp3',
    'fish01.mp3',
    'fish02.mp3',
    'foghorn.mp3',
    'whoop.mp3'
    ]

this_number = '+1'+random.choice(numbers)
this_audio = 'https://roberttwomey.com/downloads/'+random.choice(fish_audio)
# this_twiml = "<Response><Say>Ahoy, World!</Say></Response>"
this_twiml = f"<Response>\n<Play loop=\"10\">{this_audio}</Play>\n<Record maxLength=\"300\"/></Response>"

print(this_number, this_audio, this_twiml)

call = client.calls.create(
                        record=True,
                        recording_track='dual', #'inbound', # 'dual' # for both
                        # url=this_audio,
                        twiml=this_twiml,
                        to=this_number,
                        from_='+18557017864'
                    )

print(call.sid)