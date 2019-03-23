//
//  API.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 21.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import Foundation


class AppRequest {
    
    static  let sharedInstants = AppRequest()
    let session = URLSession.shared

    func getPizza(_ completionHandler: @escaping ([PizzaElement]?, Error?) -> Void) {
        let request = NSMutableURLRequest(url: NSURL(string: Strings.mainUrl)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, err) -> Void in
            if (err != nil) {
                completionHandler(nil, err)
            } else {
                do {
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(Pizza.self, from: data!)
                    completionHandler(jsonData, nil)
                } catch {
                    xprint(error)
                    completionHandler(nil,error)
                }
            }
        })
        dataTask.resume()
    }
}

//        if let path = Bundle.main.path(forResource: "piiza", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
////                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                let decoder = JSONDecoder()
//                let jsonData = try decoder.decode(Pizza.self, from: data)
//                print(jsonData.count)
//                for piz in jsonData {
//                    xprint(piz.name,piz.price)
//                }
//            } catch {
//                // handle error
//                xprint(error)
//            }
//        }
