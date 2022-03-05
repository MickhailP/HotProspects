//
//  ContextMenuExample.swift
//  HotProspects
//
//  Created by Миша Перевозчиков on 26.02.2022.
//

import SwiftUI

struct SwipeActions: View {
    var body: some View {
        List{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .swipeActions{
                    Button(role: .destructive) {
                        print("Deleted")
                    } label: {
                        Label("Delete", systemImage: "minus.circle")
                    }
                }
                .swipeActions(edge: .leading){
                    Button(role: .destructive) {
                        print("Pinned")
                    } label: {
                        Label("Pin", systemImage: "pin")
                    }
                    .tint(.orange)
                }
        }
    }
}

struct SwipeActions_Previews: PreviewProvider {
    static var previews: some View {
        SwipeActions()
    }
}
