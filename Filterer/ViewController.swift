//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var selectedColor: String = "red"
    var filteredImage: UIImage?
    var originalImage: UIImage?
    var imageSlide: UIImage?
    let imageSample = UIImage(named:"scenery.png")
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var labelView: UIView!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var slideView: UIView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet var filterButton: UIButton!
    
    @IBOutlet weak var onFilterRed: UIButton!
    @IBOutlet weak var onFilterGreen: UIButton!
    @IBOutlet weak var onFilterBlue: UIButton!
    @IBOutlet weak var onFilterYellow: UIButton!
    @IBOutlet weak var onFilterPurple: UIButton!
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet var imageViewNew: UIImageView!
    
    @IBOutlet weak var slideBar: UISlider!
    
    override func viewDidLoad() {
        imageView.alpha=1.0
        super.viewDidLoad()
        
        imageView.image = imageSample
        originalImage = imageSample
        
        compareButton.enabled = false
        editButton.enabled = false
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.toggleImage))
        imageView.addGestureRecognizer(longPressGesture)
        imageViewNew.addGestureRecognizer(longPressGesture)
        imageView.userInteractionEnabled = true
        imageViewNew.userInteractionEnabled = true

    }
    
    func toggleImage(sender: UILongPressGestureRecognizer){
        if sender.state == .Began{
            let image=originalImage
            imageView.image=image
            //imageViewNew.image=image
            UIView.animateWithDuration(0.5){
                self.imageView.alpha=1.0
                self.imageViewNew.alpha=0
            }
            showOriginalLabel()

        }
        else {
            hideOriginalLabel()
            //imageView.image = filteredImage
            imageViewNew.image = filteredImage
            UIView.animateWithDuration(0.5){
                self.imageView.alpha=0
                self.imageViewNew.alpha=1.0
            }
        }
        
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
//        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.image = image
//            originalImage = image
//        }
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        originalImage = image
        imageView.alpha=1.0
        imageViewNew.alpha=0
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func filterActionRed(sender: UIButton) {

            selectedColor = "red"
            hideOriginalLabel()
            redFilter()
            imageViewNew.image=filteredImage
            showNewImage()

    }
    
   
    @IBAction func filterActionGreen(sender: UIButton) {
        selectedColor = "green"
            hideOriginalLabel()
            greenFilter()
            imageViewNew.image=filteredImage
            showNewImage()
        }

    
    @IBAction func filterActionBlue(sender: UIButton) {
        selectedColor = "blue"
            hideOriginalLabel()
            blueFilter()
            imageViewNew.image=filteredImage
            showNewImage()


    }
    
    @IBAction func filterActionYellow(sender: UIButton) {
        
        selectedColor = "yellow"
            hideOriginalLabel()
            yellowFilter()
            imageViewNew.image=filteredImage
            showNewImage()
    }
    
    @IBAction func filterActionPurple(sender: UIButton) {
        selectedColor = "purple"
            hideOriginalLabel()
            purpleFilter()
            imageViewNew.image=filteredImage
            showNewImage()

    }
    
    
    func redFilter(){
        imageView.image = originalImage
        imageView.alpha = 1.0
        let image=imageView.image!
        let myRGBA = RGBAImage(image: image)!
        
        var totalRed=0
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                totalRed+=Int(pixel.red)
                
            }
        }
        
        let count=myRGBA.width*myRGBA.height
        
        let avgRed=totalRed/count
        //let avgBlue=83
        //let avgGreen=98
        
        //let sum = avgRed + avgGreen + avgBlue
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                let redDelta=Int(pixel.red)-avgRed
                var modifier = 1+4*(Double(y)/Double(myRGBA.height))
                if (Int(pixel.red)<avgRed){
                    modifier = 1
                }
                pixel.red = UInt8(max(min(255,Int(round(Double(avgRed)+modifier*Double(redDelta)))),0))
                myRGBA.pixels[index] = pixel
            }
            
        }
        
        filteredImage = myRGBA.toUIImage()
        
    }
    
    func greenFilter(){
        let image=imageView.image!
        let myRGBA = RGBAImage(image: image)!
        
        var totalGreen=0
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                totalGreen+=Int(pixel.green)
                
            }
        }
        
        let count=myRGBA.width*myRGBA.height
        
        let avgGreen=totalGreen/count
        //let avgBlue=83
        //let avgGreen=98
        
        //let sum = avgRed + avgGreen + avgBlue
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                let greenDelta=Int(pixel.green)-avgGreen
                var modifier = 1+4*(Double(y)/Double(myRGBA.height))
                if (Int(pixel.green)<avgGreen){
                    modifier = 1
                }
                pixel.green = UInt8(max(min(255,Int(round(Double(avgGreen)+modifier*Double(greenDelta)))),0))
                myRGBA.pixels[index] = pixel
            }
            
        }
        
        filteredImage = myRGBA.toUIImage()
    
    }
    
    
    func blueFilter(){
        
        let image=imageView.image!
        let myRGBA = RGBAImage(image: image)!
        
        var totalBlue=0
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                totalBlue+=Int(pixel.blue)
                
            }
        }
        
        let count=myRGBA.width * myRGBA.height
        
        let avgBlue=totalBlue/count
        
        //let sum = avgRed + avgGreen + avgBlue
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                let blueDelta=Int(pixel.blue)-avgBlue
                var modifier = 1+4*(Double(y)/Double(myRGBA.height))
                if (Int(pixel.blue)<avgBlue){
                    modifier = 1
                }
                pixel.blue = UInt8(max(min(255,Int(round(Double(avgBlue)+modifier*Double(blueDelta)))),0))
                myRGBA.pixels[index] = pixel
            }
            
        }
        
        filteredImage = myRGBA.toUIImage()
        
    }

    func yellowFilter(){
        let image=imageView.image!
        let myRGBA = RGBAImage(image: image)!
        
        var totalGreen = 0
        var totalRed = 0
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                totalGreen+=Int(pixel.green)
                totalRed+=Int(pixel.red)
                
            }
        }
        
        let count=myRGBA.width*myRGBA.height
        
        let avgGreen=totalGreen/count
        let avgRed=totalRed/count
        //let avgBlue=83
        //let avgGreen=98
        
        //let sum = avgRed + avgGreen + avgBlue
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                let greenDelta=Int(pixel.green)-avgGreen
                let redDelta=Int(pixel.red)-avgRed
                var modifier = 1+4*(Double(y)/Double(myRGBA.height))
                if (Int(pixel.green)<avgGreen && Int(pixel.red)<avgRed){
                    modifier = 1
                }
                pixel.green = UInt8(max(min(255,Int(round(Double(avgGreen)+modifier*Double(greenDelta)))),0))
                pixel.red = UInt8(max(min(255,Int(round(Double(avgRed)+modifier*Double(redDelta)))),0))
                myRGBA.pixels[index] = pixel
            }
            
        }
        
        filteredImage = myRGBA.toUIImage()
    }
    
    func purpleFilter(){
        let image=imageView.image!
        let myRGBA = RGBAImage(image: image)!
        
        var totalBlue = 0
        var totalRed = 0
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                totalBlue+=Int(pixel.blue)
                totalRed+=Int(pixel.red)
                
            }
        }
        
        let count=myRGBA.width*myRGBA.height
        
        let avgBlue=totalBlue/count
        let avgRed=totalRed/count
        //let avgBlue=83
        //let avgGreen=98
        
        //let sum = avgRed + avgGreen + avgBlue
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                let blueDelta=Int(pixel.blue)-avgBlue
                let redDelta=Int(pixel.red)-avgRed
                var modifier = 1+4*(Double(y)/Double(myRGBA.height))
                if (Int(pixel.blue)<avgBlue && Int(pixel.red)<avgRed){
                    modifier = 1
                }
                pixel.green = UInt8(max(min(255,Int(round(Double(avgBlue)+modifier*Double(blueDelta)))),0))
                pixel.red = UInt8(max(min(255,Int(round(Double(avgRed)+modifier*Double(redDelta)))),0))
                myRGBA.pixels[index] = pixel
            }
            
        }
        
        filteredImage = myRGBA.toUIImage()
    }
    
    
    @IBAction func editAction(sender: UIButton) {
        if(editButton.selected){
            hideSlideBar()
            editButton.selected = false
        }
        else{
            showSlideBar()
            editButton.selected = true
        }
    }
    
    @IBAction func slideActioin(sender: UISlider) {
        slideBar.minimumValue = 0
        slideBar.maximumValue = 255
        slideBar.continuous = true
        
        let image=imageView.image!
        let myRGBA = RGBAImage(image: image)!
        
        var totalBlue = 0
        var totalRed = 0
        var totalGreen = 0
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                totalBlue+=Int(pixel.blue)
                totalRed+=Int(pixel.red)
                totalGreen+=Int(pixel.green)
                
            }
        }
    
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y*myRGBA.width+x
                var pixel=myRGBA.pixels[index]
                switch selectedColor {
                case "red":
                    pixel.red = UInt8(slideBar.value);
                case "green":
                    pixel.green = UInt8(slideBar.value);
                case "blue":
                    pixel.blue = UInt8(slideBar.value);
                case "yellow":
                    pixel.red = UInt8(slideBar.value);
                    pixel.green = UInt8(slideBar.value);
                case "purple":
                    pixel.red = UInt8(slideBar.value);
                    pixel.blue = UInt8(slideBar.value);
                default:
                    pixel.red = UInt8(slideBar.value);
                }
                
                
                
                myRGBA.pixels[index] = pixel
            }
            
        }
    
        
        filteredImage = myRGBA.toUIImage()
        imageViewNew.image = myRGBA.toUIImage()

}
    
    @IBAction func onCompare(sender: UIButton) {
        if(compareButton.selected){
            hideOriginalLabel()
            imageViewNew.image=filteredImage
            UIView.animateWithDuration(5.0){
                self.imageView.alpha=0
                self.imageViewNew.alpha=1.0
            }
            compareButton.selected=false
        }
        else{
            let image=originalImage
            imageView.image=image
            //imageViewNew.image=image
            UIView.animateWithDuration(5.0){
                self.imageView.alpha=1.0
                self.imageViewNew.alpha=0
            }
            showOriginalLabel()
            
            compareButton.selected=true
        }
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            compareButton.enabled = false
            editButton.enabled = false
            sender.selected = false
        } else {
            showSecondaryMenu()
            compareButton.enabled = true
            editButton.enabled = true
            sender.selected = true
        }
    }
    
    func showOriginalLabel(){
        view.addSubview(labelView)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = labelView.topAnchor.constraintEqualToAnchor(view.topAnchor)
        let leftConstraint = labelView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = labelView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = labelView.heightAnchor.constraintEqualToConstant(44)
        NSLayoutConstraint.activateConstraints([topConstraint, leftConstraint, rightConstraint, heightConstraint])
        view.layoutIfNeeded()
        
    }
    
    func hideOriginalLabel(){
        labelView.removeFromSuperview()
    }
    
    func showNewImage(){
        view.addSubview(imageViewNew)
        imageViewNew.translatesAutoresizingMaskIntoConstraints=false
        //imageViewNew.backgroundColor = UIColor.blackColor()
        imageViewNew.contentMode = .ScaleAspectFit
        imageViewNew.backgroundColor = UIColor.blackColor()
        let bottomConstraint = imageViewNew.bottomAnchor.constraintEqualToAnchor(imageView.bottomAnchor)
        let leftConstraint = imageViewNew.leftAnchor.constraintEqualToAnchor(imageView.leftAnchor)
        let rightConstraint = imageViewNew.rightAnchor.constraintEqualToAnchor(imageView.rightAnchor)
        let topConstraint = imageViewNew.topAnchor.constraintEqualToAnchor(imageView.topAnchor)
        NSLayoutConstraint.activateConstraints([bottomConstraint, topConstraint, leftConstraint, rightConstraint])
        view.layoutIfNeeded()
        showSecondaryMenu()
        imageViewNew.alpha=0
        imageView.alpha = 1.0
        UIView.animateWithDuration(5.0){
            self.imageView.alpha=0
            self.imageViewNew.alpha=1.0
        }
        
    }
    
  
    func showSlideBar(){
        view.addSubview(slideView)
        
        slideView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = slideView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = slideView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = slideView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = slideView.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
    }
    
    func hideSlideBar(){
        slideView.removeFromSuperview()
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }

}

