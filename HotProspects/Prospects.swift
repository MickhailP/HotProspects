//
//  Prospects.swift
//  HotProspects
//
//  Created by Миша Перевозчиков on 27.02.2022.
//

import SwiftUI

class Prospect: Identifiable, Codable, Equatable {
    
    
    var id = UUID()
    var name = "Anonymous"
    var email = ""
    
    //ACESS CONTROL ELEMENT
    //this is allow us to change our property just inside this file
    //it's safe our code from bugs in the future because we can't change this property directly just with method below
    fileprivate (set) var isContacted = false
    
    static func == (lhs: Prospect, rhs: Prospect) -> Bool {
         lhs.id == rhs.id
    }
}

@MainActor class Prospects: ObservableObject {
    
    //private(set) allow us to make sure that our views can write to people array just with add() method that declared in this class
    @Published private(set) var people: [Prospect]
    
    // the better approach to save data without future mistakes or typos
    let saveKey = "SavedData"
    
    let savePath = FileManager.documentDirectory.appendingPathComponent("SavedDataStorage")
    
    //Save Data to Documents Directory
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            people = try JSONDecoder().decode([Prospect].self, from: data)
            
        } catch {
            people = []
            print("Failed to decode \(error.localizedDescription)")
        }
    }
    
    // save data to UserDefaults
//    init() {
//
//        if let data = UserDefaults.standard.data(forKey: saveKey) {
//            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
//                people = decoded
//                print("In array is \(people.count)")
//                return
//            }
//        }
//        //not saved data
//        people = []
//        print ("There is \(people.count)")
//    }
    
    
    // here private mean that just our Prospects class can call save() method
    private func save() {
        
        //Saving Data using DocumentsDirectory
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to encode \(error.localizedDescription)")
        }
        
        //User Defaults way of data storing
//        if let encoded = try? JSONEncoder().encode(people) {
//            UserDefaults.standard.set(encoded, forKey: saveKey)
//        }
        print("Saved \(people.count)")
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
        print("Added \(prospect)")
    }
    
    //this method allow us to change property of Prospect instance and make the announcement to refresh our UI. In case of direct changing there will be stale UI
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func remove(_ person: Prospect) {
        if let index = people.firstIndex(of: person) {
            people.remove(at: index)
        }
        save()
    }
    
    func delete(at offsets: IndexSet){
        people.remove(atOffsets: offsets)
        save()
    }
    
    
    
}
