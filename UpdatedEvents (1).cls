public class UpdatedEvents {
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static  list<Integer> eventcalling(String Minutes)
    {
        list<Integer> UpdatedEventsId = new list<Integer>();
        QBData = [Select Session_Token__c,Session_Token_2__c,Token_type__c from Getin_Api_Login_Data__c limit 1];   
        String session_token=QBData.Session_Token__c+QBData.Session_Token_2__c;
        system.debug(session_token+'ooooooooooooooooooooooo');
        String Authorization= QBData.Token_type__c+' '+session_token;
        if(session_token==null)
        {
            system.debug('Session Token is '+session_token);
        }
        else
        {
            system.debug('---------------------event-approved-logs?minutes');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.get-in.com/api-crm/event-approved-logs?minutes='+Minutes);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization',Authorization);  
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200)
            {
                
                system.debug('response' + response);
                system.debug(response.getbody());
                UpdatedEventsResponse Responseobj=UpdatedEventsResponse.parse(response.getbody());
                system.debug(Responseobj);
                for(UpdatedEventsResponse.Data temp:Responseobj.data)
                {
                    UpdatedEventsId.add(temp.event_id);
                }
                system.debug('-0-----0-0-0+'+UpdatedEventsId);
              return UpdatedEventsId;
                
            }
            else
            {
                system.debug('api is not working');
                return null;
            }
        }
        return null; 
    }
}