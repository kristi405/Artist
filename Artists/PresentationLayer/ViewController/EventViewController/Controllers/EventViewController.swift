import UIKit

class EventVC: UITableViewController {
    
    private enum Const {
        static let borderWidth: CGFloat = 0.2
        static let shadowRadius: CGFloat = 7
        static let heightForRow: CGFloat = 100
        static let color = UIColor(named: "Color")
    }
    
    var events = [Event]()
    private var currentEvent: Event?
    private var indexPath: Int?
    private var eventCell = EventCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Const.color
    }
    
    // MARK:  Private Methods
    
    private func castomCell(cell: EventCell) {
        cell.layer.borderWidth = Const.borderWidth
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowRadius = Const.shadowRadius
    }
    
    // MARK: Navigations segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let mapVC = segue.destination as! MapEvents
            guard let indexPath = self.indexPath else {return}
            mapVC.event = events[indexPath]
        } else if segue.identifier == "showWeb" {
            let webVC = segue.destination as! WebViewController
            guard let indexPath = self.indexPath else {return}
            webVC.eventURL = events[indexPath].url
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let eventCell = cell as? EventCell {
            self.indexPath = indexPath.row
            eventCell.configureCell(cell: eventCell, indexPath: indexPath, events: self.events)
            castomCell(cell: eventCell)
            eventCell.backgroundColor = Const.color
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Const.heightForRow
    }
}
