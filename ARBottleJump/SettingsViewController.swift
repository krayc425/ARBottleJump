//
//  SettingsViewController.swift
//  ARBottleJump
//
//  Created by Peter Luo on 2018/11/11.
//  Copyright © 2018 宋 奎熹. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    let selectedControllColor = #colorLiteral(red: 0.2470588237, green: 0.3882353008, blue: 0.5450980663, alpha: 1)
    let controllAccentColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)

    // Size
    @IBOutlet weak var btLarge: UIButton!
    @IBOutlet weak var btNormal: UIButton!
    @IBOutlet weak var btSmall: UIButton!

    // Distance
    @IBOutlet weak var btLong: UIButton!
    @IBOutlet weak var btNormalDistance: UIButton!
    @IBOutlet weak var btShort: UIButton!

    override func viewDidLoad() {
        btLarge.layer.cornerRadius  = 10.0
        btNormal.layer.cornerRadius = 10.0
        btSmall.layer.cornerRadius  = 10.0

        btLong.layer.cornerRadius = 10.0
        btNormalDistance.layer.cornerRadius = 10.0
        btShort.layer.cornerRadius = 10.0

        resetButtons()
    }

    // Size Controll
    @IBAction func btLargeTouchUpInside(_ sender: UIButton) {
        kBoxWidth = 0.3

        sender.backgroundColor = selectedControllColor
        btNormal.backgroundColor = controllAccentColor
        btSmall.backgroundColor = controllAccentColor
    }
    @IBAction func btNormalTouchUpInside(_ sender: UIButton) {
        kBoxWidth = 0.2

        sender.backgroundColor = selectedControllColor
        btSmall.backgroundColor = controllAccentColor
        btLarge.backgroundColor = controllAccentColor
    }
    @IBAction func btSmallTouchUpInside(_ sender: UIButton) {
        kBoxWidth = 0.15

        sender.backgroundColor = selectedControllColor
        btLarge.backgroundColor = controllAccentColor
        btNormal.backgroundColor = controllAccentColor
    }

    // Distance Controll
    @IBAction func btLongTouchUpInside(_ sender: UIButton) {
        distanceRange = 0.5 ... 0.8

        sender.backgroundColor = selectedControllColor
        btShort.backgroundColor = controllAccentColor
        btNormalDistance.backgroundColor = controllAccentColor
    }
    @IBAction func btNormalDistanceTouchUpInside(_ sender: UIButton) {
        distanceRange = 0.25 ... 0.5

        sender.backgroundColor = selectedControllColor
        btShort.backgroundColor = controllAccentColor
        btLong.backgroundColor = controllAccentColor
    }
    @IBAction func btShortTouchUpInside(_ sender: UIButton) {
        distanceRange = 0.2 ... 0.25

        sender.backgroundColor = selectedControllColor
        btLong.backgroundColor = controllAccentColor
        btNormalDistance.backgroundColor = controllAccentColor
    }

    private func resetButtons() {
        // Size
        switch kBoxWidth {
        case 0.3:
            btLarge.backgroundColor = selectedControllColor
        case 0.2:
            btNormal.backgroundColor = selectedControllColor
        case 0.15:
            btSmall.backgroundColor = selectedControllColor
        default:
            btNormal.backgroundColor = selectedControllColor
        }

        // Distance
        switch distanceRange {
        case 0.5 ... 0.8:
            btLong.backgroundColor = selectedControllColor
        case 0.25 ... 0.5:
            btNormalDistance.backgroundColor = selectedControllColor
        case 0.2 ... 0.25:
            btShort.backgroundColor = selectedControllColor
        default:
            btNormalDistance.backgroundColor = selectedControllColor
        }
    }
}
