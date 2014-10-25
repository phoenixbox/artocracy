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
#import "TAGSpinner.h"

// Helpers
#import "TAGViewHelpers.h"

// Data Layer
#import "TAGSuggestionStore.h"
#import "TAGSessionStore.h"
#import "TAGUpvoteStore.h"
#import "TAGUpvote.h"

@implementation TAGSuggestionDetailsSection

-(id)initWithCoder:(NSCoder*)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        self.spinner = [TAGSpinner new];
    }
    return self;
}

- (void)attributeWithModel:(TAGSuggestion *)model {
    self.suggestion = model;
    // Location
    NSString *address = [NSString stringWithFormat:@"%@, %@, %@", self.suggestion.address, self.suggestion.city, self.suggestion.state];
    NSAttributedString *locationTitle =[TAGViewHelpers attributeText:address forFontSize:12.0f];
    [self.address setAttributedText:locationTitle];
    [TAGViewHelpers sizeLabelToFit:self.address numberOfLines:0];

    // Canvas Type
    NSAttributedString *canvasType =[TAGViewHelpers attributeText:self.suggestion.canvasType forFontSize:10.0f];
    [self.canvasType setAttributedText:canvasType];
    [TAGViewHelpers sizeLabelToFit:self.canvasType numberOfLines:0];

    if ([self shouldHideUpvoteButton]) { // This should be more like a conditional hide
//        [self hideUpvoteButton];
    }
    [self getUpvoteState];
}

- (BOOL)shouldHideUpvoteButton {
    TAGSessionStore *session = [TAGSessionStore sharedStore];
    return [self.suggestion.suggestorId isEqualToNumber:session.id];
}

- (void)hideUpvoteButton {
    [self.actionButton setHidden:YES];
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

- (void)upvoteSuggestion:(UIButton *)button {
    [self startSpinner:button];

    void(^completionBlock)(TAGUpvote *upvote, NSError *err)=^(TAGUpvote *upvote, NSError *err) {
        if(!err){
            self.upvote = upvote;
            self.actionButton.selected = YES;
        } else {
            self.actionButton.selected = NO;
            [TAGErrorAlert render:err];
        }
        [self stopSpinner:button];
    };

    [[TAGUpvoteStore sharedStore] createUpvoteForSuggestion:self.suggestion.id withCompletionBlock:completionBlock];
}

- (void)startSpinner:(UIButton *)button {
    [self.spinner setProgressForButton:self.actionButton];
    [button setHidden:YES];

    [self.spinner startAnimating];

    [self addSubview:self.spinner];
}

- (void)stopSpinner:(UIButton *)button {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    [button setHidden:NO];
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

- (IBAction)upvoteToggled:(UIButton *)button {
    if (!button.selected){
        [self upvoteSuggestion:button];
    } else {
        [self removeSuggestionUpvote:button];
    }

}
@end
