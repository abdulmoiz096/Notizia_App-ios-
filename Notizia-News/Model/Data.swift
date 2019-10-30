//
//  Data.swift
//  News-App
//
//  Created by Abdul Moid on 3/31/1398 AP.
//  Copyright © 2019 d-tech.com All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class Data
{
    var titleArray = [[String]]()
    var newsSourceArray = [[String]]()
    var imageURLArray = [[String]]()
    var newsStoryUrlArray = [[String]]()
    
    func getNewsData(complete: @escaping (_ status: Bool) -> ())
    {
        SVProgressHUD.show()
        //API
        Alamofire.request("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=96983db1075641f283b65aff6d422cff", method: .get).responseJSON { (response) in
            
            guard let value = response.result.value else { return }
            
            let json = JSON(value)
            
            for item in json["articles"].arrayValue
            {
                self.titleArray.append([item["title"].stringValue])
                self.newsSourceArray.append([item["source"]["name"].stringValue])
                self.imageURLArray.append([item["urlToImage"].stringValue])
                self.newsStoryUrlArray.append([item["url"].stringValue])
                
            }
            SVProgressHUD.dismiss()
            complete(true)
        }
    }
}
