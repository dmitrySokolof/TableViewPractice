//
//  ViewController.swift
//  TableViewPractice
//
//  Created by Sokolov Dmitry on 04/10/2018.
//  Copyright © 2018 Bauman. All rights reserved.
//

import UIKit


// MARK: TableViewCell
class FilmTableViewCell: UITableViewCell
{
    static let ReuseIdentifier = "FilmTableViewCell"
    
    @IBOutlet weak var imbdIDLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    // MARK: Properties
    var films = [Film]()
    {
        // Update if films value is set
        didSet
        {
            DispatchQueue.main.async {
                self.updateView()
                self.refreshControl.endRefreshing()
            }
        }
    }
    private let refreshControl = UIRefreshControl()
    let api = APIManager()
    private let dataManager = DataManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManager.owner = self
        
        self.setupView()
        
        // Get films with year 2018
        self.fetchFilmData(year: 2018)
        
    }
    
    // MARK: View configuration
    private func setupView() {
        self.setupTableView()
        self.setupMessageLabel()
    }
    
    private func setupTableView() {
        tableView.isHidden = true
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshFilmData(_:)), for: .valueChanged)
    }
    
    
    // Refresh data with films of random year in range 1999...2017
    @objc private func refreshFilmData(_ sender: Any) {
        fetchFilmData(year: Int(arc4random_uniform(18) + 1999))
    }
    
    // Message if data is empty
    private func setupMessageLabel() {
        messageLabel.isHidden = true
        messageLabel.text = "No films to show."
    }
    
    private func updateView() {
        let hasFilms = films.count > 0
        tableView.isHidden = !hasFilms
        messageLabel.isHidden = hasFilms
        
        if hasFilms {
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.ReuseIdentifier, for: indexPath) as! FilmTableViewCell
        
        let film = self.films[indexPath.row]
        
        cell.titleLabel.text = film.title
        cell.imbdIDLabel.text = film.imbdID
        
        return cell
        
    }
    
    // MARK: Data obtainment
    private func fetchFilmData(year: Int) {
        dataManager.setURL(url: api.getURL())
        dataManager.searchFilms(year: year)
        
    }
    

}

