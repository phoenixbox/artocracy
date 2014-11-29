//
//  TAGCameraOverlay.h
//  Tagit
//
//  Created by Shane Rogers on 11/16/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TAGImagePickerController.h"

@interface TAGCameraOverlay : UIView
@property (strong, nonatomic) TAGImagePickerController *picker;
@property (strong, nonatomic) IBOutlet UIButton *takePictureButton;
@property (strong, nonatomic) IBOutlet UIButton *usePictureButton;

- (IBAction)takePicture:(id)sender;
- (IBAction)usePicture:(id)sender;

@end
