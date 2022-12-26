//
//  HomeScreenViewController.swift
//  FireBaseExample
//
//  Created by ashutosh deshpande on 06/12/2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage
import Toast_Swift
class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak var wishListTextField: UITextField!
    @IBOutlet weak var wishListImageView: UIImageView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var topTableViewLayoutConstraint: NSLayoutConstraint!
    let imagePicker = UIImagePickerController()
    var wishListArray : [[String : String]] = [[:]]
  
    var refer = DatabaseReference.init()
    var uId : String?
    var wishListText : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        //Firebase
        refer = Database.database().reference()
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(HomeScreenViewController.openGalary(tapGesture:)))
        wishListImageView.isUserInteractionEnabled = true
        wishListImageView.addGestureRecognizer(tapGesture)
        //User Default Database File
        uId = DataBaseFile.shared.fetchUId()
        print(uId!)
        fetch()
        // Do any additional setup after loading the view.
    }
    @objc func openGalary(tapGesture: UITapGestureRecognizer){
        setImagePicker()
    }
    
    
    func fetch(){
       
        wishListImageView.image = UIImage(systemName: "plus.app")
        wishListTextField.text = ""
        let ref = Database.database().reference().child("wishList").child(uId!)
        ref.observe(.value){ [unowned self](snapshot) in
            if snapshot.exists() {
                self.wishListArray = [[:]]
                for child in snapshot.children {
                    let value = (child as! DataSnapshot).value as! [String : String]
                    wishListArray.append(value)
                }
                detailTableView.reloadData()
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        secondView.isHidden = true
        navigationController?.navigationBar.isHidden = false
        
        topTableViewLayoutConstraint.constant = 50
    }
    
    //saving data INTO Firebase
    @IBAction func saveWishListButton(_ sender: Any) {
        if wishListTextField.text != "" {
            wishListText = wishListTextField.text!
            saveFBData()
            fetch()
        }else {
            self.view.makeToast("Please enter your Wishlist", duration: 3.0, position: .bottom)
            
        }
       
    }
    
    func saveFBData(){
        self.uploadImage(self.wishListImageView.image!) { [unowned self] url in
            self.saveData(url: url!, wishListTextField: self.wishListText)
        }
    }
    func saveData(url : URL , wishListTextField : String){
        let id = Database.database().reference().child("wishList").child(uId!).childByAutoId().key
        Database.database().reference().child("wishList").child(uId!).child(id!).updateChildValues(["id": id!, "title": wishListTextField, "url": url.absoluteString])
        self.view.makeToast("Data Saved", duration: 3.0, position: .bottom)
        
    }
    
    @IBAction func addWishListBarButton(_ sender: Any) {
        navigationController?.navigationBar.isHidden = true
        secondView.isHidden = false
        topTableViewLayoutConstraint.constant = 200
        
    }
    
}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")as! WishListTableViewCell
        
        cell.wishListLabel.text = wishListArray[indexPath.row]["title"]
        if wishListArray[indexPath.row]["url"] != nil {
            let urlinString = wishListArray[indexPath.row]["url"]
            let url = URL(string: urlinString!)
            do{
                let data = try Data(contentsOf: url!)
                cell.wishListImageView.image = UIImage(data: data)
            }catch let error {
                print(error.localizedDescription)
            }
        }
        if cell.wishListLabel.text == nil {
            wishListArray.remove(at: indexPath.row)
            detailTableView.reloadData()
        }
        
            return cell

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80.0)
    }
    
}

// extension because using UIimagePickerController Delegate Methods
extension HomeScreenViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // this method is written for show savedPhotosAlbum i.e galary on the screen
    func setImagePicker(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.delegate = self
            imagePicker.isEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // inbuild method for getting image on image view from phone
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image =  info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        wishListImageView.image = image
        dismiss(animated: true)
    }
    
    
    func uploadImage(_ image: UIImage, completion: @escaping ((_ url : URL?) -> ())) {
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
                   dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let convertedDate = dateFormatter.string(from: currentDate as Date)

        let storageRefer = Storage.storage().reference().child("\(convertedDate)")
        
        let imageData = wishListImageView.image?.jpegData(compressionQuality: 1.5)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageRefer.putData(imageData!, metadata: metaData) { (metaData, error) in
            if error == nil {
                print("Successful")
                storageRefer.downloadURL { url, error in
                    completion(url)
                }
            }else {
                print(error!.localizedDescription)
                completion(nil)
            }
        }
        
    }
    
}
