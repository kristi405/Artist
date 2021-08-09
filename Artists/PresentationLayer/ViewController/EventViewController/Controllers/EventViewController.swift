import UIKit

class EventVC: UITableViewController {
    // MARK:  Public Properties
    
    var events = [Event]()
    
    // MARK: Private Properties
    
    private var currentEvent: Event?
    private var indexPath: Int?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = R.color.color()
    }
    
    // MARK: IBActions
    
    @IBAction func showMap(_ sender: UIButton) {
        getIndexPath(sender: sender)
        self.performSegue(withIdentifier: R.segue.eventVC.showMap, sender: self)
    }
    
    @IBAction func showWeb(_ sender: UIButton) {
        getIndexPath(sender: sender)
        self.performSegue(withIdentifier: R.segue.eventVC.showWeb, sender: self)
    }
    
    // MARK:  Private Methods
    
    private func getIndexPath(sender: UIButton) {
        guard let cell = sender.superview?.superview as? EventCell else {return}
        let indexPath = self.tableView.indexPath(for: cell)
        self.indexPath = indexPath?.row
    }
    
    private func castomCell(cell: EventCell) {
        cell.layer.borderWidth = Constants.borderWidthOfCell
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowRadius = Constants.shadowRadius
    }

    // MARK: Navigations segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.segueShowMap else {return}
        guard let indexPath = self.indexPath else {return}
        guard let mapVC = segue.destination as? MapEvents else {return}
        mapVC.event = events[indexPath]
        guard segue.identifier == Constants.segueShowWeb else {return}
        guard let webVC = segue.destination as? WebViewController else {return}
        guard let indexPath = self.indexPath else {return}
        webVC.eventURL = events[indexPath].url
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifire, for: indexPath)
        
        if let eventCell = cell as? EventCell {
            let event = events[indexPath.row]
            eventCell.configureCell(event: event)
            castomCell(cell: eventCell)
            eventCell.backgroundColor = R.color.color()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.heightForRow
    }
}

extension EventVC {
    // MARK: Constants
    
    private enum Constants {
        static let borderWidthOfCell: CGFloat = 0.2
        static let shadowRadius: CGFloat = 7
        static let heightForRow: CGFloat = 100
        static let segueShowMap = "showMap"
        static let segueShowWeb = "showWeb"
        static let reuseIdentifire = "cell"
    }
}
