//
//  main.m
//  LockSpeedTest
//
//  Created by Galen Rhodes on 2/2/18.
//  Copyright © 2018 Project Galen. All rights reserved.
//

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnusedImportStatement"

#import <Foundation/Foundation.h>
#import "PGTests.h"
#import "PGTestLockSpeeds.h"
#import "PGARCException.h"

#define TEST_ARC   0
#define TEST_LOCKS 1

#define RUN_TEST TEST_ARC

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        PGTests *test = nil;
        [PGLoader new];

        switch(RUN_TEST) {
            case TEST_ARC: test = [[PGARCException alloc] initWithIterations:20000];
                break;
            case TEST_LOCKS:test = [[PGTestLockSpeeds alloc] initWithIterations:20000000];
                break;
            default: test = nil;
                break;
        }

        [test runTests];
        return 0;
    }
}

#pragma clang diagnostic pop
