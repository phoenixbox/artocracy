//
//  TAGProfileHeader.h
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProfileHeaderSummaryViewController.h"

#import <UIKit/UIKit.h>

@interface TAGProfileHeader : UIView

@property (nonatomic, strong) UIView *profile;
@property (nonatomic, strong) UILabel *username;

@property (nonatomic, strong) TAGProfileHeaderSummaryViewController *suggestionsSummary;

@property (nonatomic, strong) UIView *favoriteSummary;

@property (nonatomic) float xSpacing;
@property (nonatomic) float yCoord;

@end
