//
//  PicturesCollectionViewDelegate.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/28/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

class PicturesCollectionViewDelegate<T: UICollectionViewCell>: PicturesCollectionViewDelegateFlowLayout<T> where T: PicturesImageProviderType
{
    weak var picturesDataProviderDelegate: PicturesDataProviderDelegate?
    
    private(set) var selectedPictures: [URL] = []
    
    weak var picturesCollectionViewDataSource: PicturesCollectionViewDataSource<T>?
    
    @objc(collectionView:didSelectItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let pictures = picturesCollectionViewDataSource?.pictures else
        {
            return
        }
        
        guard 0..<pictures.count ~= indexPath.item else
        {
            return
        }
        
        let selectedPicture = pictures[indexPath.item]
        
        guard selectedPictures.contains(selectedPicture) == false else
        {
            return
        }
        
        selectedPictures.append(selectedPicture)
        
        guard let cell = collectionView.cellForItem(at: indexPath) else
        {
            return
        }
        
        cell.isSelected = true
        collectionView.selectItem(
            at: indexPath,
            animated: true,
            scrollPosition: UICollectionViewScrollPosition())
        
        (cell as? SelectedIndexCellType)?.index = selectedPictures.index(of: selectedPicture).map { UInt($0) + 1 } ?? 1
    }
    
    @objc(collectionView:didDeselectItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)
    {
        guard let pictures = picturesCollectionViewDataSource?.pictures else
        {
            return
        }
        
        guard 0..<pictures.count ~= indexPath.item else
        {
            return
        }
        
        let deselectedPicture = pictures[indexPath.item]
        
        guard let deselectedPictureIndex = selectedPictures.index(of: deselectedPicture) else
        {
            return
        }
        
        _ = selectedPictures.remove(at: deselectedPictureIndex)
        
        guard let cell = collectionView.cellForItem(at: indexPath) else
        {
            return
        }
        
        cell.isSelected = false
        collectionView.deselectItem(
            at: indexPath,
            animated: true)
        
        var index: UInt = 1
        
        selectedPictures
            .flatMap { pictures.index(of: $0).map { IndexPath(item: $0, section: 0) } }
            .forEach {
                if let cell = collectionView.cellForItem(at: $0) as? SelectedIndexCellType
                {
                    cell.index = index
                }
                else
                {
                    collectionView.reloadItems(at: [ $0 ])
                }
                index += 1 }
    }
    
    @objc(collectionView:willDisplayCell:forItemAtIndexPath:)
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        guard let picturesCollectionViewDataSource = picturesCollectionViewDataSource else
        {
            return
        }
        
        guard picturesCollectionViewDataSource.isLoading == false,
            picturesCollectionViewDataSource.isLoadAll == false else
        {
            return
        }
        
        let pictures = picturesCollectionViewDataSource.pictures
        
        guard indexPath.item == pictures.count - 1 else
        {
            return
        }
        
        guard let picturesDataProviderDelegate = picturesDataProviderDelegate else
        {
            return
        }
        
        picturesCollectionViewDataSource.isLoading = true
        
        picturesDataProviderDelegate.picturesNeedsNewPictures { (newPictures, isLoadAll) in
            collectionView
                .performBatchUpdates(
                    { [weak self] in
                        let insertedIndex = (pictures.count..<(pictures.count + newPictures.count)).map { IndexPath(item: $0, section: 0) }
                        self?.picturesCollectionViewDataSource?.pictures += newPictures
                        collectionView.insertItems(at: insertedIndex)
                        self?.picturesCollectionViewDataSource?.isLoadAll = isLoadAll },
                    completion: { _ in
                        picturesCollectionViewDataSource.isLoading = false }) }
    }
}
