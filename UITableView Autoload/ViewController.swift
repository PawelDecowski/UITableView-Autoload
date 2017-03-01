//
//  ViewController.swift
//  UITableView Autoload
//
//  Created by Pawel Decowski on 01/03/2017.
//  Copyright © 2017 Relish Media Ltd. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var c: Int = 0
    var reloading: Bool = false
    
    var messages = [Message]()

    override func viewDidLoad() {
        super.viewDidLoad()

        addData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "TableCell")
        }
        
        cell!.textLabel!.text = messages.reversed()[indexPath.row].body
        
        return cell!
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y > 0 || reloading == true) {
            return
        }
        
        reloading = true
        
        let prevHeight = tableView.contentSize.height
        
        loadMoreData(completion: {() -> Void in
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()
            
            let height = self.tableView.contentSize.height
            
            self.tableView.contentOffset.y = height - prevHeight
            
            self.reloading = false
        })
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Loading…"
    }
    
    func loadMoreData(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            self.addData()

            completion()
        })
    }
    
    func addData() {
        for _ in 1...20 {
            c += 1
            messages.append(Message(body: "\(c)"))
        }
    }
}

