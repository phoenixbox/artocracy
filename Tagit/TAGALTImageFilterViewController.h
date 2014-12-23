//
//  TAGALTImageFilterViewController.h
//  Tagit
//
//  Created by Shane Rogers on 12/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TAGFilterImageView.h"

@interface TAGALTImageFilterViewController : UIViewController

@property (strong, nonatomic) UIImage *postImage;

// HEADER
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

// IMAGE VIEW
@property (strong, nonatomic) IBOutlet UIImageView *filterImageView;

// ADJUSTMENTS
@property (strong, nonatomic) IBOutlet UIButton *filtersButton;
@property (strong, nonatomic) IBOutlet UIButton *brightnessButton;
@property (strong, nonatomic) IBOutlet UIButton *adjustmentsButton;


// SLIDER
@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end
