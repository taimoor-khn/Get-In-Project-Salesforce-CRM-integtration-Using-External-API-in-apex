public class OrderID_Response_List {
    
    
    Public Order obj=new Order();
    Public List<OrderItem> AllOrderItemsList=new  List<OrderItem>();   
    public List<OrderItem> OrderItemsList=new  List<OrderItem>();  
     public Map<String, List<OrderItem>>  MapSubPurchases= new Map<String, List<OrderItem>>();
    public OrderID_Response_List( List<ResponsewithOrderId.data> Reuturned_listofTransactions)
    {
        
        for(ResponsewithOrderId.Data temp:Reuturned_listofTransactions)
        {  
            
        system.debug(temp.id);
         obj.Id__c=String.valueOf(temp.id);
         obj.User_Id__c=String.valueOf(temp.user_id);
         obj.Last_Name__c=temp.first_name+temp.first_name;
         obj.Getin_Event_Id__c=String.valueOf(temp.event_id);
         obj.Status=String.valueOf(temp.status);
         obj.Purchase_Id__c=Decimal.valueOf(temp.purchase_id);
         obj.Purchase_Item_Id__c=Decimal.valueOf(temp.purchase_item_id);
         obj.Inviter_Id__c=String.valueOf(temp.inviter_id);
            
         obj.EffectiveDate=system.now().Date();
         obj.Identification_Number__c=temp.identification_number;
         obj.Phone_Country_Code__c=temp.phone_country_code;
         obj.Phone__c=temp.phone;
         obj.Age__c=temp.age;
         obj.Prefered_Language__c=temp.preferred_lang;
         //obj.Custom_Inputs__c=temp.custom_inputs;
         obj.Mailing__c=String.valueOf(temp.mailing);
         obj.Item_Id__c=String.valueOf(temp.item_id);
        // system.debug('Response List : '+temp.item_id);
         obj.CurrencyIsoCode=temp.currency_Z;
         obj.Refund_Amount__c=temp.refund_amount;
         obj.Payment__c=temp.payment;
         obj.Producer_Credit__c=temp.producer_credit;
         obj.Payment_Method__c=String.valueOf(temp.payment_method);
         obj.Comments__c=String.valueOf(temp.comment);
         // obj.Hash__c=temp.hash;
         obj.Supplier__c=temp.supplier;

         obj.Anonymous_User__c=temp.anonymous_user;
         // system.debug(temp.sub_purchases);
        // OrderList.add(obj);
         OrderItem oi=new OrderItem();
         oi.Order_Id__c=String.valueOf(temp.id);
         oi.OrderId=obj.id;
         oi.Item_Id__c=String.valueOf(temp.item_id);
         //   oi.TotalPrice=temp.payment;
         oi.Quantity=Decimal.valueOf(temp.payment);
         oi.Name__c=temp.first_name;
         oi.Event_Id__c=String.valueOf(temp.event_id);
         OrderItemsList.add(oi);
         if(temp.sub_purchases!=null)
         {
             for(ResponsewithOrderId.Sub_Purchases bingop:temp.sub_purchases)
             {
                 OrderItem oiobj=new OrderItem();
                 oiobj.OrderId=obj.id;
                 oiobj.Order_Id__c=String.valueOf(bingop.id);
                 // oiobj.TotalPrice=temp.payment;
                 oiobj.Quantity=Decimal.valueOf(temp.payment);
                 oiobj.Item_Id__c=String.valueOf(bingop.item_id);
                 oiobj.Name__c=bingop.first_name;
                 oiobj.Event_Id__c=String.valueOf(temp.event_id);
              
                 OrderItemsList.add(oiobj);
                 AllOrderItemsList.add(oiobj);
             }
             
         }
         else
         {
             AllOrderItemsList.add(oi);
         }
     MapSubPurchases.put(String.valueOf(temp.id),OrderItemsList);
        }
    }
}