//
//  PicturesCollectionViewCell.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/28/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

open class PicturesCollectionViewCell: UICollectionViewCell, PicturesImageProviderType, SelectedIndexCellType
{
    open var image: UIImage? = nil { didSet { didSetImage(oldValue) } }
    open var imageURL: URL? = nil { didSet { didSetImageURL(oldValue) } }
    open var index: UInt = 1 { didSet { selectedIndexLabel.text = "\(index)" } }
    
    private let imageView = UIImageView(frame: .zero)
    private let selectedIndexLabel = UILabel(frame: .zero)
    
    override open var isSelected: Bool { didSet { imageURL != nil ? didSetIsSelected(oldValue) : didSetIsSelectedImage(oldValue) } }
    
    // MARK: - Initializer
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit()
    {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
        
        selectedIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedIndexLabel.backgroundColor = .blue
        contentView.addSubview(selectedIndexLabel)
        
        let constraints = [
            NSLayoutConstraint(
                item: imageView,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .centerX,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: imageView,
                attribute: .width,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .width,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: imageView,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .centerY,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: imageView,
                attribute: .height,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .height,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: selectedIndexLabel,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .trailing,
                multiplier: 1.0,
                constant: 0.0),
            NSLayoutConstraint(
                item: selectedIndexLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: contentView,
                attribute: .top,
                multiplier: 1.0,
                constant: 0.0) ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Setter
    
    private func didSetIsSelected(_ oldValue: Bool)
    {
        imageView.layer.borderWidth = isSelected ? 3.0 : 0.0
        imageView.layer.borderColor = isSelected ? UIColor.blue.cgColor : nil
        selectedIndexLabel.isHidden = (isSelected == false)
    }
    
    private func didSetIsSelectedImage(_ oldValue: Bool)
    {
        imageView.layer.borderWidth = isSelected ? 3.0 : 0.0
        imageView.layer.borderColor = isSelected ? UIColor.blue.cgColor : nil
        selectedIndexLabel.isHidden = (isSelected == false)
    }
    
    private func didSetImageURL(_ oldValue: URL?)
    {
        guard let imageURL = imageURL else
        {
            imageView.image = nil
            
            return
        }
        
        DispatchQueue
            .global(qos: .background)
            .async {
                
                let image = (try? Data(contentsOf: imageURL)).flatMap { UIImage(data: $0) }
                
                DispatchQueue
                    .main
                    .async { [weak self] in
                        self?.imageView.image = image } }
    }
    
    private func didSetImage(_ oldValue: UIImage?)
    {
        guard let image = image else
        {
            imageView.image = nil
            
            return
        }
        
        DispatchQueue
            .global(qos: .background)
            .async {
                
                DispatchQueue
                    .main
                    .async { [weak self] in
                        self?.imageView.image = image } }
    }
    
    // MARK: - 
    
    override open func prepareForReuse()
    {
        super.prepareForReuse()
        
        isSelected = false
        imageView.image = nil
    }
}
