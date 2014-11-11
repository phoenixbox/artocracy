//
//  TAGErrorAlert.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGErrorAlert.h"

@implementation TAGErrorAlert

+ (void)render:(NSError *)err {
    [[[UIAlertView alloc] initWithTitle:err.localizedDescription
                                message:err.localizedRecoverySuggestion
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil, nil] show];

};

+ (void)renderWithTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:@"Form Error"
                                message:title
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil, nil] show];
}

@end
