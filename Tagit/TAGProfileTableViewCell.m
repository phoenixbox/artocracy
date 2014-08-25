//
//  TAGProfileTableViewCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/24/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProfileTableViewCell.h"

@implementation TAGProfileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
