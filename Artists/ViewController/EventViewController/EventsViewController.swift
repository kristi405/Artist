import UIKit
import RealmSwift

final class EventsViewController: UITableViewController {

// MARK:  Properties
    private var networkServices = NetworkServices()
    private var events = [Event]()
    private var eventURL: String?
    private var eventName: String?
    private var eventCell = EventsCell()

    enum Numbers: CGFloat {
        case borderWidth = 0.3
        case shadowRadius = 8
        case heightForRow = 140
    }

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
}

// MARK: - Extansions, Table view data source
extension EventsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let eventCell = cell as? EventsCell {
            castomCell(cell: eventCell)
            eventCell.configureCell(cell: eventCell, indexPath: indexPath, events: self.events, eventVC: self)
        }
        return cell
    }

    private func castomCell(cell: EventsCell) {
        eventCell.layer.borderWidth = Numbers.borderWidth.rawValue
        eventCell.layer.borderColor = UIColor.gray.cgColor
        eventCell.layer.shadowColor = UIColor.gray.cgColor
        eventCell.layer.shadowRadius = Numbers.shadowRadius.rawValue
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Numbers.heightForRow.rawValue
    }
}
