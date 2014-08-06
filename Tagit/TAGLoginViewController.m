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

#import "TAGStyleConstants.h"
#import "TAGRoutesConstants.h"

@interface TAGLoginViewController ()

@property (nonatomic, strong) UIImageView *_logoHero;
@property (nonatomic, strong) UIImageView *_logoSubheader;
@property (nonatomic, strong) UIScrollView *_scrollView;
@property (nonatomic, strong) UITextField *_emailField;
@property (nonatomic, strong) UITextField *_passwordField;
@property (nonatomic, strong) UIButton *_loginButton;
@property (nonatomic, strong) UIActivityIndicatorView *_requestIndicator;

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //  TODO: Implement scroll view for login screen
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    [self renderScrollView];
    
    [self renderLogoPlaceholderAndSubheader];
    [self renderEmailField];
    [self renderPasswordField];
    [self renderLoginButton];
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

- (void)renderEmailField {
    float emailYCoord = self._logoSubheader.frame.origin.y + self._logoSubheader.frame.size.height + 40;
    CGRect emailFieldFrame = CGRectMake(0.0f,emailYCoord, self._logoSubheader.frame.size.width, 40.0f);
    self._emailField = [[UITextField alloc] initWithFrame:emailFieldFrame];
    self._emailField.text = kSeedEmail;
    [self._emailField setCenter:CGPointMake(self.view.frame.size.width/2, emailYCoord)];
    
    [self formatTextField:self._emailField];
}

- (void)renderPasswordField {
    CGRect passwordFieldFrame = self._emailField.frame;
    passwordFieldFrame.origin.y += self._emailField.frame.size.height + 10;
    self._passwordField = [[UITextField alloc] initWithFrame:passwordFieldFrame];
    self._passwordField.secureTextEntry = YES;
    self._passwordField.text = kSeedPassword;
    
    [self formatTextField:self._passwordField];
}

- (void)formatTextField:(UITextField *)textField {
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.textAlignment = NSTextAlignmentCenter;
    [self._scrollView addSubview:textField];
}

- (void)renderLoginButton {
    CGRect loginButtonFrame = self._passwordField.frame;
    loginButtonFrame.origin.y += self._passwordField.frame.size.height + 10;
    self._loginButton = [[UIButton alloc]initWithFrame:loginButtonFrame];
    [self._loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self._loginButton setTitleColor:kPureWhite forState:UIControlStateNormal];
    self._loginButton.backgroundColor = kTagitBlue;
    [self._loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self._scrollView addSubview:self._loginButton];
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
- (void)handleKeyboardDidShow:(NSNotification *)notification {
    NSValue *keyboardRectAsObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = CGRectZero;
    
    [keyboardRectAsObject getValue:&keyboardRect];
    
    self._scrollView.contentInset = UIEdgeInsetsMake(0.0f,0.0f,keyboardRect.size.height+180,0.0f);
}

- (void)handleKeyboardWillHide:(NSNotification *)notification {
    self._scrollView.contentInset = UIEdgeInsetsZero;
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self._emailField resignFirstResponder];
    [self._passwordField resignFirstResponder];
    return YES;
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
