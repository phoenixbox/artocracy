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
#import "TAGStyleConstants.h"

@implementation TAGFilterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)renderSelectionIndicator {
    self.selectionIndicator = [[UIView alloc] initWithFrame:CGRectMake(5.0,10.0,2.0f,50.0)];
    [self.selectionIndicator setBackgroundColor:[UIColor blackColor]];

    [self addSubview:self.selectionIndicator];
}

- (void)updateWithAttributes:(NSDictionary *)attributes {
    UIImage *image = [attributes objectForKey:@"blurredImage"];
    NSString *filterName = [attributes objectForKey:@"filterName"];

    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    [self.filterImageContainer setTransform:rotate];

    // NOTE: Had to use an image instead of an ImageView in the cell becasue I couldntr constrain the redraw of the image to the imnge view frame
//     The xib file has an abnormally offset UIView to compensate for an unknown offset in resulting from the drawing below.
    UIGraphicsBeginImageContextWithOptions(self.filterImageContainer.frame.size, NO, image.scale);
    [image drawInRect:self.filterImageContainer.bounds];
    UIImage* redrawn = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.filterImageContainer setBackgroundColor:[UIColor colorWithPatternImage:redrawn]];


    [TAGViewHelpers formatLabel:_filterLabel withCopy:filterName andFontFamily:nil];
    [_filterLabel setTransform:rotate];
    [TAGViewHelpers sizeLabelToFit:_filterLabel numberOfLines:1];

}

- (void)rotateElement:(UIView *)element {
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    [element setTransform:rotate];
}

- (void)setOverlayImage:(NSString *)labelName {
    UILabel *overlayLabel = [UILabel new];
    [overlayLabel setAttributedText:[TAGViewHelpers attributeText:labelName forFontSize:25.0f andFontFamily:@"WalkwaySemiBold"]];
    [TAGViewHelpers sizeLabelToFit:overlayLabel numberOfLines:1];
    [self rotateElement:overlayLabel];
    [overlayLabel setCenter:self.filterImageContainer.center];
    [overlayLabel setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:overlayLabel];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
