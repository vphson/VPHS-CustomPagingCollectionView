//
//  File.swift
//  VPHS-CustomPagingCollectionView
//
//  Created by Hoang Son Vo Phuoc on 6/4/24.
//

import UIKit
import SnapKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initView() {
        self.backgroundColor = .systemBlue
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
        }
    }
    
    func setupViewModel(_ title: String) {
        titleLabel.text = title
    }
}

extension CustomCollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
}
