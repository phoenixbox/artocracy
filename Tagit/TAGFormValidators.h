//
//  TAGFormValidators.h
//  Tagit
//
//  Created by Shane Rogers on 11/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGFormValidators : NSObject

+ (BOOL)segmentControlIsSet:(UISegmentedControl *)control;

+ (BOOL)inputFieldEmpty:(UITextField *)textField;

@end
