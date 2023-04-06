public class LogDetailsBatchUtility {
    public static List<Transaction_Wrapper_class.data> sendinglist=new List<Transaction_Wrapper_class.data>();
    public static  List<Transaction_Wrapper_class.data> LogsRecordProcessing(List<log_details__c> loglist)
    {  
        list<String> inviterids=new list<String>();
        list<String> userids=new list<String>();
        list<String> eventids=new list<String>();
        list<String> ticketids=new list<string>();
        for(log_details__c temp: loglist)
        {
         
            if (temp.User_Id__c==null && temp.Inviter_Id__c!=null && temp.Event_Id__c==null && temp.Ticket_Id__c==null && temp.Transaction_Id__c!=null)
            {
                system.Debug('taimoor');
                inviterids.add(temp.Inviter_Id__c);
                //sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                
            }
            if(temp.User_Id__c!=null && temp.Inviter_Id__c==null && temp.Event_Id__c==null && temp.Ticket_Id__c==null && temp.Transaction_Id__c!=null)
            {
                system.Debug('ali');
                userids.add(temp.User_Id__c);
                // sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                
            }
            if(temp.User_Id__c==null && temp.Event_Id__c!=null && temp.Inviter_Id__c==null && temp.Ticket_Id__c==null && temp.Transaction_Id__c!=null)
            {
                system.Debug('khan');
                eventids.add(temp.Event_Id__c);
                //sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                
            }
            if(temp.User_Id__c==null && temp.Event_Id__c!=null && temp.Inviter_Id__c==null && temp.Ticket_Id__c!=null && temp.Transaction_Id__c!=null)
            {system.Debug('bingo');
             eventids.add(temp.Event_Id__c);
             //ticketids.add(temp.Event_Id__c);
             //sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
            }
        } 
  
        list<Account> accountsinsalesforce = [SELECT ID,Name,User_Id__pc from Account where User_Id__pc in:userids];
        list<Getin_Event__c> EventsfromPurchaseslist = [SELECT ID,Event_ID__c,User_Id__c from Getin_Event__c where Event_ID__c in:eventids];
        list<Order> TransactionfromPurchaseslist = [SELECT ID,Id__c from Order where Id__c in:inviterids];
        Map<String, Getin_Event__c> eventmap = new Map<String, Getin_Event__c>(EventsfromPurchaseslist);
        Map<String, Account> accountmap = new Map<String, Account>(accountsinsalesforce);
        Map<String,Order>Transactionmap =new Map<String,Order>(TransactionfromPurchaseslist);
        list<Account>Acclist=new list<Account>();
        list <string> useridsforcheck=new list <string>();
        list<String>eventidsforcheck=new list<String>();
        list<Getin_Event__c>Eventlist=new list<Getin_Event__c>();
        list<string>UseridsofeventinPurchases=new list<string>();
        list<string>productidcheck=new list<string>();
        list<Product2> productlist = new list<Product2>();
        // list<String> productidlist=new list<string>();
        for(Getin_Event__c temp:EventsfromPurchaseslist)
        {
            eventmap.put(temp.Event_ID__c,temp);
        }
        for(Account acc:accountsinsalesforce)
        {
            accountmap.put(acc.User_Id__pc,acc);
            //system.debug('---------------------------------------------------m.put():'+acc.User_Id__pc);
        }
        for(Order tra:TransactionfromPurchaseslist)
        {
            Transactionmap.put(tra.Id__c,tra);
        }
        list<string> sendingtransactionids=new list<string>();
        list<Product2> checklist = new list<Product2>();
        for(log_details__c temp: loglist)
        {
            
            if (temp.User_Id__c==null && temp.Inviter_Id__c!=null && temp.Event_Id__c==null && temp.Ticket_Id__c==null && temp.Transaction_Id__c!=null)
            {
                if(Transactionmap.containsKey(temp.Inviter_Id__c))
                {sendingtransactionids.add(temp.Inviter_Id__c);
                 //sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                }
                else
                {sendingtransactionids.add(temp.Inviter_Id__c);
                 sendingtransactionids.add(temp.Transaction_Id__c);
                 // sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Inviter_Id__c));
                 // sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                }
                
            }
            if(temp.User_Id__c!=null && temp.Inviter_Id__c==null && temp.Event_Id__c==null && temp.Ticket_Id__c==null && temp.Transaction_Id__c!=null)
            {
                if(accountmap.containsKey(temp.User_Id__c))
                {sendingtransactionids.add(temp.Transaction_Id__c);
                 //sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));    
                }
                else
                {
                    sendingtransactionids.add(temp.Transaction_Id__c);
                    //sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                    if(!useridsforcheck.contains(temp.User_Id__c))
                    {
                        Account accoun =UsersApi.CreateAccount(temp.User_Id__c);
                        if(accoun!=null)
                        {
                            useridsforcheck.add(temp.User_Id__c);
                            Acclist.add(accoun);
                        }  
                    }
                }
                
            }
            if(temp.User_Id__c==null && temp.Event_Id__c!=null && temp.Inviter_Id__c==null && temp.Ticket_Id__c==null && temp.Transaction_Id__c!=null)
            {
                if(eventmap.containsKey(temp.Event_Id__c))
                {
                    sendingtransactionids.add(temp.Transaction_Id__c);
                    // sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c)); 
                }
                else
                {
                    sendingtransactionids.add(temp.Transaction_Id__c);
                    //  sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                    if(!eventidsforcheck.contains(temp.Event_Id__c))
                    {
                        Getin_Event__c newevent= EventsApi.geteventbyid(Integer.valueOf(temp.Event_Id__c));
                        eventidsforcheck.add(temp.Event_Id__c);
                        Eventlist.add(newevent); 
                        if(!accountmap.containsKey(newevent.User_Id__c))
                        {
                            
                            UseridsofeventinPurchases.add(newevent.User_Id__c);
                        }
                        else
                        {
                            if(accountmap.get(newevent.User_Id__c).User_Id__pc==newevent.User_Id__c)
                            {
                                newevent.Producer__c=accountmap.get(newevent.User_Id__c).id; 
                            }
                        }   
                    }
                    
                    
                }
                
                
            }
            if(temp.User_Id__c==null && temp.Event_Id__c!=null && temp.Inviter_Id__c==null && temp.Ticket_Id__c!=null && temp.Transaction_Id__c!=null)
            {
                sendingtransactionids.add(temp.Transaction_Id__c);
                //    sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
                if(eventmap.containsKey(temp.Event_Id__c))
                {
                    
                }
                else
                {
                    if(!eventidsforcheck.contains(temp.Event_Id__c))
                    {
                        Getin_Event__c newevent= EventsApi.geteventbyid(Integer.valueOf(temp.Event_Id__c));
                        eventidsforcheck.add(temp.Event_Id__c);
                        Eventlist.add(newevent); 
                        if(!accountmap.containsKey(newevent.User_Id__c))
                        {
                            UseridsofeventinPurchases.add(newevent.User_Id__c);
                        }
                        else
                        {
                            if(accountmap.get(newevent.User_Id__c).User_Id__pc==newevent.User_Id__c)
                            {
                                newevent.Producer__c=accountmap.get(newevent.User_Id__c).id; 
                                
                            }
                        } 
                        
                    }
                }
                
                
            }   
            //sendinglist.addall(OrdersApi.TransactionCallingWithId(temp.Transaction_Id__c));
        }
            list<string> checkingids=new list<string>(); 
        List<Transaction_Wrapper_class.data> result=new List<Transaction_Wrapper_class.data>();
        for(string temp:sendingtransactionids)
        {
            if(!checkingids.contains(temp))
            {
                result=OrdersApi.TransactionCallingWithId(temp);
                if(result!=null)
                {
                    sendinglist.addall(result);
                    system.debug('result');
                }
                
                checkingids.add(temp);
            }
        }
        list<Account> AccountsfromPurchaseslistofeventsids = [SELECT ID,Name,User_Id__pc from Account where User_Id__pc in:UseridsofeventinPurchases];
        Map<String, Account> neweventaccountmaps = new Map<String, Account>(AccountsfromPurchaseslistofeventsids);
        for(account temp:AccountsfromPurchaseslistofeventsids)
        {
            neweventaccountmaps.put(temp.User_Id__pc,temp);
        }
        list<String> useridsforcheckforeventaccount=new list<String>();
        for(String temp:UseridsofeventinPurchases)
        {
            if(!neweventaccountmaps.containsKey(temp))
            { 
                if(!useridsforcheckforeventaccount.contains(temp) )
                { if(!useridsforcheck.contains(temp))
                {
                    Account accounn =UsersApi.CreateAccount(temp);
                    if(accounn!=null)
                    {
                        useridsforcheckforeventaccount.add(temp);
                        
                        Acclist.add(accounn);
                    }
                    
                }
                }
            }
        }
        upsert Acclist;
        Map<String, Account> newaccountmap = new Map<String, Account>(Acclist);
        
        for(Account temp:Acclist)
        {
            newaccountmap.put(temp.User_Id__pc,temp);
        }
        for(Getin_Event__c temp:Eventlist)
        {
            if(newaccountmap.containsKey(temp.User_Id__c))
            {
                if(newaccountmap.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                {
                    temp.Producer__c=newaccountmap.get(temp.User_Id__c).id;
                }
            }
            if(neweventaccountmaps.containsKey(temp.User_Id__c))
            {
                if(neweventaccountmaps.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                {
                    temp.Producer__c=neweventaccountmaps.get(temp.User_Id__c).id;
                }
            }
            
            if(accountmap.containsKey(temp.User_Id__c))
            {
                if(accountmap.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                {
                    temp.Producer__c=accountmap.get(temp.User_Id__c).id; 
                }
            }
        }
        system.debug('iiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii'+Eventlist);
        upsert Eventlist;
      
    
        return sendinglist;
    }
}