//
//  Config.swift
//  Yuda
//
//  Created by 신유수 on 2/28/25.
//
import Foundation

struct Config {
    static var baseURL: String {
        #if DEBUG
        return "http://localhost:3000"
        #else
        return "https://yourdiary.site"
        #endif
    }
}
