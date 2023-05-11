//
//  WelcomeViewController.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 11/05/2023.
//

import UIKit

class WelcomeViewController: UITableViewController {
    
    let cellArray = ["Delhi", "Berlin", "Toronto", "Latitude", "Longitude", "City name"]
    let headersArray = ["Choose a city", "Search a location", "Search a city"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headersArray[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abs(section - 3)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameCell") as! CityNameCell
            cell.cityLabel.text = cellArray[indexPath.item]
            return cell
            
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! InputCell
            cell.inputTextField.placeholder = cellArray[indexPath.item + 3]
            return cell
            
        case 2:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! InputCell
            cell.inputTextField.placeholder = cellArray[5]
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

class CityNameCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    
}

class InputCell: UITableViewCell {
    
    @IBOutlet weak var inputTextField: UITextField!
    
}

