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
#import "TAGMapViewController.h"

// Constants
#import "TAGStyleConstants.h"

@interface TAGSuggestionViewController ()

@property (nonatomic) TAGImagePickerController *_imagePickerController;
@property (nonatomic, strong) UIView *_overlayView;
@property (nonatomic, strong) TAGMapViewController *_mapController;
@property (nonatomic, strong) UIImageView *_photo;
@property (nonatomic, strong) UIScrollView *_scrollView;
@property (nonatomic) BOOL _showImagePicker;

@property (nonatomic, strong) UILabel *_locationTitle;
@property (nonatomic, strong) UILabel *_address;

@property (nonatomic, strong) UILabel *_canvasTypeTitle;
@property (nonatomic, strong) UISegmentedControl *_canvasTypeSegment;

@property (nonatomic, strong) UIButton *_submitButton;

@end

@implementation TAGSuggestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"Suggestion Initialized");
        self._showImagePicker = YES;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    self._photo = [UIImageView new];
    self._photo.frame = CGRectMake(0.0f, kBigPadding*2, 320.0f, 320.0f);

    if (self._showImagePicker) {
//        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAppearance];
    [self renderScrollView];
    [self renderMap];
    [self renderLocation];
    [self renderForm];

    [self setScrollViewContentSize];
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

- (void)renderScrollView {
    self._scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self._scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self._scrollView.delegate = self;

    [self.view addSubview:self._scrollView];
}

- (void)setScrollViewContentSize {
    CGFloat fullHeight = self._submitButton.frame.origin.y + 150.0f;

    [self._scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,fullHeight)];
}

- (void)renderMap {
    self._mapController = [TAGMapViewController new];

    [self addChildViewController:self._mapController];
    [self._scrollView addSubview:self._mapController.view];
}

- (void)renderLocation {
    self._locationTitle = [[UILabel alloc] initWithFrame:CGRectMake(kBigPadding,
                                                                   430.0f,
                                                                   70.0f,
                                                                    40.0f)];

    float addressXCoord = self._locationTitle.frame.origin.x + self._locationTitle.frame.size.width + kSmallPadding;
    // NOTE: The alignment of labels to the bottom edge with height delta - 16 - 12 = 4
    self._address = [[UILabel alloc] initWithFrame:CGRectMake(addressXCoord,
                                                              430.0f + 4.0f,
                                                              100.0f,
                                                              40.0f)];

    NSAttributedString *locationCopy = [self attributeText:@"Location" forFontSize:16.0f];
    [self._locationTitle setAttributedText:locationCopy];
    [self sizeLabelToFit:self._locationTitle numberOfLines:0];
    [self._scrollView addSubview:self._locationTitle];

    NSAttributedString *addressCopy = [self attributeText:@"123 Ape Street, San Francisco, CA 93221" forFontSize:12.0f];
    [self._address setAttributedText:addressCopy];
    [self sizeLabelToFit:self._address numberOfLines:1];
    [self._scrollView addSubview:self._address];
}

- (NSAttributedString *)attributeText:(NSString *)text forFontSize:(CGFloat)size{
    return [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:size]}];
}


- (void)sizeLabelToFit:(UILabel *)label numberOfLines:(CGFloat)lineNumber {
    [label setNumberOfLines:lineNumber];
    [label sizeToFit];
}

- (void)renderForm {
    float yCoord = 430.0f + self._locationTitle.frame.size.height + kBigPadding;
    self._canvasTypeTitle = [[UILabel alloc] initWithFrame:CGRectMake(kBigPadding,
                                                                    yCoord,
                                                                    100.0f,
                                                                    40.0f)];
    NSAttributedString *canvasTypeCopy = [self attributeText:@"Canvas Type" forFontSize:16.0f];
    [self._canvasTypeTitle setAttributedText:canvasTypeCopy];
    [self sizeLabelToFit:self._canvasTypeTitle numberOfLines:1];
    [self._scrollView addSubview:self._canvasTypeTitle];

    NSArray *segments = @[ @"Commercial Wall", @"Public Wall"];
    self._canvasTypeSegment = [[UISegmentedControl alloc] initWithItems:segments];
    [self._canvasTypeSegment setTintColor:[UIColor blackColor]];
    CGPoint segmentCenter = CGPointMake(self.view.center.x, self._canvasTypeTitle.frame.origin.y + 50.0f);
    [self._canvasTypeSegment setCenter:segmentCenter];
    [self._scrollView addSubview:self._canvasTypeSegment];
    [self renderLoginButton];
}

- (void)renderLoginButton {
    CGFloat yCoord = self._canvasTypeSegment.frame.origin.y + self._canvasTypeSegment.frame.size.height + kBigPadding;
    CGRect buttonFrame = CGRectMake(kBigPadding, yCoord, self.view.frame.size.width - kBigPadding*2, kBigPadding*4);

    self._submitButton = [[UIButton alloc]initWithFrame:buttonFrame];
    [self._submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self._submitButton setTitleColor:kPureWhite forState:UIControlStateNormal];
    self._submitButton.backgroundColor = kTagitBlack;
    [self._submitButton addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self._scrollView addSubview:self._submitButton];
}

- (void)submit {
    NSLog(@"Implement Submission");
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

#pragma UIImagePickerControllerProtocol methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self._showImagePicker = NO;
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
    [self._scrollView addSubview:self._photo];
    [self._imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (self._showImagePicker == YES) {
        [self.parentViewController.tabBarController setSelectedIndex:0];
    }

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
