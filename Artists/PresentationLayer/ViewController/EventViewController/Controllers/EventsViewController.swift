import UIKit
import RealmSwift

final class EventsViewController: UITableViewController {
    // MARK: Constants
    
    private enum Const {
        static let borderWidth: CGFloat = 0.3
        static let shadowRadius: CGFloat = 8
        static let heightForRow: CGFloat = 140
        static let color = #colorLiteral(red: 0.828555796, green: 0.9254013334, blue: 1, alpha: 1)
    }
    
    // MARK: Private Properties
    
    private var networkServices = NetworkServices()
    private var events = [Event]()
    private var eventURL: String?
    private var eventName: String?
    private var eventCell = EventsCell()
    private var cancelButton = UIButton()
    
    // MARK:  Initializers
    
    init(currentEvent: [Event]) {
        self.events = currentEvent
        super.init(nibName: nil, bundle: nil)
        title = currentEvent.first?.artist?.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = Const.color
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.tableView.register(EventsCell.self, forCellReuseIdentifier: "Cell")
        cancelButton.backgroundColor = .red
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButton))
    }
    
    // MARK:  Private Methods
    
    @IBAction private func backButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func castomCell(cell: EventsCell) {
        eventCell.layer.borderWidth = Const.borderWidth
        eventCell.layer.borderColor = UIColor.gray.cgColor
        eventCell.layer.shadowColor = UIColor.gray.cgColor
        eventCell.layer.shadowRadius = Const.shadowRadius
    }
}


// MARK: - Extansion Table view data source
extension EventsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        events.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let eventCell = cell as? EventsCell {
            castomCell(cell: eventCell)
            eventCell.backgroundColor = Const.color
            eventCell.configureCell(cell: eventCell, indexPath: indexPath, events: self.events, eventVC: self)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Const.heightForRow
    }
}
