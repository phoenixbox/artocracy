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

// Helpers
#import "TAGViewHelpers.h"

NSString *const kSetHeaderInfoNotification = @"SetHeaderInfoNotification";
NSString *const kSetHeaderInfoFavoriteCount = @"favoriteCount";

@implementation TAGPieceCell

-(id)initWithCoder:(NSCoder*)aDecoder {
    if((self = [super initWithCoder:aDecoder])) {
        self.spinner = [TAGSpinner new];
    }
    return self;
}

- (void)getLikeState {
    void(^completionBlock)(TAGFavorite *favorite, NSError *err)=^(TAGFavorite *favorite, NSError *err) {
        if(!err){
            self.favorite = favorite;
            [TAGViewHelpers setButtonState:YES forButton:self.likeButton withBackgroundColor:[UIColor redColor] andCopy:@"Liked"];
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
    [self startSpinner:button];
    void (^completionBlock)(TAGFavorite *favorite, NSError *err)=^(TAGFavorite *favorite, NSError *err) {
        if(!err){
            self.favorite = favorite;
        } else {
            [TAGErrorAlert render:err];
        }
        [self stopSpinner:button];

        [self sendHeaderUpdateNotification:favorite.count];
    };

    [[TAGFavoriteStore sharedStore] createFavoriteForPiece:self.piece.id withCompletionBlock:completionBlock];
}

- (void)unFavoritePiece:(UIButton *)button {
    [self startSpinner:button];
    void(^completionBlock)(TAGPiece *piece, NSError *err)=^(TAGPiece *piece, NSError *err) {
        if(!err){
            self.piece = piece;
            self.favorite = nil;
        } else {
            [TAGErrorAlert render:err];
        }

        [self stopSpinner:button];

        [self sendHeaderUpdateNotification:piece.favoriteCount];
    };

    [[TAGFavoriteStore sharedStore] destroyFavorite:self.favorite.id withCompletionBlock:completionBlock];
}

#pragma Spinner Management

- (void)startSpinner:(UIButton *)button {
    [button setEnabled:NO];
    // Wipe the button - possible use of state to decide color
    [TAGViewHelpers formatButton:button forIcon:nil withCopy:@"" withColor:[UIColor blackColor]];
    [self.spinner setHeartSpinnerForButton:button];

    [self.spinner startAnimating];

    [self addSubview:self.spinner];
}

- (void)stopSpinner:(UIButton *)button {
    [self.spinner stopAnimating];
    [self.spinner removeFromSuperview];
    [button setEnabled:YES];
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
