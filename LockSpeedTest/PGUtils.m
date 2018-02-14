/******************************************************************************************************************************//**
 *     PROJECT: LockSpeedTest
 *    FILENAME: PGUtils.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2/6/18 10:29 AM
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

#import "PGUtils.h"

NSString *const PGLogOutputPath = @"/dev/stdout";
NSMutableArray<NSString *> *PGLogQ = nil;

@implementation PGLoader

    +(void)initialize {
        static NSUInteger initcc = 0;
        if(PGLogQ == nil) {
            PGLog(@"Initializing PGLogQ: %lu", ++initcc);
            PGLogQ = [NSMutableArray arrayWithCapacity:256 * 1024];
        }
    }

@end

void PGPrintLogLine(NSMutableString *mstr, NSString *str) {
    [mstr appendString:@"LOG: "];
    [mstr appendString:str];
    [mstr appendString:@"\n"];
    [mstr writeToFile:PGLogOutputPath atomically:NO encoding:NSUTF8StringEncoding error:nil];
    [mstr setString:@""];
}

void _PGPrintLogLine(NSString *line) {
    PGPrintLogLine([NSMutableString stringWithCapacity:line.length + 10], line ?: @"");
}

void PGLog(NSString *format, ...) {
    va_list vargs;
    va_start(vargs, format);
    NSString *str = [[NSString alloc] initWithFormat:format arguments:vargs];
    if(PGLogQ) [PGLogQ addObject:str]; else _PGPrintLogLine(str);
    va_end(vargs);
}

void PGPrintLogMessages(void) {
    NSMutableString *mstr = [NSMutableString new];
    for(NSString    *str in PGLogQ) PGPrintLogLine(mstr, str);
    [PGLogQ removeAllObjects];
}

#ifndef __APPLE__

double CFAbsoluteTimeGetCurrent(void) {
    struct timespec ts;
    int res = clock_gettime(CLOCK_MONOTONIC, &ts);
    return (((double)ts.tv_sec) + (((double)ts.tv_nsec) / _NANO_));
}

#endif
