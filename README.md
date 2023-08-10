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

If you start the Project after checkout, everything builds and runs, because **SampleFramework** has been added to **SampleApp**'s *Frameworks, Libraries, and Embedded Content* ([Screenshot](https://github.com/mrtnlst/SampleProject/blob/main/Resources/Default-Embedding-of-Frameworks-into-App.png)) via Xcode. **SampleFramework** only adds **SamplePackage** as a *Target Dependency* ([Screenshot](https://github.com/mrtnlst/SampleProject/blob/main/Resources/Default-Linking-of-Package-to-Framework.png)), but it doesn't embed it (the App does).

## Reproduce the Crash

To reproduce the crash we do the following steps:

1. Compile **SampleFramework** in *Release* configuration
![Compiling Framework in Release Mode](https://github.com/mrtnlst/SampleProject/blob/main/Resources/Compiling-Framework-in-Release.png)

2. Remove the previous **SampleFramework** from our **SampleApp**'s *Frameworks, Libraries, and Embedded Content*
3. Select the **SampleFramework** binary from `Products` in the project navigator and open it in Finder
![Show binary framework in build directory](https://github.com/mrtnlst/SampleProject/blob/main/Resources/Show-Binary-Framework-from-Build-Directory.png)


4. Add the binary from `Release-iphonesimulator/SampleFramework.framework/SampleFramework` to **SampleApp**'s *Frameworks, Libraries, and Embedded Content*
![Add binary framework to App](https://github.com/mrtnlst/SampleProject/blob/main/Resources/Add-Binary-Framework-to-App.png)

5. Select the **SampleApp** scheme (make sure it's in *Debug* configuration) and run it again
6. Upon launch the project crashes
![Image of Crash](https://github.com/mrtnlst/SampleProject/blob/main/Resources/Crash-during-Runtime.png)

## Crash Details
Message: `EXC_BAD_ACCESS (code=1, address=0xfffffffffffffff0)`
Crashlog: 
```
Exception Type:  EXC_BAD_ACCESS (SIGSEGV)
Exception Subtype: KERN_INVALID_ADDRESS at 0xfffffffffffffff0
Exception Codes: 0x0000000000000001, 0xfffffffffffffff0
VM Region Info: 0xfffffffffffffff0 is not in any region.  Bytes after previous region: 18446638520056414193  
      REGION TYPE                    START - END         [ VSIZE] PRT/MAX SHRMOD  REGION DETAIL
      MALLOC_NANO (reserved)   600018000000-600020000000 [128.0M] rw-/rwx SM=NUL  ...(unallocated)
--->  
      UNUSED SPACE AT END
Termination Reason: SIGNAL 11 Segmentation fault: 11
Terminating Process: exc handler [50054]

Triggered by Thread:  0

Thread 0 Crashed::  Dispatch queue: com.apple.main-thread
0   libswiftCore.dylib            	       0x18bf8620c _swift_release_dealloc + 16
1   libswiftCore.dylib            	       0x18bf86df4 bool swift::RefCounts<swift::RefCountBitsT<(swift::RefCountInlinedness)1>>::doDecrementSlow<(swift::PerformDeinit)1>(swift::RefCountBitsT<(swift::RefCountInlinedness)1>, unsigned int) + 128
2   SampleApp                     	       0x100c4de3c outlined destroy of SampleView + 36
3   SampleApp                     	       0x100c4da60 closure #1 in SampleAppApp.body.getter + 108 (SampleApp.swift:15)
4   SwiftUI                       	       0x105cd1b6c 0x1050d4000 + 12573548
5   SampleApp                     	       0x100c4d900 SampleAppApp.body.getter + 144 (SampleApp.swift:14)
6   SampleApp                     	       0x100c4dd98 protocol witness for App.body.getter in conformance SampleAppApp + 12
```
[Complete Crashlog](https://github.com/mrtnlst/SampleProject/blob/main/Resources/SampleApp-2023-08-10-161752.ips)

## Hints

This crash does only occur when the `#if DEBUG` directives are present in `SamplePackage/Sources/SamplePackage/HelloWorld.swift`. Removing them and building a new **SampleFramework** (repeating the steps above) fixes the issue. 

If both **SampleApp** and **SampleFramework** are compiled with the same build configuration (*release* or *debug*) the issue also doesn't come up.
