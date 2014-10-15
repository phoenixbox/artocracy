//
//  TAGPieceStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGPieceStore.h"
#import "TAGAuthStore.h"

#import "TAGRoutesConstants.h"
#import "AFNetworking.h"

@implementation TAGPieceStore

+ (TAGPieceStore *)sharedStore {
    static TAGPieceStore *tagStore = nil;

    if (!tagStore) {
        tagStore = [[TAGPieceStore alloc]init];
    };
    return tagStore;
}

- (void)fetchPiecesWithCompletion:(void (^)(TAGPieceChannel *tagChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPITagsIndex];

    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TAGPieceChannel *pieceChannel = [[TAGPieceChannel alloc] initWithData:responseObject error:nil];

        block(pieceChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)fetchFavoritesForUser:(NSNumber *)userId WithCompletion:(void (^)(TAGFavoriteChannel *feedChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPITagsFavorites];
    NSDictionary *favoritesParams = @{@"user_id": userId};

    [manager GET:requestURL parameters:favoritesParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGFavoriteChannel *favoriteChannel = [[TAGFavoriteChannel alloc] initWithString:rawJSON error:nil];

        block(favoriteChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end