//
//  LoadingCollectionReusableView.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/29/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

extension LoadingCollectionReusableView
{
    func startAnimating() { activityIndicatorView.startAnimating() }
    func stopAnimating() { activityIndicatorView.stopAnimating() }
}

class LoadingCollectionReusableView: UICollectionReusableView
{
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // MARK: - Initializer
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit()
    {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        addSubview(activityIndicatorView)
        
        let constraints = [
            NSLayoutConstraint(
                item: activityIndicatorView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: activityIndicatorView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: self,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0) ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: -
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        activityIndicatorView.stopAnimating()
    }
}
