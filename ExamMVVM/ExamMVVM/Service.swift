//
//  Service.swift
//  ExamMVVM
//
//  Created by Michelle Conchina on 9/7/17.
//  Copyright © 2017 Michelle Conchina. All rights reserved.
//

import UIKit
import Alamofire
import Cache

typealias ResultBlock = (_ response: Any?, _ error: Error?) -> Void

class Service: NSObject {
    let cache = HybridCache(name: "CacheObject")
    
    func request(urlString: String, withBlock: @escaping ResultBlock) {
        print("URL: \(urlString)")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(urlString, method: .get)
            .validate()
            .responseJSON { response in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success(let JSONValue):
                    print("Success with JSON")
                    if let response = JSONValue as? [[String: AnyObject]] {
                        do {
                            try self.cache.addObject(JSON.array(response), forKey: "reponseJSONCache")
                        } catch {
                            print(error.localizedDescription)
                        }
                        withBlock(response, nil)
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    withBlock(nil, error)
                }
        }
    }
}
