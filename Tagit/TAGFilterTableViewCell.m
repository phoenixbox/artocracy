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
    NSString *watermark = [attributes objectForKey:@"watermark"];

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

    UILabel *watermarkLabel = [UILabel new];
    [watermarkLabel setAttributedText:[TAGViewHelpers attributeText:watermark forFontSize:25.0f andFontFamily:@"WalkwaySemiBold"]];
    [TAGViewHelpers sizeLabelToFit:watermarkLabel numberOfLines:1];
    [watermarkLabel setTransform:rotate];
    [watermarkLabel setCenter:self.filterImageContainer.center];
    [watermarkLabel setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:watermarkLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
