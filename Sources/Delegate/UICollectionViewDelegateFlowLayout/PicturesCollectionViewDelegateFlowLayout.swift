//
//  PicturesCollectionViewDelegateFlowLayout.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/28/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

class PicturesCollectionViewDelegateFlowLayout<T: UICollectionViewCell>: NSObject, UICollectionViewDelegateFlowLayout where T: PicturesImageProviderType
{
    weak var collectionViewLayout: UICollectionViewLayout?
    
    var size = CGSize(width: UIScreen.main.bounds.width / 3.0, height: UIScreen.main.bounds.width / 3.0) {
        didSet { collectionViewLayout?.invalidateLayout() } }
    var inset = UIEdgeInsets.zero {
        didSet { collectionViewLayout?.invalidateLayout() } }
    var minimumLineSpacing: CGFloat = 0.0 {
        didSet { collectionViewLayout?.invalidateLayout() } }
    var minimumInteritemSpacing: CGFloat = 0.0 {
        didSet { collectionViewLayout?.invalidateLayout() } }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return inset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        guard let picturesCollectionViewDataSource = collectionView.dataSource as? PicturesCollectionViewDataSource<T> else
        {
            return .zero
        }
        
        guard picturesCollectionViewDataSource.isLoadAll == false else
        {
            return .zero
        }
        
        return CGSize(width: collectionView.bounds.width, height: 44.0)
    }
}
