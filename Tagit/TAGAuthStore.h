//
//  TAGAuthStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGAuthStore : NSObject

+ (NSString *)authenticateRequest:(NSString *)requestURL withRouteParams:(NSString *)routeParams optionalParams:(NSString *)optionalParams;

@end
