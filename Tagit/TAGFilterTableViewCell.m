//
//  TAGFilterTableViewCell.m
//  Tagit
//
//  Created by Shane Rogers on 12/26/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGFilterTableViewCell.h"

@implementation TAGFilterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forCellDimension:(float)dimension
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellDimension = dimension;
//        [self renderSelectionIndicator];
    }
    return self;
}
// RESTART: Build the cell frame -  then can set the values in the table callback
//- (void)renderCellImage {
//    UIImageView *filteredImage = [UIImageView new];
//    filteredImage setFrame:CGRectMake(5.0, 5.0, xx,xx )
//    UIImage *cellImage = [[UIImage alloc]initWithContentsOfFile:@"ape_do_good_printing_SF"];

    
//    [self addSubview:cellImage];
//}

- (void)renderSelectionIndicator {
    UIView *selectionIndicator = [[UIView alloc] initWithFrame:CGRectMake(0.5,12.0,70.0, 2.0f)];
    [selectionIndicator setBackgroundColor:[UIColor redColor]];

    [self addSubview:selectionIndicator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
