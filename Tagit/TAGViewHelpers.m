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
    return [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"WalkwaySemiBold" size:size]}];
}

+ (void)formatLabel:(UILabel *)label withCopy:(NSString *)copy {
    [label setAttributedText:[self attributeText:copy forFontSize:10.0f]];
    [self sizeLabelToFit:label numberOfLines:1.0f];
}

+ (void)sizeLabelToFit:(UILabel *)label numberOfLines:(CGFloat)lineNumber {
    // 0 is default
    [label setNumberOfLines:lineNumber];
    [label sizeToFit];
}

+ (NSMutableAttributedString *)createIcon:(FAKFontAwesome *)icon withColor:(UIColor *)color {
    NSAttributedString *heartFont = [icon attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0,heartIcon.length)];
    return heartIcon;
}

+ (void)scaleAndSetBackgroundImageNamed:(NSString *)imageName forView:(UIView *)targetView {
    UIImage *image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContextWithOptions(targetView.frame.size, NO, image.scale);
    [image drawInRect:targetView.bounds];
    UIImage* redrawn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [targetView setBackgroundColor:[UIColor colorWithPatternImage:redrawn]];
}

+ (void)formatButton:(UIButton *)button forIcon:(NSMutableAttributedString *)icon withCopy:(NSString *)buttonCopy {
    NSMutableAttributedString *iconCopy =[[NSMutableAttributedString alloc] initWithString:buttonCopy attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];
    [iconCopy appendAttributedString:icon];
    [iconCopy addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,iconCopy.length)];
    [button setAttributedTitle:iconCopy forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setBackgroundColor:kTagitBlack];
    button.layer.cornerRadius = 2.0f;
    button.layer.masksToBounds = YES;
}

+ (UIActivityIndicatorView *)setActivityIndicatorForNavItem:(UINavigationItem *)item {
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [item setTitleView:aiView];
    [aiView startAnimating];
    return aiView;
}

+ (UIImage *)imageForURL:(NSString *)imageURL {
    NSURL *url = [NSURL URLWithString:imageURL];
    NSData *data = [NSData dataWithContentsOfURL:url];
    return [UIImage imageWithData:data];
}

@end