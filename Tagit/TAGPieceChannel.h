//
//  TAGFeedItemChannel.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGPiece.h"
#import "JSONModel.h"

@interface TAGPieceChannel : JSONModel

@property (strong, nonatomic) NSMutableArray<TAGPiece> *pieces;

- (TAGPiece *)findById:(NSNumber *)pieceId;

@end
