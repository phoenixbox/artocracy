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

NSString *const kSetSuggestionHeaderInfoNotification = @"SetSuggestionHeaderInfoNotification";
NSString *const kSetHeaderInfoUpvoteCount = @"upvoteCount";

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

- (IBAction)upvoteToggled:(UIButton *)button {
    if (!button.selected){
        [self upvoteSuggestion:button];
    } else {
        [self removeSuggestionUpvote:button];
    }

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

        [self sendHeaderUpdateNotification:self.upvote.count];
    };

    [[TAGUpvoteStore sharedStore] createUpvoteForSuggestion:self.suggestion.id withCompletionBlock:completionBlock];
}

- (void)removeSuggestionUpvote:(UIButton *)button {
    void(^completionBlock)(TAGSuggestion *suggestion, NSError *err)=^(TAGSuggestion *suggestion, NSError *err){
        if(!err){
            self.upvote = nil;
            self.actionButton.selected = NO;
            self.suggestion = suggestion;
        } else {
            [TAGErrorAlert render:err];
        }

        [self sendHeaderUpdateNotification:self.suggestion.upvoteCount];
    };

    [[TAGUpvoteStore sharedStore] destroyUpvote:self.upvote.id withCompletionBlock:completionBlock];
}

#pragma Loader Management

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


#pragma Header Notification
- (void)sendHeaderUpdateNotification:(NSNumber *)upvoteCount {

    NSNotification *notification = [NSNotification notificationWithName:kSetSuggestionHeaderInfoNotification
                                                                 object:self
                                                               userInfo:@{ kSetHeaderInfoUpvoteCount: upvoteCount }];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end
