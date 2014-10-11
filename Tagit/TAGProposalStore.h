//
//  TAGProposalStore.h
//  Tagit
//
//  Created by Shane Rogers on 10/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGProposalChannel.h"

@interface TAGProposalStore : NSObject {
    NSMutableArray *proposals;
}

+ (TAGProposalStore *)sharedStore;

@end