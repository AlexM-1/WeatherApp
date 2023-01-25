//
//  OneLocationVC.swift
//  WeatherApp
//
//  Created by Alex M on 30.12.2022.
//



import UIKit
import CoreData

class OneLocationVC: UIViewController, NSFetchedResultsControllerDelegate {
    

    let viewModel: OneLocationViewModel

    private var fetchedResultsController: NSFetchedResultsController<Forecast>!

    private var refreshControl = UIRefreshControl()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailyForecastCell.self, forCellReuseIdentifier: DailyForecastCell.identifier)
        tableView.register(DailyFactCell.self, forCellReuseIdentifier: DailyFactCell.identifier)
        tableView.register(PerHourTableViewCell.self, forCellReuseIdentifier: PerHourTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        return tableView
    }()
    
    
    init(viewModel: OneLocationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initFetchResultsController() {
        let request = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "location == %@ AND partName == %@", viewModel.location, "day")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.default.contextMain, sectionNameKeyPath: nil, cacheName: nil)
        try? frc.performFetch()
        fetchedResultsController = frc
        fetchedResultsController.delegate = self
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = (viewModel.location?.city ?? "") + ", " + (viewModel.location?.country ?? "")
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        

        self.navigationItem.rightBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(locationButtonTap), imageName: "locationImage", size: CGSize(width: 20, height: 26) , tintColor: .black)
        
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.menuButton(self, action: #selector(settingsButtonTap), imageName: "settings", size: CGSize(width: 34, height: 26) , tintColor: .black)
        

        refreshControl.attributedTitle = NSAttributedString(string: "Потяните вниз, чтобы обновить")
        refreshControl.addTarget(self, action: #selector(pulledRefreshControl), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        setupView()
        initFetchResultsController()
    }
    


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    private func createViewConstraint() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 110),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
        ])
        
        
    }
    
    private func setupView() {
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        createViewConstraint()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.stateChanged = { [weak self] state in
            switch state {
            case .initial:
                print("")
            case .loading:
                DispatchQueue.main.async {
                    self?.activityIndicator.startAnimating()
                }
            case .loaded:
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    self?.initFetchResultsController()
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .error:
                print("error")
            }
        }
    }
    
    
    @objc func locationButtonTap() {
        print("locationButtonTap tapped")
        viewModel.changeState(.locationButtonTap)

    }

    @objc func settingsButtonTap() {
        print("settingsButtonTap tapped")
        viewModel.changeState(.settingsButtonTap)
    }
    
    
    
    @objc func pulledRefreshControl(sender:AnyObject) {
        print("refresh VC")
        viewModel.changeState(.pulledRefresh)

    }
}


//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//         initFetchResultsController()
//             self.tableView.reloadData()
//
//    }
//

extension OneLocationVC: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 { return 1 }
        if section == 1 { return 1 }
        if section == 2 {
            return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: DailyFactCell.identifier, for: indexPath) as! DailyFactCell
            cell.setupCell(location: viewModel.location)
            cell.selectionStyle = .none
            return cell }

        if indexPath.section == 1 {

            let cell = tableView.dequeueReusableCell(withIdentifier: PerHourTableViewCell.identifier, for: indexPath) as! PerHourTableViewCell
            cell.setupCell(location: viewModel.location)
            cell.action = {
                self.viewModel.changeState(.detailButtonTap)
            }
            cell.collectionView.reloadData()

            let df = DateFormatter()
            df.dateFormat = "HH"

            if let currentHour = Int(df.string(from: Date())) {
                let indexToStart = currentHour / 3
                cell.collectionView.scrollToItem(at: IndexPath(row: indexToStart, section: 0), at: .left, animated: true)
            }
            cell.selectionStyle = .none
            return cell
        }


        if indexPath.section == 2 {

            let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastCell.identifier, for: indexPath) as! DailyForecastCell

            let index = IndexPath(row: indexPath.row, section: 0)
            let forecast = fetchedResultsController.object(at: index)
            cell.setupCell(forecast: forecast)
            return cell
        }

        return UITableViewCell()
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            viewModel.changeState(.cellForecastDidSelect(indexPath.row))
        }

        tableView.deselectRow(at: indexPath, animated: true)
        print("didSelectRowAt \(indexPath)")

    }



    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        if section == 2 {
            return ""
        }
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        if section == 2 {

            let header = view as? UITableViewHeaderFooterView
            header?.textLabel?.font = UIFont.init(name: "Rubik-Medium", size: 18)
            header?.textLabel?.text = "Ежедневный прогноз"
            header?.textLabel?.textColor = UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1)
        }

    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 25
    }



    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.01
        }
        return 25
    }


}
