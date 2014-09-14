//
//  TAGProfileHeaderSummaryViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/23/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// CONTEXT: On the profile page - in the header - aggregate counters for faves / summaries

// Classes
#import "TAGProfileHeaderSummaryViewController.h"
#import "TAGViewHelpers.h"

// Constants
#import "TAGStyleConstants.h"

@interface TAGProfileHeaderSummaryViewController ()

@property (nonatomic, strong) NSString *_imageName;
@property (nonatomic, strong) NSString *_labelName;

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

- (id)initWithImage:(NSString *)imageName andLabel:(NSString *)labelName {
    if ((self = [super init])) {
        self._imageName = imageName;
        self._labelName = labelName;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view setBackgroundColor:[UIColor greenColor]];

    [self renderIcon];
    [self renderCounter];
    [self renderLabel];
}

- (void)renderIcon {
    CGRect iconRect = CGRectMake(0.0f,
                                 0.0,
                                 25.0f,
                                 25.0f);

    self.icon = [[UIView alloc] initWithFrame:iconRect];

    [TAGViewHelpers scaleAndSetBackgroundImageNamed:self._imageName forView:self.icon];

    [self.view addSubview:self.icon];
}

- (void)renderCounter {
    float counterXCoord = self.icon.frame.size.width;

    CGRect CounterRect = CGRectMake(counterXCoord,
                                    0.0f,
                                    25.0f,
                                    25.0f);
    self.counter = [[UILabel alloc] initWithFrame:CounterRect];
    [self.counter setBackgroundColor:[UIColor orangeColor]];

    NSAttributedString *text = [TAGViewHelpers attributeText:@"7" forFontSize:10.0f];
    [self.counter setAttributedText:text];
    [self.counter setTextAlignment:NSTextAlignmentCenter];

    [self.view addSubview:self.counter];
}

- (void)renderLabel {
    float labelYCoord = self.icon.frame.origin.y + self.icon.frame.size.height + 7.5f;

    CGRect LabelRect = CGRectMake(0.0f,
                                  labelYCoord,
                                  50.0f,
                                  15.0f);
    self.label = [[UILabel alloc]initWithFrame:LabelRect];
    [self.label setBackgroundColor:[UIColor whiteColor]];

    NSAttributedString *text = [TAGViewHelpers attributeText:self._labelName forFontSize:8.0f];
    [self.label setAttributedText:text];
    [self.label setTextAlignment:NSTextAlignmentCenter];
//    [TAGViewHelpers sizeLabelToFit:self.label numberOfLines:0];

    [self.view addSubview:self.label];
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
