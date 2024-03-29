//
//  TAGDetailViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/30/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Libs
#import "FontAwesomeKit/FAKFontAwesome.h"

#import "TAGPieceDetailViewController.h"
#import "TAGViewHelpers.h"

// Constants
#import "TAGComponentConstants.h"
#import "TAGStyleConstants.h"

// Components
#import "TAGLateralTableViewCell.h"
#import "TAGErrorAlert.h"

// Pods
#import "URBMediaFocusViewController.h"

// Data Layer
#import "TAGPieceChannel.h"
#import "TAGPieceStore.h"
#import "TAGFavorite.h"
#import "TAGFavoriteStore.h"

@interface TAGPieceDetailViewController ()

@property (nonatomic, strong)UIView *_header;
@property (nonatomic, strong)UIView *_artistThumbnail;
@property (nonatomic, strong)UILabel *_pieceTitle;
@property (nonatomic, strong)UILabel *_artistName;
@property (nonatomic, strong)UILabel *_location;

@property (nonatomic, strong)UILabel *_favoriteCounter;

@property (nonatomic, strong)UILabel *_associatedTitle;
@property (nonatomic, strong)UITableView *_associatedWorkTable;
@property (nonatomic, strong)URBMediaFocusViewController *_lightboxViewController;

@property (nonatomic, strong)UIView *_pieceImage;
@property (nonatomic, strong)UIButton *_likeButton;
@property (nonatomic, strong)UIButton *_commentButton;

@property (nonatomic, strong)UIScrollView *_scrollView;

@property (nonatomic, assign) float _cellDimension;
@property (nonatomic, strong)TAGPiece *_piece;
@property (nonatomic, strong) UIActivityIndicatorView *_activityIndicator;
@property (nonatomic, strong)TAGPieceChannel *_pieceChannel;

@property (nonatomic, strong) TAGFavorite *_favorite;

@end

@implementation TAGPieceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setViewWithModel:(TAGPiece *)model {
    self._piece = model;
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
    self._cellDimension = 100.f;
    [self initAppearance];
    [self renderScrollView];
    [self renderHeader];
    [self renderDetailImage]; // Common detail functions
    [self renderFavoriteCounter];
    [self renderActionButtons];
    [self renderArtistAssocWork];
    [self setScrollViewContentSize];
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

- (void)setScrollViewContentSize {
    float yCoord = CGRectGetMaxY(self._associatedTitle.frame) + kSmallPadding;
    CGFloat fullHeight = yCoord + 200.0f + kSmallPadding;
    [self._scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,fullHeight)];
}

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
    [self buildArtistThumbnail];
    [self buildPieceTitle];
    [self buildArtistName];
}

- (void)buildArtistThumbnail {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding;
    self._artistThumbnail = [[UIView alloc]initWithFrame:CGRectMake(xCoord,
                                                                   yCoord,
                                                                   27.5f,
                                                                   27.5f)];
    [TAGViewHelpers roundImageLayer:self._artistThumbnail.layer withFrame:self._artistThumbnail.frame];
    [TAGViewHelpers scaleAndSetRemoteBackgroundImage:self._piece.artistImageURL forView:self._artistThumbnail];

    [self._scrollView addSubview:self._artistThumbnail];
}

- (void)buildPieceTitle {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding + self._artistThumbnail.frame.size.width + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding;

    self._pieceTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                             yCoord,
                                                             100.0f,
                                                             15.0f)];

    NSAttributedString *text = [TAGViewHelpers attributeText:self._piece.title forFontSize:10.0f andFontFamily:nil];
    [self._pieceTitle setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self._pieceTitle numberOfLines:0];

    [self._scrollView addSubview:self._pieceTitle];
}

- (void)buildArtistName {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding + self._artistThumbnail.frame.size.width + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding + self._pieceTitle.frame.size.height + kSmallPadding;

    self._artistName = [[UILabel alloc]initWithFrame:CGRectMake(
                                                               xCoord,
                                                               yCoord,
                                                               100.0f,
                                                               15.0f)];

    NSAttributedString *text = [TAGViewHelpers attributeText:self._piece.artistName forFontSize:10.0f andFontFamily:nil];
    [self._artistName setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self._artistName numberOfLines:0];

    [self._scrollView addSubview:self._artistName];
}

