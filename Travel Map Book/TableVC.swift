//
//  TableVC.swift
//  Travel Map Book
//
//  Created by Yıldız Uysal on 30.05.2019.
//  Copyright © 2019 Yıldız Uysal. All rights reserved.
//

import UIKit
import CoreData

class TableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var titleArray = [String]()
    var subtitleArray = [String]()
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()

    @IBOutlet weak var tableView: UITableView!
    
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    
    
    @IBAction func addButtonClick(_ sender: Any) {
        selectedTitle = ""
        performSegue(withIdentifier: "ToMapVC", sender: nil)
        
        
    }
    
    @objc func fetchData(){
        titleArray.removeAll(keepingCapacity: false)
        latitudeArray.removeAll(keepingCapacity: false)
        longitudeArray.removeAll(keepingCapacity: false)
        subtitleArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            if results.count > 0 {
                
                for result in results as! [NSManagedObject]{
                    if let title = result.value(forKey: "title") as? String{
                        self.titleArray.append(title)
                    }
                    if let subtitle = result.value(forKey: "subtitle") as? String{
                        self.subtitleArray.append(subtitle)
                    }
                    if let latitude = result.value(forKey: "latitude") as? Double{
                        self.latitudeArray.append(latitude)
                    }
                    if let longitude = result.value(forKey: "longitude") as? Double{
                        self.longitudeArray.append(longitude)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
            print("fetch data çalıştı")
        } catch  {
            print("Error var canısı ")
        }
        
        
    }
    
    @IBAction func buttonDeleteAllClick(_ sender: Any) {
        //HER şeyi sil Database temizlenmesi
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let Frequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        do{
            let results = try context.fetch(Frequest)
            for result in results as! [NSManagedObject]{
               context.delete(result)
                        titleArray.removeAll()
                        latitudeArray.removeAll()
                        longitudeArray.removeAll()
                        subtitleArray.removeAll()
                  self.tableView.reloadData()
                do{
                      try context.save()
                    
                    print("silindi ")
                }catch{
                    
                    print("silinmedi ")
                }
            }
            
        }
        catch{
            
            print("Error var silinmedi ")
        }
        
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTitle = titleArray[indexPath.row]
        selectedSubtitle = subtitleArray[indexPath.row]
        selectedLongitude = longitudeArray[indexPath.row]
        selectedLatitude = latitudeArray[indexPath.row]
        
        performSegue(withIdentifier: "ToMapVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMapVC"{
            let destinationVC = segue.destination as! MapVC
            destinationVC.selectedTitle = self.selectedTitle
            destinationVC.selectedSubtitle = self.selectedSubtitle
            destinationVC.selectedLongitude = self.selectedLongitude
            destinationVC.selectedLatitude = self.selectedLatitude
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    @objc func GeriDonme() {
         selectedTitle = ""
         selectedSubtitle = ""
         selectedLatitude = 0
         selectedLongitude  = 0
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("çalıştı anam babam")
        NotificationCenter.default.addObserver(self, selector: #selector(TableVC.fetchData), name: NSNotification.Name(rawValue: "newPlace"), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(TableVC.GeriDonme), name: NSNotification.Name(rawValue: "geriDönme"), object: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            //Databaseden silme
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let Frequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            
            do{
                let results = try context.fetch(Frequest)
                for result in results as! [NSManagedObject]{
                    if let name = result.value(forKey: "title") as? String{
                        if name == titleArray[indexPath.row]{
                            context.delete(result)
                            titleArray.remove(at: indexPath.row)
                            latitudeArray.remove(at: indexPath.row)
                            longitudeArray.remove(at: indexPath.row)
                            subtitleArray.remove(at: indexPath.row)
                            do{
                                try context.save()
                                
                                print("çalıştı delete ")
                            }
                            catch{
                                
                                print("Error var delete ")
                            }
                            
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            break
                        }
                    }
                }
                    
                
            }catch{
                
                print("delete olmadı yav ")
            }
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    
}
