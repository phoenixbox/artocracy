//
//  TAGFavoriteStore.h
//  Tagit
//
//  Created by Shane Rogers on 10/16/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//
#import <Foundation/Foundation.h>

// Data Layer
#import "TAGFavorite.h"
#import "TAGPiece.h"

@interface TAGFavoriteStore : NSObject

+ (TAGFavoriteStore *)sharedStore;

- (void)getFavoriteForPiece:(NSNumber *)pieceId withCompletionBlock:(void (^)(TAGFavorite *favorite, NSError *err))block;

- (void)createFavoriteForPiece:(NSNumber *)pieceId withCompletionBlock:(void (^)(TAGFavorite *upvote, NSError *err))block;

- (void)destroyFavorite:(NSNumber *)pieceId withCompletionBlock:(void (^)(TAGPiece *piece, NSError *err))block;

@end