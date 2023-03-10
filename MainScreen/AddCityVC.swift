
import UIKit

final class AddCityVC: UIViewController {

    var closure: (()->Void)?

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Введите название города"
        searchController.searchResultsUpdater = self
        self.navigationItem.searchController = searchController
        return searchController
    }()

    private var location: LocationProtocol?

    private let cityInfoLabel = CustomLabel(
        titleColor: .black,
        font: UIFont(name: "Rubik-Medium", size: 18))


    private lazy var addCityButton = CustomButton (
        title: "Добавить",
        titleColor: .white,
        font: .boldSystemFont(ofSize: 25),
        backgroundColor: UIColor(named: "orange")) {

            print("addCityButton tapped")
            CoreDataManager.default.addLocation(location: self.location!)
            self.navigationController?.dismiss(animated: true)
            self.closure?()
        }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
    }


    private func setupView() {
        view.backgroundColor = .white
        title = "Добавить город"
        searchController.searchResultsUpdater = self
        addCityButton.isHidden = true

        cityInfoLabel.numberOfLines = 0

        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always

        let closeAction = UIAction { [weak self] _ in
            self?.navigationController?.dismiss(animated: true)
        }

        let closeBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: closeAction, menu: nil)
        navigationItem.rightBarButtonItem  = closeBarButtonItem

        view.addSubview(addCityButton)
        view.addSubview(cityInfoLabel)
    }


    private func layout() {

        NSLayoutConstraint.activate([

            cityInfoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            cityInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            cityInfoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            cityInfoLabel.heightAnchor.constraint(equalToConstant: 150),

            addCityButton.topAnchor.constraint(equalTo: cityInfoLabel.bottomAnchor, constant: 50),
            addCityButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            addCityButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            addCityButton.heightAnchor.constraint(equalToConstant: 60),

        ])

    }


}

extension AddCityVC: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {

        if let searchText = searchController.searchBar.text,
           searchText != "" {

            Geocode().geocodeAddressString(addressString: searchText) {result,error in

                if error == nil, let result = result {
                    DispatchQueue.main.async {
                        var text = ""
                        text += result.city + "\n"
                        if result.city != result.administrativeArea {
                            text += result.administrativeArea + "\n" }
                        text += result.country + "\n"
                        self.location = result
                        self.cityInfoLabel.text = text
                        self.addCityButton.isHidden = false
                    }


                } else {
                    DispatchQueue.main.async {
                        self.cityInfoLabel.text = ""
                        self.addCityButton.isHidden = true
                    }

                }
            }

        } else {
            cityInfoLabel.text = ""
            addCityButton.isHidden = true
        }
    }
}


