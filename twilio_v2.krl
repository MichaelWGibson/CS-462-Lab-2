ruleset io.picolabs.twilio_v2 {
  meta {
    configure using account_sid = ""
                    auth_token = ""
    provides
        send_sms, messages
  }
 
  global {
    send_sms = defaction(to, from, message) {
       base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/>>
       http:post(base_url + "Messages.json", form = {
                "From":from,
                "To":to,
                "Body":message
            })
    }
    
    messages = function(messageID, to, from){
       messageURL = (messageID == null) =>  ".json" |  messageID + "/";
       base_url = <<https://#{account_sid}:#{auth_token}@api.twilio.com/2010-04-01/Accounts/#{account_sid}/Messages/#{messageURL}>>;
       queryString = {};
       queryString = (to) => queryString.put(["To"], to) | queryString;
       queryString = (from) => queryString.put(["From"], from) | queryString;
       http:get(base_url, qs = queryString);
    }
  }
}