//
//  PhotoViewController.swift
//  facebook
//
//  Created by Wanting Huang on 2/28/15.
//  Copyright (c) 2015 Wan-Ting Huang. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoActions: UIImageView!
    @IBOutlet weak var doneButton: UIImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var imageHolder: UIImage!
    var imageViewOriginalCenter: CGPoint!
    var translation:CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        imageView.image = imageHolder

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func didPanImageView(sender: UIPanGestureRecognizer) {
     
        translation = sender.translationInView(view)
        
        if (sender.state == UIGestureRecognizerState.Began){
            imageViewOriginalCenter = imageView.center
            
        } else if (sender.state == UIGestureRecognizerState.Changed) {
            
            imageView.center = CGPoint(x: imageViewOriginalCenter.x, y: imageViewOriginalCenter.y + translation.y)
            
            backgroundView.backgroundColor = UIColor(white: 0, alpha: max(0.5, 1 - translation.y/100))
            doneButton.alpha = 0
            photoActions.alpha = 0
            

        } else if (sender.state == UIGestureRecognizerState.Ended) {
            dismissViewControllerAnimated(true, completion: nil)

        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
