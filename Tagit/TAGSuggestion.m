//
//  TAGSubmission.m
//  Tagit
//
//  Created by Shane Rogers on 8/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestion.h"

@implementation TAGSuggestion

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"id",
                                                       @"address": @"address",
                                                       @"city": @"city",
                                                       @"image_url": @"imageUrl",
                                                       @"state": @"state",
                                                       @"zip_code": @"zipCode",
                                                       @"country": @"country",
                                                       @"canvas_type": @"canvasType",
                                                       @"latitude": @"latitude",
                                                       @"longitude": @"longitude",
                                                       @"proposal_count": @"proposalCount",
                                                       @"upvote_count": @"upvoteCount",
                                                       @"suggestor.id": @"suggestorId",
                                                       @"suggestor.email": @"suggestorEmail",
                                                       @"suggestor.profile_image_url": @"suggestorImageURL"
                                                       }];
}

@end
