//
//  TAGCollectionPresenterViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: Profile controls and tables/collections

#import "TAGProfileCollectionViewController.h"

#import "TAGPieceDetailViewController.h"
#import "TAGSuggestionDetailViewController.h"
#import "TAGViewHelpers.h"

// Components
#import "TAGCollectionView.h"
#import "TAGCollectionControls.h"
#import "TAGProfileTableSuggestionCell.h"
#import "TAGProfileTableFavoriteCell.h"
#import "TAGCollectionViewCell.h"

// Constants
#import "TAGComponentConstants.h"

// Pods
#import "URBMediaFocusViewController.h"


NSString *const kCollectionViewPresenter = @"CollectionView";
NSString *const kTableViewPresenter = @"TableView";

NSString *const kCollectionToggle = @"toggleCollection";
NSString *const kListToggle = @"toggleList";
NSString *const kSuggestionsToggle = @"toggleSuggestions";
NSString *const kFavoritesToggle = @"toggleFavorites";

@interface TAGProfileCollectionViewController ()

@property (nonatomic, strong) TAGCollectionControls *_collectionControls;
@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) UITableView *_tableView;

@property (nonatomic, strong) NSString *_presenterType;
@property (nonatomic, strong) UIScrollView *_scrollView;

@property (nonatomic, strong) NSString *_currentTableViewCellIdentifier;
@property (nonatomic, strong) URBMediaFocusViewController *_lightboxViewController;

@end

@implementation TAGProfileCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self._presenterType = kCollectionViewPresenter;
        self._currentTableViewCellIdentifier =kProfileTableSuggestionCellIdentifier;
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
    [self chooseCollectionPresenter:nil];
}

