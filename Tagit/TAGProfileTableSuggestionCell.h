//
//  TAGProfileTableViewCell.h
//  Tagit
//
//  Created by Shane Rogers on 8/24/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Data Layer
#import "TAGSuggestion.h"

// Pods
#import "URBMediaFocusViewController.h"

@interface TAGProfileTableSuggestionCell : UITableViewCell

@property (nonatomic, strong) TAGSuggestion *suggestion;

@property (nonatomic, strong) UIView *suggestionImage;

@property (nonatomic, strong) UILabel *suggesterLabel;
@property (nonatomic, strong) UILabel *suggestername;

@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *locationName;

@property (nonatomic, strong) UILabel *canvasTypeLabel;
@property (nonatomic, strong) UILabel *canvasTypeName;

@property (nonatomic, strong) UIView *visualSep;

@property (nonatomic, strong) UIView *upvotesIcon;
@property (nonatomic, strong) UILabel *upvotesCounter;
@property (nonatomic, strong) UILabel *upvotesLabel;

@property (nonatomic, strong) UIView *piecesIcon;
@property (nonatomic, strong) UILabel *piecesCounter;
@property (nonatomic, strong) UILabel *piecesLabel;

@property (nonatomic, assign) float cellHeight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forModel:(TAGSuggestion *)suggestion;

@end
