//
//  TAGContributeViewController.m
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: New Photo contribution view controlller

#import "TAGContributeViewController.h"

// Components
#import "TAGMapViewController.h"
#import "TAGCollectionView.h"
#import "TAGSuggestionCell.h"
#import "TAGImagePickerController.h"
#import "TAGErrorAlert.h"
#import "TAGSuggestionParallaxHeaderCell.h"
#import "TAGImageFilterController.h"
#import "TAGALTImageFilterViewController.h"

// Helpers
#import "TAGViewHelpers.h"
#import "TAGFormValidators.h"

// Constants
#import "TAGStyleConstants.h"

// Pods
#import "CSStickyHeaderFlowLayout.h"

// Data Layer
#import "TAGSuggestionStore.h"
#import "TAGPieceStore.h"
#import "TAGFavoriteStore.h"
#import "TAGUpvoteStore.h"

@interface TAGContributeViewController ()

@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) UINib *headerNib;
@property (nonatomic, strong) TAGMapViewController *_mapController;
@property (nonatomic) TAGImagePickerController *_imagePickerController;
@property (nonatomic, strong) TAGSuggestionCell *_primaryCell;
@property (nonatomic, strong) TAGSuggestionParallaxHeaderCell *_headerCell;
@property (nonatomic, strong) NSData *_photoData;
@property (nonatomic) BOOL _showImagePicker;
@property (nonatomic, strong) NSString *_photoName;
@property (nonatomic, strong) NSURL *_S3ImageLocation;
@property (nonatomic, strong) SCNavigationController *_cameraController;

@property (nonatomic, strong) UIImage *_lastTakenPhoto;

@end

@implementation TAGContributeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self._showImagePicker = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self buildCollectionView];
    [self initAppearance];
    self._lastTakenPhoto = [UIImage new];

    self._photoName = @"ape_do_good_printing_SF.png";

    CSStickyHeaderFlowLayout *layout = (id)self._collectionView.collectionViewLayout;

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 50);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320, 0); // Bigger shifts it up
    }

    UINib *parallaxHeader = [UINib nibWithNibName:@"TAGSuggestionHeader" bundle:nil];
    [self._collectionView registerNib:parallaxHeader
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"mapHeader"];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([self isCameraAvailable] && self._showImagePicker) {
        self._cameraController = [[SCNavigationController alloc] init];
        self._cameraController.scNaigationDelegate = self;
        [self._cameraController showCameraWithParentController:self];
    }
}

- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image {

//    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TAGALTImageFilterViewController" owner:self options:nil];
    TAGALTImageFilterViewController *con = [TAGALTImageFilterViewController new];
    
    con.postImage = image;
    [self._cameraController presentViewController:con animated:YES completion:nil];
//    [self._cameraController pushViewController:con animated:YES];
}

//// TODO: Functionality should be an image picker which when dismissed reveals the edit panel
//- (void)viewDidAppear:(BOOL)animated {
//    if ([self isCameraAvailable] && self._showImagePicker) {
//        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
//    }
//}

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
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypeCamera];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType {
    if ([self isCameraAvailable]) {
        TAGImagePickerController *imagePickerController = [TAGImagePickerController sharedImagePicker];
        imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
        imagePickerController.sourceType = sourceType;
        imagePickerController.delegate = self;

        [imagePickerController setShowsCameraControls:YES];

        if (sourceType == UIImagePickerControllerSourceTypeCamera)
        {
            self._imagePickerController = imagePickerController;
            [self._imagePickerController buildOverlay];
        }

        [self presentViewController:self._imagePickerController animated:YES completion:nil];
    } else {
        NSLog(@"Camera is unavailable!");
    }
}

#pragma UIImagePickerControllerProtocol methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self._showImagePicker = NO;
}

- (void)cropAndSetImage:(NSDictionary *)info {
    UIImage *image = [self cropImageToSquare:info];
    self._lastTakenPhoto = image;
    self._photoData = UIImageJPEGRepresentation(image, 0.2);
    [self._primaryCell.suggestionImage setImage:self._lastTakenPhoto];
}

