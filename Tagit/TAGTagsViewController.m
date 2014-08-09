//
//  TAGFeedViewController.m
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

// Classes
#import "TAGTagsViewController.h"
#import "TAGTagStore.h"

// Components
#import "TAGErrorAlert.h"
#import "TAGTagTableViewCell.h"

// Constants
#import "TAGStyleConstants.h"
#import "TAGComponentConstants.h"

@interface TAGTagsViewController ()

@property (nonatomic, strong) UITableView *_tagsTable;

@end

@implementation TAGTagsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self initAppearance];
//        [self fetchTags];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self renderTagsTable];
}

- (void)initAppearance
{
    self.navigationController.navigationBar.translucent = NO;

    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setBarTintColor:kTagitBlue];

    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UIToolbar appearance] setBarTintColor:kTagitBlue];
    [self setHeaderLogo];
    [self addNavigationItems];
}

- (void)addNavigationItems{
    UIImage *filterImage = [UIImage imageNamed:@"filterIcon.png"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:filterImage landscapeImagePhone:filterImage style:UIBarButtonItemStylePlain target:self action:@selector(toggleFilter)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
}

- (void)setHeaderLogo {
    [[self navigationItem] setTitleView:nil];
    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 37.0f)];
    logoView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *logoImage = [UIImage imageNamed:@"navBarLogo.png"];
    [logoView setImage:logoImage];
    self.navigationItem.titleView = logoView;
}

- (void)toggleFilter {
}

- (void)fetchTags {
    [self setActivityIndicator];

    void(^completionBlock)(TAGTagChannel *obj, NSError *err)=^(TAGTagChannel *obj, NSError *err){
        [self setHeaderLogo];
        if(!err){
//            [[self feedTable]reloadData];
        } else {
            [TAGErrorAlert render:err];
//            [self._requestIndicator stopAnimating];
        }
    };
    [[TAGTagStore sharedStore] fetchTagsWithCompletion:completionBlock];
}

- (void)setActivityIndicator {
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[self navigationItem] setTitleView:aiView];
    [aiView startAnimating];
}

- (void)renderTagsTable {
    self._tagsTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self._tagsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:kTagsTableCellIdentifier];
    self._tagsTable.delegate = self;
    self._tagsTable.dataSource = self;
    self._tagsTable.alwaysBounceVertical = NO;
    self._tagsTable.scrollEnabled = YES;
    self._tagsTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self._tagsTable.separatorInset = UIEdgeInsetsMake(0, 3, 0, 3);
    self._tagsTable.separatorColor = [UIColor blackColor];
    [self._tagsTable setBackgroundColor:[UIColor whiteColor]];

    [self.view addSubview:self._tagsTable];
}

#pragma UITableViewDelgate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    TAGTagTableViewCell *cell = (TAGTagTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kTagsTableCellIdentifier];

    if([tableView isEqual:self._tagsTable]){
        cell = [[TAGTagTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTagsTableCellIdentifier];

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTagsTableRowHeight;
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
