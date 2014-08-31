//
//  TAGSuggestionListPiecesTableCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/30/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionListPiecesTableCell.h"
#import "TAGViewHelpers.h"

@implementation TAGSuggestionListPiecesTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addImage];
    }
    return self;
}

- (void)addImage {
    self.image = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0)];


    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    [self.image setTransform:rotate];
    [self.image setFrame:CGRectMake(0,0,80.0f,80.0f)];
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
