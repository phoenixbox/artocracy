//
//  TAGUserStore.h
//  Tagit
//
//  Created by Shane Rogers on 10/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGUserStore : NSObject

+ (TAGUserStore *)sharedStore;

- (void)getContributionCountsWithCompletion:(void (^)(NSDictionary *favoriteCounts, NSError *err))block;

@end
