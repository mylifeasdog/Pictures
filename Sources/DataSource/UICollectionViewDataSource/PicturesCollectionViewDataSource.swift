//
//  PicturesCollectionViewDataSource.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/28/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

class PicturesCollectionViewDataSource<T: UICollectionViewCell>: NSObject, UICollectionViewDataSource where T: PicturesImageProviderType
{
    weak var collectionView: UICollectionView? { didSet { didSetCollectionView(oldValue) } }
    
    weak var picturesCollectionViewDelegate: PicturesCollectionViewDelegate<T>?
    
    var pictures: [URL] = []
    
    var isLoading = false
    var isLoadAll = false { didSet { didSetIsLoadAll(oldValue) } }
    
    // MARK: - Setter
    
    private func didSetCollectionView(_ oldValue: UICollectionView?)
    {
        collectionView?.register(T.self, forCellWithReuseIdentifier: NSStringFromClass(T.self))
        collectionView?.register(LoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: NSStringFromClass(LoadingCollectionReusableView.self))
    }
    
    private func didSetIsLoadAll(_ oldValue: Bool)
    {
        if isLoadAll == oldValue
        {
            // ;
        }
        else
        {
            collectionView?.collectionViewLayout.invalidateLayout()
        }
    }
    
    // MARK: -
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard 0..<pictures.count ~= indexPath.item else
        {
            fatalError()
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(T.self), for: indexPath) as? T else
        {
            fatalError()
        }
        
        let picture = pictures[indexPath.item]
        
        cell.isSelected = picturesCollectionViewDelegate.map { $0.selectedPictures.contains(picture) } ?? false
        cell.imageURL = picture
        
        if cell.isSelected
        {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
            
            (cell as? SelectedIndexCellType)?.index = picturesCollectionViewDelegate?.selectedPictures.index(of: picture).map { UInt($0) + 1 } ?? 1
        }
        else
        {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if isLoadAll
        {
            return UICollectionReusableView(frame: .zero)
        }
        else
        {
            guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: NSStringFromClass(LoadingCollectionReusableView.self), for: indexPath) as? LoadingCollectionReusableView else
            {
                fatalError()
            }
            
            view.startAnimating()
            
            return view
        }
    }
}
