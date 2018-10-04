//
//  Configuration.swift
//  TableViewPractice
//
//  Created by Sokolov Dmitry on 04/10/2018.
//  Copyright © 2018 Bauman. All rights reserved.
//

import Foundation

class APIManager {
    
    // Valid apikey for OMDb API
    let API_KEY = "21cceeff"
    private var baseURL: URL?
    
    init() {
        self.baseURL = URL(string: "https://www.omdbapi.com/")
    }

    public func getURL() -> URL?{
        return self.baseURL
    }
    
    public func setURL(url: URL?) {
        self.baseURL = url
    }
    
    
    // Append a request query to base URL
    public func addQuery(baseURL: URL?, queryItemNames: [String], queryItemValues: [String]) -> URL? {
        var urlComponents = URLComponents(url: baseURL!, resolvingAgainstBaseURL: true)
        var queryItems = Array<URLQueryItem>()
        
        
        // QueryItemNames should have same number of items as QueryItemValues
        assert(queryItemValues.count == queryItemNames.count, "Query Items Error")
        
        for i in 0...queryItemNames.count - 1
        {
            queryItems.append(URLQueryItem(name: queryItemNames[i], value: queryItemValues[i]))
        }

        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
        
    }
}

