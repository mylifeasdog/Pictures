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
    
    private(set) var selectedPictures: [URL] = [] {
        didSet { didSetSelectedPictures(oldValue) } }
    
    private(set) var selectedImagePictures: [UIImage] = [] {
        didSet { didSetSelectedPictures(oldValue) } }
    
    weak var picturesCollectionViewDataSource: PicturesCollectionViewDataSource<T>?
    
    // MARK: - Setter
    
    private func didSetSelectedPictures(_ oldValue: [Any])
    {
        picturesDataProviderDelegate?.picturesDidSelectPictures?(selectedPictures: selectedImagePictures.isEmpty == false ? selectedImagePictures : selectedPictures)
    }
    
    // MARK: -
    
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
        
        if let picture = pictures as? [URL]
        {
            let selectedPicture = picture[indexPath.item]
            
            guard selectedPictures.contains(selectedPicture) == false else
            {
                return
            }
            
            guard let cell = collectionView.cellForItem(at: indexPath) else
            {
                return
            }
            
            if self.selectedPictures.count < self.picturesDataProviderDelegate?.picturesSetLimitSelect?() ?? 9_999
            {
                selectedPictures.append(selectedPicture)
                cell.isSelected = true
                collectionView.selectItem(
                    at: indexPath,
                    animated: true,
                    scrollPosition: UICollectionViewScrollPosition())
                
                (cell as? SelectedIndexCellType)?.index = selectedPictures.index(of: selectedPicture).map { UInt($0) + 1 } ?? 1
            }
            else
            {
                cell.isSelected = false
                collectionView.deselectItem(
                    at: indexPath,
                    animated: true)
            }
            
        }
        else if let picture = pictures as? [UIImage]
        {
            let selectedPicture = picture[indexPath.item]
            
            guard selectedImagePictures.contains(selectedPicture) == false else
            {
                return
            }
            
            guard let cell = collectionView.cellForItem(at: indexPath) else
            {
                return
            }
            
            if self.selectedPictures.count < self.picturesDataProviderDelegate?.picturesSetLimitSelect?() ?? 9_999
            {
                selectedImagePictures.append(selectedPicture)
                cell.isSelected = true
                collectionView.selectItem(
                    at: indexPath,
                    animated: true,
                    scrollPosition: UICollectionViewScrollPosition())
                
                (cell as? SelectedIndexCellType)?.index = selectedImagePictures.index(of: selectedPicture).map { UInt($0) + 1 } ?? 1
            }
            else
            {
                cell.isSelected = false
                collectionView.deselectItem(
                    at: indexPath,
                    animated: true)
            }
        }
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
        
        if let picture = pictures as? [URL]
        {
            let deselectedPicture = picture[indexPath.item]
            
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
                .flatMap { picture.index(of: $0).map { IndexPath(item: $0, section: 0) } }
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
        else if let picture = pictures as? [UIImage]
        {
            let deselectedPicture = picture[indexPath.item]
            
            guard let deselectedPictureIndex = selectedImagePictures.index(of: deselectedPicture) else
            {
                return
            }
            
            _ = selectedImagePictures.remove(at: deselectedPictureIndex)
            
            guard let cell = collectionView.cellForItem(at: indexPath) else
            {
                return
            }
            
            cell.isSelected = false
            collectionView.deselectItem(
                at: indexPath,
                animated: true)
            
            var index: UInt = 1
            
            selectedImagePictures
                .flatMap { picture.index(of: $0).map { IndexPath(item: $0, section: 0) } }
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
