import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private var token = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {

        view.backgroundColor = .white
        
        title = "Мои фото"
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        
    }


    func updateData() {
        //TODO: check token
        
        //TODO: download images from disk
    }
}

