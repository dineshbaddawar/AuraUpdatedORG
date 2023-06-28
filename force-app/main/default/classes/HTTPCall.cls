public class HTTPCall {
    public string endPointUrl{get;set;}
    public string method{get;set;}
    public string userName{get;set;}
    public string password{get;set;}
    public integer timeOutDuration{get;set;}
    public string body{get;set;}
    
    public HTTPCall(string endPoint,string method, string body)
    {
        endPointUrl=endPoint;
        System.debug('endPointUrl ::'+endPointUrl);
        method=method;
        System.debug('method ::'+method);
    }
    public HTTPCall(string endPoint,string method,string userName, string password, string body)
    {
        endPointUrl=endPoint;
        method=method;
    }
}