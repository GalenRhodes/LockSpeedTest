# LockSpeedTest

This project was initially started to test the speed of various concurrancy locks
in Objective-C.  However it evolved into a more general testing framework.

# -fobjc-arc-exceptions
My current use of this is to test if there was any overhead involved with using the
clang `-fobjc-arc-exceptions` flag to ensure that memory isn't leaked when exceptions
are thrown in Objective-C.

**The result?** None. The numbers I've generated (running 2 million iterations) show
that if there is a difference it's only by a few nanoseconds at best. And, I should
point out, that's a few nanoseconds _FASTER_ than without using `-fobjc-arc-exceptions`!

All of this leads me to wonder why Apple would have chosen to NOT make this the default
when building their own Frameworks. Anyone with some deep knowledge care to chime in?
