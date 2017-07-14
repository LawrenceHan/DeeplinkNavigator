//
//  MainViewController.swift
//  DeeplinkNavigator
//
//  Created by Hanguang on 2017/7/9.
//  Copyright © 2017年 Hanguang. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {

    let items: [String] = [
        "StoryboardNavigable",
        "XibNavigable",
        "InitNavigable",
        "push from UIView",
        "present from UIView",
        "push or pop"
        ]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == items.count-1 {
            if let nav = UIViewController.lhw_topMost?.navigationController {
                let red = Navigator.viewController(for: "/StoryboardNavigable")!
                let green = Navigator.viewController(for: "/XibNavigable")!
                let blue = Navigator.viewController(for: "/InitNavigable")!
                let pushOrPop = Navigator.viewController(for: "/PushOrPop")!
                var viewControllers = nav.viewControllers
                viewControllers.append(contentsOf: [red, green, blue, pushOrPop])
                nav.setViewControllers(viewControllers, animated: true)
            }
        } else if indexPath.row == 3 {
            let cell = tableView.cellForRow(at: indexPath)
            Navigator.push("/test", from: cell, animated: true)
        } else if indexPath.row == 4 {
            let cell = tableView.cellForRow(at: indexPath)
            Navigator.present("/test", from: cell, animated: true)
        }
        Navigator.push("navigator://\(items[indexPath.row])", context: ["fromViewController": self], animated: true)
    }

}
