    //
    //  ResourceHubVC.swift
    //  PebblePulse
    //
    //  Created by Hrishikesh Vikram on 11/30/23.
    //



import UIKit
import Foundation

struct GridItem {
    let imageName: String
    let webURL: URL
}

class GridCell: UICollectionViewCell {
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ResourceHubVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var collectionView: UICollectionView!
    var gridItems: [GridItem] = [
        GridItem(imageName: "image1", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image2", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image3", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image4", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image5", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image6", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image1", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image2", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image3", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image4", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image5", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image6", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image1", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image2", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image3", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image4", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image5", webURL: URL(string: "https://example.com")!),
        GridItem(imageName: "image6", webURL: URL(string: "https://example.com")!),
    ]
    var homeBar: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupHomeBar()
    }

    func setupCollectionView() {
          let layout = UICollectionViewFlowLayout()
          layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
          layout.minimumLineSpacing = 20
          layout.minimumInteritemSpacing = 20

          collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
          collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
          collectionView.dataSource = self
          collectionView.delegate = self
          collectionView.backgroundColor = .white
          collectionView.register(GridCell.self, forCellWithReuseIdentifier: "GridCell")
          view.addSubview(collectionView)
      }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridItems.count
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
           if let cell = collectionView.cellForItem(at: indexPath) as? GridCell {
               UIView.animate(withDuration: 0.3) {
                   cell.imageView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                   cell.imageView.alpha = 0.7
               }
           }
       }

       func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
           if let cell = collectionView.cellForItem(at: indexPath) as? GridCell {
               UIView.animate(withDuration: 0.3) {
                   cell.imageView.transform = CGAffineTransform.identity
                   cell.imageView.alpha = 1.0
               }
           }
       }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        let item = gridItems[indexPath.row]
        cell.imageView.image = UIImage(named: item.imageName)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = gridItems[indexPath.row]
        UIApplication.shared.open(item.webURL)
    }

    func setupHomeBar() {
        homeBar = UIView()
        homeBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(homeBar)

        NSLayoutConstraint.activate([
            homeBar.heightAnchor.constraint(equalToConstant: 50),
            homeBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        homeBar.backgroundColor = .gray

        let chatButton = UIButton()
        let homeButton = UIButton()
        let helpButton = UIButton()

        chatButton.setTitle("Chat", for: .normal)
        homeButton.setTitle("Home", for: .normal)
        helpButton.setTitle("Help", for: .normal)

        [chatButton, homeButton, helpButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            homeBar.addSubview(button)
        }

        NSLayoutConstraint.activate([
            chatButton.leadingAnchor.constraint(equalTo: homeBar.leadingAnchor),
            chatButton.centerYAnchor.constraint(equalTo: homeBar.centerYAnchor),
            homeButton.centerXAnchor.constraint(equalTo: homeBar.centerXAnchor),
            homeButton.centerYAnchor.constraint(equalTo: homeBar.centerYAnchor),
            helpButton.trailingAnchor.constraint(equalTo: homeBar.trailingAnchor),
            helpButton.centerYAnchor.constraint(equalTo: homeBar.centerYAnchor)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! GridCell
        let item = gridItems[indexPath.row]
        cell.imageView.image = UIImage(named: item.imageName)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = gridItems[indexPath.row]
        UIApplication.shared.open(item.webURL)
    }

 
}
