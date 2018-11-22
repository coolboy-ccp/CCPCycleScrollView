//
//  CycleScrollView.swift
//  CCPCycleScrollView
//
//  Created by 储诚鹏 on 2018/11/22.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

import UIKit
import SnapKit

@objc protocol CycleAvailable {
    @objc func setContent(_ content: Any, _ defaultContent : String?)
}

protocol CycleDataAvailable {}
extension String: CycleDataAvailable {}
extension URL: CycleDataAvailable {}
extension UIImage: CycleDataAvailable {}

extension UICollectionViewCell: CycleAvailable {
    func setContent(_ content: Any, _ defaultContent : String?) {}
}

final class CycleScrollView<T: UICollectionViewCell>: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var timer: Timer?
    private var contentsArray: Array<CycleDataAvailable>? {
        didSet {
            self.setup()
        }
    }
    private var defaultContents: Array<String?>?
    private let cellReuseId = "cycleReuserId"
    private let minSections = 3
    
    static func imageScroll() -> CycleScrollView {
        let cs = CycleScrollView()
        cs.cellClass = ImagesCell.self as! T.Type
        return cs;
    }
    
    var currentP: Int = 1 {
        didSet {
            numsLabel.text = "\(currentP) / \(contentsArray!.count)"
        }
    }
    lazy var cellClass: T.Type = UICollectionViewCell.self as! T.Type
    private let numsLabel = UILabel()
    
    func scroll(contents: Array<CycleDataAvailable>, defaultContents: Array<String?>? = nil) {
        self.defaultContents = defaultContents
        self.contentsArray = contents
    }

    override func removeFromSuperview() {
        super.removeFromSuperview()
        timer?.invalidate()
        timer = nil
    }
    
    override func didMoveToSuperview() {
        guard let sp = self.superview else { return }
        sp.addSubview(numsLabel)
        numsLabel.textColor = .darkGray
        numsLabel.font = UIFont.systemFont(ofSize: 14)
        numsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(-40.0)
            make.left.right.equalTo(15.0)
            make.height.equalTo(21)
        }
    }
    
    private func setup() {
        if let _ = contentsArray {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: frame.width, height: frame.height)
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
            collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
            collectionView.isPagingEnabled = true
            collectionView.register(cellClass.self, forCellWithReuseIdentifier: cellReuseId)
            collectionView.delegate = self
            collectionView.dataSource = self
            addSubview(collectionView)
            collectionView.scrollToItem(at: IndexPath(item: 0, section: minSections / 2), at: .left, animated: false)
            collectionView.isScrollEnabled = contentsArray!.count > 1
            if contentsArray!.count > 1 {
                addTimer()
            }
            
        }
    }
    @objc private func nextContent() {
        let currentIdP = collectionView.indexPathsForVisibleItems.last!
        let middleIdP = IndexPath.init(item: currentIdP.item, section: 1)
        collectionView.scrollToItem(at: middleIdP, at: .left, animated: false)
        var nextItem = middleIdP.item + 1
        var nextSection = middleIdP.section
        if nextItem == contentsArray!.count {
            nextItem = 0
            nextSection = nextSection + 1
        }
        collectionView.scrollToItem(at: IndexPath.init(item: nextItem, section: nextSection), at: .left, animated: true)
    }
    
    private func addTimer() {
        timer = Timer.init(timeInterval: 3, target: self, selector: #selector(nextContent), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    private func numberOfSections(in collectionView: UICollectionView) -> Int {
        return minSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentsArray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseId, for: indexPath)
        var dc: String? = nil;
        if let dcs = defaultContents {
            dc = dcs[indexPath.item]
        }
        cell.setContent(contentsArray![indexPath.item], dc)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int((scrollView.contentOffset.x + (frame.width) * 0.5) / (frame.width))
        let currentPage = page % contentsArray!.count
        currentP = currentPage + 1
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer?.invalidate()
        timer = nil
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}