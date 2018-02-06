# LockSpeedTest

This project was initially started to test the speed of various concurrancy locks
in Objective-C.  However it evolved into a more general testing framework.

# -fobjc-arc-exceptions
My current use of this is to test if there was any overhead involved with using the
clang `-fobjc-arc-exceptions` flag to ensure that memory isn't leaked when exceptions
are thrown in Objective-C.

Basically I compiled this test without `-fobjc-arc-exceptions` and ran it and then
compiled it again _WITH_ `-fobjc-arc-exceptions` and then ran it again. Each times
it runs a simple test where it throws an exception while a variable with locality
inside a `@try {}` block. It does this 2,000,000 times and takes an average of the
time to complete each loop.

```objectivec
#define _ITERATIONS_ ((uint64_t)(2000000))

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
```

**The result?** None. The numbers I've generated (running 2 million iterations) show
that if there is a difference it's only by a few nanoseconds at best. And, I should
point out, that's a few nanoseconds _FASTER_ than without using `-fobjc-arc-exceptions`!

All of this leads me to wonder why Apple would have chosen to NOT make this the default
when building their own Frameworks. Anyone with some deep knowledge care to chime in?
