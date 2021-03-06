//
//  DashboardViewController.swift
//  BeyondTinnitus
//
//  Created by Huyanh Hoang on 2016. 11. 19..
//  Copyright © 2016년 teamMedApp. All rights reserved.
//

import UIKit
import AVFoundation

class DashboardViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var trialLabel: UILabel!
  
  var manager = FrequencyManager.shared
  
  fileprivate let sectionData = [" "]
  fileprivate let rowData = [["apple_music", "Play with Music"],
                             ["spotify", "Play with Spotify"],
                             ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.isScrollEnabled = false
    
    if let savedManager = loadToneSettings() {
      print("loading settings")
      manager = savedManager
      manager.setupAudioFiles()
    } else { fatalError("should go to onboard") }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if FrequencyManager.shared.trial {
      trialLabel.text = "TRIAL"
      trialLabel.backgroundColor = .red
    } else {
      trialLabel.text = ""
    }
  }
  
  @IBAction func toggleplay(_ sender: UIButton) {
    if manager.wholeTone.isPlaying {
      manager.stopAll()
      sender.setImage(UIImage(named: "play"), for: .normal)
    } else {
      manager.playAll()
      sender.setImage(UIImage(named: "pause"), for: .normal)
    }
  }
  
  private func loadToneSettings() -> FrequencyManager? {
    return NSKeyedUnarchiver.unarchiveObject(withFile: FrequencyManager.ArchiveURL.path) as? FrequencyManager
  }
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
  
  // DataSource
  @nonobjc func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return sectionData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rowData.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    
    cell.imageView?.image = UIImage(named: rowData[indexPath.row][0])
    cell.textLabel?.text = rowData[indexPath.row][1]
    
    return cell
  }
  
  // Delegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    switch indexPath.row {
    case 0:
      guard let musicAppURL = URL(string: "music://"), UIApplication.shared.canOpenURL(musicAppURL) else { fatalError("probably playing from simulator") }
      UIApplication.shared.open(musicAppURL, options: [:], completionHandler: nil)
    case 1:
      guard let musicAppURL = URL(string: "spotify://"), UIApplication.shared.canOpenURL(musicAppURL) else {
        Utility.alert(message: "You do not have Spotify", vc: self)
        return
      }
      UIApplication.shared.open(musicAppURL, options: [:], completionHandler: nil)
    default:
      print("hi")
      break
    }
  }
  
}
