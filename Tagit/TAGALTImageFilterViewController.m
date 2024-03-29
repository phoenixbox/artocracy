//
//  TAGALTImageFilterViewController.m
//  Tagit
//
//  Created by Shane Rogers on 12/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGALTImageFilterViewController.h"

// Components
#import "TAGLateralTableViewCell.h"
#import "TAGFilterTableViewCell.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGComponentConstants.h"
#import "TAGViewHelpers.h"

// If just using the reference images we dont need the other filter imports
#import "GPUImageLookupFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageBrightnessFilter.h"

// Data Layer
#import "TAGFiltersStore.h"

NSString *const kFiltersTable = @"filtersTable";
NSString *const kToolsTable = @"toolsTable";

@interface TAGALTImageFilterViewController ()

@property (nonatomic, strong) UITableView *_lateralTable;
@property (nonatomic, assign) float _cellDimension;
@property (nonatomic, strong) UILongPressGestureRecognizer *imageViewLongPress;
@property (nonatomic, strong) UIImage *_cachedImage;
@property (nonatomic, strong) NSString *_currentTableType;
@property (nonatomic, strong) NSString *_selectedToolType;
@property (nonatomic, strong) NSMutableDictionary *_sliderValues;

@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *filter;

@end

@implementation TAGALTImageFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    if (self) {
        self._currentTableType = kFiltersTable;

        self._sliderValues = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                              nil, [NSNumber numberWithInt: ART_ADJUST],
                              nil, [NSNumber numberWithInt: ART_BRIGHTNESS],
                              nil, [NSNumber numberWithInt: ART_CONTRAST],
                              nil, [NSNumber numberWithInt: ART_HIGHLIGHTS],
                              nil, [NSNumber numberWithInt: ART_SHADOWS],
                              nil, [NSNumber numberWithInt: ART_SATURATION],
                              nil, [NSNumber numberWithInt: ART_VIGNETTE],
                              nil, [NSNumber numberWithInt: ART_WARMTH],
                              nil, [NSNumber numberWithInt: ART_TILTSHIFT],
                              nil, [NSNumber numberWithInt: ART_SHARPEN], nil];

    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._cellDimension = CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(_adjustmentsView.frame);
    [self renderLateralTable];

    [self hideAndLowerSliderView];

    if (_postImage) {
        [self.filterImageView setImage:_postImage];

        TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
        [filterStore generateFiltersForImage:_postImage];

        TAGToolsStore *toolStore = [TAGToolsStore sharedStore];
        [toolStore generateToolOptions];

        [self addFilterImageViewEventHandlers];
    }
}

- (void)addFilterImageViewEventHandlers {
    self.imageViewLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOriginalImage:)];
    self.imageViewLongPress.numberOfTouchesRequired = 1;
    self.imageViewLongPress.allowableMovement = 100.0f;
    self.imageViewLongPress.minimumPressDuration = 0.075; /* Add this gesture recognizer to our view */

    [self.filterImageView addGestureRecognizer:self.imageViewLongPress];
    // NOTE: Must set interaction true so that the gesture can be triggered. Dont have to have selector on the filter ImageView
    self.filterImageView.userInteractionEnabled = YES;
}

- (void)toggleOriginalImage:(UIGestureRecognizer *)recognizer {
    UIGestureRecognizerState state = [recognizer state];
    
    if (state == UIGestureRecognizerStateBegan) {
        // Cache the last stateful image
        self._cachedImage = [self.filterImageView image];
        // Show the original
        [self.filterImageView setImage:_postImage];
    } else if (state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateFailed || state == UIGestureRecognizerStateEnded) {
        // Reset the imageView with the cached image
        [self.filterImageView setImage:self._cachedImage];
    }
}

- (void)hideAndLowerSliderView {
    [_sliderView setHidden:YES];
    [self.view sendSubviewToBack:_sliderView];
}

- (void)showAndRaiseSliderView {
    [_sliderView setHidden:NO];
    [self.view bringSubviewToFront:_sliderView];
}

