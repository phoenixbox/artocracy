//
//  TAGLoginViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/2/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGLoginViewController.h"
#import "TAGViewConstants.h"

@interface TAGLoginViewController ()

@property (nonatomic, strong) UIImageView *_logoHero;
@property (nonatomic, strong) UIImageView *_logoSubheader;
@property (nonatomic, strong) UIScrollView *_scrollView;

@end

@implementation TAGLoginViewController

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
    [self renderScrollView];
    [self renderLogoPlaceholderAndSubheader];
}

- (void)renderScrollView {
    self._scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self._scrollView];
}

- (void)renderLogoPlaceholderAndSubheader {
    self._logoHero = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,200.0f, 114.0f)];
    self._logoHero.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    [self._logoHero setImage:logoImage];
    [self._logoHero setCenter:CGPointMake(self.view.frame.size.width/2, 130.0f)];

    float subheaderYCoord = self._logoHero.frame.origin.y + self._logoHero.frame.size.height + 40;
    self._logoSubheader = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, subheaderYCoord, 200.0, 40.0)];
    self._logoSubheader.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *subheaderImage = [UIImage imageNamed:@"subheader.png"];
    [self._logoSubheader setImage:subheaderImage];
    [self._logoSubheader setCenter:CGPointMake(self.view.frame.size.width/2, self._logoSubheader.frame.origin.y)];
    
    [self._scrollView addSubview:self._logoHero];
    [self._scrollView addSubview:self._logoSubheader];
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
