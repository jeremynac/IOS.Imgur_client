//
//  EpictureApp.swift
//  Epicture
//
//  Created by Anthony Bellon on 12/10/2020.
//

import SwiftUI
import Foundation

@main
struct EpictureApp: App {
    @StateObject var globalvars = GlobalVars()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(globalvars)
        }
    }
}
