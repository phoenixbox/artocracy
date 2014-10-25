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
#import "TAGErrorAlert.h"

// Constants
#import "TAGComponentConstants.h"

// Pods
#import "URBMediaFocusViewController.h"

// Data Layer
#import "TAGSessionStore.h"
#import "TAGSuggestionStore.h"
#import "TAGSuggestionChannel.h"
#import "TAGPieceStore.h"
#import "TAGPieceChannel.h"
#import "TAGPiece.h"

NSString *const kCollectionViewPresenter = @"CollectionView";
NSString *const kTableViewPresenter = @"TableView";

NSString *const kCollectionToggle = @"toggleCollection";
NSString *const kListToggle = @"toggleList";
NSString *const kSuggestionsToggle = @"toggleSuggestions";
NSString *const kFavoritesToggle = @"toggleFavorites";

NSString *const kSuggestionsTabType = @"suggestionsTab";
NSString *const kFavoritesTabType = @"favoritesTab";

@interface TAGProfileCollectionViewController ()

@property (nonatomic, strong) TAGCollectionControls *_collectionControls;
@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) UITableView *_tableView;

@property (nonatomic, strong) NSString *_presenterType;
@property (nonatomic, strong) UIScrollView *_scrollView;

@property (nonatomic, strong) NSString *_currentTableViewCellIdentifier;
@property (nonatomic, strong) URBMediaFocusViewController *_lightboxViewController;

@property (nonatomic, strong) UIActivityIndicatorView *_activityIndicator;

@property (nonatomic, strong) TAGSuggestionChannel *_suggestionChannel;
@property (nonatomic, strong) TAGPieceChannel *_favoriteChannel;

@property (nonatomic, strong) NSString *_activeTabType;

@end

@implementation TAGProfileCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self._activeTabType = kSuggestionsTabType;
        self._presenterType = kCollectionViewPresenter;
        self._currentTableViewCellIdentifier = kProfileTableSuggestionCellIdentifier;
    }
    return self;
}

- (void)fetchSuggestionsData {
    NSLog(@"CURRENTLY: fetchSuggestionsData");

    self._activityIndicator = [TAGViewHelpers setActivityIndicatorForNavItem:[self navigationItem]];

    void(^completionBlock)(TAGSuggestionChannel *obj, NSError *err)=^(TAGSuggestionChannel *obj, NSError *err){
        if(!err){
            self._suggestionChannel = obj;
            [self removeEmptyCollectionMessage];
            [self._collectionView reloadData];
        } else {
            [TAGErrorAlert render:err];
        }
        [self._activityIndicator stopAnimating];
    };

    [[TAGSuggestionStore sharedStore] fetchSuggestionsWithCompletion:completionBlock];
}

- (void)fetchFavoritesData {
    self._activityIndicator = [TAGViewHelpers setActivityIndicatorForNavItem:[self navigationItem]];

    void(^completionBlock)(TAGPieceChannel *obj, NSError *err)=^(TAGPieceChannel *obj, NSError *err){
        if(!err){
            self._favoriteChannel = obj;
            [self removeEmptyCollectionMessage];
            [self._collectionView reloadData];
        } else {
            [TAGErrorAlert render:err];
        }
        [self._activityIndicator stopAnimating];
    };

    TAGSessionStore *sessionStore = [TAGSessionStore sharedStore];
    [[TAGPieceStore sharedStore] fetchFavoritesForUser:sessionStore.id WithCompletion:completionBlock];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];

    [self fetchDataForActiveTab];

    [self renderCollectionControls];
    [self renderScrollView];
    [self chooseCollectionPresenter:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self fetchDataForActiveTab];
}

