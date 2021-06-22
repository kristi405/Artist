import UIKit

class EventVC: UITableViewController {
    // MARK: Constants
    
    private enum Const {
        static let borderWidth: CGFloat = 0.2
        static let shadowRadius: CGFloat = 7
        static let heightForRow: CGFloat = 100
        static let color = UIColor(named: "Color")
    }
    
    // MARK:  Public Properties
    
    var events = [Event]()
    
    // MARK: Private Properties
    
    private var currentEvent: Event?
    private var indexPath: Int?
    private var eventCell = EventCell()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = Const.color
    }
    
    // MARK: IBActions
    
    @IBAction func showMap(_ sender: UIButton) {
        getIndexPath(sender: sender)
        self.performSegue(withIdentifier: "showMap", sender: self)
    }
    
    @IBAction func showWeb(_ sender: UIButton) {
        getIndexPath(sender: sender)
        self.performSegue(withIdentifier: "showWeb", sender: self)
    }
    
    // MARK:  Private Methods
    
    private func getIndexPath(sender: UIButton) {
        let cell = sender.superview?.superview as! EventCell
        let indexPath = self.tableView.indexPath(for: cell)
        self.indexPath = indexPath?.row
    }
    
    private func castomCell(cell: EventCell) {
        cell.layer.borderWidth = Const.borderWidth
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowRadius = Const.shadowRadius
    }

    // MARK: Navigations segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            guard let indexPath = self.indexPath else {return}
            let mapVC = segue.destination as! MapEvents
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
