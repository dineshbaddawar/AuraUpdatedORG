public class GetZoneData {
 // It will All Country Zonedata
    public static List<SelectOption> getItems(){
        List<SelectOption> options = new List<SelectOption>();
        Http ht =new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.timezonedb.com/v2/list-time-zone?key=LUXLT8VUSRIF&format=json');
        req.setMethod('GET');
        HttpResponse res = ht.send(req);
        JSON2Apex obj = JSON2Apex.parse(res.getBody());
        System.debug('Res Body '+res.getBody());
        System.debug('message => ' +obj.message);
        System.debug('status => ' +obj.status);
 
        for(JSON2Apex.Zones zone : obj.zones){
           options.add(new SelectOption(String.valueOf(zone.gmtOffset),zone.countryName));
        }  
           System.debug('options => ' +options);
       return options;
   }
}