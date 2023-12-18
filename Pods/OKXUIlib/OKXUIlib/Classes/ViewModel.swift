//
//  DataSource.swift
//  OkxUIlib
//
//  Created by David Chang on 12/18/23.
//

import Foundation

struct DataItem {
    let id: Int
    let imageURL: String
    let videoURL: String
}

class HomeViewViewModel : NSObject {
    var dataArray : [DataItem] = []
    
    func parse(rawData: [(String, String)]) {
        var array : [DataItem] = []
        for i in 0...rawData.count - 1 {
            array.append(DataItem(id: i, imageURL: rawData[i].0, videoURL: rawData[i].1))
        }
        dataArray = array
    }
    
    
    func dataAtIndex(_ index:Int) -> DataItem? {
        if (index < 0 || index >= dataArray.count) {
            return nil
        }
        return dataArray[index]
    }
    
    func numberOfItem() -> Int {
        return dataArray.count
    }
}


