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

// Constants
#import "TAGStyleConstants.h"
#import "TAGCopyConstants.h"

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
@property (nonatomic, strong)UILabel *_canvasTypeTitle;
@property (nonatomic, strong)UILabel *_canvasType;
@property (nonatomic, strong)UIButton *_favoriteButton;
@property (nonatomic, strong)UILabel *_locationTitle;
@property (nonatomic, strong)UILabel *_locationAddress;
@property (nonatomic, strong)UILabel *_locationCity;
@property (nonatomic, strong)UILabel *_locationState;
// Comment action
@property (nonatomic, strong)UIButton *_commentButton;
// Lateral Table
@property (nonatomic, strong)UILabel *_proposalTitle;
@property (nonatomic, strong)UILabel *_proposalCount;
@property (nonatomic, strong)UITableView *_proposalsTable;
@property (nonatomic, assign) float _cellDimension;
@property (nonatomic, assign) float _labelWidth;
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
    self._cellDimension = 100.f;
    self._labelWidth = 149.0f;
    [self initAppearance];
    [self renderScrollView];
    [self renderHeader];
    [self renderDetailImage]; // Common detail functions
//    [self renderMap];

    [self suggestionDetails];
    [self renderFavoriteButton];
    [self locationDetails];
    [self renderSuggestedPiecesTable];
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

- (void)suggestionDetails {
    float xCoord = self.view.frame.origin.x + kSmallPadding;

    self._canvasTypeTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                    CGRectGetMaxY(self._suggestionImage.frame) + kSmallPadding,
                                                                    149.0f,
                                                                     20.0f)];
    NSAttributedString *canvasTitle =[TAGViewHelpers attributeText:@"Canvas Type" forFontSize:12.0f];
    [self._canvasTypeTitle setAttributedText:canvasTitle];
    [TAGViewHelpers sizeLabelToFit:self._canvasTypeTitle numberOfLines:0];

    self._canvasType = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                 CGRectGetMaxY(self._canvasTypeTitle.frame) + kSmallPadding,
                                                                 149.0f,
                                                                 20.0f)];

    NSAttributedString *canvasType =[TAGViewHelpers attributeText:@"Commercial Wall" forFontSize:10.0f];
    [self._canvasType setAttributedText:canvasType];
    [TAGViewHelpers sizeLabelToFit:self._userName numberOfLines:0];

    [self.view addSubview:self._canvasTypeTitle];
    [self.view addSubview:self._canvasType];
}

- (void)locationDetails {
    float xCoord = CGRectGetMaxX(self._favoriteButton.frame) + kSmallPadding;

    self._locationTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                     CGRectGetMaxY(self._suggestionImage.frame) + kSmallPadding,
                                                                     self._labelWidth,
                                                                     20.0f)];
    NSAttributedString *locationTitle =[TAGViewHelpers attributeText:@"Location" forFontSize:12.0f];
    [self._locationTitle setAttributedText:locationTitle];
    [TAGViewHelpers sizeLabelToFit:self._locationTitle numberOfLines:0];
    [self.view addSubview:self._locationTitle];

    self._locationAddress = [UILabel new];
    self._locationCity = [UILabel new];
    self._locationState = [UILabel new];
    NSArray *labels = [[NSArray alloc] initWithObjects:self._locationAddress, self._locationCity, self._locationState, nil];
    NSArray *text = [[NSArray alloc] initWithObjects:kLocationAddress,kLocationCity,kLocationState, nil];

    NSUInteger labelCount = [labels count];

    float xOrigin = CGRectGetMaxX(self._favoriteButton.frame) + 5.0f;

    for (int i=0; i<labelCount; i++) {
        float yOrigin;

        if (i == 0) {
            yOrigin = CGRectGetMaxY(self._locationTitle.frame) + kSmallPadding;
        } else {
            yOrigin = yOrigin + 15.0f;
        }

        UILabel *label = [labels objectAtIndex:i];
        label = [[UILabel alloc]initWithFrame:CGRectMake(xOrigin,
                                                         yOrigin,
                                                         self._labelWidth,
                                                         10.0f)];

        NSAttributedString *labelText =[TAGViewHelpers attributeText:[text objectAtIndex:i] forFontSize:10.0f];
        [label setAttributedText:labelText];
        [self.view addSubview:label];
    }
}

- (void)renderFavoriteButton {
    float yCoord = self._canvasTypeTitle.frame.origin.y + (((CGRectGetMaxY(self._canvasType.frame) - self._canvasTypeTitle.frame.origin.y)/2));
    self._favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                      0.0f,
                                                                      40.0f,
                                                                      40.0f)];
    CGPoint buttonCenter = CGPointMake(self.view.frame.size.width/2, yCoord);
    [self._favoriteButton setCenter:buttonCenter];
    [self._favoriteButton setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self._favoriteButton];
}

- (void)renderSuggestedPiecesTable {
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
