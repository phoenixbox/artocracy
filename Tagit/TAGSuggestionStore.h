//
//  TAGSubmissionStore.h
//  Tagit
//
//  Created by Shane Rogers on 8/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

// Data Layer
#import "TAGSuggestion.h"
#import "TAGSuggestionChannel.h"
#import "TAGProposalChannel.h"

// AmazonS3 video
#import <AWSS3/AWSS3.h>
#import <AWSRuntime/AWSRuntime.h>

@interface TAGSuggestionStore : NSObject <AmazonServiceRequestDelegate> {
    NSMutableArray *suggestions;
}

@property (nonatomic, copy) void(^imageUploadedBlock)(NSURL *s3ImageLocation, NSError *);
@property (nonatomic, strong) NSMutableArray *allUsersSuggestions;

+ (TAGSuggestionStore *)sharedStore;

- (void)addUniqueSuggestion:(TAGSuggestion *)suggestion;

- (void)saveSuggestionImage:(NSData *)imageData withCompletionBlock:(void (^)(NSURL *s3ImageLocation, NSError *))imageUploadedBlock;

- (void)createSuggestion:(NSMutableDictionary *)parameters withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))returnToUserProfile;

- (void)fetchSuggestionsWithCompletion:(void (^)(TAGSuggestionChannel *suggestionChannel, NSError *err))block;

- (void)fetchProposalsForSuggestion:(NSNumber *)suggestionId withCompletionBlock:(void (^)(TAGProposalChannel *feedChannel, NSError *err))block;

@end
