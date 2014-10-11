//
//  TAGSubmission.h
//  Tagit
//
//  Created by Shane Rogers on 8/12/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol TAGSuggestion @end

@interface TAGSuggestion : JSONModel

@property (nonatomic) NSNumber *id;
@property (nonatomic) NSNumber *suggestorId;
@property (nonatomic) NSNumber *proposalCount;
@property (nonatomic) NSNumber<Optional> *upvoteCount;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zipCode;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *canvasType;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *suggestorEmail;
@property (nonatomic, strong) NSString *suggestorImageURL;

@end
