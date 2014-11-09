//
//  TAGProfileTableViewCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/24/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Subject
#import "TAGProfileTableSuggestionCell.h"

// Helpers
#import "TAGViewHelpers.h"

// Constants
#import "TAGComponentConstants.h"
#import "TAGStyleConstants.h"

// Components
#import "TAGLateralTableViewCell.h"

@implementation TAGProfileTableSuggestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forModel:(TAGSuggestion *)suggestion
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellHeight = 100.0f;
        self.suggestion = suggestion;

        [self initializeProperties];
        [self addImage];
        [self addLabels];
        [self addVisualSep];
        [self addPiecesCounter];
        [self addUpvotesCounter];
    }
    return self;
}

- (void)initializeProperties {
    self.suggestionImage = [UIView new];

    self.suggesterLabel = [UILabel new];
    self.suggestername = [UILabel new];

    self.locationLabel = [UILabel new];
    self.locationName = [UILabel new];

    self.canvasTypeLabel = [UILabel new];
    self.canvasTypeName = [UILabel new];
    self.visualSep = [UIView new];

    self.upvotesIcon = [UILabel new];
    self.upvotesCounter = [UILabel new];
    self.upvotesLabel = [UILabel new];

    self.piecesIcon = [UIView new];
    self.piecesCounter = [UILabel new];
    self.piecesLabel = [UILabel new];
}

- (void)addImage {
    CGRect imageFrame = CGRectMake(0, 0, self.cellHeight, self.cellHeight);
    [self.suggestionImage setFrame:imageFrame];

    [TAGViewHelpers scaleAndSetRemoteBackgroundImage:self.suggestion.imageUrl forView:self.suggestionImage];

    [self addSubview:self.suggestionImage];
}

- (void)addLabels {
    NSArray *labels = [[NSArray alloc] initWithObjects: self.suggesterLabel,
                                                        self.suggestername,
                                                        self.locationLabel,
                                                        self.locationName,
                                                        self.canvasTypeLabel,
                                                        self.canvasTypeName, nil];


    NSArray *text = [[NSArray alloc] initWithObjects:@"Suggested By",
                                                     self.suggestion.suggestorEmail,
                                                     @"Location",
                                                     self.suggestion.address,
                                                     @"Canvas Type",
                                                     self.suggestion.canvasType, nil];

    NSUInteger labelCount = [labels count];

    float labelHeight = 10.0f;
    float vertSpacing = (self.cellHeight - (labelCount*labelHeight))/(labelCount+1);
    float labelWidth = 130.0f;
    float xOrigin = self.cellHeight + 9.5f;


    for (int i=0; i<labelCount; i++) {
        float yOrigin;

        if (i == 0) {
            yOrigin = vertSpacing;
        } else {
            yOrigin = vertSpacing + (i * (vertSpacing + labelHeight));
        }

        UILabel *label = [labels objectAtIndex:i];
        [label setBackgroundColor:[UIColor clearColor]];
        label = [[UILabel alloc]initWithFrame:CGRectMake(xOrigin,
                                                         yOrigin,
                                                         labelWidth,
                                                         labelHeight)];
        NSString *fontFamily;
        if ( i%2 ==0 ) {
            fontFamily = @"WalkwayObliqueSemiBold";
        } else {
            fontFamily = nil;
        }
        [TAGViewHelpers formatLabel:label withCopy:[text objectAtIndex:i] andFontFamily:fontFamily];



        [self addSubview:label];
    }
}

- (void)addVisualSep {
    // TODO: Couldnt get a hold of label origin to use as relative distance measure
    float percentageFromTop = 0.1;

    float sepHeight = self.cellHeight * (1 - (percentageFromTop * 2));

    [self.visualSep setFrame:CGRectMake(249.0f,
                                        self.cellHeight * percentageFromTop,
                                        1.0f,
                                        sepHeight)];

    [self.visualSep setBackgroundColor:kTagitSeparatorGrey];
    [self addSubview:self.visualSep];
}

- (void)addPiecesCounter {
    [self addPiecesCounterLabel];
    [self addPiecesCounterIcon];
}

- (void)addPiecesCounterLabel {
    float counterSq = 25.0f;
    float yOrigin = (self.cellHeight/4) - (counterSq/2);
    CGRect counterRect = CGRectMake(249.0f + 2.0f + 9.5f,
                                    yOrigin,
                                    counterSq,
                                    counterSq);
    [self.piecesCounter setFrame:counterRect];

    NSAttributedString *upvotesCount = [TAGViewHelpers counterString:[self.suggestion.proposalCount stringValue] withFontSize:10.0f];
    [self.piecesCounter setAttributedText:upvotesCount];
    [self addSubview:self.piecesCounter];
}

- (void)addPiecesCounterIcon {
    float counterSq = 25.0f;
    float yOrigin = (self.cellHeight/4) - (counterSq/2);
    CGRect iconRect = CGRectMake(self.piecesCounter.frame.origin.x + counterSq,
                                 yOrigin,
                                 counterSq,
                                 counterSq);
    [self.piecesIcon setFrame:iconRect];
    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"pieceIcon.png" forView:self.piecesIcon];
    [self addSubview:self.piecesIcon];

    [self.piecesLabel setFrame:CGRectMake(self.piecesCounter.frame.origin.x,
                                          CGRectGetMaxY(self.piecesCounter.frame) - 10.0f,
                                          counterSq*2,
                                          counterSq)];
    [self setLabel:self.piecesLabel withTitle:@"Proposals" forFontSize:8.0f];
}

- (void)addUpvotesCounter {
    [self addUpvotesCounterLabel];
    [self addUpvotesCounterIcon];
}

- (void)addUpvotesCounterLabel {
    float counterSq = 25.0f;
    float yOrigin = (self.cellHeight/2) + (counterSq/4);
    CGRect counterRect = CGRectMake(249.0f + 2.0f + 9.5f,
                                    yOrigin,
                                    counterSq,
                                    counterSq);
    [self.upvotesCounter setFrame:counterRect];

    NSAttributedString *upvotesCount = [TAGViewHelpers counterString:[self.suggestion.upvoteCount stringValue] withFontSize:10.f];
    [self.upvotesCounter setAttributedText:upvotesCount];
    [self addSubview:self.upvotesCounter];
}

- (void)addUpvotesCounterIcon {
    float counterSq = 25.0f;
    float yOrigin = (self.cellHeight/2) + (counterSq/4);
    CGRect iconRect = CGRectMake(self.upvotesCounter.frame.origin.x + counterSq,
                                 yOrigin,
                                 counterSq,
                                 counterSq);
    [self.upvotesIcon setFrame:iconRect];
    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"upvote.png" forView:self.upvotesIcon];
    [self addSubview:self.upvotesIcon];

    [self.upvotesLabel setFrame:CGRectMake(self.upvotesCounter.frame.origin.x,
                                           CGRectGetMaxY(self.upvotesCounter.frame) - 10.0f,
                                           counterSq*2,
                                           counterSq)];
    [self setLabel:self.upvotesLabel withTitle:@"Upvotes" forFontSize:8.0f];
}

- (void)setLabel:(UILabel *)label withTitle:(NSString *)title forFontSize:(CGFloat)size {
    NSAttributedString *faveText = [TAGViewHelpers attributeText:title forFontSize:size andFontFamily:nil];
    [label setAttributedText:faveText];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
