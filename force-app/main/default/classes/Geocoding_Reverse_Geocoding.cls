public class Geocoding_Reverse_Geocoding {
    // 
    // For Getting Address using Lat & Lan
    @future(callout=true)
    public static void parseJSONResponse(String latitue,String longitude) {     
        //String address='18.5538+73.9477';
        String key='AIzaSyB4SPqkO0ZQbxT-EU4l886H9Y3ipf1NMW0';
        Http httpProtocol = new Http();
        // Create HTTP request to send.
        HttpRequest request = new HttpRequest();
        // Set the endpoint URL.
        //  String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key='+key;
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='+latitue+','+longitude+'&key='+key;
        
        request.setEndPoint(endpoint);
        // Set the HTTP verb to GET.
        request.setMethod('GET');
        // Send the HTTP request and get the response.
        // The response is in JSON format.
        HttpResponse response = httpProtocol.send(request);
        System.debug('Response Body : '+response.getBody());
        
        
        
    }   
    
}