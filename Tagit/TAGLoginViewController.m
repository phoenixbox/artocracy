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

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self selector:@selector(handleKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)paramAnimated{
    [super viewWillDisappear:paramAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    self._scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self._scrollView setContentSize:CGSizeMake(self.view.bounds.size.width,self.view.bounds.size.height)];

    self._scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    self._scrollView.delegate = self;

    [self.view addSubview:self._scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"SCROLLING");
}

- (void)renderLogoPlaceholderAndSubheader {
    self._logoHero = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,290.0f, 57.0f)];
    self._logoHero.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"art_logo.png"];
    [self._logoHero setImage:logoImage];
    [self._logoHero setCenter:CGPointMake(self.view.frame.size.width/2, 130.0f)];

    float subheaderYCoord = self._logoHero.frame.origin.y + self._logoHero.frame.size.height + 40;
    self._logoSubheader = [[UIImageView alloc]initWithFrame:CGRectMake(0.0, subheaderYCoord, 220.0, 45.0)];
    self._logoSubheader.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *subheaderImage = [UIImage imageNamed:@"art_subheader.png"];
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
    [self._scrollView addSubview:self._passwordField];
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
    self._loginButton.backgroundColor = kTagitBlack;
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

- (void)handleKeyboardWillShow:(NSNotification *)paramNotification {
    NSDictionary *userInfo = paramNotification.userInfo;

    NSValue *animationDurationObject = userInfo[UIKeyboardAnimationDurationUserInfoKey];

    NSValue *keyboardEndRectObject = userInfo[UIKeyboardFrameEndUserInfoKey];

    double animationDuration = 0.0;
    CGRect keyboardEndRect = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
    [animationDurationObject getValue:&animationDuration];
    [keyboardEndRectObject getValue:&keyboardEndRect];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    /* Convert the frame from window's coordinate system to our view's coordinate system */
    keyboardEndRect = [self.view convertRect:keyboardEndRect fromView:window];
    /* Find out how much of our view is being covered by the keyboard */
    CGRect intersectionOfKeyboardRectAndWindowRect = CGRectIntersection(self.view.frame, keyboardEndRect);
    /* Scroll the scroll view up to show the full contents of our view */
    [UIView animateWithDuration:animationDuration animations:^{
        self._scrollView.contentInset =
        UIEdgeInsetsMake(0.0f,
                         0.0f,
                         intersectionOfKeyboardRectAndWindowRect.size.height,
                         0.0f);
        [self._scrollView scrollRectToVisible:self._loginButton.frame animated:NO];
    }];
}

- (void) handleKeyboardWillHide:(NSNotification *)paramSender{
    NSDictionary *userInfo = [paramSender userInfo];
    NSValue *animationDurationObject = [userInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey];

    double animationDuration = 0.0;
    [animationDurationObject getValue:&animationDuration];

    [UIView animateWithDuration:animationDuration animations:^{
        self._scrollView.contentInset = UIEdgeInsetsZero;
    }];
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
