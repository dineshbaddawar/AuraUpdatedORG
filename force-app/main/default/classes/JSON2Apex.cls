public class JSON2Apex {
 
    public String status;
    public String message;
    public List<Zones> zones;
 
    public class Zones {
        public String countryCode;
        public String countryName;
        public String zoneName;
        public Integer gmtOffset;
        public Integer timestamp;
    }
 
     
    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
}