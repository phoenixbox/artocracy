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
@property (nonatomic) NSNumber *artistId;
@property (nonatomic) NSNumber *favoriteCount;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipCode;
//@property (nonatomic, strong) NSString *country;
//@property (nonatomic, strong) NSString *canvasType;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *artistImageURL;

@end