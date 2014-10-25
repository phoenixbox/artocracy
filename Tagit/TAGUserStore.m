//
//  TAGUserStore.m
//  Tagit
//
//  Created by Shane Rogers on 10/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGAuthStore.h"
#import "AFNetworking.h"
#import "TAGRoutesConstants.h"
#import "TAGUserStore.h"
#import "TAGSessionStore.h"

@implementation TAGUserStore

+ (TAGUserStore *)sharedStore {
    static TAGUserStore *sessionStore = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        sessionStore = [[TAGUserStore alloc] init];
    });
    return sessionStore;
}

- (void)getContributionCountsWithCompletion:(void (^)(NSDictionary *favoriteCounts, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSString *urlSegment = [[NSString alloc] initWithFormat:@"/%@/contribution_counts", [session.id stringValue]];
    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIUserContributionCounts withURLSegment:urlSegment];

    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *counts = @{ @"suggestions" : [responseObject objectForKey:@"suggestion_count"], @"favorites" : [responseObject objectForKey:@"favorite_count"] };

        block(counts, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end
