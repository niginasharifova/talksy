//
//  ProfileViewController.swift
//  Talksy
//
//  Created by Nigina Sharifova on 22/01/25.
//
import UIKit
import FirebaseAuth
import SDWebImage

final class ProfileViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.nameOfClass)
        table.tableHeaderView = createTableHeader()
        return table
    }()
    
    var data = [ProfileViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ProfileTableViewCell.self,
                           forCellReuseIdentifier: ProfileTableViewCell.nameOfClass)

        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Name: \(UserDefaults.standard.value(forKey:"name") as? String ?? "No Name")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .info,
                                     title: "Email: \(UserDefaults.standard.value(forKey:"email") as? String ?? "No Email")",
                                     handler: nil))
        data.append(ProfileViewModel(viewModelType: .logout, title: "Log Out", handler: { [weak self] in

            guard let self = self else {
                return
            }

            let actionSheet = UIAlertController(title: "",
                                          message: "",
                                          preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "Log Out",
                                          style: .destructive,
                                          handler: { [weak self] _ in

                                            guard let self = self else {
                                                return
                                            }

                                            UserDefaults.standard.setValue(nil, forKey: "email")
                                            UserDefaults.standard.setValue(nil, forKey: "name")

                                            do {
                                                try FirebaseAuth.Auth.auth().signOut()
                                                
                                                let vc = SignInViewController()
                                                let nav = UINavigationController(rootViewController: vc)
                                                nav.modalPresentationStyle = .fullScreen
                                                self.present(nav, animated: true)
                                            }
                                            catch {
                                                print("Failed to log out")
                                            }

            }))

            actionSheet.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel,
                                                handler: nil))

            self.present(actionSheet, animated: true)
        }))


        tableView.tableHeaderView = createTableHeader()
        makeConstraints()
        setupTableView()
    }
    
    private func makeConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func createTableHeader() -> UIView? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return nil
        }

        let safeEmail = DataBaseManager.safeEmail(emailAddress: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename

        let headerView = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: self.view.width,
                                        height: 300))

        headerView.backgroundColor = .link

        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150) / 2,
                                                  y: 75,
                                                  width: 150,
                                                  height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.width/2
        headerView.addSubview(imageView)

        StorageManager.shared.downloadURL(for: path, completion: { result in
            switch result {
            case .success(let url):
                imageView.sd_setImage(with: url, completed: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })

        return headerView
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.nameOfClass,
                                                 for: indexPath) as! ProfileTableViewCell
        cell.setUp(with: viewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].handler?()
    }
}
