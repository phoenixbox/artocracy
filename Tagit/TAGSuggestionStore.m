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
        suggestionStore = [[TAGSuggestionStore alloc] init];
    };
    return suggestionStore;
}

- (void)saveSuggestionImage:(NSData *)imageData withCompletionBlock:(void (^)(NSURL *s3ImageLocation, NSError *))imageUploadedBlock {
    self.imageUploaded = imageUploadedBlock;
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];

    self.tm = [S3TransferManager new];
    self.tm.s3 = s3;
    self.tm.delegate = self;

    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSLog(@"%@",uuid);

    [self.tm uploadData:imageData bucket:@"artocracy.bananas" key:uuid];
}

-(void)request:(AmazonServiceRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData called");
}

-(void)request:(AmazonServiceRequest *)request didSendData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten totalBytesExpectedToWrite:(long long)totalBytesExpectedToWrite;
{
    NSLog(@"didSendData called: %lld - %lld / %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
}

-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    self.imageUploaded(request.url,nil);
    NSLog(@"didCompleteWithResponse called: %@", response);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    self.imageUploaded(request.url,error);
    NSLog(@"didFailWithError called: %@", error);
}

- (void)createSuggestion:(NSMutableDictionary *)parameters withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))returnToUserProfile {
    returnToUserProfile(nil, nil);
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPISubmissionCreate withRouteParams:nil optionalParams:nil];
//
//    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        // Return to the users profile
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
}

- (NSString *)pictureBucket {
    return [[NSString stringWithFormat:@"%@-%@", PICTURE_BUCKET, ACCESS_KEY_ID] lowercaseString];
}

@end


