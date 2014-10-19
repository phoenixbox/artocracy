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

- (void)fetchFavoritesForUser:(NSNumber *)userId WithCompletion:(void (^)(TAGPieceChannel *favoriteChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPITagFavorites];
    NSDictionary *favoritesParams = @{@"user_id": userId};

    [manager GET:requestURL parameters:favoritesParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGPieceChannel *favoriteChannel = [[TAGPieceChannel alloc] initWithString:rawJSON error:nil];

        block(favoriteChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
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

- (void)fetchAssociatedWorkForArtist:(NSNumber *)artistId WithCompletion:(void (^)(TAGPieceChannel *pieceChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPITagsArtistWork];
    NSDictionary *assocWorkParams = @{@"artist_id": artistId};

    [manager GET:requestURL parameters:assocWorkParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGPieceChannel *assocWorkChannel = [[TAGPieceChannel alloc] initWithString:rawJSON error:nil];

        block(assocWorkChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

@end