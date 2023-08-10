//
//  SampleView.swift
//  SampleFramework
//
//  Created by Martin List on 10.08.23.
//

import SwiftUI
import SamplePackage

public struct SampleView: View {
    let helloWorld = HelloWorld(name: String(describing: Self.self))

    public init() {}

    public var body: some View {
        Text(helloWorld.greetings())
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
