//
//  TAGCollectionControls.h
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGCollectionControls : UIView

@property (nonatomic, strong) UIButton *gridViewButton;
@property (nonatomic, strong) UIButton *listViewButton;
@property (nonatomic, strong) UIButton *suggestionsButton;
@property (nonatomic, strong) UIButton *favoritesButton;
@property (nonatomic, strong) NSArray *callbackNames;

@property (nonatomic) float xSpacing;
@property (nonatomic) float buttonWidth;

@property (copy)void (^actionBlock)(NSString *);

- (id)initWithFrame:(CGRect)frame forActions:(NSArray *)callbackNames withBlock:(void (^)(NSString *action))actionBlock;

@end
