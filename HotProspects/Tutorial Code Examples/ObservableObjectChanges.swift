//
//  ObservableObjectChanhges.swift
//  HotProspects
//
//  Created by Миша Перевозчиков on 26.02.2022.
//

import SwiftUI

@MainActor class DelayedUpdater: ObservableObject {
    var value = 0 {
        willSet {
            objectWillChange.send()
        }
    }
    
    init() {
        for i in 1...10 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.value += 1
            }
        }
    }
}

struct ObservableObjectChanges: View {
    @StateObject var updater = DelayedUpdater()
    
    var body: some View {
        Text("Value is \(updater.value)")
    }
}

struct ObservableObjectChanges_Previews: PreviewProvider {
    static var previews: some View {
        ObservableObjectChanges()
    }
}
