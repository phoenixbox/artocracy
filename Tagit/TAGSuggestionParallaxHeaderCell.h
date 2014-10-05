//
//  TAGSuggestionParallaxHeaderCell.h
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Map Module
#import <MapKit/MapKit.h>
// Location module
#import <CoreLocation/CoreLocation.h>
#import "TAGMapView.h"

@interface TAGSuggestionParallaxHeaderCell : UICollectionViewCell <MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet TAGMapView *mapView;
@property (weak, nonatomic) MKMapView *map;

@property (nonatomic, strong) CLLocationManager *_myLocationManager;
@property (nonatomic, retain) MKUserLocation *currentUserLocation;
@property (nonatomic) CGSize searchViewSize;

- (void)reverseGeocodeUserLocationWithCompletionBlock:(void (^)(NSMutableDictionary *suggestionParams, NSError *err))finishedGeocodingBlock;

@end
