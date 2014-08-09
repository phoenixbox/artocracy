//
//  TAGSuggestionViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionViewController.h"
#import "TAGCameraOverlay.h"

@interface TAGSuggestionViewController ()

@property (nonatomic) UIImagePickerController *_imagePickerController;
@property (nonatomic, strong) UIView *_overlayView;

@end

@implementation TAGSuggestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;

    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        self._imagePickerController.showsCameraControls = NO;

        self._overlayView = [TAGCameraOverlay new];

        self._overlayView.frame = self._imagePickerController.cameraOverlayView.frame;

        self._imagePickerController.cameraOverlayView = self._overlayView;

        self._overlayView = nil;
    }

    self._imagePickerController = imagePickerController;
    [self presentViewController:self._imagePickerController animated:YES completion:nil];
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
