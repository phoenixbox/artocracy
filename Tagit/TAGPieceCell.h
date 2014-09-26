//
//  TAGPieceCell.h
//  Tagit
//
//  Created by Shane Rogers on 9/11/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGPieceCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *artistThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *pieceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pieceImage;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UILabel *heartIcon;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;

- (void)styleCounter;

@end
