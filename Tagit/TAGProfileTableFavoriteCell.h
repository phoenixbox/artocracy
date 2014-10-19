//
//  TAGProfileTableViewFavoriteCell.h
//  Tagit
//
//  Created by Shane Rogers on 8/27/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Data Layer
#import "TAGPiece.h"

@interface TAGProfileTableFavoriteCell : UITableViewCell

@property (nonatomic, strong) UIView *favoriteImage;

@property (nonatomic, strong) UILabel *artistLabel;
@property (nonatomic, strong) UILabel *artistName;

@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UILabel *locationName;

@property (nonatomic, strong) UILabel *canvasTypeLabel;
@property (nonatomic, strong) UILabel *canvasTypeName;

@property (nonatomic, strong) UIView *visualSep;

@property (nonatomic, strong) UIView *favoritesIcon;
@property (nonatomic, strong) UILabel *counter;
@property (nonatomic, strong) UILabel *favoritesLabel;

@property (nonatomic, assign) float cellHeight;
@property (nonatomic, strong) TAGPiece *favorite;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forModel:(TAGPiece *)model;

@end