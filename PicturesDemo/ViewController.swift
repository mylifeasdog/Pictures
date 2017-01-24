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
        pictures.picturesDataProviderDelegate = self
        pictures.collectionView?.reloadData()
        
        let navi = UINavigationController(rootViewController: pictures)
        present(navi, animated: true, completion: nil)
    }
    
}

extension ViewController: PicturesDataProviderDelegate
{
    func picturesNeedsNewPictures(_ callback: @escaping (((newPictures: [Any], isLoadAll: Bool)) -> Void))
    {
        DispatchQueue
            .main
            .asyncAfter(
            deadline: .now() + .seconds(2)) {
                self.page += 1
                callback((newPictures: self.allImage(), isLoadAll: self.page > 3))
        }
    }
    
    func picturesDidSelectPictures(selectedPictures: [Any])
    {
        print("selectedPictures: \(selectedPictures)")
    }
}

extension ViewController
{
    func allImage() -> [UIImage]
    {
        var images = [UIImage]()
        for i in 0...10
        {
            images.append(UIImage(named: "sample-\(i)")!)
        }
        
        return images
    }
    
    fileprivate func imageURL(from index: UInt) -> URL
    {
        return URL(string: "https://unsplash.it/250/250?image=\(index)")! // swiftlint:disable:this force_unwrapping
    }
}
