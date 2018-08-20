#import "SSHttpSender.h"

@interface SSHttpSender() {
    __block SSSmartyResponse *myResponse;
}
    
@property (nonatomic) int maxTimeout;
@property (nonatomic) NSDictionary *proxy;

@end

@implementation SSHttpSender

- (instancetype)init {
    if (self = [super init]) {
        _maxTimeout = 10000;
    }
    return self;
}

- (instancetype)initWithMaxTimeout:(int)maxTimeout andProxy:(NSDictionary*)proxy{
    if (self = [[super self] init]) {
        _maxTimeout = maxTimeout;
        _proxy = proxy;
    }
    return self;
}

- (SSSmartyResponse*)sendRequest:(SSSmartyRequest*)request error:(NSError**)error {
    NSMutableURLRequest *httpRequest = [self buildHttpRequest:request];
    [self copyHeaders:request httpRequest:httpRequest];
    
    return [self buildResponse:httpRequest];
}

- (NSMutableURLRequest*)buildHttpRequest:(SSSmartyRequest*)request {
    NSURL *url = [NSURL URLWithString:[request getUrl]];
    
    NSMutableURLRequest *httpRequest = [NSMutableURLRequest requestWithURL:url];;
    if ([request.method isEqualToString:@"GET"]) {
        [httpRequest setHTTPMethod:@"GET"];
    }
    else {
        [httpRequest setHTTPMethod:@"POST"];
        [httpRequest setHTTPBody:request.payload];
    }
    return httpRequest;
}

- (void)copyHeaders:(SSSmartyRequest*)request httpRequest:(NSMutableURLRequest*)httpRequest {
    for (NSString *key in [request.headers allKeys])
        [httpRequest addValue:request.headers[key] forHTTPHeaderField:key];
    
    NSString *version = [[NSBundle bundleForClass:[@"SmartystreetsSDK" class]] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *userAgent = [[@"smartystreets (sdk:ios@" stringByAppendingString:version] stringByAppendingString:@")"];
    
    [httpRequest addValue:userAgent forHTTPHeaderField:@"User-Agent"];
}

- (SSSmartyResponse*)buildResponse:(NSMutableURLRequest*)httpRequest {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.connectionProxyDictionary = _proxy;
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, _maxTimeout * 1000000);
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:httpRequest
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error == nil) {
                int statusCode = (int)[(NSHTTPURLResponse *) response statusCode];
                NSData *payload = data;
                
                //TODO finish this
                NSLog(@"\nMethod: %@", [httpRequest HTTPMethod]);
                NSLog(@"\nRequest body:\n\n%@", [[NSString alloc] initWithData:[httpRequest HTTPBody] encoding:NSUTF8StringEncoding]);
                
                myResponse = [[SSSmartyResponse alloc] initWithStatusCode:statusCode payload:payload];
                dispatch_semaphore_signal(semaphore);
            }
        }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore, timeout);
    
    return myResponse;
}

@end
