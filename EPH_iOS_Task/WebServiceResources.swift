//
//  WebServiceResources.swift
//  EPH_iOS_Task
//
//  Created by Jafhar Sharief B on 05/11/17.
//  Copyright © 2017 Jafhar. All rights reserved.
//

import Foundation

// MARK: - Web Service Resource
protocol WebServiceResource {
    associatedtype Model
    var methodPath: String { get }
    func makeModelFrom(json: JSONObject) -> Model?
}

extension WebServiceResource {
    var url: URL {
        let baseUrl = "https://dog.ceo/"
        let url = baseUrl + methodPath
        print(url)
        return URL(string: url)!
    }
    
    func makeModel(data: Data) -> Model? {
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            return nil
        }
        guard let jsonSerialization = json as? JSONObject else {
            return nil
        }
        return self.makeModelFrom(json:jsonSerialization)
    }
}

// MARK: - Resource For Fetching Breed List
struct BreedResource: WebServiceResource {
    typealias Model = Breeds
    let methodPath = "api/breeds/list"
    func makeModelFrom(json: JSONObject) -> Model? {
        return Breeds(json:json)
    }
}


// MARK: - Resource For Fetching Sub Breed List
struct SubBreedResource: WebServiceResource {
    typealias Model = Breeds
    var methodPath = ""
    func makeModelFrom(json: JSONObject) -> Breeds? {
        return Breeds(json:json)
    }
}


// MARK: - Resource For Fetching Random Image Json
struct RandomImageResource: WebServiceResource {
    
    typealias Model = RandomImageURL
    var methodPath = ""
    func makeModelFrom(json: JSONObject) -> RandomImageURL? {
        return RandomImageURL(json:json)
    }
}

