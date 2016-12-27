//
//  ViewController.swift
//  VoiceMemo
//
//  Created by Muhammad Moaz on 12/27/16.
//  Copyright © 2016 Muhammad Moaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(MemoCell.self, forCellReuseIdentifier: MemoCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
        
    }()
    
    lazy var recordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Record", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(self.startRecording), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var stopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stop Recording", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(self.stopRecording), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    // MARK: - Audio Properties
    let sessionManager = MemoSessionManager.sharedInstance
    let recorder = MemoRecorder.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        let headerView = UIView()
        headerView.backgroundColor = .black
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(recordButton)
        headerView.addSubview(stopButton)
        
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: 120.0),
            headerView.centerXAnchor.constraint(equalTo: recordButton.centerXAnchor),
            headerView.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor),
            headerView.centerXAnchor.constraint(equalTo: stopButton.centerXAnchor),
            headerView.centerYAnchor.constraint(equalTo: stopButton.centerYAnchor),
            ])
        
        let stackView = UIStackView(arrangedSubviews: [headerView, tableView])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            self.topLayoutGuide.bottomAnchor.constraint(equalTo: stackView.topAnchor),
            view.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            // Header View
            headerView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            headerView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            headerView.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            // Table View
            tableView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: stackView.leftAnchor)
            ])
    }
    
    
    func startRecording() {
        toggleRecordButton(on: false)
        
        if !sessionManager.permissionGranted {
            sessionManager.requestPermission { permissionAllowd in
                if !permissionAllowd {
                    self.displayInsufficientPermissionsAlert()
                }
            }
        }
        
        recorder.start()
    }
    
    func stopRecording() {
        toggleRecordButton(on: true)
        
        let outputURLString = recorder.stop()
        presentSaveMemoAlertController { title in
            let memo = Memo(id: nil, title: title, fileURLString: outputURLString)
            self.save(memo: memo)
        }
    }

    private func toggleRecordButton(on flag: Bool) {
        recordButton.isHidden = !flag
        stopButton.isHidden = flag
    }
    
    func displayInsufficientPermissionsAlert() {
        let alertController = UIAlertController(title: "Insufficient Permissions", message: "Cannot record without permission", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentSaveMemoAlertController(completion: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: "Save Memo", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = "New Memo"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { alertAction in
            guard let title = alertController.textFields?.first?.text else {
                let timeStamp = Date().timeIntervalSince1970
                let title = "Memo_\(timeStamp)"
                completion(title)
                return
            }
            
            completion(title)
        }
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func save(memo: Memo) {
        
    }

}

