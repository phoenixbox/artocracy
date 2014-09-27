//
//  TAGContributeViewController.m
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: New Photo contribution view controlller

#import "TAGContributeViewController.h"

#import "TAGMapViewController.h"
#import "TAGCollectionView.h"
#import "TAGSuggestionCell.h"
#import "TAGImagePickerController.h"

#import "TAGSuggestionParallaxHeaderCell.h"

// Helpers
#import "TAGViewHelpers.h"

// Constants
#import "TAGStyleConstants.h"

// Pods
#import "CSStickyHeaderFlowLayout.h"

@interface TAGContributeViewController ()

@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) TAGMapViewController *_mapController;
@property (nonatomic) TAGImagePickerController *_imagePickerController;
@property (nonatomic, strong) TAGSuggestionCell *_primaryCell;
//@property (nonatomic, strong) UIImageView *_photo;
@property (nonatomic, strong) NSData *_photoData;
@property (nonatomic) BOOL _showImagePicker;
@property (nonatomic, strong) NSString *_photoName;

@property (nonatomic, strong) UIImage *_lastTakenPhoto;

@end

@implementation TAGContributeViewController

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

    [self buildCollectionView];
    [self initAppearance];
//    self._photo = [UIImageView new];
//    self._primaryCell = [TAGSuggestionCell new];
    self._lastTakenPhoto = [UIImage new];

    self._photoName = @"ape_do_good_printing_SF.png";

    CSStickyHeaderFlowLayout *layout = (id)self._collectionView.collectionViewLayout;

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 50);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320, 20); // Bigger shifts it up
    }
    // KNOW: think the header identifier here is specific to CSStickyHeaderParallaxHeader
    UINib *parallaxHeader = [UINib nibWithNibName:@"TAGSuggestionHeader" bundle:nil];
    [self._collectionView registerNib:parallaxHeader
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"mapHeader"];
}

- (void)viewDidAppear:(BOOL)animated {
//    [self._primaryCell.suggestionImage setImage:self._lastTakenPhoto];

//    [self._primaryCell.suggestionImage setImage:[UIImage imageNamed:self._photoName]];

    // SHOW PICKER STRAIGHT AWAY
    if (self._showImagePicker) {
        //        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    }
}


- (void)initAppearance
{
    [self setHeaderLogo];
    [self addNavigationItems];
}

- (void)addNavigationItems{
    UIImage *cancel = [UIImage imageNamed:@"cancel.png"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:cancel landscapeImagePhone:cancel style:UIBarButtonItemStylePlain target:self action:@selector(cancelSuggestion)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
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
    NSLog(@"Implement Photo Retake");
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
//    [self._primaryCell setSuggestionImage:nil];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    TAGImagePickerController *imagePickerController = [TAGImagePickerController sharedImagePicker];
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
//    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
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

    UIImageView *overlay = [[UIImageView alloc] initWithFrame:f];
    overlay.image = overlayImage;
    overlay.alpha = 0.7f;
    [imagePickerController setCameraOverlayView:overlay];

    return imagePickerController;
}

#pragma UIImagePickerControllerProtocol methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self._showImagePicker = NO;
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    [self transformToSquareImage:image];
    self._photoName = @"open_arms_SF.png";
    self._lastTakenPhoto = image;
    self._photoData = UIImageJPEGRepresentation(image, 0.2);

    __block TAGCollectionView *collectionView = self._collectionView;

    void (^completionBlock)(void) = ^(void){
        NSLog(@"COMPLETION BLOCK");
        [collectionView reloadData];
    };

    [self._imagePickerController dismissViewControllerAnimated:YES completion:completionBlock];
}

-(void)transformToSquareImage:(UIImage *)image {
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
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (self._showImagePicker == YES) {
        [self.parentViewController.tabBarController setSelectedIndex:0];
    }

    [self._imagePickerController dismissViewControllerAnimated:YES completion:nil];
}



- (void)buildCollectionView {
    self._collectionView = [[TAGCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:[self buildCollectionViewCellLayout]];

    UINib *cell = [UINib nibWithNibName:@"TAGSuggestionCell" bundle:nil];
    [self._collectionView registerNib:cell forCellWithReuseIdentifier:@"cell"];

    [self._collectionView setBackgroundColor:[UIColor whiteColor]];
    [self._collectionView setDelegate:self];
    [self._collectionView setDataSource:self];

    [self.view addSubview:self._collectionView];
}

- (UICollectionViewFlowLayout *)buildCollectionViewCellLayout {
    UICollectionViewFlowLayout *flowLayout = [CSStickyHeaderFlowLayout new];

    flowLayout.itemSize = CGSizeMake(320.0f,450.0f); // Same dimensions as the xib
    // TODO: Should be 0 but that disables scroll?
    flowLayout.headerReferenceSize = CGSizeMake(0.0f,10.0f);

    return flowLayout;
}

/////////////////////// Sticky

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // RETHINK THE NEED TO HAVE A HANDLE TO THE CELL? what about in view did appear?

    // Specify the cell identifier to be used
    self._primaryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                   forIndexPath:indexPath];
    // Setup cells appropriately
    [self._primaryCell setBackgroundColor:[UIColor whiteColor]];

    [self._primaryCell.canvasType setTintColor:[UIColor blackColor]];

    [self._primaryCell.retakePhoto addTarget:self action:@selector(retakePhoto) forControlEvents:UIControlEventTouchUpInside];

//    [self._primaryCell.suggestionImage setImage:self._lastTakenPhoto];

    // WORKS
    [self._primaryCell.suggestionImage setImage:[UIImage imageNamed:self._photoName]];

//    if (self._photoName) {
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self._photoName]];
//        [self._primaryCell.suggestionImage addSubview:imageView];
//    }

    [self._primaryCell.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self._primaryCell.submitButton setTitleColor:kPureWhite forState:UIControlStateNormal];
    self._primaryCell.submitButton.backgroundColor = kTagitBlack;
    [self._primaryCell.submitButton addTarget:self action:@selector(submitSuggestion:) forControlEvents:UIControlEventTouchUpInside];
    
    [self._primaryCell updateStyle];

    return self._primaryCell;
}

- (void)submitSuggestion:(id)paramSender {
    NSLog(@"Implement Suggestion Submit");
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      return [collectionView cellForItemAtIndexPath:indexPath];
    }
    else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        TAGSuggestionParallaxHeaderCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind                                                                            withReuseIdentifier:@"mapHeader" forIndexPath:indexPath];

        TAGMapView *map = [[TAGMapView alloc]initWithFrame:cell.mapView.frame forDelegate:cell];
        [cell.mapView addSubview:map];

        return cell;

    }
    return nil;
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
