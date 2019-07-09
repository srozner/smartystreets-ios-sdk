import Foundation

public class URLPrefixSender: SmartySender {
    
    var urlPrefix:String
    var inner:SmartySender
    
    public init(urlPrefix:String, inner:Any) {
        self.urlPrefix = urlPrefix
        self.inner = inner as! SmartySender
    }
    
    override func sendRequest(request: SmartyRequest, error: inout NSError!) -> SmartyResponse! {
        request.urlPrefix = self.urlPrefix
        return self.inner.sendRequest(request: request, error: &error)
    }
}
