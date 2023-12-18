//
//  CollectionViewDataSource.swift
//  OkxUIlib
//
//  Created by David Chang on 12/18/23.
//

import Foundation

class VideoViewDataSource : NSObject, UICollectionViewDataSource {
    
    var viewmodel : HomeViewViewModel
    init(viewmodel: HomeViewViewModel) {
        self.viewmodel = viewmodel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewmodel.numberOfItem() : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.cellReuseIdentifier, for: indexPath)
        if let videoCell = cell as? VideoCell {
            videoCell.setData(data: viewmodel.dataAtIndex(indexPath.row)!)
        }
        return cell
    }    
}

class CarouselDataSource : NSObject, UICollectionViewDataSource {
    var viewmodel : HomeViewViewModel
    init(viewmodel: HomeViewViewModel) {
        self.viewmodel = viewmodel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? viewmodel.numberOfItem() : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellReuseIdentifier, for: indexPath)
        if let carouselCell = cell as? CarouselCell {
            carouselCell.setData(aData: viewmodel.dataAtIndex(indexPath.row)!)
        }
        return cell
    }
}
