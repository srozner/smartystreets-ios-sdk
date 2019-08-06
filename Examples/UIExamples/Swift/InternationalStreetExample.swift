import UIKit

class InternationalStreetExample: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var country: UITextField!
    @IBOutlet weak var freeform: UITextField!
    @IBOutlet weak var result: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        country.delegate = self
        freeform.delegate = self
    }
    
    @IBAction func Execute(_ sender: Any) {
        result.text = run()
    }
    
    func run() -> String {
        let client = SSClientBuilder(id: "KEY", hostname: "hostname").buildInternationalStreetApiClient()
//        let authId = ProcessInfo.processInfo.environment["SMARTY_AUTH_ID"]
//        let authToken = ProcessInfo.processInfo.environment["SMARTY_AUTH_TOKEN"]
//        let client = SSClientBuilder(authId: authId, authToken: authToken).buildInternationalStreetApiClient()
        
        // Documentation for input fields can be found at:
        // https://smartystreets.com/docs/cloud/international-street-api#http-input-fields
        
        var lookup:InternationalStreetLookup
        
        if let freeform = self.freeform.text, let country = self.country.text {
            lookup = InternationalStreetLookup(freeform: freeform, country: country, inputId: nil)
        } else {
            return "Country and Freeform address required"
        }
        lookup.organization = "John Doe"
        lookup.enableGeocode(geocode: true) // Must be expressly set to get latitude and longitude
        
        var error:NSError! = nil
        
        _ = client.sendLookup(lookup:&lookup, error:&error)
        if let error = error {
            let output = """
            Domain: \(error.domain)
            Error Code: \(error.code)
            Description:\n\(error.userInfo[NSLocalizedDescriptionKey] as! NSString)
            """
            NSLog(output)
            return output
        }
        
        let results:[InternationalStreetCandidate] = lookup.result ?? []
        var output = "Results:\n"
        
        if results.count == 0 {
            return "Error. Address is not valid"
        }
        
        let candidate = results[0]
        if let analysis = candidate.analysis, let metadata = candidate.metadata {
            output.append("""
                \nAddress is \(analysis.verificationStatus ?? "")
                \nAddress precision: \(analysis.addressPrecision ?? "")\n
                \nFirst Line: \(candidate.address1 ?? "")
                \nSecond Line: \(candidate.address2 ?? "")
                \nThird Line: \(candidate.address3 ?? "")
                \nFourth Line: \(candidate.address4 ?? "")
                \nLatitude: \(metadata.latitude ?? 0)
                \nLongitude: \(metadata.longitude ?? 0)
                """)
            return output
        }
    
        return "Uncaught Error"
    }
    
    @IBAction func Return(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
