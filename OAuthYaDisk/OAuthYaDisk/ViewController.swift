import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private var token = ""
    private var first = true


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if first {
            updateData()
        }
        first = false
    }
    
    
    func setupViews() {

        view.backgroundColor = .yellow
        
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
        
        guard !token.isEmpty else {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            present(requestTokenViewController, animated: true, completion: nil)
            return
        }
            
        
        //TODO: download images from disk
    }
}

extension ViewController : AuthViewControllerDelegate {
    func handleTokenChanged(token: String) {
        self.token = token
        print(token)
        updateData()
    }
}
