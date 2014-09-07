//
//  TAGProfileTableViewCell.m
//  Tagit
//
//  Created by Shane Rogers on 8/24/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Subject
#import "TAGProfileTableViewSuggestionCell.h"

// Helpers
#import "TAGViewHelpers.h"

// Constants
#import "TAGComponentConstants.h"

// Components
#import "TAGLateralTableViewCell.h"

@implementation TAGProfileTableViewSuggestionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.cellHeight = 100.0f;
        self.lateralTableCellDimension = 80.0f;
        [self addImage];
        [self addLocation];
        [self addPiecesTable];
        [self addCounter];
    }
    return self;
}

- (void)addImage {
    CGRect imageFrame = CGRectMake(0, 0, self.cellHeight, self.cellHeight);
    self.image = [[UIView alloc] initWithFrame:imageFrame];

    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"folsom_st_SF.png" forView:self.image];

    [self addSubview:self.image];
}

- (void)addLocation {
    self.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.image.frame.size.width + 5.0f,
                                                                  5.0f,
                                                                  36.0f,
                                                                   10.0f)];


    NSAttributedString *location = [TAGViewHelpers attributeText:@"Location:" forFontSize:8.0f];
    [self.locationLabel setAttributedText:location];
    [self addSubview:self.locationLabel];

    float xOrigin = self.locationLabel.frame.origin.x +self.locationLabel.frame.size.width;
    float addressWidth = 320.0f - self.locationLabel.frame.origin.x - 5.0f;

    self.locationAddress = [[UILabel alloc] initWithFrame:CGRectMake(xOrigin,
                                                                   5.0f,
                                                                   addressWidth,
                                                                   10.0f)];
    NSAttributedString *address = [TAGViewHelpers attributeText:@" 1285 Folsom St, San Francisco, CA 94103" forFontSize:8.0f];
    [self.locationAddress setAttributedText:address];
    [self.locationAddress setTextAlignment:NSTextAlignmentLeft];
    [TAGViewHelpers sizeLabelToFit:self.locationAddress numberOfLines:0];
    [self addSubview:self.locationAddress];
}

- (void)addPiecesTable {
    self.piecesTable = [UITableView new];
    CGRect piecesRect = CGRectMake(100.0f, 20.0f, 176.0f, self.lateralTableCellDimension);

    self.piecesTable = [[UITableView alloc] initWithFrame:piecesRect];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(-M_PI_2);
    [self.piecesTable setTransform:rotate];
    // VIP: Must set the frame again on the table after rotation
    [self.piecesTable setFrame:piecesRect];
    [self.piecesTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTAGLateralTableViewCellIdentifier];
    self.piecesTable.delegate = self;
    self.piecesTable.dataSource = self;
    self.piecesTable.alwaysBounceVertical = NO;
    self.piecesTable.scrollEnabled = YES;
    self.piecesTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    self.piecesTable.separatorColor = [UIColor whiteColor];

    [self.piecesTable setBackgroundColor:[UIColor whiteColor]];

    [self addSubview:self.piecesTable];
}

- (void)addCounter {
    float counterXCoord = self.piecesTable.frame.origin.x + self.piecesTable.frame.size.width + 9.5f;
    float counterSq = 25.0f;

    float iconYOrigin = (self.cellHeight/2) - (counterSq);
    CGRect iconRect = CGRectMake(counterXCoord,
                                    iconYOrigin,
                                    counterSq,
                                    counterSq);

    self.pieceIcon = [[UILabel alloc]initWithFrame:iconRect];
    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"pieceIcon.png" forView:self.pieceIcon];
    [self addSubview:self.pieceIcon];

    CGRect counterRect = CGRectMake(counterXCoord,
                                 self.cellHeight/2,
                                 counterSq,
                                 counterSq);
    self.counter = [[UILabel alloc] initWithFrame:counterRect];
    [self.counter setBackgroundColor:[UIColor orangeColor]];
    NSAttributedString *text = [TAGViewHelpers attributeText:@"7" forFontSize:10.0f];
    [self.counter setAttributedText:text];
    [self.counter setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.counter];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TAGLateralTableViewCell *cell = (TAGLateralTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kProfileTableSuggestionCellIdentifier];

    if([tableView isEqual:self.piecesTable]){
        cell = [[TAGLateralTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kProfileTableSuggestionCellIdentifier forCellDimension:self.lateralTableCellDimension];
        [cell addImage:@"open_arms_SF.png"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.lightboxViewController = [[URBMediaFocusViewController alloc] initWithNibName:nil bundle:nil];
    self.lightboxViewController.shouldDismissOnImageTap = YES;
    self.lightboxViewController.shouldShowPhotoActions = YES;
    TAGLateralTableViewCell *targetCell = (TAGLateralTableViewCell *)[self.piecesTable cellForRowAtIndexPath:indexPath];
    [self.lightboxViewController showImage:targetCell.artImage fromView:targetCell];
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
