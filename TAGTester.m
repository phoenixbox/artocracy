//
//  TAGTester.m
//  Tagit
//
//  Created by Shane Rogers on 10/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Subliminal/Subliminal.h>

@interface TAGTester : SLTest

@end

@implementation TAGTester

- (void)setUpTest {
	// Navigate to the part of the app being exercised by the test cases,
	// initialize SLElements common to the test cases, etc.
}

- (void)tearDownTest {
	// Navigate back to "home", if applicable.
}

- (void)testLogInSucceedsWithUsernameAndPassword {
    SLTextField *usernameField = [SLTextField elementWithAccessibilityLabel:@"username field"];
    SLTextField *passwordField = [SLTextField elementWithAccessibilityLabel:@"password field"];
    SLElement *submitButton = [SLElement elementWithAccessibilityLabel:@"Submit"];
    SLElement *loginSpinner = [SLElement elementWithAccessibilityLabel:@"Logging in..."];

    NSString *username = @"Jeff", *password = @"foo";
    [usernameField setText:username];
    [passwordField setText:password];

    [submitButton tap];

    // wait for the login spinner to disappear
    SLAssertTrueWithTimeout([loginSpinner isInvalidOrInvisible],
                            3.0, @"Log-in was not successful.");

    NSString *successMessage = [NSString stringWithFormat:@"Hello, %@!", username];
    SLAssertTrue([[SLElement elementWithAccessibilityLabel:successMessage] isValid],
                 @"Log-in did not succeed.");
}

@end
