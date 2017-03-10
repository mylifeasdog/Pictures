//
//  ViewController.swift
//  PicturesDemo
//
//  Created by Wipoo Shinsirikul on 30/12/16.
//  Copyright © 2016 WipooShinsirikul. All rights reserved.
//

import UIKit

import Pictures

class ViewController: UIViewController
{
    fileprivate(set) var page: UInt = 0
    
    @IBAction func buttonDidSelect()
    {
        let pictures = Pictures<PicturesCollectionViewCell>()
        pictures.selectionLimit = 5
        pictures.needsNewPicturesHandler = { [unowned self] callback in
            self.loadMoreImageURL(page: self.page + 1) { (urls, isLoadAll) in
                self.page += 1
                callback((newPictures: urls, isLoadAll: isLoadAll)) } }
        
        pictures.didSelectPicturesHandler = { selectedPictures in
            print("selectedPictures: \(selectedPictures)") }
        
        pictures.collectionView?.reloadData()
        
        let navigationController = UINavigationController(rootViewController: pictures)
        present(navigationController, animated: true, completion: nil)
    }
}

extension ViewController
{
    fileprivate func imageURL(from index: UInt) -> URL
    {
        return URL(string: "https://unsplash.it/250/250?image=\(index)")! // swiftlint:disable:this force_unwrapping
    }
    
    fileprivate func loadMoreImageURL(page: UInt, callback: @escaping ((urls: [URL], isLoadAll: Bool)) -> Void)
    {
        DispatchQueue
            .main
            .asyncAfter(deadline: .now() + .seconds(2)) {
                
                let urls = (0...30).map { [unowned self] in self.imageURL(from: $0 * page) }
                let isLoadAll = page > 3
                
                callback((urls: urls, isLoadAll: isLoadAll)) }
    }
}
