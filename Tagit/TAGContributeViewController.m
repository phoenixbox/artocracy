//
//  TAGContributeViewController.m
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGContributeViewController.h"

#import "TAGCollectionView.h"
#import "TAGSuggestionCell.h"

// Helpers
#import "TAGViewHelpers.h"

// Constants
#import "TAGStyleConstants.h"

// Pods
#import "CSStickyHeaderFlowLayout.h"

@interface TAGContributeViewController ()

@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) UINib *headerNib;

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

    CSStickyHeaderFlowLayout *layout = (id)self._collectionView.collectionViewLayout;

    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 100);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(320, 80); // Bigger shifts it up
    }
    // KNOW: think the header identifier here is specific to CSStickyHeaderParallaxHeader
    UINib *parallaxHeader = [UINib nibWithNibName:@"TAGSuggestionHeader" bundle:nil];
    [self._collectionView registerNib:parallaxHeader
          forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader
                 withReuseIdentifier:@"mapHeader"];
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
}
- (void)retakePhoto {
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
    // NOTE: Important to match the dimensions in the xib
    flowLayout.itemSize = CGSizeMake(320.0f,350.0f);
    flowLayout.headerReferenceSize = CGSizeMake(0.0f,40.0f);

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

    // Specify the cell identifier to be used
    TAGSuggestionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                   forIndexPath:indexPath];
    // Setup cells appropriately
    [cell setBackgroundColor:[UIColor whiteColor]];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
      return [collectionView cellForItemAtIndexPath:indexPath];
    }
    else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind                                                                            withReuseIdentifier:@"mapHeader" forIndexPath:indexPath];

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
