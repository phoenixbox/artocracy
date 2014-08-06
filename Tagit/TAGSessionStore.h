//
//  TAGSessionStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol SDRSessionStore @end

@interface TAGSessionStore : JSONModel

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *authentication_token;

+ (TAGSessionStore *)sharedStore;
- (void)login:(NSDictionary *)loginParams withCompletionBlock:(void (^)(TAGSessionStore *session, NSError *err))block;

@end
