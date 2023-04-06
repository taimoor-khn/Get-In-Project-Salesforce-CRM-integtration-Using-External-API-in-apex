public class Order_Response_Lists {
    Public List<Order> OrderList=new  List<Order>();
    Public List<OrderItem> AllOrderItemsList=new  List<OrderItem>();
    public Map<String, List<OrderItem>>  MapSubPurchases= new Map<String, List<OrderItem>>();
    public List<OrderItem> OrderItemsList=new  List<OrderItem>();
    public Order_Response_Lists( List<Transaction_Wrapper_class.data> Reuturned_listofTransactions)
    {
        for(Transaction_Wrapper_class.Data temp:Reuturned_listofTransactions)
        {    
            Order obj=new Order();
            obj.Id__c=String.valueOf(temp.id);
            obj.User_Id__c=String.valueOf(temp.user_id);
            obj.Last_Name__c=temp.first_name+temp.first_name;
            obj.Getin_Event_Id__c=String.valueOf(temp.event_id);
            obj.Status=String.valueOf(temp.status);
            obj.Purchase_Id__c=Decimal.valueOf(temp.purchase_id);
            obj.Purchase_Item_Id__c=Decimal.valueOf(temp.purchase_item_id);
            obj.Inviter_Id__c=temp.inviter_id;
            obj.EffectiveDate=system.now().Date();
            obj.Identification_Number__c=temp.identification_number;
            obj.Phone_Country_Code__c=temp.phone_country_code;
            obj.Phone__c=temp.phone;
            obj.Age__c=temp.age;
            obj.Prefered_Language__c=temp.preferred_lang;
            //obj.Custom_Inputs__c=temp.custom_inputs;
            obj.Mailing__c=temp.mailing;
            obj.Item_Id__c=String.valueOf(temp.item_id);
            // system.debug('Response List : '+temp.item_id);
            obj.CurrencyIsoCode=temp.currency_Z;
            obj.Refund_Amount__c=temp.refund_amount;
            obj.Payment__c=temp.payment;
            obj.Producer_Credit__c=temp.producer_credit;
            obj.Payment_Method__c=temp.payment_method;
            obj.Comments__c=temp.comment;
            // obj.Hash__c=temp.hash;
            obj.Supplier__c=temp.supplier;
            obj.Enter__c=temp.enter;
            obj.Anonymous_User__c=temp.anonymous_user;
            // system.debug(temp.sub_purchases);
            
            
            
            OrderList.add(obj);
            
            OrderItem oi=new OrderItem();
            oi.Order_Id__c=String.valueOf(temp.id);
            oi.OrderId=obj.id;
            oi.Item_Id__c=String.valueOf(temp.item_id);
            //   oi.TotalPrice=temp.payment;
            oi.Quantity=Decimal.valueOf(temp.payment);
            oi.Name__c=temp.first_name;
            oi.Event_Id__c=String.valueOf(temp.event_id);
            oi.User_Id__c=String.valueOf(temp.user_id);
            oi.Name__c=temp.first_name+temp.first_name;
            
            oi.Status__c=String.valueOf(temp.status);
            oi.Purchase_Id__c=String.valueOf(temp.purchase_id);
            oi.Purchase_Item_Id__c=string.valueOf(temp.purchase_item_id);
            oi.Inviter_Id__c=temp.inviter_id;
            //oiobj.EffectiveDate=system.now().Date();
            oi.Identification_Number__c=temp.identification_number;
            oi.Phone_Country_Code__c=temp.phone_country_code;
            oi.Phone__c=temp.phone;
            oi.Age__c=temp.age;
            oi.Prefered_Language__c=temp.preferred_lang;
            //oi.Custom_Inputs__c=temp.custom_inputs;
            oi.Mailing__c=temp.mailing;
            oi.Item_Id__c=String.valueOf(temp.item_id);
            // system.debug('Response List : '+temp.item_id);
            //oiobj.CurrencyIsoCode=bingop.currency_Z;
            oi.Refund_Amount__c=temp.refund_amount;
            oi.Payment__c=temp.payment;
            oi.Producer_Credit__c=temp.producer_credit;
            oi.Payment_Method__c=temp.payment_method;
            oi.Comments__c=temp.comment;
            //oi.CurrencyIsoCode=temp.currency_Z;
            //  oi.CurrencyIsoCode=temp.currency_Z;
            // oi.Currency__c=Decimal.valueOf(temp.currency_Z);
            OrderItemsList.add(oi);
            if(temp.sub_purchases!=null)
            {
                for(Transaction_Wrapper_class.Sub_Purchases bingop:temp.sub_purchases)
                {
                    OrderItem oiobj=new OrderItem();
                    oiobj.OrderId=obj.id;
                    oiobj.Order_Id__c=String.valueOf(temp.id);
                    
                    oiobj.Quantity=Decimal.valueOf(bingop.payment);
                    oiobj.Item_Id__c=String.valueOf(bingop.item_id);
                    oiobj.Name__c=bingop.first_name;
                    oiobj.Event_Id__c=String.valueOf(bingop.event_id);
                    
                    oiobj.User_Id__c=String.valueOf(bingop.user_id);
                    oiobj.Name__c=bingop.first_name+bingop.first_name;
                    
                    oiobj.Status__c=String.valueOf(bingop.status);
                    oiobj.Purchase_Id__c=String.valueOf(bingop.purchase_id);
                    oiobj.Purchase_Item_Id__c=string.valueOf(bingop.purchase_item_id);
                    oiobj.Inviter_Id__c=bingop.inviter_id;
                    //oiobj.EffectiveDate=system.now().Date();
                    oiobj.Identification_Number__c=bingop.identification_number;
                    oiobj.Phone_Country_Code__c=bingop.phone_country_code;
                    oiobj.Phone__c=bingop.phone;
                    oiobj.Age__c=bingop.age;
                    oiobj.Prefered_Language__c=bingop.preferred_lang;
                    //obj.Custom_Inputs__c=temp.custom_inputs;
                    oiobj.Mailing__c=bingop.mailing;
                    oiobj.Item_Id__c=String.valueOf(bingop.item_id);
                    // system.debug('Response List : '+temp.item_id);
                    //oiobj.CurrencyIsoCode=bingop.currency_Z;
                    oiobj.Refund_Amount__c=bingop.refund_amount;
                    oiobj.Payment__c=bingop.payment;
                    oiobj.Producer_Credit__c=bingop.producer_credit;
                    oiobj.Payment_Method__c=bingop.payment_method;
                    oiobj.Comments__c=bingop.comment;
                    // obj.Hash__c=temp.hash;
                    // oiobj.Supplier__c=bingop.supplier;
                    //oiobj.Enter__c=bingop.enter;
                    //oiobj.Anonymous_User__c=bingop.anonymous_user;
                    //  oiobj.CurrencyIsoCode=bingop.currency_Z;
                    //oiobj.Currency__c=
                    //  OrderItemsList.add(oiobj);
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