import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var dataLabel1: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!

    func configureCell(event: Event) {
        dataLabel1.text = event.datetime
        cityLabel.text = event.venue?.city
        countryLabel.text = event.venue?.country
    }
}
