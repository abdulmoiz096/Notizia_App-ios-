//
//  ViewController.swift
//  News-App
//
//  Created by d-tech on 7/13/18.
//  Copyright © 2019 d-tech.com. All rights reserved.
//

import UIKit

class NewsVC: UIViewController
{
    let data = Data()
    var titleArray = [[String]]()
    var newsSourceArray = [[String]]()
    var imageURLArray = [[String]]()
    var newsStoryUrlArray = [[String]]()
    @IBOutlet weak var newsTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.newsTableView.backgroundColor = UIColor.clear
        self.newsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        data.getNewsData { (success) in
            if success {
                print("success")
                self.titleArray = self.data.titleArray
                self.imageURLArray = self.data.imageURLArray
                self.newsSourceArray = self.data.newsSourceArray
                self.newsStoryUrlArray = self.data.newsStoryUrlArray
                self.newsTableView.reloadData()
                print(self.imageURLArray.count)
            } else {
                print("doesnt work ")
                let alertController = UIAlertController(title: "Nouvelles", message: "Error getting news please make sure you are connected to the internet", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                    UIAlertAction in
                    exit(0)
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension NewsVC: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
       return imageURLArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var title = String()
        section == 0 ? (title = "") : (title = " ")
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView()
        returnedView.backgroundColor = UIColor.clear    //To make tableView header transparent
        return returnedView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = newsTableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as? NewsCell else { return UITableViewCell() }
        
        var titles = String()
        var sources = String()
        
        cell.layer.cornerRadius = 10            //To make cell edges round
        cell.layer.masksToBounds = true
        
        if titleArray.count > 0 {
             titles = titleArray[indexPath.section][indexPath.row]
        } else {
             titles = ""
        }
        
        if newsSourceArray.count > 0 {
            sources = newsSourceArray[indexPath.section][indexPath.row]
        } else {
            sources = ""
        }
    
        if imageURLArray.count > 0 {
            
            cell.newsImage.layer.borderWidth = 1
            cell.newsImage.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.newsImage.layer.cornerRadius = (cell.newsImage.frame.size.width) / 2
            cell.newsImage.clipsToBounds = true
            
            cell.newsImage.sd_setImage(with: URL(string: imageURLArray[indexPath.section][indexPath.row])) { (image, error, cache, urls) in
                if (error != nil) {
                    cell.newsImage.image = UIImage(named: "newsPlaceholder")
                } else {
                    cell.newsImage.image = image
                }
            }
        } else {
            cell.newsImage.image = UIImage(named: "newsPlaceholder")!
        }
        cell.configureCell(newsTitle: titles, newsSource: sources)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let indexPath = tableView.indexPathForSelectedRow
        let urls = newsStoryUrlArray[(indexPath?.section)!][(indexPath?.row)!]
    
        UIApplication.shared.open( URL(string: urls)!, options: [:] ) { (success) in
            if success {
                print("open link")
            }
            else
            {
                let alertController = UIAlertController(title: "Nouvelles", message: "Error Opening News", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default){
                    UIAlertAction in
                }
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath! , animated: true)
    }
}

