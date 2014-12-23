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


- (void)setProgressForButton:(UIButton *)button {
    UIImage *img = [UIImage imageNamed:@"spinner_00.png"];
    [self setImage:img];


    //Add more images which will be used for the animation
    self.animationImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"spinner_01.png"],
                            [UIImage imageNamed:@"spinner_02.png"],
                            [UIImage imageNamed:@"spinner_03.png"],
                            [UIImage imageNamed:@"spinner_04.png"],
                            [UIImage imageNamed:@"spinner_05.png"],
                            [UIImage imageNamed:@"spinner_06.png"],
                            [UIImage imageNamed:@"spinner_07.png"],
                            [UIImage imageNamed:@"spinner_08.png"],
                            [UIImage imageNamed:@"spinner_09.png"], nil];

    self.animationDuration = 0.5;
    [self setFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)];
    [self setCenter:button.center];
}

- (void)setHeartSpinnerForButton:(UIButton *)button {
    [button setBackgroundColor:[UIColor blackColor]];
    UIImage *img = [UIImage imageNamed:@"heart_spinner00.png"];
    [self setImage:img];

    self.animationImages = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"heart_spinner01.png"],
                            [UIImage imageNamed:@"heart_spinner02.png"],
                            [UIImage imageNamed:@"heart_spinner03.png"],
                            [UIImage imageNamed:@"heart_spinner04.png"],
                            [UIImage imageNamed:@"heart_spinner05.png"],
                            [UIImage imageNamed:@"heart_spinner06.png"],
                            [UIImage imageNamed:@"heart_spinner07.png"],
                            [UIImage imageNamed:@"heart_spinner08.png"],
                            [UIImage imageNamed:@"heart_spinner09.png"], nil];

    self.animationDuration = 0.2;

    [self setFrame:CGRectMake(0.0f, 0.0f, button.frame.size.height, button.frame.size.height)];
    [self setCenter:button.center];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
