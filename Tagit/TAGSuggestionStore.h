//
//  TAGSubmissionStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TAGSuggestion.h"

// AmazonS3 video
#import <AWSS3/AWSS3.h>

@interface TAGSuggestionStore : NSObject <AmazonServiceRequestDelegate>

@property (nonatomic, retain) AmazonS3Client *s3;

+ (TAGSuggestionStore *)sharedStore;

- (void)saveSuggestionPhoto:(NSData *)imageData withCompletionBlock:(void (^)(NSString *imageURL, NSError *err))block;
- (void)createSuggestion:(NSDictionary *)parameters withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))block;

@end
