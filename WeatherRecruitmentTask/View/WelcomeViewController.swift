//
//  WelcomeViewController.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 11/05/2023.
//

import UIKit

class WelcomeViewController: UITableViewController {
    
    var callType: WeatherCallType = .none
    var determinedCity: String = ""
    
    private let numberOfSections = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - TableView methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return CellData.welcomeHeadersArray[section]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abs(section - 3)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityNameCell") as! CityNameCell
            cell.cityLabel.text = CellData.welcomeCellArray[indexPath.item]
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! InputCell
            cell.inputTextField.placeholder = CellData.welcomeCellArray[indexPath.item + 3]
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InputCell") as! InputCell
            cell.inputTextField.placeholder = CellData.welcomeCellArray[5]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            handleCityTap(at: indexPath)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let latCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! InputCell
        let lonCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! InputCell
        let cityCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! InputCell
        
        if !latCell.inputTextField.text!.isEmpty && !lonCell.inputTextField.text!.isEmpty {
            callType = .latLon
            performSegue(withIdentifier: "showWeather", sender: nil)
        } else if !cityCell.inputTextField.text!.isEmpty {
            callType = .city
            performSegue(withIdentifier: "showWeather", sender: nil)
        } else {
            
        }
    }
    
    // MARK: - Segue method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showWeather" else { return }
        let destination = segue.destination as! WeatherViewController
        
        let latCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! InputCell
        let lonCell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! InputCell
        let cityCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as! InputCell
        
        switch callType {
        case .city:
            destination.model = WeatherViewModel(cityName: cityCell.inputTextField.text!)
        case .cityDetermined:
            destination.model = WeatherViewModel(cityName: determinedCity)
        case .latLon:
            let lat = Double(latCell.inputTextField.text!) ?? 0.0
            let lon = Double(lonCell.inputTextField.text!) ?? 0.0
            destination.model = WeatherViewModel(lat: lat, lon: lon)
        case .none:
            break
        }
    }
    
    // MARK: - methods
    
    func handleCityTap(at indexPath: IndexPath) {
        determinedCity = CellData.welcomeCellArray[indexPath.item]
        callType = .cityDetermined
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showWeather", sender: nil)
    }
    
}

class CityNameCell: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    
}

class InputCell: UITableViewCell {
    
    @IBOutlet weak var inputTextField: UITextField!
    
}

enum WeatherCallType {
    case city
    case cityDetermined
    case latLon
    case none
}

