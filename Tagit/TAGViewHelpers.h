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

+ (void)formatButton:(UIButton *)button forIcon:(NSMutableAttributedString *)icon withCopy:(NSString *)buttonCopy;

+ (UIActivityIndicatorView *)setActivityIndicatorForNavItem:(UINavigationItem *)item;

@end
