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
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
