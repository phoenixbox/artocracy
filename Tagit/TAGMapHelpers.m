//
//  TAGMapHelpers.m
//  Tagit
//
//  Created by Shane Rogers on 10/6/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGMapHelpers.h"
#import "TAGMapAnnotation.h"

@implementation TAGMapHelpers

+ (MKAnnotationView *)annotation:(id <MKAnnotation>)annotation forMap:(MKMapView *)mapView {
    MKAnnotationView *result = nil;

    if([annotation isKindOfClass:[TAGMapAnnotation class]]==NO){
        return result;
    }

    if ([mapView isEqual:mapView] == NO){
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

    result = annotationView;
    
    return result;
}

@end
