//
//  TAGProfileHeaderSummaryViewController.h
//  Tagit
//
//  Created by Shane Rogers on 8/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGProfileHeaderSummaryViewController : UIViewController

@property (nonatomic, strong) UIView *icon;
@property (nonatomic, strong) UILabel *counter;
@property (nonatomic, strong) UILabel *label;

- (id)initWithImage:(NSString *)imageName andLabel:(NSString *)labelName;

@end