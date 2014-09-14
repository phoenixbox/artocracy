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

// Routes
// ** Session
// Bean Bag
//#define kAPIUserLogin @"http://192.168.2.9:3000/api/v1/users/login"
// Golden Gate
//#define kAPIUserLogin @"http://192.168.1.114:3000/api/v1/users/login"
// Localhost
#define kAPIUserLogin @"http://0.0.0.0:3000/api/v1/users/login"


// ** Tags
// Bean Bag
//#define kAPITagsIndex @"http://192.168.2.9:3000/api/v1/tags"
// Golden Gate
//#define kAPITagsIndex @"http://192.168.1.114:3000/api/v1/tags"
// Localhost
#define kAPITagsIndex @"http://0.0.0.0:3000/api/v1/tags"

// ** Tags
// Bean Bag
//#define kAPISuggestionsCreate @"http://192.168.2.9:3000/api/v1/suggestions"
// Golden Gate
//#define kAPISuggestionsCreate @"http://192.168.1.114:3000/api/v1/suggestions"
// Localhost
#define kAPISuggestionsCreate @"http://0.0.0.0:3000/api/v1/suggestions"



#endif
