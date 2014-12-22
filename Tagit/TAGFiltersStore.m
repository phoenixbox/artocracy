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
    // Any custom setup work goes here
    NSMutableArray *options = [NSMutableArray new];

    UIImage *processedImage;
    NSString *filename = @"lookup_cooling.png";

    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];

    GPUImagePicture *lookupImageSource = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:filename]];
    GPUImageLookupFilter *lookupFilter = [[GPUImageLookupFilter alloc] init];

    [stillImageSource addTarget:lookupFilter];
    [lookupImageSource addTarget:lookupFilter];

    [stillImageSource processImage];
    [lookupImageSource processImage];

    [lookupFilter useNextFrameForImageCapture];

    processedImage = [lookupFilter imageFromCurrentFramebufferWithOrientation:image.imageOrientation];

    NSDictionary *filteredDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:processedImage, @"filteredImage", filename, @"filename", nil];

    [options insertObject:filteredDictionary atIndex:0];
    
    self.filterOptions = options;
}

- (NSMutableArray *)allFilters {
    return [self filterOptions];
}

@end