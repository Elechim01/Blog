//
//  BlogApp.swift
//  Shared
//
//  Created by Michele Manniello on 22/08/21.
//

import SwiftUI
import Firebase

@main
struct BlogApp: App {
//    Initalizing Firebase..
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
