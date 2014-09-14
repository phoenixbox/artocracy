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

@implementation TAGSuggestionParallaxHeaderCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self.currentUserLocation = userLocation;

    [mapView removeAnnotations:[mapView annotations]];

    float latitude = userLocation.coordinate.latitude;
    float longitude = userLocation.coordinate.longitude;

    CLLocationCoordinate2D pin = CLLocationCoordinate2DMake(latitude, longitude);

    TAGMapAnnotation *annotation = [[TAGMapAnnotation alloc] initWithCoordinates:pin title:@"" subtitle:@""];

    [self.map addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [TAGErrorAlert render:error];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *result = nil;

    if([annotation isKindOfClass:[TAGMapAnnotation class]]==NO){
        return result;
    }

    if ([mapView isEqual: self] == NO){
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
    //    UIImage *markerIcon = [UIImage imageNamed:@"map_icon.png"];
    //    if (markerIcon != nil){
    //        annotationView.image = markerIcon;
    //    }

    result = annotationView;

    return result;
}

//- (void)reverseGeocodeUserLocationWithCompletionBlock:(void (^)(NSMutableDictionary *suggestionParams, NSError *err))finishedGeocodingBlock {
//    NSMutableDictionary *suggestionParams = [NSMutableDictionary new];
//    CLGeocoder *geocoder = [CLGeocoder new];
//
//    [geocoder reverseGeocodeLocation:self._currentUserLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (error == nil && placemarks.count > 0){
//            CLPlacemark *placemark = placemarks[0];
//            NSDictionary *address = @{ @"address" : placemark.name,
//                                       @"city" : placemark.subAdministrativeArea,
//                                       @"state" : placemark.administrativeArea,
//                                       @"zip_code" : placemark.postalCode,
//                                       @"country" :placemark.ISOcountryCode
//                                       };
//            [suggestionParams addEntriesFromDictionary:address];
//
//            NSString *latitude = [NSString stringWithFormat:@"%f", self._currentUserLocation.coordinate.latitude];
//            NSString *longitude = [NSString stringWithFormat:@"%f", self._currentUserLocation.coordinate.longitude];
//
//            [suggestionParams setObject:latitude forKey:@"latitude"];
//            [suggestionParams setObject:longitude forKey:@"longitude"];
//
//            finishedGeocodingBlock(suggestionParams, nil);
//        }
//        else if (error == nil && placemarks.count == 0){
//            NSLog(@"No results were returned.");
//        }
//        else if (error != nil){
//            NSLog(@"An error occurred = %@", error);
//            finishedGeocodingBlock(nil, error);
//        }
//    }];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
