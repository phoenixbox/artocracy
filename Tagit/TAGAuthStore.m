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

+ (NSString *)authenticateRequest:(NSString *)requestURL {
    
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSString *email = session.email;
    NSString *token = session.authenticationToken;

    requestURL = [requestURL stringByAppendingString:(@"?email=")];
    requestURL = [requestURL stringByAppendingString:email];
    requestURL = [requestURL stringByAppendingString:(@"&authentication_token=")];
    requestURL = [requestURL stringByAppendingString:token];

    return requestURL;
}

+ (NSString *)authenticateRequest:(NSString *)requestURL withURLSegment:(NSString *)urlSegment {
    if (urlSegment) {
        requestURL = [requestURL stringByAppendingString:urlSegment];
    }
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSString *email = session.email;
    NSString *token = session.authenticationToken;

    requestURL = [requestURL stringByAppendingString:(@"?email=")];
    requestURL = [requestURL stringByAppendingString:email];
    requestURL = [requestURL stringByAppendingString:(@"&authentication_token=")];
    requestURL = [requestURL stringByAppendingString:token];

    return requestURL;

}

@end
