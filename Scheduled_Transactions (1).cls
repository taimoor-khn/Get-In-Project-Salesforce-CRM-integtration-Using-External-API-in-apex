global class Scheduled_Transactions Implements Schedulable
{
    global void execute(SchedulableContext sc)
    {
        
        FirstGetinUsersApiCall.postcallout();
        list<Transaction_Wrapper_class.data>  Reuturned_listofTransactions =  TestingTransaction.usercalling('2022-11-24 00:01:05');
        //system.debug('ddddddddddddddddd'+Reuturned_listofTransactions);
        //list<Transaction_Wrapper_class.data> Trnasaction_object = Reuturned_listofTransactions.data;
        //system.debug('rrrrrrrrrrrrrrrrrrrrr'+Reuturned_listofTransactions.data[2]);
        for (Transaction_Wrapper_class.data ob : Reuturned_listofTransactions)
        {
            system.debug('List : '+ob.event_id);
            //returned_List.add(ob);
        }
        
        
    }
    
    
}