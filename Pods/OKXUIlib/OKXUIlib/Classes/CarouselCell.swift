//
//  CarouselCell.swift
//  OKXUIlib
//
//  Created by David Chang on 12/18/23.
//

import Foundation
import Alamofire
import AlamofireImage

class CarouselCell : UICollectionViewCell {
    
    var data : DataItem?
    static let cellReuseIdentifier = "CarouselCellReuseIdentifier"
    
    var imageView : UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = self.bounds
        imageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
        
    func setData(aData: DataItem) {
        data = aData
        
        AF.request(aData.imageURL).responseImage { [weak self](response) in
            switch response.result {
            case .success(let image):
                let strongSelf = self
                guard strongSelf != nil else {
                    return
                }
                if (strongSelf?.data?.imageURL == aData.imageURL) {
                    strongSelf?.imageView.image = image
                }
            case .failure(let error):
                print("Error downloading image: \(error)")
            }
        }
        
        
    }
}
