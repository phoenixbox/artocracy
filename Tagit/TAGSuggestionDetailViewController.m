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
#import "TAGMapHelpers.h"

// Components
#import "TAGMapViewController.h"
#import "TAGSuggestionDetailsSection.h"
#import "TAGLateralTableViewCell.h"
#import "TAGMapAnnotation.h"
#import "TAGErrorAlert.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGCopyConstants.h"
#import "TAGComponentConstants.h"

// Pods
#import "URBMediaFocusViewController.h"

// Data Layer
#import "TAGProposalChannel.h"
#import "TAGSuggestionStore.h"

@interface TAGSuggestionDetailViewController ()

// Data Layer
@property (nonatomic, strong)TAGSuggestion *_suggestion;
// Header section
@property (nonatomic, strong) UIView *_header;
@property (nonatomic, strong) UIView *_userThumbnail;
@property (nonatomic, strong) UILabel *_userName;
@property (nonatomic, strong) UILabel *_upvoteCounter;
// Main Content
@property (nonatomic, strong) UIImageView *_suggestionImage;
// Map view
@property (nonatomic, strong) MKMapView *_mapView;
// Suggestion Detail Section
@property (nonatomic, strong) TAGSuggestionDetailsSection *_suggestionDetailsSection;
// Comment action
@property (nonatomic, strong) UIButton *_commentButton;
// Lateral Table
@property (nonatomic, strong) UIActivityIndicatorView *_activityIndicator;
@property (nonatomic, strong) TAGProposalChannel *_proposalChannel;
@property (nonatomic, strong) UILabel *_proposalTitle;
@property (nonatomic, strong) UILabel *_proposalCount;
@property (nonatomic, strong) UITableView *_proposalsTable;
@property (nonatomic, strong) URBMediaFocusViewController *_lightboxViewController;
@property (nonatomic, assign) float _cellDimension;
// Container scroll view
@property (nonatomic, strong) UIScrollView *_scrollView;

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

- (void)setViewWithSuggestion:(TAGSuggestion *)suggestion {
    self._suggestion = suggestion;
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
    [self.view setBackgroundColor:[UIColor whiteColor]]; // Fix transparent transtion as pushed atop the stack
    self._cellDimension = 165.f;
    [self initAppearance];
    [self renderScrollView];
    [self renderHeader];
    [self renderDetailImage]; // Common detail functions
    [self renderMap];

    [self renderSuggestionDetailsContainer];

    [self fetchProposalsForSuggestion];
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

    [TAGViewHelpers scaleAndSetRemoteBackgroundImage:self._suggestion.suggestorImageURL forView:self._userThumbnail];

    [self._scrollView addSubview:self._userThumbnail];
}

- (void)buildUserName {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding + self._userThumbnail.frame.size.width + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding;

    self._userName = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                yCoord,
                                                                100.0f,
                                                                15.0f)];

    NSAttributedString *text = [TAGViewHelpers attributeText:self._suggestion.suggestorEmail forFontSize:10.0f];
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

    self._suggestionImage = [[UIImageView alloc] initWithFrame:imageFrame];
    UIImage *img = [TAGViewHelpers imageForURL:self._suggestion.imageUrl];
    [self._suggestionImage setImage:img];

    [self._scrollView addSubview:self._suggestionImage];
}

- (void)renderMap {
    self._mapView = [MKMapView new];
    self._mapView.delegate = self;
    [self._mapView setMapType:MKMapTypeStandard];
    [self.view addSubview:self._mapView];

    CLLocationCoordinate2D pin = CLLocationCoordinate2DMake([self._suggestion.latitude doubleValue], [self._suggestion.longitude doubleValue]);
    TAGMapAnnotation *annotation = [[TAGMapAnnotation alloc] initWithCoordinates:pin title:@"" subtitle:@""];
    annotation.pinColor = MKPinAnnotationColorPurple;
    [self._mapView addAnnotation:annotation];

    MKCoordinateSpan span = MKCoordinateSpanMake(0.01, 0.01);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMake(pin, span);
    [self._mapView setRegion:viewRegion animated:YES];

    CGFloat xCoord = CGRectGetMaxX(self._suggestionImage.frame);
    CGFloat yCoord = self._suggestionImage.frame.origin.y;

    CGRect mapViewRect = CGRectMake(xCoord,
                                    yCoord,
                                    self._suggestionImage.frame.size.width,
                                    self._suggestionImage.frame.size.height);

    [self._mapView setFrame:mapViewRect];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *result = nil;
    result = [TAGMapHelpers annotation:annotation forMap:mapView];
    return result;
}

