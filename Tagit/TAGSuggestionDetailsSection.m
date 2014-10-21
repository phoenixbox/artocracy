//
//  TAGSuggestionDetailsSection.m
//  Tagit
//
//  Created by Shane Rogers on 9/6/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionDetailsSection.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGCopyConstants.h"

// Components
#import "TAGErrorAlert.h"

// Helpers
#import "TAGViewHelpers.h"

// Data Layer
#import "TAGSuggestionStore.h"
#import "TAGSessionStore.h"
#import "TAGUpvoteStore.h"
#import "TAGUpvote.h"

@implementation TAGSuggestionDetailsSection

- (id)initWithFrame:(CGRect)frame forSuggestion:(TAGSuggestion *)suggestion {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.labelWidth = 149.0f;
        self.suggestion = suggestion;

        [self renderCanvasInfo];

        if ([self shouldRenderUpvoteButton]) {
            [self renderUpvoteButton];
        }

        [self renderLocationInfo];
    }
    return self;
}

- (BOOL)shouldRenderUpvoteButton {
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    return ![self.suggestion.suggestorId isEqualToNumber:session.id];
}

- (void)renderCanvasInfo {
    float xCoord = self.frame.origin.x + kSmallPadding;

    self.canvasTypeTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                    kSmallPadding,
                                                                    149.0f,
                                                                    20.0f)];
    NSAttributedString *canvasTitle =[TAGViewHelpers attributeText:@"Canvas Type" forFontSize:12.0f];
    [self.canvasTypeTitle setAttributedText:canvasTitle];
    [TAGViewHelpers sizeLabelToFit:self.canvasTypeTitle numberOfLines:0];

    self.canvasType = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                CGRectGetMaxY(self.canvasTypeTitle.frame) + kSmallPadding,
                                                                149.0f,
                                                                20.0f)];

    NSAttributedString *canvasType =[TAGViewHelpers attributeText:self.suggestion.canvasType forFontSize:10.0f];
    [self.canvasType setAttributedText:canvasType];
    [TAGViewHelpers sizeLabelToFit:self.canvasType numberOfLines:0];

    [self addSubview:self.canvasTypeTitle];
    [self addSubview:self.canvasType];
}

- (void)renderUpvoteButton {
    [self buildUpvoteButton];

    [self getUpvoteState];
}

- (void)buildUpvoteButton {
    float yCoord = self.canvasTypeTitle.frame.origin.y + (((CGRectGetMaxY(self.canvasType.frame) - self.canvasTypeTitle.frame.origin.y)/2));
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                   0.0f,
                                                                   40.0f,
                                                                   40.0f)];
    CGPoint buttonCenter = CGPointMake(self.frame.size.width/2, yCoord);
    [self.actionButton setCenter:buttonCenter];
    [self.actionButton addTarget:self action:@selector(upvoteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

    [TAGViewHelpers roundImageLayer:self.actionButton.layer withFrame:self.actionButton.frame];

    [self.actionButton setBackgroundImage:[UIImage imageNamed:@"upvoteUnselected.png"] forState:UIControlStateNormal];
    [self.actionButton setBackgroundImage:[UIImage imageNamed:@"upvoteSelected.png"] forState:UIControlStateSelected];
}

- (void)getUpvoteState {
    void(^completionBlock)(TAGUpvote *upvote, NSError *err)=^(TAGUpvote *upvote, NSError *err) {
        if(!err){
            self.upvote = upvote;
            self.actionButton.selected = YES;
        } else {
            self.actionButton.selected = NO;
        }
        [self addSubview:self.actionButton];
    };

    [[TAGUpvoteStore sharedStore] getUpvoteForSuggestion:self.suggestion.id withCompletionBlock:completionBlock];
}

- (void)upvoteButtonTapped:(UIButton *)button {
    if (!button.selected){
        [self upvoteSuggestion:button];
    } else {
        [self removeSuggestionUpvote:button];
    }
}

- (void)upvoteSuggestion:(UIButton *)button {
    void(^completionBlock)(TAGUpvote *upvote, NSError *err)=^(TAGUpvote *upvote, NSError *err) {
        if(!err){
            self.upvote = upvote;
            self.actionButton.selected = YES;
        } else {
            [TAGErrorAlert render:err];
        }
    };

    [[TAGUpvoteStore sharedStore] createUpvoteForSuggestion:self.suggestion.id withCompletionBlock:completionBlock];
}

- (void)removeSuggestionUpvote:(UIButton *)button {
    void(^completionBlock)(BOOL upvoted, NSError *err)=^(BOOL upvoted, NSError *err){
        if(!err){
            self.upvote = nil;
            self.actionButton.selected = NO;
        } else {
            [TAGErrorAlert render:err];
        }
    };

    [[TAGUpvoteStore sharedStore] destroyUpvote:self.upvote.id withCompletionBlock:completionBlock];
}

- (void)renderLocationInfo {
    float xCoord = CGRectGetMaxX(self.actionButton.frame) + kSmallPadding;

    self.canvasTypeTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                    kSmallPadding,
                                                                    149.0f,
                                                                    20.0f)];


    self.locationTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                  kSmallPadding,
                                                                  self.labelWidth,
                                                                  20.0f)];
    NSAttributedString *locationTitle =[TAGViewHelpers attributeText:@"Location" forFontSize:12.0f];
    [self.locationTitle setAttributedText:locationTitle];
    [TAGViewHelpers sizeLabelToFit:self.locationTitle numberOfLines:0];
    [self addSubview:self.locationTitle];

    self.locationAddress = [UILabel new];
    self.locationCity = [UILabel new];
    self.locationState = [UILabel new];

    NSArray *labels = [[NSArray alloc] initWithObjects:self.locationAddress, self.locationCity, self.locationState, nil];
    NSArray *text = [[NSArray alloc] initWithObjects:self.suggestion.address,self.suggestion.city,self.suggestion.state, nil];

    NSUInteger labelCount = [labels count];

    float xOrigin = CGRectGetMaxX(self.actionButton.frame) + 5.0f;

    for (int i=0; i<labelCount; i++) {
        float yOrigin;

        if (i == 0) {
            yOrigin = CGRectGetMaxY(self.locationTitle.frame) + kSmallPadding;
        } else {
            yOrigin = yOrigin + 15.0f;
        }

        UILabel *label = [labels objectAtIndex:i];
        label = [[UILabel alloc]initWithFrame:CGRectMake(xOrigin,
                                                         yOrigin,
                                                         self.labelWidth,
                                                         10.0f)];

        NSAttributedString *labelText =[TAGViewHelpers attributeText:[text objectAtIndex:i] forFontSize:10.0f];
        [label setAttributedText:labelText];
        [self addSubview:label];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
