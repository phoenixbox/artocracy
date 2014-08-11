//
//  TAGMapView.m
//  Tagit
//
//  Created by Shane Rogers on 8/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGMapView.h"

@interface TAGMapView ()

@property (nonatomic, strong) CLLocationManager *_myLocationManager;
@property (nonatomic, strong) CLGeocoder *_geocoder;
@property (nonatomic) CGSize _searchViewSize;

@end

@implementation TAGMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setMapType:MKMapTypeStandard];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

        CLLocationCoordinate2D noLocation;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
        MKCoordinateRegion adjustedRegion = [self regionThatFits:viewRegion];
        [self setRegion:adjustedRegion animated:YES];

        // Display the user
        self.showsUserLocation = YES;
        // Enable tracking mode which overrides default and forces user to be at the center of the map
        self.userTrackingMode = MKUserTrackingModeFollow;
    }
    return self;
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
