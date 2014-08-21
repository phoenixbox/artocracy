//
//  TAGCollectionControls.m
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGCollectionControls.h"

@implementation TAGCollectionControls

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.xSpacing = 32.0f;
        self.buttonWidth = 40.0f;
        [self setBackgroundColor:[UIColor whiteColor]];
        [self renderControlButtons];
    }
    return self;
}

- (void)renderControlButtons {
    self.gridViewButton = [[UIButton alloc] initWithFrame:CGRectMake(self.xSpacing,
                                                                  5.0f,
                                                                  40.0f,
                                                                   40.0f)];
    [self.gridViewButton setBackgroundImage:[UIImage imageNamed:@"gridUnselected"] forState:UIControlStateNormal];
    [self.gridViewButton setBackgroundImage:[UIImage imageNamed:@"gridSelected"] forState:UIControlStateSelected];
    [self.gridViewButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.gridViewButton setSelected:YES];
    [self.gridViewButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

    float listViewButtonXCoord = self.xSpacing*2 + self.buttonWidth;
    self.listViewButton = [[UIButton alloc] initWithFrame:CGRectMake(listViewButtonXCoord,
                                                                    5.0f,
                                                                    40.0f,
                                                                    40.0f)];
    [self.listViewButton setBackgroundImage:[UIImage imageNamed:@"listUnselected"] forState:UIControlStateNormal];
    [self.listViewButton setBackgroundImage:[UIImage imageNamed:@"listSelected"] forState:UIControlStateSelected];
    [self.listViewButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

    float suggestionsButtonXCoord = self.xSpacing*3 + self.buttonWidth*2;
    self.suggestionsButton = [[UIButton alloc] initWithFrame:CGRectMake(suggestionsButtonXCoord,
                                                                     5.0f,
                                                                     40.0f,
                                                                     40.0f)];
    [self.suggestionsButton setBackgroundImage:[UIImage imageNamed:@"lightbulbUnselected"] forState:UIControlStateNormal];
    [self.suggestionsButton setBackgroundImage:[UIImage imageNamed:@"lightbulbSelected"] forState:UIControlStateSelected];
    [self.suggestionsButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.suggestionsButton setSelected:YES];


    float favoritesButtonXCoord = self.xSpacing*4 + self.buttonWidth*3;
    self.favoritesButton = [[UIButton alloc] initWithFrame:CGRectMake(favoritesButtonXCoord,
                                                                     5.0f,
                                                                     40.0f,
                                                                     40.0f)];
    [self.favoritesButton setBackgroundImage:[UIImage imageNamed:@"heartUnselected"] forState:UIControlStateNormal];
    [self.favoritesButton setBackgroundImage:[UIImage imageNamed:@"heartSelected"] forState:UIControlStateSelected];
    [self.favoritesButton.imageView setContentMode:UIViewContentModeScaleAspectFit];


    [self addSubview:self.gridViewButton];
    [self addSubview:self.listViewButton];
    [self addSubview:self.suggestionsButton];
    [self addSubview:self.favoritesButton];
}

- (void)buttonTapped:(UIButton *)paramSender {
    [paramSender setSelected:YES];
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
