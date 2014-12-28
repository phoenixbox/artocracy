//
//  TAGToolsStore.m
//  
//
//  Created by Shane Rogers on 12/28/14.
//
//

#import "TAGToolsStore.h"

@interface TAGToolsStore ()

@property (nonatomic, strong) NSMutableArray *toolOptions;

@end

@implementation TAGToolsStore

+ (instancetype)sharedStore {
    static id toolStore = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toolStore = [[self alloc] init];
    });

    return toolStore;
}

- (NSMutableArray *)allTools {
    return [self toolOptions];
}

- (void)generateToolOptions {

    NSArray *toolTypes = @[
                             @"adjust.png",
                             @"brightness.png",
                             @"contrast.png",
                             @"highlights.png",
                             @"shadows.png",
                             @"saturation.png",
                             @"vignette.png",
                             @"warmth.png",
                             @"tiltShift.png",
                             @"sharpen.png"];

    // NOTE: Combine to dicts when social media appraisal done
    NSArray *toolNames = @[
                           @"Adjust",
                           @"Brightness",
                           @"Contrast",
                           @"Highlights",
                           @"Shadows",
                           @"Saturation",
                           @"Vignette",
                           @"Warmth",
                           @"Tilt Shift",
                           @"Sharpen"];

    NSMutableArray *options = [NSMutableArray new];

    for (int index = 0; index < [toolTypes count]; index++) {
        NSString *filename = [toolTypes objectAtIndex:index];
        NSString *toolName = [toolNames objectAtIndex:index];

        UIImage *toolIcon = [UIImage imageNamed:filename];

        NSDictionary *toolDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                            toolIcon, @"toolIcon",
                                            filename, @"filename",
                                            toolName, @"toolName", nil];

        [options addObject:toolDictionary];
    }
    // Any custom setup work goes here
    
    self.toolOptions = options;
}

@end