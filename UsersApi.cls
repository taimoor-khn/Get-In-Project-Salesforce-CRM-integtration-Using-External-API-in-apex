public class UsersApi {
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static Getin_Api_Users_Data__c usersobj{get;set;}
    public static String Session_Token;
    /* public static List<Account> postcallout(integer pagenumber)
{
//custom setting
QBData = [Select ID,Name,Auth_URL__c,Last_Updated__c,Session_Token__c,Session_Token_2__c,Token_type__c from Getin_Api_Data__c limit 1];
//
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint(QBData.Auth_URL__c);
request.setMethod('POST');
request.setHeader('Content-Type', 'application/json;charset=UTF-8');

HttpResponse response = http.send(request);
// Parse the JSON response
if(response.getStatusCode() == 200)
{
System.debug('The status code returned was expected: ' + response.getStatusCode() + ' ' + response.getStatus());
system.debug(response);
system.debug(response.getbody());
GetinWraperClassResponseforToken.response Responseobj = (GetinWraperClassResponseforToken.response)JSON.deserialize(response.getBody(), GetinWraperClassResponseforToken.response.class);

String session_token=Responseobj.data.session_token;
// String token_type=Responseobj.data.token_typ;

updateSessionToken(session_token);

return usercalling(pagenumber);
} 
else
{            
System.debug(response.getBody());
}
return null;
}

public static void updateSessionToken(String session_token)
{
QBData = [Select ID,Name,Auth_URL__c,Last_Updated__c,Session_Token__c,Session_Token_2__c,Token_type__c from Getin_Api_Data__c limit 1];

if(session_token.length()>255)
{
QBData.Session_Token__c = session_token.substring(0,255);
QBData.Session_Token_2__c=session_token.substring(255,259);
QBData.Last_Updated__c = Datetime.now();
}
else
{
system.debug('session token is not valid');
}

}*/  
    //
    public static Account CreateAccount(String userid)
    {
        QBData = [Select ID,Name,Auth_URL__c,Token_type__c from Getin_Api_Login_Data__c limit 1]; 
        //usersobj=[Select ID,Name,Users_URL__c,Last_Page_Number__c,Last_Record_Timing__c,Start_Page_Number__c from Getin_Api_Users_Data__c limit 1];
        Session_Token=ApiUtility.logincallout();
        //String session_token=QBData.Session_Token__c+QBData.Session_Token_2__c;
        List<Account> accsLst =new List<Account>();
        //system.debug(session_token+'ooooooooooooooooooooooo');
        String Authorization= QBData.Token_type__c+' '+Session_Token;
        if(Session_Token==null)
        {
            system.debug('Session Token is '+Session_Token);
        }
        else
        {
            //system.debug('----------------------https://api.get-in.com/api-crm/users');
            Http http = new Http();
            HttpRequest request = new HttpRequest();//
            //  request.setEndpoint(usersobj.Users_URL__c+'?page='+pagenumber);
            request.setEndpoint('https://api.gettt.co.il/api-crm/users/search?column=id&value='+userid);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            request.setHeader('Authorization',Authorization);  
            
            HttpResponse response = http.send(request);
            // Parse the JSON response
            // system.debug(response);
            if(response.getStatusCode() == 200)
            {
                SearchUserResponse Responseobj=SearchUserResponse.parse(response.getbody());
                
                if(Responseobj.data.size()>0)
                {
                    system.debug('---------------------------------'+userid+'------------------------- user Responseobj '+Responseobj.data);
                    Account acc = new Account();
                    acc.LastName=Responseobj.data[0].full_name;
                    acc.PersonEmail=Responseobj.data[0].email;
                    acc.User_Id__pc=String.valueOf(Responseobj.data[0].id);
                    //acc.PersonMailingAddress=Responseobj.data.mailing;
                    // acc.Name  = Responseobj.data.full_name;
                    acc.Phone=Responseobj.data[0].phone;
                    acc.Subscribed__pc=String.valueOf(Responseobj.data[0].mailing);
                    acc.Status__pc=String.valueOf(Responseobj.data[0].status);
                    acc.Preffered_Language__pc=Responseobj.data[0].preferred_lang;
                    //system.debug('Responseobj.data[0].birth_date '+Responseobj.data[0].birth_date);
                    //system.Debug('-------------------------------------------------------------------------------------------------------------------'+Responseobj.data[0].id);
                    List<string> aa;
                    if(Responseobj.data[0].birth_date!=null && Responseobj.data[0].birth_date!='')
                    {
                        
                        aa=Responseobj.data[0].birth_date.split('-');
                        if(integer.valueOf(aa[0])>=4000)
                        {
                            Date temp=system.now().Date();
                            aa.clear();
                            aa=String.valueOf(temp).split('-');
                        }
                    }
                    
                    
                    //system.debug('Splitted Date: '+aa);
                    acc.PersonBirthdate=Responseobj.data[0].birth_date=='' ? null : Date.newInstance(integer.valueOf(aa[0]),integer.valueOf(aa[1]),integer.valueOf(aa[2]));
                    
                    acc.Profile_Image__pc=Responseobj.data[0].profile_image;
                    acc.KYC_Status__pc=String.valueOf(Responseobj.data[0].kyc_status);
                    return acc;
                }
                else
                {
                    system.debug('data not found '+userid);
                    return null;
                }
                
            }
            else
            {
                system.debug('api is not working');
                return null;
            }
        }  return null;
        
    }
}