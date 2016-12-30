//
//  Pictures.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/28/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

open class Pictures<T: UICollectionViewCell>: UICollectionViewController where T: PicturesImageProviderType
{
    fileprivate let picturesCollectionViewDataSource = PicturesCollectionViewDataSource<T>()
//    private let picturesCollectionViewDataSourcePrefetching = PicturesCollectionViewDataSourcePrefetching()
    fileprivate let picturesCollectionViewDelegate = PicturesCollectionViewDelegate<T>()
    
    public init()
    {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override open func viewDidLoad()
    {
        super.viewDidLoad()
        
        installsStandardGestureForInteractiveMovement = false
        
        if collectionViewLayout is UICollectionViewFlowLayout
        {
            // ;
        }
        else
        {
            collectionView?.collectionViewLayout = UICollectionViewFlowLayout()
        }
        
        picturesCollectionViewDataSource.collectionView = collectionView
        picturesCollectionViewDataSource.picturesCollectionViewDelegate = picturesCollectionViewDelegate
        
        picturesCollectionViewDelegate.collectionViewLayout = collectionView?.collectionViewLayout
        picturesCollectionViewDelegate.picturesCollectionViewDataSource = picturesCollectionViewDataSource
        
        collectionView?.dataSource = picturesCollectionViewDataSource
//        collectionView?.prefetchDataSource = picturesCollectionViewDataSourcePrefetching
        collectionView?.delegate = picturesCollectionViewDelegate
        
        collectionView?.allowsMultipleSelection = true
        collectionView?.backgroundColor = .white
        
        reloadData()
    }
}

extension Pictures
{
    func reloadData()
    {
        guard let picturesDataProviderDelegate = picturesDataProviderDelegate else
        {
            return
        }
        
        picturesCollectionViewDataSource.isLoading = true
        picturesCollectionViewDataSource.isLoadAll = false
        picturesCollectionViewDataSource.pictures.removeAll()
        
        picturesDataProviderDelegate.picturesNeedsNewPictures { [weak self] (newPictures, isLoadAll) in
            self?.collectionView?
                .performBatchUpdates(
                    { [weak self] in
                        let insertedIndex = (0..<newPictures.count).map { IndexPath(item: $0, section: 0) }
                        self?.picturesCollectionViewDataSource.pictures += newPictures
                        self?.collectionView?.insertItems(at: insertedIndex)
                        self?.picturesCollectionViewDataSource.isLoadAll = isLoadAll },
                    completion: { _ in
                        self?.picturesCollectionViewDataSource.isLoading = false }) }
    }
}

extension Pictures
{
    open var size: CGSize {
        get { return picturesCollectionViewDelegate.size }
        set { picturesCollectionViewDelegate.size = newValue } }
    open var inset: UIEdgeInsets {
        get { return picturesCollectionViewDelegate.inset }
        set { picturesCollectionViewDelegate.inset = newValue } }
    open var minimumLineSpacing: CGFloat {
        get { return picturesCollectionViewDelegate.minimumLineSpacing }
        set { picturesCollectionViewDelegate.minimumLineSpacing = newValue } }
    open var minimumInteritemSpacing: CGFloat {
        get { return picturesCollectionViewDelegate.minimumInteritemSpacing }
        set { picturesCollectionViewDelegate.minimumInteritemSpacing = newValue } }
    
    open var picturesDataProviderDelegate: PicturesDataProviderDelegate? {
        get { return picturesCollectionViewDelegate.picturesDataProviderDelegate }
        set { picturesCollectionViewDelegate.picturesDataProviderDelegate = newValue } }
}
