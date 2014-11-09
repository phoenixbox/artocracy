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

// Note: if there are UI abnormalities - possible conflicts with original handrolling
// Size label to fit and setNumberOfLines should be taken care of in the IB

+ (NSAttributedString *)attributeText:(NSString *)text forFontSize:(CGFloat)size {
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"WalkwaySemiBold" size:size]}];
}

+ (void)formatLabel:(UILabel *)label withCopy:(NSString *)copy {
    [label setAttributedText:[self attributeText:copy forFontSize:10.0f]];
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

+ (void)scaleAndSetRemoteBackgroundImage:(NSString *)remoteURL forView:(UIView *)targetView {
    UIImage *image = [TAGViewHelpers imageForURL:remoteURL];
    UIGraphicsBeginImageContextWithOptions(targetView.frame.size, NO, image.scale);
    [image drawInRect:targetView.bounds];
    UIImage *redrawn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [targetView setBackgroundColor:[UIColor colorWithPatternImage:redrawn]];
}

+ (void)formatButton:(UIButton *)button forIcon:(NSMutableAttributedString *)icon withCopy:(NSString *)buttonCopy withColor:(UIColor *)color {
    NSMutableAttributedString *iconCopy =[[NSMutableAttributedString alloc] initWithString:buttonCopy attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];
    if (icon) {
        [iconCopy appendAttributedString:icon];
    }
    [iconCopy addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,iconCopy.length)];
    [button setAttributedTitle:iconCopy forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setBackgroundColor:color];
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

+ (void)rotate90Clockwise:(UIView *)object {
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    [object setTransform:rotate];
}

+ (NSAttributedString *)counterString:(NSString *)count withFontSize:(CGFloat)size {
    if (!count) {
        count = @"0";
    }

    return [TAGViewHelpers attributeText:count forFontSize:size];
}

+ (void)updateCount:(NSUInteger)number forLabel:(UILabel *)label {
    NSString *count = [NSString stringWithFormat:@"%tu", number];
    NSAttributedString *proposalCount = [TAGViewHelpers attributeText:count forFontSize:12.0f];
    [label setAttributedText:proposalCount];
}

+ (UILabel *)emptyTableMessage:(NSString *)message forView:(UIView *)view {
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height)];
    [TAGViewHelpers formatLabel:messageLabel withCopy:message];
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel sizeToFit];

    [TAGViewHelpers rotate90Clockwise:messageLabel];

    return messageLabel;
}

+ (void)setButtonState:(BOOL)state forButton:(UIButton *)button withBackgroundColor:(UIColor *)color andCopy:(NSString *)copy {
    button.selected = state;
    [TAGViewHelpers formatButton:button forIcon:nil withCopy:copy withColor:color];
}

+ (void)roundImageLayer:(CALayer *)layer withFrame:(CGRect)frame {
    layer.cornerRadius = frame.size.width/2;
    layer.masksToBounds = YES;
}


// REAFACTOR: Cant get case statement to work above

+ (NSMutableAttributedString *)upvoteCounterStringWithCopy:(NSString *)copy andFontSize:(CGFloat)fontSize {
    FAKFontAwesome *heart = [FAKFontAwesome thumbsUpIconWithSize:fontSize];
    NSAttributedString *heartFont = [heart attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];

    NSAttributedString *favoriteCount = [TAGViewHelpers counterString:copy withFontSize:fontSize];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0,heartIcon.length)];
    [heartIcon appendAttributedString:favoriteCount];
    [heartIcon insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];

    return heartIcon;
}

+ (NSMutableAttributedString *)heartCounterStringWithCopy:(NSString *)copy andFontSize:(CGFloat)fontSize {
    FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:fontSize];
    NSAttributedString *heartFont = [heart attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];

    NSAttributedString *favoriteCount = [TAGViewHelpers counterString:copy withFontSize:fontSize];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,heartIcon.length)];
    [heartIcon appendAttributedString:favoriteCount];
    [heartIcon insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];

    return heartIcon;
}

/// Invalid FAK Case statement
+ (void)iconCounter:(NSString *)iconType withCopy:(NSString *)copy andFontSize:(CGFloat)fontSize {

    void (^selectedCase)() = @{
                               @"upvote": ^{
                                   FAKFontAwesome *icon = [FAKFontAwesome thumbsUpIconWithSize:fontSize];
                                   return [self createIcon:icon withCopy:copy andFontSize:fontSize];
                               },
                               @"heart": ^{
                                   FAKFontAwesome *icon = [FAKFontAwesome heartIconWithSize:fontSize];
                                   return  [self createIcon:icon withCopy:copy andFontSize:fontSize];
                               }
                               }[iconType];

    if (selectedCase != nil) {
        selectedCase();
    }
}

+ (NSMutableAttributedString *)createIcon:(FAKFontAwesome *)icon withCopy:(NSString *)copy andFontSize:(CGFloat)fontSize {
    NSAttributedString *heartFont = [icon attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];

    NSAttributedString *favoriteCount = [TAGViewHelpers counterString:copy withFontSize:fontSize];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,heartIcon.length)];
    [heartIcon appendAttributedString:favoriteCount];
    [heartIcon insertAttributedString:[[NSAttributedString alloc] initWithString:@" "] atIndex:1];
    
    return heartIcon;
}

@end