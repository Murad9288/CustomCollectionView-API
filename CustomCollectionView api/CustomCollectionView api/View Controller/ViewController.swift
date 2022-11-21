//
//  ViewController.swift
//  CustomCollectionView api
//
//  Created by Abul Kashem on 13/11/22.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    let rest = RestManager()
    var countryData = [Result]()
    
    var padding     : CGFloat = 0
    var itemGap     : CGFloat = 0
    var lineGap     : CGFloat = 0
    var cellWidth   : CGFloat = 0
    var cellHeight  : CGFloat = 0

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        itemSize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
        fetchData()
        
    }

    
    func itemSize(){
        padding = UIDevice.current.userInterfaceIdiom == .phone ? 12.0 : 25.0
        itemGap = UIDevice.current.userInterfaceIdiom == .phone ? 15.0 : 30.0
        let noOfItem = UIDevice.current.userInterfaceIdiom == .phone ? 3.0 : 4.0
        cellWidth = floor((UIScreen.main.bounds.width - 2.0 * padding - itemGap * (noOfItem - 1.0)) / noOfItem)
        cellHeight = floor(1.2 * cellWidth + 60.0)
        lineGap = UIDevice.current.userInterfaceIdiom == .phone ? 15.0 : 35.0
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        let nib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
    }
    
    //MARK: fetchData
    
    func fetchData(){
        guard let url = URL(string: Api.MovieApiUrl) else { return }
        
        rest.makeRequest(toURL: url, withHttpMethod: .get) { result in
            
            if result.error != nil {
                print(result.error.debugDescription)
            }
            
            if let data = result.data {
                print(data)
                
                let decode = JSONDecoder()
                let welcome = try? decode.decode(Welcome.self, from: data)
                  
//                for i in 0..<(welcome?.results?.count ?? 0) {
//                    guard let item = welcome?.results?[i] else { return }
//                    self.countryData.append(item)
//                }
                
                guard let item = welcome?.results else{return}
                self.countryData.append(contentsOf: item)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        cell.configure(movie: countryData[indexPath.row])
        return cell
    }
}

extension ViewController : UICollectionViewDelegate{
    
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return lineGap
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return itemGap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
    }
}

