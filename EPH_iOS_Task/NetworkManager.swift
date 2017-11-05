//
//  NetworkManager.swift
//  EPH_iOS_Task
//
//  Created by Jafhar Sharief B on 05/11/17.
//  Copyright © 2017 Jafhar. All rights reserved.
//

import Foundation
import UIKit

protocol NetworkRequest: class {
    
    associatedtype Model
    func loadRequest(withCompletion completion: @escaping (Model?) -> Void)
    func decode(_ data: Data) -> Model?
    
}

// MARK: - Web Service Request
extension NetworkRequest {
    
    fileprivate func load(_ url: URL, withCompletion completion: @escaping (Model?) -> Void) {
        let configuration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: url, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(self?.decode(data))
        })
        task.resume()
    }
    
}



// MARK: - Preparing Web Service Request
class WebServiceRequest<Resource: WebServiceResource> {
    let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
}

extension WebServiceRequest: NetworkRequest {
    func decode(_ data: Data) -> Resource.Model? {
        return resource.makeModel(data: data)
    }
    
    func loadRequest(withCompletion completion: @escaping (Resource.Model?) -> Void) {
        load(resource.url, withCompletion: completion)
    }
}



// MARK: - Preparing Image Fetching Request
class ImageRequest {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
}

extension ImageRequest: NetworkRequest {
    func decode(_ data: Data) -> UIImage? {
        return UIImage(data: data)
    }
    
    func loadRequest(withCompletion completion: @escaping (UIImage?) -> Void) {
        load(url, withCompletion: completion)
    }
}


