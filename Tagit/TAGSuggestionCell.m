//
//  TAGSuggestionCell.m
//  Tagit
//
//  Created by Shane Rogers on 9/14/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionCell.h"

#import "TAGStyleConstants.h"
#import "TAGViewHelpers.h"

@implementation TAGSuggestionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateStyle {
    self.retakePhoto.layer.cornerRadius = self.retakePhoto.frame.size.width/2;
    UIView *cameraIcon = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f, 40.0f, 40.0f)];

    [self.retakePhoto setBackgroundImage:[UIImage imageNamed:@"camera_nav.png"] forState:UIControlStateNormal];
    self.retakePhoto.backgroundColor = kPureWhite;
    [self.retakePhoto addSubview:cameraIcon];

    [self.retakePhoto setTitle:@"" forState:UIControlStateNormal];
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
