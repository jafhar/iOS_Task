//
//  EPHSubViewDetailViewController.swift
//  EPH_iOS_Task
//
//  Created by Jafhar Sharief B on 05/11/17.
//  Copyright © 2017 Jafhar. All rights reserved.
//

import UIKit


class EPHSubViewDetailViewController: UIViewController {
    
    var parentBreed: String?
    var selectedBreed:String?
    fileprivate var request: AnyObject?
    fileprivate var imageRequest: AnyObject?
    let breedCache = NSCache<NSString, UIImage>()

    @IBOutlet weak var breedImageView:UIImageView!
    @IBOutlet weak var activityIndicatorForImage: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if selectedBreed != nil {
            title = selectedBreed
        } else {
            title = "Breed Detail"
        }
        
        fetchRandomImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


extension EPHSubViewDetailViewController {
    
    // MARK: - Fetch Selected Breed's Random Image
    func fetchRandomImage() {
        var path = "api/breeds/image/random"
        if let selectedBreed = selectedBreed, let parentBreed = parentBreed {
            path = "api/breed/" + parentBreed + "/" + selectedBreed + "/images/random"
        }
        let imageResource = RandomImageResource(methodPath: path)
        let imageRequest = WebServiceRequest(resource: imageResource)
        request = imageRequest
        activityIndicatorForImage.isHidden = false
        activityIndicatorForImage.startAnimating()
        breedImageView.isHidden = true
        imageRequest.loadRequest{ [weak self] (imageURL: RandomImageURL?) in
            self?.activityIndicatorForImage.stopAnimating()
            self?.activityIndicatorForImage.isHidden = true
            self?.breedImageView.isHidden = false
            guard let imageURL = imageURL else {
                return
            }
            self?.fetchImage(path: imageURL.imageURL)
        }
    }
    
}


private extension EPHSubViewDetailViewController {
    
    // MARK: - Fetching the Image from actual URL
    func fetchImage(path url:String) {
        print(url)
        // MARK: - Use Cached Image, If not fetch it from service
        if let cachedBreedImage = breedCache.object(forKey: url as NSString) {
            print("Cached Image...)")
            updateDetails(with: cachedBreedImage)
        }else {
            guard let imageURL = URL(string: url) else {
                return
            }
            let imageRequest = ImageRequest(url: imageURL)
            self.imageRequest = imageRequest
            activityIndicatorForImage.isHidden = false
            activityIndicatorForImage.startAnimating()
            breedImageView.isHidden = true
            imageRequest.loadRequest{ [weak self] (randomImage: UIImage?) in
                self?.activityIndicatorForImage.startAnimating()
                self?.activityIndicatorForImage.isHidden = true
                self?.breedImageView.isHidden = false
                guard let randomImage = randomImage else {
                    return
                }
                self?.breedCache.setObject(randomImage, forKey: url as NSString)
                if let cachedImage = self?.breedCache.object(forKey: url as NSString) {
                    self?.updateDetails(with: cachedImage)
                }
            }
        }
    }
    
    // MARK: - Update Image to UI
    func updateDetails(with image:UIImage) {
        breedImageView.image = image
        breedImageView.contentMode = UIViewContentMode.scaleAspectFill
    }
    
}

