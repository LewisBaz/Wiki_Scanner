//
//  WikiType.swift
//  Wiki_Scanner
//
//  Created by Lewis on 09.10.2024.
//

enum WikiType: Int, CaseIterable {
    case events
    case deaths
    case births
    
    var string: String {
        switch self {
        case .events:
            return "Events"
        case .deaths:
            return "Deaths"
        case .births:
            return "Births"
        }
    }
}
