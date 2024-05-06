//
//  MyBLEKeyboardApp.swift
//  MyBLEKeyboard
//
//  Created by jason on 2024-05-03.
//

import SwiftUI

@main
struct MyBLEKeyboardApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
