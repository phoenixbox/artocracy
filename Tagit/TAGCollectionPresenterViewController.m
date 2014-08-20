//
//  TAGCollectionPresenterViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGCollectionPresenterViewController.h"
#import "TAGCollectionControls.h"

@interface TAGCollectionPresenterViewController ()

@property (nonatomic, strong) TAGCollectionControls *_collectionControls;
@property (nonatomic) BOOL _collectionView;

@end

@implementation TAGCollectionPresenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self._collectionView = true;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor greenColor]];

    [self renderCollectionControls];
    [self renderCollectionPresenter];
}

- (void)renderCollectionControls {
    self._collectionControls = [[TAGCollectionControls alloc]initWithFrame:CGRectMake(0.0f,
                                                                                      0.0f,
                                                                                      self.view.frame.size.width,
                                                                                      50.0f)];
    [self.view addSubview:self._collectionControls];
}

- (void)renderCollectionPresenter {
    // Trigger this on controls tap - pass a block into the control function that will trigger this method
    if (self._collectionView) {
        // Generate the collection view
    } else {
        // Generate the table view
    }
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
