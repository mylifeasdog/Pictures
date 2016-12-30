//
//  PicturesImageProviderType.swift
//  Pictures
//
//  Created by Wipoo Shinsirikul on 12/28/16.
//  Copyright © 2016 Wipoo Shinsirikul. All rights reserved.
//

import UIKit

public protocol PicturesImageProviderType: class
{
    var imageURL: URL? { get set }
}
