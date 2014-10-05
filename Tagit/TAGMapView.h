//
//  TAGMapView.h
//  Tagit
//
//  Created by Shane Rogers on 8/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Map Module
#import <MapKit/MapKit.h>
// Location module
#import <CoreLocation/CoreLocation.h>

@interface TAGMapView : MKMapView

- (id)initWithFrame:(CGRect)frame forDelegate:(UICollectionViewCell *)delegate;

@end
