//
//  TAGProfileTableViewFavoriteCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/27/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProfileTableViewFavoriteCell.h"

@implementation TAGProfileTableViewFavoriteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setTitle];
    }
    return self;
}

- (void)setTitle {
    self.title = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.origin.x + 100.0f,
                                                          30.0f,
                                                          100.0f,
                                                          40.0f)];
    [self.title setText:@"Favorite Cell"];
    [self addSubview:self.title];
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
