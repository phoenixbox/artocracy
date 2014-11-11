//
//  TAGFeedItem.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol TAGPiece @end

@interface TAGPiece : JSONModel

@property (nonatomic) NSNumber *id;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *canvasType;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic) NSNumber *favoriteCount;
@property (nonatomic) NSNumber<Optional> *artistId;
@property (nonatomic, strong) NSString<Optional> *artistName;
@property (nonatomic, strong) NSString<Optional> *artistImageURL;

@end