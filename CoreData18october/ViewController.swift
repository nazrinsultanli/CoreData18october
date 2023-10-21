//
//  ViewController.swift
//  CoreData18october
//
//  Created by Nazrin Sultanlı on 18.10.23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let context = AppDelegate().persistentContainer.viewContext
    var items = [ToDoList]()

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        fetchData()
    }

    func saveData(text: String, definition: String){
        do{
            let model = ToDoList(context: context)
            model.title = text
            model.definition = definition
            try context.save()
            fetchData()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchData(){
        do{
            items = try context.fetch(ToDoList.fetchRequest())
            tableView.reloadData()
        } catch{
            print(error.localizedDescription)
        }
    }
    
    func deleteData(indexPath: Int){
        
        context.delete(items[indexPath])
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func editUpdateData(index: Int, newText: String, newdefinition: String){
        let updatedData = items[index]
        updatedData.title = newText
        updatedData.definition = newdefinition
        
        do{
            try context.save()
            fetchData()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Enter new item", message: "", preferredStyle: .alert)
        
        alertController.addTextField{ textfield in
            textfield.placeholder = "Enter new Item"
        }
        alertController.addTextField{ textfield in
            textfield.placeholder = "Enter definition Item"
        }
        
        let okayButton  = UIAlertAction(title: "Add", style: .default){_ in
            let text = alertController.textFields?[0].text ?? ""
            let definition = alertController.textFields?[1].text ?? ""
            self.saveData(text: text, definition: definition)
        }
        let cancelButtton = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okayButton)
        alertController.addAction(cancelButtton)
        present(alertController,animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(items[indexPath.row].title ?? "") \n\(items[indexPath.row].definition ?? "")"
        //cell.textLabel?.text = "\(items[indexPath.row].title)\n \()"
        return cell
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        deleteData(indexPath: indexPath.row)
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
        alertController.addTextField{ textfield in
            textfield.placeholder = "Enter new Item"
            textfield.text = self.items[indexPath.row].title
        }
        alertController.addTextField{ textfield in
            textfield.placeholder = "Enter definition Item"
            textfield.text = self.items[indexPath.row].definition
        }
        let saveButton  = UIAlertAction(title: "Save", style: .default){_ in
            let newText = alertController.textFields?[0].text ?? ""
            let newDefinition = alertController.textFields?[1].text ?? ""
            self.editUpdateData(index: indexPath.row , newText: newText, newdefinition: newDefinition)
        }
        let cancelButtton = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(saveButton)
        alertController.addAction(cancelButtton)
        present(alertController,animated: true)
    }
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            context.delete(items[indexPath.row])
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            do{
                try context.save()
            }
            
            catch{
                print(error.localizedDescription)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }*/
    
    
    
}

