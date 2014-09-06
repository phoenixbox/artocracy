//
//  TAGMapViewController.h
//  Tagit
//
//  Created by Shane Rogers on 8/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGMapViewController : UIViewController

@property (nonatomic, assign) CGRect mapFrame;

- (void)reverseGeocodeUserLocationWithCompletionBlock:(void (^)(NSMutableDictionary *suggestionParams, NSError *err))finishedGeocodingBlock;

- (id)initWithFrame:(CGRect)frame;

@end
