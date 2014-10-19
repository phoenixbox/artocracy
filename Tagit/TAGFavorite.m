//
//  TAGFavorite.m
//  Tagit
//
//  Created by Shane Rogers on 10/13/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGFavorite.h"

@implementation TAGFavorite

+ (JSONKeyMapper*)keyMapper {
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end