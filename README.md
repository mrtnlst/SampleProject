# Debug Compiler Directives in Swift Package cause Runtime Crash

This sample project provides a setup to reproduce a crash when using `#if DEBUG` directives in a Swift Package that is linked (but not embedded) to a *release build* of a static library. If the static library and the Package's library target are embedded into an App a runtime crash occurs. 

If the App target is also build in `release`, the crash doesn't occur.

## Project Setup 

The SampleProject consists of:

* an App Target called **SampleApp**
* a Framework Target called **SampleFramework**
* a local Swift Package called **SamplePackage**

The Dependency Graph looks like this: 

```
SampleApp
└── embeds SampleFramework
    └── links to SamplePackage
└── embeds SamplePackage
```

If you start the Project after checkout, everything builds and runs, because **SampleFramework** has been added to **SampleApp**'s *Frameworks, Libraries, and Embedded Content* (Screenshot) via Xcode. **SampleFramework** only adds **SamplePackage** as a *Target Dependency* (Screenshot), but it doesn't embed it (the App does).

## Reproduce the Crash

To reproduce the crash we do the following steps:

1. Compile **SampleFramework** in *Release* configuration (Screenshot)
2. Remove the previous **SampleFramework** from our **SampleApp**'s *Frameworks, Libraries, and Embedded Content*
3. Select the **SampleFramework** binary from `Products` in the project navigator and open it in Finder (Screenshot)
4. Add the binary from `Release-iphonesimulator/SampleFramework.framework/SampleFramework` to **SampleApp**'s *Frameworks, Libraries, and Embedded Content* (Screenshot)
5. Select the **SampleApp** scheme (make sure it's in *Debug* configuration) and run it again
6. Upon launch the project crashes (Screenshot)

## Hints

This crash does only occur when the `#if DEBUG` directives are present in `SamplePackage/Sources/SamplePackage/HelloWorld.swift`. Removing them and building a new **SampleFramework** (repeating the steps above) fixes the issue. 

If both **SampleApp** and **SampleFramework** are compiled with the same build configuration (*release* or *debug*) the issue also doesn't come up.
