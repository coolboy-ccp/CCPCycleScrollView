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
    @IBOutlet weak var textViewBg: UIView!
    private let imgScr = CycleScrollView.image
    private let textScr = CycleScrollView.text
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImgScrollView()
        setTextScrollView()
    }
    
    private func setImgScrollView() {
        cycleViewBg.addSubview(imgScr)
        imgScr.frame = cycleViewBg.bounds
        let imgNames = ["img1", "img2", "img3"]
        imgScr.scroll(contents: imgNames)
    }
    
    private func setTextScrollView() {
        textViewBg.addSubview(textScr)
        textScr.frame = textViewBg.bounds
        let texts = ["text-------01", "text-------02", "text-------03"]
        textScr.scroll(contents: texts)
    }


}

