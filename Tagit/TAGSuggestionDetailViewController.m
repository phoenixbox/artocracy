//
//  TAGSuggestionDetailViewController.m
//  Tagit
//
//  Created by Shane Rogers on 9/1/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionDetailViewController.h"

// Helpers
#import "TAGViewHelpers.h"

// Components
#import "TAGMapViewController.h"
#import "TAGSuggestionDetailsSection.h"
#import "TAGLateralTableViewCell.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGCopyConstants.h"
#import "TAGComponentConstants.h"

@interface TAGSuggestionDetailViewController ()

// Header section
@property (nonatomic, strong)UIView *_header;
@property (nonatomic, strong)UIView *_userThumbnail;
@property (nonatomic, strong)UILabel *_userName;
@property (nonatomic, strong)UILabel *_upvoteCounter;


@property (nonatomic, strong)UIView *_suggestionImage;

// Map view
@property (nonatomic, strong) TAGMapViewController *_mapController;
// Suggestion Detail Section
@property (nonatomic, strong)TAGSuggestionDetailsSection *_suggestionDetailsSection;
// Comment action
@property (nonatomic, strong)UIButton *_commentButton;
// Lateral Table
@property (nonatomic, strong)UILabel *_proposalTitle;
@property (nonatomic, strong)UILabel *_proposalCount;
@property (nonatomic, strong)UITableView *_proposalsTable;
@property (nonatomic, assign) float _cellDimension;
// Container scroll view
@property (nonatomic, strong)UIScrollView *_scrollView;

@end

@implementation TAGSuggestionDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, 40.0f, 40.0f)];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(popDetailView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self._cellDimension = 165.f;
    [self initAppearance];
    [self renderScrollView];
    [self renderHeader];
    [self renderDetailImage]; // Common detail functions
//    [self renderMap];

    [self renderSuggestionDetailsContainer];
    [self renderProposalsTable];
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

- (void)renderScrollView {
    self._scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self._scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self._scrollView.delegate = self;

    [self.view addSubview:self._scrollView];
}

//- (void)setScrollViewContentSize {
//    float yCoord = CGRectGetMaxY(self._associatedTitle.frame) + kSmallPadding;
//    CGFloat fullHeight = yCoord + 200.0f + kSmallPadding;
//    [self._scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,fullHeight)];
//}

- (void)popDetailView {
    NSLog(@"Pop the controller");
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)renderHeader {
    [self buildUserThumbnail];
    [self buildUserName];
}

- (void)buildUserThumbnail {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding;
    self._userThumbnail = [[UIView alloc]initWithFrame:CGRectMake(xCoord,
                                                                    yCoord,
                                                                    27.5f,
                                                                    27.5f)];
    self._userThumbnail.layer.cornerRadius = self._userThumbnail.frame.size.width/2;
    self._userThumbnail.layer.masksToBounds = YES;

    [self setBackgroundImage:@"profile_photo.png" forView:self._userThumbnail];

    [self._scrollView addSubview:self._userThumbnail];
}

- (void)buildUserName {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding + self._userThumbnail.frame.size.width + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding;

    self._userName = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                yCoord,
                                                                100.0f,
                                                                15.0f)];

    NSAttributedString *text = [TAGViewHelpers attributeText:@"Shane Rogers" forFontSize:10.0f];
    [self._userName setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self._userName numberOfLines:0];

    [self._scrollView addSubview:self._userName];
}

- (void)renderDetailImage {
    CGFloat xCoord = self.view.frame.origin.x;
    CGFloat yCoord = self._userThumbnail.frame.origin.y + self._userThumbnail.frame.size.height + kBigPadding;
    CGRect imageFrame = CGRectMake(xCoord,
                                   yCoord,
                                   self.view.frame.size.width/2,
                                   self.view.frame.size.width/2);

    self._suggestionImage = [[UIView alloc] initWithFrame:imageFrame];

    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"ape_do_good_printing_SF.png" forView:self._suggestionImage];

    [self._scrollView addSubview:self._suggestionImage];
}

- (void)renderSuggestionDetailsContainer {
    void(^buttonTapped)(BOOL selected)=^(BOOL selected){
        if (selected) {
            NSLog(@"SELECT THE BUTTON");
        } else {
            NSLog(@"DESELECT THE BUTTON");
        }
    };

    CGRect suggestionFrame = CGRectMake(0.0f, CGRectGetMaxY(self._suggestionImage.frame), self.view.frame.size.width, 65.0f);
    self._suggestionDetailsSection = [[TAGSuggestionDetailsSection alloc] initWithFrame:suggestionFrame withBlock:buttonTapped];
    [self._suggestionDetailsSection setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self._suggestionDetailsSection];
}

- (void)renderProposalsTable {
    [self renderTableHeader];
    float yCoord = CGRectGetMaxY(self._proposalTitle.frame) + kSmallPadding;

    CGRect piecesRect = CGRectMake(0.0f, yCoord, 320.0f, self._cellDimension);

    self._proposalsTable = [[UITableView alloc] initWithFrame:piecesRect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI_2);
    [self._proposalsTable setTransform:rotate];

    // VIP: Must set the frame again on the table after rotation
    [self._proposalsTable setFrame:piecesRect];
    [self._proposalsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTAGLateralTableViewCellIdentifier];
    self._proposalsTable.delegate = self;
    self._proposalsTable.dataSource = self;
    self._proposalsTable.alwaysBounceVertical = NO;
    self._proposalsTable.scrollEnabled = YES;
    self._proposalsTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    self._proposalsTable.separatorColor = [UIColor blackColor];

    [self._proposalsTable setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self._proposalsTable];
}

- (void)renderTableHeader {
    float yCoord = CGRectGetMaxY(self._suggestionDetailsSection.frame);
    self._proposalTitle = [[UILabel alloc]initWithFrame:CGRectMake(kSmallPadding,
                                                                   yCoord,
                                                                   100.0f,
                                                                   20.0f)];
    NSAttributedString *proposalTitle = [TAGViewHelpers attributeText:@"Proposals" forFontSize:12.0f];
    [self._proposalTitle setAttributedText:proposalTitle];


    self._proposalCount = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - (2*kBigPadding),
                                                                   yCoord,
                                                                   100.0f,
                                                                   20.0f)];
    NSAttributedString *proposalCount = [TAGViewHelpers attributeText:@"10" forFontSize:12.0f];
    [self._proposalCount setAttributedText:proposalCount];

    [self.view addSubview:self._proposalTitle];
    [self.view addSubview:self._proposalCount];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGLateralTableViewCell *cell = (TAGLateralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTAGLateralTableViewCellIdentifier];

    if([tableView isEqual:self._proposalsTable]){
        cell = [[TAGLateralTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTAGLateralTableViewCellIdentifier forCellDimension:self._cellDimension];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self._cellDimension;
}

// TODO: Common detail function
- (void)setBackgroundImage:(NSString *)imageName forView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:imageName];
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

//- (void)renderMap {
//    CGRect mapFrame = CGRectMake(160.0f,
//                                 self._suggestionImage.frame.origin.y,
//                                 self.view.frame.size.width/2,
//                                  self.view.frame.size.width/2);
//    self._mapController = [[TAGMapViewController alloc] initWithFrame:mapFrame];
//
//    // RESTART: Convert suggestion image capture to use the custom map initializer
//    // https://github.com/jamztang/CSStickyHeaderFlowLayout implement sticky headers and parralax effects
//    [self addChildViewController:self._mapController];
//    [self._scrollView addSubview:self._mapController.view];
//}


- (void)didReceiveMemoryWarning {
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
