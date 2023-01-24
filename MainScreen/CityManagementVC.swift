//
//  CityManagementVC.swift
//  WeatherApp
//
//  Created by Alex M on 09.01.2023.
//


import UIKit
import CoreData

final class CityManagementVC: UIViewController, UITableViewDataSource,
                                UITableViewDelegate, NSFetchedResultsControllerDelegate {


    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        return tableView
    }()


    private var fetchedResultsController: NSFetchedResultsController<Location>!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        initFetchResultsController()
    }


    private func initFetchResultsController() {
        let request = Location.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "city", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.default.contextMain, sectionNameKeyPath: nil, cacheName: nil)
        try? frc.performFetch()
        fetchedResultsController = frc
        fetchedResultsController.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if navigationController?.isBeingDismissed == true {
                       NotificationCenter.default.post(name: NSNotification.Name("CityManagementVCisBeingDismissed"), object: nil)
        }

    }



    private func setupView() {

        view.backgroundColor = .white
        title = "Список локаций"

        let closeAction = UIAction { [weak self] _ in
            self?.navigationController?.dismiss(animated: true)
        }
        let closeBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: closeAction, menu: nil)
        navigationItem.rightBarButtonItem  = closeBarButtonItem


        let addLocationAction = UIAction { [weak self] _ in

            let vc = AddCityVC()
            vc.closure = self?.tableView.reloadData
            vc.modalPresentationStyle = .automatic
            let nc = UINavigationController(rootViewController: vc)

            self?.present(nc, animated: true)

        }

        let addLocationBarButtonItem = UIBarButtonItem(systemItem: .add, primaryAction: addLocationAction, menu: nil)
        navigationItem.leftBarButtonItem  = addLocationBarButtonItem

        view.addSubview(tableView)

    }


    private func layout() {

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }



    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")

        let item = fetchedResultsController.object(at: indexPath)

        cell.textLabel?.text = item.city

        if item.city == item.administrativeArea {
            cell.detailTextLabel?.text = item.country
        } else {
            if item.administrativeArea != "" {
                cell.detailTextLabel?.text = (item.administrativeArea ?? "") + ", " + (item.country ?? "")
            } else {
                cell.detailTextLabel?.text = item.country
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }




    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            let item = fetchedResultsController.object(at: indexPath)
            CoreDataManager.default.deleteLocation(location: item)
        }

    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        if type == .delete {
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

