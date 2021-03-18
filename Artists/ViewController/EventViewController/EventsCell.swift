import UIKit

final class EventsCell: UITableViewCell {
    
    private var eventVC: EventsViewController?
    private var events: [Event]?
    
      private var dataLabel = UILabel()
    private var countryLabel = UILabel()
    private var cityLabel = UILabel()
    private var mapButton = UIButton()
    private var labelStackView = UIStackView()
    private var goOverButton = UIButton()
    private var buttonStackView = UIStackView()

private enum Numbers: CGFloat {
    case stackViewSpacing = 20
    case buttonStackViewSpacing = 10
    case shadowWidth = 1
    case shadowHight = 0.5
    case stackViewTopAnchor = 17
    case stackViewLeadingAnchor = 15
    case stackViewTrailingAnchor = -185
    case buttonStackViewBottomAnchor = -20
    case buttonStackViewTrailingAnchor = -45
}
    
    func configureCell(cell: EventsCell, indexPath: IndexPath, events: [Event], eventVC: EventsViewController) {
        
        self.eventVC = eventVC
        self.events = events
        let event = events[indexPath.row]
        
        cell.dataLabel.text = event.datetime
        dataLabel.shadowColor = .gray
        dataLabel.shadowOffset = CGSize(width: Numbers.shadowWidth.rawValue, height: Numbers.shadowWidth.rawValue)
        
        countryLabel.text = event.venue?.country
        countryLabel.shadowColor = .gray
        countryLabel.shadowOffset = CGSize(width: Numbers.shadowHight.rawValue, height: Numbers.shadowHight.rawValue)
        
        cityLabel.text = event.venue?.city
        cityLabel.shadowColor = .gray
        cityLabel.shadowOffset = CGSize(width: Numbers.shadowHight.rawValue, height: Numbers.shadowHight.rawValue)
        
        mapButton.setImage(#imageLiteral(resourceName: "pinMap-1"), for: .normal)
        
        goOverButton.setGoOverImage()
        goOverButton.customButton(button: goOverButton)
        
        labelStackView = UIStackView(arrangedSubviews: [dataLabel, countryLabel, cityLabel], axis: .vertical, spacing: Numbers.stackViewSpacing.rawValue)
        buttonStackView = UIStackView(arrangedSubviews: [mapButton, goOverButton], axis: .horizontal, spacing: Numbers.buttonStackViewSpacing.rawValue)
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        cell.addSubview(labelStackView)
        cell.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: cell.topAnchor, constant: Numbers.stackViewTopAnchor.rawValue),
            labelStackView.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: Numbers.stackViewLeadingAnchor.rawValue),
            labelStackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: Numbers.stackViewTrailingAnchor.rawValue),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: Numbers.buttonStackViewBottomAnchor.rawValue),
            buttonStackView.leadingAnchor.constraint(equalTo: labelStackView.trailingAnchor, constant: Numbers.buttonStackViewSpacing.rawValue),
            buttonStackView.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: Numbers.buttonStackViewTrailingAnchor.rawValue)
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
