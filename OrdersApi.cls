public class OrdersApi {
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static String Session_Token;
    public static  List<Transaction_Wrapper_class.data> TransactionLastUpdateCalling(String last_update)
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
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200)
            {
                
                // system.debug('response' + response);
                //  system.debug(response.getbody());
                
                Transaction_Wrapper_class Responseobj=Transaction_Wrapper_class.parse(response.getbody());
                List<Transaction_Wrapper_class.data> responselist= Responseobj.data;
                return responselist;
            }
            else
            {
                system.debug('api is not working');
                return null;
            } 
            
        }
        return null;
    }
    public static List<Transaction_Wrapper_class.data>TransactionCallingWithId(String Id)
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
            // system.debug('---------------------https://api.gettt.co.il/api-crm/transactions?transaction_id=transaction_id'+Id);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            //81453
            String url='https://api.gettt.co.il/api-crm/transactions?transaction_id='+Id;
            url=url.replace(' ','%20');
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization',Authorization);  
            request.setTimeout(120000);
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200)
            {
                
                // system.debug('response' + response);
                //  system.debug(response.getbody());
                
               /* ResponsewithOrderId Responseobj=ResponsewithOrderId.parse(response.getbody());
                //List<ResponsewithOrderId.data> responselist= Responseobj.data;
                //OrderID_Response_List obj=new OrderID_Response_List(responselist);
               // system.debug(obj.OrderItemsList);
              // system.debug(responselist);
              return Responseobj.data;*/
             Transaction_Wrapper_class Responseobj=Transaction_Wrapper_class.parse(response.getbody());
             List<Transaction_Wrapper_class.data> responselist= Responseobj.data;
             return responselist;
   
             
            }
            else
            {
                system.debug('api is not working');
             return null;
            } 
            
        }return null;
       
    }
}