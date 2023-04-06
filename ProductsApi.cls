public class ProductsApi {
    public static Getin_Api_Login_Data__c QBData {get;set;}
    public static String Session_Token;
    
    public static List<Product2> ProductCallingForEvent(String eventid)
    {   List<Product2> productlist = new List<Product2>();
     Session_Token=ApiUtility.logincallout();
     QBData = [Select ID,Token_type__c from Getin_Api_Login_Data__c limit 1]; 
     String Authorization= QBData.Token_type__c+' '+Session_Token;
     if(Session_Token==null)
     {
         system.debug('Session Token is '+Session_Token+ ' and Unsuccessfull Login');
     }
     else
     {
         Http http = new Http();
         HttpRequest request = new HttpRequest();
         String url='https://api.gettt.co.il/api-crm/events/'+eventid+'/tickets';
         request.setEndpoint(url);
         request.setMethod('GET');
         request.setHeader('Content-Type', 'application/json');
         request.setHeader('Authorization',Authorization);  
          request.setTimeout(120000);
         HttpResponse response = http.send(request);
         system.debug('-'+response);
         if(response.getStatusCode() == 200)
         {
             
             system.debug('response' + response);
             system.debug(response.getbody());
             ProductResponseForEvents Responseobj=ProductResponseForEvents.parse(response.getbody());
             
             for(ProductResponseForEvents.Data temp:Responseobj.data)
             {
                 Product2 pro=new Product2();
                 pro.Product_Id__c=String.valueOf(temp.id);
                 pro.Name=temp.name;
                 pro.Comments__c=temp.comment;
                 pro.Quantity__c=temp.quantity;
                 pro.Remaining__c=temp.remaining;
                 pro.Limits__c=temp.limits;
                 pro.Price__c=temp.price;
                 pro.Start_Date__c=DateTime.valueOf(temp.start_date);
                 pro.End_Date__c=DateTime.valueOf(temp.end_date);
                 //pro.Status__c=String.valueOf(temp.status);
                 pro.Reg__c=temp.reg;
                 pro.Last_Update__c=DateTime.valueOf(temp.last_update);
                // pro.Category_Ids__c=temp.category_ids;
                 pro.Event_Id__c=eventid;
                 pro.IsActive=true;
                 productlist.add(pro);
             }
             return productlist;
             
         }
         else
         {
             system.debug('api is not working');
             
         }
         
     }
     return null;
     
    }
    public static Product2 ProductCallingForEventwithProductid(String eventid,String Ticketid)
    {
        
        Session_Token=ApiUtility.logincallout();
        QBData = [Select ID,Token_type__c from Getin_Api_Login_Data__c limit 1]; 
        String Authorization= QBData.Token_type__c+' '+Session_Token;
        if(Session_Token==null)
        {
            system.debug('Session Token is '+Session_Token+ ' and Unsuccessfull Login');
        }
        else
        {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            String url='https://api.gettt.co.il/api-crm/events/'+eventid+'/tickets/'+Ticketid;
            request.setEndpoint(url);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization',Authorization);  
            
            HttpResponse response = http.send(request);
            system.debug('-'+response);
            if(response.getStatusCode() == 200)
            {
                
                system.debug('response' + response);
                system.debug(response.getbody());
                ProductidResponse Responseobj=ProductidResponse.parse(response.getbody());
                system.debug(Responseobj.data);
                
                Product2 pro=new Product2();
                pro.Product_Id__c=String.valueOf(Responseobj.data.id);
                pro.Name=Responseobj.data.name;
                pro.Comments__c=Responseobj.data.comment;
                pro.Quantity__c=Responseobj.data.quantity;
                pro.Remaining__c=Responseobj.data.remaining;
                pro.Limits__c=Responseobj.data.limits;
                pro.Price__c=Responseobj.data.price;
                pro.Start_Date__c=DateTime.valueOf(Responseobj.data.start_date);
                pro.End_Date__c=DateTime.valueOf(Responseobj.data.end_date);
                //pro.Status__c=String.valueOf(Responseobj.data.status);
                pro.Reg__c=Responseobj.data.reg;
                pro.Last_Update__c=DateTime.valueOf(Responseobj.data.last_update);
                pro.Category_Ids__c=Responseobj.data.category_ids;
                pro.Event_Id__c=eventid;
                pro.IsActive=true;
                system.debug(pro);
                
                return pro;
                
            }
            else
            {
                system.debug('api is not working');
                
            }
            
        }
        return null;
    }
}