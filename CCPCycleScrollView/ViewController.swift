//
//  ViewController.swift
//  CCPCycleScrollView
//
//  Created by 储诚鹏 on 2018/11/22.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var cycleViewBg: UIView!
    private let scrView = CycleScrollView.imageScroll()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setScrollView()
    }
    
    private func setScrollView() {
        cycleViewBg.addSubview(scrView)
        scrView.frame = cycleViewBg.bounds
//       / scrView.snp.makeConstraints { $0.top.bottom.left.right.equalTo(cycleViewBg) }
        let imgNames = ["img1", "img2", "img3"]
        scrView.scroll(contents: imgNames)
    }


}

