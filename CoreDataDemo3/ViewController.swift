//
//  ViewController.swift
//  CoreDataDemo3
//
//  Created by apple_mini on 2019/3/19.
//  Copyright © 2019年 Scode. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    var data = [NSManagedObject]()
    var appDelegate:AppDelegate?
    var context:NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let d = data[indexPath.row]
        let content = d.value(forKey: "content") as! String
        cell.textLabel?.text = content
        return cell
    }
    
    
    @IBAction func addData(_ sender: Any) {
        
        let alert  = UIAlertController(title: "新增", message: "请添加新增信息", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "保存", style: .default) { (action) in
            let textField = alert.textFields![0] 
            self.saveData(content: textField.text!)
            let indexPath = IndexPath(row: self.data.count - 1 , section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in            
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            print("textField:\(textField.text)")
        }
        
        present(alert, animated: true) {
            print("show ")
        }
        
    }
    
    
    func initData(){
        appDelegate = UIApplication.shared.delegate as? AppDelegate
         context = appDelegate?.persistentContainer.viewContext
        
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HisData") //1
        do{
//             let fetchRequests = try context?.fetch(fetchRequest) as? [NSManagedObject]
            //HisData 自带获取方法同1
            let fetchRequests = try context?.fetch(HisData.fetchRequest()) as? [NSManagedObject]
            if let results = fetchRequests{
                data = results
                self.tableView.reloadData()
            }
        }catch{
            fatalError("获取失败")
        }

    }
    
    
    private func saveData(content : String){
        let entity = NSEntityDescription.entity(forEntityName: "HisData", in: self.context!)
        
        let data = NSManagedObject(entity: entity!, insertInto: self.context!)
        
        data.setValue(content, forKey: "content")
        
        do{
            try context?.save()
        }catch{
            fatalError("无法保存")
        }
        
        self.data.append(data)
        
    }
    
}

