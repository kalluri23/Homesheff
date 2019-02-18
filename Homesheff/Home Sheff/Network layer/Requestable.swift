//
//  Requestable.swift
//  Homesheff
//
//  Created by Anurag Yadev on 10/13/18.
//  Copyright © 2018 Dimitrios Papageorgiou. All rights reserved.
//

import Foundation

enum HttpType:String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

/*
 All request model should comfirm this protocol
 */
protocol Requestable {
  var basePath:String? { get }
  var apiPath:String {get}
  var httpType:HttpType {get}
  var pathType : ServicePath {get set}
}


// MARK: - Protocol is extended with common functionality methods like basePath. In addition to that, protocol extension contains some generic methods like requestURL and httpHeaders etc.
extension Requestable {
  
  var basePath:String? {
    return ConfigEndPoints.shared.appMode.baseEndPoint()
  }
  
  func requestURL()->URL? {
    if let path = self.basePath {
      let encodedPath = self.apiPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let fullPath = path+encodedPath!
      return URL(string: fullPath)
    }
    
    return nil
  }
  
  func httpHeaders()->[String:String]? {
    
    var dict:[String:String] = [:]
    dict["Content-Type"] = "application/json"
    
    return dict
  }
  
}
