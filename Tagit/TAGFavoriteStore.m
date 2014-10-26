//
//  TAGFavoriteStore.m
//  Tagit
//
//  Created by Shane Rogers on 10/16/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGFavoriteStore.h"

// Modules
#import "AFNetworking.h"

// Constants
#import "TAGRoutesConstants.h"

// Data Leyer
#import "TAGAuthStore.h"
#import "TAGSessionStore.h"

@implementation TAGFavoriteStore

+ (TAGFavoriteStore *)sharedStore {
    static TAGFavoriteStore *upvoteStore = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        upvoteStore = [[TAGFavoriteStore alloc] init];
    });
    return upvoteStore;
}

- (void)getFavoriteForPiece:(NSNumber *)pieceId withCompletionBlock:(void (^)(TAGFavorite *favorite, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIFavorited];
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSDictionary *favoritedParams = @{@"tag_id": [pieceId stringValue], @"user_id": [session.id stringValue] };

    [manager GET:requestURL parameters:favoritedParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGFavorite *favorite = [[TAGFavorite alloc] initWithString:rawJSON error:nil];

        if (favorite) {
            block(favorite, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];

}

- (void)createFavoriteForPiece:(NSNumber *)pieceId withCompletionBlock:(void (^)(TAGFavorite *upvote, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIFavoriteCreate];
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSDictionary *upvoteParams = @{@"piece_id": [pieceId stringValue], @"user_id": [session.id stringValue]};

    [manager POST:requestURL parameters:upvoteParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGFavorite *favorite = [[TAGFavorite alloc] initWithString:rawJSON error:nil];

        block(favorite, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)destroyFavorite:(NSNumber *)favoriteId withCompletionBlock:(void (^)(TAGPiece *, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *urlSegment = [[NSString alloc] initWithFormat:@"/%@", favoriteId];
    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIFavoriteDestroy withURLSegment:urlSegment];

    [manager DELETE:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGPiece *piece = [[TAGPiece alloc] initWithString:rawJSON error:nil];

        block(piece, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end
