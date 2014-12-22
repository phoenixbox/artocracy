//
//  TAGFiltersStore.h
//  Tagit
//
//  Created by Shane Rogers on 12/22/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TAGFiltersStore : NSObject

+ (instancetype)sharedStore;

- (void)generateFiltersForImage:(UIImage *)image;

- (NSMutableArray *)allFilters;

@end
