public class TriggerHandlerClass {
    
    // On Task If Stauts is Completed then Then Make priprity as "High" before Insert & Update else Normal
    
    public Static void updateTaskPriority(List<Task> newTaskList,Map<Id,Task> newTaskMap,List<Task> oldTaskList,Map<Id,Task> oldTaskMap){
        System.debug(' newTaskList >>::'+newTaskList);
        System.debug(' newTaskMap >>::'+newTaskMap);
        System.debug(' oldTaskList >>::'+oldTaskList);
        System.debug(' oldTaskMap >>::'+oldTaskMap);
        for(Task tk : newTaskList){
            if(oldTaskMap != null){
                if( tk.Status !=  oldTaskMap.get(tk.Id).Status){
                    System.debug('Before Class ::');
                    if(tk.Status == 'Completed'){
                        tk.Priority = 'High';
                    }
                    
                }
                
            }
            
            if(oldTaskMap == null){
                System.debug('Before Class ::');
                tk.ActivityDate = System.today().addDays(7);
            }
        }
    }
    
    public Static void beforeUpdate(List<Task> newTaskList){
        for(Task tk : newTaskList){
            if(tk.Subject !=null){
                System.debug('tk.Subject :::'+tk.Subject);
                Boolean result=tk.Subject.contains('FORCE');
                
                if(result == true){
                    tk.ActivityDate = System.today().addDays(7);
                }else{
                    System.debug('Not Found');
                }
                
            }
        }
    }
}