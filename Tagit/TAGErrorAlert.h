//
//  TAGErrorAlert.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGErrorAlert : NSObject

+(void)render:(NSError *)err;

@end
