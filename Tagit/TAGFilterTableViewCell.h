//
//  TAGFilterTableViewCell.h
//  Tagit
//
//  Created by Shane Rogers on 12/26/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGFilterTableViewCell : UITableViewCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forCellDimension:(float)dimension;
- (void)updateWithAttributes:(NSDictionary *)attributes;
- (void)setCellImage:(UIImage *)image;
- (void)setOverlayImage:(NSString *)labelName;
- (void)setCellLabel:(NSString *)copy;

@property (nonatomic, assign) float cellDimension;
@property (strong, nonatomic) UIImage *filteredImage;
//@property (strong, nonatomic) UIView *selectionIndicator;
//XIBS
@property (strong, nonatomic) IBOutlet UIView *filterImageContainer;

@property (strong, nonatomic) IBOutlet UIView *selectionIndicator;
@property (strong, nonatomic) IBOutlet UILabel *filterLabel;

@end
