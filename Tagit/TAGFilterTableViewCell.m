//
//  TAGFilterTableViewCell.m
//  Tagit
//
//  Created by Shane Rogers on 12/26/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGFilterTableViewCell.h"

// Constants
#import "TAGViewHelpers.h"

@implementation TAGFilterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.cellDimension = dimension;
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
    self.selectionIndicator = [[UIView alloc] initWithFrame:CGRectMake(5.0,10.0,2.0f,50.0)];
    [self.selectionIndicator setBackgroundColor:[UIColor blackColor]];

    [self addSubview:self.selectionIndicator];
}

- (void)updateWithAttributes:(NSDictionary *)attributes {
    UIImage *image = [attributes objectForKey:@"filteredImage"];
    [self setFilteredImage:image];
//
//    // TESTER
//    UIImageView *imageView = [UIImageView new];
//    UIImage *cellImage = [[UIImage alloc]initWithContentsOfFile:@"ape_do_good_printing_SF"];
//
//    CGRectGetMaxX(self.selectionIndicator)
//
//    imageView setFrame:CGRectMake(, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//    [imageView setImage:cellImage];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
