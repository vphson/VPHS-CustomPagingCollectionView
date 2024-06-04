//
//  ViewController.swift
//  VPHS-CustomPagingCollectionView
//
//  Created by Hoang Son Vo Phuoc on 6/4/24.
//

import UIKit

final class ViewController: UIViewController {
    
    private var currentItem = 0
    
    private var items = ["Item 1 ", "Item 2 ", "Item 3 ", "Item 4 ", "Item 5 "]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        Constants.itemWidth =  UIScreen.main.bounds.width - Constants.collectionMargin * 2.0
        
        layout.sectionInset = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: 0,
                                           right: 0)
        layout.itemSize = CGSize(width: Constants.itemWidth,
                                 height: Constants.itemHeight)
        layout.headerReferenceSize = CGSize(width: Constants.collectionMargin,
                                            height: 0)
        layout.footerReferenceSize = CGSize(width: Constants.collectionMargin,
                                            height: 0)
        
        layout.minimumLineSpacing = Constants.itemSpacing
        layout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self,
                                forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.decelerationRate = .fast
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = items.count
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.pageIndicatorTintColor = .lightGray
        return pageControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
            make.height.equalTo(350)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(Constants.itemWidth + Constants.itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView.contentSize.width  )
        var newPage = Float(self.pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    }

}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        cell.setupViewModel(items[indexPath.row])
        return cell
    }
    
}

private extension ViewController {
    
    struct Constants {
        static let collectionMargin: CGFloat = 16
        static let itemSpacing: CGFloat = 10
        static let itemHeight: CGFloat = 322
        static var itemWidth: CGFloat = 0
    }
}
