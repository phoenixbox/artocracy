//
//  TAGSuggestionCell.h
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Location Modules
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TAGSuggestionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *suggestionImage;
@property (weak, nonatomic) IBOutlet UISegmentedControl *canvasType;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *retakePhoto;

- (void)updateStyle;

@end
