//
//  AppDelegate.swift
//  Notch Simulator
//
//  Created by Jinyu Meng on 2021/10/19.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let screens = NSScreen.screens
    var windows = [NotchWindow]()
    var windowControllers = [NSWindowController]()
    let notchViewController = NotchViewController(nibName: "NotchViewController", bundle: nil)
    
    let myAppsWindow = NSWindow()
    let myAppsWindowController = NSWindowController()
    let myAppsViewController = MyAppsViewController(nibName: "MyAppsViewController", bundle: nil)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupWindow()
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetWindow), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        
        if !UserDefaults.standard.bool(forKey: "viewMyApps") {
            setupMyAppWindow()
            UserDefaults.standard.set(true, forKey: "viewMyApps")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    
    func setupWindow() {
        if screens.count == 0 {
            NSApplication.shared.terminate(self)
        }
        
        let menubarHeight = NSApplication.shared.mainMenu!.menuBarHeight
        
        for i in 0..<screens.count {
            let notchWindow = NotchWindow()
            notchWindow.targetScreen = screens[i]
            notchWindow.styleMask = .borderless
            notchWindow.backingType = .buffered
            notchWindow.backgroundColor = .clear
            notchWindow.hasShadow = false
            notchWindow.level = .screenSaver
            notchWindow.contentViewController = NotchViewController(nibName: "NotchViewController", bundle: nil)
            
            let screenFrame = screens[i].frame
            notchWindow.setFrame(NSRect(x: screenFrame.origin.x, y: screenFrame.origin.y + screenFrame.size.height - menubarHeight, width: screenFrame.size.width, height: menubarHeight), display: true)
            
            let notchWindowController = NSWindowController()
            notchWindowController.contentViewController = notchWindow.contentViewController
            notchWindowController.window = notchWindow
            notchWindowController.showWindow(self)
            
            windows.append(notchWindow)
            windowControllers.append(notchWindowController)
        }
    }
    
    @objc func resetWindow() {
        for item in windows {
            item.close()
        }
        
        windows.removeAll()
        windowControllers.removeAll()
        
        setupWindow()
    }

    
    func setupMyAppWindow() {
        myAppsWindow.styleMask = [.titled, .closable]
        myAppsWindow.backingType = .buffered
        myAppsWindow.title = "MyApps"
        myAppsWindow.contentViewController = myAppsViewController
        myAppsWindowController.contentViewController = myAppsWindow.contentViewController
        myAppsWindowController.window = myAppsWindow
        myAppsWindowController.showWindow(self)
        
        myAppsWindow.center()
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}

