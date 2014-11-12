//
//  TAGPiecesCollectionViewController.m
//  Tagit
//
//  Created by Shane Rogers on 9/7/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: Index page with sticky header cells

#import "TAGPiecesViewController.h"

// Data Layer
#import "TAGPieceChannel.h"
#import "TAGPieceStore.h"
#import "TAGPiece.h"

// Components
#import "TAGCollectionView.h"
#import "TAGPieceCell.h"
#import "TAGErrorAlert.h"
#import "TAGSpinner.h"

// Constants
#import "TAGComponentConstants.h"
#import "TAGStyleConstants.h"

// Helpers
#import "TAGViewHelpers.h"

// Pods
#import "CSStickyHeaderFlowLayout.h"

@interface TAGPiecesViewController ()

@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) UIActivityIndicatorView *_activityIndicator;
@property (nonatomic, strong) TAGPieceChannel *_pieceChannel;

@property (nonatomic, strong) TAGSpinner *_spinner;

// ScrollView component hiding
@property (nonatomic, assign) float _prevNavBarScrollViewYOffset;
@property (nonatomic, assign) float _prevTabBarScrollViewYOffset;
@property (nonatomic, assign) float _negDiff;
@property (nonatomic, assign) CGRect _originalTabFrame;

@end

@implementation TAGPiecesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        self._spinner = [TAGSpinner new];
        [self fetchPieces];
    }
    return self;
}

- (void)listenToCell:(TAGPieceCell *)cell {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(updateCellHeader:)
                   name:kSetHeaderInfoNotification
                 object:cell];
}

- (void)removeListenerOnCell:(TAGPieceCell *)cell {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center removeObserver:self
                      name:kSetHeaderInfoNotification
                    object:cell];
}

- (void)updateCellHeader:(NSNotification *)notification {

    // Retrieve data
    TAGPieceCell *cell = notification.object;

    [self removeListenerOnCell:cell];

    NSNumber *newFavoriteCount = notification.userInfo[kSetHeaderInfoFavoriteCount];
    // Find the item in the data source channel
    TAGPiece *targetPiece = [self._pieceChannel findById:cell.piece.id];
    // Update it - the data source
    targetPiece.favoriteCount = newFavoriteCount;
    // Find the index path of the section in the collection then reload
    NSInteger sectionIndex = [[self._collectionView indexPathForCell:cell] section];
    // Control the animations
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [self._collectionView reloadSections:[[NSIndexSet alloc] initWithIndex:sectionIndex]];
    [UIView setAnimationsEnabled:animationsEnabled];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAppearance];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self buildCollectionView];
}

// ScrollView component hiding
- (void)viewDidAppear:(BOOL)animated {
    self._originalTabFrame = self.tabBarController.tabBar.frame;
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

- (void)addNavigationItems {
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

- (void)fetchPieces {
    [self._spinner setSpinnerImagesWithView:self.view];

    [self._spinner startAnimating];
    [self.view addSubview:self._spinner];

    void(^completionBlock)(TAGPieceChannel *obj, NSError *err)=^(TAGPieceChannel *obj, NSError *err){
        if(!err){
            self._pieceChannel = obj;
            [self._collectionView reloadData];
        } else {
            [TAGErrorAlert render:err];
        }
        [self._spinner stopAnimating];
        [self._spinner removeFromSuperview];
    };
    [[TAGPieceStore sharedStore] fetchPiecesWithCompletion:completionBlock];
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
}

- (UICollectionViewFlowLayout *)buildCollectionViewCellLayout {
    UICollectionViewFlowLayout *flowLayout = [CSStickyHeaderFlowLayout new];
    // NOTE: Important to match the dimensions in the xib
    flowLayout.itemSize = CGSizeMake(320.0f,350.0f);
    flowLayout.headerReferenceSize = CGSizeMake(0.0f,50.0f);

    return flowLayout;
}

/////////////////////// Sticky

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    // Will be the store count
    return [self._pieceChannel.pieces count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    // Just identifiers for views
    TAGPieceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell"
                                                                   forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];

    if (self._pieceChannel.pieces.count > 0) {
        TAGPiece *piece = [self._pieceChannel.pieces objectAtIndex:[indexPath section]];
        cell.piece = piece;
        [cell getLikeState];

        // Listen for header update
        [self listenToCell:cell];

        UIImage *img = [TAGViewHelpers imageForURL:piece.imageUrl];
        [cell.pieceImage setImage:img];
    }

    FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:10];
    NSMutableAttributedString *heartIcon = [TAGViewHelpers createIcon:heart withColor:[UIColor blackColor]];
    FAKFontAwesome *comment = [FAKFontAwesome commentIconWithSize:10];
    NSMutableAttributedString *commentIcon = [TAGViewHelpers createIcon:comment withColor:[UIColor blackColor]];

    [TAGViewHelpers formatButton:cell.likeButton forIcon:heartIcon withCopy:@"Like  " withColor:[UIColor blackColor]];
    [TAGViewHelpers formatButton:cell.commentButton forIcon:commentIcon withCopy:@"Comment  " withColor:[UIColor blackColor]];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TAGPieceCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                withReuseIdentifier:@"sectionHeader"
                                                                       forIndexPath:indexPath];

        TAGPiece *piece = [self._pieceChannel.pieces objectAtIndex:[indexPath section]];
        [cell attributeWithModel:piece];

        return cell;
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        return [collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

#pragma NavigationBar Hide On Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideNavBar:scrollView];
    [self hideTabBar:scrollView];
}