- (void)renderFavoriteCounter {
    CGFloat xCoord = 280.0f;
    CGFloat yCoord = self._pieceTitle.frame.origin.y;

    self._favoriteCounter = [[UILabel alloc] initWithFrame:CGRectMake(xCoord,
                                                                      yCoord,
                                                                      100.0f,
                                                                      20.0f)];

    [self updateHeaderCounter];
    [self._scrollView addSubview:self._favoriteCounter];
}

- (void)renderDetailImage {
    CGFloat xCoord = self.view.frame.origin.x;
    CGFloat yCoord = self._artistThumbnail.frame.origin.y + self._artistThumbnail.frame.size.height + kBigPadding;
    CGRect imageFrame = CGRectMake(xCoord, yCoord, 320.0f, 320.0f);

    self._pieceImage = [[UIView alloc] initWithFrame:imageFrame];

    [TAGViewHelpers scaleAndSetRemoteBackgroundImage:self._piece.imageUrl forView:self._pieceImage];

    [self._scrollView addSubview:self._pieceImage];
}

- (void)renderActionButtons {
    [self renderLikeButton];
//    [self renderCommentButton];
    [self attachActionSelectors];
}

- (void)renderLikeButton{
    float xCoord = self.view.frame.origin.x + kSmallPadding;
    float yCoord = CGRectGetMaxY(self._pieceImage.frame) + kSmallPadding;

    self._likeButton = [[UIButton alloc] initWithFrame:CGRectMake(xCoord,
                                                                  yCoord,
                                                                  50.0f,
                                                                  20.0f)];

    FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:10];
    NSMutableAttributedString *heartIcon = [TAGViewHelpers createIcon:heart withColor:[UIColor blackColor]];
    [TAGViewHelpers formatButton:self._likeButton forIcon:heartIcon withCopy:@"Like  " withColor:[UIColor blackColor]];

    void(^completionBlock)(TAGFavorite *favorite, NSError *err)=^(TAGFavorite *favorite, NSError *err) {
        if(!err){
            self._favorite = favorite;
            [TAGViewHelpers setButtonState:YES forButton:self._likeButton withBackgroundColor:[UIColor redColor] andCopy:@"Liked"];
        }
    };
    [[TAGFavoriteStore sharedStore] getFavoriteForPiece:self._piece.id withCompletionBlock:completionBlock];

    [self._scrollView addSubview:self._likeButton];
}

- (void)renderCommentButton{
    float xCoord = CGRectGetMaxX(self._likeButton.frame) + kSmallPadding;
    float yCoord = self._likeButton.frame.origin.y;

    self._likeButton = [[UIButton alloc] initWithFrame:CGRectMake(xCoord,
                                                                  yCoord,
                                                                  70.0f,
                                                                  20.0f)];
    FAKFontAwesome *comment = [FAKFontAwesome commentIconWithSize:10];
    NSMutableAttributedString *commentIcon = [TAGViewHelpers createIcon:comment withColor:[UIColor blackColor]];
    [TAGViewHelpers formatButton:self._likeButton forIcon:commentIcon withCopy:@"Comment  " withColor:[UIColor blackColor]];
    [self._scrollView  addSubview:self._likeButton];
}

