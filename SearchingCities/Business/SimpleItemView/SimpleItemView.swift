//
//  SimpleItemView.swift
//  SearchingCities
//
//  Created by Yeşim Daşdemir on 13.05.2021.
//

import UIKit

final class SimpleItemView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    var viewModel: SimpleItemViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            initView(viewModel: viewModel)
        }
    }
    
    var contentViewModel: ContentViewModel? {
        didSet {
            guard let contentViewModel = contentViewModel else {
                return
            }
            
            contentView.layer.borderWidth = contentViewModel.borderWidth ?? 0
            contentView.layer.cornerRadius = contentViewModel.cornerRadius ?? 8.0
            contentView.layer.masksToBounds = true
            contentView.layer.borderColor = contentViewModel.borderColor
            
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: contentViewModel.leadingTrailingPadding ?? 0).isActive = true
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(contentViewModel.leadingTrailingPadding ?? 0)).isActive = true
            contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: contentViewModel.topBottomPadding ?? 0).isActive = true
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -(contentViewModel.topBottomPadding ?? 0)).isActive = true
            
            contentView.setNeedsLayout()
            contentView.layoutIfNeeded()
        }
    }
    
    private func initView(viewModel: SimpleItemViewModel) {
        if let title: String = viewModel.title {
            titleLabel.text = title
        }
        
        if let subTitle: String = viewModel.subTitle {
            subTitleLabel.text = subTitle
        }
    }
    
    // MARK: LoadNib
    
    private func loadNib() {
        let nibName = String(describing: type(of: self))
        Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(contentView)
    }
}
