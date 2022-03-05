//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Миша Перевозчиков on 27.02.2022.
//

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    @EnvironmentObject var prospects: Prospects
    
    @State private var isShowingScanner = false
    @State private var sorter: SortType = .none
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case none, byName, lifo
    }
   
    let filter: FilterType
    
    
    var body: some View {
        NavigationView{
            List {
                ForEach(sortProspects) { prospect in
                    HStack {
                        if filter == .none {
                        Image(systemName: prospect.isContacted ? "person.crop.circle.badge.checkmark" : "person.crop.circle.badge.xmark" )
                            .renderingMode(.original)
                            .foregroundStyle(prospect.isContacted ? .green : .red)
                            .font(.largeTitle)
                        }
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.email)
                                .foregroundColor(.secondary)
                        }
                    }
                    .swipeActions(allowsFullSwipe: false){
                        Button(role: .destructive){
                            prospects.remove(prospect)
                            
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Marc Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                           
                            
                            Button {
                                //it is necessary because this way we can track our change inside of our Prospect instance and announce it to the view directly
                                //array marked @Published doesn't watch changes in particular items. It is watching changing in array in common
                                prospects.toggle(prospect)
                            } label: {
                                Label("Marc Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind me", systemImage: "bell")
                            }
                            .tint(.orange)
                            
                        }
                    }
                }
                .onDelete { offset in prospects.delete(at: offset)}
            }
            
            
            .navigationTitle(title)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    HStack{
                        Button {
                            isShowingScanner = true
                        } label: {
                            Label("Scan", systemImage: "qrcode.viewfinder")
                        }
                        .sheet(isPresented: $isShowingScanner) {
                            CodeScannerView(codeTypes: [.qr], simulatedData: "Michal Perevozchikov\nmich_p@inbox.ru", completion: handleScan)
                        }
                    }
                }
                
                ToolbarItem{
                    Menu{
                        Button{
                            self.sorter = .byName
                        } label : {
                            Label("By name", systemImage: "character")
                        }
                        Button{
                            sorter = .lifo
                        } label : {
                            Label("Last first", systemImage: "arrow.up")
                        }
                        Button{
                            sorter = .none
                        } label : {
                            Label("First first", systemImage: "arrow.down")
                        }
                        
                    }label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down.square")
                    }
                }
            }
        }
    }
    
    var title: String {
        switch filter {
            case .none:
                return "Everyone"
            case .contacted:
                return "Contacted people"
            case .uncontacted:
                return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
            case .none:
                return prospects.people
            case .contacted:
                return prospects.people.filter { $0.isContacted }
            case .uncontacted:
                return prospects.people.filter { !$0.isContacted }
        }
    }
    
    var sortProspects: [Prospect] {
        switch sorter {
            case .none:
                return filteredProspects
            case .byName:
                return filteredProspects.sorted(by: sortByName)
            case .lifo:
                return filteredProspects.reversed()
                
        }
    }
    
    func sortByName(_ lhs: Prospect, _ rhs: Prospect) -> Bool {
        lhs.name < rhs.name
    }
    
    func sortByRecent(_ people: [Prospect]) -> [Prospect] {
        people.reversed()
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
            case .success(let result):
                let details = result.string.components(separatedBy: "\n")
                
                let person = Prospect()
                person.name = details[0]
                person.email = details[1]
            
                // we use this:
                prospects.add(person)
                
                //instead
//                prospects.people.append(prospect)
//                prospects.save()
                
            case .failure(let error):
                print("Scanning failed. There is an Error: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        //get access to Notification centre
        let centre = UNUserNotificationCenter.current()
        
        //create a closure we will call when it needed
        let addRequest = {
            // create our notification that will show in future
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.email
            content.sound = UNNotificationSound.default
            
            //when it will be show
            var dateComponents = DateComponents()
            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            //testing
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            //put altogether in request
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            centre.add(request)
        }
        
        // make sure we only schedule notifications when allowed
        centre.getNotificationSettings{ settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                centre.requestAuthorization(options: [.alert, .sound, .badge] ){ success, error in
                    if success {
                        addRequest()
                    } else{
                        print("Notifications isn't allowed")
                    }

                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
