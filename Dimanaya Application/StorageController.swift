//
//  StorageController.swift
//  Dimanaya Application
//
//  Created by Atikah Febrianti Nastiti on 28/04/22.
//

import UIKit
import CoreData

class StorageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var models = [StorageList]()
    
    var selectedProductCategories: ProductItem = ProductItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedProductCategories.name
        view.addSubview(tableView)
        getAllItems(productName: selectedProductCategories.name)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Storage",
                                      message: "Enter New Storage Name",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        
        present(alert, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    //Method ketika slide salah satu cell
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = models[indexPath.row]
        
        //delete
        let delete = UIContextualAction(style: .normal,
                                        title: "Delete") { [weak self] (action, view, completionHandler) in
            self?.deleteItem(item: item)
            completionHandler(true)
        }
        delete.backgroundColor = .systemRed
        
        //edit
        let edit = UIContextualAction(style: .normal,
                                      title: "Edit") { [weak self] (action, view, completionHandler) in
            self?.showEditAlert(item: item)
            completionHandler(true)
        }
        edit.backgroundColor = .systemGreen
        let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return configuration
    }
    
    func showEditAlert(item: StorageList) {
        let alert = UIAlertController(title: "Edit Item",
                                      message: "Edit your storage name",
                                      preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.textFields?.first?.text = item.name
        alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: {[weak self] _ in
            guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                return
            }
            self?.updateItem(item: item, newName: newName)
        }))
        self.present(alert, animated: true)
    }
    
    //Untuk ganti antar scene navigation controller (bisa dipake buat button juga)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let storageController = storyBoard.instantiateViewController(withIdentifier: "StorageStoryboard") as! StorageController
        self.navigationController?.pushViewController(storageController, animated: true)
    }
    
    //CORE DATA
    func getAllItems(productName: String?){
        let predicate = NSPredicate(format: "productName == %@", productName!)
        let fetchRequest = NSFetchRequest<StorageList>(entityName:"StorageList")
        fetchRequest.predicate = predicate
                            
        do{
            models = try context.fetch(fetchRequest)
            print(models)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
                    
        }catch let err{
            print("Error in updating",err)
        }
    }
    
    func createItem(name: String){
        let newItem = StorageList(context: context)
        newItem.name = name
        newItem.productName = selectedProductCategories.name
        
        do {
            try context.save()
            
            getAllItems(productName: selectedProductCategories.name)
        }
        catch{
            
        }
    }
    
    func deleteItem(item: StorageList) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems(productName: selectedProductCategories.name)
        }
        catch{
            
        }
    }
    
    func updateItem(item: StorageList, newName: String){
        item.name = newName
        
        do {
            try context.save()
            getAllItems(productName: selectedProductCategories.name)
        }
        catch{
            
        }
    }
    
}



