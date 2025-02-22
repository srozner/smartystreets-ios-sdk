import Foundation
import SmartyStreets

class InternationalAutocompleteExample {
    func run() -> String {
        let id = "ID"
        let hostname = "Hostname"
        //            The appropriate license values to be used for your subscriptions
        //            can be found on the Subscriptions page of the account dashboard.
        //            https://www.smartystreets.com/docs/cloud/licensing
        let client = ClientBuilder(id: id, hostname: hostname).withLicenses(licenses: ["international-autocomplete-cloud"]).buildInternationalAutocompleteApiClient()
        
        // Documentation for input fields can be found at:
        // https://smartystreets.com/docs/cloud/international-address-autocomplete-api#http-input-fields
        
        var lookup = InternationalAutocompleteLookup()
        lookup.country = "FRA"
        lookup.locality = "Paris"
        lookup.search = "Louis"
        
        var error: NSError! = nil
        
        _ = client.sendLookup(lookup: &lookup, error:&error)
        if let error = error {
            let output = """
            Domain: \(error.domain)
            Error Code: \(error.code)
            Description:\n\(error.userInfo[NSLocalizedDescriptionKey] as! NSString)
            """
            NSLog(output)
            return output
        }
        
        let results:InternationalAutocompleteResult = lookup.result ?? InternationalAutocompleteResult(dictionary: NSDictionary())
        let candidates:[InternationalAutocompleteCandidate] = results.candidates ?? []
        var output = "Results:\n"
        
        if candidates.count == 0 {
            return "Error. Address is not valid"
        }
        
        for candidate in candidates {
            output.append("\(candidate.street ?? "") \(candidate.locality ?? "") \(candidate.administrativeArea ?? ""), \(candidate.countryISO3 ?? "")")
        }
        
        return output
    }
}
