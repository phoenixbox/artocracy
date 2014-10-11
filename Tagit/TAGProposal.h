//
//  TAGProposal.h
//  Tagit
//
//  Created by Shane Rogers on 10/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "JSONModel.h"

@protocol TAGProposal @end

@interface TAGProposal : JSONModel

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *proposerId;
@property (nonatomic) NSNumber<Optional> *voteCount;
@property (nonatomic, strong) NSString *imageUrl;

@end