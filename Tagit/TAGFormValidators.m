//
//  TAGFormValidators.m
//  Tagit
//
//  Created by Shane Rogers on 11/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGFormValidators.h"

@implementation TAGFormValidators

+ (BOOL)segmentControlIsSet:(UISegmentedControl *)control {
    return [control titleForSegmentAtIndex:control.selectedSegmentIndex];
}

+ (BOOL)inputFieldEmpty:(UITextField *)textField {
    return [[textField text] length] < 1;
}

@end