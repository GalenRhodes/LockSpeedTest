# LockSpeedTest

This project was initially started to test the speed of various concurrancy locks
in Objective-C.  However it evolved into a more general testing framework.

# -fobjc-arc-exceptions
My current use of this is to test if there was any overhead involved with using the
clang `-fobjc-arc-exceptions` flag to ensure that memory isn't leaked when exceptions
are thrown in Objective-C.

Basically I compiled this test without `-fobjc-arc-exceptions` and ran it and then
compiled it again _WITH_ `-fobjc-arc-exceptions` and then ran it again. Each time
it runs a simple test where it throws an exception with a variable with locality
inside a `@try {}` block is assigned a newly created object. It does this 2,000,000
times and takes an average of the time to complete each loop _(total_time / iterations)_.

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

The class `TestClass` is just a very simple class. The important bit is that it logs
a message when it is both created and deallocated.

```objectivec
-(instancetype)init {
    self = [super init];

    if(self) {
        _instanceNumber = [[self class] nextInstanceNumber];
        _instanceName   = [NSString stringWithFormat:@"%@:%@", NSStringFromClass([self class]), [[self class] formattedInstanceNumber:self.instanceNumber]];
        [PGTestMessages addObject:[NSString stringWithFormat:@"Instance %@ created.", self.instanceName]];
    }

    return self;
}

-(void)dealloc {
    [PGTestMessages addObject:[NSString stringWithFormat:@"Instance %@ deallocating.", self.instanceName]];
}
```

Then when the log is printed after the test you can see each instance of the `TestClass`
being created and deallocated. Even better you can see the effect of the
`-fobjc-arc-exceptions` flag at the end of the output.

Without `-fobjc-arc-exceptions`
```
"Instance TestClass:1,999,997 created.",
"--------------------------------------------------------------",
"Instance TestClass:1,999,997 deallocating.",
"Instance TestClass:1,999,998 created.",
"--------------------------------------------------------------",
"Instance TestClass:1,999,998 deallocating.",
"Instance TestClass:1,999,999 created.",
"--------------------------------------------------------------",
"Instance TestClass:1,999,999 deallocating.",
"Instance TestClass:2,000,000 created.",
"Exception: NSGenericException; Reason: No Reason; User Info: {\n    \"Last String\" = \"abnegating abnegation abnegations abnegative abnegator abnegators Abner abnerval abnet abneural\";\n}"
```

**_With_** `-fobjc-arc-exceptions`
```
"Instance TestClass:1,999,997 created.",
"--------------------------------------------------------------",
"Instance TestClass:1,999,997 deallocating.",
"Instance TestClass:1,999,998 created.",
"--------------------------------------------------------------",
"Instance TestClass:1,999,998 deallocating.",
"Instance TestClass:1,999,999 created.",
"--------------------------------------------------------------",
"Instance TestClass:1,999,999 deallocating.",
"Instance TestClass:2,000,000 created.",
"Instance TestClass:2,000,000 deallocating.",
"Exception: NSGenericException; Reason: No Reason; User Info: {\n    \"Last String\" = \"abnegating abnegation abnegations abnegative abnegator abnegators Abner abnerval abnet abneural\";\n}"
```

You can see that without the `-fobjc-arc-exceptions` flag (the first example) the
last instance is never deallocated because the exception is thrown. The next
example **_with_** the `-fobjc-arc-exceptions` flag clearly shows that code was
added to clean up the objects. The line of bars is not printed between the creation
and deallocation because the exception was thrown before execution reached that
point.

**The result?** No difference. None. The numbers I've generated (running it three
times each way and taking the average) show that if there is a difference it's only
by a few nanoseconds at best. And, I should point out, that's a few nanoseconds
_FASTER_ than without using `-fobjc-arc-exceptions`!

| Run | Without Flag | With Flag |
|:---:|:------------:|:---------:|
| 1 | 12,720.9940 ns | 12,391.1695 ns |


All of this leads me to wonder why Apple would have chosen to NOT make this the
default when building their own Frameworks. Anyone with some deep knowledge care
to chime in?
