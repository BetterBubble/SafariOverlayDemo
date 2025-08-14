
import UIKit

final class ProjectVC: UIViewController {
    
    private let project: Project
    private let cellIdentifier = "ProjectItemCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProjectItemCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        return tableView
    }()
    
    private lazy var overlay: UIView = {
        let effect = UIBlurEffect(style: .systemThinMaterialDark)
        let view = UIVisualEffectView(effect: effect)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    private lazy var visibilityDelegate = VisibilityDelegate { [weak self] in
        self?.view.setNeedsLayout()
        self?.view.layoutIfNeeded()
    }
    
    init(project: Project) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder: ) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(overlay)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let layout = ProjectViewLayoute(
            bounds: view.bounds,
            safeAreaInsets: view.safeAreaInsets,
            visibility: visibilityDelegate.currentVisibility)
        tableView.frame = layout.tableViewFrame
        overlay.frame = layout.overlayFrame
        tableView.contentInset = UIEdgeInsets(
            top: tableView.contentInset.top,
            left: tableView.contentInset.left,
            bottom: layout.overlayFrame.height,
            right: tableView.contentInset.right
        )
        tableView.scrollIndicatorInsets = UIEdgeInsets(
            top: tableView.verticalScrollIndicatorInsets.top,
            left: tableView.horizontalScrollIndicatorInsets.left,
            bottom: layout.overlayFrame.height,
            right: tableView.horizontalScrollIndicatorInsets.right
        )
    }
    
    @objc private func overlayTapped() {
        visibilityDelegate.setVisibility(1, animated: true)
    }
}

extension ProjectVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return project.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProjectItemCell
        let item = project.features[indexPath.row]
        let color = colors[indexPath.row % colors.count]
        cell.configure(with: item, color: color)
        return cell
    }
}

extension ProjectVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ProjectVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            visibilityDelegate.scrollViewWillBeginDragging(scrollView)
        }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        visibilityDelegate.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        visibilityDelegate.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        visibilityDelegate.scrollViewDidEndDecelerating(scrollView)
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
