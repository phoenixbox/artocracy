//
//  TAGMapAnnotation.h
//  Tagit
//
//  Created by Shane Rogers on 8/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

extern NSString *const kReusablePinRed;
extern NSString *const kReusablePinGreen;
extern NSString *const kReusablePinPurple;

@interface TAGMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, unsafe_unretained, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *subtitle;
@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;

+ (NSString *) reusableIdentifierforPinColor:(MKPinAnnotationColor)paramColor;

- (instancetype) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
                               title:(NSString *)title
                            subtitle:(NSString *)subtitle;

@end