- (void)attachActionSelectors {
    [self._likeButton addTarget:self action:@selector(favoriteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)favoriteButtonTapped:(UIButton *)button {
    if (!button.selected){
        [self favoritePiece:button];
    } else {
        [self unFavoritePiece:button];
    }
}

- (void)favoritePiece:(UIButton *)button {
    void (^completionBlock)(TAGFavorite *favorite, NSError *err)=^(TAGFavorite *favorite, NSError *err) {
        if(!err){
            self._piece.favoriteCount = favorite.count;
            self._favorite = favorite;
            [TAGViewHelpers setButtonState:YES forButton:self._likeButton withBackgroundColor:[UIColor redColor] andCopy:@"Liked"];
        } else {
            [TAGErrorAlert render:err];
        }

        [self updateHeaderCounter];
    };

    [[TAGFavoriteStore sharedStore] createFavoriteForPiece:self._piece.id withCompletionBlock:completionBlock];
}

- (void)unFavoritePiece:(UIButton *)button {
    void(^completionBlock)(TAGPiece *piece, NSError *err)=^(TAGPiece *piece, NSError *err) {
        if(!err){
            self._piece = piece;
            self._favorite = nil;
            [TAGViewHelpers setButtonState:NO forButton:self._likeButton withBackgroundColor:[UIColor blackColor] andCopy:@"Like"];
        } else {
            [TAGErrorAlert render:err];
        }
        [self updateHeaderCounter];
    };

    [[TAGFavoriteStore sharedStore] destroyFavorite:self._favorite.id withCompletionBlock:completionBlock];
}

- (void)updateHeaderCounter {
    NSString *count = [self._piece.favoriteCount stringValue];

    NSMutableAttributedString *favoriteCounter = [TAGViewHelpers heartCounterStringWithCopy:count andFontSize:13.0f];
    [self._favoriteCounter setAttributedText:favoriteCounter];
}

- (void)renderArtistAssocWork {
    [self renderAssociatedTitle];
    [self renderAssociatedWorkTable];
    [self fetchArtistsAssociatedWork];
}

- (void)fetchArtistsAssociatedWork {

    void(^completionBlock)(TAGPieceChannel *obj, NSError *err)=^(TAGPieceChannel *obj, NSError *err){
        if(!err){
            self._pieceChannel = obj;
            [self._associatedWorkTable reloadData];
        } else {
            [TAGErrorAlert render:err];
        }
    };

    [[TAGPieceStore sharedStore] fetchAssociatedWorkForArtist:self._piece.artistId WithCompletion:completionBlock];
}

- (void)renderAssociatedTitle {
    NSMutableAttributedString *preString =[[NSMutableAttributedString alloc] initWithString:@"Other work by: " attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10.0]}];

    NSAttributedString *postString =[[NSAttributedString alloc] initWithString:self._artistName.text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];

    [preString appendAttributedString:postString];

    self._associatedTitle = [UILabel new];

    float xCoord = self.view.frame.origin.x + kSmallPadding;
    float yCoord = CGRectGetMaxY(self._likeButton.frame) + kSmallPadding;

    [self._associatedTitle setFrame:CGRectMake(xCoord,
                                               yCoord,
                                               100.0f,
                                               20.0f)];

    [self._associatedTitle setAttributedText:preString];
    [TAGViewHelpers sizeLabelToFit:self._associatedTitle numberOfLines:1];

    [self._scrollView addSubview:self._associatedTitle];
}

- (void)renderAssociatedWorkTable {
    self._associatedWorkTable = [UITableView new];

    float yCoord = CGRectGetMaxY(self._associatedTitle.frame) + kSmallPadding;

    CGRect piecesRect = CGRectMake(0.0f, yCoord, 320.0f, self._cellDimension);

    self._associatedWorkTable = [[UITableView alloc] initWithFrame:piecesRect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI_2);
    [self._associatedWorkTable setTransform:rotate];
    // VIP: Must set the frame again on the table after rotation
    [self._associatedWorkTable setFrame:piecesRect];
    [self._associatedWorkTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTAGLateralTableViewCellIdentifier];
    self._associatedWorkTable.delegate = self;
    self._associatedWorkTable.dataSource = self;
    self._associatedWorkTable.alwaysBounceVertical = NO;
    self._associatedWorkTable.scrollEnabled = YES;
    self._associatedWorkTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    self._associatedWorkTable.separatorColor = [UIColor whiteColor];

    [self._associatedWorkTable setBackgroundColor:[UIColor whiteColor]];

    [self._scrollView addSubview:self._associatedWorkTable];
}


#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger rowCount = [self._pieceChannel.pieces count];

    if (rowCount > 0) {
        self._associatedWorkTable.backgroundView = nil;
        return rowCount;
    } else {
        self._associatedWorkTable.backgroundView = [TAGViewHelpers emptyTableMessage:@"this artist has no associated work" forView:self.view];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGLateralTableViewCell *cell = [[TAGLateralTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTAGLateralTableViewCellIdentifier forCellDimension:self._cellDimension];

    if([tableView isEqual:self._associatedWorkTable]){
        UIImageView *backgroundImage = [UIImageView new];
        if ([self._pieceChannel.pieces count] > 0) {
            TAGPiece *piece = [self._pieceChannel.pieces objectAtIndex:[indexPath row]];

            UIImage *img = [TAGViewHelpers imageForURL:piece.imageUrl];
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
    TAGLateralTableViewCell *targetCell = (TAGLateralTableViewCell *)[self._associatedWorkTable cellForRowAtIndexPath:indexPath];
    [self._lightboxViewController showImage:targetCell.artImage fromView:targetCell];
}

// TODO: Common detail function
- (void)setBackgroundImage:(NSString *)imageName forView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:imageName];
    view.backgroundColor = [UIColor colorWithPatternImage:image];
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
