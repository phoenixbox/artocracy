//
//  TAGALTImageFilterViewController.m
//  Tagit
//
//  Created by Shane Rogers on 12/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGALTImageFilterViewController.h"

// Data Layer
#import "TAGFiltersStore.h"

@interface TAGALTImageFilterViewController ()

@end

@implementation TAGALTImageFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    [_sliderView setHidden:YES];

    if (_postImage) {
        [self.filterImageView setImage:_postImage];

        TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
        [filterStore generateFiltersForImage:_postImage];
    }
}

//scaleAndSetBackgroundImageNamed

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    NSLog(@"goBack");
}
- (IBAction)goNext:(id)sender {
    NSLog(@"goNext");
}
- (IBAction)revealFilters:(id)sender {
    NSLog(@"revealFilters");
}
- (IBAction)revealBrightness:(id)sender {
    NSLog(@"revealBrightness");
}
- (IBAction)revealAdjustments:(id)sender {
    NSLog(@"revealAdjustments");
}
- (IBAction)sliding:(id)sender {
    NSLog(@"Slider value %f", [_slider value]);
}
- (IBAction)cancelAdjustment:(id)sender {
    NSLog(@"cancelAdjustment");
}
- (IBAction)saveAdjustment:(id)sender {
    NSLog(@"saveAdjustment");
}
@end