- (void)dismissTheImagePicker {
    [self._imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)cropImageToSquare:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];

    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width != height) {
        CGFloat newDimension = MIN(width, height);
        CGFloat widthOffset = (width - newDimension) / 2;
        CGFloat heightOffset = (height - newDimension) / 2;
        // TODO: Investigate the 3rd param
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(newDimension, newDimension), NO, 0.);
        [image drawAtPoint:CGPointMake(-widthOffset, -heightOffset)
                 blendMode:kCGBlendModeCopy
                     alpha:1.0];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    };
    return image;
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

    flowLayout.itemSize = CGSizeMake(320.0f,600.0f); // Same dimensions as the xib
    // TODO: Should be 0 but that disables scroll?
    flowLayout.headerReferenceSize = CGSizeMake(0.0f,10.0f);

    return flowLayout;
}

/////////////////////// Sticky Header

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Specify the cell identifier to be used
    self._primaryCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                   forIndexPath:indexPath];
    // Setup cells appropriately
    [self._primaryCell setBackgroundColor:[UIColor whiteColor]];
    // Title
    [self._primaryCell.titleLabel setAttributedText:[TAGViewHelpers attributeText:@"Title" forFontSize:16.0f andFontFamily:nil]];

    // Contribution Type
    [self._primaryCell.contributionTypeSelect setTintColor:[UIColor blackColor]];
    [self._primaryCell.contributionTypeLabel setAttributedText:[TAGViewHelpers attributeText:@"Contribution Type" forFontSize:16.0f andFontFamily:nil]];
    // Canvas Type
    [self._primaryCell.canvasType setTintColor:[UIColor blackColor]];
    [self._primaryCell.canvasTypeLabel setAttributedText:[TAGViewHelpers attributeText:@"Canvas Type" forFontSize:16.0f andFontFamily:nil]];

    [self._primaryCell.suggestionImage setImage:self._lastTakenPhoto];
    [self._primaryCell.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self._primaryCell.submitButton setTitleColor:kPureWhite forState:UIControlStateNormal];
    self._primaryCell.submitButton.backgroundColor = kTagitBlack;
    [self._primaryCell.submitButton addTarget:self action:@selector(submitContribution) forControlEvents:UIControlEventTouchUpInside];

    return self._primaryCell;
}

- (BOOL)validateForm {
    NSString *errorMessage;

    if ([TAGFormValidators inputFieldEmpty:self._primaryCell.titleTextField]) {
        errorMessage = @"Please give the piece a name";
    } else if (![TAGFormValidators segmentControlIsSet:self._primaryCell.contributionTypeSelect]){
        errorMessage = @"Please select a contribution type";
    } else if (![TAGFormValidators segmentControlIsSet:self._primaryCell.canvasType]) {
        errorMessage = @"Please select a canvas type";
    }

    if (errorMessage) {
        [TAGErrorAlert renderWithTitle:errorMessage];
        return NO;
    } else {
        return YES;
    }
}

- (void)submitPiece:(NSMutableDictionary *)params {
    TAGPieceStore *pieceStore = [TAGPieceStore sharedStore];

    // Fourth: Return to user's profile
    void (^returnToUserProfile)(TAGFavorite *favorite, NSError *err)=^(TAGFavorite *favorite, NSError *err) {
        [self.parentViewController.tabBarController setSelectedIndex:2];
    };

    // Third: Auto favorite the piece on behalf of the user
    void(^favoritePiece)(TAGPiece *piece, NSError *err)=^(TAGPiece *piece, NSError *err){
        [[TAGPieceStore sharedStore] addUniquePiece:piece];

        TAGFavoriteStore *favoriteStore = [TAGFavoriteStore sharedStore];
        [favoriteStore createFavoriteForPiece:piece.id withCompletionBlock:returnToUserProfile];
    };

    // Second: Create suggestion
    void (^finishedGeocodingBlock)(NSMutableDictionary *pieceParams, NSError *err)=^(NSMutableDictionary *pieceParams, NSError *err) {
        // Add the remaining required selection params for server persistence
        [pieceParams setObject:[params objectForKey:@"title"] forKey:@"title"];
        [pieceParams setObject:[params objectForKey:@"canvas_type"] forKey:@"canvas_type"];
        [pieceParams setObject:self._S3ImageLocation forKey:@"image_url"];
        // Send this data to the server
        TAGPieceStore *store = [TAGPieceStore sharedStore];
        [store createPiece:pieceParams withCompletionBlock:favoritePiece];
    };

    // First: Reverse geocode
    void (^imageUploadedBlock)(NSURL *s3ImageLocation, NSError *err)=^(NSURL *s3ImageLocation, NSError *err) {
        if(!err){
            self._S3ImageLocation = s3ImageLocation;
            [self._headerCell reverseGeocodeUserLocationWithCompletionBlock:finishedGeocodingBlock];
        } else {
            [TAGErrorAlert render:err];
        }
    };

    // Begin: Save the suggested image to S3
    [pieceStore savePieceImage:self._photoData withCompletionBlock:imageUploadedBlock];
}

