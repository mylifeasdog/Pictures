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
        
        if #available(iOS 9.0, *)
        {
            installsStandardGestureForInteractiveMovement = false
        }
        
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(Pictures.refreshControlValueDidChange(refreshControl:)), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        
        reloadData()
    }
    
    // MARK: -
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator)
    {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: { [weak self] _ in
                self?.picturesCollectionViewDelegate.size = CGSize(width: UIScreen.main.bounds.width / 3.0, height: UIScreen.main.bounds.width / 3.0) },
            completion: nil)
    }
    
    // MARK: - Action
    
    @objc
    private func refreshControlValueDidChange(refreshControl: UIRefreshControl)
    {
        reloadData { refreshControl.endRefreshing() }
    }
}

extension Pictures
{
    func reloadData(_ completion: (() -> Void)? = nil)
    {
        guard let needsNewPicturesHandler = needsNewPicturesHandler else
        {
            return
        }
        
        picturesCollectionViewDataSource.isLoading = true
        picturesCollectionViewDataSource.isLoadAll = false
        
        needsNewPicturesHandler(true) { [weak self] (newPictures, isLoadAll) in
            self?.picturesCollectionViewDataSource.pictures.removeAll()
            self?.picturesCollectionViewDataSource.pictures += newPictures
            self?.picturesCollectionViewDataSource.isLoadAll = isLoadAll
            self?.picturesCollectionViewDataSource.isLoading = false
            self?.collectionView?.reloadData()
            completion?() }
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
    open var needsNewPicturesHandler: ((_ isFromRefreshControl: Bool, _ callback: @escaping ((newPictures: [Any], isLoadAll: Bool)) -> Void) -> Void)? {
        get { return picturesCollectionViewDelegate.needsNewPicturesHandler }
        set { picturesCollectionViewDelegate.needsNewPicturesHandler = newValue } }
    open var didSelectPicturesHandler: (([(index: UInt, picture: Any)]) -> Void)? {
        get { return picturesCollectionViewDelegate.didSelectPicturesHandler }
        set { picturesCollectionViewDelegate.didSelectPicturesHandler = newValue } }
    open var selectionLimit: UInt {
        get { return picturesCollectionViewDelegate.selectionLimit }
        set { picturesCollectionViewDelegate.selectionLimit = newValue } }
}
