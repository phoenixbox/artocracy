//
//  TAGUpvote.m
//  Tagit
//
//  Created by Shane Rogers on 10/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGUpvote.h"

@implementation TAGUpvote

+ (JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end