- (void)fetchDataForActiveTab {
    void (^selectedCase)() = @{
       kSuggestionsTabType: ^{
        [self fetchSuggestionsData];
       },
       kFavoritesTabType: ^{
        [self fetchFavoritesData];
       }
    }[self._activeTabType];

    if (selectedCase != nil) {
        selectedCase();
    }
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
               self._activeTabType = kSuggestionsTabType;
               if ([self tableViewExists]) { // Table View
                   if ([self shouldToggleToCell:kProfileTableSuggestionCellIdentifier]) {
                       [self toggleTableViewCellsTo:kProfileTableSuggestionCellIdentifier];
                   }
               } else {                      // Collection View
                   self._currentTableViewCellIdentifier = kProfileTableSuggestionCellIdentifier;
                   [self buildCollectionView];
                   NSLog(@"FILTER COLLECTION TO SUGGESTIONS!");
               }
           },
           kFavoritesToggle : ^{
              self._activeTabType = kFavoritesTabType;
               if (self._favoriteChannel == nil) {
                   [self fetchFavoritesData];
               }

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

- (void)removeEmptyCollectionMessage {
    [self._collectionView.backgroundView removeFromSuperview];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count;
    if([self suggestionsActive]) {
        count = [self._suggestionChannel.suggestions count];
    } else if ([self favoritesActive]) {
        count = [self._favoriteChannel.pieces count];
    }

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Suggestions
    if ([self suggestionsActive]) {
        TAGProfileTableSuggestionCell *cell = (TAGProfileTableSuggestionCell *)[tableView dequeueReusableCellWithIdentifier:kProfileTableSuggestionCellIdentifier];

        if([tableView isEqual:self._tableView]) {
            if (self._suggestionChannel.suggestions.count > 0) {
                [self removeEmptyCollectionMessage];

                TAGSuggestion *suggestion = [self._suggestionChannel.suggestions objectAtIndex:[indexPath row]];
                cell = [[TAGProfileTableSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileTableFavoriteCellIdentifier forModel:suggestion];
            }

            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        return cell;
    } else {
    // Favorites
        TAGProfileTableFavoriteCell *cell = (TAGProfileTableFavoriteCell *)[tableView dequeueReusableCellWithIdentifier:kProfileTableFavoriteCellIdentifier];

        if([tableView isEqual:self._tableView]){
            if (self._favoriteChannel.pieces.count > 0) {
                [self removeEmptyCollectionMessage];

                TAGPiece *favorite = [self._favoriteChannel.pieces objectAtIndex:[indexPath row]];

                cell = [[TAGProfileTableFavoriteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileTableFavoriteCellIdentifier forModel:favorite];
            }

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
    if ([self suggestionsActive]) {
        TAGSuggestionDetailViewController *suggestionDetailController = [[TAGSuggestionDetailViewController alloc]init];

        // Retrieve the right model
        TAGSuggestion *selectedSuggestion = [self._suggestionChannel.suggestions objectAtIndex:[indexPath row]];
        // Set that model on the instantiated controller
        [suggestionDetailController setViewWithSuggestion:selectedSuggestion];

        // Push that controller on the navigation controlller
        [[self navigationController] pushViewController:suggestionDetailController animated:YES];

    } else {
        TAGPieceDetailViewController *pieceDetailViewController = [[TAGPieceDetailViewController alloc]init];

        // Retrieve the right model
        TAGPiece *selectedFavorite = [self._favoriteChannel.pieces objectAtIndex:[indexPath row]];
        // Set that model on the instantiated controller
        [pieceDetailViewController setViewWithModel:selectedFavorite];

        [[self navigationController] pushViewController:pieceDetailViewController animated:YES];
    }
}

- (BOOL)suggestionsActive {
    return [self._currentTableViewCellIdentifier isEqual:kProfileTableSuggestionCellIdentifier];
}

- (BOOL)favoritesActive {
    return [self._currentTableViewCellIdentifier isEqual:kProfileTableFavoriteCellIdentifier];
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
    // This needs to be flexible per channel - suggestions/favorites/
    NSUInteger sectionCount;
    NSString *collection;
    if([self suggestionsActive]) {
        sectionCount = [self._suggestionChannel.suggestions count];
        collection = @"suggestions";
    } else if ([self favoritesActive]) {
        sectionCount = [self._favoriteChannel.pieces count];
        collection = @"favorites";
    }

    NSString *emptyCollectionCopy = [NSString stringWithFormat:@"no %@ currently available. please pull down to refresh.", collection];

    if (sectionCount > 0) {
        self._collectionView.backgroundView = nil;
        return sectionCount;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [TAGViewHelpers formatLabel:messageLabel withCopy:emptyCollectionCopy];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];

        self._collectionView.backgroundView = messageLabel;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TAGCollectionViewCell *cell = (TAGCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];

    UIImageView *backgroundImage = [UIImageView new];
    if([self suggestionsActive]) {
        if (self._suggestionChannel.suggestions.count > 0) {
            [self removeEmptyCollectionMessage];

            TAGSuggestion *suggestion = [self._suggestionChannel.suggestions objectAtIndex:[indexPath row]];

            UIImage *img = [TAGViewHelpers imageForURL:suggestion.imageUrl];

            [backgroundImage setImage:img];
        }
    } else {
        if (self._favoriteChannel.pieces.count > 0) {
            [self removeEmptyCollectionMessage];

            TAGPiece *favorite = [self._favoriteChannel.pieces objectAtIndex:[indexPath row]];

            UIImage *img = [TAGViewHelpers imageForURL:favorite.imageUrl];

            [backgroundImage setImage:img];
        }
    }

    [cell setBackgroundView:backgroundImage];
    [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if([self suggestionsActive]) {
        TAGSuggestionDetailViewController *suggestionDetailController = [[TAGSuggestionDetailViewController alloc] init];

        // Retrieve the right model
        TAGSuggestion *selectedSuggestion = [self._suggestionChannel.suggestions objectAtIndex:[indexPath row]];

        // Set that model on the instantiated controller
        [suggestionDetailController setViewWithSuggestion:selectedSuggestion];

        // Push that controller on the navigation controlller
        [[self navigationController] pushViewController:suggestionDetailController animated:YES];
    } else {
        TAGPieceDetailViewController *pieceDetailViewController = [[TAGPieceDetailViewController alloc] init];

        // Retrieve the right model
        TAGPiece *selectedFavorite = [self._favoriteChannel.pieces objectAtIndex:[indexPath row]];

        // Set that model on the instantiated controller
        [pieceDetailViewController setViewWithModel:selectedFavorite];

        [[self navigationController] pushViewController:pieceDetailViewController animated:YES];
    }
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
