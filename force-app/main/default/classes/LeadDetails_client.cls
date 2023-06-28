// Class For   Getting Lead Recor By Sendin Country as Input
public class LeadDetails_client {
    public String Country;
    public static LeadDetails_client parse(String json) {
        return (LeadDetails_client) System.JSON.deserialize(json, LeadDetails_client.class);
    }
}