//
//  TAGAuthStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGAuthStore.h"
#import "TAGSessionStore.h"

@implementation TAGAuthStore

+ (NSString *)authenticateRequest:(NSString *)requestURL withRouteParams:(NSString *)routeParams optionalParams:(NSString *)optionalParams {
    
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSString *email = session.email;
    NSString *token = session.authentication_token;

//    if (routeParams) {
//        requestURL = [requestURL stringByAppendingFormat:@"/%@", optionalParams];
//    };

    requestURL = [requestURL stringByAppendingString:(@"?email=")];
    requestURL = [requestURL stringByAppendingString:email];
    requestURL = [requestURL stringByAppendingString:(@"&authentication_token=")];
    requestURL = [requestURL stringByAppendingString:token];

//    if (optionalParams) {
//        requestURL = [requestURL stringByAppendingString: optionalParams];
//    };

    return requestURL;
}

@end
