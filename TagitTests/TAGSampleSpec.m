//
//  TAGSampleSpec.m
//  Tagit
//
//  Created by Shane Rogers on 10/19/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

SPEC_END