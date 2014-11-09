//
//  TAGTagsTableViewCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/5/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Libs
#import "FontAwesomeKit/FAKFontAwesome.h"

// Classes
#import "TAGTagTableViewCell.h"
#import "TAGViewHelpers.h"

//Constants
#import "TAGComponentConstants.h"
#import "TAGStyleConstants.h"

@implementation TAGTagTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self renderHeader];
        [self renderCellImage];
        [self renderTagImageButtons];
    }
    return self;
}

- (void)renderHeader {
    [self buildArtistThumbnail];
    [self buildTagTitle];
    [self buildArtistName];
    [self renderFavoriteCounter];
}

- (void)buildArtistThumbnail {
    CGFloat xCoord = self.frame.origin.x + kSmallPadding;
    CGFloat yCoord = self.frame.origin.y + kSmallPadding;
    self.artistThumbnail = [[UIView alloc]initWithFrame:CGRectMake(xCoord,
                                                                   yCoord,
                                                                   27.5f,
                                                                   27.5f)];

    [TAGViewHelpers roundImageLayer:self.artistThumbnail.layer withFrame:self.artistThumbnail.frame];

    [self setBackgroundImage:@"profile_photo.png" forView:self.artistThumbnail];

    [self.contentView addSubview:self.artistThumbnail];
}

- (void)buildTagTitle {
    CGFloat xCoord = self.frame.origin.x + kSmallPadding + self.artistThumbnail.frame.size.width + kSmallPadding;
    CGFloat yCoord = self.frame.origin.y + kSmallPadding;

    self.tagTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                          yCoord,
                                                          100.0f,
                                                          15.0f)];

    NSAttributedString *text = [TAGViewHelpers attributeText:@"Ape Do Good Printing" forFontSize:10.0f andFontFamily:nil];
    [self.tagTitle setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self.tagTitle numberOfLines:0];

    [self.contentView addSubview:self.tagTitle];
}

- (void)buildArtistName {
    CGFloat xCoord = self.frame.origin.x + kSmallPadding + self.artistThumbnail.frame.size.width + kSmallPadding;
    CGFloat yCoord = self.frame.origin.y + kSmallPadding + self.tagTitle.frame.size.height + kSmallPadding;

    self.artistName = [[UILabel alloc]initWithFrame:CGRectMake(
                                                               xCoord,
                                                               yCoord,
                                                               100.0f,
                                                               15.0f)];

    NSAttributedString *text = [TAGViewHelpers attributeText:@"Lonnie Spoon" forFontSize:10.0f andFontFamily:nil];
    [self.artistName setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self.artistName numberOfLines:0];

    [self.contentView addSubview:self.artistName];
}

- (void)renderFavoriteCounter {
    CGFloat xCoord = 280.0f;
    CGFloat yCoord = self.artistName.frame.origin.y;

    self.favoriteCounter = [[UILabel alloc] initWithFrame:CGRectMake(xCoord,
                                                                      yCoord,
                                                                      100.0f,
                                                                      10.0f)];
    FAKFontAwesome *heart = [FAKFontAwesome heartIconWithSize:10];
    NSAttributedString *heartFont = [heart attributedString];
    NSMutableAttributedString *heartIcon = [heartFont mutableCopy];

    NSMutableAttributedString *favoriteCount =[[NSMutableAttributedString alloc] initWithString:@" 1023" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];
    [heartIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,heartIcon.length)];
    [heartIcon appendAttributedString:favoriteCount];

    [self.favoriteCounter setAttributedText:heartIcon];
    [TAGViewHelpers sizeLabelToFit:self.favoriteCounter numberOfLines:1];

    [self.contentView addSubview:self.favoriteCounter];
}


- (void)renderCellImage {
    CGFloat xCoord = self.frame.origin.x;
    CGFloat yCoord = self.artistThumbnail.frame.origin.y + self.artistThumbnail.frame.size.height + kBigPadding;
    CGRect imageFrame = CGRectMake(xCoord, yCoord, 320.0f, 320.0f);

    self.image = [[UIView alloc] initWithFrame:imageFrame];

    [self setBackgroundImage:@"ape_do_good_printing_SF.png" forView:self.image];

    [self.contentView addSubview:self.image];
}

- (void)renderTagImageButtons {
    [self renderLikeButton];
    [self renderCommentButton];
}

- (void)renderLikeButton{
    CGFloat xCoord = self.frame.origin.x + kSmallPadding;
    self.likeButton = [[UIButton alloc] initWithFrame:CGRectMake(xCoord,
                                                         367.5f,
                                                         50.0f,
                                                         20.0f)];

    FAKFontAwesome *heartIcon = [FAKFontAwesome heartIconWithSize:10];
    NSMutableAttributedString *icon = [TAGViewHelpers createIcon:heartIcon withColor:[UIColor blackColor]];
    [TAGViewHelpers formatButton:self.likeButton forIcon:icon withCopy:@"Like  " withColor:[UIColor blackColor]];

    [self.contentView addSubview:self.likeButton];
}

- (void)renderCommentButton{
    CGFloat xCoord = self.frame.origin.x + kBigPadding + 50.0f;
    self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(xCoord,
                                                                 367.5f,
                                                                 70.0f,
                                                                 20.0f)];

    FAKFontAwesome *commentIcon = [FAKFontAwesome commentIconWithSize:10];
    NSMutableAttributedString *icon = [TAGViewHelpers createIcon:commentIcon withColor:[UIColor blackColor]];
    [TAGViewHelpers formatButton:self.commentButton forIcon:icon withCopy:@"Comment  " withColor:[UIColor blackColor]];

    [self.contentView addSubview:self.commentButton];
}

- (void)setBackgroundImage:(NSString *)imageName forView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:imageName];
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
