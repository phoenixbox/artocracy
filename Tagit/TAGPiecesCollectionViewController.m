//
//  TAGPiecesCollectionViewController.m
//  Tagit
//
//  Created by Shane Rogers on 9/7/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: Index page with sticky header cells

#import "TAGPiecesCollectionViewController.h"

#import "TAGCollectionView.h"
#import "TAGCollectionViewCell.h"
#import "TAGPieceCell.h"

// Constants
#import "TAGComponentConstants.h"
#import "TAGStyleConstants.h"

// Pods
#import "CSStickyHeaderFlowLayout.h"

@interface TAGPiecesCollectionViewController ()

@property (nonatomic, strong) NSArray *_sections;
@property (nonatomic, strong) TAGCollectionView *_collectionView;

@end

@implementation TAGPiecesCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self._sections = @[
          @{@"Twitter":@"http://twitter.com"},
          @{@"Facebook":@"http://facebook.com"},
          @{@"Tumblr":@"http://tumblr.com"},
          @{@"Pinterest":@"http://pinterest.com"},
          @{@"Instagram":@"http://instagram.com"},
          @{@"Github":@"http://github.com"},
      ];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAppearance];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self buildCollectionView];
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
    UIImage *filterImage = [UIImage imageNamed:@"filterIcon.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:filterImage landscapeImagePhone:filterImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleFilter)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)setHeaderLogo {
    [[self navigationItem] setTitleView:nil];
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 165.0f, 32.5f)];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"art_navBarLogo.png"];
    [logoView setImage:logoImage];
    self.navigationItem.titleView = logoView;
}

- (void)toggleFilter {
}


- (void)buildCollectionView {
    self._collectionView = [[TAGCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:[self buildCollectionViewCellLayout]];

    UINib *cell = [UINib nibWithNibName:@"TAGPieceCell" bundle:nil];
    [self._collectionView registerNib:cell forCellWithReuseIdentifier:@"cell"];

    UINib *headerNib = [UINib nibWithNibName:@"TAGPieceSectionHeader" bundle:nil];
    [self._collectionView registerNib:headerNib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];

    [self._collectionView setBackgroundColor:[UIColor whiteColor]];

    [self._collectionView setDelegate:self];
    [self._collectionView setDataSource:self];

    [self.view addSubview:self._collectionView];
    NSLog(@"VIEW COUNT %ld", [[self.view subviews]count]);
}

- (UICollectionViewFlowLayout *)buildCollectionViewCellLayout {
    UICollectionViewFlowLayout *flowLayout = [CSStickyHeaderFlowLayout new];
    // NOTE: Important to match the dimensions in the xib
    flowLayout.itemSize = CGSizeMake(320.0f,80.0f);
    flowLayout.headerReferenceSize = CGSizeMake(0.0f,50.0f);

    return flowLayout;
}

/////////////////////// Sticky

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self._sections count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Just identifiers for views
    TAGPieceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                   forIndexPath:indexPath];

    NSDictionary *obj = self._sections[indexPath.section];
    cell.textLabel.text = [[obj allValues] firstObject];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {

        TAGPieceCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                withReuseIdentifier:@"sectionHeader"
                                                                       forIndexPath:indexPath];

        NSDictionary *obj = self._sections[indexPath.section];
        cell.textLabel.text = [[obj allKeys] firstObject];

        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        return [collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}


//////////////////////////////
//#pragma UICollectionView Protocol Methods
//
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 18;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    TAGCollectionViewCell *cell = (TAGCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
//
//    // TODO: Visual differentiatior to be replaced by varied data type retrieval
//    UIImageView *backgroundImage = [UIImageView new];
//
//    UIImage *image = [UIImage imageNamed:@"ape_do_good_printing_SF.png"];
//    cell.image = image;
//    [backgroundImage setImage:cell.image];
//
//    [cell setBackgroundView:backgroundImage];
//    [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];
//    return cell;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"Cell selected");
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

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
