//
//  WikiViewModel.swift
//  Wiki_Scanner
//
//  Created by Lewis on 09.10.2024.
//

import RxSwift

final class WikiViewModel {
    
    // MARK: - Managers
    
    private let disposeBag = DisposeBag()
    private let wikiNetworkManager = WikiNetworkManager()
    
    // MARK: - Private Properties
    
    private let wikiSubject = PublishSubject<Wiki.WikiSubject>()
    
    let stopSignal = PublishSubject<Void>()
    
    // MARK: - Public Properties
    
    var subject: Observable<Wiki.WikiSubject> {
        return wikiSubject.asObservable()
    }
    
    var choosenDay = PublishSubject<String>()
    var choosenMonth = PublishSubject<String>()
    var choosenWikiType = BehaviorSubject(value: WikiType.events)
    
    // MARK: - Public Methods
    
    // TODO: - Добавить кеширование
    
    func wikiRequest(_ type: WikiType, _ request: WikiRequest) {
        choosenWikiType
            .debug()
            .flatMap { [unowned self] type -> Observable<Wiki.WikiSubject> in
                switch type {
                case .events:
                    return self.makeEventsRequest(request)
                case .deaths:
                    return self.makeDeathsRequest(request)
                case .births:
                    return self.makeBirthsRequest(request)
                }
            }
            .subscribe(onNext: { [weak self] subject in
                self?.wikiSubject.onNext(subject)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Private Methods

private extension WikiViewModel {
    
    func makeEventsRequest(_ request: WikiRequest) -> Observable<Wiki.WikiSubject> {
        wikiNetworkManager
            .wikiRequest(.events(request), Wiki.Events.self)
            .take(until: stopSignal)
            .catch { error in
                print(error)
                return Observable.empty()
            }
            .map { events -> Wiki.WikiSubject in
//                print("Received events:", events)
                let subject = Wiki.WikiSubject.init(date: events.date, link: events.link, subjects: events.events)
                self.wikiSubject.onNext(subject)
                return subject
            }
    }
    
    func makeDeathsRequest(_ request: WikiRequest) -> Observable<Wiki.WikiSubject> {
        wikiNetworkManager
            .wikiRequest(.deaths(request), Wiki.Deaths.self)
            .take(until: stopSignal)
            .catch { error in
                print(error)
                return Observable.empty()
            }
            .map { events -> Wiki.WikiSubject in
//                print("Received deaths:", events)
                let subject = Wiki.WikiSubject.init(date: events.date, link: events.link, subjects: events.deaths)
                self.wikiSubject.onNext(subject)
                return subject
            }
    }
    
    func makeBirthsRequest(_ request: WikiRequest) -> Observable<Wiki.WikiSubject> {
        wikiNetworkManager
            .wikiRequest(.births(request), Wiki.Births.self)
            .take(until: stopSignal)
            .catch { error in
                print(error)
                return Observable.empty()
            }
            .map { events -> Wiki.WikiSubject in
//                print("Received births:", events)
                let subject = Wiki.WikiSubject.init(date: events.date, link: events.link, subjects: events.births)
                self.wikiSubject.onNext(subject)
                return subject
            }
    }
}
