//
//  ContentView.swift
//  app
//
//  Created by kelly on 2020/02/21.
//  Copyright © 2020 kelly. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button("Export Health Data") {
            HealthKitService.shared.getData()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
