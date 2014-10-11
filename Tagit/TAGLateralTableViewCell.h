//
//  TAGSuggestionListPiecesTableCell.h
//  Tagit
//
//  Created by Shane Rogers on 8/30/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGLateralTableViewCell : UITableViewCell

@property (nonatomic, assign) float cellDimension;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImage *artImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier forCellDimension:(float)dimension;

- (void)addImage:(NSString *)imageName;
@end
