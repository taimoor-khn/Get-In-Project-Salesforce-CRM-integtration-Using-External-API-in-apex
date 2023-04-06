public class EventsBatch implements Database.Batchable<Getin_Event__c>,Schedulable,Database.AllowsCallouts,Database.Stateful{
    // instance member to retain state across transactions
    public Integer current_Page{get;set;}
    public Integer Last_Page{get;set;}
    public String Datetobe_processed{get;set;}
    public boolean Chaining{get;set;}
    public GetinEvent__c GEData {get;set;}
    Public EventResponse.Data_Z Responseobj{get;set;}
    
    //constructor 
    public EventsBatch(Integer CurrentPage,Integer LastPage,String Datetobeprocessed,boolean chaining)
    { 
        this.Chaining=chaining;
        this.Last_Page=LastPage;
        this.current_Page=CurrentPage;
        this.Datetobe_processed=Datetobeprocessed;
    }
    public  Iterable<Getin_Event__c> start(Database.BatchableContext bc)
    {
        system.debug('Chaining :'+Chaining);
        if(Chaining)
        { 
            
            GEData = [Select Last_Updation__c from GetinEvent__c limit 1]; 
            Datetobe_processed=String.valueOfGmt(GEData.Last_Updation__c.addHours(2));
            GEData.Last_Updation__c=System.now();  
            system.debug('Date: '+Datetobe_processed);
        }
        system.debug('FirstPage in Start before Api: '+current_Page);
        system.debug('LastPage in Start before Api: '+Last_Page);
        Responseobj=EventsApi.LastUpdateCalling(Datetobe_processed,String.valueOf(current_Page));
        EventWrapperClass obj =new EventWrapperClass(Responseobj);
        
        current_Page=obj.CurrentPage;
        Last_Page=obj.LastPage;
        List<Getin_Event__c> eventlist =obj.EventList;
        system.debug('FirstPage in Start: '+current_Page);
        system.debug('LastPage in Start: '+Last_Page);
        if(Chaining){
            update GEData;
        }
        return eventlist;
    }
    public void execute(Database.BatchableContext bc, List<Getin_Event__c> geteventlist){
        
        EventsBatchUtility.EventBatchRecordProcessing(geteventlist);
        
    }
    public void finish(Database.BatchableContext bc)
    {
        current_Page+=1;
        system.debug('FirstPage in Finish: '+current_Page);
        system.debug('LastPage in Finsh:'+Last_Page);
        system.debug('current_Page<=Last_Page :'+Boolean.valueof(current_Page<=Last_Page));
        system.debug('Date to be Processed in Finish: '+Datetobe_processed);
        if(current_Page<=Last_Page)
        {
            system.debug('Inside Finish Chain');
            system.debug('FirstPage in Finish in Chain: '+current_Page);
            system.debug('LastPage in Finsh in Chain:'+Last_Page);
            EventsBatch bcn = new EventsBatch(current_Page,null,Datetobe_processed,False);
            Database.executeBatch(bcn);
        }
        
        //system.schedule('batch job', '0 * * * *', schedulable)
    }
    public void execute(SchedulableContext sc)
    {
        // EventsBatch eventBatch=new EventsBatch(1,null,null,True);
        // Database.executeBatch(eventBatch);        
    }
}