//
//  TAGUpvoteStore.m
//  Tagit
//
//  Created by Shane Rogers on 10/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGUpvoteStore.h"

// Modules
#import "AFNetworking.h"

// Constants
#import "TAGRoutesConstants.h"

// Data Layer
#import "TAGAuthStore.h"
#import "TAGSessionStore.h"
#import "TAGUpvote.h"

@implementation TAGUpvoteStore

+ (TAGUpvoteStore *)sharedStore {
    static TAGUpvoteStore *upvoteStore = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        upvoteStore = [[TAGUpvoteStore alloc] init];
    });
    return upvoteStore;
}

- (void)getUpvoteForSuggestion:(NSNumber *)suggestionId withCompletionBlock:(void (^)(TAGUpvote *upvote, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIUpvoted];
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSDictionary *upvotedParams = @{@"suggestion_id": [suggestionId stringValue], @"user_id": [session.id stringValue] };

    [manager GET:requestURL parameters:upvotedParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGUpvote *upvote = [[TAGUpvote alloc] initWithString:rawJSON error:nil];

        if (upvote) {
            block(upvote, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)createUpvoteForSuggestion:(NSNumber *)suggestionId withCompletionBlock:(void (^)(TAGUpvote *upvote, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIUpvoteCreate];
    NSDictionary *upvoteParams = @{@"suggestion_id": [suggestionId stringValue]};

    [manager POST:requestURL parameters:upvoteParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGUpvote *upvote = [[TAGUpvote alloc] initWithString:rawJSON error:nil];

        block(upvote, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)destroyUpvote:(NSNumber *)upvoteId withCompletionBlock:(void (^)(BOOL upvoted, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSString *urlSegment = [[NSString alloc] initWithFormat:@"/%@", upvoteId];
    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIUpvoteDestroy withURLSegment:urlSegment];

    [manager DELETE:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        BOOL deleted = [responseObject objectForKey:@"success"];

        block(deleted, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}


@end
