import Foundation

@objcMembers public class InternationalStreetAnalysis: NSObject, Codable {
    // See "https://smartystreets.com/docs/cloud/international-street-api#analysis"
    
    public var verificationStatus:String?
    public var addressPrecision:String?
    public var maxAddressPrecision:String?
    public var changes:InternationalStreetChanges?
    
    init(dictionary: NSDictionary) {
        self.verificationStatus = dictionary["verification_status"] as? String
        self.addressPrecision = dictionary["address_precision"] as? String
        self.maxAddressPrecision = dictionary["max_address_precision"] as? String
        if let changes = dictionary["changes"] {
            self.changes = InternationalStreetChanges(dictionary: changes as! NSDictionary)
        } else {
            self.changes = InternationalStreetChanges(dictionary: NSDictionary())
        }
    }
}
