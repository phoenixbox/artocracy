//
//  TAGPieceViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: Old implementation of index page not using xibs

// Classes
#import "TAGPieceViewController.h"
#import "TAGPieceStore.h"

// Components
#import "TAGErrorAlert.h"
#import "TAGTagTableViewCell.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGComponentConstants.h"

@interface TAGPieceViewController ()

@property (nonatomic, strong) UITableView *_tagsTable;

// ScrollView component hiding
@property (nonatomic, assign) float _prevNavBarScrollViewYOffset;
@property (nonatomic, assign) float _prevTabBarScrollViewYOffset;
@property (nonatomic, assign) float _negDiff;
@property (nonatomic, assign) CGRect _originalTabFrame;

@end

@implementation TAGPieceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initAppearance];
//        [self fetchTags];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self renderTagsTable];
}

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

- (void)fetchTags {
    [self setActivityIndicator];

    void(^completionBlock)(TAGTagChannel *obj, NSError *err)=^(TAGTagChannel *obj, NSError *err){
        [self setHeaderLogo];
        if(!err){
//            [[self feedTable]reloadData];
        } else {
            [TAGErrorAlert render:err];
//            [self._requestIndicator stopAnimating];
        }
    };
    [[TAGPieceStore sharedStore] fetchPiecesWithCompletion:completionBlock];
}

- (void)setActivityIndicator {
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
}

- (void)renderTagsTable {
    self._tagsTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self._tagsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTagsTableCellIdentifier];
    self._tagsTable.delegate = self;
    self._tagsTable.dataSource = self;
    self._tagsTable.alwaysBounceVertical = NO;
    self._tagsTable.scrollEnabled = YES;
    self._tagsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self._tagsTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    self._tagsTable.separatorColor = [UIColor clearColor];
    [self._tagsTable setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self._tagsTable];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TAGTagTableViewCell *cell = (TAGTagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTagsTableCellIdentifier];

    if([tableView isEqual:self._tagsTable]){
        cell = [[TAGTagTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTagsTableCellIdentifier];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTagsTableRowHeight;
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

    [self.navigationController.navigationBar setFrame:navFrame];
    [self updateBarButtonItems:(1 - navFramePercentageHidden)];
    self._prevNavBarScrollViewYOffset = scrollOffset;
}

- (void)hideTabBar:(UIScrollView *)scrollView {
    CGRect tabFrame = self.navigationController.tabBarController.tabBar.frame;

    CGFloat scrollOffset = scrollView.contentOffset.y;

    // TODO: Remove hardcoded 64 here
    CGFloat navScrollDiff = -64 - self._prevNavBarScrollViewYOffset;

    CGFloat scrollHeight = scrollView.frame.size.height;
    CGFloat scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;

    if (scrollOffset <= -scrollView.contentInset.bottom) {
        tabFrame.origin.y = 520;
    } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
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
        [self updateBarButtonItems:alpha];
    }];
}

- (void)animateTabBarTo:(CGFloat)y {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.tabBarController.tabBar.frame;
//        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.tabBarController.tabBar setFrame:frame];
//        [self updateBarButtonItems:alpha];
    }];
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
