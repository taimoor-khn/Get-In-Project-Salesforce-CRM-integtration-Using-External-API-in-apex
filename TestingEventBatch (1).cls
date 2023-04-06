public with sharing class TestingEventBatch implements Database.Batchable<Integer>{
    // instance member to retain state across transactions
    public Integer counter = 0;
    public Integer TotalRecord = 0;
    public Iterable<Integer> start(Database.BatchableContext bc) {
        
        list<Integer> UpdatedEventsId =UpdatedEvents.eventcalling('1000');
        TotalRecord=UpdatedEventsId.size();
        return UpdatedEventsId;
    }
    public void execute(Database.BatchableContext bc, list<Integer> scope){ 
        
        system.debug('scope'+scope);
        for(integer temp:scope)
        {
           Getin_Event__c eventobj=[SELECT Id, Producer__c FROM Getin_Event__c where id =:String.valueOf(temp)];
            if(eventobj!=null && eventobj.Producer__c!=null)
            {
                    //updation
            }
            else
            {
               Getin_Event__c getinevent=TestingEvent.geteventbyid(temp);
               Account accobj=[SELECT ID,User_Id__pc from Account where User_Id__pc=:getinevent.Producer__c];
                if(accobj==null)
                {
                    accobj =Testingapi.usercalling(getinevent.Producer__c);
                    insert accobj;
                    insert getinevent;
                }
                else
                {
                    insert getinevent;
                }
            }
            
        }
        
        
        
        
        
    }
    public void finish(Database.BatchableContext bc)
    {
        
        
    }
    
    
}