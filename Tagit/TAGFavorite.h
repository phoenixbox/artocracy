//
//  TAGFavorite.h
//  Tagit
//
//  Created by Shane Rogers on 10/13/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol TAGFavorite @end

@interface TAGFavorite : JSONModel

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *tagId;
@property (nonatomic) NSNumber *userId;

@end