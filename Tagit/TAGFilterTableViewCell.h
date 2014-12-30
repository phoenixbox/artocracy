//
//  TAGFilterTableViewCell.h
//  Tagit
//
//  Created by Shane Rogers on 12/26/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGFilterTableViewCell : UITableViewCell

- (void)setCellImage:(UIImage *)image;
- (void)setOverlayImage:(NSString *)labelName;
- (void)setCellLabel:(NSString *)copy;

@property (nonatomic, assign) float cellDimension;
@property (strong, nonatomic) UIImage *filteredImage;
@property (strong, nonatomic) NSString *toolType;

@property (strong, nonatomic) IBOutlet UIView *filterImageContainer;

@property (strong, nonatomic) IBOutlet UIView *selectionIndicator;
@property (strong, nonatomic) IBOutlet UILabel *filterLabel;

@end
