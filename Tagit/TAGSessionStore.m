//
//  TAGSessionStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSessionStore.h"
#import "AFNetworking.h"
#import "TAGRoutesConstants.h"

@implementation TAGSessionStore

+ (TAGSessionStore *)sharedStore {
    static TAGSessionStore *sessionStore = nil;

    if (!sessionStore) {
        sessionStore = [[TAGSessionStore alloc]init];
    };
    return sessionStore;
}

- (void)login:(NSDictionary *)parameters withCompletionBlock:(void (^)(TAGSessionStore *session, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    NSString *requestURL = [self constructLoginRequest:parameters];

    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TAGSessionStore *sessionStore = [TAGSessionStore sharedStore];
        NSDictionary *responseDict = responseObject;
        sessionStore.email = [responseDict objectForKey:@"email"];
        sessionStore.authentication_token = [responseDict objectForKey:@"authentication_token"];

        block(sessionStore, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (NSString *)constructLoginRequest:(NSDictionary *)parameters {
    NSString *email = [parameters objectForKey:@"email"];
    NSString *password = [parameters objectForKey:@"password"];

    NSString *requestURL = [NSString stringWithFormat:kAPIUserLogin];
    requestURL = [requestURL stringByAppendingString:(@"?email=")];
    requestURL = [requestURL stringByAppendingString:email];
    requestURL = [requestURL stringByAppendingString:(@"&password=")];
    requestURL = [requestURL stringByAppendingString:password];
    return requestURL;
}

@end
