//
//  TAGSuggestionDetailsSection.h
//  Tagit
//
//  Created by Shane Rogers on 9/6/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGSuggestionDetailsSection : UIView

- (id)initWithFrame:(CGRect)frame withBlock:(void (^)(BOOL selected))actionBlock;

@property (nonatomic, strong)UILabel *canvasTypeTitle;
@property (nonatomic, strong)UILabel *canvasType;
@property (nonatomic, strong)UIButton *favoriteButton;
@property (nonatomic, strong)UILabel *locationTitle;
@property (nonatomic, strong)UILabel *locationAddress;
@property (nonatomic, strong)UILabel *locationCity;
@property (nonatomic, strong)UILabel *locationState;
@property (nonatomic, assign) float labelWidth;

@property (copy)void (^actionBlock)(BOOL);

@end
