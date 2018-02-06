# Moscow

Moscow is intended to be a more generic and lightweight replacement for the
[macOS DOM classes](https://developer.apple.com/documentation/foundation/archives_and_serialization/xml_processing_and_modeling?language=objc).
One of the primary reasons for building this library is that it is not included
in iOS, watchOS, tvOS.  The other goal was to bring the flexability of supporting
other input and output formats besides XML - such as (but not limited to) JSON and
INI files.

### Comparison to Java Version

See [Java JDK 1.8 API Documentation](http://docs.oracle.com/javase/8/docs/api/index.html?org/w3c/dom/Node.html)

Although there is a lot in Moscow that is inspired by the Java XML libraries
there has been no attempt to model either the API or the behavior of the
Java XML libraries completely or exactly. Changes have been made where this
developer felt that the Java XML libraries fell short, could have been simpler,
didn't work intuitively, or could have worked heck of a lot better.

One area where Moscow diverges from the Java XML libraries is that Moscow uses the
Objective-C design pattern of [Class Clusters](https://developer.apple.com/library/content/documentation/General/Conceptual/DevPedia-CocoaCore/ClassCluster.html)
rather than the Java design pattern of
[interfaces](https://docs.oracle.com/javase/tutorial/java/concepts/interface.html).
Although Objective-C has @protocol which is similar to Java interfaces they do not
behave exactly the same. Also class clusters provide the same functionality that
were behind the initial reasoning of interfaces which was to not bind the interface
to any one implementation or any implementation at all.

### ARC and Exceptions

Since Moscow makes use of both ARC and Exceptions it is set to compile using the clang
_-fobjc-arc-exceptions_ compiler flag so that the reference counts of objects that are
retained within the _@try_ block are properly updated in the event of a thrown exception.
Very informal tests have shown that setting this flag does not have any impact on the
size or performance of the code. In fact, at least on Linux using GNUstep, it resulted
in code that was 2K smaller and ran a few seconds faster.  Weird!

### Limitations

Moscow is not thread-safe. While there are some instances of thread-safety in certain
places it was always intended that any synchronization be left up to the code using
Moscow. This will help Moscow to be as fast as possible in uses where multi-threading
is not a consideration.
