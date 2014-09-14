//
//  TAGSuggestionParallaxHeaderCell.h
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Location Modules
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "TAGMapView.h"

@interface TAGSuggestionParallaxHeaderCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet TAGMapView *mapView;

@end
