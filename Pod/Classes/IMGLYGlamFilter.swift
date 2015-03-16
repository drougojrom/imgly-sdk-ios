//
//  IMGLYGlamFilter.swift
//  imglyKit
//
//  Created by Carsten Przyluczky on 11/03/15.
//  Copyright (c) 2015 9elements GmbH. All rights reserved.
//

import Foundation

public class IMGLYGlamFilter: IMGLYResponseFilter {
    public override init() {
        super.init()
        self.responseName = "Glam"
        self.displayName = "glam"
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override var filterType:IMGLYFilterType {
        get {
            return IMGLYFilterType.Glam
        }
    }
}
