//
//  TAGPieceStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGPieceChannel.h"

// AmazonS3 video
#import <AWSS3/AWSS3.h>
#import <AWSRuntime/AWSRuntime.h>

@interface TAGPieceStore : NSObject <AmazonServiceRequestDelegate> {
    NSMutableArray *tags;
}

@property (nonatomic, copy) void(^imageUploadedBlock)(NSURL *s3ImageLocation, NSError *);
@property (nonatomic, strong) NSMutableArray *allUserPieces;

+ (TAGPieceStore *)sharedStore;

- (void)addUniquePiece:(TAGPiece *)piece;

- (void)fetchPiecesWithCompletion:(void (^)(TAGPieceChannel *feedChannel, NSError *err))block;

- (void)fetchFavoritesForUser:(NSNumber *)userId WithCompletion:(void (^)(TAGPieceChannel *favoriteChannel, NSError *err))block;

- (void)fetchAssociatedWorkForArtist:(NSNumber *)artistId WithCompletion:(void (^)(TAGPieceChannel *pieceChannel, NSError *err))block;

- (void)savePieceImage:(NSData *)imageData withCompletionBlock:(void (^)(NSURL *s3ImageLocation, NSError *))imageUploadedBlock;

- (void)createPiece:(NSMutableDictionary *)parameters withCompletionBlock:(void (^)(TAGPiece *suggestion, NSError *err))returnToUserProfile;

@end
