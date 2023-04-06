public class TransactionsBatch implements Database.Batchable<Transaction_Wrapper_class.data>,Database.AllowsCallouts,Database.Stateful{
    
    public GetinPurchases__c PData {get;set;}
    public String Datetobe_processed{get;set;}
    public boolean dateUpdate{get;set;}
    public TransactionsBatch(String queryDate,Boolean dateCheck){
        this.Datetobe_processed=queryDate;
        this.dateUpdate=dateCheck;
    }
    public  Iterable<Transaction_Wrapper_class.data> start(Database.BatchableContext bc)
    {
        if(dateUpdate){
            PData=[select id,Last_Updation__c from GetinPurchases__c limit 1];
            Datetobe_processed=String.valueOfGmt(PData.Last_Updation__c.addHours(2));
            PData.Last_Updation__c=System.now(); 
        }
        //system.debug('Datetobe_processed : '+Datetobe_processed);
        List<Transaction_Wrapper_class.data> responselist= TransactionsApi.TransactionLastUpdateCalling('2022-11-04 00:01:05');
        
        if(dateUpdate){
            update PData;
        } 
        return responselist;
    }
    public void execute(Database.BatchableContext bc, List<Transaction_Wrapper_class.data> responselist){
        
        
        //List<Transaction_Wrapper_class.data> responselist= TestingTransaction.TransactionLastUpdateCalling('2022-12-01 00:01:05');
        Transaction_Response_Lists obj=new Transaction_Response_Lists(responselist);
        
        
        list<String> Userids = new list<String>();
        list<String>UseridsofeventinPurchases=new list<String>();
        list<String> Eventids = new list<String>();
        list<String> TransactionIds=new list<String>();
        list<String> InvitersIds=new list<String>();
        
        for(Purchase__c temp : obj.PurchasesList)
        {
            Userids.add(temp.User_Id__c);
            Eventids.add(temp.Event_Id__c);
            TransactionIds.add(temp.Name);
            
            InvitersIds.add(temp.Inviter_Id__c);
        }    
        
        list<Account> AccountsfromPurchaseslist = [SELECT ID,Name,User_Id__pc from Account where User_Id__pc in:Userids];
        list<Getin_Event__c> EventsfromPurchaseslist = [SELECT ID,Event_ID__c,User_Id__c from Getin_Event__c where Event_ID__c in:Eventids];
        list<Purchase__c> TransactionfromPurchaseslist = [SELECT ID,Name from Purchase__c where Name in:TransactionIds];
        list<Purchase__c> InviterfromPurchaseslist = [SELECT ID,Name,Inviter_Id__c from Purchase__c where Name in:InvitersIds];
        Map<String, Getin_Event__c> eventmap = new Map<String, Getin_Event__c>(EventsfromPurchaseslist);
        Map<String, Account> m = new Map<String, Account>(AccountsfromPurchaseslist);
        Map<String,Purchase__c>Transactionmap =new Map<String,Purchase__c>(TransactionfromPurchaseslist);
        Map<String,Purchase__c>Invitermap =new Map<String,Purchase__c>(InviterfromPurchaseslist);
        
        
        
        for(Getin_Event__c temp:EventsfromPurchaseslist)
        {
            eventmap.put(temp.Event_ID__c,temp);
        }
        for(Account acc:AccountsfromPurchaseslist)
        {
            m.put(acc.User_Id__pc,acc);
            system.debug('---------------------------------------------------m.put():'+acc.User_Id__pc);
        }
        for(Purchase__c tra:TransactionfromPurchaseslist)
        {
            Transactionmap.put(tra.Name,tra);
        }
        for(Purchase__c tra:InviterfromPurchaseslist)
        {
            Invitermap.put(tra.Inviter_Id__c,tra);
        }
        
        ///////////////////////////////////////////////////////////////////
        list<String> useridsforcheck = new list<String>();
        list<String> useridsforcheck2 = new list<String>();
        list<Account> Acclist = new list<Account>();
        list<String> eventidsforcheck = new list<String>();
        list<Getin_Event__c> Eventlist = new list<Getin_Event__c>();
        list<String> checklistinviterid = new list<string>();
        ///////////////////////////////////////////////////////////////////
        for(Purchase__c temp : obj.PurchasesList)
        {
            // system.debug('---------------------------------------------------temp'+temp.User_Id__c+'event id'+temp.Event_ID__c);
            if(Transactionmap.containsKey(temp.Name))
            {
                temp.id=Transactionmap.get(temp.Name).id;
            }
            
            if(temp.User_Id__c==null && temp.Inviter_Id__c!=null)
            {
                
                if(Invitermap.containsKey(temp.Inviter_Id__c))
                {
                    temp.Inviter_Purchase__c=Invitermap.get(temp.Inviter_Id__c).id;
                }
                else
                {
                    if(!checklistinviterid.contains(temp.Inviter_Id__c))
                    {
                        //  createinviterid
                        
                        //   checklistinviterid.add(temp.Inviter_Id__c);
                    }
                }
                //else transaction nai ho to mangwaon? agar mangawao or wo isi main ho?
            }
            
            
            if(m.containsKey(temp.User_Id__c) && temp.User_Id__c!=null)
            {
                temp.Account__c=m.get(temp.User_Id__c).id;
            }
            else
            {
                if(!useridsforcheck.contains(temp.User_Id__c) && temp.User_Id__c!=null)
                {
                    
                    system.debug('Account -----------------------------------------1-'+temp.User_Id__c);
                    Account accoun =UsersApi.CreateAccount(temp.User_Id__c);
                    useridsforcheck.add(temp.User_Id__c);
                    
                    Acclist.add(accoun);
                }
                
            }
            
            if(eventmap.containsKey(temp.Event_ID__c))
            {
                temp.Getin_Event__c=eventmap.get(temp.Event_ID__c).id;
            }
            else
            {
                if(!eventidsforcheck.contains(temp.Event_ID__c))
                {//system.debug('---------------------------------------------------');
                    //system.debug('---------------------------------------------------------'+temp.Event_ID__c);
                    //system.debug('---------------------------------------------------');
                    Getin_Event__c newevent= EventsApi.geteventbyid(Integer.valueOf(temp.Event_ID__c));
                    
                    eventidsforcheck.add(temp.Event_ID__c);
                    ////////////////////////----------------ticket call for events
                    Eventlist.add(newevent);
                    if(!m.containsKey(newevent.User_Id__c))
                    {
                        UseridsofeventinPurchases.add(newevent.User_Id__c);
                        /*  if(!useridsforcheck.contains(newevent.User_Id__c))
{
system.debug('Account-------------------------------------------------2-'+newevent.User_Id__c);

Account accounn =UsersApi.CreateAccount(newevent.User_Id__c);

useridsforcheck.add(newevent.User_Id__c);

Acclist.add(accounn);

}
else
{
system.debug('-------------------------------------------------------------repeat 2 -'+newevent.User_Id__c);
}*/
                    }
                    else
                    {
                        if(m.get(newevent.User_Id__c).User_Id__pc==newevent.User_Id__c)
                        {
                            newevent.Producer__c=m.get(newevent.User_Id__c).id; 
                        }
                    }
                }  
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
                    
                    useridsforcheckforeventaccount.add(temp);
                    
                    Acclist.add(accounn);
                }
                 
                }
                
            }
        }
        ////////////////////////////////////////
        
        insert Acclist;
        
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
            
            if(m.containsKey(temp.User_Id__c))
            {
                if(m.get(temp.User_Id__c).User_Id__pc==temp.User_Id__c)
                {
                    temp.Producer__c=m.get(temp.User_Id__c).id; 
                }
            }
        }
        insert Eventlist;
        
        Map<String, Getin_Event__c> neweventmap = new Map<String, Getin_Event__c>(Eventlist);
        for(Getin_Event__c temp:Eventlist)
        {
            neweventmap.put(temp.Event_ID__c,temp);
        }
        for(Purchase__c temp : obj.PurchasesList)
        {
            if(temp.User_Id__c!=null)
            {
                if(newaccountmap.containsKey(temp.User_Id__c) && temp.User_Id__c!=null)
                {
                    temp.Account__c=newaccountmap.get(temp.User_Id__c).id;
                }
            }
            if(eventmap.containsKey(temp.Event_ID__c))
            {
                temp.Getin_Event__c=eventmap.get(temp.Event_ID__c).id;
            } 
            if(neweventmap.containsKey(temp.Event_ID__c))
            {
                temp.Getin_Event__c=neweventmap.get(temp.Event_ID__c).id;
            } 
            
        }  
        upsert  obj.PurchasesList;
        list<Purchase__c> NewTransactionfromPurchaseslist = [SELECT ID,Name,Account__c from Purchase__c where Name in:TransactionIds];
        list<Purchase__c> NewInviterfromPurchaseslist = [SELECT ID,Name,Inviter_Id__c from Purchase__c where Name in:InvitersIds];
        Map<String,Purchase__c>NewInvitermap =new Map<String,Purchase__c>(NewInviterfromPurchaseslist);
        for(Purchase__c tra:NewInviterfromPurchaseslist)
        {
            NewInvitermap.put(tra.Name,tra);
        }
        Map<String,Purchase__c>NewTransactionmap =new Map<String,Purchase__c>(NewTransactionfromPurchaseslist);
        for(Purchase__c tra:NewTransactionfromPurchaseslist)
        {
            NewTransactionmap.put(tra.Name,tra);
            //system.debug('tra.Name'+tra.Name);
        }
        
        for(Purchase__c temp : obj.PurchasesList)
        {
            if(temp.Inviter_Id__c!=null)
            {
                if(NewInvitermap.containsKey(temp.Inviter_Id__c))
                {
                    temp.Inviter_Purchase__c=NewInvitermap.get(temp.Inviter_Id__c).id;
                }//jo new purchases create hoi hain or purani hai sirf wohi check karta hai agaar in main wo na ho?
                
            }
            
        }
        List<Sub_Purchase__c> sublist = new list<Sub_Purchase__c>();
        List<Sub_Purchase__c> subpurchaselist=new list<Sub_Purchase__c>();
        List<String> subpurchasesid=new list<String>();
        
        for(Sub_Purchase__c temp:obj.AllSubPurchasesList)
        {
            subpurchasesid.add(temp.Sub_Purchase_ID__c);
        }
        list<Sub_Purchase__c> SubPurchasesfromSubPurchaseslist = [SELECT ID,Name,Purchase__c,Sub_Purchase_ID__c from Sub_Purchase__c where Sub_Purchase_ID__c in:subpurchasesid];
        Map<String, Sub_Purchase__c> subpurchasesmap = new Map<String, Sub_Purchase__c>(SubPurchasesfromSubPurchaseslist);
        for(Sub_Purchase__c temp:SubPurchasesfromSubPurchaseslist)
        {
            subpurchasesmap.put(temp.Sub_Purchase_ID__c,temp);
        }
        for(String key:obj.MapSubPurchases.keyset())
        {
            
            if(NewTransactionmap.containsKey(key))
            {
                sublist  =obj.MapSubPurchases.get(key);
                for(Sub_Purchase__c temp:sublist)
                {
                    if(subpurchasesmap.containsKey(temp.Sub_Purchase_ID__c))
                    {
                        temp.id=subpurchasesmap.get(temp.Sub_Purchase_ID__c).id;
                        //temp.Purchase__c=subpurchasesmap.get(temp.Sub_Purchase_ID__c).Purchase__c;
                    }
                    
                    //system.debug(temp.Purchase__c+temp.Name);
                    temp.Purchase__c=NewTransactionmap.get(key).id;
                    //system.debug(temp.Purchase__c+temp.Name);
                    temp.Account__c=NewTransactionmap.get(key).Account__c;
                    
                    subpurchaselist.add(temp);
                }
            }
        }
        
        upsert  obj.PurchasesList;
        upsert subpurchaselist;
        
        
    }
    public void finish(Database.BatchableContext bc)
    {
        
    }
    
}