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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        fetchData()
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
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }
}

extension ViewController : UICollectionViewDelegate{
    
}

extension ViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        if screenWidth > 430{
            let spaceBetweenItems: CGFloat = 2*20
            let width: CGFloat = (screenWidth - 10 - spaceBetweenItems)/3
            return CGSize(width: width, height: 450)
        }else{
            let spaceBetweenItems: CGFloat = 10
            let width = (screenWidth - 10 - spaceBetweenItems)/2
            return CGSize(width: width, height: 250)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

