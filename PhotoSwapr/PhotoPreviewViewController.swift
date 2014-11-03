//
//  PhotoPreviewViewController.swift
//  PhotoSwapr
//
//  Created by Jameson Quave on 11/3/14.
//  Copyright (c) 2014 JQ Software LLC. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {
    var photo : UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(photo != nil, "The 'photo' variable is nil in PhotoPreviewViewController. How are we going to preview a photo if it's nil!?")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
