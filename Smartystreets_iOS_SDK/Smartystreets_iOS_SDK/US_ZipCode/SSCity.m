#import "SSCity.h"

@implementation SSCity

- (instancetype)initWithData:(NSDictionary*)data {
    if (self = [super init]) {
        _city = [data objectForKey:@"city"];
        _mailableCity = [data objectForKey:@"mailable_city"]; // TODO: what's the default value or should it be nil?
        _stateAbbreviation = [data objectForKey:@"state_abbreviation"];
        _state = [data objectForKey:@"state"];
    }
    return self;
}

@end
