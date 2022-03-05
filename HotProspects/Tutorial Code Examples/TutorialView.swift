//
//  TutorialView.swift
//  HotProspects
//
//  Created by Миша Перевозчиков on 23.02.2022.
//

import SwiftUI

@MainActor class User: ObservableObject {
    @Published var name = "Taylor Swift"
}

struct EditView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        TextField("Name", text: $user.name)
            .textFieldStyle(.roundedBorder)
    }
}

struct DisplayView: View {
    @EnvironmentObject var user: User
    
    var body: some View {
        Text(user.name)
    }
}
struct TutorialView: View {
    //That @EnvironmentObject property wrapper will automatically look for a User instance in the environment, and place whatever it finds into the user property. If it can’t find a User in the environment your code will just crash, so please be careful.
    
    @StateObject var user = User()
    @State private var selectedTab = "One"

    
    var body: some View {
        VStack{
            EditView()//.environmentObject(user)
                .padding()
            DisplayView()//.environmentObject(user)
        }
        .environmentObject(user)
        TabView(selection: $selectedTab) {
            Text("Tab 1")
                .onTapGesture {
                    selectedTab = "Counter"
                    print(selectedTab)
                }
                .tabItem {
                    Label("One", systemImage: "star")
                }
            //Tag is the thing than allow us to bind a @State and current represented Tab 
                .tag("One")
            VStack{
                Text("Tab 2")
                ObservableObjectChanges()
                
            }
                .tabItem {
                    Label("Counter", systemImage: "circle")
                }
                .tag("Counter")
            
            UnderstandingResult()
                .tabItem{
                    Label("Result", systemImage: "icloud.and.arrow.down")
                }
        }
    }
    
}

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
