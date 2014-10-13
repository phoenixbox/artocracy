//
//  TAGSuggestionDetailsSection.h
//  Tagit
//
//  Created by Shane Rogers on 9/6/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Data Layer
#import "TAGSuggestion.h"
#import "TAGUpvote.h"

@interface TAGSuggestionDetailsSection : UIView

- (id)initWithFrame:(CGRect)frame forSuggestion:(TAGSuggestion *)suggestion;

@property (nonatomic, strong)TAGSuggestion *suggestion;
@property (nonatomic, strong)TAGUpvote *upvote;
@property (nonatomic, strong)UILabel *canvasTypeTitle;
@property (nonatomic, strong)UILabel *canvasType;
@property (nonatomic, strong)UIButton *actionButton;
@property (nonatomic, strong)UILabel *locationTitle;
@property (nonatomic, strong)UILabel *locationAddress;
@property (nonatomic, strong)UILabel *locationCity;
@property (nonatomic, strong)UILabel *locationState;
@property (nonatomic, assign) float labelWidth;

@end