- (void)renderSuggestionDetailsContainer {
    CGRect suggestionFrame = CGRectMake(0.0f, CGRectGetMaxY(self._suggestionImage.frame), self.view.frame.size.width, 65.0f);
    self._suggestionDetailsSection = [[TAGSuggestionDetailsSection alloc] initWithFrame:suggestionFrame forSuggestion:self._suggestion];
    [self._suggestionDetailsSection setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self._suggestionDetailsSection];
}

- (void)fetchProposalsForSuggestion {
    self._activityIndicator = [TAGViewHelpers setActivityIndicatorForNavItem:[self navigationItem]];

    void(^completionBlock)(TAGProposalChannel *obj, NSError *err)=^(TAGProposalChannel *obj, NSError *err){
        if(!err){
            self._proposalChannel = obj;
            [self updateProposalsCountLabel];
            [self._proposalsTable reloadData];
        } else {
            [TAGErrorAlert render:err];
        }
        [self._activityIndicator stopAnimating];
    };

    [[TAGSuggestionStore sharedStore] fetchProposalsForSuggestion:self._suggestion.id withCompletionBlock:completionBlock];

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
    self._proposalsTable.separatorColor = [UIColor clearColor];

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

    [self updateProposalsCountLabel];

    [self.view addSubview:self._proposalTitle];
    [self.view addSubview:self._proposalCount];
}

- (void)updateProposalsCountLabel {
    NSString *count = [NSString stringWithFormat:@"%tu", [self._proposalChannel.proposals count]];
    NSAttributedString *proposalCount = [TAGViewHelpers attributeText:count forFontSize:12.0f];
    [self._proposalCount setAttributedText:proposalCount];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount = [self._proposalChannel.proposals count];

    if (rowCount > 0) {
        self._proposalsTable.backgroundView = nil;
        return rowCount;
    } else {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [TAGViewHelpers formatLabel:messageLabel withCopy:@"no proposals have been made"];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [messageLabel sizeToFit];

        [TAGViewHelpers rotate90Clockwise:messageLabel];

        self._proposalsTable.backgroundView = messageLabel;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGLateralTableViewCell *cell = [[TAGLateralTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTAGLateralTableViewCellIdentifier forCellDimension:self._cellDimension];

    if([tableView isEqual:self._proposalsTable]){
        UIImageView *backgroundImage = [UIImageView new];
        if ([self._proposalChannel.proposals count] > 0) {
            TAGProposal *proposal = [self._proposalChannel.proposals objectAtIndex:[indexPath row]];

            UIImage *img = [TAGViewHelpers imageForURL:proposal.imageUrl];
            [cell setArtImage:img];

            [backgroundImage setImage:img];
        }
        [cell setBackgroundView:backgroundImage];
        // Rotate the image in the cell
        [TAGViewHelpers rotate90Clockwise:cell.backgroundView];
        [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self._cellDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self._lightboxViewController = [[URBMediaFocusViewController alloc] initWithNibName:nil bundle:nil];
    self._lightboxViewController.shouldDismissOnImageTap = YES;
    self._lightboxViewController.shouldShowPhotoActions = YES;
    TAGLateralTableViewCell *targetCell = (TAGLateralTableViewCell *)[self._proposalsTable cellForRowAtIndexPath:indexPath];
    [self._lightboxViewController showImage:targetCell.artImage fromView:targetCell];
}


// TODO: Common detail function
- (void)setBackgroundImage:(NSString *)imageName forView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:imageName];
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

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
