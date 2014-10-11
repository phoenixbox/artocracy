//
//  TAGProposalChannel.h
//  Tagit
//
//  Created by Shane Rogers on 10/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JSONModel.h"
// Data Layer
#import "TAGProposal.h"

@interface TAGProposalChannel : JSONModel

@property (strong, nonatomic) NSMutableArray<TAGProposal> *proposals;

@end