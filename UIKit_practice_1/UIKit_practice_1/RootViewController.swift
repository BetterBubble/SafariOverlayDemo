
import UIKit

class RootViewController: UIViewController {
    
    private lazy var navController = UINavigationController()
    private lazy var projectListVC = ProjectListVC(projects: sampleProjects)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(navController)
        view.addSubview(navController.view)
        navController.didMove(toParent: self)
        navController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupNavigation()
    }

    private func setupNavigation() {
        navController.navigationBar.isHidden = true
        navController.setViewControllers([projectListVC], animated: false)
    }
    
}

