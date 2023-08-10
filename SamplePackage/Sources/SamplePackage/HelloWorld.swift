//
//  HelloWorld.swift
//  
//
//  Created by Martin List on 10.08.23.
//

import Foundation

public struct HelloWorld {
    private let name: String
#if DEBUG
    private let secretName: String
#endif

    public init(name: String) {
        self.name = name
#if DEBUG
        self.secretName = "secret \(name)"
#endif
    }

    public func greetings() -> String {
#if DEBUG
        "Hello \(secretName)"
#else
        "Hello \(name)"
#endif
    }
}
