//
//  TAGViewHelpers.m
//  Tagit
//
//  Created by Shane Rogers on 8/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGViewHelpers.h"

// Constants
#import "TAGStyleConstants.h"

@implementation TAGViewHelpers

+ (NSAttributedString *)attributeText:(NSString *)text forFontSize:(CGFloat)size {
    return [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:size]}];
}

+ (void)sizeLabelToFit:(UILabel *)label numberOfLines:(CGFloat)lineNumber {
    // 0 is default
    [label setNumberOfLines:lineNumber];
    [label sizeToFit];
}

+ (void)scaleAndSetBackgroundImageNamed:(NSString *)imageName forView:(UIView *)targetView {
    UIImage *image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(targetView.frame.size, NO, image.scale);
    [image drawInRect:targetView.bounds];
    UIImage* redrawn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [targetView setBackgroundColor:[UIColor colorWithPatternImage:redrawn]];
}

+ (void)formatButton:(UIButton *)button forIcon:(FAKFontAwesome *)icon withCopy:(NSString *)buttonCopy {
    NSAttributedString *iconFont = [icon attributedString];
    NSMutableAttributedString *iconCopy =[[NSMutableAttributedString alloc] initWithString:buttonCopy attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];
    [iconCopy appendAttributedString:iconFont];
    [iconCopy addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,iconCopy.length)];
    [button setAttributedTitle:iconCopy forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setBackgroundColor:kTagitBlack];
    button.layer.cornerRadius = 2.0f;
    button.layer.masksToBounds = YES;
}

@end