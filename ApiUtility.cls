public class ApiUtility {
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static String logincallout()
    {
        
        QBData = [Select ID,Name,Auth_URL__c,Last_Updated__c,Session_Token__c,Session_Token_2__c,Token_type__c from Getin_Api_Login_Data__c limit 1];
        //system.debug('url--'+QBData.Auth_URL__c);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(QBData.Auth_URL__c);
        //system.debug('o'+QBData.Auth_URL__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
       
        HttpResponse response = http.send(request);
        // Parse the JSON response
        //system.debug(response);
        if(response.getStatusCode() == 200)
        {
          //  System.debug('The status code returned was expected: ' + response.getStatusCode() + ' ' + response.getStatus());
           // system.debug(response);
            //system.debug(response.getbody());
            GetinWraperClassResponseforToken.response Responseobj = (GetinWraperClassResponseforToken.response)JSON.deserialize(response.getBody(), GetinWraperClassResponseforToken.response.class);
            
            String session_token=Responseobj.data.session_token;
            //system.debug('session token '+ session_token);
            return session_token;
            
        } else 
        {            
            System.debug(response.getBody()+response.getStatusCode());
            return null;
        }
    }
}