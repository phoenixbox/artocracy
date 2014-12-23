//
//  TAGImageFilterController.m
//  Tagit
//
//  Created by Shane Rogers on 8/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGImageFilterController : UIViewController <UITableViewDelegate, UITableViewDataSource>

// Header El's
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *filterHeader;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;

// Image processing options
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIButton *brightnessButton;


// Slider Options
@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

- (IBAction)goNext:(id)sender;
- (IBAction)goBack:(id)sender;

// Image Processing Actions
- (IBAction)revealFilters:(id)sender;
- (IBAction)revealBrightness:(id)sender;

// Sider
- (IBAction)sliding:(id)sender;
- (IBAction)cancelAdjustment:(id)sender;
- (IBAction)saveAdjustment:(id)sender;

@property (nonatomic, strong) UIImage *postImage;

@end