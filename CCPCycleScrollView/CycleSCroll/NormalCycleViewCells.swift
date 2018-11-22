//
//  NormalCycleViewCells.swift
//  CCPCycleScrollView
//
//  Created by 储诚鹏 on 2018/11/22.
//  Copyright © 2018 储诚鹏. All rights reserved.
//

import UIKit
import Kingfisher

 final class ImagesCell: UICollectionViewCell {
    private let imgV = UIImageView()
    private var defaultImgName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgV)
        imgV.contentMode = .scaleAspectFit
        contentView.backgroundColor = UIColor.white
        imgV.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setContent(_ content: Any, _ defaultContent : String?) {
        if let url = content as? URL {
            urlContent(url, defaultContent)
        }
        else if let str = content as? String {
            stringContent(str, defaultContent)
        }
        else if let img = content as? UIImage {
            imageContent(img)
        }
    }
    
    private func urlContent(_ content: URL, _ defaultContent : String?) {
        var defaultImage: UIImage?
        if let name = defaultContent {
            defaultImage = UIImage(named: name)
        }
        imgV.kf.setImage(with: content, placeholder: defaultImage)
    }
    
    private func stringContent(_ content: String, _ defaultContent: String?) {
        
        if let img = UIImage(named: content) {
            imageContent(img)
        }
        else if let url = URL(string: content){
            urlContent(url, defaultContent)
        }
    }
    
    private func imageContent(_ content: UIImage) {
        imgV.image = content
    }
    
}
