#import "SSJsonSerializer.h"

@implementation SSJsonSerializer

- (NSMutableData*)serialize:(NSObject*)obj {
    if (!obj)
        return nil;
    
    NSMutableDictionary *jsonData = obj;

//    NSArray<NSString*>* arr = @[@"str"];
//    
//    NSString* string = [arr objectAtIndex:0];
//    NSNumber* number = [arr objectAtIndex:0];

    NSString *deleteThisString = @"delete";
    
    return nil; //TODO: implement
}

- (id)deserialize:(NSMutableData *)payload withClassType:(Class)type error:(NSError**)error {
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:payload options:NSJSONReadingMutableContainers error:error];
    return json; //TODO: implement
}

@end
