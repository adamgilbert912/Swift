//
//  ViewController.swift
//  Project10
//
//  Created by macbook on 1/9/20.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var picker: UIImagePickerController!
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .darkGray
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
        
        picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Can't deque with 'Person' identifier")
        }
        let imageURL = getDocumentsFromDirectory().appendingPathComponent(people[indexPath.item].imageID)
        cell.imageView.image = UIImage(contentsOfFile: imageURL.path)
        cell.label.text = people[indexPath.item].name
        
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        
        cell.imageView.layer.cornerRadius = 8
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let rename = UIAlertAction(title: "Rename", style: .default) {
            [weak self] _ in
            let name = alert.textFields?[0].text
            self?.people[indexPath.item].name = name
            collectionView.reloadData()
        }
        alert.addAction(rename)
        
        let delete = UIAlertAction(title: "Delete", style: .default) {
            [weak self] _ in
            self?.people.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
            //collectionView.reloadData() maybe
        }
        alert.addAction(delete)
        
        let viewPicture = UIAlertAction(title: "View", style: .default) {
            [weak self] _ in
            let vc = PictureImage()
            let url = self?.getDocumentsFromDirectory().appendingPathComponent(self!.people[indexPath.item].imageID)
            let image = UIImage(contentsOfFile: url!.path)
            vc.imageView.image = image
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        alert.addAction(viewPicture)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    @objc func addNewImage() {
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsFromDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.9) {
            try? jpegData.write(to: imagePath)
        }
        
        let labelAlert = UIAlertController(title: "Create a Name!", message: nil, preferredStyle: .alert)
        labelAlert.addTextField()
        let submit = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak labelAlert] _ in
            self?.people.last?.name = labelAlert?.textFields?[0].text
            self?.collectionView.reloadData()
            
        }
        
        labelAlert.addAction(submit)
        
        let person = Person(name: nil, imageID: imageName)
        people.append(person)
        dismiss(animated: true)
        present(labelAlert, animated: true)
        collectionView.reloadData()
    }
    
    func getDocumentsFromDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }


}

