public class OrderBatchUtility {
    
    public static  void OrderBatchRecordProcessing(List<Transaction_Wrapper_class.data> responseList)
    {  
        Map<String, List<OrderItem>>  mapSubPurchases=new map<string,List<OrderItem>> ();
        List<Order> orderList= new list<Order>();
        Order_Response_Lists obj=new Order_Response_Lists(responseList);
        orderList=obj.OrderList;
        
        // AllOrderItemsList=obj.AllOrderItemsList;
        mapSubPurchases  =obj.MapSubPurchases;
        
        Pricebook2 priceBookObj=[select Id, Name, IsActive from PriceBook2 where IsStandard=True and IsActive=True LIMIT 1];
        
        List<Log_Details__c> logList=new List<Log_Details__c>();
        list<String> userIds = new list<String>();
        list<String>userIdsOfEventInPurchases=new list<String>();
        list<String> eventIds = new list<String>();
        list<String> transactionIds=new list<String>();
        list<String> invitersIds=new list<String>();
        if(orderList.size()>0)
        {
            
            for(Order temp : orderList)
            {
                //temp.Getin_Event_Id__c='5995';
                userIds.add(temp.User_Id__c);
                eventIds.add(temp.Getin_Event_Id__c);
                transactionIds.add(temp.Id__c);
                system.debug('Transaction Id ==============='+temp.Id__c +'Inviter Id ---------'+temp.Inviter_Id__c);
                invitersIds.add(temp.Inviter_Id__c);
            }    
            list<Account> accountsfromPurchaseslist=new list<account>();
            list<Getin_Event__c> eventsfromPurchaseslist=new list<Getin_Event__c>(); 
            list<Order> transactionfromPurchaseslist=new list<Order> ();
            Map<String, Getin_Event__c> eventmap = new Map<String, Getin_Event__c>(eventsfromPurchaseslist);
            Map<String, Account> accountsmapinsalesforce = new Map<String, Account>(accountsfromPurchaseslist);
            Map<String,Order>transactionmap =new Map<String,Order>(transactionfromPurchaseslist);
            
            if(userIds.size()>0)
            {
                accountsfromPurchaseslist = [SELECT ID,Name,User_Id__pc from Account where User_Id__pc in:userIds]; 
                if(accountsfromPurchaseslist.size()>0)
                {
                    for(Account acc:accountsfromPurchaseslist)
                    {
                        accountsmapinsalesforce.put(acc.User_Id__pc,acc);
                        //system.debug('---------------------------------------------------m.put():'+acc.User_Id__pc);
                    }  
                }
            }
            
            if(eventIds.size()>0)
            {
                eventsfromPurchaseslist = [SELECT ID,Event_ID__c,CurrencyIsoCode,User_Id__c from Getin_Event__c where Event_ID__c in:eventIds];  
                if(eventsfromPurchaseslist.size()>0)
                {
                    for(Getin_Event__c temp:eventsfromPurchaseslist)
                    {
                        system.debug('salesforce event contain currency : '+temp.CurrencyIsoCode+' Event id :'+temp.Event_ID__c);
                        eventmap.put(temp.Event_ID__c,temp);
                    }   
                }
            }
            
            if(transactionIds.size()>0)
            {
                transactionfromPurchaseslist = [SELECT ID,Id__c from Order where Id__c in:transactionIds];   
                if(transactionfromPurchaseslist.size()>0)
                {
                    for(Order tra:transactionfromPurchaseslist)
                    {
                        transactionmap.put(tra.Id__c,tra);
                    }   
                }
                
            }
            
            list<String> useridsforcheck = new list<String>();
            list<String> useridsforcheck2 = new list<String>();
            list<Account> accList = new list<Account>();
            list<String> eventidsforcheck = new list<String>();
            list<Getin_Event__c> eventList = new list<Getin_Event__c>();
            // list<String> checklistinviterid = new list<string>();
            list<Product2> productList = new list<Product2>();
            list<Product2> checkList = new list<Product2>();
            List<String> productIdCheck=new list<String>();
            for(Order temp : orderList)
            {
                temp.Pricebook2Id=priceBookObj.id;
                // system.debug('---------------------------------------------------temp'+temp.User_Id__c+'event id'+temp.Event_ID__c);
                if(transactionmap.containsKey(temp.Id__c))
                {
                    temp.id=transactionmap.get(temp.Id__c).id;
                }
                if(temp.User_Id__c==null && temp.Inviter_Id__c!=null)
                {
                    /*
if(Invitermap.containsKey(temp.Inviter_Id__c))
{
temp.AccountId=Invitermap.get(temp.Inviter_Id__c).AccountId;
}
else
{
if(!checklistinviterid.contains(temp.Inviter_Id__c))
{
//  createinviterid

//   checklistinviterid.add(temp.Inviter_Id__c);
}
}*/
                }
                if(accountsmapinsalesforce.containsKey(temp.User_Id__c) && temp.User_Id__c!=null)
                {
                    temp.AccountId=accountsmapinsalesforce.get(temp.User_Id__c).id;
                }
                else
                {
                    if(!useridsforcheck.contains(temp.User_Id__c) && temp.User_Id__c!=null)
                    {
                        Account accoun =UsersApi.CreateAccount(temp.User_Id__c);
                        // useridsforcheck.add(temp.User_Id__c);
                        //Acclist.add(accoun);
                        if(accoun!=null)
                        {
                            useridsforcheck.add(temp.User_Id__c);
                            
                            accList.add(accoun);
                        }
                        else
                        {
                            Log_Details__c logobj=new Log_Details__c();
                            logobj.User_Id__c=temp.User_Id__c;
                            logobj.Transaction_Id__c=temp.Id__c;
                            logobj.error__c='User Id : '+ logobj.User_Id__c+'  is not available thorugh Users api for Transaction Id : '+logobj.Transaction_Id__c;
                            logobj.Is_Processed__c=false;
                            logList.add(logobj);
                        }
                    }
                }
                if(eventmap.containsKey(temp.Getin_Event_Id__c))
                {
                    //  temp.CurrencyIsoCode=eventmap.get(temp.Getin_Event_Id__c).CurrencyIsoCode;
                    temp.Event_Id__c=eventmap.get(temp.Getin_Event_Id__c).id;
                    //  temp.Getin_Event_Id__c='5995';
                    if(!productIdCheck.contains(temp.Getin_Event_Id__c))
                    {
                        checkList=ProductsApi.ProductCallingForEvent(temp.Getin_Event_Id__c);
                        productIdCheck.add(temp.Getin_Event_Id__c);
                        if(checkList!=null)
                        {
                            productList.addAll(checkList);
                            system.debug('inserting');
                            system.debug(checkList);
                            system.debug('ending');
                        }
                        else
                        {
                            Log_Details__c logobj=new Log_Details__c();
                            logobj.Event_Id__c=temp.Getin_Event_Id__c;
                            logobj.Transaction_Id__c=temp.Id__c;
                            logobj.Ticket_Id__c=temp.Getin_Event_Id__c;
                            logobj.error__c='Event Id : '+logobj.Event_Id__c +' not available through Ticket api '+ 'Transaction id : '+logobj.Transaction_Id__c;
                            logobj.Is_Processed__c=false;
                            logList.add(logobj);  
                        }
                    }
                }
                else
                {
                    if(!eventidsforcheck.contains(temp.Getin_Event_Id__c))
                    {
                        Getin_Event__c newevent= EventsApi.geteventbyid(Integer.valueOf(temp.Getin_Event_Id__c));
                        if(newevent!=null)
                        {
                            
                            eventidsforcheck.add(temp.Getin_Event_Id__c);
                            eventList.add(newevent);
                            //newevent.Event_ID__c='5995';
                            if(!productIdCheck.contains(newevent.Event_ID__c))
                            {
                                checkList=ProductsApi.ProductCallingForEvent(newevent.Event_ID__c);
                                productIdCheck.add(newevent.Event_ID__c);
                                if(checkList!=null)
                                {
                                    productList.addAll(checkList);
                                    system.debug('inserting');
                                    system.debug(checkList);
                                    system.debug('ending');
                                }
                                else
                                {
                                    Log_Details__c logobj=new Log_Details__c();
                                    logobj.Event_Id__c=newevent.Event_ID__c;
                                    logobj.Transaction_Id__c=temp.Id__c;
                                    logobj.Ticket_Id__c=newevent.Event_ID__c;
                                    logobj.error__c='Event Id : '+logobj.Event_Id__c +' not available through Ticket api '+ 'Transaction id : '+logobj.Transaction_Id__c;
                                    logobj.Is_Processed__c=false;
                                    logList.add(logobj);  
                                }
                            }
                            if(!accountsmapinsalesforce.containsKey(newevent.User_Id__c))
                            {
                                userIdsOfEventInPurchases.add(newevent.User_Id__c);
                            }//no event log insert
                            else
                            {
                                if(accountsmapinsalesforce.get(newevent.User_Id__c).User_Id__pc==newevent.User_Id__c)
                                {
                                    newevent.Producer__c=accountsmapinsalesforce.get(newevent.User_Id__c).id; 
                                }
                            }
                        }
                        else
                        {
                            Log_Details__c logobj=new Log_Details__c();
                            logobj.Event_Id__c=temp.Getin_Event_Id__c;
                            logobj.Transaction_Id__c=temp.Id__c;
                            logobj.error__c='Event Id : '+logobj.Event_Id__c +' not available through Event api and Transaction id is '+ logobj.Transaction_Id__c;
                            logobj.Is_Processed__c=false;
                            logList.add(logobj);  
                        }
                        
                    }  
                } 
            }
            list<Account> accountsfromPurchaseslistofeventsids=new list<Account> ();
            Map<String, Account> newEventAccountMaps = new Map<String, Account>(accountsfromPurchaseslistofeventsids);
            if(userIdsOfEventInPurchases.size()>0)
            {
                accountsfromPurchaseslistofeventsids = [SELECT ID,Name,User_Id__pc from Account where User_Id__pc in:userIdsOfEventInPurchases];   
                if(accountsfromPurchaseslistofeventsids.size()>0)
                {
                    for(account temp:accountsfromPurchaseslistofeventsids)
                    {
                        newEventAccountMaps.put(temp.User_Id__pc,temp);
                    }   
                }
                list<String> useridsforcheckforeventaccount=new list<String>();
                for(String temp:userIdsOfEventInPurchases)
                {
                    if(!newEventAccountMaps.containsKey(temp))
                    { 
                        if(!useridsforcheckforeventaccount.contains(temp) )
                        { if(!useridsforcheck.contains(temp))
                        {
                            Account accounn =UsersApi.CreateAccount(temp);
                            if(accounn!=null)
                            {
                                useridsforcheckforeventaccount.add(temp);
                                
                                accList.add(accounn);
                            }
                            else
                            {
                                Log_Details__c logobj=new Log_Details__c();
                                logobj.User_Id__c=temp;
                                // logobj.Event_Id__c=neweventaccountmaps.get(temp).Event_ID__c;
                                logobj.error__c='User Id '+temp +' Record is not available in users api while creating for events';
                                logobj.Is_Processed__c=false;
                                logList.add(logobj);
                            }
                            
                        }
                        }
                    }
                }
            }
            
            
            
            
            ///  system.debug('Acclist'+Acclist);
            Map<String, Account> newAccountMap = new Map<String, Account>();
            if(accList.size()>0)
            {
                upsert accList;  
                for(Account temp:accList)
                {
                    newAccountMap.put(temp.User_Id__pc,temp);
                }
            }
            
            
            Map<String, Getin_Event__c> newEventMap = new Map<String, Getin_Event__c>();
            if(eventList.size()>0)
            {
                for(Getin_Event__c temp:eventList)
                {
                    if(newAccountMap.containsKey(temp.User_Id__c))
                    {
                        if(newAccountMap.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                        {
                            temp.Producer__c=newAccountMap.get(temp.User_Id__c).id;
                        }
                    }
                    if(newEventAccountMaps.containsKey(temp.User_Id__c))
                    {
                        if(newEventAccountMaps.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                        {
                            temp.Producer__c=newEventAccountMaps.get(temp.User_Id__c).id;
                        }
                    }
                    
                    if(accountsmapinsalesforce.containsKey(temp.User_Id__c))
                    {
                        if(accountsmapinsalesforce.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                        {
                            temp.Producer__c=accountsmapinsalesforce.get(temp.User_Id__c).id; 
                        }
                    }
                    if(temp.Producer__c==null)
                    {
                        Log_Details__c logobj=new Log_Details__c();
                        logobj.User_Id__c=temp.User_Id__c;
                        logobj.Event_Id__c=temp.Event_ID__c;
                        logobj.error__c='User Id '+temp +' Record is not available in Events Record while creating for Event Id : '+temp.Event_Id__c;
                        logobj.Is_Processed__c=false;
                        logList.add(logobj);
                    }
                }
                upsert eventList;  
                for(Getin_Event__c temp:eventList)
                {
                    system.debug('new event contain currency : '+temp.CurrencyIsoCode+' Event id :'+temp.Event_ID__c);
                    newEventMap.put(temp.Event_ID__c,temp);
                }
            }
            
            
            
            
            //  Map<String, Order> fillnullinviterwithaccount = new Map<String, Order>();
            
            List<Order> orderWithUserId=new List<Order>();
            for(Order temp : orderList)
            {
                if(transactionmap.containsKey(temp.Id__c))
                {
                    temp.id=transactionmap.get(temp.Id__c).id;
                }
                if(temp.User_Id__c!=null)
                {
                    if(newAccountMap.containsKey(temp.User_Id__c) && temp.User_Id__c!=null)
                    {
                        temp.AccountId=newAccountMap.get(temp.User_Id__c).id;
                    }
                }
                if(eventmap.containsKey(temp.Getin_Event_Id__c))
                {
                    temp.CurrencyIsoCode=eventmap.get(temp.Getin_Event_Id__c).CurrencyIsoCode;
                    temp.Event_Id__c=eventmap.get(temp.Getin_Event_Id__c).id;
                } 
                if(newEventMap.containsKey(temp.Getin_Event_Id__c))
                {
                    temp.CurrencyIsoCode=newEventMap.get(temp.Getin_Event_Id__c).CurrencyIsoCode;
                    temp.Event_Id__c=newEventMap.get(temp.Getin_Event_Id__c).id;
                }
                //    system.debug('------------------------Userid : '+temp.User_Id__c+'------------------------------------'+temp.Id__c+' inviter id is  :' +temp.Inviter_Id__c);
                if(temp.AccountId!=null && temp.Inviter_Id__c==null)
                {
                    // system.debug('Orderwithuserid contain userid :'+Orderwithuserid);
                    orderWithUserId.add(temp);
                }
            } 
            /*
for(Order temp : OrderList)
{
fillnullinviterwithaccount.put(temp.Id__c,temp);
}
for(Order temp : OrderList)
{

if(temp.User_Id__c==null)
{system.debug('temp.Inviter_Id__c'+temp.Inviter_Id__c);
system.debug('temp.AccountId'+temp.AccountId);
if(fillnullinviterwithaccount.containsKey(temp.Inviter_Id__c))
{
temp.AccountId=fillnullinviterwithaccount.get(temp.Inviter_Id__c).AccountId;
system.debug('fillnullinviterwithaccount.get(temp.Inviter_Id__c).AccountId'+fillnullinviterwithaccount.get(temp.Inviter_Id__c).AccountId);
}
}
}*/if(orderWithUserId.size()>0)
{
    upsert orderWithUserId;
}
            
            for(order temp : orderWithUserId)
            {
                system.debug('Order id :'+temp.id__c+' Currency '+temp.CurrencyIsoCode+' event id : '+temp.Getin_Event_Id__c);
            }
            List<Order> orderWithoutUserId=new List<Order>();
            
            list<Order> inviterFromPurchasesList = [SELECT ID,Id__c,Inviter_Id__c,AccountId from Order where Id__c in:invitersIds];
            Map<String,Order>inviterMap =new Map<String,Order>(inviterFromPurchasesList);
            for(Order tra:inviterFromPurchasesList)
            {
                inviterMap.put(tra.Id__c,tra);
            }
            for(Order temp : orderList)
            {
                // system.debug('last user id check : '+temp.User_Id__c);
                if(temp.User_Id__c==null)
                {
                    // system.debug('---------------------------------------temp.Inviter_Id__c : '+temp.Inviter_Id__c+'temp.AccountId'+temp.AccountId);
                    
                    if(inviterMap.containsKey(temp.Inviter_Id__c))
                    {
                        temp.AccountId=inviterMap.get(temp.Inviter_Id__c).AccountId;
                        // system.debug('------------------------------------temp.Inviter_Id__c : '+temp.Inviter_Id__c+' -- temp.AccountId --- '+temp.AccountId+' ---Invitermap.get(temp.Inviter_Id__c).AccountId -- '+Invitermap.get(temp.Inviter_Id__c).AccountId);
                        orderWithoutUserId.add(temp);
                    }
                    else
                    {
                        Log_Details__c logobj=new Log_Details__c();
                        logobj.User_Id__c=temp.User_Id__c;
                        logobj.Inviter_Id__c=temp.Inviter_Id__c;
                        logobj.Transaction_Id__c=temp.Id__c;
                        logobj.error__c='User id : '+logobj.User_Id__c+' and Inviter Id : '+logobj.Inviter_Id__c+' not available through Api for Transaction id'+logobj.Transaction_Id__c ;
                        logobj.Is_Processed__c=false;
                        logList.add(logobj);
                    }
                    
                }
                
            }
            upsert  orderWithoutUserId;
            for(order temp : orderWithoutUserId)
            {
                system.debug('Order id :'+temp.id__c+' Currency '+temp.CurrencyIsoCode+' event id : '+temp.Getin_Event_Id__c);
            }
            map <String,Order> orderWithUserIdsMap=new map <String,Order>();
            for(order temp:orderWithUserId)
            {
                orderWithUserIdsMap.put(temp.Id__c,temp);
            }
            map <String,Order> orderWithoutUserIdsMap=new map <String,Order>();
            for(order temp:orderWithoutUserId)
            {
                orderWithoutUserIdsMap.put(temp.Id__c,temp);
            }
            integer i=0;
            list<String> productidslist= new list<string>();
            for(product2 temp:productList)
            {
                productidslist.add(temp.Product_Id__c);
                system.debug(temp.Product_Id__c);
            }
            list<product2> productIntheSalesForce=[SELECT ID,Product_Id__c,CurrencyIsoCode,Quantity__c from product2 where Product_Id__c in:productidslist];
            map <string,product2> productListMap=new map <string,product2>(); 
            for(product2 temp:productIntheSalesForce)
            {
                // system.debug('Quantity of product in salesforce : '+temp.Quantity__c);
                productListMap.put(temp.Product_Id__c,temp);
            }
            for(product2 temp:productList)
            { 
                //system.debug('Quantity of product in apis wala : '+temp.Quantity__c);
                temp.isActive=TRUE;
                if(productListMap.containsKey(temp.Product_Id__c))
                {
                    temp.id=productListMap.get(temp.Product_Id__c).id;
                }
                if(eventmap.containsKey(temp.Event_ID__c))
                {
                    temp.Getin_Event__c=eventmap.get(temp.Event_ID__c).id;
                    temp.CurrencyIsoCode=eventmap.get(temp.Event_ID__c).CurrencyIsoCode;
                    system.debug('Event id is :'+eventmap.get(temp.Event_ID__c).Event_ID__c+'currency is :'+eventmap.get(temp.Event_Id__c).CurrencyIsoCode);
                }
                if(newEventMap.containsKey(temp.Event_ID__c))
                {
                    temp.Getin_Event__c=newEventMap.get(temp.Event_ID__c).id;
                    temp.CurrencyIsoCode=newEventMap.get(temp.Event_Id__c).CurrencyIsoCode;
                    system.debug('Event id is :'+newEventMap.get(temp.Event_ID__c).Event_ID__c+'currency is :'+newEventMap.get(temp.Event_Id__c).CurrencyIsoCode);
                }
                
            }
            
            upsert productList;
            map <string,product2> newProductListMap=new map <string,product2>();
            for(product2 temp:productList)
            {
                //system.debug('new Quantity of product in salesforce : '+temp.Quantity__c);
                newProductListMap.put(temp.Product_Id__c,temp);
            }
            list<PricebookEntry> pricebookEntryListInSalesforce= [SELECT ID,Name,Product_Id__c from PricebookEntry where Product_Id__c in:productidslist];
            map<String,PricebookEntry>  pricebookListMap = new Map<String, PricebookEntry>(pricebookEntryListInSalesforce);
            for(PricebookEntry temp:pricebookEntryListInSalesforce)
            {
                pricebookListMap.put(temp.Product_Id__c,temp);
                //system.debug('temp.Product_Id__c'+temp.Product_Id__c);
            }
            list<PricebookEntry> pricebookentrylist=new  list<PricebookEntry>();
            //Pricebook2 pricebookobj=[select Id, Name, IsActive from PriceBook2 where IsStandard=True and IsActive=True LIMIT 1];
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
            
            map<String,PricebookEntry>  newPricebookListMap = new Map<String, PricebookEntry>();
            for(PricebookEntry temp:pricebookentrylist)
            {
                
                newPricebookListMap.put(temp.Product_Id__c,temp);
                //system.debug('temp.Product_Id__c'+temp.Product_Id__c);
            }
            
            system.debug('--------------------------------------------------------------------------------------------------------------------');
            list <orderitem> insertingOrderItemList=new list<orderitem>();
            list<String> orderitemIds=new list<String>();
            for(orderitem temp:obj.OrderItemsList)
            {
                orderitemIds.add(temp.Order_Id__c);
            }
            list<orderitem> orderItemsInSalesForce=[SELECT ID,Order_Id__c from orderitem where Order_Id__c in:orderitemIds];
            map <string,orderitem> orderItemMap=new map<string,orderitem>();
            boolean doit=false;
            boolean print=false;
            for(orderitem temp:orderItemsInSalesForce)
            {
                orderItemMap.put(temp.Order_Id__c,temp);
            }
            for(orderitem temp:obj.OrderItemsList)
            {
                
                if(orderItemMap.containsKey(temp.Order_Id__c))
                {
                    temp.id=orderItemMap.get(temp.Order_Id__c).id;
                    doit=true;
                }
                
                if(newProductListMap.containsKey(temp.Item_Id__c))
                {
                    if(doit!=true)
                    {
                        temp.Product2Id=newProductListMap.get(temp.Item_Id__c).id;
                        
                    }
                    temp.Quantity=newProductListMap.get(temp.Item_Id__c).Quantity__c;
                    
                }
                if(newAccountMap.containsKey(temp.User_Id__c))
                {
                    temp.Account__c=newAccountMap.get(temp.User_Id__c).id;
                }
                if(accountsmapinsalesforce.containsKey(temp.User_Id__c))
                {
                    temp.Account__c=accountsmapinsalesforce.get(temp.User_Id__c).id;
                }
                
                
                
                if(orderWithoutUserIdsMap.containsKey(temp.Order_Id__c))
                {if(doit!=true)
                {
                    temp.OrderId=orderWithoutUserIdsMap.get(temp.Order_Id__c).id;
                    //temp.CurrencyIsoCode=temp.Order.CurrencyIsoCode;
                    // insertingorderitemlist.add(temp);
                    
                }
                 //  print=true;
                }
                if(orderWithUserIdsMap.containsKey(temp.Order_Id__c))
                {if(doit!=true)
                {
                    temp.OrderId=orderWithUserIdsMap.get(temp.Order_Id__c).id;
                    
                    
                }
                 // print=true;
                }
                if(newPricebookListMap.containsKey(temp.Item_Id__c))
                {
                    if(doit!=true)
                    {
                        temp.PricebookEntryId=newPricebookListMap.get(temp.Item_Id__c).id; 
                    }
                    temp.unitPrice=newPricebookListMap.get(temp.Item_Id__c).UnitPrice;
                    // print=true;
                }
                else
                {
                    system.debug('Order item'+temp.Order_Id__c+' with event id '+temp.Event_Id__c);
                    Log_Details__c logobj=new Log_Details__c();
                    logobj.Transaction_Id__c=temp.Order_Id__c;
                    logobj.Event_Id__c=temp.Event_ID__c;
                    logobj.error__c='Transaction Id '+logobj.Transaction_Id__c +' Record is not available in pricebookentry Record while creating for Event Id : '+temp.Event_Id__c;
                    logobj.Is_Processed__c=false;
                    logList.add(logobj); 
                }
                system.debug('pricebook entry id in orderitem list '+temp.PricebookEntryId+'order item id is : '+temp.Order_Id__c);
                if(temp.OrderId!=null && temp.PricebookEntryId!=null)
                {
                    system.debug('yes');
                    insertingOrderItemList.add(temp);
                }
                else
                {
                    
                }
                doit=false;
            }
            for(orderitem temp:insertingOrderItemList)
            {
                system.debug('orderiteminserting list contain currency :'+temp.CurrencyIsoCode );
                
            }
            if(Loglist.size()>0)
            {
                insert Loglist;  
            }
            if(insertingOrderItemList.size()>0)
            {
                upsert insertingOrderItemList;  
            }
            
        }
    }
}