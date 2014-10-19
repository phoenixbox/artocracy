//
//  TAGRoutesConstants.h
//  Tagit
//
//  Created by Shane Rogers on 8/3/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#ifndef Tagit_TAGRoutesConstants_h
#define Tagit_TAGRoutesConstants_h

// Seed User Login Params
#define kSeedEmail @"rogerssh@tcd.ie"
#define kSeedPassword @"12345678"

// Bean Bag
//#define kAPIUserLogin @"http://192.168.2.9:3000/api/v1/users/login"
//#define kAPITagsIndex @"http://192.168.2.9:3000/api/v1/tags"
//#define kAPISuggestionsCreate @"http://192.168.2.9:3000/api/v1/suggestions"

// Golden Gate
#define kAPIUserLogin @"http://192.168.1.119:3000/api/v1/users/login"
#define kAPITagsIndex @"http://192.168.1.119:3000/api/v1/tags"
#define kAPITagsArtistWork @"http://192.168.1.119:3000/api/v1/tags/artist_work"
#define kAPITagFavorites @"http://192.168.1.119:3000/api/v1/tags/favorites"

#define kAPISuggestionsCreate @"http://192.168.1.119:3000/api/v1/suggestions"
#define kAPISuggestionsIndex @"http://192.168.1.119:3000/api/v1/suggestions"

#define kAPIProposalSuggestionsIndex @"http://192.168.1.119:3000/api/v1/suggestions"

#define kAPIUpvoted @"http://192.168.1.119:3000/api/v1/upvoted"
#define kAPIUpvoteCreate @"http://192.168.1.119:3000/api/v1/upvotes"
#define kAPIUpvoteDestroy @"http://192.168.1.119:3000/api/v1/upvotes"

#define kAPIFavorited @"http://192.168.1.119:3000/api/v1/favorited"
#define kAPIFavoriteCreate @"http://192.168.1.119:3000/api/v1/favorites"
#define kAPIFavoriteDestroy @"http://192.168.1.119:3000/api/v1/favorites"

// Tethered
//172.20.10.2
//#define kAPIUserLogin @"http://172.20.10.15:3000/api/v1/users/login"
//#define kAPITagsIndex @"http://172.20.10.15:3000/api/v1/tags"
//#define kAPISuggestionsCreate @"http://172.20.10.15:3000/api/v1/suggestions"
//#define kAPISuggestionsIndex @"http://172.20.10.15:3000/api/v1/suggestions"
//#define kAPIProposalSuggestionsIndex @"http://172.20.10.15:3000/api/v1/suggestions/"

// Localhost
//#define kAPIUserLogin @"http://0.0.0.0:3000/api/v1/users/login"
//#define kAPITagsIndex @"http://0.0.0.0:3000/api/v1/tags"
//#define kAPISuggestionsCreate @"http://0.0.0.0:3000/api/v1/suggestions"
//#define kAPISuggestionsIndex @"http://0.0.0.0:3000/api/v1/suggestions"
//#define kAPIProposalSuggestionsIndex @"http://0.0.0.0:3000/api/v1/suggestions/"


#endif