//
//  TAGSuggestionParallaxHeaderCell.m
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionParallaxHeaderCell.h"

#import "TAGMapAnnotation.h"
#import "TAGErrorAlert.h"

#import "TAGMapAnnotation.h"

@implementation TAGSuggestionParallaxHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)addMapToCell {
    self._mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0.0,0.0,320.0f, 200.0f)];

    [self._mapView setMapType:MKMapTypeStandard];
    self._mapView.delegate = self;

    [self._mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    // Set the initial zoom level
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self._mapView regionThatFits:viewRegion];
    [self._mapView setRegion:adjustedRegion animated:YES];

    // Display the user
    self._mapView.showsUserLocation = YES;
    // Enable tracking mode which overrides default and forces user to be at the center of the map
    self._mapView.userTrackingMode = MKUserTrackingModeFollow;

    [self.contentView addSubview:self._mapView];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.currentUserLocation = userLocation;

    [mapView removeAnnotations:[mapView annotations]];

    float latitude = userLocation.coordinate.latitude;
    float longitude = userLocation.coordinate.longitude;

    CLLocationCoordinate2D pin = CLLocationCoordinate2DMake(latitude, longitude);

    TAGMapAnnotation *annotation = [[TAGMapAnnotation alloc] initWithCoordinates:pin title:@"" subtitle:@""];

    annotation.pinColor = MKPinAnnotationColorPurple;

    [self._mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [TAGErrorAlert render:error];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *result = nil;

    if([annotation isKindOfClass:[TAGMapAnnotation class]]==NO){
        return result;
    }

    if ([mapView isEqual:self._mapView] == NO){
        return result;
    }

    // Typecast the annotation that the MapView has fired this delegate message
    TAGMapAnnotation *senderAnnotation = (TAGMapAnnotation *)annotation;

    // Use the annotation class method to get the resusable identifier for the pin being created
    NSString *reusablePinIdentifier = [TAGMapAnnotation reusableIdentifierforPinColor:senderAnnotation.pinColor];

    // Use this identifier as the reusable annotation identifier on the map view
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusablePinIdentifier];

    if(annotationView == nil){
        annotationView = [[MKPinAnnotationView alloc]initWithAnnotation:senderAnnotation reuseIdentifier:reusablePinIdentifier];

        // Ensure we can see the callout for the pin
        [annotationView setCanShowCallout:YES];
    }

    // Display Custom Image
    UIImage *markerIcon = [UIImage imageNamed:@"map_icon.png"];
    if (markerIcon != nil){
        annotationView.image = markerIcon;
    }

    // Ensure the color of the pin matches the color of the annotation
    //    annotationView.pinColor = senderAnnotation.pinColor;

    result = annotationView;

    return result;
}

- (void)reverseGeocodeUserLocationWithCompletionBlock:(void (^)(NSMutableDictionary *suggestionParams, NSError *err))finishedGeocodingBlock {
    // Need to get in here :)
    NSLog(@"REVERSE GEOCODING!");
    NSMutableDictionary *suggestionParams = [NSMutableDictionary new];
    CLGeocoder *geocoder = [CLGeocoder new];

    [geocoder reverseGeocodeLocation:self.currentUserLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && placemarks.count > 0){
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *address = @{ @"address" : placemark.name,
                                       @"city" : placemark.subAdministrativeArea,
                                       @"state" : placemark.administrativeArea,
                                       @"zip_code" : placemark.postalCode,
                                       @"country" :placemark.ISOcountryCode
                                       };
            [suggestionParams addEntriesFromDictionary:address];

            NSString *latitude = [NSString stringWithFormat:@"%f", self.currentUserLocation.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", self.currentUserLocation.coordinate.longitude];

            [suggestionParams setObject:latitude forKey:@"latitude"];
            [suggestionParams setObject:longitude forKey:@"longitude"];

            finishedGeocodingBlock(suggestionParams, nil);
        }
        else if (error == nil && placemarks.count == 0){
            NSLog(@"No results were returned.");
        }
        else if (error != nil){
            NSLog(@"An error occurred = %@", error);
            finishedGeocodingBlock(nil, error);
        }
    }];
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
