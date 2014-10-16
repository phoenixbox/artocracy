//
//  TAGPieceStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGPieceChannel.h"
#import "TAGFavoriteChannel.h"

@interface TAGPieceStore : JSONModel {
    NSMutableArray *tags;
}

+ (TAGPieceStore *)sharedStore;

- (void)fetchPiecesWithCompletion:(void (^)(TAGPieceChannel *feedChannel, NSError *err))block;

- (void)fetchFavoritesForUser:(NSNumber *)userId WithCompletion:(void (^)(TAGFavoriteChannel *favoriteChannel, NSError *err))block;

- (void)fetchAssociatedWorkForArtist:(NSNumber *)artistId WithCompletion:(void (^)(TAGPieceChannel *pieceChannel, NSError *err))block;

@end
