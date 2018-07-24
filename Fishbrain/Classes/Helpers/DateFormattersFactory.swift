//
//  datetime.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 14.07.2018.
//


import Foundation


/// Key-Value storage of formatters, 'cause creating a formatter is a heavy operation.
/// Key - date format.
/// If formatter for key does not exist, a new formatter for provided key is created
class DateFormatterFactory {
    static var shared = DateFormatterFactory()
    private var formatters = [String: DateFormatter]()

    func formatter(for key: String) -> DateFormatter {
        if let formatter = formatters[key] {
            return formatter
        }

        let newFormatter = DateFormatter()
        newFormatter.dateFormat = key

        formatters[key] = newFormatter
        return newFormatter

    }
}
