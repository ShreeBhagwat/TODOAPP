//
//  ViewController.swift
//  TODOAPP
//
//  Created by Gauri Bhagwat on 08/03/18.
//  Copyright © 2018 Development. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = [Item]()
 let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        print(dataFilePath)
        
        loadItems()
    }
    
   //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        //Ternary Operator ==>
        //value = condition ? valueIfTrue : valueIffalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }

    //MARK - Tableview Delegate Methods.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        }
    
    //MARK - AddButtonPressed IB Action
    
  
    @IBAction func Add(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
       let alert = UIAlertController(title: "Add New TODO Items", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will hapen when user clicks Add Item button on our UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
           self.saveItems()
            
}
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item "
            print(alertTextField.text!)
            textField = alertTextField
            print(alertTextField.text!)
          
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK - Model Manuplation Method
    
    func saveItems (){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error Encoding item array, \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
      if  let data = try? Data(contentsOf: dataFilePath!){
        let decoder = PropertyListDecoder()
        do {
        itemArray = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding from itemArray, \(error)")
        }
        }
    }
}
