//
//  HieuDinhAppViewController.swift
//  HDExtensions
//
//  Created by Hieu Dinh on 10/8/19.
//  Copyright © 2019 Hieu Dinh. All rights reserved.
//

import UIKit
import FirebaseDatabase

enum AppEnum: String {
    case exchangeRates = "Exchange Rates"
    case unitConverter = "Unit Converter"
    case kanban = "Kanban"
    case datesRemember = "Dates remember"
    case tinhLaiTietKiem = "Tinh Lai Tiet Kiem"
    case spendingJournal = "Spending journal"
    case scanner = "Scanner"
}

class HieuDinhAppModel {
    var isOpen = false
    var index = 0
    var level = 0
    var key = ""
    var value = 0
    var parent = ""
    var childModels = [HieuDinhAppModel]()
    
    convenience init(index: Int, level: Int, key: String, value: Int, parent: String) {
        self.init()
        self.index = index
        self.level = level
        self.key = key
        self.value = value
        self.parent = parent
    }
}

class HieuDinhAppViewController: HDBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    private let root = "HieuDinhApp"
    private let total = "--Total"
    private var data = [HieuDinhAppModel]()
    private lazy var ref: DatabaseReference = {
        return Database.database().reference()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupPullToRefresh()
        fetch()
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className)
    }
    
    private func setupPullToRefresh() {
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func fetch() {
        /*
         HieuDinhApp
         -   Dates remember
         -       Asia
         -           Ho_Chi_Minh
         -               ID: 2
         */
        refreshControl.beginRefreshing()
        data.removeAll()
        ref.child(root).observeSingleEvent(of: .value) { [weak self] (dataSnapshot) in
            guard let self = self else { return }
            let dictionary = (dataSnapshot.value as? [String: Any]) ?? [:] // [App: [Locale: [City: Total]]]
            for item in dictionary {
                let app = item.key
                var index = 1
                if app.lowercased().contains(AppEnum.exchangeRates.rawValue.lowercased()) {
                    index = 1
                } else if app.lowercased().contains(AppEnum.unitConverter.rawValue.lowercased()) {
                    index = 100
                } else if app.lowercased().contains(AppEnum.kanban.rawValue.lowercased()) {
                    index = 1000
                } else if app.lowercased().contains(AppEnum.datesRemember.rawValue.lowercased()) {
                    index = 10000
                } else if app.lowercased().contains(AppEnum.tinhLaiTietKiem.rawValue.lowercased()) {
                    index = 100000
                } else if app.lowercased().contains(AppEnum.spendingJournal.rawValue.lowercased()) {
                    index = 1000000
                } else if app.lowercased().contains(AppEnum.scanner.rawValue.lowercased()) {
                    index = 10000000
                }
                
                let appModel = HieuDinhAppModel(index: index,
                                                level: 0,
                                                key: app,
                                                value: 0,
                                                parent: "")
                
                self.data.append(appModel)
                guard let value = item.value as? [String: Any] else { continue }
                
                for item in value where item.key != self.total {
                    index += 1
                    let locale = item.key
                    let localeModel = HieuDinhAppModel(index: index,
                                                       level: 1,
                                                       key: locale,
                                                       value: (item.value as? Int) ?? 0,
                                                       parent: app)
                    appModel.childModels.append(localeModel)
                    self.data.append(localeModel)
                    
                    guard let value = item.value as? [String: Any] else {
                        appModel.value += localeModel.value
                        continue
                    }
                    for item in value {
                        index += 1
                        let city = item.key
                        let cityModel = HieuDinhAppModel(index: index,
                                                         level: 2,
                                                         key: city,
                                                         value: (item.value as? Int) ?? 0,
                                                         parent: app + "/" + locale)
                        localeModel.childModels.append(cityModel)
                        self.data.append(cityModel)
                        
                        guard let value = item.value as? [String: Int] else {
                            localeModel.value += cityModel.value
                            continue
                        }
                        for item in value {
                            index += 1
                            let id = item.key
                            let idModel = HieuDinhAppModel(index: index,
                                                           level: 3,
                                                           key: id,
                                                           value: item.value,
                                                           parent: app + "/" + locale + "/" + city)
                            cityModel.childModels.append(idModel)
                            self.data.append(idModel)
                            
                            cityModel.value += idModel.value
                        }
                        localeModel.value += cityModel.value
                    }
                    appModel.value += localeModel.value
                }
            }
            
            self.data = self.data.sorted(by: { $0.index < $1.index })
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func delete(child: String) {
        ref.child(root + "/" + child).removeValue()
        fetch()
    }
}

extension HieuDinhAppViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row > data.count - 1 { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className, for: indexPath)
        cell.selectionStyle = .none
        let model = data[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.lineBreakMode = .byTruncatingMiddle
        let padding = "     "
        cell.textLabel?.font = .systemFont(ofSize: cell.textLabel?.font.pointSize ?? 17)
        if model.level == 0 {
            cell.textLabel?.text = String(format: "%@: %@", model.key, String(model.value))
            cell.textLabel?.font = .boldSystemFont(ofSize: cell.textLabel?.font.pointSize ?? 17)
        } else if model.level == 1 {
            if model.childModels.count > 0 {
                cell.textLabel?.font = .boldSystemFont(ofSize: cell.textLabel?.font.pointSize ?? 17)
            }
            cell.textLabel?.text = String(format: "%@%@: %@", padding, model.key, String(model.value))
        } else if model.level == 2 {
            if model.childModels.count > 0 {
                cell.textLabel?.font = .boldSystemFont(ofSize: cell.textLabel?.font.pointSize ?? 17)
            }
            cell.textLabel?.text = String(format: "%@%@%@: %@", padding, padding, model.key, String(model.value))
        } else {
            cell.textLabel?.text = String(format: "%@%@%@%@: %@", padding, padding, padding, model.key, String(model.value))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = data[indexPath.row]
        for item in model.childModels {
            let isOpen = !item.isOpen
            item.isOpen = isOpen
            
            for item in item.childModels {
                item.isOpen = isOpen
                
                for item in item.childModels {
                    item.isOpen = isOpen
                    
                    for item in item.childModels {
                        item.isOpen = isOpen
                    }
                }
            }
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let model = data[indexPath.row]
        delete(child: model.parent + (model.level == 0 ? "" : "/") + model.key)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row > data.count - 1 { return 0 }
        
        let model = data[indexPath.row]
        return (model.level == 0 || model.isOpen) ? 44 : 0
    }
}
