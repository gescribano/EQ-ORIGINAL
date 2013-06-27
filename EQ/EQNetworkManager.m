//
//  EQNetworkManager.m
//  EQ
//
//  Created by Sebastian Borda on 4/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQNetworkManager.h"
#import "AFNetworking.h"
#import "EQSession.h"

@implementation EQNetworkManager

+ (void)makeRequest:(EQRequest *)request{
    @synchronized (self) {

        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request.urlRequest success:^(NSURLRequest *urlRequest, NSHTTPURLResponse *urlResponse, id JSON) {
            NSArray *jsonArray = nil;
            BOOL error = false;
            NSString *message = nil;
            
            if ([JSON isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dictionary = JSON;
                for (NSString* key in [dictionary allKeys]) {
                    if ([key isEqualToString:@"data"]) {
                        jsonArray = [dictionary objectForKey:key];
                    } else if([key isEqualToString:@"error"]) {
                        error = [[dictionary objectForKey:key] boolValue];
                    } else if([key isEqualToString:@"message"]){
                        message = [dictionary objectForKey:key];
                    }
                }
            } else {
                jsonArray = JSON;
            }
            
            if (!error) {
                request.successBlock(jsonArray);
            } else {
                NSLog(@"Failed: %@ for request %@",message, [[urlRequest URL] absoluteString]);
                request.failBlock([NSError errorWithDomain:@"EQ-Server" code:9999 userInfo:[NSDictionary dictionaryWithObject:message forKey:@"message"]]);
            }
            
        } failure:^(NSURLRequest *urlRequest , NSURLResponse *response , NSError *error , id JSON)
                                             {
                                                 NSLog(@"Failed: %@ for request %@",[error localizedDescription], [[urlRequest URL] absoluteString]);
                                                 request.failBlock(error);
                                             }];
        [operation start];
    }
}

@end
