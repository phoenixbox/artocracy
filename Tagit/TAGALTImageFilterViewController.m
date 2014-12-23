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

@end

@implementation TAGALTImageFilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Update this to be the remainder value
        self._cellDimension = 60.f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self renderFilterOptionsTable];
    [_sliderView setHidden:YES];

    if (_postImage) {
        [self.filterImageView setImage:_postImage];

        TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
        [filterStore generateFiltersForImage:_postImage];
    }
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
    [self._filterOptionsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTAGLateralTableViewCellIdentifier];
    self._filterOptionsTable.delegate = self;
    self._filterOptionsTable.dataSource = self;
    self._filterOptionsTable.alwaysBounceVertical = NO;
    self._filterOptionsTable.scrollEnabled = YES;
    self._filterOptionsTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    self._filterOptionsTable.separatorColor = [UIColor whiteColor];

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

    TAGLateralTableViewCell *cell = [[TAGLateralTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTAGLateralTableViewCellIdentifier forCellDimension:self._cellDimension];

    if([tableView isEqual:self._filterOptionsTable]){
        UIImageView *backgroundImage = [UIImageView new];

        if ([[filterStore allFilters] count] > 0) {
            NSDictionary *filteredDict = [[filterStore allFilters] objectAtIndex:[indexPath row]];
            UIImage *image = [filteredDict objectForKey:@"filteredImage"];

            // Set the image reference on the cell then update the el's native background view
            [cell setArtImage:image];
            [backgroundImage setImage:image];
        }
        [cell setBackgroundView:backgroundImage];

        // Rotate the image in the cell
        [TAGViewHelpers rotate90Clockwise:cell.backgroundView];
        [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self._cellDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
    NSDictionary *targetFilter = [filterStore.allFilters objectAtIndex:[indexPath row]];

    _filterImageView.image = [targetFilter objectForKey:@"filteredImage"];
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
