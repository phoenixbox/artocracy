//
//  TAGUpvoteStore.h
//  Tagit
//
//  Created by Shane Rogers on 10/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

// Data Layer
#import "TAGUpvote.h"
#import "TAGSuggestion.h"

@interface TAGUpvoteStore : NSObject

+ (TAGUpvoteStore *)sharedStore;

- (void)getUpvoteForSuggestion:(NSNumber *)suggestionId withCompletionBlock:(void (^)(TAGUpvote *upvote, NSError *err))block;

- (void)createUpvoteForSuggestion:(NSNumber *)suggestionId withCompletionBlock:(void (^)(TAGUpvote *upvote, NSError *err))block;

- (void)destroyUpvote:(NSNumber *)upvoteId withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))block;

@end
