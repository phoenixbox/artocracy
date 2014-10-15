//
//  TAGFavoriteChannel.h
//  Tagit
//
//  Created by Shane Rogers on 10/13/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONModel.h"
// Data Layer
#import "TAGFavorite.h"

@interface TAGFavoriteChannel : JSONModel

@property (strong, nonatomic) NSMutableArray<TAGFavorite> *favorites;

@end