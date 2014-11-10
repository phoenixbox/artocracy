//
//  TAGProfileHeader.m
//  Tagit
//
//  Created by Shane Rogers on 8/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGProfileHeader.h"

// Helpers
#import "TAGViewHelpers.h"

// Constants
#import "TAGStyleConstants.h"

// Components
#import "TAGErrorAlert.h"

// Data Layer
#import "TAGUserStore.h"
#import "TAGSessionStore.h"
#import "TAGUserStore.h"

NSString *const kFetchUserContributions = @"FetchUserContributions";

@implementation TAGProfileHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addProfile];
        [self addName];
        [self addSuggestionsSummaryViewController];
        [self addFavoritesSummaryViewController];

        [self setParentWillAppearListener];
    }
    return self;
}

- (void)setParentWillAppearListener {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    [center addObserver:self
               selector:@selector(fetchUserContributions)
                   name:kFetchUserContributions
                 object:[self superview]];
}

- (void)fetchUserContributions {
    void(^completionBlock)(NSDictionary *contributionCounts, NSError *err)=^(NSDictionary *contributionCounts, NSError *err){

        if(!err){
            NSAttributedString *suggestionCount = [TAGViewHelpers attributeText:[[contributionCounts objectForKey:@"suggestions"] stringValue] forFontSize:10.0f andFontFamily:nil];
            [self.suggestionsSummary.counter setAttributedText:suggestionCount];

            NSAttributedString *favoriteCount = [TAGViewHelpers attributeText:[[contributionCounts objectForKey:@"favorites"] stringValue] forFontSize:10.0f andFontFamily:nil];
            [self.favoritesSummary.counter setAttributedText:favoriteCount];
        } else {
            [TAGErrorAlert render:err];
        }
    };

    [[TAGUserStore sharedStore] getContributionCountsWithCompletion:completionBlock];
}

- (void)addProfile {
    self.profile = [[UIView alloc]initWithFrame:CGRectMake(kProfileXSpacing,
                                                             7.5f,
                                                             60.0f,
                                                              60.0f)];

    TAGSessionStore *session = [TAGSessionStore sharedStore];
    [TAGViewHelpers roundImageLayer:self.profile.layer withFrame:self.profile.frame];
    [TAGViewHelpers scaleAndSetRemoteBackgroundImage:session.profileImageUrl forView:self.profile];

    [self addSubview:self.profile];
}

- (void)addName {
    float usernameXCoord = kProfileXSpacing * 2 + self.profile.frame.size.width;
    self.username = [[UILabel alloc]initWithFrame:CGRectMake(usernameXCoord,
                                                              27.5f,
                                                              120.0f,
                                                            20.0f)];

    TAGSessionStore *session = [TAGSessionStore sharedStore];
    NSAttributedString *text = [TAGViewHelpers attributeText:session.email forFontSize:10.0f andFontFamily:nil];
    [self.username setAttributedText:text];
    [TAGViewHelpers sizeLabelToFit:self.username numberOfLines:0.0f];

    [self.username setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.username];
}

- (void)addSuggestionsSummaryViewController {
    self.suggestionsSummary = [[TAGProfileHeaderSummaryViewController new] initWithImage:@"lightbulbSelected.png" andLabel:@"suggestions"];

    [self.suggestionsSummary.view setFrame:CGRectMake(190.0f,
                                                     kProfileYCoord,
                                                     50.0f,
                                                     57.5f)];
    
    [self addSubview:self.suggestionsSummary.view];
}

- (void)addFavoritesSummaryViewController {
    self.favoritesSummary = [[TAGProfileHeaderSummaryViewController new] initWithImage:@"heartSelected.png" andLabel:@"favorites"];
    float favoritesXCoord = self.suggestionsSummary.view.frame.origin.x + self.suggestionsSummary.view.frame.size.width + kProfileXSpacing;

    [self.favoritesSummary.view setFrame:CGRectMake(favoritesXCoord,
                                                      kProfileYCoord,
                                                      50.0f,
                                                      57.5f)];

    [self addSubview:self.favoritesSummary.view];
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
