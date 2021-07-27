//
//  TaskListTableViewController.swift
//  TestTaskListCoreData3
//
//  Created by User on 5/13/21.
//  Copyright © 2021 User. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController {

    var arrayOfTask = [Task]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var curCategory: Category? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTaskFromDB()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfTask.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)

        cell.textLabel?.text = arrayOfTask[indexPath.row].name

        return cell
    }

    @IBAction func addbuttonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "new Task", message: "Type of task's name", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "name"
        }
        let alertAction = UIAlertAction(title: "OK", style: .default) { [weak alert, self] _ in
            if let textFields = alert?.textFields, let newNameString = textFields[0].text {
                self.addNewTask(with: newNameString)
            }
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }

    func addNewTask(with name: String) {
        let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.newBackgroundContext()
        
        let task = Task(context: context)
        task.name = name
        if let category = curCategory {
            task.parent = category
        }
        
        arrayOfTask.append(task)
        tableView.reloadData()
        //        DispatchQueue.main.async {
        do {
            try self.context.save()
        } catch {
            let error = error
            print(error)
        }
        //        }
        
    }

    func loadTaskFromDB() {
        if let categoty = curCategory {
            let condition = NSPredicate(format: "parent == %@", categoty)
            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [condition])
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = condition
            do {
                arrayOfTask = try context.fetch(fetchRequest)
            } catch {
                let error = error
                print(error)
            }
        }
    }

}
