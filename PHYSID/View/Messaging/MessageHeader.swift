import UIKit

private let reuseIdentifier = "HeaderCell"

protocol MessageHeaderDelegate: class {
    func controller(_ controller: MessageHeader, wantsToStartChatWith matchedUserUid: String)
}

class MessageHeader: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MessageHeaderDelegate?
    
    var users = [User]() {
        didSet { colletionView.reloadData() }
    }
    
    private lazy var colletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.isPagingEnabled = true
        cv.dataSource = self
        cv.delegate = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(HeaderCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return cv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Followed Users"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)        
        configureUI()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .white
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 8)
        
        addSubview(colletionView)
        colletionView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 6)
    }
}


// MARK: - UICollectionViewDelegate

extension MessageHeader: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension MessageHeader: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeaderCell
        cell.viewModel = MessageHeaderViewModel(user: users[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let uid = users[indexPath.row].uid else { return }
        delegate?.controller(self, wantsToStartChatWith: uid)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout


extension MessageHeader: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 180)
    }
}


