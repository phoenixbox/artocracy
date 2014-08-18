//
//  TAGMapViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/10/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGMapViewController.h"

// Map Module
#import <MapKit/MapKit.h>
// Location module
#import <CoreLocation/CoreLocation.h>
// Components
#import "TAGErrorAlert.h"
#import "TAGMapAnnotation.h"

@interface TAGMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) MKMapView *_mapView;
@property (nonatomic, strong) CLLocationManager *_myLocationManager;
@property (nonatomic, retain) MKUserLocation *_currentUserLocation;
@property (nonatomic) CGSize _searchViewSize;

@end

@implementation TAGMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addMapToView];
}

- (void)addMapToView {
    self._mapView = [[MKMapView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                               320.0f,
                                                               self.view.frame.size.width,
                                                               100.0f)];

    [self._mapView setMapType:MKMapTypeStandard];
    self._mapView.delegate = self;
    [self._mapView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];

    // Set the initial zoom level
    CLLocationCoordinate2D noLocation;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self._mapView regionThatFits:viewRegion];
    [self._mapView setRegion:adjustedRegion animated:YES];


    self._mapView.showsUserLocation = YES;
    self._mapView.userTrackingMode = MKUserTrackingModeFollow;

    [self.view addSubview:self._mapView];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    self._currentUserLocation = userLocation;

    [mapView removeAnnotations:[mapView annotations]];

    float latitude = userLocation.coordinate.latitude;
    float longitude = userLocation.coordinate.longitude;

    CLLocationCoordinate2D pin = CLLocationCoordinate2DMake(latitude, longitude);

    TAGMapAnnotation *annotation = [[TAGMapAnnotation alloc] initWithCoordinates:pin title:@"" subtitle:@""];

    [self._mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [TAGErrorAlert render:error];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *result = nil;

    if([annotation isKindOfClass:[TAGMapAnnotation class]]==NO){
        return result;
    }

    if ([mapView isEqual: self._mapView] == NO){
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

- (void)reverseGeocodeUserLocationWithCompletionBlock:(void (^)(NSMutableDictionary *suggestionParams, NSError *err))finishedGeocodingBlock {
    NSMutableDictionary *suggestionParams = [NSMutableDictionary new];
    CLGeocoder *geocoder = [CLGeocoder new];

    [geocoder reverseGeocodeLocation:self._currentUserLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && placemarks.count > 0){
            CLPlacemark *placemark = placemarks[0];
            NSDictionary *address = @{ @"address" : placemark.name,
                                       @"city" : placemark.subAdministrativeArea,
                                       @"state" : placemark.administrativeArea,
                                       @"zip_code" : placemark.postalCode,
                                       @"country" :placemark.ISOcountryCode
                                       };
            [suggestionParams addEntriesFromDictionary:address];

            NSString *latitude = [NSString stringWithFormat:@"%f", self._currentUserLocation.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f", self._currentUserLocation.coordinate.longitude];

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
