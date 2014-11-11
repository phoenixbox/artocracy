//
//  TAGsuggestionStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionStore.h"
#import "TAGErrorAlert.h"

// Constants
#import "TAGRoutesConstants.h"
#import "TAGAppConstants.h"

// Modules
#import "AFNetworking.h"

// Data Layer
#import "TAGAuthStore.h"
#import "TAGSessionStore.h"

// Helpers
#import "TAGS3Configuration.h"

@implementation TAGSuggestionStore

+ (TAGSuggestionStore *)sharedStore {
    static TAGSuggestionStore *suggestionStore = nil;

    if (!suggestionStore) {
        suggestionStore = [[TAGSuggestionStore alloc] init];
    };
    return suggestionStore;
}

// TODO: Refactor
- (void)addUniqueSuggestion:(TAGSuggestion *)suggestion {
    if(!self.allUsersSuggestions){
        self.allUsersSuggestions = [NSMutableArray new];
    }

    if ([self.allUsersSuggestions containsObject:suggestion]) {
        [self.allUsersSuggestions addObject:suggestion];
    }
}

- (void)saveSuggestionImage:(NSData *)imageData withCompletionBlock:(void (^)(NSURL *s3ImageLocation, NSError *))imageUploadedBlock {
    self.imageUploadedBlock = imageUploadedBlock;

    // RESTART: Compose 23 configuration and use across the suggestion and the pieces
    S3TransferManager *tm = [TAGS3Configuration createTransferManager];
    tm.delegate = self;

    S3PutObjectRequest *por = [TAGS3Configuration createPutObjectRequestWithImageData:imageData];
    por.delegate = self;

    [tm upload:por];
}

- (void)createSuggestion:(NSMutableDictionary *)parameters withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))returnToUserProfile {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPISuggestionsCreate];

    TAGSessionStore *session = [TAGSessionStore sharedStore];

    NSDictionary *suggestionParams = @{@"suggestion": parameters, @"user_id": [session.id stringValue]};

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
        NSString *rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGSuggestionChannel *suggestionChannel = [[TAGSuggestionChannel alloc] initWithString:rawJSON error:nil];

        block(suggestionChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)fetchProposalsForSuggestion:(NSNumber *)suggestionId withCompletionBlock:(void (^)(TAGProposalChannel *proposalChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *urlSegment = [[NSString alloc] initWithFormat:@"/%@/proposals", suggestionId];
    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPISuggestionsProposalsIndex withURLSegment:urlSegment];

    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGProposalChannel *proposalChannel = [[TAGProposalChannel alloc] initWithString:rawJSON error:nil];

        block(proposalChannel, nil);
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


