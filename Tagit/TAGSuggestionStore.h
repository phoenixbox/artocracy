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

@property (nonatomic, retain) S3TransferManager *tm;
@property (nonatomic, retain) AmazonS3Client *s3;
@property (nonatomic, copy) void(^imageUploaded)(NSURL *s3ImageLocation, NSError *);

+ (TAGSuggestionStore *)sharedStore;

- (void)saveSuggestionImage:(NSData *)imageData withCompletionBlock:(void (^)(NSURL *s3ImageLocation, NSError *))imageUploadedBlock;

- (void)createSuggestion:(NSMutableDictionary *)parameters withCompletionBlock:(void (^)(TAGSuggestion *suggestion, NSError *err))returnToUserProfile;

@end