- (void)toggleTableViewCellsTo:(NSString *)identifier {
    self._currentTableType = identifier;
    self._lateralTable = nil;

    [self renderLateralTable];
}

- (void)renderLateralTable {
    self._lateralTable = [UITableView new];

    CGRect piecesRect = CGRectMake(0.0f, CGRectGetMaxY(_adjustmentsView.frame), CGRectGetMaxX(self.view.frame), self._cellDimension);

    self._lateralTable = [[UITableView alloc] initWithFrame:piecesRect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI_2);
    [self._lateralTable setTransform:rotate];
    // VIP: Must set the frame again on the table after rotation
    [self._lateralTable setFrame:piecesRect];
    [self._lateralTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTAGFilterTableViewCellIdentifier];
    self._lateralTable.delegate = self;
    self._lateralTable.dataSource = self;
    self._lateralTable.alwaysBounceVertical = NO;
    self._lateralTable.scrollEnabled = YES;
    self._lateralTable.showsVerticalScrollIndicator = NO;
    self._lateralTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    [self._lateralTable setSeparatorColor:[UIColor clearColor]];

    [self._lateralTable setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self._lateralTable];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isFiltersTable]) {
        TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];

        return [[filterStore allFilters] count];
    } else if ([self isToolsTable]) {
        TAGToolsStore *toolStore = [TAGToolsStore sharedStore];

        return [[toolStore allTools] count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
    TAGToolsStore *toolStore = [TAGToolsStore sharedStore];

    // Load the custom xib
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:kTAGFilterTableViewCellIdentifier owner:nil options:nil];
    TAGFilterTableViewCell *cell = [nibContents lastObject];

    if([tableView isEqual:self._lateralTable]){

        if ([self isFiltersTable]) {
            NSDictionary *attributes = [[filterStore allFilters] objectAtIndex:[indexPath row]];

            [cell setCellImage:[attributes objectForKey:@"blurredImage"]];
            [cell setOverlayImage:[attributes objectForKey:@"overlay"]];
            [cell setCellLabel:[attributes objectForKey:@"filterName"]];

        } else if ([self isToolsTable]) {
            NSDictionary *attributes = [[toolStore allTools] objectAtIndex:[indexPath row]];

            NSString *toolType = [attributes objectForKey:@"toolName"];

            [cell setCellImage:[attributes objectForKey:@"toolIcon"]];
            [cell setCellLabel:toolType];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        if ([indexPath row] > 0) {
            [cell.selectionIndicator setHidden:YES];
        }
    }
    return cell;
}

- (BOOL)isFiltersTable {
    return [self._currentTableType isEqual:kFiltersTable];
}

- (BOOL)isToolsTable {
    return [self._currentTableType isEqual:kToolsTable];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width/4.5;
}

// NOTE: Auto select the first cell so we can trigger removal of the selection indicator on first alternate row selection
- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self._lateralTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGFilterTableViewCell *cell = (TAGFilterTableViewCell *)[self._lateralTable cellForRowAtIndexPath:indexPath];
    [cell.selectionIndicator setHidden:NO];

    if ([self isFiltersTable]) {
        TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
        NSDictionary *targetFilter = [filterStore.allFilters objectAtIndex:[indexPath row]];

        _filterImageView.image = [targetFilter objectForKey:@"filteredImage"];
    } else if ([self isToolsTable]) {
        // Update the cached image
        self._cachedImage = [self.filterImageView image];

        filterType = (ARTToolType)indexPath.row;

        [TAGToolsStore setupSlider:self.slider forFilterType:(ARTToolType)indexPath.row];

        float lastValue = [[self._sliderValues objectForKey:[NSNumber numberWithInt:filterType]] floatValue];

        if (lastValue != 0) { // If last value is nil
            [self.slider setValue:lastValue];
        }

        [self showAndRaiseSliderView];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGFilterTableViewCell *cell = (TAGFilterTableViewCell *)[self._lateralTable cellForRowAtIndexPath:indexPath];

    [cell.selectionIndicator setHidden:YES];
}

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
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goNext:(id)sender {
    NSLog(@"goNext");
}

- (IBAction)revealFilters:(id)sender {
    if (![self isFiltersTable]) {
        [self toggleTableViewCellsTo:kFiltersTable];
    } else {
        NSLog(@"Filters already set");
    }
}

- (IBAction)revealBrightness:(id)sender {
    NSLog(@"revealBrightness");
}

- (IBAction)revealTools:(id)sender {
    if (![self isToolsTable]) {
        [self toggleTableViewCellsTo:kToolsTable];
    } else {
        NSLog(@"Tools already set");
    }
}

- (IBAction)sliding:(id)sender {
    float sliderValue = (float)[(UISlider *)sender value];
    [self._sliderValues setObject:[NSNumber numberWithFloat:sliderValue] forKey:[NSNumber numberWithInt:filterType]];

    // Note: initialize the source with a cached instance of the image :)
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:self._cachedImage];

    switch (filterType)
    {
        case ART_ADJUST: {
            self.filter = [GPUImageTransformFilter new];
            [(GPUImageTransformFilter *)self.filter setAffineTransform:CGAffineTransformMakeRotation(sliderValue)];
        }; break;
        case ART_BRIGHTNESS: {
            self.filter = [GPUImageBrightnessFilter new];
            [(GPUImageBrightnessFilter *)self.filter setBrightness:sliderValue];
        }; break;
        case ART_CONTRAST: {
            self.filter = [GPUImageContrastFilter new];
            [(GPUImageContrastFilter *)self.filter setContrast:sliderValue];
        }; break;
        case ART_HIGHLIGHTS: {
            self.filter = [GPUImageHighlightShadowFilter new];
            [(GPUImageHighlightShadowFilter *)self.filter setHighlights:[(UISlider *)sender value]];
        }; break;
        case ART_SHADOWS: {
            self.filter = [GPUImageHighlightShadowFilter new];
            [(GPUImageHighlightShadowFilter *)self.filter setShadows:[(UISlider *)sender value]];
        }; break;
        case ART_SATURATION: {
            self.filter = [GPUImageSaturationFilter new];
            [(GPUImageSaturationFilter *)self.filter setSaturation:sliderValue];
        }; break;
        case ART_VIGNETTE: {
            self.filter = [GPUImageVignetteFilter new];
//            self.vignetteStart = 0.3;
//            self.vignetteEnd = 0.75;
            [(GPUImageVignetteFilter *)self.filter setVignetteStart:0.35];
            [(GPUImageVignetteFilter *)self.filter setVignetteEnd:1.4-sliderValue];
        }; break;
        case ART_WARMTH: {
            self.filter = [GPUImageWhiteBalanceFilter new];
            [(GPUImageWhiteBalanceFilter *)self.filter setTemperature:sliderValue];
        }; break;
        case ART_TILTSHIFT: {
            self.filter = [[GPUImageTiltShiftFilter alloc] init];
            [(GPUImageTiltShiftFilter *)self.filter setTopFocusLevel:0.4];
            [(GPUImageTiltShiftFilter *)self.filter setBottomFocusLevel:0.6];
            [(GPUImageTiltShiftFilter *)self.filter setFocusFallOffRate:0.2];

            [(GPUImageTiltShiftFilter *)self.filter setTopFocusLevel:sliderValue - 0.1];
            [(GPUImageTiltShiftFilter *)self.filter setBottomFocusLevel:sliderValue + 0.1];
        }; break;
        case ART_SHARPEN: {
            self.filter = [GPUImageSharpenFilter new];
            [(GPUImageSharpenFilter *)self.filter setSharpness:sliderValue];
        }; break;
        default: break;
    }

    [stillImageSource addTarget:self.filter];
    [self.filter useNextFrameForImageCapture];
    [stillImageSource processImage];

    _filterImageView.image = [self.filter imageFromCurrentFramebuffer];;
}

- (IBAction)cancelAdjustment:(id)sender {
    NSLog(@"cancelAdjustment");
    [self.sliderView setHidden:YES];
}

- (IBAction)saveAdjustment:(id)sender {
    NSLog(@"saveAdjustment");
    [self.sliderView setHidden:YES];
}

@end
