//
//  TAGSuggestionViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionViewController.h"
#import "TAGCameraOverlay.h"
#import "TAGImagePickerController.h"

// Constants
#import "TAGStyleConstants.h"

@interface TAGSuggestionViewController ()

@property (nonatomic) TAGImagePickerController *_imagePickerController;
@property (nonatomic, strong) UIView *_overlayView;
@property (nonatomic, strong) UIImageView *_photo;
@property (nonatomic) BOOL _showPicker;

@end

@implementation TAGSuggestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"Suggestion Initialized");

        self._showPicker = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self._photo = [UIImageView new];
    self._photo.frame = CGRectMake(0.0f, kBigPadding, 320.0f, 320.0f);

    if (self._showPicker) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAppearance];
}

- (void)initAppearance
{
    self.navigationController.navigationBar.translucent = NO;

    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarTintColor:kPureWhite];

    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UIToolbar appearance] setBarTintColor:kTagitBlack];
    [self setHeaderLogo];
    [self addNavigationItems];
}

- (void)addNavigationItems{
    UIImage *cancel = [UIImage imageNamed:@"cancel.png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:cancel landscapeImagePhone:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelSuggestion)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];

    UIImage *retake = [UIImage imageNamed:@"camera_nav.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:retake landscapeImagePhone:retake style:UIBarButtonItemStylePlain target:self action:@selector(retakePhoto)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void)setHeaderLogo {
    [[self navigationItem] setTitleView:nil];
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 165.0f, 32.5f)];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"art_navBarLogo.png"];
    [logoView setImage:logoImage];
    self.navigationItem.titleView = logoView;
}

- (void)cancelSuggestion {
    [self.parentViewController.tabBarController setSelectedIndex:0];
}

- (void)retakePhoto {
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    [self._photo setImage:nil];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    TAGImagePickerController *imagePickerController = [TAGImagePickerController sharedImagePicker];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [imagePickerController setShowsCameraControls:YES];

    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        self._imagePickerController = [self buildSquareOverlay:imagePickerController];
    }

    [self presentViewController:self._imagePickerController animated:YES completion:nil];
}

- (TAGImagePickerController *)buildSquareOverlay:(TAGImagePickerController *)imagePickerController {
    CGRect f = imagePickerController.view.bounds;
    f.size.height -= imagePickerController.navigationBar.bounds.size.height;
    UIGraphicsBeginImageContext(f.size);
    [[UIColor colorWithWhite:0.0f alpha:.8] set];
    UIRectFillUsingBlendMode(CGRectMake(0, 0, f.size.width, 124.0), kCGBlendModeNormal);
    UIRectFillUsingBlendMode(CGRectMake(0, 444, f.size.width, 52), kCGBlendModeNormal);
    UIImage *overlayImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *overlayIV = [[UIImageView alloc] initWithFrame:f];
    overlayIV.image = overlayImage;
    overlayIV.alpha = 0.7f;
    [imagePickerController setCameraOverlayView:overlayIV];

    return imagePickerController;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.0];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    };
    self._photo.image = image;
    [self.view addSubview:self._photo];
    self._showPicker = NO;
    [self._imagePickerController dismissViewControllerAnimated:YES completion:nil];
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
