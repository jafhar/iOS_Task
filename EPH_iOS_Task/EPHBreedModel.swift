//
//  EPHBreedModel.swift
//  EPH_iOS_Task
//
//  Created by Jafhar Sharief B on 05/11/17.
//  Copyright © 2017 Jafhar. All rights reserved.
//

import Foundation

// MARK: - Breeds Model
struct Breeds {
    var breeds:[String]
}

extension Breeds {
    private enum Keys: String, JSONObjectKey {
        case message
    }
    
    init(json: JSONObject) {
        breeds = json.value(forKey: Keys.message)!
    }
}


// MARK: - Image Model Which has url for actual image to fetch
struct RandomImageURL {
    let imageURL:String
}

extension RandomImageURL {
    private enum Keys: String, JSONObjectKey {
        case message
    }
    
    init(json: JSONObject) {
        imageURL = json.value(forKey: Keys.message)!
    }
}