- (void)submitSuggestion:(NSMutableDictionary *)params {
    TAGSuggestionStore *suggestionStore = [TAGSuggestionStore sharedStore];

    // Fourth: Return to user's profile
    void (^returnToUserProfile)(TAGUpvote *upvote, NSError *err)=^(TAGUpvote *upvote, NSError *err) {
        [self.parentViewController.tabBarController setSelectedIndex:2];
    };

    // Third: Auto upvote the suggestion on behalf of the user
    void(^upvoteSuggestion)(TAGSuggestion *suugesstion, NSError *err)=^(TAGSuggestion *suggestion, NSError *err){
        [[TAGSuggestionStore sharedStore] addUniqueSuggestion:suggestion];

        TAGUpvoteStore *upvoteStore = [TAGUpvoteStore sharedStore];
        [upvoteStore createUpvoteForSuggestion:suggestion.id withCompletionBlock:returnToUserProfile];
    };

    // Second: Create suggestion
    void (^finishedGeocodingBlock)(NSMutableDictionary *suggestionParams, NSError *err)=^(NSMutableDictionary *suggestionParams, NSError *err) {
        // Add the remaining required selection params for server persistence
        [suggestionParams setObject:[params objectForKey:@"title"] forKey:@"title"];
        [suggestionParams setObject:[params objectForKey:@"canvas_type"] forKey:@"canvas_type"];
        [suggestionParams setObject:self._S3ImageLocation forKey:@"image_url"];
        // Send this data to the server
        TAGSuggestionStore *store = [TAGSuggestionStore sharedStore];
        [store createSuggestion:suggestionParams withCompletionBlock:upvoteSuggestion];
    };

    // First: Reverse geocode
    void (^imageUploadedBlock)(NSURL *s3ImageLocation, NSError *err)=^(NSURL *s3ImageLocation, NSError *err) {
        if(!err){
            self._S3ImageLocation = s3ImageLocation;
            [self._headerCell reverseGeocodeUserLocationWithCompletionBlock:finishedGeocodingBlock];
        } else {
            [TAGErrorAlert render:err];
        }
    };

    // Begin: Save the suggested image to S3
    [suggestionStore saveSuggestionImage:self._photoData withCompletionBlock:imageUploadedBlock];
}

- (NSMutableDictionary *)extractFormParams {
    NSMutableDictionary *params = [NSMutableDictionary new];

    NSString *title = [self._primaryCell.titleTextField text];
    [params setValue:title forKey:@"title"];

    NSString *contributionType = [self._primaryCell.contributionTypeSelect titleForSegmentAtIndex:self._primaryCell.contributionTypeSelect.selectedSegmentIndex];
    [params setValue:contributionType forKey:@"contribution_type"];

    NSString *canvasType = [self._primaryCell.canvasType titleForSegmentAtIndex:self._primaryCell.canvasType.selectedSegmentIndex];
    [params setValue:canvasType forKey:@"canvas_type"];

    return params;
}

- (void)submitContribution {
    if ([self validateForm]) {
        [self submitFormWithParams];
    }
}

- (void)submitFormWithParams {

    NSMutableDictionary *params = [self extractFormParams];
    __block TAGContributeViewController *_this = self;

    NSString *contributionType = [params objectForKey:@"contribution_type"];

    void (^selectedCase)() = @{
       @"Existing Piece" : ^{
           [_this submitPiece:params];
       },
       @"I Want Something Here" : ^{
           [_this submitSuggestion:params];
       }
       }[contributionType];

    if (selectedCase != nil) {
        selectedCase();
    }
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      return [collectionView cellForItemAtIndexPath:indexPath];
    }
    else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        self._headerCell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                              withReuseIdentifier:@"mapHeader"
                                                                     forIndexPath:indexPath];
        [self._headerCell addMapToCell];

        return self._headerCell;
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
