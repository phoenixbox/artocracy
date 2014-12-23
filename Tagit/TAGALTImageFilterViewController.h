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
- (IBAction)goBack:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)goNext:(id)sender;

// IMAGE VIEW
@property (strong, nonatomic) IBOutlet UIImageView *filterImageView;

// ADJUSTMENTS
@property (strong, nonatomic) IBOutlet UIView *adjustmentsView;
@property (strong, nonatomic) IBOutlet UIButton *filtersButton;
- (IBAction)revealFilters:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *brightnessButton;
- (IBAction)revealBrightness:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *adjustmentsButton;
- (IBAction)revealAdjustments:(id)sender;

// SLIDER
@property (strong, nonatomic) IBOutlet UIView *sliderView;
- (IBAction)sliding:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
- (IBAction)cancelAdjustment:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveAdjustment:(id)sender;
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end
