//
//  TAGPieceStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGPieceChannel.h"

@interface TAGPieceStore : NSObject{
    NSMutableArray *tags;
}

+ (TAGPieceStore *)sharedStore;

- (void)fetchPiecesWithCompletion:(void (^)(TAGPieceChannel *feedChannel, NSError *err))block;

@end
