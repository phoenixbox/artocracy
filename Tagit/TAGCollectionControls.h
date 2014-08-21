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

@property (nonatomic) float xSpacing;
@property (nonatomic) float buttonWidth;

@end
