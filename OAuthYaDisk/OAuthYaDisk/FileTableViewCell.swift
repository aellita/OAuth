import UIKit


protocol FileTableViewCellDelegate {
    func loadImage(with url : String, completion : @escaping ((UIImage?) -> ()))
}

class FileTableViewCell: UITableViewCell {
    
    var delegate : FileTableViewCellDelegate?

    private let image = UIImageView()
    private let nameLabel = UILabel()
    private let sizeLabel = UILabel()
    
    private let photoSize = CGSize(width: 80, height: 80)
    private let inset: CGFloat = 16
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
    }
    
    
    func bindModel(model : DiskFile) {
        nameLabel.text = model.name
        sizeLabel.text = "\(model.size!/1024/1024) MB"
        
        delegate?.loadImage(with: model.preview ?? "", completion: { [weak self] im in
            self?.image.image = im
        })
        
    }
    
    func setupViews() {
        image.backgroundColor = .green.withAlphaComponent(0.2)
        image.contentMode = .scaleToFill
        sizeLabel.font = UIFont.systemFont(ofSize: 11)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(image)
        addSubview(nameLabel)
        addSubview(sizeLabel)
        
        sizeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: inset/2),
            image.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset/2),
            image.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            image.widthAnchor.constraint(equalToConstant: photoSize.width),
            image.heightAnchor.constraint(equalToConstant: photoSize.height),
            
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            nameLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: inset),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            
            
            sizeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset/2),
            sizeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sizeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
            
        ])
    }
}
