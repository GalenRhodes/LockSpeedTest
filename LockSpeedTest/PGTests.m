/******************************************************************************************************************************//**
 *     PROJECT: LockSpeedTest
 *    FILENAME: PGTests.m
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

#import "PGTests.h"
#import <objc/objc-runtime.h>

#define PG_TEST_PREFIX     ("test")
#define PG_TEST_PREFIX_LEN (strlen(PG_TEST_PREFIX))

NSMutableArray<NSString *> *PGTestMessages = nil;

@implementation PGTests {
        NSNumberFormatter *_if;
        NSNumberFormatter *_df;
    }

    @synthesize startTime = _startTime;
    @synthesize stopTime = _stopTime;
    @synthesize totalTime = _totalTime;

    -(instancetype)init {
        self = [super init];

        if(self) {
            _if = [[self class] numberFormatter:0];
            _df = [[self class] numberFormatter:4];
        }

        return self;
    }

    -(NSInteger)runTests {
        unsigned int methodCount = 0;
        Method       *methodList = class_copyMethodList([self class], &methodCount);
        BOOL         runTests    = YES;
        NSInteger    results     = 0;

        @try {
            _startTime = CFAbsoluteTimeGetCurrent();
            for(int i = 0; (runTests && (i < methodCount)); ++i) {
                Method m   = methodList[i];
                SEL    sel = method_getName(m);
                if([self isTestCase:m target:sel]) runTests = ![self executeTestCase:sel];
            }
            _stopTime = CFAbsoluteTimeGetCurrent();
        }
        @catch(NSException *e) {
            _stopTime = CFAbsoluteTimeGetCurrent();
            results   = 1;
            PGLog(@"Exception \"%@\" occurred; Reason: %@; User Info: %@", e.name, e.reason, e.userInfo);
        }
        @finally {
            _totalTime = (_stopTime - _startTime);
            free(methodList);
            PGLog(@"All tests completed in %@ seconds.", [[[self class] numberFormatter:4] stringFromNumber:@(_totalTime)]);
        }

        return results;
    }

    -(void)beforeTest:(NSString *)testCaseName {
        /*
         * Do Nothing
         */
    }

    -(void)afterTest:(NSString *)testCaseName totalTime:(double)totalTime {
        /*
         * Do Nothing
         */
    }

    -(BOOL)onException:(NSException *)exception testCaseName:(NSString *)testCaseName when:(PGExceptionPoint)when {
        PGLog(@"Exception %@ test case \"%@\": %@, %@", [[self class] exceptionPointDescription:when], testCaseName, exception, [exception userInfo]);
        return NO;
    }

    -(BOOL)isTestCase:(Method)m target:(SEL)sel {
        const char *nam       = sel_getName(sel);
        char       *typ       = method_copyReturnType(m);
        BOOL       isTestCase = ((method_getNumberOfArguments(m) == 2) &&
                                 (strcmp(typ, @encode(NSUInteger)) == 0) &&
                                 (strlen(nam) > PG_TEST_PREFIX_LEN) &&
                                 (strncmp(nam, PG_TEST_PREFIX, PG_TEST_PREFIX_LEN) == 0));
        free(typ);
        return isTestCase;
    }

    -(BOOL)executeTestCase:(SEL)target {
        NSString         *tcName       = [NSString stringWithCString:sel_getName(target) encoding:NSUTF8StringEncoding];
        NSUInteger       tcIterations  = 1;
        double           tcStartTime   = 0;
        double           tcStopTime    = 0;
        double           tcTotalTime   = 0;
        double           tcTimePerIter = 0;
        BOOL             tcStopTests   = NO;
        PGExceptionPoint exceptionPoint;

        PGLog(@"Starting test case \"%@\".", tcName);

        @try {
            exceptionPoint = PGExceptionPointBefore;
            [self beforeTest:tcName];

            exceptionPoint = PGExceptionPointDuring;
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:target]];
            [inv setSelector:target];

            tcStartTime = CFAbsoluteTimeGetCurrent();
            [inv invokeWithTarget:self];
            tcStopTime = CFAbsoluteTimeGetCurrent();

            [inv getReturnValue:&tcIterations];
            tcTotalTime   = (tcStopTime - tcStartTime);
            tcTimePerIter = ((tcTotalTime / (double)(tcIterations ? : 1)) * _NANO_);

            exceptionPoint = PGExceptionPointAfter;
            [self afterTest:tcName totalTime:tcTotalTime];
        }
        @catch(NSException *exception) {
            tcStopTime  = CFAbsoluteTimeGetCurrent();
            tcTotalTime = (tcStopTime - tcStartTime);
            tcStopTests = [self onException:exception testCaseName:tcName when:exceptionPoint];
        }
        @finally {
            PGLog(@"LOG: %@", PGTestMessages);

            if(tcIterations > 1) {
                PGLog(@"Finished test case \"%@\": %@ seconds; %@ iterations; %@ nanoseconds/iteration",
                      tcName,
                      [_df stringFromNumber:@(tcTotalTime)],
                      [_if stringFromNumber:@(tcIterations)],
                      [_df stringFromNumber:@(tcTimePerIter)]);
            }
            else {
                PGLog(@"Finished test case \"%@\": %@ seconds; %@ iterations", tcName, [_df stringFromNumber:@(tcTotalTime)], [_if stringFromNumber:@(tcIterations)]);
            }

            [PGTestMessages removeAllObjects];
        }

        return tcStopTests;
    }

    +(void)initialize {
        static NSUInteger initcc = 0;
        if(PGTestMessages == nil) {
            PGLog(@"Initializing PGTestMessages array: %lu", ++initcc);
            PGTestMessages = [NSMutableArray new];
        }
    }

    +(NSString *)exceptionPointDescription:(PGExceptionPoint)exceptionPoint {
        NSString *swhen = nil;
        switch(exceptionPoint) {
            case PGExceptionPointBefore:
                swhen = @"before";
                break;
            case PGExceptionPointAfter:
                swhen = @"after";
                break;
            case PGExceptionPointDuring:
                swhen = @"during";
                break;
        }
        return swhen;
    }

    +(NSNumberFormatter *)numberFormatter:(NSUInteger)fractionDigits {
        NSNumberFormatter *nf = [NSNumberFormatter new];
        nf = [NSNumberFormatter new];
        nf.minimumIntegerDigits  = 1;
        nf.thousandSeparator     = @",";
        nf.groupingSeparator     = @",";
        nf.groupingSize          = 3;
        nf.usesGroupingSeparator = YES;
        nf.hasThousandSeparators = YES;
        nf.maximumFractionDigits = fractionDigits;
        nf.minimumFractionDigits = fractionDigits;
        return nf;
    }

@end


