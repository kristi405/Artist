import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var dataLabel1: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    private var events: [Event]?
    
    func configureCell(cell: EventCell, indexPath: IndexPath, events: [Event]) {
        self.events = events
        let event = events[indexPath.row]
        
        cell.dataLabel1.text = event.datetime
        cell.cityLabel.text = event.venue?.city
        cell.countryLabel.text = event.venue?.country
    }
}
