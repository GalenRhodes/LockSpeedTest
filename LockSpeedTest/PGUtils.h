/******************************************************************************************************************************//**
 *     PROJECT: LockSpeedTest
 *    FILENAME: PGUtils.h
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

#ifndef __LockSpeedTest_PGUtils_H_
#define __LockSpeedTest_PGUtils_H_

#import <Foundation/Foundation.h>

#define _NANO_ ((double)(1000000000.0))

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const PGLogOutputPath;

FOUNDATION_EXPORT NSMutableArray<NSString *> *_Nullable PGLogQ;

FOUNDATION_EXPORT void PGLog(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

FOUNDATION_EXPORT void PGPrintLogMessages(void);

#ifndef __APPLE__

FOUNDATION_EXPORT double CFAbsoluteTimeGetCurrent(void);

#endif

@interface PGLoader : NSObject
@end

NS_ASSUME_NONNULL_END

#endif //__LockSpeedTest_PGUtils_H_
