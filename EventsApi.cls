public class EventsApi {
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static GetinEvent__c GEData {get;set;}
    public static String Session_Token;
    public static  EventResponse.Data_Z LastUpdateCalling(String Lastupdate,String Page)
    { 
        Session_Token=ApiUtility.logincallout();
        GEData = [Select Basic_Url__c from GetinEvent__c limit 1];
        QBData = [Select ID,Token_type__c from Getin_Api_Login_Data__c limit 1]; 
        List<Getin_Event__c> eventlist = new List<Getin_Event__c>();        
        //String session_token=QBData.Session_Token__c+QBData.Session_Token_2__c;
        //system.debug(session_token+'ooooooooooooooooooooooo');
        String Authorization= QBData.Token_type__c+' '+Session_Token;
        if(Session_Token==null)
        {
            system.debug('Session Token is '+Session_Token+ ' and Unsuccessfull Login');
        }
        else
        {
            system.debug('----------------------'+GEData.Basic_Url__c+Page+'&event_last_update='+Lastupdate);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String url=GEData.Basic_Url__c+Page+'&event_last_update='+Lastupdate;
            url=url.replace(' ','%20');
            system.debug('Api URL: '+url);
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization',Authorization);  
            
            HttpResponse response = http.send(request);
            //system.debug('-'+response);
            if(response.getStatusCode() == 200)
            {
                
                system.debug('response' + response);
                system.debug(response.getbody());
                
                EventResponse Responseobj=EventResponse.parse(response.getbody());
                //system.debug(Responseobj);
                EventResponse.Data_Z obj=Responseobj.data;
                system.debug('obj'+Responseobj.data);
                return Responseobj.data;
                /*-- 
for(EventResponse.Data temp:Responseobj.data.data)
{
system.debug(temp);
Getin_Event__c geve = new Getin_Event__c();
geve.Event_ID__c  = String.valueOf(temp.event.id);
geve.Event_Title__c=temp.event_info.title;
//system.debug('DateTime.parse(temp.event_info.start_date)'+DateTime.parse(temp.event_info.start_date)+'DateTime.parse(temp.event_info.end_date)'+DateTime.parse(temp.event_info.end_date));
//geve.Start_Date__c= DateTime.parse(temp.event_info.start_date);
//geve.End_Date__c= DateTime.parse(temp.event_info.end_date);
//geve.Event_Address__Longitude__s=decimal.valueOf(temp.event_info.lon);
//geve.Event_Address__Latitude__s=decimal.valueOf(temp.event_info.lat);
//geve.Event_Address__c=geve.Event_Address__Longitude__s+geve.Event_Address__Latitude__s;
//geve.Status__c=String.valueOf(temp.event.status);
// geve.CurrencyIsoCode=temp.event_info.currency;
geve.Timezone__c=temp.event_info.time_zone;
geve.Views__c=temp.event_data.views;
geve.Event_Contact_Email__c=temp.event_data.contact_email;
geve.User_Id__c=String.valueOf(temp.event.user_id);

eventlist.add(geve);
}
return eventlist;
--*/
            }
            else
            {
                system.debug('api is not working');
                return null;
            }
        }
        return null; 
    }
    //------------------------------------------\
    //239240
    public static Getin_Event__c geteventbyid(Integer eventid)
    {
        QBData = [Select Token_type__c from Getin_Api_Login_Data__c limit 1]; 
        List<Getin_Event__c> eventlist = new List<Getin_Event__c>();        
        Session_Token=ApiUtility.logincallout();
        
        String Authorization= QBData.Token_type__c+' '+Session_Token;
        if(Session_Token==null)
        {
            system.debug('Session Token is '+Session_Token);
        }
        else
        {
            //system.debug('----------------------https://api.gettt.co.il/api-crm/events/+eventid');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.gettt.co.il/api-crm/events/'+eventid);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization',Authorization);  
            
            HttpResponse response = http.send(request);
            if(response.getStatusCode() == 200)
            {
                
                ////system.debug('response' + response);
                //system.debug(response.getbody());
                EventResponseId Responseobj=EventResponseId.parse(response.getbody());
                if(Responseobj.Data!=null)
                {
                     //system.debug('p'+Responseobj.Data.event.id);
                Getin_Event__c geve = new Getin_Event__c();
                geve.Event_ID__c  = String.valueOf(Responseobj.Data.event.id);
                geve.Event_Title__c=Responseobj.Data.event_info.title;
                string tempname=Responseobj.Data.event_info.title;
                if(tempname.length()>80)
                {
                    tempname=tempname.substring(0,80);
                }
                geve.Name=tempname;
                //system.debug('DateTime.parse(temp.event_info.start_date)'+DateTime.parse(temp.event_info.start_date)+'DateTime.parse(temp.event_info.end_date)'+DateTime.parse(temp.event_info.end_date));
                geve.Start_Date__c=Responseobj.Data.event_info.start_date==null ? null : DateTime.valueOf(Responseobj.Data.event_info.start_date);
                geve.End_Date__c= Responseobj.Data.event_info.end_date==null ? null : DateTime.valueOf(Responseobj.Data.event_info.end_date);
                geve.Event_Address__Longitude__s=Responseobj.Data.event_info.lon=='' ? null : decimal.valueOf(Responseobj.Data.event_info.lon);
                geve.Event_Address__Latitude__s=Responseobj.Data.event_info.lat=='' ? null : decimal.valueOf(Responseobj.Data.event_info.lat);
                //geve.Event_Address__c=geve.Event_Address__Longitude__s+geve.Event_Address__Latitude__s;
                geve.Status__c=String.valueOf(Responseobj.Data.event.status);
                geve.CurrencyIsoCode=Responseobj.Data.event_info.currency_Z;
                geve.Timezone__c=Responseobj.Data.event_info.time_zone;
                geve.Views__c=Responseobj.Data.event_data.views;
                geve.Event_Contact_Email__c=Responseobj.Data.event_data.contact_email;
                geve.User_Id__c=String.valueOf(Responseobj.Data.event.user_id);
                return geve;
                }
                else
                {
                    return null;
                }
               
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