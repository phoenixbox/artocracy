//
//  ImageFilterController.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-21.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "ImageFilterController.h"

// Components
#import "TAGLateralTableViewCell.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGComponentConstants.h"
#import "TAGViewHelpers.h"

// GPUImage Imports
#import "GPUImageMonochromeFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageView.h"
#import "GPUImagePicture.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageVignetteFilter.h"
#import "GPUImageExposureFilter.h"
#import "GPUImageFilterGroup.h"
#import "GPUImageGrayscaleFilter.h"
#import "GPUImageAlphaBlendFilter.h"

// If just using the reference images we dont need the other filter imports
#import "GPUImageLookupFilter.h"

// Data Layer
#import "TAGFiltersStore.h"

@interface ImageFilterController ()

@property (nonatomic, strong) UITableView *_filterOptionsTable;
@property (nonatomic, strong) UIImageView *_photoImageView;
@property (nonatomic, strong) NSMutableArray *_filterOptions;
//@property (nonatomic, strong) NSMutableArray *_filterNames;

@property (nonatomic, assign) float _cellDimension;

@end

@implementation ImageFilterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        [self.view setBackgroundColor:[UIColor blackColor]];
        self._cellDimension = 60.f;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (_postImage) {
        [self setTheImage:_postImage];

        TAGFiltersStore *filterStore = [TAGFiltersStore sharedStore];
        [filterStore generateFiltersForImage:_postImage];
    }

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, self.view.frame.size.height - 40, 80, 40);
    [backBtn setTitle:@"back" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self renderFilterOptionsTable];
}

- (void)setTheImage:(UIImage *)image {
    self._photoImageView = [[UIImageView alloc] initWithImage:image];
    self._photoImageView.clipsToBounds = YES;
    self._photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self._photoImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    self._photoImageView.center = self.view.center;
    [self.view addSubview:self._photoImageView];
}

- (void)renderFilterOptionsTable {
    self._filterOptionsTable = [UITableView new];

    UIImageView *imageView = [UIImageView new];
    imageView.image = _postImage;

    float yCoord = CGRectGetMaxY(self._photoImageView.frame) + kSmallPadding;

    CGRect piecesRect = CGRectMake(0.0f, yCoord, 320.0f, self._cellDimension);

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

    self._photoImageView.image = [targetFilter objectForKey:@"filteredImage"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}






@end