- (void)renderCollectionControls {
    __block TAGProfileCollectionViewController *_this = self;

    void(^actionBlock)(NSString *actionType)=^(NSString *actionType){
        __block TAGProfileCollectionViewController *presenterView = _this;
        void (^selectedCase)() = @{
           kCollectionToggle : ^{
               [presenterView chooseCollectionPresenter:kCollectionToggle];
           },
           kListToggle : ^{
               [presenterView chooseCollectionPresenter:kListToggle];
           },
           kSuggestionsToggle : ^{
               if ([self tableViewExists]) {
                   if ([self shouldToggleToCell:kProfileTableSuggestionCellIdentifier]) {
                       [self toggleTableViewCellsTo:kProfileTableSuggestionCellIdentifier];
                   }
               } else {
                   self._currentTableViewCellIdentifier = kProfileTableSuggestionCellIdentifier;
                   [self buildCollectionView];
                   NSLog(@"FILTER COLLECTION TO SUGGESTIONS!");
               }
           },
           kFavoritesToggle : ^{
               if ([self tableViewExists]) {
                   if ([self shouldToggleToCell:kProfileTableFavoriteCellIdentifier]) {
                       [self toggleTableViewCellsTo:kProfileTableFavoriteCellIdentifier];
                   }
               } else {
                   self._currentTableViewCellIdentifier = kProfileTableFavoriteCellIdentifier;
                   [self buildCollectionView];

                   NSLog(@"FILTER COLLECTION TO FAVORITES!");
               }
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

- (void)toggleTableViewCellsTo:(NSString *)identifier {
    self._currentTableViewCellIdentifier = identifier;
    [self buildListView];
}

- (BOOL)tableViewExists {
    return self._tableView != nil;
}

- (BOOL)collectionViewExists {
    return self._collectionView != nil;
}

- (BOOL)shouldToggleToCell:(NSString *)identifier {
    return ![self._tableView isHidden] && self._currentTableViewCellIdentifier != identifier;
}

- (BOOL)shouldToggleToList:(NSString *)identifier {
    return ![self._collectionView isHidden] && self._currentTableViewCellIdentifier != identifier;
}

- (void)chooseCollectionPresenter:(NSString *)presenterType {
    if (presenterType == nil || presenterType == kCollectionToggle) {
        [self buildCollectionView];
    } else if (presenterType == kListToggle) {
        [self buildListView];
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

- (void)buildListView {
    [self removeCollectionAndTable];

    self._tableView = [[UITableView alloc] initWithFrame:self._scrollView.bounds];
    [self._tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:self._currentTableViewCellIdentifier];
    self._tableView.delegate = self;
    self._tableView.dataSource = self;
    self._tableView.alwaysBounceVertical = NO;
    self._tableView.scrollEnabled = YES;
    self._tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self._tableView.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    self._tableView.separatorColor = [UIColor clearColor];
    [self._tableView setBackgroundColor:[UIColor whiteColor]];

    [self._scrollView addSubview:self._tableView];
    NSLog(@"VIEW COUNT %ld", [[self.view subviews]count]);
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self._currentTableViewCellIdentifier isEqual:kProfileTableSuggestionCellIdentifier]) {
        TAGProfileTableSuggestionCell *cell = (TAGProfileTableSuggestionCell *)[tableView dequeueReusableCellWithIdentifier:kProfileTableSuggestionCellIdentifier];

        if([tableView isEqual:self._tableView]){
            cell = [[TAGProfileTableSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileTableSuggestionCellIdentifier];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        return cell;
    } else {
        TAGProfileTableFavoriteCell *cell = (TAGProfileTableFavoriteCell *)[tableView dequeueReusableCellWithIdentifier:kProfileTableFavoriteCellIdentifier];

        if([tableView isEqual:self._tableView]){
            // Cell should accept the appropriate model which it will use to pull off the attrs
            cell = [[TAGProfileTableFavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileTableFavoriteCellIdentifier forModel:@{}];

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kProfileTableRowHeight;
}

// hook into the didSelectRowAtIndexPath to instantiate a DetailViewController and push it atop the stack
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //  Init the detail view controller
    if ([self._currentTableViewCellIdentifier isEqual:kProfileTableSuggestionCellIdentifier]) {
        TAGSuggestionDetailViewController *suggestionDetailController = [[TAGSuggestionDetailViewController alloc]init];
        [[self navigationController] pushViewController:suggestionDetailController animated:YES];

    } else {
        TAGPieceDetailViewController *pieceDetailViewController = [[TAGPieceDetailViewController alloc]init];
        [[self navigationController] pushViewController:pieceDetailViewController animated:YES];
    }
//TODO Find the selection from the associated store per touch
//    NSArray *allObjects = [[TAGCurretnStore sharedStore] allObjects];
//    TAGObject *selection = [allObjects objectAtIndex:[indexPath row]];
//    [tagDetailViewController setViewWithSelection:selection];

}

- (void)buildCollectionView {
    [self removeCollectionAndTable];

    self._collectionView = [[TAGCollectionView alloc]initWithFrame:self._scrollView.bounds collectionViewLayout:[self buildCollectionViewCellLayout]];

    [self._collectionView registerClass:[TAGCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
    [self._collectionView setBackgroundColor:[UIColor whiteColor]];


    // Custom cell here identifier here
    [self._collectionView setDelegate:self];
    [self._collectionView setDataSource:self];

    [self._scrollView addSubview:self._collectionView];
    NSLog(@"VIEW COUNT %ld", [[self.view subviews]count]);
}

- (void)removeCollectionAndTable {
    self._collectionView = nil;
    self._tableView = nil;
}

- (void)show:(UIView *)showView andHide:(UIView *)hideView {
    [self._scrollView bringSubviewToFront:showView];
    [showView setHidden:NO];
    [hideView setHidden:YES];
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
    TAGCollectionViewCell *cell = (TAGCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];

    // TODO: Visual differentiatior to be replaced by varied data type retrieval
    UIImageView *backgroundImage = [UIImageView new];
    if([self._currentTableViewCellIdentifier isEqual:kProfileTableSuggestionCellIdentifier]) {
        UIImage *image = [UIImage imageNamed:@"ape_do_good_printing_SF.png"];
        cell.image = image;
        [backgroundImage setImage:cell.image];
    } else {
        UIImage *image = [UIImage imageNamed:@"open_arms_SF.png"];
        cell.image = image;
        [backgroundImage setImage:cell.image];
    }

    [cell setBackgroundView:backgroundImage];
    [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self._lightboxViewController = [[URBMediaFocusViewController alloc] initWithNibName:nil bundle:nil];
    self._lightboxViewController.shouldDismissOnImageTap = YES;
    self._lightboxViewController.shouldShowPhotoActions = YES;

    TAGCollectionViewCell *targetCell = (TAGCollectionViewCell *)[self._collectionView cellForItemAtIndexPath:indexPath];

    [self._lightboxViewController showImage:targetCell.image fromView:targetCell];
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
