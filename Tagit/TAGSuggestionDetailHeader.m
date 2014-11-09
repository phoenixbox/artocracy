//
//  TAGSuggestionDetailHeader.m
//  Tagit
//
//  Created by Shane Rogers on 11/2/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionDetailHeader.h"

// Helpers
#import "TAGViewHelpers.h"

@implementation TAGSuggestionDetailHeader

-(id)initWithCoder:(NSCoder*)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {

    }
    return self;
}

- (void)attributeWithModel:(TAGSuggestion *)model {
    self.suggestion = model;

    // Suggestor Image - Set & Round
    [TAGViewHelpers scaleAndSetRemoteBackgroundImage:self.suggestion.suggestorImageURL forView:self.suggestorThumnail];
    [TAGViewHelpers roundImageLayer:self.suggestorThumnail.layer withFrame:self.suggestorThumnail.frame];

    // SuggestorEmail
    NSAttributedString *text = [TAGViewHelpers attributeText:self.suggestion.suggestorEmail forFontSize:10.0f andFontFamily:nil];
    [self.suggestorEmail setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self.suggestorEmail numberOfLines:0];
    
    // Counter
    NSString *count = [self.suggestion.upvoteCount stringValue];
    NSMutableAttributedString *upvoteCounter = [TAGViewHelpers upvoteCounterStringWithCopy:count andFontSize:13.0f];
    [self.upvoteCounter setAttributedText:upvoteCounter];
}

@end
