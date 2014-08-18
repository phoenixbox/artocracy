//
//  TAGFeedStore.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGTagStore.h"
#import "TAGAuthStore.h"
#import "TAGTagChannel.h"

#import "TAGRoutesConstants.h"
#import "AFNetworking.h"

@implementation TAGTagStore

+ (TAGTagStore *)sharedStore {
    static TAGTagStore *tagStore = nil;

    if (!tagStore) {
        tagStore = [[TAGTagStore alloc]init];
    };
    return tagStore;
}

- (void)fetchTagsWithCompletion:(void (^)(TAGTagChannel *tagChannel, NSError *err))block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    NSString *requestURL = [TAGAuthStore authenticateRequest:kAPITagsIndex];

    [manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString* rawJSON = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        TAGTagChannel *tagChannel = [[TAGTagChannel alloc] initWithString:rawJSON error:nil];
        
        block(tagChannel, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


@end
