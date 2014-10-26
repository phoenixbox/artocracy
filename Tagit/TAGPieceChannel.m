//
//  TAGFeedItemChannel.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGPieceChannel.h"

@implementation TAGPieceChannel

- (TAGPiece *)findById:(NSNumber*)pieceId {
    TAGPiece *piece;

    for (TAGPiece* piece in self.pieces){
        if([piece.id isEqualToNumber:pieceId]){
            return piece;
        }
    }

    return piece;
}

@end
