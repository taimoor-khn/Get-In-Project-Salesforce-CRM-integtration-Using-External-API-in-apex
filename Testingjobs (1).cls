public class Testingjobs implements Queueable  {
    public integer start;
    public integer ending;
    public List<Account> accl =new List<Account>();
    public void execute(QueueableContext context)
    {
        system.debug('start :'+start);
        if((start+100)<ending)
        {
            for(integer i=start;i<100;i++)
            {
                system.debug(i);
                //accl.addAll(Testingapi.postcallout(i));
               // accl.addAll(Testingapi.usercalling(String.valueOf(i)));
            }
            if(accl.size()>=0)
            {
                insert accl;
                start+=100;
            }
            system.debug('Start at end: '+start);
        }
        if(start<ending){
            Testingjobs chainedJob=new Testingjobs();
            chainedJob.start=start;
            chainedJob.ending=ending;
            System.enqueueJob(chainedJob);
        }  
    }
    
}