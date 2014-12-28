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

// Data Layer
#import "TAGFiltersStore.h"

@interface TAGALTImageFilterViewController ()

@property (nonatomic, strong) UITableView *_filterOptionsTable;
@property (nonatomic, assign) float _cellDimension;
@property (nonatomic, strong) UILongPressGestureRecognizer *imageViewLongPress;
@property (nonatomic, strong) UIImage *_cachedImage;

@end

@implementation TAGALTImageFilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._cellDimension = CGRectGetMaxY(self.view.frame) - CGRectGetMaxY(_adjustmentsView.frame);
    [self renderFilterOptionsTable];

    [self hideAndRaiseSliderView];

    if (_postImage) {
        [self.filterImageView setImage:_postImage];

        TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
        [filterStore generateFiltersForImage:_postImage];

        [self addFilterImageViewTappedHandler];
    }
}

- (void)listenForChange {
}

- (void)addFilterImageViewTappedHandler {
    self.imageViewLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOriginalImage:)];

    self.imageViewLongPress.numberOfTouchesRequired = 1;

    self.imageViewLongPress.allowableMovement = 100.0f;
    self.imageViewLongPress.minimumPressDuration = 0.1; /* Add this gesture recognizer to our view */

    [self.view addGestureRecognizer:self.imageViewLongPress];
}

- (void)toggleOriginalImage:(UILongPressGestureRecognizer *)recognizer {
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

- (void)hideAndRaiseSliderView {
    [_sliderView setHidden:YES];
    [self.view bringSubviewToFront:_sliderView];
}

- (void)renderFilterOptionsTable {
    self._filterOptionsTable = [UITableView new];

    UIImageView *imageView = [UIImageView new];
    imageView.image = _postImage;

    CGRect piecesRect = CGRectMake(0.0f, CGRectGetMaxY(_adjustmentsView.frame), CGRectGetMaxX(self.view.frame), self._cellDimension);

    self._filterOptionsTable = [[UITableView alloc] initWithFrame:piecesRect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI_2);
    [self._filterOptionsTable setTransform:rotate];
    // VIP: Must set the frame again on the table after rotation
    [self._filterOptionsTable setFrame:piecesRect];
    [self._filterOptionsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTAGFilterTableViewCellIdentifier];
    self._filterOptionsTable.delegate = self;
    self._filterOptionsTable.dataSource = self;
    self._filterOptionsTable.alwaysBounceVertical = NO;
    self._filterOptionsTable.scrollEnabled = YES;
    self._filterOptionsTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    [self._filterOptionsTable setSeparatorColor:[UIColor clearColor]];

    [self._filterOptionsTable setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self._filterOptionsTable];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];

    return [[filterStore allFilters] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];

    // Load the custom xib
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:kTAGFilterTableViewCellIdentifier owner:nil options:nil];
    TAGFilterTableViewCell *cell = [nibContents lastObject];

    if([tableView isEqual:self._filterOptionsTable]){
        UIImageView *backgroundImage = [UIImageView new];

        if ([[filterStore allFilters] count] > 0) {
            NSDictionary *filteredDict = [[filterStore allFilters] objectAtIndex:[indexPath row]];
            [cell updateWithAttributes:filteredDict];
        }
        [cell setBackgroundView:backgroundImage];

        // Rotate the image in the cell
        [TAGViewHelpers rotate90Clockwise:cell.backgroundView];
        [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        if ([indexPath row] > 0) {
            [cell.selectionIndicator setHidden:YES];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

// NOTE: Auto select the first cell so we can trigger removal of the selection indicator on first alternate row selection
- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self._filterOptionsTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
    NSDictionary *targetFilter = [filterStore.allFilters objectAtIndex:[indexPath row]];
    TAGFilterTableViewCell *cell = (TAGFilterTableViewCell *)[self._filterOptionsTable cellForRowAtIndexPath:indexPath];

    [cell.selectionIndicator setHidden:NO];

    _filterImageView.image = [targetFilter objectForKey:@"filteredImage"];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGFilterTableViewCell *cell = (TAGFilterTableViewCell *)[self._filterOptionsTable cellForRowAtIndexPath:indexPath];

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
    NSLog(@"revealFilters");
//    if filters table is hidden then show it ()
}

- (IBAction)revealBrightness:(id)sender {
    NSLog(@"revealBrightness");
}

- (IBAction)revealTools:(id)sender {
    NSLog(@"revealAdjustments");
//    if tools table is hidden then show it (): reference the profile collection view controller
}

- (IBAction)sliding:(id)sender {
    NSLog(@"Slider value %f", [_slider value]);
}

- (IBAction)cancelAdjustment:(id)sender {
    NSLog(@"cancelAdjustment");
    [_sliderView setHidden:YES];
}

- (IBAction)saveAdjustment:(id)sender {
    NSLog(@"saveAdjustment");
    [_sliderView setHidden:YES];
}

@end
