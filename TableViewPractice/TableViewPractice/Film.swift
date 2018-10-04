//
//  Film.swift
//  TableViewPractice
//
//  Created by Sokolov Dmitry on 04/10/2018.
//  Copyright © 2018 Bauman. All rights reserved.
//

import Foundation

struct Film {
    
    let title: String
    let imbdID: String
    
}

extension Film {
    
    public init?(JSON: Any) {
        
        guard let JSON = JSON as? [String: AnyObject] else { return nil }
        guard let title = JSON["Title"] as? String else { return nil }
        guard let imbdID = JSON["imdbID"] as? String else { return nil }
        
        self.title = title
        self.imbdID = imbdID
        
    }
    
}
