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

@interface ImageFilterController ()

@property (nonatomic, strong) UITableView *_filterOptionsTable;
@property (nonatomic, strong) UIImageView *_photoImageView;
@property (nonatomic, strong) NSArray *_filterOptions;
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
        self._filterOptions = @[
                               @{@"name": @"Filter A", @"image": @"filter_one.png"},
                               @{@"name": @"Filter B", @"image": @"filter_two.png"},
                               @{@"name": @"Filter C", @"image": @"filter_one.png"},
                               @{@"name": @"Filter D", @"image": @"filter_two.png"},
                               @{@"name": @"Filter E", @"image": @"filter_one.png"},
                               @{@"name": @"Filter F", @"image": @"filter_two.png"},
                               @{@"name": @"Filter G", @"image": @"filter_one.png"},
                               @{@"name": @"Filter H", @"image": @"filter_two.png"},
                               @{@"name": @"Filter I", @"image": @"filter_one.png"},
                               @{@"name": @"Filter J", @"image": @"filter_two.png"}
                               ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_postImage) {
        [self setTheImage:_postImage];
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
    return [self._filterOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGLateralTableViewCell *cell = [[TAGLateralTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTAGLateralTableViewCellIdentifier forCellDimension:self._cellDimension];

    if([tableView isEqual:self._filterOptionsTable]){
        UIImageView *backgroundImage = [UIImageView new];

        if ([self._filterOptions count] > 0) {
            NSDictionary *filter = [self._filterOptions objectAtIndex:[indexPath row]];
            NSString *image = [filter objectForKey:@"image"];

            UIImage *img = [UIImage imageNamed:image];
            [cell setArtImage:img];

            [backgroundImage setImage:img];
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
    GPUImageFilterGroup *groupFilter = [[GPUImageFilterGroup alloc]init];
    GPUImageSaturationFilter *saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:0.5];

    GPUImageMonochromeFilter *monochromeFilter = [[GPUImageMonochromeFilter alloc] init];
    [monochromeFilter setColor:(GPUVector4){0.0f, 0.0f, 1.0f, 1.0f}];
    [monochromeFilter setIntensity:0.2];

    GPUImageVignetteFilter *vignetteFilter = [[GPUImageVignetteFilter alloc] init];
    [vignetteFilter setVignetteEnd:0.7];

    GPUImageExposureFilter *exposureFilter = [[GPUImageExposureFilter alloc] init];
    [exposureFilter setExposure:0.3];

    // Note: Cascading target addition is required
    [saturationFilter addTarget: monochromeFilter];
    [monochromeFilter addTarget: vignetteFilter];
    [vignetteFilter addTarget: exposureFilter];

    [(GPUImageFilterGroup *) groupFilter setInitialFilters:[NSArray arrayWithObject: saturationFilter]];
    [(GPUImageFilterGroup *) groupFilter setTerminalFilter:exposureFilter];

    [groupFilter addFilter:saturationFilter];
    [groupFilter addFilter:monochromeFilter];
    [groupFilter addFilter:vignetteFilter];
    [groupFilter addFilter:exposureFilter];

    GPUImagePicture *stillImage= [[GPUImagePicture alloc]initWithImage:_postImage];
    [stillImage addTarget:groupFilter];
    [stillImage processImage];

    [groupFilter useNextFrameForImageCapture];

    UIImage *processedImage = [groupFilter imageFromCurrentFramebufferWithOrientation:self._photoImageView.image.imageOrientation];

    self._photoImageView.image = processedImage;
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
