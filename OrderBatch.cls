public class OrderBatch implements Database.Batchable<Transaction_Wrapper_class.data>,Database.AllowsCallouts,Database.Stateful{
    public boolean logsRecord{get;set;} 
    public List<Transaction_Wrapper_class.data> responseList{get;set;}
    
    //Public List<OrderItem> AllOrderItemsList=new list<orderitem>();
    
    public OrderBatch(boolean logsrecord,List<Transaction_Wrapper_class.data> logsresponserecord)
    {
        this.responseList=logsresponserecord;
        this.logsRecord=logsrecord;
        
    }
    
    public  Iterable<Transaction_Wrapper_class.data> start(Database.BatchableContext bc)
    {
        
        if(logsRecord)
        { 
            return responseList;
        }
        else
        {
            responseList= OrdersApi.TransactionLastUpdateCalling('2022-06-01 00:01:05');
        }
        //system.debug('Datetobe_processed : '+Datetobe_processed);
        
        //   system.debug('responselist'+responselist);
        
        return responseList;
    }
    public void execute(Database.BatchableContext bc, List<Transaction_Wrapper_class.data> responseList)
    {
        if(responseList.size()>0)
        {
            OrderBatchUtility.OrderBatchRecordProcessing(responseList);
        }
        
        
    }
    public void finish(Database.BatchableContext bc)
    {
        
    }
    
}