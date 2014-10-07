//
//  TAGSuggestionDetailsSection.m
//  Tagit
//
//  Created by Shane Rogers on 9/6/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGSuggestionDetailsSection.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGCopyConstants.h"

// Helpers
#import "TAGViewHelpers.h"

@implementation TAGSuggestionDetailsSection

- (id)initWithFrame:(CGRect)frame forSuggestion:(TAGSuggestion *)suggestion withBlock:(void (^)(BOOL selected))actionBlock {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.labelWidth = 149.0f;
        self.suggestion = suggestion;
        self.actionBlock = actionBlock;

        [self renderCanvasInfo];
        [self renderFavoriteButton];
        [self renderLocationInfo];
    }
    return self;
}

- (void)renderCanvasInfo {
    float xCoord = self.frame.origin.x + kSmallPadding;

    self.canvasTypeTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                    kSmallPadding,
                                                                    149.0f,
                                                                    20.0f)];
    NSAttributedString *canvasTitle =[TAGViewHelpers attributeText:@"Canvas Type" forFontSize:12.0f];
    [self.canvasTypeTitle setAttributedText:canvasTitle];
    [TAGViewHelpers sizeLabelToFit:self.canvasTypeTitle numberOfLines:0];

    self.canvasType = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                CGRectGetMaxY(self.canvasTypeTitle.frame) + kSmallPadding,
                                                                149.0f,
                                                                20.0f)];

    NSAttributedString *canvasType =[TAGViewHelpers attributeText:self.suggestion.canvasType forFontSize:10.0f];
    [self.canvasType setAttributedText:canvasType];
    [TAGViewHelpers sizeLabelToFit:self.canvasType numberOfLines:0];

    [self addSubview:self.canvasTypeTitle];
    [self addSubview:self.canvasType];
}

- (void)renderFavoriteButton {
    float yCoord = self.canvasTypeTitle.frame.origin.y + (((CGRectGetMaxY(self.canvasType.frame) - self.canvasTypeTitle.frame.origin.y)/2));
    self.favoriteButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f,
                                                                      0.0f,
                                                                      40.0f,
                                                                      40.0f)];
    CGPoint buttonCenter = CGPointMake(self.frame.size.width/2, yCoord);
    [self.favoriteButton setCenter:buttonCenter];
    [self.favoriteButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];



    self.favoriteButton.layer.cornerRadius = self.favoriteButton.frame.size.width/2;
    self.favoriteButton.layer.masksToBounds = YES;

    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heartUnselected.png"] forState:UIControlStateNormal];
    [self.favoriteButton setBackgroundImage:[UIImage imageNamed:@"heartSelected.png"] forState:UIControlStateSelected];

    [self addSubview:self.favoriteButton];
}

- (void)buttonTapped:(UIButton *)paramSender {
    if(!paramSender.selected) {
        [paramSender setSelected:YES];
        self.actionBlock(true);
    } else {
        [paramSender setSelected:NO];
        self.actionBlock(false);
    }
}

- (void)renderLocationInfo {
    float xCoord = CGRectGetMaxX(self.favoriteButton.frame) + kSmallPadding;

    self.canvasTypeTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                    kSmallPadding,
                                                                    149.0f,
                                                                    20.0f)];


    self.locationTitle = [[UILabel alloc]initWithFrame:CGRectMake(xCoord,
                                                                  kSmallPadding,
                                                                  self.labelWidth,
                                                                  20.0f)];
    NSAttributedString *locationTitle =[TAGViewHelpers attributeText:@"Location" forFontSize:12.0f];
    [self.locationTitle setAttributedText:locationTitle];
    [TAGViewHelpers sizeLabelToFit:self.locationTitle numberOfLines:0];
    [self addSubview:self.locationTitle];

    self.locationAddress = [UILabel new];
    self.locationCity = [UILabel new];
    self.locationState = [UILabel new];

    NSArray *labels = [[NSArray alloc] initWithObjects:self.locationAddress, self.locationCity, self.locationState, nil];
    NSArray *text = [[NSArray alloc] initWithObjects:self.suggestion.address,self.suggestion.city,self.suggestion.state, nil];

    NSUInteger labelCount = [labels count];

    float xOrigin = CGRectGetMaxX(self.favoriteButton.frame) + 5.0f;

    for (int i=0; i<labelCount; i++) {
        float yOrigin;

        if (i == 0) {
            yOrigin = CGRectGetMaxY(self.locationTitle.frame) + kSmallPadding;
        } else {
            yOrigin = yOrigin + 15.0f;
        }

        UILabel *label = [labels objectAtIndex:i];
        label = [[UILabel alloc]initWithFrame:CGRectMake(xOrigin,
                                                         yOrigin,
                                                         self.labelWidth,
                                                         10.0f)];

        NSAttributedString *labelText =[TAGViewHelpers attributeText:[text objectAtIndex:i] forFontSize:10.0f];
        [label setAttributedText:labelText];
        [self addSubview:label];
    }
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
