//
//  TAGFeedItem.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGPiece.h"

@implementation TAGPiece

+(JSONKeyMapper*)keyMapper {
        return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                           @"id": @"id",
                                                           @"title": @"title",
                                                           @"city": @"city",
                                                           @"image_url": @"imageUrl",
                                                           @"state": @"state",
                                                           @"zip_code": @"zipCode",
                                                           @"country": @"country",
                                                           @"canvas_type": @"canvasType",
                                                           @"latitude": @"latitude",
                                                           @"longitude": @"longitude",
                                                           @"favorite_count": @"favoriteCount",
                                                           @"artist.id": @"artistId",
                                                           @"artist.name": @"artistName",
                                                           @"artist.profile_image_url": @"artistImageURL"
                                                           }];
}

@end
