//
//  AboutWindow.swift
//  TrafficSweetSpot
//
//  Created by Freddie Meyer on 7/19/16.
//  Copyright © 2016 Freddie Meyer. All rights reserved.
//

import Cocoa

class AboutWindow: NSWindowController {
    @IBOutlet weak var versionText: NSTextField!

    override var windowNibName : String! {
        return "AboutWindow"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.makeKeyAndOrderFront(nil)
        self.window?.title = "About TrafficSweetSpot"
        NSApp.activate(ignoringOtherApps: true)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionText.stringValue = "Version: "+version
        }
    }

    @IBAction func githubClick(_ sender: AnyObject) {
        NSWorkspace.shared().open(URL(string: "https://github.com/DungFu/TrafficSweetSpot")!)
        self.window?.close()
    }
}
