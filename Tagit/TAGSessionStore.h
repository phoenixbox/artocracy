//
//  TAGSessionStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol TAGSessionStore @end

@interface TAGSessionStore : JSONModel

@property (nonatomic) NSNumber *id;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *authenticationToken;

+ (TAGSessionStore *)sharedStore;
- (void)login:(NSDictionary *)loginParams withCompletionBlock:(void (^)(TAGSessionStore *session, NSError *err))block;

@end
