//
//  TAGProfileTableViewFavoriteCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/27/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProfileTableViewFavoriteCell.h"
#import "TAGViewHelpers.h"

@implementation TAGProfileTableViewFavoriteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellHeight = 100.0f;
        [self setImage];
        [self initializeProperties];
        [self addLabelsAndNames];
        [self addVisualSep];
    }
    return self;
}

- (void)setImage {
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
}

- (void)addLabelsAndNames {
    NSArray *labels = [[NSArray alloc] initWithObjects:self.artistLabel, self.artistName, self.locationLabel, self.locationName, self.canvasTypeLabel, self.canvasTypeName, nil];
    NSUInteger labelCount = [labels count];

    float labelHeight = 10.0f;
    float vertSpacing = (self.cellHeight - (labelCount*labelHeight))/(labelCount+1);
    float labelWidth = 130.0f;
    float xOrigin = self.image.frame.size.width + 10.0f;

    for (int i=0; i<labelCount; i++) {
        float yOrigin;

        if (i == 0) {
            yOrigin = vertSpacing;
        } else {
            yOrigin = vertSpacing + (i * (vertSpacing + labelHeight));
        }

        UILabel *label = [labels objectAtIndex:i];
        label = [[UILabel alloc]initWithFrame:CGRectMake(xOrigin,
                                                         yOrigin,
                                                         labelWidth,
                                                         labelHeight)];
        [label setBackgroundColor:[UIColor blackColor]];
        [label setText:@"Woop!"];
        [self addSubview:label];
    }
}

- (void)addVisualSep {
    // TODO: Couldnt get a hold of label origin to use as relative distance measure
    float percentageFromTop = 0.1;

    float sepHeight = self.cellHeight * (1 - (percentageFromTop * 2));

    [self.visualSep setFrame:CGRectMake(244.0f,
                                       self.cellHeight * percentageFromTop,
                                       2.0f,
                                       sepHeight)];
    [self.visualSep setBackgroundColor:[UIColor greenColor]];
    [self addSubview:self.visualSep];
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
