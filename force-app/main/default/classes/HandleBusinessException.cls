public class HandleBusinessException extends Exception {
    
    public static void captureError(String className, String methodName, Exception ex){
        Exceptions__c newException = createError(className, methodName, ex);
        insertError(newException);          
    }
    
    private static Exceptions__c createError(String className, String methodName, Exception ex){
        Exceptions__c result 		= new Exceptions__c();
        result.Class_Name__c 		= className;
        result.Method_Name__c 		= methodName;
        result.Error_Message__c 	= ex.getMessage();
        result.Error_Stack_Trace__c	= ex.getStackTraceString();
        result.Error_Line_No__c		= ex.getLineNumber();
        result.Error_Type__c		= ex.getTypeName();
        
        return result;
    }
    
    private static void insertError(Exceptions__c exceps){
        try{
            Database.insert(exceps, false);
        }
        catch(DMLException dmlError){}
    }
}