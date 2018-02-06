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
#import "PGARCException.h"

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        [[PGARCException new] runTests];
        return 0;
    }
}

#pragma clang diagnostic pop
