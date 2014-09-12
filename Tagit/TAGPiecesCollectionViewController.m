//
//  TAGPiecesCollectionViewController.m
//  Tagit
//
//  Created by Shane Rogers on 9/7/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGPiecesCollectionViewController.h"

#import "TAGCollectionView.h"
#import "TAGCollectionViewCell.h"
#import "TAGPieceCell.h"

// Constants
#import "TAGComponentConstants.h"

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self buildCollectionView];
}


- (void)buildCollectionView {
    self._collectionView = [[TAGCollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:[self buildCollectionViewCellLayout]];

    UINib *cell = [UINib nibWithNibName:@"TAGPieceCell" bundle:nil];
    [self._collectionView registerNib:cell forCellWithReuseIdentifier:@"cell"];

    [self._collectionView setBackgroundColor:[UIColor whiteColor]];


    // Custom cell here identifier here
    [self._collectionView setDelegate:self];
    [self._collectionView setDataSource:self];

    [self.view addSubview:self._collectionView];
    NSLog(@"VIEW COUNT %ld", [[self.view subviews]count]);
}

- (UICollectionViewFlowLayout *)buildCollectionViewCellLayout {
    UICollectionViewFlowLayout *flowLayout = [CSStickyHeaderFlowLayout new];
    flowLayout.itemSize = CGSizeMake(320.0f,80.0f);
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.sectionInset = UIEdgeInsetsMake(2.5f, 0.0f, 2.5f, 0.0f);

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

    NSDictionary *obj = self._sections[indexPath.section];

    // Just identifiers for views
    TAGPieceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                             forIndexPath:indexPath];

    cell.textLabel.text = [[obj allValues] firstObject];

    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//        NSDictionary *obj = self._sections[indexPath.section];
//
//        TAGPieceCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                          withReuseIdentifier:@"cell"
//                                                                 forIndexPath:indexPath];
//
//        cell.textLabel.text = [[obj allKeys] firstObject];
//
//        return cell;
//    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
//        // JUST the parallax header view - i.e. the Map/Search Bar etc
//        //        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//        //                                                                            withReuseIdentifier:@"header"
//        //                                                                                   forIndexPath:indexPath];
//
//        return [collectionView cellForItemAtIndexPath:indexPath];
//    }
//    return nil;
//}


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
