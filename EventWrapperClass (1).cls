public class EventWrapperClass {
    
    Public integer CurrentPage;
    Public integer LastPage;
    Public List<Getin_Event__c> EventList=new  List<Getin_Event__c>();
    
    public  EventWrapperClass(EventResponse.Data_Z Responseobj)
    {
       // system.debug('Responseobj'+Responseobj.data[0].event_balance);
        CurrentPage=Responseobj.current_page;
        LastPage=Responseobj.last_page;
        for(EventResponse.Data temp:Responseobj.data)
        {
            //system.debug(temp);
            Getin_Event__c geve = new Getin_Event__c();
            geve.Event_ID__c  = String.valueOf(temp.event.id);
            geve.Event_Title__c=temp.event_info.title;
            string tempname=temp.event_info.title;
            if(tempname.length()>80)
            {
                tempname=tempname.substring(0,80);
            }
            geve.Name=tempname;
            //system.debug('DateTime.parse(temp.event_info.start_date)'+DateTime.parse(temp.event_info.start_date)+'DateTime.parse(temp.event_info.end_date)'+DateTime.parse(temp.event_info.end_date));
            geve.Start_Date__c=temp.event_info.start_date==null ? null : DateTime.valueOf(temp.event_info.start_date);
            geve.End_Date__c= temp.event_info.end_date==null ? null : DateTime.valueOf(temp.event_info.end_date);
            geve.Event_Address__Longitude__s=temp.event_info.lon=='' ? null : decimal.valueOf(temp.event_info.lon);
            geve.Event_Address__Latitude__s=temp.event_info.lat=='' ? null : decimal.valueOf(temp.event_info.lat);
            //geve.Event_Address__c=geve.Event_Address__Longitude__s+geve.Event_Address__Latitude__s;
            geve.Status__c=String.valueOf(temp.event.status);
            geve.CurrencyIsoCode=temp.event_info.currency_Z;
            geve.Timezone__c=temp.event_info.time_zone;
            geve.Views__c=temp.event_data.views;
            geve.Event_Contact_Email__c=temp.event_data.contact_email;
            geve.User_Id__c=String.valueOf(temp.event.user_id);
            if(temp.event_balance!=null)
            {
               // system.debug('bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'+temp.event_balance.total_credit);
                geve.Total_Credit__c=temp.event_balance.total_credit==null ? 0 : Decimal.valueOf(temp.event_balance.total_credit);            
                geve.Total_Scanned_Ticket__c=temp.event_balance.total_scanned_tickets==null ? 0 : Decimal.valueOf(temp.event_balance.total_scanned_tickets);
                //system.debug(' geve.Total_Scanned_Ticket__c'+ geve.Total_Scanned_Ticket__c);
                geve.Total_Refund__c=  temp.event_balance.total_refund==null ? 0 : Decimal.valueOf(temp.event_balance.total_refund);
                geve.Total_Purchase_Tickets__c= temp.event_balance.total_purchases_tickets==null ? 0 : Decimal.valueOf(temp.event_balance.total_purchases_tickets);           
                geve.Total_Getin__c= temp.event_balance.total_get_in_fee==null ? 0 : Decimal.valueOf(temp.event_balance.total_get_in_fee);
                geve.Total_Cash__c=temp.event_balance.total_cash==null ? 0 : Decimal.valueOf(temp.event_balance.total_cash);
            }
            
            
            
            // geve.Payment_Gateway__c=
            EventList.add(geve);
        }
    }
}