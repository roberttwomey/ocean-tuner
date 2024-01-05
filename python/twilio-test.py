# Download the helper library from https://www.twilio.com/docs/python/install
import os
from twilio.rest import Client

# Find your Account SID and Auth Token at twilio.com/console
# and set the environment variables. See http://twil.io/secure
account_sid = os.environ['TWILIO_ACCOUNT_SID']
auth_token = os.environ['TWILIO_AUTH_TOKEN']
client = Client(account_sid, auth_token)

call = client.calls.create(
                        record=True,
                        recording_track='inbound', # 'dual' # for both
                        url='https://roberttwomey.com/downloads/multiple-fish.mp3',
                        to='+12029973952',
                        # to='+19173125203', # ash
                        # to='+13082934901', # sam
                        from_='+18557017864'
                    )

print(call.sid)