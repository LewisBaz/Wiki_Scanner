//
//  WikiViewController.swift
//  Wiki_Scanner
//
//  Created by Lewis on 09.10.2024.
//

import UIKit
import RxSwift

final class WikiViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let segmentedControl = UISegmentedControl()
    private let fieldsStack = UIStackView()
    // TODO: - Поменять на колеса
    private let dayTextField = UITextField()
    private let monthTextField = UITextField()
    // TODO: - убрать кнопку и следить за изменением дат колес
    private let findButton = UIButton()
    private let dateLabel = UILabel()
    private let nothingLabel = UILabel()
    private let tableView = UITableView()
    
    // MARK: - Private Properties
    
    private let disposeBag = DisposeBag()
    private let viewModel = WikiViewModel()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

// MARK: - Private Methods

private extension WikiViewController {
    
    func setup() {
        view.backgroundColor = .systemBackground
        addViews()
        setupConstraints()
        setupSegmentedControl()
        setupStack()
        setupFields()
        setupButton()
        setupLabels()
        setupTableView()
        bindDateLabel()
        bindNothingLabel()
        bindTableView()
        bindTextFields()
    }
    
    func addViews() {
        view.addSubview(segmentedControl)
        view.addSubview(fieldsStack)
        view.addSubview(findButton)
        view.addSubview(dateLabel)
        view.addSubview(tableView)
        view.addSubview(nothingLabel)
        fieldsStack.addArrangedSubview(dayTextField)
        fieldsStack.addArrangedSubview(monthTextField)
    }
    
    func setupConstraints() {
        segmentedControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.centerX.equalToSuperview()
        }
        
        fieldsStack.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(50)
            $0.centerX.equalToSuperview()
        }
        
        findButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(30)
            $0.top.equalTo(fieldsStack.snp.bottom).offset(50)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(findButton.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        nothingLabel.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(findButton.snp.bottom).offset(200)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        dayTextField.snp.makeConstraints { $0.width.equalTo(100) }
        monthTextField.snp.makeConstraints { $0.width.equalTo(100) }
    }
    
    func setupSegmentedControl() {
        for (index, type) in WikiType.allCases.enumerated() {
            segmentedControl.insertSegment(withTitle: type.string, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { index in
                self.viewModel.choosenWikiType.onNext(WikiType.allCases[index])
            })
            .disposed(by: disposeBag)
    }
    
    func setupStack() {
        fieldsStack.spacing = 50
    }
    
    func setupFields() {
        dayTextField.placeholder = "Day"
        dayTextField.borderStyle = .roundedRect
        dayTextField.keyboardType = .numberPad
        
        monthTextField.placeholder = "Month"
        monthTextField.borderStyle = .roundedRect
        monthTextField.keyboardType = .numberPad
    }
    
    func setupButton() {
        findButton.setTitle("Find!", for: .normal)
        findButton.configuration = .filled()
        findButton.tintColor = .systemBlue
        findButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(viewModel.choosenDay, viewModel.choosenMonth))
            .map { day, month -> (Int, Int)? in
                guard let dayInt = Int(day), let monthInt = Int(month) else { return nil }
                return (dayInt, monthInt)
            }
            .compactMap { $0 }
            .subscribe(onNext: { day, month in
                self.makeRequest(.init(day: day, month: month))
            })
            .disposed(by: disposeBag)
    }
    
    func setupLabels() {
        dateLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        nothingLabel.textAlignment = .center
        nothingLabel.text = "Nothing yet..."
    }
    
    func bindDateLabel() {
        viewModel.subject
            .flatMap { subject in
                return Observable.just(subject.date)
            }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func bindNothingLabel() {
        viewModel.subject
            .map {
                return !($0.subjects?.isEmpty ?? false)
            }
            .bind(to: nothingLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func setupTableView() {
        tableView.register(WikiLinkCell.self, forCellReuseIdentifier: "WikiLinkCell")
    }
    
    func bindTableView() {
        viewModel.subject
            .flatMap { subject in
                return Observable.just(subject.subjects ?? [])
            }
            .bind(to: tableView.rx.items(cellIdentifier: WikiLinkCell.reuseIdentifier, cellType: WikiLinkCell.self)) { _, model, cell in
                cell.configure(.init(year: model.year ?? "?", description: model.description ?? "?"))
            }
            .disposed(by: disposeBag)
    }
    
    func bindTextFields() {
        dayTextField.rx.text.orEmpty
            .bind(to: viewModel.choosenDay)
            .disposed(by: disposeBag)
        
        monthTextField.rx.text.orEmpty
            .bind(to: viewModel.choosenMonth)
            .disposed(by: disposeBag)
    }
    
    func makeRequest(_ request: WikiRequest) {
        viewModel.wikiRequest(.events, request)
    }
}
