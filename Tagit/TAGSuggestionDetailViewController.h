//
//  TAGSuggestionDetailViewController.h
//  Tagit
//
//  Created by Shane Rogers on 9/1/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAGSuggestion.h"

@interface TAGSuggestionDetailViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

- (void)setViewWithSuggestion:(TAGSuggestion *)suggestion;

@end
