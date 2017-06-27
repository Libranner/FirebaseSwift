//
//  ListTableViewController.swift
//  FirebaseSwift
//
//  Created by Libranner Leonel Santos Espinal on 6/26/17.
//  Copyright © 2017 swiftdo. All rights reserved.
//

import UIKit
import Firebase

class ListTableViewController: UITableViewController {

    var ref: DatabaseReference!
    var listItems: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _refRemoveHandle: DatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDatabase()

        //Persist all the stuff!
        ref.keepSynced(true)
    }

    deinit {
        ref.child("list").removeObserver(withHandle: _refHandle)
        ref.child("list").removeObserver(withHandle: _refRemoveHandle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // dequeue cell
        let cell: UITableViewCell! = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let itemSnapshot: DataSnapshot! = listItems[indexPath.row]
        let listItem =  itemSnapshot.value as! [String: String]

        let text =  listItem["text"] ?? "[text]"
        cell.textLabel?.text = text

        return cell!
        // TODO: update cell to display message data
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let item = self.listItems[indexPath.row]
            ref.child("list/\(item.key)").removeValue()
        }
    }

    func configureDatabase() {
        ref = Database.database().reference()
        _refHandle = ref.child("list").observe(.childAdded) { (snapshot: DataSnapshot) in
            self.listItems.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.listItems.count - 1, section: 0)],
                                      with: .automatic)
        }

        _refRemoveHandle = ref.child("list").observe(.childRemoved) { (snapshot: DataSnapshot) in
            var index = -1
            for element in self.listItems {
                index += 1
                if snapshot.key == element.key {
                    self.listItems.remove(at: index)
                    self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .bottom)
                }
            }
        }
    }
}
