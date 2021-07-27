//
//  CategoryTableViewController.swift
//  TestTaskListCoreData3
//
//  Created by User on 5/12/21.
//  Copyright © 2021 User. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var arrayOfCategory = [Category]()
    var curCategory: Category? = nil
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategoriesFromDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategory.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = arrayOfCategory[indexPath.row].name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        curCategory = arrayOfCategory[indexPath.row]
        performSegue(withIdentifier: "showTasks", sender: nil)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? TaskListTableViewController {
            destination.curCategory = curCategory
        }
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "new Category", message: "Type of category's name", preferredStyle: .alert)
        alert.addTextField(){textField in
            textField.placeholder = "name"
        }
        let alertAction = UIAlertAction(title: "OK", style: .default) { [weak alert, self] _ in
            if let textFields = alert?.textFields, let newNameString = textFields[0].text {
                self.addNewCategory(with: newNameString)
            }
        }
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
        

    }
    
    func addNewCategory(with name: String) {
        let category = Category(context: context)
        category.name = name
        
        arrayOfCategory.append(category)
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
    
    func loadCategoriesFromDB() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            arrayOfCategory = try context.fetch(request)
        } catch {
            let error = error
            print(error)
        }
    }
    
}
