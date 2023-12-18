//
//  VideoCell.swift
//  OkxUIlib
//
//  Created by David Chang on 12/18/23.
//

import Foundation
import AVFoundation


class VideoCell : UICollectionViewCell {
    static let cellReuseIdentifier = "VideoCellReuseIdentifier"
 
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var dataItem : DataItem?
    
    func setData(data: DataItem) {
        dataItem = data
        self.backgroundColor = UIColor.white
        let url = URL(string:data.videoURL)
        guard url != nil else {
            return
        }
        player = AVPlayer(url:url!)
        playerLayer = AVPlayerLayer(player: player)

        layer.addSublayer(playerLayer!)
        
        playerLayer?.frame = contentView.bounds
        playerLayer?.videoGravity = .resizeAspect
        play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { [weak self] _ in
            self?.player?.seek(to: CMTime.zero)
            self?.player?.play()
        }
    }
    
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    override func prepareForReuse() {
        if (player?.currentItem != nil) {
            NotificationCenter.default.removeObserver(player!.currentItem!)
        }
        super.prepareForReuse()
        pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
}
