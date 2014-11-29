//
//  TAGImagePickerController.m
//  Tagit
//
//  Created by Shane Rogers on 8/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGImagePickerController.h"
#import "TAGCameraOverlay.h"

@interface TAGImagePickerController ()

@property (nonatomic, strong) TAGCameraOverlay *cameraOverlay;

@end

@implementation TAGImagePickerController

+ (TAGImagePickerController *)sharedImagePicker {
    static TAGImagePickerController *imagePicker = nil;

    if (!imagePicker) {
        imagePicker = [[TAGImagePickerController alloc]init];

    };
    return imagePicker;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildOverlay {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TAGCameraOverlay" owner:nil options:nil];
    self.cameraOverlay = [nibContents lastObject];
    [self.cameraOverlay setPicker:self];

    [self setCameraOverlayView:self.cameraOverlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
