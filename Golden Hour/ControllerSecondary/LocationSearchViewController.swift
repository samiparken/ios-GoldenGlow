import UIKit
import MapKit

class LocationSearchViewController: UIViewController {
    let myTabBar = TabBarController.singletonTabBar

    @IBOutlet weak var selectedCityLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var matchingItems: [MKMapItem] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self

        tableView.dataSource = self
        tableView.delegate = self

    }
    
//MARK: - Init
    func setCurrentLocation() {
        if let location = myTabBar.currentLocation {
            selectedCityLabel.text = "📍" + location
        }
    }
}

//MARK: - UITableViewDataSource
extension LocationSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: LocationSearchCell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchCell", for: indexPath) as! LocationSearchCell

            let selectedItem = matchingItems[indexPath.row].placemark
            cell.label?.text = (selectedItem.locality ?? "") + ", " + (selectedItem.country ?? "")
            
            return cell
    }
}

//MARK: - UITableViewDelegate
extension LocationSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // auto-deselect animation
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("Selected at \(indexPath.row)")

    }

}

//MARK: - UISearchBarDelegate
extension LocationSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText == "" {
            self.matchingItems = []
            self.tableView.reloadData()
            return
        } else {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchText
            request.region = MKCoordinateRegion(.world)
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else { return }
                self.matchingItems = response.mapItems
                self.tableView.reloadData()
            }
        }
    }
}
