//
//  MoviesViewController.swift
//  flixster
//
//  Created by Mikael Joseph Kaufman on 2/12/21.
//

import UIKit
import AlamofireImage


// STEP 1 of THE RECIPE of tableViews (Add: UITableViewDataSource and UITableViewDelegate to Class header)
class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    
    var movies = [[String:Any]]() //Array of dictionaries
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // STEP 3 of creating a scrolling tableView
        tableView.dataSource = self
        tableView.delegate = self
        
        // Basically this chunk below downloads all the movies and stores it in the
        // array that is called self.movies (an array of dictionaries)
        
        // Do any additional setup after loading the view.
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request)
        { [self]
            (data, response, error) in
            // This will run when the network request returns
            if let error = error
            {
                print(error.localizedDescription)
            }
            else if let data = data
            {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
              
                self.movies = dataDictionary["results"] as! [[String:Any]]
                
                //Continously reloads data so we get more movie titles
                self.tableView.reloadData()
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data

            }
        }
        task.resume()
    }
    
    // STEP 2 Create code stubs for the TableView and TableView Cell
    // ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Create the amount of rows for the amount of movies
        return movies.count
    }
    // CELL
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //For each particular row, give the cell
        // creates cell and gives access to the outlets (features of the cell)
        // [the title, synopsis, poster, etc..]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell
        
        //grabs poster and title and synopsis
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synoposis = movie["overview"] as! String
        
        //edit the cell/row with the desired information
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synoposis
        
        // gets url for the poster and puts the image on app
        let baseUrl = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL(string: baseUrl + posterPath)
        
        // Gets url and takes care of downloading the image
        cell.posterView.af.setImage(withURL: posterUrl!)
        
        
        return cell
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //Find Selected Movie
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let movie = movies[indexPath.row]
        
        //Pass the selected movie to the details view Controller
        let detailsViewController = segue.destination as! MoviesDetailsViewController
        detailsViewController.movie = movie
        
        //deselects the selected object, get's rid of that dark grey highlight
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

}
