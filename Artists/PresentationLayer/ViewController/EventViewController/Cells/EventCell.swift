import UIKit

class EventCell: UITableViewCell {

    @IBOutlet private weak var dataLabel1: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!

    func configureCell(event: Event) {
        dataLabel1.text = event.datetime
        cityLabel.text = event.venue?.city
        countryLabel.text = event.venue?.country
    }
}
