//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 3/22/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action: "logout")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "add")
    }

    func logout() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController")
        self.presentViewController(controller!, animated: true, completion: nil)
    }


}

