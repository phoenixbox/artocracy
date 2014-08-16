//
//  TAGsuggestionStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionStore.h"
#import "TAGsuggestion.h"
#import "TAGAuthStore.h"
#import "TAGErrorAlert.h"

// Constants
#import "TAGRoutesConstants.h"
#import "TAGAppConstants.h"

// Modules
#import "AFNetworking.h"
#import <AWSRuntime/AWSRuntime.h>

#define ACCESS_KEY_ID          @"AKIAIESK6XLNAJWROT4Q"
#define SECRET_KEY             @"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"

// Constants for the Bucket and Object name.
#define PICTURE_BUCKET         @"mule.inventoryvideos"
#define PICTURE_NAME           @"tester"

@implementation TAGSuggestionStore

+ (TAGSuggestionStore *)sharedStore {
    static TAGSuggestionStore *suggestionStore = nil;

    if (!suggestionStore) {
        suggestionStore = [[TAGSuggestionStore alloc]init];
    };
    return suggestionStore;
}

- (void)saveSuggestionPhoto:(NSData *)imageData withCompletionBlock:(void (^)(NSString *imageURL, NSError *err))block {
    self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    self.s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];

    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:@"BANANA" inBucket:@"mule.inventoryvideos"];
    por.contentType = @"image/jpeg";
    por.data        = imageData;

    por.delegate = self;
    [self.s3 putObject:por];
}

- (void)createSuggestion:(NSDictionary *)parameters withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPISubmissionCreate withRouteParams:nil optionalParams:nil];

    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (NSString *)pictureBucket {
    return [[NSString stringWithFormat:@"%@-%@", PICTURE_BUCKET, ACCESS_KEY_ID] lowercaseString];
}

@end


