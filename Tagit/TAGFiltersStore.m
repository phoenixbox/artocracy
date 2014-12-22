//
//  TAGFiltersStore.m
//  Tagit
//
//  Created by Shane Rogers on 12/22/14.
//  Copyright (c) 2014 Shane Rogers. All rights reserved.
//

#import "TAGFiltersStore.h"

// GPUImage Imports
#import "GPUImageMonochromeFilter.h"
#import "GPUImagePicture.h"
#import "GPUImageView.h"
#import "GPUImagePicture.h"
#import "GPUImageSaturationFilter.h"
#import "GPUImageVignetteFilter.h"
#import "GPUImageExposureFilter.h"
#import "GPUImageFilterGroup.h"
#import "GPUImageGrayscaleFilter.h"
#import "GPUImageAlphaBlendFilter.h"

// If just using the reference images we dont need the other filter imports
#import "GPUImageLookupFilter.h"

@interface TAGFiltersStore ()

@property (nonatomic, strong) NSMutableArray *filterOptions;

@end

@implementation TAGFiltersStore

+ (instancetype)sharedStore {
    static id filterStore = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        filterStore = [[self alloc] init];
    });

    return filterStore;
}

- (void)generateFiltersForImage:(UIImage *)image {
    NSArray *filterTypes = @[
                             @"lookup_cooling.png",
                             @"lookup_cooling2.png",
                             @"lookup_filter1.png",
                             @"lookup_filter2.png",
                             @"lookup_highkey.png",
                             @"lookup_infrared.png",
                             @"lookup_sepia.png",
                             @"lookup_sepia2.png",
                             @"lookup_vibrance.png",
                             @"lookup_warming.png"];

    NSMutableArray *options = [NSMutableArray new];

    for (int index = 0; index < [filterTypes count]; index++) {
        UIImage *processedImage;
        NSString *filename = [filterTypes objectAtIndex:index];


        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];

        GPUImagePicture *lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:filename]];
        NSLog(@"%@", filename);
        GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];

        [stillImageSource addTarget:lookupFilter];
        [lookupImageSource addTarget:lookupFilter];

        [stillImageSource processImage];
        [lookupImageSource processImage];

        [lookupFilter useNextFrameForImageCapture];

        processedImage = [lookupFilter imageFromCurrentFramebufferWithOrientation:image.imageOrientation];

        NSDictionary *filteredDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:processedImage, @"filteredImage", filename, @"filename", nil];
        [options addObject:filteredDictionary];
    }
    // Any custom setup work goes here

    self.filterOptions = options;
}

- (NSMutableArray *)allFilters {
    return [self filterOptions];
}

@end