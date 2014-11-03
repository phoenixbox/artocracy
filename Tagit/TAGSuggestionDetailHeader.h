//
//  TAGSuggestionDetailHeader.h
//  Tagit
//
//  Created by Shane Rogers on 11/2/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAGSuggestion.h"

@interface TAGSuggestionDetailHeader : UIView

- (void)attributeWithModel:(TAGSuggestion *)model;

@property (nonatomic, strong)TAGSuggestion *suggestion;

@property (strong, nonatomic) IBOutlet UILabel *suggestorEmail;
@property (strong, nonatomic) IBOutlet UIView *suggestorThumnail;
@property (strong, nonatomic) IBOutlet UILabel *upvoteCounter;

@end
