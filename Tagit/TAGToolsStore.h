//
//  TAGToolsStore.h
//  
//
//  Created by Shane Rogers on 12/28/14.
//
//

#import <Foundation/Foundation.h>

#import "GPUImage.h"

typedef enum {
    ART_ADJUST,
    ART_BRIGHTNESS,
    ART_CONTRAST,
    ART_HIGHLIGHTS,
    ART_SHADOWS,
    ART_SATURATION,
    ART_VIGNETTE,
    ART_WARMTH,
    ART_TILTSHIFT,
    ART_SHARPEN
} ARTToolType;

extern NSString *const kFilterTool;
extern NSString *const kFilterSlider;

@interface TAGToolsStore : NSObject {
    GPUImageOutput<GPUImageInput> *filter;
}

+ (instancetype)sharedStore;
+ (void)setupSlider:(UISlider *)slider forFilterType:(ARTToolType)toolType;

- (NSMutableArray *)allTools;

- (void)generateToolOptions;

@end