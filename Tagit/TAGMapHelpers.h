//
//  TAGMapHelpers.h
//  Tagit
//
//  Created by Shane Rogers on 10/6/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <Foundation/Foundation.h>

// Map Module
#import <MapKit/MapKit.h>
// Location module
#import <CoreLocation/CoreLocation.h>

@interface TAGMapHelpers : NSObject

+ (MKAnnotationView *)annotation:(id <MKAnnotation>)annotation forMap:(MKMapView *)mapView;

@end
