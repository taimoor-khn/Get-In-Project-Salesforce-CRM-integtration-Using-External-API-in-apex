public class FirstGetinUsersApiCall 
{ 
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static Getin_Api_Users_Data__c usersobj{get;set;}
     public static GetinEvent__c GEData {get;set;}
    public static void postcallout()
    {
        //custom setting
        
        QBData = [Select ID,Name,Auth_URL__c,Last_Updated__c,Session_Token__c,Session_Token_2__c,Token_type__c from Getin_Api_Login_Data__c limit 1];
        
        //
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(QBData.Auth_URL__c);
        system.debug('o'+QBData.Auth_URL__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        system.debug(response);
        if(response.getStatusCode() == 200)
        {
            System.debug('The status code returned was expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            system.debug(response);
            system.debug(response.getbody());
            GetinWraperClassResponseforToken.response Responseobj = (GetinWraperClassResponseforToken.response)JSON.deserialize(response.getBody(), GetinWraperClassResponseforToken.response.class);
            
            String session_token=Responseobj.data.session_token;
            // String token_type=Responseobj.data.token_typ;
            updateSessionToken(session_token);
       
           // usercalling();
           
            
        } else 
        {            
            System.debug(response.getBody());
        }
    }
    public static void updateSessionToken(String session_token)
    {
        
        
        if(session_token.length()>255)
        {
            system.debug('session_token+'+session_token);
            QBData.Session_Token__c = session_token.substring(0,255);
            QBData.Session_Token_2__c=session_token.substring(255,277);
            QBData.Last_Updated__c = Datetime.now();
                 update QBData;
            
            system.debug('bingo'+QBData);
        }
        else
        {
            system.debug('session token is not valid');
        }
        
    }
   
    public static void usercalling()
    {
        usersobj=[Select ID,Name,Users_URL__c,Total_Page__c,Last_Record_Timing__c,Start_Page_Number__c from Getin_Api_Users_Data__c limit 1];
        
        String session_token=QBData.Session_Token__c+QBData.Session_Token_2__c;
        String token_type='Bearer';
        system.debug(session_token+'ooooooooooooooooooooooo'+token_type);
        String Authorization= token_type+' '+session_token;
        if(session_token==null)
        {
            system.debug('Session Token is '+session_token);
        }
        else
        {
            system.debug('start user calling');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(usersobj.Users_URL__c);
            system.debug('='+usersobj.Users_URL__c);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            system.debug(Authorization);
            request.setHeader('Authorization',Authorization);  
            HttpResponse response = http.send(request);
            // Parse the JSON response
            system.debug('-'+response);
            if(response.getStatusCode() == 200)
            {
                System.debug('The status code returned was expected: ' + response.getStatusCode() + ' ' + response.getStatus());
                system.debug(response);
                system.debug(response.getbody());
                
                JSON2Apex Responseobj=JSON2Apex.parse(response.getbody());
                usersobj.Start_Page_Number__c=Responseobj.data.current_page;
                usersobj.Total_Page__c=Responseobj.data.last_page;   
                system.debug(Responseobj.data.current_page);
                system.debug(Responseobj.data.last_page);
               
                // if(integer.valueof(Responseobj.data.last_page)>=1)
                //{
                if(QBData!=null )
                {
                    update usersobj;
                    update QBData;
                 
                    system.debug(usersobj);
                    system.debug(QBData);
                }
                //   Testingjobs chainedJob=new Testingjobs();
                
                //   chainedJob.start=integer.valueof(Responseobj.data.current_page);
                //   chainedJob.ending=integer.valueof(Responseobj.data.last_page);
                //  System.enqueueJob(chainedJob);
                //}
                
            }
            else
            {
                system.debug('api is not working');
            }
        }
    }
}