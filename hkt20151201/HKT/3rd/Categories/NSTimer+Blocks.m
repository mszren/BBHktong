//
//  NSTimer+Blocks.m
//
//  Created by Jiva DeVoe on 1/14/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "NSTimer+Blocks.h"

typedef BOOL (^NSTimerWrapBlockType)();

@implementation NSTimer (Blocks)

+ (id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval
                              target:(id)target
                             repeats:(BOOL)inRepeats
                               block:(void (^)())inBlock {
    
    __weak typeof(target) weakTarget = target;
    NSTimerWrapBlockType wrapBlock = ^() {
        if (!weakTarget) {
            return NO;
        }
        
        inBlock();
        return YES;
    };
    
    return [self scheduledTimerWithTimeInterval:inTimeInterval
                                         target:self
                                       selector:@selector(handleTimeout:)
                                       userInfo:wrapBlock
                                        repeats:inRepeats];
}

+ (id)timerWithTimeInterval:(NSTimeInterval)inTimeInterval
                     target:(id)target
                    repeats:(BOOL)inRepeats
                      block:(void (^)())inBlock {
    
    __weak typeof(target) weakTarget = target;
    NSTimerWrapBlockType wrapBlock = ^() {
        if (!weakTarget) {
            return NO;
        }
        
        inBlock();
        return YES;
    };
    
    return [self timerWithTimeInterval:inTimeInterval
                                target:self
                              selector:@selector(handleTimeout:)
                              userInfo:wrapBlock
                               repeats:inRepeats];
}

+ (void)handleTimeout:(NSTimer *)inTimer {
    
    if (inTimer.userInfo) {
        NSTimerWrapBlockType wrapBlock = inTimer.userInfo;
        if (!wrapBlock()) {
            [inTimer invalidate];
        }
    }
}

@end
