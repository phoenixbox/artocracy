//
//  TAGFeedItemChannel.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGTag.h"
#import "JSONModel.h"

@interface TAGTagChannel : JSONModel

@property (strong, nonatomic) NSMutableArray<TAGFeedItem> *feedItems;

@end
