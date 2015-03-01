//
//  FeedViewController.swift
//  facebook
//
//  Created by Wanting Huang on 2/28/15.
//  Copyright (c) 2015 Wan-Ting Huang. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool = true

    @IBOutlet weak var feedScrollView: UIScrollView!
    var selectedImageView: UIImageView!
    var translationPass:CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        feedScrollView.contentSize = CGSize(width: 320, height: 1438)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationViewController = segue.destinationViewController as PhotoViewController
            
        // Passing selected image to the next screen
        destinationViewController.imageHolder = selectedImageView.image
        // Pass translation
        destinationViewController.translation = translationPass
        
        // Custom transition
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        
        
        
        if (isPresenting) {
   
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            
            // Set from and to controllers
            var tabViewController = fromViewController as UITabBarController
            // Hide feedViewController
            var feedViewController = tabViewController.viewControllers![0] as FeedViewController
            feedViewController.selectedImageView.hidden = true
            // Hide photoViewController
            var photoViewController = toViewController as PhotoViewController
            photoViewController.imageView.hidden = true
            
            // Create a subview to show the scaling image
            var movingImageView = UIImageView(image: selectedImageView.image)
            var newFrame = containerView.convertRect(selectedImageView.frame, fromView:feedScrollView)
            
            movingImageView.frame = CGRectMake(newFrame.origin.x,newFrame.origin.y,newFrame.width,newFrame.height)
            movingImageView.contentMode = selectedImageView.contentMode
            movingImageView.clipsToBounds = selectedImageView.clipsToBounds
            containerView.addSubview(movingImageView)
            

    
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                
                // Set the moving view to the position of the image view in next screen
                
                var sx:CGFloat = self.selectedImageView.image!.size.width / photoViewController.imageView.frame.width
                var sy:CGFloat = self.selectedImageView.image!.size.height / photoViewController.imageView.frame.height

                if (sx > sy){ //If width is the limiting factor
                     movingImageView.frame = CGRectMake(0,(photoViewController.imageView.frame.height - self.selectedImageView.image!.size.height/sx)/2+55,320, self.selectedImageView.image!.size.height/sx)
                } else {
                    movingImageView.frame = CGRectMake(0,55,self.selectedImageView.image!.size.width/sy, 469)
                }
                
                toViewController.view.alpha = 1
                

                //movingImageView.frame = photoViewController.imageView.frame
                
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    movingImageView.removeFromSuperview()
                    //show photoViewController
                    photoViewController.imageView.hidden = false
            }
        } else {
            
            // Set from and to controllers
            var tabViewController = toViewController as UITabBarController
            // Hide feedViewController
            var feedViewController = tabViewController.viewControllers![0] as FeedViewController
            feedViewController.selectedImageView.hidden = true
            // Hide photoViewController
            var photoViewController = fromViewController as PhotoViewController
            photoViewController.imageView.hidden = true
            
            // Create a subview to show the scaling image
            var sx:CGFloat = self.selectedImageView.image!.size.width / photoViewController.imageView.frame.width
            var sy:CGFloat = self.selectedImageView.image!.size.height / photoViewController.imageView.frame.height
            var movingImageView = UIImageView(image: selectedImageView.image)
            
            
            
            //println(translationPass)
            
            if (sx > sy){ //If width is the limiting factor
                movingImageView.frame = CGRectMake(0,(photoViewController.imageView.frame.height - self.selectedImageView.image!.size.height/sx)/2 + 55,320, self.selectedImageView.image!.size.height/sx)
            } else {
                movingImageView.frame = CGRectMake(0,(photoViewController.imageView.frame.height - 469)/2 + 55,self.selectedImageView.image!.size.width/sy, 469)
            }
            
            movingImageView.contentMode = selectedImageView.contentMode
            movingImageView.clipsToBounds = selectedImageView.clipsToBounds
            containerView.addSubview(movingImageView)
            
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                
                // Set the moving view to the position of the image view in the previous screen
                
                var newFrame = containerView.convertRect(self.selectedImageView.frame, fromView:self.feedScrollView)
                
                movingImageView.frame = CGRectMake(newFrame.origin.x, newFrame.origin.y, self.selectedImageView.frame.width, self.selectedImageView.frame.height)
                fromViewController.view.alpha = 0


                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    //movingImageView.removeFromSuperview()
                    fromViewController.view.removeFromSuperview()
                    feedViewController.selectedImageView.hidden = false
                 
            }
        }
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        
        selectedImageView = sender.view as UIImageView
        
        performSegueWithIdentifier("photoSegue", sender: self)
        
        
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
