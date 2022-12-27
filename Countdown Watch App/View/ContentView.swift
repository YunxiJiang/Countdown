//
//  ContentView.swift
//  Countdown Watch App
//
//  Created by Yunxi Jiang on 20/12/2022.
//

import SwiftUI

struct ContentView: View {

    
    var body: some View {
        TabView{
            NavigationStack{
                CountdownView()
            }
            
            NavigationStack{
                ChartView()
            }
        }
        .tabViewStyle(.page)
    }
    

    

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
