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
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *requestURL = [self constructLoginRequest:parameters];

    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //Will this overwrite the session data?
        TAGSessionStore *sessionStore = [[TAGSessionStore alloc] initWithString:rawJSON error:nil];

        block(sessionStore, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
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
