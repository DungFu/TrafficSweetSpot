//
//  PreferencesWindow.swift
//  TrafficSweetSpot
//
//  Created by Freddie Meyer on 7/19/16.
//  Copyright © 2016 Freddie Meyer. All rights reserved.
//

import Cocoa

protocol PreferencesWindowDelegate {
    func preferencesDidUpdate()
}

class PreferencesWindow: NSWindowController {
    @IBOutlet weak var apiKeyInput: NSTextField!
    @IBOutlet weak var originInput: NSTextField!
    @IBOutlet weak var destInput: NSTextField!
    @IBOutlet weak var cacheInput: NSPopUpButton!
    @IBOutlet weak var notificationsCheckbox: NSButton!
    @IBOutlet weak var notificationsTimeSlider: NSSlider!
    @IBOutlet weak var notificationsTimeLabel: NSTextField!
    @IBOutlet weak var travelTimeMenuBarCheckBox: NSButton!
    @IBOutlet weak var checkForUpdatesCheckBox: NSButton!
    @IBOutlet weak var startTimeDropdown: NSPopUpButton!
    @IBOutlet weak var endTimeDropdown: NSPopUpButton!
    
    var delegate: PreferencesWindowDelegate?

    override var windowNibName : NSNib.Name? {
        return NSNib.Name.init("PreferencesWindow")
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.center()
        self.window?.title = "Preferences"
        NSApp.activate(ignoringOtherApps: true)
        self.window?.makeKeyAndOrderFront(self)
        let defaults = UserDefaults.standard
        if let apiKeyVal = defaults.string(forKey: "apiKey") {
            apiKeyInput.stringValue = apiKeyVal
        }
        if let originVal = defaults.string(forKey: "origin") {
            originInput.stringValue = originVal
        }
        if let destVal = defaults.string(forKey: "dest") {
            destInput.stringValue = destVal
        }
        if let cacheVal = defaults.string(forKey: "cache") {
            cacheInput.stringValue = cacheVal
        }
        if let notificationsEnabledVal = defaults.string(forKey: "notificationsEnabled") {
            notificationsCheckbox.stringValue = notificationsEnabledVal
        }
        if let notificationsTimeVal = defaults.string(forKey: "notificationsTime") {
            notificationsTimeSlider.stringValue = notificationsTimeVal
        }
        if let travelTimeMenuBarVal = defaults.string(forKey: "travelTimeMenuBar") {
            travelTimeMenuBarCheckBox.stringValue = travelTimeMenuBarVal
        }
        if let checkForUpdatesVal = defaults.string(forKey: "checkForUpdates") {
            checkForUpdatesCheckBox.stringValue = checkForUpdatesVal
        }
        startTimeDropdown.removeAllItems()
        endTimeDropdown.removeAllItems()
        for index in 0...23 {
            var hour = String(index)
            if (index < 10) {
                hour = "0" + hour
            }
            startTimeDropdown.addItem(withTitle: hour + ":00")
            endTimeDropdown.addItem(withTitle: hour + ":00")
        }
        if let startTimeNotifVal = defaults.string(forKey: "startTimeNotif") {
            startTimeDropdown.selectItem(at: Int(startTimeNotifVal) ?? 17)
        } else {
            startTimeDropdown.selectItem(at: 17)
        }
        if let endTimeNotifVal = defaults.string(forKey: "endTimeNotif") {
            endTimeDropdown.selectItem(at: Int(endTimeNotifVal) ?? 20)
        } else {
            endTimeDropdown.selectItem(at: 20)
        }
        updateStartTimeDropdownItems()
        updateEndTimeDropdownItems()
        updateSliderLabel()
    }

    @IBAction func onSliderUpdate(_ sender: Any) {
        updateSliderLabel()
    }

    @IBAction func onStartTimeDropdownUpdate(_ sender: Any) {
        updateEndTimeDropdownItems()
    }

    @IBAction func onEndTimeDropdownUpdate(_ sender: Any) {
        updateStartTimeDropdownItems()
    }
    
    @IBAction func saveClicked(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.setValue(apiKeyInput.stringValue, forKey: "apiKey")
        defaults.setValue(originInput.stringValue, forKey: "origin")
        defaults.setValue(destInput.stringValue, forKey: "dest")
        defaults.setValue(cacheInput.stringValue, forKey: "cache")
        defaults.setValue(notificationsCheckbox.stringValue, forKey: "notificationsEnabled")
        defaults.setValue(notificationsTimeSlider.stringValue, forKey: "notificationsTime")
        defaults.setValue(travelTimeMenuBarCheckBox.stringValue, forKey: "travelTimeMenuBar")
        defaults.setValue(checkForUpdatesCheckBox.stringValue, forKey: "checkForUpdates")
        defaults.setValue(String(startTimeDropdown.indexOfSelectedItem), forKey: "startTimeNotif")
        defaults.setValue(String(endTimeDropdown.indexOfSelectedItem), forKey: "endTimeNotif")
        defaults.synchronize()
        delegate?.preferencesDidUpdate()
        self.window?.close()
    }
    
    func updateSliderLabel() {
        notificationsTimeSlider.integerValue = Int(notificationsTimeSlider.floatValue.rounded())
        let value = notificationsTimeSlider.integerValue
        var hours = String(value / 60)
        if (hours.count < 2) {
            hours = "0" + hours
        }
        var minutes = String(value % 60)
        if (minutes.count < 2) {
            minutes = "0" + minutes
        }
        notificationsTimeLabel.stringValue = hours + ":" + minutes
    }
    
    func updateStartTimeDropdownItems() {
        for item in startTimeDropdown.itemArray {
            item.isHidden = startTimeDropdown.index(of: item) >= endTimeDropdown.indexOfSelectedItem
        }
    }
    
    func updateEndTimeDropdownItems() {
        for item in endTimeDropdown.itemArray {
            item.isHidden = endTimeDropdown.index(of: item) <= startTimeDropdown.indexOfSelectedItem
        }
    }
}
