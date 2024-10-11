//
//  Wiki.swift
//  Wiki_Scanner
//
//  Created by Lewis on 09.10.2024.
//

enum Wiki {
    
    struct Events: Decodable {
        let date: String?
        let link: String?
        let events: [Event]?
        
        enum CodingKeys: String, CodingKey {
            case date
            case link = "wikipedia"
            case events
        }
    }
    
    struct Deaths: Decodable {
        let date: String?
        let link: String?
        let deaths: [Event]?
        
        enum CodingKeys: String, CodingKey {
            case date
            case link = "wikipedia"
            case deaths
        }
    }
    
    struct Births: Decodable {
        let date: String?
        let link: String?
        let births: [Event]?
        
        enum CodingKeys: String, CodingKey {
            case date
            case link = "wikipedia"
            case births
        }
    }
    
    struct WikiSubject {
        let date: String?
        let link: String?
        let subjects: [Event]?
    }
    
    struct Event: Decodable {
        let year: String?
        let description: String?
        let links: [WikiLink]?
        
        enum CodingKeys: String, CodingKey {
            case year, description
            case links = "wikipedia"
        }
    }
    
    struct WikiLink: Decodable {
        let title: String?
        let link: String?
        
        enum CodingKeys: String, CodingKey {
            case title
            case link = "wikipedia"
        }
    }
}
