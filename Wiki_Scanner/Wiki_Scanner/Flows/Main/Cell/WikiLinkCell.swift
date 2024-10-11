//
//  WikiLinkCell.swift
//  Wiki_Scanner
//
//  Created by Lewis on 09.10.2024.
//

import UIKit

final class WikiLinkCell: UITableViewCell {
    
    static let reuseIdentifier = "WikiLinkCell"
    
    struct ViewModel {
        let year: String
        let description: String
    }
    
    // MARK: - UI Elements
    
    private let yearLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        yearLabel.text = nil
        descriptionLabel.text = nil
    }
    
    // MARK: - Public Methods

    func configure(_ viewModel: ViewModel) {
        yearLabel.text = viewModel.year
        descriptionLabel.text = viewModel.description
    }
}

// MARK: - Private Methods

private extension WikiLinkCell {
    
    func setupView() {
        separatorInset = .zero
        addViews()
        setupConstraints()
        setupLabels()
    }
    
    func addViews() {
        contentView.addSubview(yearLabel)
        contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        yearLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalToSuperview().offset(14)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(yearLabel.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(14)
        }
    }
    
    func setupLabels() {
        yearLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        descriptionLabel.numberOfLines = 0
    }
}
