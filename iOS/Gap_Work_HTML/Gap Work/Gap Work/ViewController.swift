//
//  ViewController.swift
//  Lunch
//
//  Created by Tanner Helton on 9/12/2016.
//  Copyright © 2016 Tanner Helton. All rights reserved.
//
//  Original code from jwclark
//
//  adapted from http post source code: https://www.youtube.com/watch?v=4YDkJgZCoQs
//  Info.plist config: http://stackoverflow.com/a/32560433/1103584
//
//  icons: http://www.gieson.com/Library/projects/utilities/icon_slayer/#.VgglEqLASas
//
//  language guide: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID309
//
//  myschooldining.com api (just a bread crumb) - http://codepen.io/AJNDL/pen/yhbar
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var webviewHTML: UIWebView!
    
    //set the view with HTML string
    func updateWebview(var html: String) {
        
        html = assembleHTML(html) //inject a header of assets like css and scripts
        
        //load assets in respect to their base URL ('tis why I keep all the site files in the same folder)
        let base = NSBundle.mainBundle().pathForResource("site/main", ofType: "css")!
        let baseUrl = NSURL(fileURLWithPath: base)
        webviewHTML.loadHTMLString(html, baseURL: baseUrl)
    }
    
    //put some html files at the top (like a web page)
    func assembleHTML(var html: String) -> String {
        let fileMgr = NSFileManager.defaultManager()
        let hPath = NSBundle.mainBundle().pathForResource("site/header", ofType: "html")!
        let fPath = NSBundle.mainBundle().pathForResource("site/footer", ofType: "html")!
        var hContent: String?
        var fContent: String?
        if fileMgr.fileExistsAtPath(hPath) && fileMgr.fileExistsAtPath(fPath) {
            do {
                hContent = try String(contentsOfFile: hPath, encoding: NSUTF8StringEncoding)
                fContent = try String(contentsOfFile: fPath, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                print("error:\(error)")
            }
        } else {
            print("not found")
        }
        html = hContent! + html + fContent!
        return html;
    }
    
    //build a data parameter string from today
    func getDateParams() -> String {
        //get today
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day, .Month, .Year], fromDate: date)
        let day = components.day
        let month = components.month
        let year = components.year
        //The link below is used to get the date to use for getting the html data for showing the lunch.
        //http://myschooldining.com/RockhurstHighSchool/calendarWeek?current_day=2016-09-01&adj=0
        return "current_day=\(year)-\(month)-\(day)&adj=0"
    }
    
    //HTTP POST method
    func post(url : String, params : String, successHandler: (response: String) -> Void) {
        let url = NSURL(string: url)
        let params = String(params);
        let request = NSMutableURLRequest(URL: url!);
        request.HTTPMethod = "POST"
        request.HTTPBody = params.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            //in case of error
            if error != nil {
                return
            }
            
            let responseString : String = String(data: data!, encoding: NSUTF8StringEncoding)!
            successHandler(response: responseString)
        }
        task.resume();
    }
    
    //the view did load, successfully i suppose
    override func viewDidLoad() {
        super.viewDidLoad()
        //Original url http://myschooldining.com/RockhurstHighSchool/calendarWeek
        let url = "https://tannerstechtips.com"
        post(url, params: getDateParams(), successHandler: {(response) in self.updateWebview(response)});
    }
    
    //a warning, probably not going to occur in this app - maybe some other apps take up too much memory though (but they'd be serialized to disk, ya?)
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

