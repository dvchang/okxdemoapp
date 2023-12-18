//
//  HomeViewController.swift
//  OkxUIlib
//
//  Created by David Chang on 12/18/23.
//

import Foundation

public class HomeViewController : UIViewController {
    
    var videosView : UICollectionView!
    var videosViewDataSource : VideoViewDataSource?
    
    var carouselView : UICollectionView!
    var carouselViewDataSource : CarouselDataSource?
    
    var viewModel : HomeViewViewModel = HomeViewViewModel()
    
    var currentFocusedCarouselItem = 0
        
    let TopMargin = 60.0
    let VerticalPadding = 10.0
    let CarouselViewHeight = 100.0
    
    var carouselCellSize = CGSize(width: 0, height: 0)
    var videoCellSize = CGSize(width: 0, height:0)
    let EnLargeScale = 1.3
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoView()
        setupCarouseView()
        view.backgroundColor = UIColor.white
    }
    
    public func showData(rawData: [(String, String)]) {
        viewModel.parse(rawData: rawData)
        
        videosView.reloadData()
        carouselView.reloadData()
    }
    
    func setupCarouseView() {
        let layout = UICollectionViewFlowLayout()
        let width = floor (view.bounds.width / 3)
        let height = CarouselViewHeight
        carouselCellSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 10
        let y = videosView.frame.origin.y + videosView.frame.size.height + VerticalPadding
        carouselView = UICollectionView(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height * 1.5), collectionViewLayout: layout)
        carouselView.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        carouselView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.cellReuseIdentifier)
        carouselViewDataSource = CarouselDataSource(viewmodel: viewModel)
        carouselView.dataSource = carouselViewDataSource
        carouselView.showsHorizontalScrollIndicator = false
        let inset = width * 0.85
        carouselView.contentOffset = CGPoint(x: inset , y: 0)
        carouselView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        carouselView.delegate = self
        carouselView.clipsToBounds = false
        view.addSubview(carouselView)
    }
    
    func setupVideoView() {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.width
        let height = view.bounds.width
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        videoCellSize = layout.itemSize
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        videosView = UICollectionView(frame: CGRect(x: 0, y: TopMargin, width: width, height: height), collectionViewLayout: layout)
        videosView.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
        videosView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.cellReuseIdentifier)
        
        videosViewDataSource = VideoViewDataSource(viewmodel: viewModel)
        videosView.dataSource = videosViewDataSource
        videosView.showsHorizontalScrollIndicator = false
        videosView.delegate = self
        view.addSubview(videosView)
    }
    
    func updateCraouselIndexWithScrolling(index: Int) {
        if (index != currentFocusedCarouselItem) {
            carouselView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
            updateCurrentFocusedCarouselIndex(index: index)
        }
    }
    
    func updateCurrentFocusedCarouselIndex(index: Int) {
        if (index != currentFocusedCarouselItem) {
            currentFocusedCarouselItem = index
            carouselView.performBatchUpdates(nil, completion: nil)
        }
    }
    
    func updateVideoViewIndex(index: Int) {
        if (videosView.indexPathsForVisibleItems.first?.row != index) {
            videosView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
        }
    }
    
}

extension HomeViewController : UICollectionViewDelegate {
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (scrollView === videosView) {
            if let collectionView = scrollView as? UICollectionView {
                targetContentOffset.pointee = collectionView.contentOffset
                var indexes = collectionView.indexPathsForVisibleItems
                indexes.sort()
                var index = indexes.first!
                let cell = collectionView.cellForItem(at: index)!
                let position = collectionView.contentOffset.x - cell.frame.origin.x
                if position > cell.frame.size.width/2{
                    index.row = index.row+1
                }
                collectionView.scrollToItem(at: index, at: .left, animated: true)
                updateCraouselIndexWithScrolling(index: index.row)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView === carouselView) {
            carselViewDidEndScrolling()
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (scrollView === carouselView && !decelerate) {
            carselViewDidEndScrolling()
        }
    }
    
    func carselViewDidEndScrolling() {
        let visbleIndexes = carouselView.indexPathsForVisibleItems
        var minDiff = 1000000.0
        var index = 0
        
        for i in visbleIndexes {
            let cell = carouselView.cellForItem(at: i)
            let diff = abs(cell!.center.x - carouselView.contentOffset.x - carouselView.bounds.size.width/2)
            if (diff < minDiff) {
                minDiff = diff
                index = i.row
            }
        }
        updateCurrentFocusedCarouselIndex(index: index)
        updateVideoViewIndex(index: index)
    }
}

extension HomeViewController : UICollectionViewDelegateFlowLayout {
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (collectionView === carouselView) {
            if (indexPath.row == currentFocusedCarouselItem) {
                return CGSize(width: carouselCellSize.width * EnLargeScale, height: carouselCellSize.height * EnLargeScale)
            } else {
                return carouselCellSize
            }
        } else {
            return videoCellSize
        }
    }
}
