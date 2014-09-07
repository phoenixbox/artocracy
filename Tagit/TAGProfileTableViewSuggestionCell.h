//
//  TAGProfileTableViewCell.h
//  Tagit
//
//  Created by Shane Rogers on 8/24/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Pods
#import "URBMediaFocusViewController.h"

@interface TAGProfileTableViewSuggestionCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *image;
@property (nonatomic, strong) UILabel *location;

@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *locationAddress;

@property (nonatomic, strong) UIView *visualSep;

@property (nonatomic, strong) UIView *pieceIcon;
@property (nonatomic, strong) UILabel *counter;

@property (nonatomic, strong) UITableView *piecesTable;

@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) float lateralTableCellDimension;
@property (nonatomic, assign) NSString *imageName;

@property (nonatomic, strong) URBMediaFocusViewController *lightboxViewController;

@end
