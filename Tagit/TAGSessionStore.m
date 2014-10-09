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
#import "TAGStyleConstants.h"

@implementation TAGSessionStore

+(JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

+ (TAGSessionStore *)sharedStore {
    static TAGSessionStore *sessionStore = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        sessionStore = [[TAGSessionStore alloc] init];
    });
    return sessionStore;
}

- (void)login:(NSDictionary *)parameters withCompletionBlock:(void (^)(TAGSessionStore *session, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSString *requestURL = [self constructLoginRequest:parameters];

    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TAGSessionStore *sessionStore = [TAGSessionStore sharedStore];
        sessionStore.id = [responseObject objectForKey:@"id"];
        sessionStore.email = [responseObject objectForKey:@"email"];
        sessionStore.authenticationToken = [responseObject objectForKey:@"authentication_token"];
        sessionStore.profileImageUrl = [responseObject objectForKey:@"profile_image_url"];

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
