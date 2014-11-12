//
//  TAGPieceCell.h
//  Tagit
//
//  Created by Shane Rogers on 9/11/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Data Layer
#import "TAGPiece.h"
#import "TAGFavorite.h"

// Components
#import "TAGSpinner.h"

extern NSString *const kSetHeaderInfoNotification;
extern NSString *const kSetHeaderInfoFavoriteCount;

@interface TAGPieceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *artistThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *pieceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pieceImage;
@property (nonatomic, strong)TAGSpinner *spinner;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UILabel *heartIcon;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCount;

@property (strong, nonatomic) TAGPiece *piece;
@property (strong, nonatomic) TAGFavorite *favorite;

- (void)styleCounter;

- (void)getLikeState;

- (void)attributeWithModel:(TAGPiece *)model;

@end
