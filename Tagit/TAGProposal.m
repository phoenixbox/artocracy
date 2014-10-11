//
//  TAGProposal.m
//  Tagit
//
//  Created by Shane Rogers on 10/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProposal.h"

@implementation TAGProposal

//+(JSONKeyMapper*)keyMapper
//{
//    return [[JSONKeyMapper alloc] initWithDictionary:@{
//                                                       @"id": @"id",
//                                                       @"proposer_id": @"proposerId",
//                                                       @"vote_count": @"voteCount",
//                                                       @"image_url": @"imageUrl"
//                                                       }];
//}

+ (JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
