//
//  TAGCollectionPresenterViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGCollectionPresenterViewController.h"
#import "TAGCollectionControls.h"
#import "TAGCollectionView.h"

NSString *const kCollectionViewPresenter = @"CollectionView";
NSString *const kTableViewPresenter = @"TableView";

NSString *const kCollectionToggle = @"toggleCollection";
NSString *const kListToggle = @"toggleList";
NSString *const kSuggestionsToggle = @"toggleSuggestions";
NSString *const kFavoritesToggle = @"toggleFavorites";

static NSString *kCollectionViewCellIdentifier = @"CollectionCell";

@interface TAGCollectionPresenterViewController ()

@property (nonatomic, strong) TAGCollectionControls *_collectionControls;
@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) NSString *_presenterType;
@property (nonatomic, strong) UIScrollView *_scrollView;

@end

@implementation TAGCollectionPresenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self._presenterType = kCollectionViewPresenter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self renderCollectionControls];
    [self renderScrollView];
    [self chooseCollectionPresenter];
}

- (void)renderCollectionControls {
    void(^actionBlock)(NSString *actionType)=^(NSString *actionType){
        void (^selectedCase)() = @{
           kCollectionToggle : ^{
               NSLog(kCollectionToggle);
           },
           kListToggle : ^{
               NSLog(kListToggle);
           },
           kSuggestionsToggle : ^{
               NSLog(kSuggestionsToggle);
           },
           kFavoritesToggle : ^{
               NSLog(kFavoritesToggle);
           },
           }[actionType];

        if (selectedCase != nil) {
            selectedCase();
        }
    };
    NSArray *callbackNames = @[kCollectionToggle, kListToggle, kSuggestionsToggle, kFavoritesToggle];

    self._collectionControls = [[TAGCollectionControls alloc]initWithFrame:CGRectMake(0.0f,
                                                                                      0.0f,
                                                                                      self.view.frame.size.width,
                                                                                      50.0f)
                                                                forActions:callbackNames
                                                                 withBlock:actionBlock];
    [self.view addSubview:self._collectionControls];
}

- (void)chooseCollectionPresenter {
    // Trigger this on controls tap - pass a block into the control function that will trigger this method
    if (self._presenterType == kCollectionViewPresenter) {
        // Generate the collection view
        [self buildCollectionView];
    } else {
        // Generate the table view
    }
}

- (void)renderScrollView {
    float scrollYCoord = CGRectGetMaxY(self._collectionControls.bounds);
    self._scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f,
                                                                      scrollYCoord,
                                                                      self.view.frame.size.width,
                                                                      330.0f)];
    self._scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self._scrollView.delegate = self;
    self._scrollView.bounces = NO;

    [self.view addSubview:self._scrollView];
}

- (void)buildCollectionView {
    self._collectionView = [[TAGCollectionView alloc]initWithFrame:self._scrollView.bounds collectionViewLayout:[self buildCollectionViewCellLayout]];

    [self._collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    [self._collectionView setBackgroundColor:[UIColor whiteColor]];

    // Custom cell here identifier here
    [self._collectionView setDelegate:self];
    [self._collectionView setDataSource:self];

    [self._scrollView addSubview:self._collectionView];
}

- (UICollectionViewFlowLayout *)buildCollectionViewCellLayout {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.itemSize = CGSizeMake(102.5f,102.5f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(2.5f, 0.0f, 2.5f, 0.0f);

    return flowLayout;
}

#pragma UICollectionView Protocol Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [self._suggestions count]
    return 18;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];

    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ape_do_good_printing_SF.png"]];

    [cell setBackgroundView:backgroundImage];
    [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected cell number %@", indexPath);
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
