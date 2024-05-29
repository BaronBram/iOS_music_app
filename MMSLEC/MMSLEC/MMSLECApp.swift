//
//  MMSLECApp.swift
//  MMSLEC
//
//  Created by Baron Bram on 02/12/23.
//

import SwiftUI
import Firebase


@main
struct MMSLECApp: App {
  

    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                
        }
    }
}
