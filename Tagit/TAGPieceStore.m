//
//  TAGPieceStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGPieceStore.h"
#import "TAGAuthStore.h"

// Data Layer
#import "TAGAuthStore.h"
#import "TAGSessionStore.h"

// Constants
#import "TAGRoutesConstants.h"

// Libs
#import "AFNetworking.h"

// Helpers
#import "TAGS3Configuration.h"

@implementation TAGPieceStore

+ (TAGPieceStore *)sharedStore {
    static TAGPieceStore *tagStore = nil;

    if (!tagStore) {
        tagStore = [[TAGPieceStore alloc]init];
    };
    return tagStore;
}

- (void)addUniquePiece:(TAGPiece *)piece {
    if(!self.allUserPieces){
        self.allUserPieces = [NSMutableArray new];
    }

    if ([self.allUserPieces containsObject:piece]) {
        [self.allUserPieces addObject:piece];
    }
}

- (void)fetchFavoritesForUser:(NSNumber *)userId WithCompletion:(void (^)(TAGPieceChannel *favoriteChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlSegment = [[NSString alloc] initWithFormat:@"/%@/favorites", userId];
    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIUserFavorites withURLSegment:urlSegment];

    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIPiecesIndex];

    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGPieceChannel *pieceChannel = [[TAGPieceChannel alloc] initWithString:rawJSON error:nil];

        block(pieceChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)fetchAssociatedWorkForArtist:(NSNumber *)artistId WithCompletion:(void (^)(TAGPieceChannel *pieceChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    // Todo: Update the data model to have an artist
    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIPiecesArtistWork];
    NSDictionary *artist_params = @{@"artist_id": artistId};

    [manager GET:requestURL parameters:artist_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGPieceChannel *assocWorkChannel = [[TAGPieceChannel alloc] initWithString:rawJSON error:nil];

        block(assocWorkChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (void)savePieceImage:(NSData *)imageData withCompletionBlock:(void (^)(NSURL *s3ImageLocation, NSError *))imageUploadedBlock {
    self.imageUploadedBlock = imageUploadedBlock;

    // RESTART: Compose 23 configuration and use across the suggestion and the pieces
    S3TransferManager *tm = [TAGS3Configuration createTransferManager];
    tm.delegate = self;

    S3PutObjectRequest *por = [TAGS3Configuration createPutObjectRequestWithImageData:imageData];
    por.delegate = self;

    [tm upload:por];
}

- (void)createPiece:(NSMutableDictionary *)parameters withCompletionBlock:(void (^)(TAGPiece *suggestion, NSError *err))returnToUserProfile {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPIPiecesCreate];

    TAGSessionStore *session = [TAGSessionStore sharedStore];

    NSDictionary *pieceParams = @{@"piece": parameters, @"user_id": [session.id stringValue]};

    [manager POST:requestURL parameters:pieceParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGPiece *piece = [[TAGPiece alloc] initWithString:rawJSON error:nil];

        returnToUserProfile(piece, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma AmazonServiceRequest Protocol Methods

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData called");
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;
{
    NSLog(@"didSendData called: %lld - %lld / %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    self.imageUploadedBlock(request.url, nil);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    self.imageUploadedBlock(request.url,error);
    NSLog(@"didFailWithError called: %@", error);
}


@end