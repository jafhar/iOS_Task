//
//  EPHBreedViewController.swift
//  EPH_iOS_Task
//
//  Created by Jafhar Sharief B on 05/11/17.
//  Copyright © 2017 Jafhar. All rights reserved.
//

import UIKit


class EPHBreedViewController: UIViewController {
    
    var breedList:Breeds? = nil
    let breedSearchController = UISearchController(searchResultsController: nil)
    var filteredBreedList:Breeds? = nil
    fileprivate var request: AnyObject?
    let segueIdentifier = "SubBreedSegue"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Breeds"
        
        // MARK: - Fetch Breeds List
        fetchBreed()
        
        // MARK: - Setup the Breed Search Controller
        breedSearchController.searchResultsUpdater = self
        breedSearchController.obscuresBackgroundDuringPresentation = false
        breedSearchController.searchBar.placeholder = "Search Breed"
        tableView.tableHeaderView = breedSearchController.searchBar
        breedSearchController.hidesNavigationBarDuringPresentation = false
        breedSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = false
        
        // MARK: - Assign breed list to filtered breed list
        filteredBreedList = breedList
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // MARK: - Dismiss search View Controller
        breedSearchController.dismiss(animated: false, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: - Make Search Control Empty
        breedSearchController.searchBar.text = nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension EPHBreedViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = (filteredBreedList?.breeds.count) {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: - Configuring the table cell
        let cellIdentifier = "BreedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let breed = filteredBreedList?.breeds[indexPath.row]
        cell.textLabel?.text = breed
        return cell
    }
    
}


extension EPHBreedViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension EPHBreedViewController {
    
    // MARK: - Prepare segue for Sub Breed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedBreed = filteredBreedList?.breeds[indexPath.row]
                let destinationViewController = segue.destination as! EPHSubBreedViewController
                destinationViewController.parentBreed = selectedBreed
            }
        }
    }
}


extension EPHBreedViewController {
    
    // MARK: - Fetch Breed List
    func fetchBreed() {
        let breedsResource = BreedResource()
        let breedsRequest = WebServiceRequest(resource: breedsResource)
        request = breedsRequest
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        tableView.isHidden = true
        breedsRequest.loadRequest{ [weak self] (breeds: Breeds?) in
            self?.activityIndicator.isHidden = true
            self?.activityIndicator.stopAnimating()
            self?.tableView.isHidden = false
            guard let breeds = breeds else {
                return
            }
            self?.updateUI(with: breeds)
        }
    }
    
}


private extension EPHBreedViewController {
    
    // MARK: - Update UI with results
    func updateUI(with breeds: Breeds) {
        breedList = breeds
        breedSearchController.searchBar.text = nil
        tableView.reloadData()
    }
    
}


extension EPHBreedViewController: UISearchResultsUpdating {
    
    // MARK: - Search Controll Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = breedSearchController.searchBar.text, !searchText.isEmpty {
            filteredBreedList?.breeds = (breedList?.breeds.filter { breed in
                return breed.lowercased().contains(searchText.lowercased())
                })!
            
        } else {
            filteredBreedList = breedList
        }
        tableView.reloadData()
    }
    
}

