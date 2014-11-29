//
//  TAGCameraOverlay.m
//  Tagit
//
//  Created by Shane Rogers on 11/16/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGCameraOverlay.h"

@implementation TAGCameraOverlay

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)takePicture:(id)sender {
    [self.picker takePicture];
}

- (IBAction)usePicture:(id)sender {
    NSLog(@"Use Picture");
//    [self.picker didfinis]
}

@end
