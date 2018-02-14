/******************************************************************************************************************************//**
 *     PROJECT: LockSpeedTest
 *    FILENAME: PGTests.h
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2/5/18 11:21 AM
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

#ifndef __LockSpeedTest_PGTests_H_
#define __LockSpeedTest_PGTests_H_

#import <Foundation/Foundation.h>
#import "PGUtils.h"

#define _ITERATIONS_ ((NSUInteger)(20000000))

typedef enum _pg_exception_point {
    PGExceptionPointBefore, PGExceptionPointDuring, PGExceptionPointAfter
} PGExceptionPoint;

NS_ASSUME_NONNULL_BEGIN

@interface PGTests : NSObject

    @property(atomic, readonly) double startTime;
    @property(atomic, readonly) double stopTime;
    @property(atomic, readonly) double totalTime;

    -(void)beforeTest:(NSString *)testCaseName;

    -(void)afterTest:(NSString *)testCaseName totalTime:(double)totalTime;

    -(BOOL)onException:(NSException *)exception testCaseName:(NSString *)testCaseName when:(PGExceptionPoint)when;

    -(NSInteger)runTests;

    +(NSString *)exceptionPointDescription:(PGExceptionPoint)exceptionPoint;

    +(NSNumberFormatter *)numberFormatter:(NSUInteger)fractionDigits;

@end

NS_ASSUME_NONNULL_END

#endif //__LockSpeedTest_PGTests_H_
