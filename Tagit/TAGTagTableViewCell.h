//
//  TAGTagsTableViewCell.h
//  Tagit
//
//  Created by Shane Rogers on 8/5/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TAGTagTableViewCell : UITableViewCell

@property (nonatomic, strong)UIView *header;
@property (nonatomic, strong)UIView *artistThumbnail;
@property (nonatomic, strong)UILabel *tagTitle;
@property (nonatomic, strong)UILabel *artistName;
@property (nonatomic, strong)UILabel *location;

@property (nonatomic, strong)UIView *image;
@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UIButton *commentButton;

@end
