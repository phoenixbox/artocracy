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
        [self setImage];
        [self initializeProperties];
        [self addLabelsAndNames];
    }
    return self;
}

- (void)setImage {
    CGRect imageFrame = CGRectMake(0, 0, 100.0f, 100.0f);
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
}

- (void)addLabelsAndNames {
    NSArray *labels = [[NSArray alloc] initWithObjects:self.artistLabel, self.artistName, self.locationLabel, self.locationName, self.canvasTypeLabel, self.canvasTypeName, nil];
    NSUInteger labelCount = [labels count];

    float labelHeight = 10.0f;
    float vertSpacing = (100.0f - (labelCount*labelHeight))/(labelCount+1);
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
