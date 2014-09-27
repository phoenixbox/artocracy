//
//  TAGCollectionPresenterViewController.h
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kCollectionViewPresenter;
extern NSString *const kTableViewPresenter;

@interface TAGProfileCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end
