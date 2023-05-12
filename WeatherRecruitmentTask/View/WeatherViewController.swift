//
//  WeatherViewController.swift
//  WeatherRecruitmentTask
//
//  Created by Marcin Bartminski on 12/05/2023.
//

import UIKit
import RxSwift
import RxCocoa

class WeatherViewController: UITableViewController {
    
    let detailsArray = ["Min temperature", "Max temperature", "Cloud coverage", "Latitude", "Longitude", "Sunrise", "Sunset"]
    
    var model: WeatherViewModel?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
        bindTitle()
        bindTableView()
    }
    
    // MARK: - TableView methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? nil : "Details"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? 1 : detailsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherOverviewCell") as! WeatherOverviewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherDetailCell") as! WeatherDetailCell
            cell.nameLabel.text = detailsArray[indexPath.item]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.deselectRow(at: indexPath, animated: false)
        return nil
    }
    
    // MARK: - Rx methods
    
    private func bindTitle() {
        model?.weatherData.asObservable()
            .subscribe(onNext: { [unowned self] data in
                DispatchQueue.main.async {
                    self.navigationItem.title = data?.name ?? "---"
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        model?.weatherData.asObservable()
            .subscribe(onNext: { [unowned self] data in
                DispatchQueue.main.async {
                    let overviewCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! WeatherOverviewCell
                    let config = UIImage.SymbolConfiguration(hierarchicalColor: .label)
                    overviewCell.symbolImageView.image = self.model?.icon(for: data?.weather.first!.id ?? 0)?.applyingSymbolConfiguration(config)
                    overviewCell.conditionLabel.text = data?.weather.first!.main ?? ""
                    overviewCell.tempLabel.text = self.model?.temperatureString(from: data?.main.temp, to: .celsius)
                    
                    let minTempCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! WeatherDetailCell
                    minTempCell.valueLabel.text = self.model?.temperatureString(from: data?.main.tempMin, to: .celsius)
                    let maxTempCell = self.tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! WeatherDetailCell
                    maxTempCell.valueLabel.text = self.model?.temperatureString(from: data?.main.tempMax, to: .celsius)
                    
                    let cloudsCell = self.tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as! WeatherDetailCell
                    cloudsCell.valueLabel.text = data?.clouds.all.percentString()
                    
                    let latCell = self.tableView.cellForRow(at: IndexPath(row: 3, section: 1)) as! WeatherDetailCell
                    latCell.valueLabel.text = data?.coord.lat.toString()
                    let lonCell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 1)) as! WeatherDetailCell
                    lonCell.valueLabel.text = data?.coord.lon.toString()
                    
                    let timezone = data?.timezone ?? 0
                    let sunriseCell = self.tableView.cellForRow(at: IndexPath(row: 5, section: 1)) as! WeatherDetailCell
                    sunriseCell.valueLabel.text = data?.sys.sunrise.toTimeOfDay(timezone)
                    let sunsetCell = self.tableView.cellForRow(at: IndexPath(row: 6, section: 1)) as! WeatherDetailCell
                    sunsetCell.valueLabel.text = data?.sys.sunset.toTimeOfDay(timezone)
                }
            })
            .disposed(by: disposeBag)
    }
    
}

class WeatherOverviewCell: UITableViewCell {
    @IBOutlet weak var symbolImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
}

class WeatherDetailCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
}
