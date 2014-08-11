//
//  TAGMapView.h
//  Tagit
//
//  Created by Shane Rogers on 8/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Location modules
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TAGMapView : MKMapView <MKMapViewDelegate, CLLocationManagerDelegate>

@end
