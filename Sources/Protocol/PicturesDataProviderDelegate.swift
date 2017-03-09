//
//  PicturesDataProviderDelegate.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/29/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import Foundation

public protocol PicturesDataProviderDelegate: class
{
    func picturesNeedsNewPictures( _ callback: @escaping (((newPictures: [Any], isLoadAll: Bool)) -> Void))
    
    func picturesDidSelectPictures(selectedPictures: [(index: UInt, picture: Any)])
}
