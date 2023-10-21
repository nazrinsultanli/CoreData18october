//
//  RealmViewController.swift
//  CoreData18october
//
//  Created by Nazrin Sultanlı on 20.10.23.
//

import UIKit
import RealmSwift

class ToDoListRealm: Object{
    @Persisted var ntitle: String = ""
    @Persisted var ndescription: String = ""
//    @Persisted var nazrin:String = ""
}

class RealmViewController: UIViewController{

    var itemsss = [ToDoListRealm]()
    let realmss = try! Realm()

    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        
        if let url = realmss.configuration.fileURL {
            print(url)
        }

        fetch()
        
    }
    
    func fetch(){
        let data = realmss.objects(ToDoListRealm.self)
        itemsss.removeAll()
        itemsss.append(contentsOf: data)
        myTableView.reloadData()
    }

    
    func saveItems(text: String, description: String){
        let item = ToDoListRealm()
        item.ntitle = text
        item.ndescription = description
        do{
            try realmss.write{
                realmss.add(item)
                fetch()
//                items.append(item)
//                myTableView.reloadData()
//                myTableView.insertRows(at: [IndexPath(row: itemsss.count-1, section: 0)], with: .fade)
            }
        } catch{
            print(error.localizedDescription)
        }
    }
    
//    func editUpdateData(index: Int , newText: String, newdefinition: String){        
//        let updatedData = realmss.objects(.self).first!
////        let updatedData = itemsss[index]
////        updatedData.ntitle = newText
////        updatedData.ndescription = newdefinition
//        
//        do{
//            try realmss.write{
//                realmss.add(updatedData)
//                fetch()
//            }
//        }
//        catch{
//            print(error.localizedDescription)
//        }
//    }
    
    func deleteData(indexPath: Int){
        
        do{
            try realmss.write{
                realmss.delete(itemsss[indexPath])
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
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
            self.saveItems(text: text, description: definition)
        }
        let cancelButtton = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(okayButton)
        alertController.addAction(cancelButtton)
        present(alertController,animated: true)
    }
    
    
    

}



extension RealmViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit item", message: "", preferredStyle: .alert)
        alertController.addTextField{ textfield in
            textfield.placeholder = "Enter new Item"
            textfield.text = self.itemsss[indexPath.row].ntitle
        }
        alertController.addTextField{ textfield in
            textfield.placeholder = "Enter definition Item"
            textfield.text = self.itemsss[indexPath.row].ndescription
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemsss.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "myCellRealm", for: indexPath)
        myCell.textLabel?.numberOfLines = 0
        myCell.textLabel?.text = "\(itemsss[indexPath.row].ntitle ) \n\(itemsss[indexPath.row].ndescription )"
        return myCell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        deleteData(indexPath: indexPath.row)
        itemsss.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
