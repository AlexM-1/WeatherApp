//
//  MainController.swift
//  WeatherApp
//
//  Created by Alex M on 29.12.2022.
//

import UIKit

final class MainScreenController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    private let viewModel: MainScreenViewModel
    
    private var pageControl = UIPageControl()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private var orderedViewControllers: [UIViewController] = []
    
    
    private func makeOrderedViewControllers() -> [UIViewController] {
        
        var navContrArray: [UIViewController] = []
        let request = Location.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
        let locations = (try? CoreDataManager.default.contextBackground.fetch(request)) ?? []
        
        
        locations.forEach {location in
            
            let VC = OneLocationVC(viewModel: OneLocationViewModel(coordinator: self.viewModel.coordinator, location: location))
            
            VC.viewModel.location = location
            let NC = UINavigationController(rootViewController: VC)
            navContrArray.append(NC)
        }
        
        if locations.isEmpty {
            let VC = EmptyVC()
            VC.closure = { self.initOrderedViewControllers() }
            let NC = UINavigationController(rootViewController: VC)
            navContrArray.append(NC)
        }
        
        return navContrArray
    }
    
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initOrderedViewControllers() {
        orderedViewControllers = makeOrderedViewControllers()
        
        if let firstViewController =
            self.orderedViewControllers.first {
            self.setViewControllers([firstViewController],
                                    direction: .forward,
                                    animated: true,
                                    completion: nil)
            
            
            self.pageControl.numberOfPages = orderedViewControllers.count
            self.pageControl.currentPage = 0
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        self.navigationController?.isNavigationBarHidden = true
        initOrderedViewControllers()
        configurePageControl()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("CityManagementVCisBeingDismissed"), object: nil, queue: OperationQueue.main) { notification in
            self.initOrderedViewControllers()
        }
    }
    
    
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.minY + 75,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = orderedViewControllers.count
        self.pageControl.currentPage = 0
        
        
        self.pageControl.preferredCurrentPageIndicatorImage = UIImage(systemName: "circle.fill")
        self.pageControl.preferredIndicatorImage = UIImage(systemName: "circle")
        
        self.pageControl.pageIndicatorTintColor = .black
        self.pageControl.currentPageIndicatorTintColor = .black
        
        self.pageControl.isUserInteractionEnabled = false
        
        
        self.view.addSubview(pageControl)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    
    
    
    // MARK: Delegate methords
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.firstIndex(of: pageContentViewController)!
    }
    
    // MARK: Data source functions.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            // return orderedViewControllers.last
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            // return orderedViewControllers.first
            // Uncommment the line below, remove the line above if you don't want the page control to loop.
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
}
