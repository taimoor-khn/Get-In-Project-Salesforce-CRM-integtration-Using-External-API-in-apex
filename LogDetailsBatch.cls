public class LogDetailsBatch implements Database.Batchable<log_details__c>,Database.AllowsCallouts,Database.Stateful{
    public List<Transaction_Wrapper_class.data> sendinglist=new List<Transaction_Wrapper_class.data>();
    public  list<log_details__c> start(Database.BatchableContext bc)
    {
        List<log_details__c> loglist=[select id,Transaction_Id__c,User_Id__c,Inviter_Id__c,Ticket_Id__c,Event_Id__c,Is_Processed__c from log_details__c where Is_Processed__c=false];
        for(log_details__c temp: loglist)
        {
             temp.Is_Processed__c=true;
        }
        upsert loglist;
        return loglist;
    }
    public void execute(Database.BatchableContext bc, List<log_details__c> loglist)
    {
        
      

      
      sendinglist=LogDetailsBatchUtility.LogsRecordProcessing(loglist);
        
        
    }
    public void finish(Database.BatchableContext bc)
    {
        if(sendinglist.size()>0)
        {
             OrderBatch bt=new OrderBatch(true,sendinglist);
       		 Database.executeBatch(bt,20); 
        }
        else
        {
            system.debug('no');
        }
      
    }
    
}