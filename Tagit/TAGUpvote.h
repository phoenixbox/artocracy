//
//  TAGUpvote.h
//  Tagit
//
//  Created by Shane Rogers on 10/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol TAGUpvote @end

@interface TAGUpvote : JSONModel

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *suggestionId;
@property (nonatomic) NSNumber *userId;
@property (nonatomic) NSNumber *count;

@end