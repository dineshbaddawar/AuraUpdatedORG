public with sharing class ContinuationSampleController {
    private static final String LONG_RUNNING_SERVICE_URL ='https://th-apex-http-callout.herokuapp.com/animals';
    @AuraEnabled(continuation=true cacheable=true)
    public static Object startRequest() {
        Continuation con = new Continuation(40);
        // Set callback method
        con.continuationMethod='processResponse';
        System.debug('con.continuationMethod ::'+con.continuationMethod);
        // Set state
        con.state='Hello, World!';
        // Create callout request
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(LONG_RUNNING_SERVICE_URL);
        // Add callout request to continuation
        con.addHttpRequest(req);
          System.debug('req ::'+req);
        // Return the continuation
          System.debug('');
        return con;
    }
    
    @AuraEnabled(cacheable=true)
    public static Object processResponse(List<String> labels, Object state) {
          System.debug(' labels :: '+labels +' AND state ::'+state);
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(labels[0]);
          System.debug('response ::'+response);
        // Set the result variable
        String result = response.getBody();
          System.debug('result ::'+result);
        return result;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint(LONG_RUNNING_SERVICE_URL);
request.setMethod('GET');
HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.
if(response.getStatusCode() == 200) {
// Deserializes the JSON string into collections of primitive data types.
Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
// Cast the values in the 'animals' key as a list
List<Object> animals = (List<Object>) results.get('animals');
System.debug('Received the following animals:');
for(Object animal: animals) {
System.debug(animal);
}
}
System.debug('response ::'+response);
//  return response;
*/
}