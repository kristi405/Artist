//
//  EventsViewController.swift
//  Artists
//
//  Created by kris on 13/11/2020.
//  Copyright © 2020 kris. All rights reserved.
//

import UIKit
import RealmSwift

class EventsViewController: UITableViewController {
    
    var networkServices = NetworkServices()
    private var events = [Event]()
    var eventURL: String?
    var eventName: String?
    let mapManeger = MapManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(EventsCell.self, forCellReuseIdentifier: "Cell")
    }
    
    init(currentEvent: [Event]) {
        self.events = currentEvent
        super.init(nibName: nil, bundle: nil)
        title = currentEvent.first?.artist?.name
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EventsCell
        DispatchQueue.main.async {
            self.configureCell(cell: cell, indexPath: indexPath)
            tableView.reloadData()
        }
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowRadius = 8
        
        return cell
    }

    private func configureCell(cell: EventsCell, indexPath: IndexPath) {

        let dataLabel = UILabel(frame: CGRect(x: 5, y: 10, width: 180, height: 50))
        dataLabel.textAlignment = .center
        dataLabel.text = events[indexPath.row].datetime
        dataLabel.numberOfLines = 0
        dataLabel.shadowColor = .gray
        dataLabel.shadowOffset = CGSize(width: 1, height: 1)
        cell.addSubview(dataLabel)
        
        let countryLabel = UILabel(frame: CGRect(x: 10, y: 70, width: 150, height: 20))
        countryLabel.textAlignment = NSTextAlignment.center
        countryLabel.text = events[indexPath.row].venue?.country
        countryLabel.shadowColor = .gray
        countryLabel.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.addSubview(countryLabel)
        
        let cityLabel = UILabel(frame: CGRect(x: 10, y: 110, width: 150, height: 20))
        cityLabel.textAlignment = NSTextAlignment.center
        cityLabel.text = events[indexPath.row].venue?.city
        cityLabel.shadowColor = .gray
        cityLabel.shadowOffset = CGSize(width: 0.5, height: 0.5)
        cell.addSubview(cityLabel)
        
        let mapButton = UIButton(frame: CGRect(x: 345, y: 75, width: 50, height: 50))
        mapButton.setImage(#imageLiteral(resourceName: "pin-map-7"), for: .normal)
        cell.addSubview(mapButton)
        
        let goOverButton = UIButton(frame: CGRect(x: 210, y: 85, width: 125, height: 30))
        goOverButton.setGoOverImage()
        goOverButton.customButton(button: goOverButton)
        cell.addSubview(goOverButton)
        
        let tapGesture = CustomTapGesture(target: self, action: #selector(showWeb(_:)))
        tapGesture.indexPath = indexPath
        goOverButton.addGestureRecognizer(tapGesture)
        
        let tapGestureMap = CustomTapGesture(target: self, action: #selector(showMap(_:)))
        tapGestureMap.indexPath = indexPath
        mapButton.addGestureRecognizer(tapGestureMap)
    }
    
    @objc func  showWeb(_ sender: UITapGestureRecognizer) {
        if let sender = sender as? CustomTapGesture {
            guard let indexPath = sender.indexPath else {return}
            let webVC = WebViewController()
            webVC.eventURL = events[indexPath.row].url
            present(webVC, animated: true, completion: nil)
        }
    }
    
    @objc func  showMap(_ sender: UITapGestureRecognizer) {
        if let sender = sender as? CustomTapGesture {
            guard let indexPath = sender.indexPath else {return}
            let mapVC = MapEvents()
            mapVC.event = self.events[indexPath.row]
            present(mapVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 140
       }
}
