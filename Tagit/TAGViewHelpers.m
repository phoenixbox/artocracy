//
//  TAGViewHelpers.m
//  Tagit
//
//  Created by Shane Rogers on 8/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGViewHelpers.h"

@implementation TAGViewHelpers

+ (NSAttributedString *)attributeText:(NSString *)text forFontSize:(CGFloat)size {
    return [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:size]}];
}

+ (void)sizeLabelToFit:(UILabel *)label numberOfLines:(CGFloat)lineNumber {
    // 0 is default
    [label setNumberOfLines:lineNumber];
    [label sizeToFit];
}

@end
