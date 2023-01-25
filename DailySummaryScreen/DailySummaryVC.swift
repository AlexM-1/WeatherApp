//
//  DailySummaryVC.swift
//  WeatherApp
//
//  Created by Alex M on 17.01.2023.
//


import UIKit
import CoreData

final class DailySummaryVC: UIViewController, NSFetchedResultsControllerDelegate {
    
    var location: Location
    private var fetchedResultsController: NSFetchedResultsController<Forecast>!
    
    private var dates : [String] = []
    private var startIndex: Int
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DailySummaryCell.self, forCellReuseIdentifier: DailySummaryCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.sectionHeaderHeight = 0.01
        return tableView
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.register(DailySummaryCollectionCell.self, forCellWithReuseIdentifier: DailySummaryCollectionCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    
    private let locationLabel = CustomLabel(
        titleColor: UIColor(red: 0.154, green: 0.152, blue: 0.135, alpha: 1),
        font: UIFont(name: "Rubik-Medium", size: 18))
    
    
    private lazy var backButton = CustomButton (
        title: "Дневная погода",
        titleColor: UIColor(red: 0.604, green: 0.587, blue: 0.587, alpha: 1),
        font: UIFont(name: "Rubik-Medium", size: 16),
        backgroundColor: .systemBackground,
        image: UIImage(named: "backButton"),
        imagePadding: 20)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    init(location: Location, index: Int) {
        self.location = location
        startIndex = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.scrollToItem(at: IndexPath(row: startIndex, section: 0), at: .left, animated: true)
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    private func initFetchResultsController(with date: String?) {
        let request = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "location == %@ AND date == %@", location, date ?? "")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.default.contextMain, sectionNameKeyPath: nil, cacheName: nil)
        try? frc.performFetch()
        fetchedResultsController = frc
        fetchedResultsController.delegate = self
    }
    
    
    
    private func initDatesToShow() {
        let request = Forecast.fetchRequest()
        request.predicate = NSPredicate(format: "location == %@ AND partName == %@", location, "day")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let context = CoreDataManager.default.contextMain
        let forecasts = (try? context.fetch(request)) ?? []
        dates = []
        forecasts.forEach { forecast in
            if let date = forecast.date {
                dates += [date]
            }
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDatesToShow()
        initFetchResultsController(with: dates[startIndex])
        setupView()
    }
    
    
    
    private func setupView() {
        
        [collectionView, tableView, backButton, locationLabel].forEach { view.addSubview($0) }
        view.backgroundColor = .white
        locationLabel.text = (location.city ?? "") + ", " + (location.country ?? "")
        collectionView.allowsMultipleSelection = false
        collectionView.selectItem(at: IndexPath(row: startIndex, section: 0), animated: true, scrollPosition: [])
        backButton.contentHorizontalAlignment = .leading
        locationLabel.textAlignment = .left
        createViewConstraint()
    }
    
    
    
    private func createViewConstraint() {
        
        NSLayoutConstraint.activate([
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 40),
            
            locationLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 28),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 48),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 28),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
}

extension DailySummaryVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailySummaryCell.identifier, for: indexPath) as! DailySummaryCell
        let forecast = fetchedResultsController.object(at: indexPath)
        cell.forecast = forecast
        cell.setupCell(forecast: forecast)
        cell.selectionStyle = .none
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 399
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        0.01
    }
    
}

extension DailySummaryVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DailySummaryCollectionCell.identifier, for: indexPath) as! DailySummaryCollectionCell
        let data = dates[indexPath.row]
        cell.setupCell(data: data)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 88, height: 36)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tableView.setContentOffset(.zero, animated: false)
        initFetchResultsController(with: dates[indexPath.row])
        tableView.reloadData()
    }
    
}
