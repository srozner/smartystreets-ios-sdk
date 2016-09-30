#import "SSZipCodeClient.h"

@interface SSZipCodeClient()

@property (readonly, nonatomic) NSString *urlPrefix;
@property (readonly, nonatomic) id<SSSender> sender;
@property (readonly, nonatomic) id<SSSerializer> serializer;

@end

@implementation SSZipCodeClient

- (instancetype)initWithUrlPrefix:(NSString*)urlPrefix withSender:(id<SSSender>)sender withSerializer:(id<SSSerializer>)serializer {
    if (self = [super init]) {
        _urlPrefix = urlPrefix;
        _sender = sender;
        _serializer = serializer;
    }
    return self;
}

- (void)sendLookup:(SSZipCodeLookup*)lookup error:(NSError**)error {
    SSZipCodeBatch *batch = [[SSZipCodeBatch alloc] init];
    [batch add:lookup error:error];
    [self sendBatch:batch error:error];
}

- (void)sendBatch:(SSZipCodeBatch*)batch error:(NSError**)error {
    SSRequest *request = [[SSRequest alloc] initWithUrlPrefix:self.urlPrefix];
    
    if ([batch count] == 0)
        return;
    
    if ([batch count] == 1)
        [self populateQueryString:[batch getLookupAtIndex:0] withRequest:request];
    else
        [request setPayload:[self.serializer serialize:batch.allLookups]];
        
    SSResponse *response = [self.sender sendRequest:request withError:error];
    
    NSArray *resultsDict = [self.serializer deserialize:response.payload withClassType:[NSArray<SSResult*> class] error:error];
    
    if (resultsDict == nil)
        resultsDict = [NSArray<SSResult*> new];

    [self assignResultsToLookups:batch result:resultsDict];
}

- (void)populateQueryString:(SSZipCodeLookup*)lookup withRequest:(SSRequest*)request {
    [request setValue:lookup.inputId forHTTPParameterField:@"input_id"];
    [request setValue:lookup.city forHTTPParameterField:@"city"];
    [request setValue:lookup.state forHTTPParameterField:@"state"];
    [request setValue:lookup.zipcode forHTTPParameterField:@"zipcode"];
}

- (void)assignResultsToLookups:(SSZipCodeBatch*)batch result:(NSArray*)resultsDict {
//    for (SSResult *r in results)
//        SSResult *result = 
//        
//        [[batch getLookupAtIndex:i] setResult:[results objectAtIndex:i]];
}

@end
