public class Getgeolocation {
    
    @AuraEnabled
    public Static String getAddressofLead(String recordId){
        Lead led = [SELECT Id,Name,Address,Street,City,State,PostalCode,Country FROM Lead Where Id=:recordId LIMIT 1];
        String Address = led.Street + ', '+led.City+ ', '+led.State + ', '+led.PostalCode + ', '+led.Country;
        System.debug('led Address ::'+led.Street + ', '+led.City+ ', '+led.State + ', '+led.PostalCode + ', '+led.Country);
        Getgeolocation.getLongandLat(Address,recordId);
        
        return Address;
    }
    
    @AuraEnabled
    public Static Map<String,String> getLongandLat(String Addresss, String reocrdId){
        Map<String,String> responseMap = new Map<String,String>();
        String apikey ='AIzaSyB4SPqkO0ZQbxT-EU4l886H9Y3ipf1NMW0';
        String baseURL = 'https://maps.googleapis.com/maps/api/geocode/json?address=';
        
        String encodedAddresss = EncodingUtil.urlEncode(Addresss, 'UTF-8');
        String url = baseURL+encodedAddresss+'&key='+apikey;
        System.debug('encoded url ::'+url);
        Http ht =new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Content-Length', '0');
        HttpResponse res = ht.send(req);
        String response = (res.getBody());
        System.debug('response ::'+response);
        
        LocationParser parsedJson = LocationParser.parse(res.getBody());
        system.debug('parsedJson ====> ' + parsedJson);
        system.debug('parsedJson results ====> ' + parsedJson.results);
        
        LocationParser.Results parserResult = parsedJson.results[0];
        LocationParser.Geometry parserGeometry = parserResult.geometry;
        LocationParser.Location parserLocation = parserGeometry.location;
        Double lat = parserLocation.lat;
        Double lang = parserLocation.lng;
        
        responseMap.put('lat',String.valueOf(lat));
        responseMap.put('lang',String.valueOf(lang));
       // String recordId= '';
        System.debug('responseMap---'+String.valueOf(responseMap));
        Getgeolocation.updateGeolocation(reocrdId,String.valueOf(lat),String.valueOf(lang));        
        return responseMap;
    }
    
    @AuraEnabled
    public Static Lead updateGeolocation(String recordId, String lat, String lng){
        Lead led = [SELECT Id,Name,Address,Street,City,State,PostalCode,Country,Geolocation__Latitude__s,Geolocation__Longitude__s FROM Lead Where Id=:recordId LIMIT 1];
        led.Geolocation__Latitude__s =Decimal.valueOf(lat);
        led.Geolocation__Longitude__s =Decimal.valueOf(lng);
        update led;
        System.debug('Updated Lead :'+led);
        return led;
    }
}