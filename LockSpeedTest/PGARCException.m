/******************************************************************************************************************************//**
 *     PROJECT: LockSpeedTest
 *    FILENAME: PGARCException.m
 *         IDE: AppCode
 *      AUTHOR: Galen Rhodes
 *        DATE: 2/5/18 3:29 PM
 * DESCRIPTION:
 *
 * Copyright © 2018 Project Galen. All rights reserved.
 *
 * @"It can hardly be a coincidence that no language on Earth has ever produced the expression 'As pretty as an airport.' Airports
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

#import "PGARCException.h"

@interface TestClass : NSObject

    @property(nonatomic, readonly) NSArray<NSString *> *wordList;
    @property(nonatomic, readonly) NSString            *instanceName;
    @property(nonatomic, readonly) NSUInteger          instanceNumber;

    -(instancetype)init;

    -(NSString *)buildString:(NSUInteger)point;

    +(NSUInteger)nextInstanceNumber;

@end

@implementation PGARCException {
    }

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCDFAInspection"

    -(NSUInteger)testARCExceptions {
        NSString   *str      = nil;
        NSUInteger iter      = _ITERATIONS_;
        NSUInteger throwWhen = (iter - 1);

        for(NSUInteger i = 0; i < iter; ++i) {
            @try {
                TestClass *test = nil;
                test = [[TestClass alloc] init];
                str  = [test buildString:i];
                if(i == throwWhen) {
                    @throw [NSException exceptionWithName:NSGenericException reason:@"No Reason" userInfo:@{ @"Last String":str }];
                }
                [PGTestMessages addObject:@"--------------------------------------------------------------"];
            }
            @catch(NSException *e) {
                [PGTestMessages addObject:[NSString stringWithFormat:@"Exception: %@; Reason: %@; User Info: %@", e.name, e.reason, e.userInfo]];
            }
        }

        return iter;
    }

#pragma clang diagnostic pop

@end

@implementation TestClass {
    }

    @synthesize wordList = _wordList;
    @synthesize instanceName = _instanceName;
    @synthesize instanceNumber = _instanceNumber;

    -(NSString *)buildString:(NSUInteger)point {
        NSArray<NSString *> *wordList = self.wordList;
        NSUInteger          cc        = wordList.count;
        NSUInteger          j         = (NSUInteger)((point * 20) % cc);
        NSMutableString     *mstr     = [wordList[j] mutableCopy];

        for(int k = 1; k < 10; ++k) {
            [mstr appendString:@" "];
            [mstr appendString:[wordList[(j + k) % cc] copy]];
        }
        return mstr;
    }

    -(void)dealloc {
        [PGTestMessages addObject:[NSString stringWithFormat:@"Instance %@ deallocating.", self.instanceName]];
    }

    -(instancetype)init {
        self = [super init];

        if(self) {
            _instanceNumber = [[self class] nextInstanceNumber];
            _instanceName   = [NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [[self class] formattedInstanceNumber:self.instanceNumber]];
            _wordList       = [[self class] masterWordList];
            [PGTestMessages addObject:[NSString stringWithFormat:@"Instance %@ created.", self.instanceName]];
        }

        return self;
    }

    +(NSUInteger)nextInstanceNumber {
        static NSUInteger _nextInstanceNumber = 1;
        @synchronized([TestClass class]) {
            return _nextInstanceNumber++;
        }
    }

    +(NSString *)formattedInstanceNumber:(NSUInteger)instnum {
        static NSNumberFormatter *_formatter = nil;
        @synchronized([TestClass class]) {
            if(_formatter == nil) _formatter = [PGTests numberFormatter:0];
            return [_formatter stringFromNumber:@(instnum)];
        }
    }

    +(NSArray<NSString *> *)masterWordList {
        static NSArray<NSString *> *_wl = nil;
        @synchronized([TestClass class]) {
            if(_wl == nil) {
                _wl = @[
                        @"ableness", @"ablepharia", @"ablepharon", @"ablepharous", @"Ablepharus", @"ablepsy", @"ablepsia", @"ableptical", @"ableptically", @"abler", @"ables",
                        @"ablesse", @"ablest", @"ablet", @"ablewhackets", @"ably", @"ablings", @"ablins", @"ablock", @"abloom", @"ablow", @"ABLS", @"ablude", @"abluent",
                        @"abluents", @"ablush", @"ablute", @"abluted", @"ablution", @"ablutionary", @"ablutions", @"abluvion", @"ABM", @"abmho", @"abmhos", @"abmodality",
                        @"abmodalities", @"abn", @"Abnaki", @"Abnakis", @"abnegate", @"abnegated", @"abnegates", @"abnegating", @"abnegation", @"abnegations", @"abnegative",
                        @"abnegator", @"abnegators", @"Abner", @"abnerval", @"abnet", @"abneural", @"abnormal", @"abnormalcy", @"abnormalcies", @"abnormalise", @"abnormalised",
                        @"abnormalising", @"abnormalism", @"abnormalist", @"abnormality", @"abnormalities", @"abnormalize", @"abnormalized", @"abnormalizing", @"abnormally",
                        @"abnormalness", @"abnormals", @"abnormity", @"abnormities", @"abnormous", @"abnumerable", @"Abo", @"aboard", @"aboardage", @"Abobra", @"abococket",
                        @"abodah", @"abode", @"aboded", @"abodement", @"abodes", @"abode's", @"abody", @"aboding", @"abogado", @"abogados", @"abohm", @"abohms", @"aboideau",
                        @"aboideaus", @"aboideaux", @"aboil", @"aboiteau", @"aboiteaus", @"aboiteaux", @"abolete", @"abolish", @"abolishable", @"abolished", @"abolisher",
                        @"abolishers", @"abolishes", @"abolishing", @"abolishment", @"abolishments", @"abolishment's", @"abolition", @"abolitionary", @"abolitionise",
                        @"abolitionised", @"abolitionising", @"abolitionism", @"abolitionist", @"abolitionists", @"abolitionize", @"abolitionized", @"abolitionizing",
                        @"abolitions", @"abolla", @"abollae", @"aboma", @"abomas", @"abomasa", @"abomasal", @"abomasi", @"abomasum", @"abomasus", @"abomasusi", @"A-bomb",
                        @"abominability", @"abominable", @"abominableness", @"abominably", @"abominate", @"abominated", @"abominates", @"abominating", @"abomination",
                        @"abominations", @"abominator", @"abominators", @"abomine", @"abondance", @"Abongo", @"abonne", @"abonnement", @"aboon", @"aborad", @"aboral", @"aborally",
                        @"abord", @"Aboriginal", @"aboriginality", @"aboriginally", @"aboriginals", @"aboriginary", @"Aborigine", @"aborigines", @"aborigine's", @"Abor-miri",
                        @"Aborn", @"aborning", @"a-borning", @"aborsement", @"aborsive", @"abort", @"aborted", @"aborter", @"aborters", @"aborticide", @"abortient",
                        @"abortifacient", @"abortin", @"aborting", @"abortion", @"abortional", @"abortionist", @"abortionists", @"abortions", @"abortion's", @"abortive",
                        @"abortively", @"abortiveness", @"abortogenic", @"aborts", @"abortus", @"abortuses", @"abos", @"abote", @"Abott", @"abouchement", @"aboudikro", @"abought",
                        @"Aboukir", @"aboulia", @"aboulias", @"aboulic", @"abound", @"abounded", @"abounder", @"abounding", @"aboundingly", @"abounds", @"Abourezk", @"about",
                        @"about-face", @"about-faced", @"about-facing", @"abouts", @"about-ship", @"about-shipped", @"about-shipping", @"about-sledge", @"about-turn", @"above",
                        @"aboveboard", @"above-board", @"above-cited", @"abovedeck", @"above-found", @"above-given", @"aboveground", @"abovementioned", @"above-mentioned",
                        @"above-named", @"aboveproof", @"above-quoted", @"above-reported", @"aboves", @"abovesaid", @"above-said", @"abovestairs", @"above-water", @"above-written",
                        @"abow", @"abox", @"Abp", @"ABPC", @"Abqaiq", @"abr", @"abr.", @"Abra", @"abracadabra", @"abrachia", @"abrachias", @"abradable", @"abradant", @"abradants",
                        @"abrade", @"abraded", @"abrader", @"abraders", @"abrades", @"abrading", @"Abraham", @"Abrahamic", @"Abrahamidae", @"Abrahamite", @"Abrahamitic",
                        @"Abraham-man", @"Abrahams", @"Abrahamsen", @"Abrahan", @"abray", @"abraid", @"Abram", @"Abramis", @"Abramo", @"Abrams", @"Abramson", @"Abran",
                        @"abranchial", @"abranchialism", @"abranchian", @"Abranchiata", @"abranchiate", @"abranchious", @"abrasax", @"abrase", @"abrased", @"abraser", @"abrash",
                        @"abrasing", @"abrasiometer", @"abrasion", @"abrasions", @"abrasion's", @"abrasive", @"abrasively", @"abrasiveness", @"abrasivenesses", @"abrasives",
                        @"abrastol", @"abraum", @"abraxas", @"abrazite", @"abrazitic", @"abrazo", @"abrazos", @"abreact", @"abreacted", @"abreacting", @"abreaction",
                        @"abreactions", @"abreacts", @"abreast", @"abreed", @"abrege", @"abreid", @"abrenounce", @"abrenunciate", @"abrenunciation", @"abreption", @"abret",
                        @"abreuvoir", @"abri", @"abrico", @"abricock", @"abricot", @"abridgable", @"abridge", @"abridgeable", @"abridged", @"abridgedly", @"abridgement",
                        @"abridgements", @"abridger", @"abridgers", @"abridges", @"abridging", @"abridgment", @"abridgments", @"abrim", @"abrin", @"abrine", @"abris", @"abristle",
                        @"abroach", @"abroad", @"Abrocoma", @"abrocome", @"abrogable", @"abrogate", @"abrogated", @"abrogates", @"abrogating", @"abrogation"
                ];
            }
            return _wl;
        }
    }

@end
