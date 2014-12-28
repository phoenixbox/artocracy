//
//  TAGToolsStore.h
//  
//
//  Created by Shane Rogers on 12/28/14.
//
//

#import <Foundation/Foundation.h>

@interface TAGToolsStore : NSObject

+ (instancetype)sharedStore;

- (NSMutableArray *)allTools;

- (void)generateToolOptions;

@end