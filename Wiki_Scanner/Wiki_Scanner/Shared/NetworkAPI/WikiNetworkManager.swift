//
//  WikiNetworkManager.swift
//  Wiki_Scanner
//
//  Created by Lewis on 09.10.2024.
//

import RxSwift
import RxCocoa

final class WikiNetworkManager {
    
    func wikiRequest<D: Decodable>(_ endpoint: WikiEndpoint, _ responseOfType: D.Type) -> Observable<D> {
        let obs = Observable.just(endpoint.urlString)
            .map { str -> URL in
                return URL(string: str) ?? URL(string: "")!
            }
            .map { url -> URLRequest in
                return URLRequest(url: url)
            }
            .flatMap { request in
                return URLSession.shared.rx.response(request: request)
            }
            .map { _, data in
                try JSONDecoder().decode(responseOfType, from: data)
            }
            .observe(on: MainScheduler())
        return obs
    }
}
