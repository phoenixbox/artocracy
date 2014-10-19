//
//  TAGDetailViewController.h
//  Tagit
//
//  Created by Shane Rogers on 8/30/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Data Layer
#import "TAGPiece.h"

@interface TAGPieceDetailViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

- (void)setViewWithModel:(TAGPiece *)model;

@end
