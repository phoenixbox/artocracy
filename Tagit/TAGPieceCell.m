//
//  TAGPieceCell.m
//  Tagit
//
//  Created by Shane Rogers on 9/11/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGPieceCell.h"

// Libs
#import "FontAwesomeKit/FAKFontAwesome.h"

@implementation TAGPieceCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)styleCounter {
    FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:15];
    NSAttributedString *heartFont = [heart attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];

    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,heartIcon.length)];

    // EXPECT: Just have the heart
    [self.heartIcon setAttributedText:heartIcon];
}

// Public method after cell renderin which takes the counter
//- (void)addCounter:(NSString *)counter {
//    NSMutableAttributedString *favoriteCount =[[NSMutableAttributedString alloc] initWithString:@" 1023" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];
//    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,heartIcon.length)];
//    [heartIcon appendAttributedString:favoriteCount];
//
//    [self.favoriteCounter setAttributedText:heartIcon];
//    [TAGViewHelpers sizeLabelToFit:self.favoriteCounter numberOfLines:1];
//
//    [self.contentView addSubview:self.favoriteCounter];
//
//}

// UIView *artistThumbnail;
// UILabel *artistLabel;
// UILabel *pieceLabel;
// UIImageView *pieceImage;
// UIButton *likeButton;
// UIButton *commentButton;
// UILabel *favoriteCounter;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
