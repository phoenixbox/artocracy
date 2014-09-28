//
//  TAGPieceStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGPieceStore.h"
#import "TAGAuthStore.h"
#import "TAGPieceChannel.h"

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
        NSLog(@"Error: %@", error);
    }];
}


@end
