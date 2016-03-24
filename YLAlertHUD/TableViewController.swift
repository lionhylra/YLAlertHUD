//
//  TableViewController.swift
//  YLAlertHUD
//
//  Created by HeYilei on 7/03/2016.
//  Copyright © 2016 lionhylra. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(image: UIImage(named: "panda"))
        imageView.contentMode = .ScaleAspectFill
        tableView.backgroundView = imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func show(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view, animated: true, hideAfterDelay: nil){
            (hud) -> Void in
            hud.theme = .Light
            hud.backgroundStyle = .Blur
            hud.position = .Center
            hud.label.text = "Hello World, this HUD will persist in the view unless you tap 'hide' button."
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func hide(){
        YLAlertHUD.HUDForView(self.navigationController!.view)?.hide(true)
    }
    
    @IBAction func darkCenterText(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view, animated: true) { (hud) -> Void in
            hud.theme = .Dark
            hud.position = .Center
            hud.label.text = "Hello World"
            hud.imageView.image = nil
            hud.backgroundStyle = .SolidColor
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func lightTopTextImage(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view) { (hud) -> Void in
            hud.theme = .Light
            hud.position = .Top
            hud.label.text = "Hello World"
            hud.imageView.image = UIImage(named: "close")
            hud.backgroundStyle = .SolidColor
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func extraLightBottomImage(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view, animated: true) { (hud) -> Void in
            hud.theme = .ExtraLight
            hud.position = .Bottom
            hud.label.text = nil
            hud.imageView.image = UIImage(named: "checkmark")
            hud.backgroundStyle = .SolidColor
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func darkUpperLeftText(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view) { (hud) -> Void in
            hud.theme = .Dark
            hud.position = .UpperLeft
            hud.label.text = "Hello World."
            hud.imageView.image = nil
            hud.backgroundStyle = .Blur
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func lightUpperRightImage(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view) { (hud) -> Void in
            hud.theme = .Light
            hud.position = .UpperRight
            hud.label.text = nil
            hud.imageView.image = UIImage(named: "cross")
            hud.backgroundStyle = .Blur
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func lextraLghtLowerLeftTextImage(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view) { (hud) -> Void in
            hud.theme = .ExtraLight
            hud.position = .LowerLeft
            hud.label.text = "OK"
            hud.imageView.image = UIImage(named: "checkmark")
            hud.backgroundStyle = .Blur
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }

    @IBAction func darkLowerRightTextImage(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view, animated: true, hideAfterDelay: 1.5) { (hud) -> Void in
            hud.theme = .Dark
            hud.position = .LowerRight
            hud.label.text = "Ice Ice Baby"
            hud.imageView.image = UIImage(named: "cross")
            hud.backgroundStyle = .Blur
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func switchTextImage(){
        
        let HUD = YLAlertHUD.showHUDAddedToView(self.navigationController!.view, animated: true, hideAfterDelay: nil) { (hud) -> Void in
            hud.theme = .Dark
            hud.position = .Center
            hud.label.text = "Wait 6 seconds."
            hud.imageView.image = nil
            hud.backgroundStyle = .Blur
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
        
        runOnGlobalQueue { [weak HUD]() -> Void in
            sleep(2)
            runOnMainQueue({ () -> Void in
                HUD?.label.text = "Hello world!"
            })
            sleep(2)
            runOnMainQueue({ () -> Void in
                HUD?.label.text = nil
                HUD?.imageView.image = UIImage(named: "checkmark")
            })
            sleep(2)
            runOnMainQueue({ () -> Void in
                HUD?.hide(true)
            })
        }
        
    }
    
    @IBAction func noAnimation(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view, animated: false, hideAfterDelay: 2){(hud)->Void in
            hud.label.text = "Please wait"
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
    @IBAction func longText(){
        YLAlertHUD.showHUDAddedToView(self.navigationController!.view){(hud)->Void in
            hud.label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliter homines, aliter philosophos loqui putas oportere? Omnes enim iucundum motum, quo sensus hilaretur."
            hud.adjustOffsetForNavigationBar = true
            hud.adjustOffsetForTabBar = true
        }
    }
    
}
