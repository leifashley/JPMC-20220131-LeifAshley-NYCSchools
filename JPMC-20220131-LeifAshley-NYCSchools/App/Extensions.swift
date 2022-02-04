//
//  Extension.swift
//  CommandLineRunner
//
//  Created by Leif Ashley on 2/1/22.
//

import Foundation
import SwiftUI

extension View {
    // @inlinable public func opacity(_ opacity: Double) -> some View
    func invisible(_ isInvisible: Bool) -> some View {
        return self.opacity(isInvisible ? 0 : 1)
    }
    
    // If conditional to apply checks to views, but this actively hides and removes views, sometimes not what is best.
    // and causes the views to snap around in unpredictable ways
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
         if conditional {
             return AnyView(content(self))
         } else {
             return AnyView(self)
         }
     }
}

extension Bundle {
    
    /// Loads a static resource from the main bundle and inflates the JSON to the given type
    /// - Returns: Type object or nil if no data was found
    func loadJson<T>(type: T.Type, resourceName: String) -> T? where T: Decodable {
        var result: T? = nil
        
        if let path = Bundle.main.path(forResource: resourceName, ofType: "json"), let data = FileManager.default.contents(atPath: path) {
            log.verbose("Path: \(path)")
            
            let decoder = JSONDecoder()
            
            do {
                result = try decoder.decode(T.self, from: data)
            } catch {
                log.error("Static JSON decode error for '\(resourceName)'", error: error)
            }
        } else {
            log.error("FATAL: cannot find json resource '\(resourceName)'", error: AppError.unknownError)
        }
        
        return result
    }
    
    
    /// Loads a static plist XML file and inflates the XML to the given type
    /// - Returns: Type object or nil if no data was found
    static func decodeFromPList<T>(_ type: T.Type, forResource: String) -> T? where T: Decodable {
        let logTitle = "Bundle.decodeFromPList"
        var t: T? = nil
        
        if let path = Bundle.main.path(forResource: forResource, ofType: "plist") {
            log.verbose("\(logTitle) Path: \(path)")
            
            if let data = FileManager.default.contents(atPath: path) {
                do {
                    let decoded = try PropertyListDecoder().decode(type, from: data)
                    t = decoded
                } catch {
                    log.error("\(logTitle)", error: error)
                }
            }
            
        }
        
        return t
    }
}


extension URLComponents {
    
    /// Assists in adding name/value pairs to a URLComponent, for cleaner code
    mutating func addQueryString(name: String, value: String) {
        if queryItems == nil {
            queryItems = [URLQueryItem]()
        }
        
        queryItems?.append(URLQueryItem(name: name, value: value))
    }
}


extension Optional where Wrapped == String {
    
    // quick unwrap for string options that might or might not be nil
    var valueOrDefault: String {
        if let value = self {
            return value
        } else {
            return "-"
        }
    }
}

extension Thread {
    
    
    /// Prints extended thread details for thread monitoring
    public var extendedDetails: String {
        let t: Thread = self
        
        var result = [String]()
        
        if t.isMainThread { result.append("isMainThread") }
        
        if t.isCancelled { result.append("isCanceled") }
        if t.isExecuting { result.append("isExecuting") }
        if t.isFinished { result.append("isFinished") }
                
        switch t.qualityOfService {
        case .background:
            result.append("QoS background")
        case .userInitiated:
            result.append("QoS userInitiated")
        case .userInteractive:
            result.append("QoS userInteractive")
        case .utility:
            result.append("QoS utility")
        default:
            result.append("QoS default")
        }
        
        result.append("threadPriority=\(t.threadPriority)")
        let title = "Thread"
        return "\(title): \(result.joined(separator: ", ")) -- \(t)"
    }
}
