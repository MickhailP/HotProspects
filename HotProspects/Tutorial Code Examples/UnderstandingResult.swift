//
//  UnderstandingResult.swift
//  HotProspects
//
//  Created by Миша Перевозчиков on 26.02.2022.
//

import SwiftUI

struct UnderstandingResult: View {
    
    @State private var output = ""
    
    var body: some View {
        Text(output)
            .task {
                await fetchReadings()
            }
    }
    
    func fetchReadings() async{
        
        let fetchResults = Task { () -> String in
            let url = URL(string: "https://hws.dev/readings.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let readings = try JSONDecoder().decode([Double].self, from: data)
            return "Found \(readings.count) readings"
        }
        
        let result = await fetchResults.result
        
        // we can go this way OR
//        do {
//            output = try result.get()
//        } catch {
//            print(error.localizedDescription)
//        }
        
        //use switch
        switch result {
            case .success(let str):
                output = str
            
            case .failure(let error):
                output = error.localizedDescription
            
        }
    }
}

struct UnderstandingResult_Previews: PreviewProvider {
    static var previews: some View {
        UnderstandingResult()
    }
}
