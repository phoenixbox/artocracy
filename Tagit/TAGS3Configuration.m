//
//  TAGS3Configuration.m
//  Tagit
//
//  Created by Shane Rogers on 11/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGS3Configuration.h"

#define ACCESS_KEY_ID          @"AKIAI5KPOFQMMN5FNU5Q"
#define SECRET_KEY             @"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"

// Constants for the Bucket and Object name.
#define PICTURE_BUCKET         @"artocracy"

@implementation TAGS3Configuration

+ (NSDictionary *)s3ConfigurationObject {
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];

    s3.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];

    NSDictionary *config = @{ @"s3" : s3 };

    return config;
}

+ (S3TransferManager *)createTransferManager {
    S3TransferManager *tm = [S3TransferManager new];
    tm.s3 = [[self s3ConfigurationObject] objectForKey:@"s3"];

    return tm;
}

+ (S3PutObjectRequest *)createPutObjectRequestWithImageData:(NSData *)imageData {
    NSString *uuid = [[NSUUID UUID] UUIDString];

    S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:uuid inBucket:PICTURE_BUCKET];
    por.contentType = @"image/jpeg";
    por.cannedACL   = [S3CannedACL publicRead];
    por.data        = imageData;

    return por;
}


@end
