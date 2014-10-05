//
//  TAGMapView.m
//  Tagit
//
//  Created by Shane Rogers on 8/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGMapView.h"
#import "TAGSuggestionParallaxHeaderCell.h"

// Libs
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

// Components
#import "TAGErrorAlert.h"

@interface TAGMapView ()

@property (nonatomic, strong) CLLocationManager *_myLocationManager;
@property (nonatomic, strong) CLGeocoder *_geocoder;
@property (nonatomic) CGSize _searchViewSize;

@property (nonatomic, retain) MKUserLocation *_currentUserLocation;

@end

@implementation TAGMapView

- (id)initWithFrame:(CGRect)frame forDelegate:(TAGSuggestionParallaxHeaderCell *)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        [self configureMap];
    }
    return self;
}

- (void)configureMap {
    [self setMapType:MKMapTypeHybrid];

    [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    // Set the initial zoom level
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self regionThatFits:viewRegion];
    [self setRegion:adjustedRegion animated:YES];


    self.showsUserLocation = YES;
    self.userTrackingMode = MKUserTrackingModeFollow;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
