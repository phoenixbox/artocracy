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
}

- (void)buildArtistThumbnail {
    CGFloat xCoord = self.frame.origin.x + kSmallPadding;
    CGFloat yCoord = self.frame.origin.y + kSmallPadding;
    self.artistThumbnail = [[UIView alloc]initWithFrame:CGRectMake(xCoord,
                                                                   yCoord,
                                                                   27.5f,
                                                                   27.5f)];
    self.artistThumbnail.layer.cornerRadius = self.artistThumbnail.frame.size.width/2;
    self.artistThumbnail.layer.masksToBounds = YES;

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
    NSAttributedString *text = [self attributeHeaderText:@"Ape Do Good Printing"];
    [self.tagTitle setAttributedText:text];
    [self sizeLabelToFit:self.tagTitle];

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
    NSAttributedString *text = [self attributeHeaderText:@"Lonnie Spoon"];
    [self.artistName setAttributedText:text];
    [self sizeLabelToFit:self.artistName];

    [self.contentView addSubview:self.artistName];
}

- (NSAttributedString *)attributeHeaderText:(NSString *)text {
    return [[NSAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10.0]}];
}

- (void)sizeLabelToFit:(UILabel *)label {
    [label setNumberOfLines:0];
    [label sizeToFit];
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

    [self formatButton:self.likeButton forIcon:heartIcon withCopy:@"Like  "];
}

- (void)renderCommentButton{
    CGFloat xCoord = self.frame.origin.x + kBigPadding + 50.0f;
    self.commentButton = [[UIButton alloc] initWithFrame:CGRectMake(xCoord,
                                                                 367.5f,
                                                                 70.0f,
                                                                 20.0f)];

    FAKFontAwesome *commentIcon = [FAKFontAwesome commentIconWithSize:10];

    [self formatButton:self.commentButton forIcon:commentIcon withCopy:@"Comment  "];
}

- (void)setBackgroundImage:(NSString *)imageName forView:(UIView *)view {
    UIImage *image = [UIImage imageNamed:imageName];
    view.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)formatButton:(UIButton *)button forIcon:(FAKFontAwesome *)icon withCopy:(NSString *)buttonCopy {
    NSAttributedString *iconFont = [icon attributedString];
    NSMutableAttributedString *iconCopy =[[NSMutableAttributedString alloc] initWithString:buttonCopy attributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]}];
    [iconCopy appendAttributedString:iconFont];
    [iconCopy addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,iconCopy.length)];
    [button setAttributedTitle:iconCopy forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setBackgroundColor:kTagitBlue];
    button.layer.cornerRadius = 2.0f;
    button.layer.masksToBounds = YES;

    [self.contentView addSubview:button];
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
