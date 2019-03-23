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

class TipCalc {
    var defPerc = 75.0
    
    func calcTip(amount : Double, tipPerc : Double) -> Double {
        return amount * tipPerc/100.0
    }
}
