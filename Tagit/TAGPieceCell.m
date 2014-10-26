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

// Components
#import "TAGErrorAlert.h"

// Data Layer
#import "TAGFavoriteStore.h"
#import "TAGSessionStore.h"
#import "TAGPiece.h"

// Constants
#import "TAGViewHelpers.h"

NSString *const kSetHeaderInfoNotification = @"SetHeaderInfoNotification";
NSString *const kSetHeaderInfoFavoriteCount = @"favoriteCount";

@implementation TAGPieceCell

- (void)getLikeState {
    void(^completionBlock)(TAGFavorite *favorite, NSError *err)=^(TAGFavorite *favorite, NSError *err) {
        if(!err){
            self.favorite = favorite;
            [TAGViewHelpers setButtonState:YES forButton:self.likeButton withBackgroundColor:[UIColor greenColor] andCopy:@"Liked"];
        } else {
            [TAGViewHelpers setButtonState:NO forButton:self.likeButton withBackgroundColor:[UIColor blackColor] andCopy:@"Like"];
        }
        [self addSubview:self.likeButton];
    };

    [[TAGFavoriteStore sharedStore] getFavoriteForPiece:self.piece.id withCompletionBlock:completionBlock];
}


- (void)styleCounter {
    FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:15];
    NSAttributedString *heartFont = [heart attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];

    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,heartIcon.length)];

    [self.heartIcon setAttributedText:heartIcon];
}

- (IBAction)likePiece:(UIButton *)button {
    if (!button.selected){
        [self favoritePiece:button];
    } else {
        [self unFavoritePiece:button];
    }
}

- (void)favoritePiece:(UIButton *)button {
    void (^completionBlock)(TAGFavorite *favorite, NSError *err)=^(TAGFavorite *favorite, NSError *err) {
        if(!err){
            self.favorite = favorite;
            [TAGViewHelpers setButtonState:YES forButton:self.likeButton withBackgroundColor:[UIColor greenColor] andCopy:@"Liked"];
        } else {
            [TAGErrorAlert render:err];
        }

        [self sendHeaderUpdateNotification:favorite.count];
    };

    [[TAGFavoriteStore sharedStore] createFavoriteForPiece:self.piece.id withCompletionBlock:completionBlock];
}

- (void)unFavoritePiece:(UIButton *)button {
    void(^completionBlock)(TAGPiece *piece, NSError *err)=^(TAGPiece *piece, NSError *err) {
        if(!err){
            self.piece = piece;
            self.favorite = nil;
            [TAGViewHelpers setButtonState:NO forButton:self.likeButton withBackgroundColor:[UIColor blackColor] andCopy:@"Like"];
        } else {
            [TAGErrorAlert render:err];
        }
        [self sendHeaderUpdateNotification:self.piece.favoriteCount];
    };

    [[TAGFavoriteStore sharedStore] destroyFavorite:self.favorite.id withCompletionBlock:completionBlock];
}

#pragma Header Notification
- (void)sendHeaderUpdateNotification:(NSNumber *)favoriteCount {

    NSNotification *notification = [NSNotification notificationWithName:kSetHeaderInfoNotification
                                                                 object:self
                                                               userInfo:@{ kSetHeaderInfoFavoriteCount: favoriteCount }];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)commentOnPiece:(UIButton *)sender {
    NSLog(@"Comment on Piece");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
