public class TransactionsApi {
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static String Session_Token;
    //81453       Getin_Api_Login_Data__c
    public static   List<Transaction_Wrapper_class.data> TransactionLastUpdateCalling(String last_update)
    {
        QBData = [Select ID,Name,Token_type__c from Getin_Api_Login_Data__c limit 1]; 
        //   List<Purchase__c> PurchaseList = new List<Purchase__c>();
        // List<Sub_Purchase__c> SubPurchaseList = new List<Sub_Purchase__c>();
        Session_Token=ApiUtility.logincallout();
        
        String Authorization= QBData.Token_type__c+' '+Session_Token;
        if(Session_Token==null)
        {
            system.debug('Session Token is '+Session_Token);
        }
        else
        {
           // system.debug('---------------------https://api.gettt.co.il/api-crm/transactions?last_update=+last_update');
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            //81453
            String url='https://api.gettt.co.il/api-crm/transactions?last_update='+last_update;
            url=url.replace(' ','%20');
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization',Authorization);  
            
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200)
            {
                
               // system.debug('response' + response);
              //  system.debug(response.getbody());
                
                Transaction_Wrapper_class Responseobj=Transaction_Wrapper_class.parse(response.getbody());
                List<Transaction_Wrapper_class.data> responselist= Responseobj.data;
                return responselist;
                //Transaction_Response_Lists obj=new Transaction_Response_Lists(responselist);
                
                //  system.debug(obj.PurchasesList);
                //return obj;
                
                //  Transaction_Wrapper_class response2 = (Transaction_Wrapper_class)JSON.deserialize(response.getbody(), Transaction_Wrapper_class.class);
                //list<Transaction_Wrapper_class.data> Trnasaction_object = response2.data;
                
                /*  integer size= response2.size();
List<object> returned_List = new List<object>();
integer index=0;
System.debug('vvvvvvvvbbbbbbbbbbbvvvvv'+response2.data[2].enter); 
for (object ob : response2.data)
{
//system.debug(ob);
returned_List.add(ob);
}*/
                //System.debug('vvvvvvvvjjjjjjjjjjbm vvvvv'+Trnasaction_object);
                // return Trnasaction_object; 
                //  PurchaseList;
                /*for(Transaction_Wrapper_class.Data temp:Responseobj.data)
{ system.debug('t'+temp);

system.debug(temp.user_id);
Purchase__c obj=new Purchase__c();
obj.Event_Id__c=String.valueOf(temp.event_id);
obj.Status__c=String.valueOf(temp.status);
obj.Purchase_Id__c=String.valueOf(temp.purchase_id);
obj.Purchase_Item_Id__c=String.valueOf(temp.purchase_item_id);
obj.Inviter_Id__c=temp.inviter_id;
obj.Name=temp.first_name+' '+temp.last_name;
obj.Identification_Number__c=temp.identification_number;
obj.Phone_Country_Code__c=temp.phone_country_code;
obj.Phone__c=temp.phone;
obj.Age__c=temp.age;
obj.Prefered_Language__c=temp.preferred_lang;
obj.Custom_Inputs__c=temp.custom_inputs;
obj.Mailing__c=temp.mailing;
obj.Item_Id__c=String.valueOf(temp.item_id);
//obj.CurrencyIsoCode=temp.currency;
obj.Refund_Amount__c=temp.refund_amount;
obj.Payment__c=temp.payment;
obj.Producer_Credit__c=temp.producer_credit;
obj.Payment_Method__c=temp.payment_method;
obj.Comments__c=temp.comment;
obj.Hash__c=temp.hash;
// obj.Supplier__c=temp.supplier;
obj.Enter__c=temp.enter;
obj.Anonymous_User__c=temp.anonymous_user;
system.debug(temp.user_id);
system.debug(temp.sub_purchases);

if(temp.sub_purchases!=null)
{
for(Transaction_Wrapper_class.Sub_Purchases bingop:temp.sub_purchases)
{
Sub_Purchase__c subobj=new Sub_Purchase__c();
subobj.Purchase__c=obj.id;
system.debug(bingop.id);
subobj.Status__c=String.valueOf(bingop.status);
subobj.Last_Update__c=bingop.last_update;
subobj.Name=bingop.first_name+' '+bingop.last_name;
subobj.Identification_Number__c= bingop.identification_number;
subobj.Email__c=bingop.email;
subobj.Phone__c= bingop.phone;
subobj.Phone_Country_Code__c=bingop.phone_country_code;
subobj.Facebook_Id__c=bingop.facebook_id;
subobj.Gender__c= bingop.gender;
subobj.Birth_Date__c=bingop.birth_date;
subobj.Age__c=bingop.age;
subobj.Preferred_Language__c=bingop.preferred_lang;
subobj.Custom_Inputs__c=bingop.custom_inputs;
subobj.Mailing__c=bingop.mailing;
subobj.Item_Id__c=String.valueOf(bingop.item_id);
subobj.Comment__c=bingop.comment;
subobj.Hash__c= bingop.hash;
subobj.Enter__c=bingop.enter;
SubPurchaseList.add(subobj);
}   
PurchaseList.add(obj);
}
}
system.debug(PurchaseList);
system.debug(SubPurchaseList);

List<String> eventidList = new List<String>();
List<String> purchaseidList = new List<String>();
for(Purchase__c temp:PurchaseList)
{
eventidList.add(temp.Event_Id__c);
purchaseidList.add(temp.Purchase_Id__c);
}
list<String> purchaseidofsalesforce = new list<String>();
Map<String, Account> purchaseidinsalesforce = new Map<String, Account>([SELECT Id, Name,User_Id__pc  FROM Account WHERE User_Id__pc IN:purchaseidList]);
Map<String, Getin_Event__c> EventinSalesforce = new Map<String, Getin_Event__c>([SELECT Id, Name,Event_ID__c  FROM Getin_Event__c WHERE Event_ID__c IN:eventidList]);
for(String temp :purchaseidinsalesforce.keySet())
{ 
purchaseidofsalesforce.add(temp);
}  
list<String> EventIdofSalesforce = new list<String>();

for(String temp :EventinSalesforce.keySet())
{ 
EventIdofSalesforce.add(temp);
}  
for(Purchase__c temp:PurchaseList)
{
if(!purchaseidofsalesforce.contains(temp.Purchase_Id__c))
{
//      Account accoun =Testingapi.usercalling(temp.Purchase_Id__c);
//    insert accoun;
}
if(!EventIdofSalesforce.contains(temp.Event_Id__c))
{
//      Getin_Event__c eve =TestingEvent.geteventbyid(Integer.valueOf(temp.Event_Id__c));
//      insert eve;
}
}
insert PurchaseList;
insert SubPurchaseList;*/
                
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