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
#import "TAGLateralTableViewCell.h"
#import "TAGMapAnnotation.h"
#import "TAGErrorAlert.h"
#import "TAGPieceCell.h"

// Interface
#import "TAGSuggestionDetailsSection.h"
#import "TAGSuggestionDetailHeader.h"

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
@property (nonatomic, strong) TAGSuggestionDetailHeader *_suggestionHeader;
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

    [self listenToSuggestionDetailsContainer];
}

- (void)listenToSuggestionDetailsContainer {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(updateSuggestionHeader:)
                   name:kSetSuggestionHeaderInfoNotification
                 object:self._suggestionDetailsSection];
}

- (void)updateSuggestionHeader:(NSNotification *)notification {
    NSNumber *newUpvoteCount = notification.userInfo[kSetHeaderInfoUpvoteCount];

    [self._suggestion setUpvoteCount:newUpvoteCount];
    [self._suggestionHeader attributeWithModel:self._suggestion];
    [self._suggestionHeader setNeedsDisplay];

    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [UIView setAnimationsEnabled:animationsEnabled];
}


- (void)initAppearance
{
    self.navigationController.navigationBar.translucent = NO;

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

- (void)setHeaderLogo {
    [[self navigationItem] setTitleView:nil];
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 165.0f, 32.5f)];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"art_navBarLogo.png"];
    [logoView setImage:logoImage];
    self.navigationItem.titleView = logoView;
}

- (void)addNavigationItems{
    UIImage *filterImage = [UIImage imageNamed:@"filterIcon.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:filterImage landscapeImagePhone:filterImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleFilter:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)toggleFilter:(UIButton *)button {
    NSLog(@"Toggle Filter!");
}

- (void)renderHeader {
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TAGSuggestionDetailHeader" owner:nil options:nil];

    // Find the view among nib contents (not too hard assuming there is only one view in it).
    self._suggestionHeader = [nibContents lastObject];
    [self._suggestionHeader attributeWithModel:self._suggestion];

    [self._suggestionHeader setFrame:CGRectMake(0.0f,
                                                0.0f,
                                                self._suggestionHeader.frame.size.width,
                                                self._suggestionHeader.frame.size.height)];

    [self.view addSubview:self._suggestionHeader];
}

- (void)renderDetailImage {
    CGFloat xCoord = self.view.frame.origin.x;
    CGFloat yCoord = self._suggestionHeader.frame.origin.y + self._suggestionHeader.frame.size.height + kBigPadding;
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
    // Instantiate the nib content without any reference to it.
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TAGSuggestionDetailsSection" owner:nil options:nil];

    // Find the view among nib contents (not too hard assuming there is only one view in it).
    self._suggestionDetailsSection = [nibContents lastObject];
    [self._suggestionDetailsSection attributeWithModel:self._suggestion];

    [self._suggestionDetailsSection setFrame:CGRectMake(0.0f,
                                                        CGRectGetMaxY(self._suggestionImage.frame),
                                                        self._suggestionDetailsSection.frame.size.width,
                                                        self._suggestionDetailsSection.frame.size.height)];

    [self.view addSubview:self._suggestionDetailsSection];
}

- (void)fetchProposalsForSuggestion {

    void(^completionBlock)(TAGProposalChannel *obj, NSError *err)=^(TAGProposalChannel *obj, NSError *err){
        if(!err){
            self._proposalChannel = obj;
            [self updateProposalsCountLabel];
            [self._proposalsTable reloadData];
        } else {
            [TAGErrorAlert render:err];
        }
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
    NSAttributedString *proposalTitle = [TAGViewHelpers attributeText:@"Proposals" forFontSize:12.0f andFontFamily:nil];
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
    [TAGViewHelpers updateCount:[self._proposalChannel.proposals count] forLabel:self._proposalCount];
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
        self._proposalsTable.backgroundView = [TAGViewHelpers emptyTableMessage:@"no proposals have been made" forView:self.view];
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
