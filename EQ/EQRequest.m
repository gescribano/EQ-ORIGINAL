//
//  EQRequest.m
//  EQ
//
//  Created by Sebastian Borda on 4/30/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQRequest.h"
#import "AFNetworking.h"
#import "NSDictionary+EQ.h"

@implementation EQRequest

- (id)initWithParams:(NSMutableDictionary *)params
 successRequestBlock:(void(^)(NSArray* jsonArray))success
    failRequestBlock:(void(^)(NSError* error))fail
     runInBackground:(BOOL)runInBackground{
    
    
    //Check if we have an object to submit request.
    
    NSMutableURLRequest *url = [[self generateRequestWithParameters:params] mutableCopy];
    
    NSLog(@"POST %@", url);
    
#ifdef TEST_VERSION
    //Adding basic headers for stage server.
    NSString *authStr = [NSString stringWithFormat:@"eq:eq"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    [url setValue:authValue forHTTPHeaderField:@"Authorization"];
#endif
    
    self.urlRequest = url;
    if (success == nil) {
        self.successBlock = ^(NSArray* jsonArray){
            NSLog(@"url: %@ result: %lu", [[url URL] absoluteString], (unsigned long)[jsonArray count]);
        };
        
    } else{
        self.successBlock = ^(NSArray* jsonArray){
            if (runInBackground) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    success(jsonArray);
                });
            } else {
                success(jsonArray);
            }
        };
    }
    
    
    if (fail == nil) {
        self.failBlock = ^(NSError *error){
            NSLog(@"EQRequest fail error:%@ UserInfo:%@",error ,error.userInfo);
        };
    } else {
        self.failBlock = fail;
    }
    
    return self;
}

-(NSURLRequest *)generateRequestWithParameters:(NSMutableDictionary *)params
{
    NSMutableString *queryString = [NSMutableString stringWithFormat:@"%@?action=%@&object=%@&usuario=%@&password=%@",@API_URL,params[@"action"],params[@"object"],params[@"usuario"],params[@"password"]];
        
    BOOL post = [params[@"POST"] boolValue];
    NSURLRequest *request = nil;
    [params removeObjectForKey:@"object"];
    [params removeObjectForKey:@"action"];
    [params removeObjectForKey:@"usuario"];
    [params removeObjectForKey:@"password"];
    
    if (post) {
        NSNumber *identifier = [params objectForKey:@"id"];
        [params removeObjectForKey:@"POST"];
        [params removeObjectForKey:@"id"];
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:queryString]];
        httpClient.parameterEncoding = AFFormURLParameterEncoding;
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{@"atributos":[params toJSON]}];
        if (identifier) {
            [parameters addEntriesFromDictionary:@{@"id":identifier}];
        }
        
        request = [httpClient requestWithMethod:@"POST" path:queryString parameters:parameters];
    } else {
        for (NSString *key in params.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",params[key]];
            [queryString appendFormat:@"&%@=%@",key,value];
        }
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:queryString]];
    }
    
    return request;
}

- (NSString *)description {
    return [[self.urlRequest URL] absoluteString];
}

@end
