
import UIKit

final class ProjectListVC: UIViewController {
    
    private let projects: [Project]
    private let idCell = "ProjectCell"
    
    init(projects: [Project]) {
        self.projects = projects
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = CustomFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProjectCell.self, forCellWithReuseIdentifier: idCell)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ProjectListVC: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let projectVC = ProjectVC(project: projects[indexPath.item])
        navigationController?.pushViewController(projectVC, animated: true)
    }
}

extension ProjectListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        projects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idCell, for: indexPath) as! ProjectCell
        let color = colors[indexPath.item % colors.count]
        cell.configure(with: projects[indexPath.item].name, color: color)
        return cell
    }
}

private let colors: [UIColor] = [
    .systemBlue,
    .systemGreen,
    .systemOrange,
    .systemPink,
    .systemPurple,
    .systemTeal,
    .systemCyan,
    .systemRed,
    .systemGray,
    .systemBrown
]
