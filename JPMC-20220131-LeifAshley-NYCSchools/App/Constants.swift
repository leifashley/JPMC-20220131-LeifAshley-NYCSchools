//
//  Constants.swift
//  CommandLineRunner
//
//  Created by Leif Ashley on 2/1/22.
//

import Foundation


/// General error when the cause is not known but an error enum is required
enum AppError: Error {
    case unknownError
}

/// Standard logger, should be used instead of print statements
/// Normally in production, a debug and production config would switch this to bump up the log levels and avoid excessive string building and printing
let log = AppLogger(adapter: SwiftyBeaverLogAdapter())

