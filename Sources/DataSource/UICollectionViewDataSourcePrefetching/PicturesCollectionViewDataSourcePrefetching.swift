//
//  PicturesCollectionViewDataSourcePrefetching.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/28/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

class PicturesCollectionViewDataSourcePrefetching: NSObject, UICollectionViewDataSourcePrefetching
{
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
    {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath])
    {
        fatalError()
    }
}
