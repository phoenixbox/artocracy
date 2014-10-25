//
//  TAGSpinner.m
//  Tagit
//
//  Created by Shane Rogers on 10/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSpinner.h"

@implementation TAGSpinner


- (void)setSpinnerImagesWithView:(UIView *)view {
    UIImage *img = [UIImage imageNamed:@"a_00.png"];
    [self setImage:img];


    //Add more images which will be used for the animation
    self.animationImages = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"a_90.png"],
                                [UIImage imageNamed:@"a_80.png"],
                                [UIImage imageNamed:@"a_70.png"],
                                [UIImage imageNamed:@"a_60.png"],
                                [UIImage imageNamed:@"a_50.png"],
                                [UIImage imageNamed:@"a_40.png"],
                                [UIImage imageNamed:@"a_30.png"],
                                [UIImage imageNamed:@"a_20.png"],
                                [UIImage imageNamed:@"a_20.png"],
                                [UIImage imageNamed:@"a_10.png"],
                                [UIImage imageNamed:@"a_00.png"],
                                [UIImage imageNamed:@"a_10.png"],
                                [UIImage imageNamed:@"a_20.png"],
                                [UIImage imageNamed:@"a_30.png"],
                                [UIImage imageNamed:@"a_40.png"],
                                [UIImage imageNamed:@"a_50.png"],
                                [UIImage imageNamed:@"a_60.png"],
                                [UIImage imageNamed:@"a_70.png"],
                                [UIImage imageNamed:@"a_80.png"], nil];

    self.animationDuration = 0.5;
    [self setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [self setCenter:view.center];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end