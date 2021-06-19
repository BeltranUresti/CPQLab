/**
 * Created by Administrador 1 on 05/06/2021.
 */

public with sharing class VidSigner_HandleCustomException   extends Exception {

    public static void LogException(Exception e)
    {
        LogException(e,'','');
    }
    // Log Exception in CustomException object.
    // relatedToId : Case/object for which this error in logged.
    @Future
    public static void LogException(String relatedToId, String messageDesc){
        LogException(null,relatedToId,messageDesc);
    }

    public static void LogException(Exception e,String relatedToId, String messageDesc)
    {
        try
        {
            //Log information in object
            VIDSigner_Tracker__c exc = new VIDSigner_Tracker__c();

            if( e != null){
                String stackTrace = e.getStackTraceString().substringBefore('\n');
                String className = stackTrace.substringAfter('.').substringBefore('.');
                String methodName = stackTrace.substringBefore(':').substringAfter(className).substringAfter('.');
                exc.Exception_Message__c = e.getMessage();
                exc.Exception_Type__c = e.getTypeName();
                exc.Line_Number__c = e.getLineNumber();
                exc.StackTrace__c = e.getStackTraceString();
                exc.MethodName__c=methodName;
                exc.ClassName__c=className;
            }else{
                exc.Exception_Message__c = messageDesc;
            }


            //Governer Limit of executingQuery
            String QueryLimit = '1. SOQL Queries used / SOQL Queries allowed: ' + Limits.getQueries() + '/' + Limits.getLimitQueries();
            String DMLimit = '2. Number of records queried so far /  Number allowed: ' + Limits.getDmlRows() + '/' + Limits.getLimitDmlRows();
            String DMLStat = '3. Number of DML statements used so far / Number allowed: ' +  Limits.getDmlStatements() + '/' + Limits.getLimitDmlStatements();
            String CPUT = '4. Amount of CPU time (in ms) used so far / CPU usage time (in ms) allowed: ' + Limits.getCpuTime() + '/' + Limits.getLimitCpuTime();


            exc.Related_To_Number__c=relatedToId;
            exc.Govt_Limit_in_Executing_Code__c = String.format('{0}\n{1}\n{2}\n{3}',new List<String>{QueryLimit, DMLimit,DMLStat,CPUT});

            Database.insert(exc);
        }
        finally{
        }
    }
}