//
//  TAGProposalStore.m
//  Tagit
//
//  Created by Shane Rogers on 10/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProposalStore.h"
#import "AFNetworking.h"
#import "TAGAuthStore.h"
#import "TAGRoutesConstants.h"
#import "TAGStyleConstants.h"

@implementation TAGProposalStore

+ (TAGProposalStore *)sharedStore {
    static TAGProposalStore *sessionStore = nil;

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        sessionStore = [[TAGProposalStore alloc] init];
    });
    return sessionStore;
}

@end
