//
//  TAGSuggestionListPiecesTableCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/30/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGLateralTableViewCell.h"
#import "TAGViewHelpers.h"

@implementation TAGLateralTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forCellDimension:(float)dimension
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellDimension = dimension;
        [self addImage];
    }
    return self;
}

- (void)addImage {
    self.image = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0)];


    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    [self.image setTransform:rotate];
    [self.image setFrame:CGRectMake(0,0,self.cellDimension,self.cellDimension)];
    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"open_arms_SF.png" forView:self.image];

    [self addSubview:self.image];
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
