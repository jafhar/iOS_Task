//
//  EPHSubBreedViewController.swift
//  EPH_iOS_Task
//
//  Created by Jafhar Sharief B on 05/11/17.
//  Copyright © 2017 Jafhar. All rights reserved.
//

import UIKit


class EPHSubBreedViewController: UIViewController {
    
    var subBreedList:Breeds? = nil
    var parentBreed:String?
    fileprivate var request: AnyObject?
    fileprivate var imageRequest: AnyObject?
    let breedImagesCache = NSCache<NSString, UIImage>()
    let segueIdentifier = "SubBreedDetailSegue"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var randomImageView:UIImageView!
    @IBOutlet weak var activityIndicatorForImage: UIActivityIndicatorView!
    @IBOutlet weak var activityIndicatorForList: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if parentBreed != nil {
            title = parentBreed
        } else {
            title = "Sub Breeds"
        }
        // MARK: - Fetch Breeds Random Image
        fetchRandomImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension EPHSubBreedViewController:UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = (subBreedList?.breeds.count) {
            return count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: -  Configuring the sub breeds table Cell
        let cellIdentifier = "SubBreedCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let subBreed = subBreedList?.breeds[indexPath.row]
        cell.textLabel?.text = subBreed
        return cell
        
    }
}


extension EPHSubBreedViewController {
    
    // MARK: - Table view dalegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension EPHSubBreedViewController {
    
    // MARK: - Preparing for the detail segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedBreed = subBreedList?.breeds[indexPath.row]
                let destinationViewController = segue.destination as! EPHSubViewDetailViewController
                destinationViewController.selectedBreed = selectedBreed
                destinationViewController.parentBreed = parentBreed
            }
        }
    }
}

extension EPHSubBreedViewController {
    
    // MARK: - Fetching the Sub Breed List
    func fetchSubBreed() {
        var path = "api/breeds/list"
        if let parentBreed = parentBreed {
            path = "api/breed/" + parentBreed + "/list"
        }
        
        let subBreedsResource = SubBreedResource(methodPath: path)
        let subBreedsRequest = WebServiceRequest(resource: subBreedsResource)
        request = subBreedsRequest
        activityIndicatorForList.isHidden = false
        activityIndicatorForList.startAnimating()
        tableView.isHidden = true
        subBreedsRequest.loadRequest{ [weak self] (subBreeds: Breeds?) in
            self?.activityIndicatorForList.isHidden = true
            self?.activityIndicatorForList.stopAnimating()
            self?.tableView.isHidden = false
            guard let subBreeds = subBreeds else {
                return
            }
            self?.updateSubBreedTable(with: subBreeds)
        }
    }
    
}


extension EPHSubBreedViewController {
    
    // MARK: - Fetching the Breed Random Image
    func fetchRandomImage() {
        var path = "api/breeds/image/random"
        if let parentBreed = parentBreed {
            path = "api/breed/" + parentBreed + "/images/random"
        }
        
        let subBreedsResource = RandomImageResource(methodPath: path)
        let subBreedsRequest = WebServiceRequest(resource: subBreedsResource)
        request = subBreedsRequest
        activityIndicatorForImage.isHidden = false
        activityIndicatorForImage.startAnimating()
        randomImageView.isHidden = true
        subBreedsRequest.loadRequest{ [weak self] (randomImageURL: RandomImageURL?) in
            self?.activityIndicatorForImage.isHidden = true
            self?.activityIndicatorForImage.startAnimating()
            self?.randomImageView.isHidden = false
            guard let randomImageURL = randomImageURL else {
                return
            }
            self?.fetchImage(path: randomImageURL.imageURL)
            self?.fetchSubBreed()
        }
    }
    
}



private extension EPHSubBreedViewController {
    
    // MARK: - Fetching the Image From Actual URL
    func fetchImage(path url:String) {
        
        // MARK: - Use Cached Image, If not Fetch it
        if let cachedBreedImage = breedImagesCache.object(forKey: url as NSString) {
            print("Cached Image :)")
            upadateSubBreedImage(with: cachedBreedImage)
        } else {
            guard let imageURL = URL(string: url) else {
                return
            }
            let imageRequest = ImageRequest(url: imageURL)
            self.imageRequest = imageRequest
            activityIndicatorForImage.isHidden = false
            activityIndicatorForImage.startAnimating()
            randomImageView.isHidden = true
            imageRequest.loadRequest{ [weak self] (randomImage: UIImage?) in
                self?.activityIndicatorForImage.isHidden = true
                self?.activityIndicatorForImage.stopAnimating()
                self?.randomImageView.isHidden = false
                guard let randomImage = randomImage else {
                    return
                }
                self?.breedImagesCache.setObject(randomImage, forKey: url as NSString)
                if let cachedImage = self?.breedImagesCache.object(forKey: url as NSString) {
                    self?.upadateSubBreedImage(with: cachedImage)
                }
            }
        }
    }
    
    // MARK: - Update Sub Breeds List Table
    func updateSubBreedTable(with subBreeds: Breeds) {
        subBreedList = subBreeds
        tableView.reloadData()
    }
    
    // MARK: - Update Breed's Random Image
    func upadateSubBreedImage(with randomImage:UIImage) {
        randomImageView.image = randomImage
        randomImageView.contentMode = UIViewContentMode.scaleToFill
        
    }
    
}

