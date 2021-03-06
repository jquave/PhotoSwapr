//
//  ViewController.swift
//  PhotoSwapr
//
//  Created by Jameson Quave on 9/28/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        return 10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageTableViewCell") as ImageTableViewCell
        
        return cell
    }

}

