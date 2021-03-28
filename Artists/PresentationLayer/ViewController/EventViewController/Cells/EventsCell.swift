import UIKit

final class EventsCell: UITableViewCell {
    
    // MARK:  Properties
    private var eventVC: EventsViewController?
    private var events: [Event]?
    private var dataLabel = UILabel()
    private var countryLabel = UILabel()
    private var cityLabel = UILabel()
    private var mapButton = UIButton()
    private var labelStackView = UIStackView()
    private var goOverButton = UIButton()
    private var buttonStackView = UIStackView()
    
    func configureCell(cell: EventsCell, indexPath: IndexPath, events: [Event], eventVC: EventsViewController) {
        
        self.eventVC = eventVC
        self.events = events
        let event = events[indexPath.row]
        
        cell.dataLabel.text = event.datetime
        dataLabel.shadowColor = .gray
        dataLabel.shadowOffset = CGSize(width: Const.shadowWidth, height: Const.shadowWidth)
        
        countryLabel.text = event.venue?.country
        countryLabel.shadowColor = .gray
        countryLabel.shadowOffset = CGSize(width: Const.shadowHight, height: Const.shadowHight)
        
        cityLabel.text = event.venue?.city
        cityLabel.shadowColor = .gray
        cityLabel.shadowOffset = CGSize(width: Const.shadowHight, height: Const.shadowHight)
        
        mapButton.setImage(#imageLiteral(resourceName: "pinMap-1"), for: .normal)
        
        goOverButton.setGoOverImage()
        goOverButton.customButton(button: goOverButton)
        
        labelStackView = UIStackView(arrangedSubviews: [dataLabel, countryLabel, cityLabel], axis: .vertical, spacing: Const.stackViewSpacing)
        buttonStackView = UIStackView(arrangedSubviews: [mapButton, goOverButton], axis: .horizontal, spacing: Const.buttonStackViewSpacing)
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(labelStackView)
        cell.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: cell.topAnchor, constant: Const.stackViewTopAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: Const.stackViewLeadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: Const.stackViewTrailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: Const.buttonStackViewBottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: labelStackView.trailingAnchor, constant: Const.buttonStackViewSpacing),
            buttonStackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: Const.buttonStackViewTrailingAnchor)
        ])
        
        let tapGesture = CustomTapGesture(target: self, action: #selector(showWeb(_:)))
        tapGesture.indexPath = indexPath
        goOverButton.addGestureRecognizer(tapGesture)
        
        let tapGestureMap = CustomTapGesture(target: self, action: #selector(showMap(_:)))
        tapGestureMap.indexPath = indexPath
        mapButton.addGestureRecognizer(tapGestureMap)
    }
    
    @IBAction private func showWeb(_ sender: UITapGestureRecognizer) {
        if let sender = sender as? CustomTapGesture {
            guard let indexPath = sender.indexPath else {return}
            let webVC = WebViewController()
            guard let events = self.events else {return}
            webVC.eventURL = events[indexPath.row].url
            
            eventVC!.present(webVC, animated: true, completion: nil)
        }
    }
    
    @IBAction private func showMap(_ sender: UITapGestureRecognizer) {
        if let sender = sender as? CustomTapGesture {
            guard let indexPath = sender.indexPath else {return}
            let mapVC = MapEvents()
            guard let events = self.events else {return}
            mapVC.event = events[indexPath.row]
            
            eventVC!.present(mapVC, animated: true, completion: nil)
        }
    }
}

extension EventsCell {
    private enum Const {
        static let stackViewSpacing: CGFloat = 20
        static let buttonStackViewSpacing: CGFloat = 10
        static let shadowWidth: CGFloat = 1
        static let shadowHight: CGFloat = 0.5
        static let stackViewTopAnchor: CGFloat = 17
        static let stackViewLeadingAnchor: CGFloat = 15
        static let stackViewTrailingAnchor: CGFloat = -185
        static let buttonStackViewBottomAnchor: CGFloat = -20
        static let buttonStackViewTrailingAnchor: CGFloat = -45
    }
}
