//
//  WikiEndpoint.swift
//  Wiki_Scanner
//
//  Created by Lewis on 09.10.2024.
//

enum WikiEndpoint {
    case events(_ request: WikiRequest)
    case deaths(_ request: WikiRequest)
    case births(_ request: WikiRequest)
    
    var urlString: String {
        switch self {
        case .events(let request):
            return "https://byabbe.se/on-this-day/\(request.month)/\(request.day)/events.json"
        case .deaths(let request):
            return "https://byabbe.se/on-this-day/\(request.month)/\(request.day)/deaths.json"
        case .births(let request):
            return "https://byabbe.se/on-this-day/\(request.month)/\(request.day)/births.json"
        }
    }
}