- (void)hideNavBar:(UIScrollView *)scrollView {
    CGRect navFrame = self.navigationController.navigationBar.frame;
    CGFloat navSize = navFrame.size.height - 21;
    CGFloat navFramePercentageHidden = ((20 - navFrame.origin.y) / (navFrame.size.height - 1));

    CGFloat scrollOffset = scrollView.contentOffset.y;

    CGFloat navScrollDiff = scrollOffset - self._prevNavBarScrollViewYOffset;

    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;

    if (scrollOffset <= -scrollView.contentInset.top) { // Top Condition
        navFrame.origin.y = 20;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) { // Bottom Condition;
        navFrame.origin.y = -navSize;
    } else {
        navFrame.origin.y = MIN(20, MAX(-navSize, navFrame.origin.y - navScrollDiff));
    }

    CGFloat yOrigin = 0.0f - (20.0f - navFrame.origin.y);
    [self updateCollectionViewYOrigin:yOrigin];

    [self.navigationController.navigationBar setFrame:navFrame];
    [self updateBarButtonItems:(1 - navFramePercentageHidden)];
    self._prevNavBarScrollViewYOffset = scrollOffset;
}

- (void)updateCollectionViewYOrigin:(CGFloat)origin {
    CGRect collectionFrame = self._collectionView.frame;
    collectionFrame.origin.y = origin;
    [self._collectionView setFrame:collectionFrame];

}

- (void)hideTabBar:(UIScrollView *)scrollView {
    CGRect tabFrame = self.navigationController.tabBarController.tabBar.frame;

    CGFloat scrollOffset = scrollView.contentOffset.y;

    // TODO: Remove hardcoded 64 here
    CGFloat navScrollDiff = -64 - self._prevNavBarScrollViewYOffset;

    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;

    if (scrollOffset >= -scrollView.contentInset.bottom) { // Top Condition
        tabFrame.origin.y = 520;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) { // Bottom Condition
        tabFrame.origin.y = 570;
    } else if (self._negDiff > 520 - navScrollDiff) {
        tabFrame.origin.y = 520;
        self._negDiff = 520 - navScrollDiff;
    } else {
        self._negDiff = 520 - navScrollDiff;
        tabFrame.origin.y = MAX(520, MIN(520 - navScrollDiff,570));
    }
    [self.navigationController.tabBarController.tabBar setFrame:tabFrame];
    self._prevNavBarScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    CGRect navFrame = self.navigationController.navigationBar.frame;
    if (navFrame.origin.y < 20) {
        [self animateNavBarTo:-(navFrame.size.height - 21)];
    }
    CGRect tabFrame = self.navigationController.tabBarController.tabBar.frame;
    if (tabFrame.origin.y > 520) {
        [self animateTabBarTo:(571)];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    self.navigationItem.titleView.alpha = alpha;
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];

        // NavBar & collection frame should move in tandem
        CGRect collectionFrame = self._collectionView.frame;
        collectionFrame.origin.y = - (20 - frame.origin.y);
        [self._collectionView setFrame:collectionFrame];

        [self updateBarButtonItems:alpha];
    }];
}

- (void)animateTabBarTo:(CGFloat)y {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.tabBarController.tabBar.frame;
        frame.origin.y = y;
        [self.navigationController.tabBarController.tabBar setFrame:frame];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
