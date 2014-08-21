//
//  TAGCollectionPresenterViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGCollectionPresenterViewController.h"
#import "TAGCollectionControls.h"
#import "TAGCollectionView.h"

NSString *const kCollectionViewPresenter = @"CollectionView";
NSString *const kTableViewPresenter = @"TableView";

static NSString *kCollectionViewCellIdentifier = @"CollectionCell";

@interface TAGCollectionPresenterViewController ()

@property (nonatomic, strong) TAGCollectionControls *_collectionControls;
@property (nonatomic, strong) TAGCollectionView *_collectionView;
@property (nonatomic, strong) NSString *_presenterType;

// TODO: use of enums

@end

@implementation TAGCollectionPresenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self._presenterType = kCollectionViewPresenter;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor greenColor]];

    [self renderCollectionControls];
    [self chooseCollectionPresenter];
}

- (void)renderCollectionControls {
    self._collectionControls = [[TAGCollectionControls alloc]initWithFrame:CGRectMake(0.0f,
                                                                                      0.0f,
                                                                                      self.view.frame.size.width,
                                                                                      50.0f)];
    [self.view addSubview:self._collectionControls];
}

- (void)chooseCollectionPresenter {
    // Trigger this on controls tap - pass a block into the control function that will trigger this method
    if (self._presenterType == kCollectionViewPresenter) {
        // Generate the collection view
        [self buildCollectionView];
    } else {
        // Generate the table view
    }
}

- (void)buildCollectionView {
    float yCoord = self._collectionControls.frame.origin.y + self._collectionControls.frame.size.height;


    self._collectionView = [[TAGCollectionView alloc]initWithFrame:CGRectMake(0.0f,
                                                                             yCoord,
                                                                             self.view.frame.size.width,
                                                                              self.view.frame.size.height) collectionViewLayout:[self buildCollectionViewCellLayout]];

    [self._collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    [self._collectionView setBackgroundColor:[UIColor whiteColor]];

    // Custom cell here identifier here
    [self._collectionView setDelegate:self];
    [self._collectionView setDataSource:self];
    // TODO: Collection view needs to be added to a scroll view
    [self.view addSubview:self._collectionView];
}

-(UICollectionViewFlowLayout *)buildCollectionViewCellLayout {
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 5.0f;
    flowLayout.minimumInteritemSpacing = 5.0f;
    flowLayout.itemSize = CGSizeMake(102.5f,102.5f);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(2.5f, 0.0f, 2.5f, 0.0f);

    //RESTART: Formatting the collection layout to have custom the protocol methods necessary for the cells to be formatted etc.
    return flowLayout;
}

#pragma UICollectionView Protocol Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [self._suggestions count]
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier forIndexPath:indexPath];

    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ape_do_good_printing_SF.png"]];
    [cell setBackgroundView:backgroundImage];
    [cell.backgroundView setContentMode:UIViewContentModeScaleAspectFit];
    // TODO: Assign the custom cell attributes
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected cell number %@", indexPath);
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
