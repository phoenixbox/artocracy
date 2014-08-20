//
//  TAGProfileViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/18/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProfileViewController.h"
#import "TAGStyleConstants.h"

#import "TAGProfileHeader.h"

// Compose the collection presenter view controller
#import "TAGCollectionPresenterViewController.h"

@interface TAGProfileViewController ()

@property (nonatomic, strong) TAGProfileHeader *_profileHeader;
@property (nonatomic, strong) TAGCollectionPresenterViewController *_collectionPresenter;

@end

@implementation TAGProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initAppearance];
    [self renderProfileSection];
    [self renderCollectionPresenter];
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
    UIImage *settingsIcon = [UIImage imageNamed:@"settingsIcon.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:settingsIcon landscapeImagePhone:settingsIcon style:UIBarButtonItemStylePlain target:self action:@selector(settings:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
}

- (void)setHeaderLogo {
    [[self navigationItem] setTitleView:nil];
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 165.0f, 32.5f)];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"art_navBarLogo.png"];
    [logoView setImage:logoImage];
    self.navigationItem.titleView = logoView;
}

- (void)settings:(id)paramSender {
}

- (void)renderProfileSection {
    self._profileHeader = [[TAGProfileHeader alloc]initWithFrame:CGRectMake(0.0f,
                                                                           0.0f,
                                                                           self.view.frame.size.width,
                                                                           75.0f)];
    [self.view addSubview:self._profileHeader];
}


-(void)renderCollectionPresenter {
    float yCoord = self._profileHeader.frame.origin.y + self._profileHeader.frame.size.height;

    self._collectionPresenter = [TAGCollectionPresenterViewController new];
    [self._collectionPresenter.view setFrame:CGRectMake(0.0f,
                                                       yCoord,
                                                       self.view.frame.size.width,
                                                       self.view.frame.size.height - yCoord)];

    [self addChildViewController:self._collectionPresenter];
    [self.view addSubview:self._collectionPresenter.view];
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
