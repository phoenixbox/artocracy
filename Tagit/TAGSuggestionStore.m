//
//  TAGsuggestionStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionStore.h"
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

- (void)addUniqueSuggestion:(TAGSuggestion *)suggestion {
    if(!self.allUsersSuggestions){
        self.allUsersSuggestions = [NSMutableArray new];
    }

    NSInteger ind = [self.allUsersSuggestions indexOfObject:suggestion];
    if (ind == NSNotFound) {
        [self.allUsersSuggestions addObject:suggestion];
    }
}

- (void)saveSuggestionImage:(NSData *)imageData withCompletionBlock:(void (^)(NSURL *s3ImageLocation, NSError *))imageUploadedBlock {
    self.imageUploadedBlock = imageUploadedBlock;
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
    s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];

    self.tm = [S3TransferManager new];
    self.tm.s3 = s3;
    self.tm.delegate = self;

    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSLog(@"%@",uuid);

    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:uuid inBucket:@"artocracy.bananas"];
    por.contentType = @"image/jpeg";
    por.cannedACL   = [S3CannedACL publicRead];
    por.data        = imageData;
    por.delegate    = self; // TODO: Required?

    [self.tm upload:por];
}

- (void)createSuggestion:(NSMutableDictionary *)parameters withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))returnToUserProfile {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPISuggestionsCreate];
    NSDictionary *suggestionParams = @{@"suggestion": parameters};

    [manager POST:requestURL parameters:suggestionParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGSuggestion *suggestion = [[TAGSuggestion alloc] initWithString:rawJSON error:nil];

        returnToUserProfile(suggestion, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchSuggestionsWithCompletion:(void (^)(TAGSuggestionChannel *suggestionChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPISuggestionsIndex];

    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TAGSuggestionChannel *suggestionChannel = [[TAGSuggestionChannel alloc] initWithData:responseObject error:nil];

        block(suggestionChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma AmazonServiceRequest Protocol Methods

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
    self.imageUploadedBlock(request.url, nil);
}

-(void)request:(AmazonServiceRequest *)request didFailWithError:(NSError *)error
{
    self.imageUploadedBlock(request.url,error);
    NSLog(@"didFailWithError called: %@", error);
}

@end


