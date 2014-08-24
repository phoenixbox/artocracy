//
//  TAGProfileHeaderSummaryViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Classes
#import "TAGProfileHeaderSummaryViewController.h"
#import "TAGViewHelpers.h"

// Constants
#import "TAGStyleConstants.h"

@interface TAGProfileHeaderSummaryViewController ()

@end

@implementation TAGProfileHeaderSummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self renderSuggestionIcon];
    [self renderSuggestionCounter];
    [self renderSuggestionLabel];
}

- (void)renderSuggestionIcon {
    CGRect iconRect = CGRectMake(0.0f,
                                 0.0,
                                 25.0f,
                                 25.0f);

    self.suggestionIcon = [[UIView alloc] initWithFrame:iconRect];

    [TAGViewHelpers scaleAndSetBackgroundImageNamed:@"lightbulbSelected.png" forView:self.suggestionIcon];

    [self.view addSubview:self.suggestionIcon];
}

// GOOD SUBCOMPONENT VIEWS! :) Keep it up - Lost reference to the element positions - fix sub view controller

- (void)renderSuggestionCounter {
    float counterXCoord = self.suggestionIcon.frame.origin.x + self.suggestionIcon.frame.size.width;

    CGRect suggestionCounterRect = CGRectMake(counterXCoord,
                                              kProfileYCoord,
                                              25.0f,
                                              25.0f);
    self.suggestionCounter = [[UILabel alloc] initWithFrame:suggestionCounterRect];
    [self.suggestionCounter setBackgroundColor:[UIColor orangeColor]];

    NSAttributedString *text = [TAGViewHelpers attributeText:@"7" forFontSize:10.0f];
    [self.suggestionCounter setAttributedText:text];
    [self.suggestionCounter setTextAlignment:NSTextAlignmentCenter];
    [TAGViewHelpers sizeLabelToFit:self.suggestionCounter numberOfLines:0];

    [self.view addSubview:self.suggestionCounter];
}

- (void)renderSuggestionLabel {
    float labelXCoord = self.suggestionIcon.frame.origin.x;
    float labelYCoord = self.suggestionIcon.frame.origin.y + self.suggestionIcon.frame.size.height + 7.5f;

    CGRect suggestionLabelRect = CGRectMake(labelXCoord,
                                            labelYCoord,
                                            50.0f,
                                            25.0f);
    self.suggestionLabel = [[UILabel alloc]initWithFrame:suggestionLabelRect];
    [self.suggestionLabel setBackgroundColor:[UIColor whiteColor]];

    NSAttributedString *text = [TAGViewHelpers attributeText:@"suggestions" forFontSize:8.0f];
    [self.suggestionLabel setAttributedText:text];
    [self.suggestionLabel setTextAlignment:NSTextAlignmentCenter];
    [TAGViewHelpers sizeLabelToFit:self.suggestionLabel numberOfLines:0];

    [self.view addSubview:self.suggestionLabel];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
