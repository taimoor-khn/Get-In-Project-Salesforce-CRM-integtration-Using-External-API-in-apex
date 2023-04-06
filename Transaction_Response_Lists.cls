public class Transaction_Response_Lists {
    Public List<Purchase__c> PurchasesList=new  List<Purchase__c>();
    Public List<Sub_Purchase__c> AllSubPurchasesList=new  List<Sub_Purchase__c>();  
  //  public Map<String,List <SObject> MapSubPurchases=new Map<String,List <SObject>();
   public Map<String, List<Sub_Purchase__c>>  MapSubPurchases= new Map<String, List<Sub_Purchase__c>>();
    public Transaction_Response_Lists( List<Transaction_Wrapper_class.data> Reuturned_listofTransactions)
    {
        for(Transaction_Wrapper_class.Data temp:Reuturned_listofTransactions)
        { 
            Purchase__c obj=new Purchase__c();
            obj.Name=String.valueOf(temp.id);
            obj.User_Id__c=String.valueOf(temp.user_id);
           // obj.Last_Name__c=temp.first_name+temp.first_name;
            obj.Event_Id__c=String.valueOf(temp.event_id);
            obj.Status__c=String.valueOf(temp.status);
           obj.Purchase_Id__c=String.valueOf(temp.purchase_id);
            obj.Purchase_Item_Id__c=String.valueOf(temp.purchase_item_id);
            obj.Inviter_Id__c=temp.inviter_id;
          
            obj.Identification_Number__c=temp.identification_number;
            obj.Phone_Country_Code__c=temp.phone_country_code;
            obj.Phone__c=temp.phone;
            obj.Age__c=temp.age;
            obj.Prefered_Language__c=temp.preferred_lang;
         //   obj.Custom_Inputs__c=temp.custom_inputs;
            obj.Mailing__c=temp.mailing;
            obj.Item_Id__c=String.valueOf(temp.item_id);
            obj.CurrencyIsoCode=temp.currency_Z;
            obj.Refund_Amount__c=temp.refund_amount;
            obj.Payment__c=temp.payment;
            obj.Producer_Credit__c=temp.producer_credit;
            obj.Payment_Method__c=temp.payment_method;
            obj.Comments__c=temp.comment;
            //obj.Hash__c=temp.hash;
            // obj.Supplier__c=temp.supplier;
            obj.Enter__c=temp.enter;
            obj.Anonymous_User__c=temp.anonymous_user;
           // system.debug(temp.sub_purchases);
            PurchasesList.add(obj);
            if(temp.sub_purchases!=null)
            { List<Sub_Purchase__c> SubPurchasesList=new  List<Sub_Purchase__c>();  
                for(Transaction_Wrapper_class.Sub_Purchases bingop:temp.sub_purchases)
                {
                    Sub_Purchase__c subobj=new Sub_Purchase__c();
                    subobj.Purchase__c=obj.id;
                  //  system.debug(bingop.id);
                  //  subobj.Status__c=String.valueOf(bingop.status);
                    subobj.Last_Update__c=bingop.last_update;
                    subobj.Name=bingop.first_name+' '+bingop.last_name;
                    subobj.Identification_Number__c= bingop.identification_number;
                    subobj.Email__c=bingop.email;
                    subobj.Sub_Purchase_ID__c=String.valueOf(bingop.id);
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
                    subobj.Status__c=String.valueOf(bingop.status);
                    subobj.Identification_Number__c=bingop.identification_number;
                    subobj.Hash__c= bingop.hash;
                    subobj.Enter__c=bingop.enter;
                    SubPurchasesList.add(subobj);
                    AllSubPurchasesList.add(subobj);
                }
               // system.debug('size: '+SubPurchasesList.size());
                MapSubPurchases.put(String.valueOf(temp.id),SubPurchasesList);
                
                
            }
        }
    }}