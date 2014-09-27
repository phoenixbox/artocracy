//
//  TAGProfileTableViewFavoriteCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/27/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: Favorite cell in the profile collection view

#import "TAGProfileTableFavoriteCell.h"
#import "TAGViewHelpers.h"

// Constants
#import "TAGStyleConstants.h"

@implementation TAGProfileTableFavoriteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellHeight = 100.0f;
        self.imageName = @"heartSelected.png";
        [self addImage];
        [self initializeProperties];
        [self addLabelsAndNames];
        [self addVisualSep];
        [self addFavoritesCounter];
    }
    return self;
}

- (void)addImage {
    CGRect imageFrame = CGRectMake(0, 0, self.cellHeight, self.cellHeight);
    self.image = [[UIView alloc] initWithFrame:imageFrame];

    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"open_arms_SF" forView:self.image];

    [self addSubview:self.image];
}

- (void)initializeProperties {
    self.artistLabel = [UILabel new];
    self.artistName = [UILabel new];
    self.locationLabel = [UILabel new];
    self.locationName = [UILabel new];
    self.canvasTypeLabel = [UILabel new];
    self.canvasTypeName = [UILabel new];
    self.visualSep = [UIView new];
    self.favoritesIcon = [UIView new];
    self.counter = [UILabel new];
    self.favoritesLabel = [UILabel new];
}

- (void)addLabelsAndNames {
    NSArray *labels = [[NSArray alloc] initWithObjects:self.artistLabel, self.artistName, self.locationLabel, self.locationName, self.canvasTypeLabel, self.canvasTypeName, nil];
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
        [label setText:@"Woop!"];
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

- (void)addFavoritesCounter {
    // TODO: xOrigin should be relative to an el not hardcoded
    float counterSq = 25.0f;
    float yOrigin = (self.cellHeight/2) - (counterSq/2);

    CGRect counterRect = CGRectMake(249.0f + 2.0f + 9.5f,
                                 yOrigin,
                                 counterSq,
                                 counterSq);

    [self.counter setFrame:counterRect];
    [self setLabel:self.counter withTitle:@"7" forFontSize:10.0f];

    CGRect iconRect = CGRectMake(self.counter.frame.origin.x + counterSq,
                               yOrigin,
                               counterSq,
                               counterSq);
    [self.favoritesIcon setFrame:iconRect];
    [TAGViewHelpers scaleAndSetBackgroundImageNamed:self.imageName forView:self.favoritesIcon];
    [self addSubview:self.favoritesIcon];

    [self.favoritesLabel setFrame:CGRectMake(self.counter.frame.origin.x,
                                             CGRectGetMaxY(self.counter.frame) - 10.0f,
                                             counterSq*2,
                                             counterSq)];
    [self setLabel:self.favoritesLabel withTitle:@"Favorited" forFontSize:9.0f];
}

- (void)setLabel:(UILabel *)label withTitle:(NSString *)title forFontSize:(CGFloat)size {
    NSAttributedString *faveText = [TAGViewHelpers attributeText:title forFontSize:size];
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
