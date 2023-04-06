public class EventsBatchUtility {
    public static  void EventBatchRecordProcessing(List<Getin_Event__c> geteventlist)
    {  
        //List<Getin_Event__c> getEventlist=TestingEvent.usercalling('2022-01-24 00:01:05');
        list<String> userIds = new list<String>();
        list<String> eventIds = new list<String>();
        list<Product2> productList = new list<Product2>();
        list<Product2> checkList = new list<Product2>();
        List<String> productIdCheck=new list<String>();
        for(Getin_Event__c temp : getEventlist)
        {
            userIds.add(temp.User_Id__c);
            eventIds.add(temp.Event_ID__c);
            // temp.Event_ID__c='6601';
            if(!productIdCheck.contains(temp.Event_ID__c))
            {
                checkList=ProductsApi.ProductCallingForEvent(temp.Event_ID__c);
                productIdCheck.add(temp.Event_ID__c);
                if(checkList!=null)
                {
                    productList.addAll(checkList);
                }
            }
            
            
            
        }    
        list<Account> accountsFromEventList = [SELECT ID,Name,User_Id__pc from Account where User_Id__pc in:userIds];
        list<Getin_Event__c> eventsFromEventList = [SELECT ID,Event_ID__c,User_Id__c from Getin_Event__c where Event_ID__c in:eventIds];
        Map<String, Getin_Event__c> eventMap = new Map<String, Getin_Event__c>(eventsFromEventList);
        Map<String, Account> accountMap = new Map<String, Account>(accountsFromEventList);
        for(Getin_Event__c temp:eventsFromEventList)
        {
            eventMap.put(temp.Event_ID__c,temp);
        }
        for(Account acc:accountsFromEventList)
        {
            accountMap.put(acc.User_Id__pc,acc);
            
        }
        
        list<Account> accList = new list<Account>();
        list<String> accsEventIdList = new list<String>();
        list<String> userIdsForCheck = new list<String>();
        for(Getin_Event__c temp:getEventlist)
        {
            if(!accountMap.containsKey(temp.User_Id__c))
            { 
                if(!userIdsForCheck.contains(temp.User_Id__c))
                {
                    Account accoun =UsersApi.CreateAccount(temp.User_Id__c);
                    userIdsForCheck.add(temp.User_Id__c);
                    accsEventIdList.add(temp.Event_ID__c);
                    accList.add(accoun);
                }
            }
            else
            {  
                if(eventMap.containsKey(temp.Event_ID__c))
                {
                    system.debug('eventmap.get(temp.Event_ID__c).User_Id__c'+eventMap.get(temp.Event_ID__c).User_Id__c);
                    system.debug('temp.User_Id__c'+temp.User_Id__c);
                    if(eventMap.get(temp.Event_ID__c).User_Id__c == temp.User_Id__c)
                    { 
                        temp.id=eventMap.get(temp.Event_ID__c).id;
                        temp.Producer__c=accountMap.get(temp.User_Id__c).id; 
                        
                        system.debug('name'+accountMap.get(temp.User_Id__c).Name);
                        //  temp.Producer__c=m.get(temp.User_Id__c).id; 
                    }
                }else
                {
                    
                    if(accountMap.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                    {
                        temp.Producer__c=accountMap.get(temp.User_Id__c).id; 
                    }
                    
                }
            }
        } 
        insert accList;
        system.debug(accList);
        // upsert getEventlist;
        Map<String, Account> newAccountMap = new Map<String, Account>(accList);
        for(Account temp:accList)
        {
            newAccountMap.put(temp.User_Id__pc,temp);
        }
        //list <Getin_Event__c>neweventlistinsalesforcemap = [SELECT ID,Event_ID__c from Getin_Event__c where Event_ID__c in:Accseventidlist];
        //system.debug(neweventlistinsalesforcemap);
        //Map<String, Getin_Event__c> neweventmap = new Map<String, Getin_Event__c>(neweventlistinsalesforcemap);
        //for(Getin_Event__c temp:neweventlistinsalesforcemap)
        //{
        //   neweventmap.put(temp.Event_ID__c,temp);
        //}
        for(Getin_Event__c temp:getEventlist)
        {
            if(newAccountMap.containsKey(temp.User_Id__c) )
            {
                //Account obj= newaccountmap.get(temp.User_Id__c).id;
                //obj.p
                //system.debug('bingo');
                //temp.id=eventmap.get(temp.Event_ID__c).id;
                temp.Producer__c=newAccountMap.get(temp.User_Id__c).id;
                
            }
        }
        upsert getEventlist;
        Map<String, Getin_Event__c> newEventListMap = new Map<String, Getin_Event__c>();
        for(Getin_Event__c temp:getEventlist)
        {
            newEventListMap.put(temp.Event_ID__c,temp);
        }
        list<String> productIdList=new list<string>();
        for(Product2 temp:productList)
        {
            productIdList.add(temp.Product_Id__c);
        }
        list<Product2> productListFromSalesForce = [SELECT ID,Name,Product_Id__c from Product2 where Product_Id__c in:productIdList];
        Map<String, Product2> productListMap = new Map<String, Product2>(productListFromSalesForce);
        for(Product2 temp:productListFromSalesForce)
        {
            productListMap.put(temp.Product_Id__c,temp);
        }
        for(Product2 temp:productList)
        {
            temp.isActive=TRUE;
            if(productListMap.containsKey(temp.Product_Id__c))
            {
                temp.id=productListMap.get(temp.Product_Id__c).id;
                
            }
            if(newEventListMap.containsKey(temp.Event_ID__c))
            {
                temp.Getin_Event__c=newEventListMap.get(temp.Event_ID__c).id;
                temp.CurrencyIsoCode=newEventListMap.get(temp.Event_Id__c).CurrencyIsoCode;
            }
        }
        system.debug('productlist +' +productList);
        upsert productList;
        
        map <string,product2> newProductListMap=new map <string,product2>();
        for(product2 temp:productList)
        {
            //system.debug('new Quantity of product in salesforce : '+temp.Quantity__c);
            newProductListMap.put(temp.Product_Id__c,temp);
        }
        list<PricebookEntry> pricebookEntryListInSalesforce= [SELECT ID,Name,Product_Id__c from PricebookEntry where Product_Id__c in:productIdList];
        map<String,PricebookEntry>  pricebookListMap = new Map<String, PricebookEntry>(pricebookEntryListInSalesforce);
        for(PricebookEntry temp:pricebookEntryListInSalesforce)
        {
            pricebookListMap.put(temp.Product_Id__c,temp);
            //system.debug('temp.Product_Id__c'+temp.Product_Id__c);
        }
        list<PricebookEntry> pricebookentrylist=new  list<PricebookEntry>();
        Pricebook2 pricebookobj=[select Id, Name, IsActive from PriceBook2 where IsStandard=True and IsActive=True LIMIT 1];
        for(Product2 temp:productList)
        {
            //  system.debug('Product list contain currency : '+temp.CurrencyIsoCode);
            PricebookEntry pbobj = new PricebookEntry();
            if(pricebookListMap.containsKey(temp.Product_Id__c))
            {
                pbobj.id=pricebookListMap.get(temp.Product_Id__c).id;
                pbobj.Product_Name__c=temp.Name;
                pbobj.UnitPrice=temp.Price__c;
                pbobj.Product_Id__c=temp.Product_Id__c;
                //pbobj.Pricebook2Id=pricebookobj.id;
                // pbobj.CurrencyIsoCode=temp.CurrencyIsoCode;
            }
            else
            {
                // system.debug('ccccccccccccccccccccc'+temp.CurrencyIsoCode);
                pbobj.CurrencyIsoCode=temp.CurrencyIsoCode;
                
                
                pbobj.Product_Name__c=temp.Name;
                pbobj.UnitPrice=temp.Price__c;
                pbobj.Product_Id__c=temp.Product_Id__c;
                pbobj.Product2Id=temp.id;
                pbobj.Pricebook2Id=pricebookobj.id;
                pbobj.IsActive=true;
            }
            pricebookentrylist.add(pbobj);
        }
        upsert pricebookentrylist;
    }
}