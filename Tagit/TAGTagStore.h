//
//  TAGFeedStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGTagChannel.h"

@interface TAGTagStore : NSObject{
    NSMutableArray *tags;
}

+ (TAGTagStore *)sharedStore;

- (void)fetchPiecesWithCompletion:(void (^)(TAGTagChannel *feedChannel, NSError *err))block;

@end
