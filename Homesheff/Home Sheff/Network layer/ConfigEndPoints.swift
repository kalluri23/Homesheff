//
//  ConfigEndPoints.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

/*
 This structure has member function to set the current build scheme. Current build scheme selected in XCode will be set into project info.plist key named as APP_ENV. This key is can also mentione under Build Setting
 where each schemes names could be mentione. All these name must be equal to the names as mentioned under the Enum of AppEnvMode.
 
 */
struct ConfigEndPoints {
  
  internal enum AppEnvMode:String {
    case Debug = "Debug"
    case Dev = "Development"
    case Prod = "Production"
    
    /*
     Set your project scheme base urls
     */
    func baseEndPoint()->String? {
      
      switch self {
      case .Debug, .Dev:
        return "https://api.dev.homesheff.com/v1/"
      case .Prod:
        return "Here we can add our production URL"
      }
    }
  }
  
  private var mode: AppEnvMode?
  static var shared = ConfigEndPoints()
  
  var appMode:AppEnvMode {
    get {
      return mode!
    }
  }
  
  /* This method need to be called when app launches. Ideal place to call this method at the very beginining of AppDelegate delegate method didFinishLaunching */
  mutating func initialize() {
    self.mode = .Debug
    
    /* Value is captured from info.plist. Value in info.plist will come from User-Defined Variables APP_ENV */
    if let modeString = Bundle.main.infoDictionary?["APP_ENV"] as? String,
      let modeType = AppEnvMode(rawValue: modeString) {
      self.mode = modeType
    }
  }
}
