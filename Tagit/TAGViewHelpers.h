//
//  TAGViewHelpers.h
//  Tagit
//
//  Created by Shane Rogers on 8/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

// Libs
#import "FontAwesomeKit/FAKFontAwesome.h"

@interface TAGViewHelpers : NSObject

+ (NSAttributedString *)attributeText:(NSString *)text forFontSize:(CGFloat)size;

+ (void)formatLabel:(UILabel *)label withCopy:(NSString *)copy;

+ (void)sizeLabelToFit:(UILabel *)label numberOfLines:(CGFloat)lineNumber;

+ (NSMutableAttributedString *)createIcon:(FAKFontAwesome *)icon withColor:(UIColor *)color;

+ (void)scaleAndSetBackgroundImageNamed:(NSString *)imageName forView:(UIView *)targetView;

+ (void)scaleAndSetRemoteBackgroundImage:(NSString *)remoteURL forView:(UIView *)targetView;

+ (void)formatButton:(UIButton *)button forIcon:(NSMutableAttributedString *)icon withCopy:(NSString *)buttonCopy withColor:(UIColor *)color;

+ (UIActivityIndicatorView *)setActivityIndicatorForNavItem:(UINavigationItem *)item;

+ (UIImage *)imageForURL:(NSString *)imageURL;

+ (void)rotate90Clockwise:(UIView *)object;

+ (NSAttributedString *)counterString:(NSString *)count;

+ (void)updateCount:(NSUInteger)number forLabel:(UILabel *)label;

+ (UILabel *)emptyTableMessage:(NSString *)message forView:(UIView *)view;

+ (void)setButtonState:(BOOL)state forButton:(UIButton *)button withBackgroundColor:(UIColor *)color andCopy:(NSString *)copy;

+ (void)roundImageLayer:(CALayer *)layer withFrame:(CGRect)frame;

@end
