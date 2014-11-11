//
//  TAGSuggestionCell.h
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

// Libs
#import "TPKeyboardAvoidingScrollView.h"

// Location Modules
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface TAGSuggestionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *cellScrollView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) IBOutlet UILabel *contributionTypeLabel;
@property (strong, nonatomic) IBOutlet UISegmentedControl *contributionTypeSelect;
@property (weak, nonatomic) IBOutlet UIImageView *suggestionImage;
@property (strong, nonatomic) IBOutlet UILabel *canvasTypeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *canvasType;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

//- (void)updateStyle;

@end
