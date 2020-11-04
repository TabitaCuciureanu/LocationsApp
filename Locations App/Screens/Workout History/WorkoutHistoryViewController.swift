//
//  WorkoutHistoryViewController.swift
//  Workout App
//
//  Created by Tabita Marusca on 27/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

final class WorkoutHistoryViewController: UITableViewController {
    // MARK: - Properties
    
    private let workoutManager: WorkoutManager
    private let accountManager: AccountManager
    private var workouts = [WorkoutRoutine]()
    private var images = [String: UIImage]()
    private weak var router: Router?
    
    // MARK: - Init
    
    init(workoutManager: WorkoutManager, accountManager: AccountManager, router: Router) {
        self.workoutManager = workoutManager
        self.accountManager = accountManager
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workoutManager.getWorkoutHistory { [weak self] (workoutHistory) in
            guard let self = self else { return }
            self.workouts = workoutHistory
            self.workouts.sort {
                $0.date.date ?? Date() > $1.date.date ?? Date()
            }
            workoutHistory.forEach { [weak self] in
                guard let self = self else { return }
                self.workoutManager.getImage(timeOfAdding: $0.timeOfAdding) { _, image, timeOfAdding in
                    if let image = image, let timeOfAdding = timeOfAdding {
                        self.images[timeOfAdding] = image
                        self.tableView?.reloadData()
                    }
                }
            }
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        tableView.register(WorkoutHistoryCell.self, forCellReuseIdentifier: "WorkoutHistoryCell")
        tableView.estimatedRowHeight = 80
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout))

        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = addButton
    }
    
    // MARK: - TableView
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHistoryCell", for: indexPath) as! WorkoutHistoryCell
        let image = images[workouts[indexPath.row].timeOfAdding]
        cell.configure(name: workouts[indexPath.row].name, date: workouts[indexPath.row].date, photo: image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        router?.goToWorkoutDetails(with: workouts[indexPath.row], image: images[workouts[indexPath.row].timeOfAdding])
    }
    
    // MARK: - Private Methods
    
    @objc private func addTapped() {
//        router?.goToAddWorkoutRoutine()
    }
    
    @objc private func logout() {
        accountManager.logout { [weak self] (error) in
            guard let _ = error else {
                self?.router?.startFlow()
                return
            }
            
            self?.showAlert(title: "An error occured", message: "The user could not be logged in, please try again later")
        }
    }
}
