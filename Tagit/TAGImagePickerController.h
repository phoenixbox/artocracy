//
//  TAGImagePickerController.h
//  Tagit
//
//  Created by Shane Rogers on 8/9/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGImagePickerController : UIImagePickerController

+ (TAGImagePickerController *)sharedImagePicker;

- (void)buildOverlay;

@end