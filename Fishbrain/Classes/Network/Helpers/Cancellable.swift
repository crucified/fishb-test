//
//  Cancellable.swift
//  Fishbrain
//
//  Created by Denis Kharitonov on 10.07.2018.
//

import Foundation


protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable { }
