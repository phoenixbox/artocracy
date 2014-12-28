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

    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    [self.filterImageContainer setTransform:rotate];

    // NOTE: Had to use an image instead of an ImageView in the cell becasue I couldntr constrain the redraw of the image to the imnge view frame
    // The xib file has an abnormally offset UIView to compensate for an unknown offset in resulting from the drawing below.
    UIGraphicsBeginImageContextWithOptions(self.filterImageContainer.frame.size, NO, image.scale);
    [image drawInRect:self.filterImageContainer.bounds];
    UIImage* redrawn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.filterImageContainer setBackgroundColor:[UIColor colorWithPatternImage:redrawn]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
