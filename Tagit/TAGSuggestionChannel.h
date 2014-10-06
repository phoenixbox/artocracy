//
//  TAGSuggestionChannel.h
//  Tagit
//
//  Created by Shane Rogers on 10/5/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TAGSuggestion.h"
#import "JSONModel.h"

@interface TAGSuggestionChannel : JSONModel

@property (strong, nonatomic) NSMutableArray<TAGSuggestion> *suggestions;

@end
