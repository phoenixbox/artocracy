//
//  TAGLoginViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/2/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGLoginViewController.h"
#import "TAGAppDelegate.h"
#import "TAGSessionStore.h"
#import "TAGErrorAlert.h"

// Libs
#import "TPKeyboardAvoidingScrollView.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGViewHelpers.h"
#import "TAGRoutesConstants.h"

@interface TAGLoginViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *_logoHero;
@property (strong, nonatomic) IBOutlet UIImageView *_logoSubheader;
@property (strong, nonatomic) IBOutlet UITextField *_emailField;
@property (strong, nonatomic) IBOutlet UITextField *_passwordField;
@property (strong, nonatomic) IBOutlet UIButton *_emailButton;
@property (strong, nonatomic) IBOutlet UIButton *_igButton;
@property (nonatomic, strong) UIActivityIndicatorView *_requestIndicator;
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *_scrollView;

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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self styleButtons];

    // Development Only!
    [self setInputPlaceholders];
}

- (void)setInputPlaceholders {
    [self._emailField setText:kSeedEmail];
    self._passwordField.secureTextEntry = YES;
    [self._passwordField setText:kSeedPassword];
}

- (void)styleButtons {
    [self._emailButton setBackgroundColor:[UIColor blackColor]];
    [self._emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self._emailButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];

    [self._igButton setBackgroundColor:[UIColor blueColor]];
    [self._igButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self._igButton addTarget:self action:@selector(igLogin) forControlEvents:UIControlEventTouchUpInside];
}

- (void)igLogin {
    NSLog(@"Implement IG Login");
}

- (void)login {
    NSDictionary *loginParams = [self extractLoginInfo];
    [self setLoginActivityIndicator];

    void(^completionBlock)(TAGSessionStore *session, NSError *err)=^(TAGSessionStore *session, NSError *err){
        if(!err){
            TAGAppDelegate *appDelegate = (TAGAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate initializeNavigationControllers];
            [self._requestIndicator stopAnimating];
        } else {
            [self renderErrorMessage:err];
            [self._requestIndicator stopAnimating];
        }
    };

    [[TAGSessionStore sharedStore]login:loginParams withCompletionBlock:completionBlock];
}

- (NSDictionary *)extractLoginInfo {
    NSString *email = self._emailField.text;
    NSString *password = self._passwordField.text;
    return @{ @"email" : email, @"password" : password };
}

- (void)setLoginActivityIndicator {
    self._requestIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self._requestIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    self._requestIndicator.center = self.view.center;
    [self.view addSubview:self._requestIndicator];

    [self._requestIndicator startAnimating];
}

- (void)renderErrorMessage:(NSError *)err {
    [TAGErrorAlert render:err];

    [self._requestIndicator stopAnimating];
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
