//
//  TAGS3Configuration.h
//  Tagit
//
//  Created by Shane Rogers on 11/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

// AmazonS3 Dependencies
#import <AWSS3/AWSS3.h>
#import <AWSRuntime/AWSRuntime.h>

@interface TAGS3Configuration : NSObject

+ (NSDictionary *)s3ConfigurationObject;

+ (S3TransferManager *)createTransferManager;

+ (S3PutObjectRequest *)createPutObjectRequestWithImageData:(NSData *)imageData;

@end
