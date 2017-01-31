//
//  PicturesDataProviderDelegate.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/29/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import Foundation

@objc
public protocol PicturesDataProviderDelegate: class
{
    func picturesNeedsNewPictures( _ callback: @escaping (((newPictures: [Any], isLoadAll: Bool)) -> Void))
    @objc
    optional func picturesDidSelectPictures(selectedPictures: [Any])
    
    @objc
    optional func picturesSetLimitSelect() -> Int
    
}
