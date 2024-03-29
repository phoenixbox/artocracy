//
//  TAGSuggestionDetailsSection.h
//  Tagit
//
//  Created by Shane Rogers on 9/6/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Components
#import "TAGSpinner.h"

// Data Layer
#import "TAGSuggestion.h"
#import "TAGUpvote.h"

extern NSString *const kSetSuggestionHeaderInfoNotification;
extern NSString *const kSetHeaderInfoUpvoteCount;

@interface TAGSuggestionDetailsSection : UIView

- (void)attributeWithModel:(TAGSuggestion *)model;

@property (nonatomic, strong)TAGSuggestion *suggestion;
@property (nonatomic, strong)TAGUpvote *upvote;
@property (nonatomic, strong)TAGSpinner *spinner;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *canvasTypeLabel;

@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *canvasType;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
- (IBAction)upvoteToggled:(UIButton *)sender;

@end