//
//  TAGFavorite.m
//  Tagit
//
//  Created by Shane Rogers on 10/13/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGFavorite.h"

@implementation TAGFavorite

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"id",
                                                       @"artist_id": @"artistId",
                                                       @"favorite_count": @"favoriteCount",
                                                       @"city": @"city",
                                                       @"image_url": @"imageUrl",
                                                       @"state": @"state",
                                                       @"zip_code": @"zipCode",
//                                                       @"country": @"country", // TODO: Add the country
//                                                       @"canvas_type": @"canvasType", // TODO Add the canvas type
                                                       @"latitude": @"latitude",
                                                       @"longitude": @"longitude",
                                                       @"artist.name": @"artistName",
                                                       @"artist.profile_image_url": @"artistImageURL"
                                                       }];
}

@end