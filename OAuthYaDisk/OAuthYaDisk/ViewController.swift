import UIKit

class ViewController: UIViewController {
    private let tableView = UITableView()
    private var token = ""
    private var first = true
    private var fileData : DiskResponse?

    private var imagesArray = [UIImage]()

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

        view.backgroundColor = .white
        
        title = "Мои фото"

        tableView.dataSource = self
        tableView.register(FileTableViewCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        
        
    }


    func updateData() {
        
        guard !token.isEmpty else {
            let requestTokenViewController = AuthViewController()
            requestTokenViewController.delegate = self
            present(requestTokenViewController, animated: true, completion: nil)
            return
        }
            
        
        var components = URLComponents(string: "https://cloud-api.yandex.net/v1/disk/resources/files")
        components?.queryItems = [URLQueryItem(name: "media_type", value: "image")]
        
        guard let url = components?.url else { return }
        
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, let sself = self else { return }
            
            guard let newFiles = try? JSONDecoder().decode(DiskResponse.self, from: data) else { return }
            sself.fileData = newFiles

            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        task.resume()
        
    }
    
    let cellId = "FileTableViewCell"
    
    func imageStuff(im : UIImage) {
        
    }
    
    func loadImage(with url : String, imSt : @escaping (UIImage) -> ()) {
        
        var resImage = UIImage(named: "chris")
        
        guard let url = URL(string: url) else {
            imSt(resImage!)
            return
        }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, resp, er in
            guard let data = data else { return }
            print(url)
            guard let image = UIImage(data: data) else { return }

            
            DispatchQueue.main.async {
                resImage = image
                imSt(resImage!)
            }
        }.resume()
    }
}

extension ViewController : AuthViewControllerDelegate {
    func handleTokenChanged(token: String) {
        self.token = token
        updateData()
    }
}


extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileData?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        guard let items = fileData?.items, items.count > indexPath.row else { return cell }
        
        if let fileCell = cell as? FileTableViewCell {
            
            fileCell.delegate = self
            fileCell.bindModel(model: items[indexPath.row])
        }
        
        return cell
    }
}


extension ViewController : FileTableViewCellDelegate {
    func loadImage(with url: String, completion: @escaping ((UIImage?) -> ())) {
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
}
