//
//  DataManager.swift
//  TableViewPractice
//
//  Created by Sokolov Dmitry on 04/10/2018.
//  Copyright © 2018 Bauman. All rights reserved.
//

import Foundation

class DataManager {
    
    private var baseURL: URL!
    public var films: [Film]
    
    
    // Owner of DataManager instance
    public weak var owner: ViewController?
    
    // MARK: Initialization with URL
    init(baseURL: URL) {
        self.baseURL = baseURL
        films = [Film]()
    }
    
    // MARK: Initialization with empty parameter list
    init() {
        self.baseURL = URL(string: "")
        films = [Film]()
    }
    
    public func setURL(url: URL?) {
        self.baseURL = url
    }
    
    // MARK: Append query parameters to base URL and launch URL session
    func searchFilms(year: Int) {
        
        let apiManager = APIManager()
        
        // Qeury parameters:
        // y=year, year of film release
        // s=car, search for 'car' in films title
        // apikey=API_KEY, valid OMDb API key
        let url = apiManager.addQuery(baseURL: baseURL, queryItemNames: ["y", "s", "apikey"], queryItemValues: ["\(year)", "car", apiManager.API_KEY])
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            self.didFetchFilmData(data: data, response: response, error: error)
        }.resume()
    
    }
    
    // MARK: Check for correct HTTP request
    func didFetchFilmData(data: Data?, response: URLResponse?, error: Error?) {
        if let data = data, let response = response as? HTTPURLResponse {
            if response.statusCode == 200 {
                processData(data: data)
            }
        }
    }
    
    // MARK: Parse JSON manager
    func processData(data: Data) {
        var buffer = [Film]()
        
        if let JSON = try? JSONSerialization.jsonObject(with: data, options: []) {
            
            guard let JSON = JSON as? [String: AnyObject] else { return }
            
            let temp = JSON["Search"]
            
            let filmData = temp as! Array<Dictionary<String, String>>
            
            for filmDataPoint in filmData {
                if let film = Film(JSON: filmDataPoint) {
                    buffer.append(film)
                }
            }
            
            owner?.films = buffer
            
        }
    }
}
