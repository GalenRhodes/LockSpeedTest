/******************************************************************************************************************************//**
 *     PROJECT: LockSpeedTest
 *    FILENAME: PGTestLockSpeeds.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2/5/18 11:51 AM
 * DESCRIPTION:
 *
 * Copyright © 2018 Project Galen. All rights reserved.
 *
 * "It can hardly be a coincidence that no language on Earth has ever produced the expression 'As pretty as an airport.' Airports
 * are ugly. Some are very ugly. Some attain a degree of ugliness that can only be the result of special effort."
 * - Douglas Adams from "The Long Dark Tea-Time of the Soul"
 *
 * Permission to use, copy, modify, and distribute this software for any purpose with or without fee is hereby granted, provided
 * that the above copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
 * CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
 * NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *********************************************************************************************************************************/

#import "PGTestLockSpeeds.h"

@implementation PGTestLockSpeeds {
        NSRecursiveLock *rlock;
        NSLock          *lock;
        NSString        *lockMe;
        NSUInteger      _iterations;
    }

    -(instancetype)initWithIterations:(NSUInteger)iterations {
        self = [self init];

        if(self) {
            rlock       = [NSRecursiveLock new];
            lock        = [NSLock new];
            lockMe      = @"lockMe";
            _iterations = iterations ?: 1;
        }

        return self;
    }

    -(instancetype)init {
        return (self = [self initWithIterations:1]);
    }

    -(NSUInteger)testNSRecursiveLock {
        for(uint64_t i = 0; i < _iterations;) {
            [rlock lock];
            ++i;
            [rlock unlock];
        }

        return _iterations;
    }

    -(NSUInteger)testNSLock {
        for(uint64_t i = 0; i < _iterations;) {
            [lock lock];
            ++i;
            [lock unlock];
        }
        return _iterations;
    }

    -(NSUInteger)testExceptionSafeNSRecursiveLock {
        for(uint64_t i = 0; i < _iterations;) {
            [rlock lock];
            @try {
                ++i;
            }
            @finally {
                [rlock unlock];
            }
        }
        return _iterations;
    }

    -(NSUInteger)testExceptionSafeNSLock {
        for(uint64_t i = 0; i < _iterations;) {
            [lock lock];
            @try {
                ++i;
            }
            @finally {
                [lock unlock];
            }
        }
        return _iterations;
    }

    -(NSUInteger)testSynchronized {
        for(uint64_t i = 0; i < _iterations;) {
            @synchronized(lockMe) {
                ++i;
            }
        }
        return _iterations;
    }

@end
