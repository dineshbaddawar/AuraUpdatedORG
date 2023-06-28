// API to Find Record Using Country
@RestResource(urlMapping='/APIToFindRecordFromCountry/*')
global class APIGETRECORDUsingCountry {
    @HttpPost
    global static responseWrapper FindRecord(){
        try{
            responseWrapper responseJSON = new responseWrapper();
            System.debug('responseJSON :: '+responseJSON);
            LeadDetails_client leadRec = LeadDetails_client.parse(RestContext.request.requestBody.tostring());
            System.debug('leadRec :: '+leadRec);
            List<Lead> LeadRecordList = new List<Lead>();
            if(!String.isBlank(leadRec.Country)){
                LeadRecordList = [SELECT Id,Name,Phone,OwnerId,Country,LeadSource FROM Lead WHERE Country =:leadRec.Country];
                System.debug('LeadRecordList :::'+LeadRecordList);
                for(Lead led : LeadRecordList){
                    responseJSON.Message = 'Record Found Successfully';
                    responseJSON.LeadRecord = led;
                }
            }else{
                responseJSON.Message = 'ERROR';
            }
            return responseJSON;
            
        }catch(Exception e){
            System.debug('Error Message :'+e.getMessage() +' Error Line ::'+e.getLineNumber());
        }
        return null;
    }
    global class responseWrapper {
        global String Message;
        global Lead LeadRecord;
    }
    
}