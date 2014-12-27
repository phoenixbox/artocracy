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

@property (nonatomic, assign) float cellDimension;
@property (strong, nonatomic) UIImage *filteredImage;
//@property (strong, nonatomic) UIView *selectionIndicator;
//XIBS
@property (strong, nonatomic) IBOutlet UIImageView *filteredImageView;
@property (strong, nonatomic) IBOutlet UIView *selectionIndicator;

@end
