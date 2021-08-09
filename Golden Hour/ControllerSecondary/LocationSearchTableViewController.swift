import UIKit
import MapKit

class LocationSearchTableViewController: UITableViewController {
    let myTabBar = TabBarController.singletonTabBar

    let searchController = UISearchController()
    
    var matchingItems: [MKMapItem] = []
    var mapView: MKMapView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setCurrentLocation()
    }
    
//MARK: - Init
    func setCurrentLocation() {
        if let location = myTabBar.currentLocation {
            title = "📍" + location
        }
    }

// MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return matchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LocationSearchCell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchCell", for: indexPath) as! LocationSearchCell

        let selectedItem = matchingItems[indexPath.row].placemark
        cell.label?.text = selectedItem.name
        
        return cell
    }
}


//MARK: - UISearchResultsUpdating
extension LocationSearchTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let inputText = searchController.searchBar.text else {
            return
        }
                
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = inputText
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
        
    }
        
}
