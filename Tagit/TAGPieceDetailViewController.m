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
#import "TAGStyleConstants.h"
#import "TAGViewHelpers.h"

@interface TAGPieceDetailViewController ()

@property (nonatomic, strong)UIView *_header;
@property (nonatomic, strong)UIView *_artistThumbnail;
@property (nonatomic, strong)UILabel *_pieceTitle;
@property (nonatomic, strong)UILabel *_artistName;
@property (nonatomic, strong)UILabel *_location;

@property (nonatomic, strong)UILabel *_favoriteCounter;

@property (nonatomic, strong)UIView *_image;
@property (nonatomic, strong)UIButton *_likeButton;
@property (nonatomic, strong)UIButton *_commentButton;

@property (nonatomic, strong)UIScrollView *_scrollView;

@end

@implementation TAGPieceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initAppearance];
        [self renderScrollView];
        [self renderHeader];
        [self renderCellImage];
        [self renderFavoriteCounter];
//        [self renderActionButtons];
        [self setScrollViewContentSize];
    }
    return self;
}

- (void)renderScrollView {
    self._scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self._scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self._scrollView.delegate = self;

    [self.view addSubview:self._scrollView];
}

- (void)setScrollViewContentSize {
    CGFloat fullHeight = self._commentButton.frame.origin.y + 350.0f;

    [self._scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,fullHeight)];
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

- (void)popDetailView {
    NSLog(@"Pop the controller");
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)renderHeader {
    [self buildArtistThumbnail];
    [self buildTagTitle];
    [self buildArtistName];
}

- (void)buildArtistThumbnail {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding;
    self._artistThumbnail = [[UIView alloc]initWithFrame:CGRectMake(xCoord,
                                                                   yCoord,
                                                                   27.5f,
                                                                   27.5f)];
    self._artistThumbnail.layer.cornerRadius = self._artistThumbnail.frame.size.width/2;
    self._artistThumbnail.layer.masksToBounds = YES;

    [self setBackgroundImage:@"profile_photo.png" forView:self._artistThumbnail];

    [self._scrollView addSubview:self._artistThumbnail];
}

- (void)buildTagTitle {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding + self._artistThumbnail.frame.size.width + kSmallPadding;
    CGFloat yCoord = self.view.frame.origin.y + kSmallPadding;

    self._pieceTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                             yCoord,
                                                             100.0f,
                                                             15.0f)];

    NSAttributedString *text = [TAGViewHelpers attributeText:@"Ape Do Good Printing" forFontSize:10.0f];
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

    NSAttributedString *text = [TAGViewHelpers attributeText:@"Lonnie Spoon" forFontSize:10.0f];
    [self._artistName setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self._artistName numberOfLines:0];

    [self._scrollView addSubview:self._artistName];
}

- (void)renderCellImage {
    CGFloat xCoord = self.view.frame.origin.x;
    CGFloat yCoord = self._artistThumbnail.frame.origin.y + self._artistThumbnail.frame.size.height + kBigPadding;
    CGRect imageFrame = CGRectMake(xCoord, yCoord, 320.0f, 320.0f);

    self._image = [[UIView alloc] initWithFrame:imageFrame];

    [self setBackgroundImage:@"ape_do_good_printing_SF.png" forView:self._image];

    [self._scrollView addSubview:self._image];
}

- (void)renderFavoriteCounter {
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding;
    self._favoriteCounter = [[UILabel alloc] initWithFrame:CGRectMake(xCoord,
                                                                  367.5f,
                                                                  100.0f,
                                                                  20.0f)];
    FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:10];
    NSAttributedString *heartFont = [heart attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];

    NSMutableAttributedString *favoriteCount =[[NSMutableAttributedString alloc] initWithString:@" 1023" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,heartIcon.length)];
    [heartIcon appendAttributedString:favoriteCount];

    [self._favoriteCounter setAttributedText:heartIcon];

    [self.view addSubview:self._favoriteCounter];
}

- (void)renderActionButtons {
    [self renderLikeButton];
    [self renderCommentButton];
}

- (void)renderLikeButton{
    CGFloat xCoord = self.view.frame.origin.x + kSmallPadding;
    self._likeButton = [[UIButton alloc] initWithFrame:CGRectMake(xCoord,
                                                                 367.5f,
                                                                 50.0f,
                                                                 20.0f)];
    FAKFontAwesome *heartIcon = [FAKFontAwesome heartIconWithSize:10];
    [TAGViewHelpers formatButton:self._likeButton forIcon:heartIcon withCopy:@"Like  "];
    [self._scrollView addSubview:self._likeButton];
}

- (void)renderCommentButton{
    CGFloat xCoord = self.view.frame.origin.x + kBigPadding + 50.0f;
    self._commentButton = [[UIButton alloc] initWithFrame:CGRectMake(xCoord,
                                                                    367.5f,
                                                                    70.0f,
                                                                    20.0f)];
    FAKFontAwesome *commentIcon = [FAKFontAwesome commentIconWithSize:10];
    [TAGViewHelpers formatButton:self._likeButton forIcon:commentIcon withCopy:@"Comment  "];
    [self._scrollView  addSubview:self._likeButton];
}

- (void)setBackgroundImage:(NSString *)imageName forView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:imageName];
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
