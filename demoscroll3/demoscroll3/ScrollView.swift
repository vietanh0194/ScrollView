//
//  ScrollView.swift
//  demoscroll3
//
//  Created by Viet Anh on 3/28/17.
//  Copyright © 2017 Viet Anh. All rights reserved.
//

import UIKit

class ScrollView: UIViewController ,UIScrollViewDelegate{
    var photo: [UIImageView] = []
    var pageImages:[String] = []
    var currentPage = 0
    var first = false
    var Next: Int = 0
    var frontScrollViews : [UIScrollView] = []
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageController: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImages = ["anh1","anh2","anh3"]
        //tinh so trang page
        pageController.currentPage = 0
        //
        // so page cua page = tong so phan tu cua mang
        pageController.numberOfPages = pageImages.count
        //
    }
//    override func viewDidLayoutSubviews() {
//        if (!first) {
//            first = true
//        
//        // dien tich cua scroll view
//        let pageScrollViewSize = scrollView.frame.size
//        //
//        // tinh do dai bang cach lay so anh nhan voi chieu rong cua frame
//        scrollView.contentOffset = CGPoint(x: CGFloat(currentPage) * scrollView.frame.width , y: 0 )
//        //quy dinh do rong
//        scrollView.contentSize = CGSize(width: pageScrollViewSize.width * CGFloat(pageImages.count), height: 0)
//        //lap tu 0 den tong so phan tu cua mang
//        for index in 0..<pageImages.count {
//            //them anh bang imgview
//            let imgView = UIImageView(image: UIImage(named: pageImages[index] + ".jpg"))
//            imgView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
//            //anh hien thi truc tiep theo kich thuoc cua imaageview vd o day la scroll view chi hien thi 1 man hinh 1 anh k bi chay
//            imgView.contentMode = .scaleAspectFit
//            //
//          
//            //su kien tap
//            imgView.isUserInteractionEnabled = true
//            imgView.isMultipleTouchEnabled = true
//            let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg))
//            tap.numberOfTapsRequired = 1
//            imgView.addGestureRecognizer(tap)
//            let doubletap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg))
//            doubletap.numberOfTapsRequired = 2
//            imgView.addGestureRecognizer(doubletap)
//            tap.require(toFail: doubletap)
//            let frontScrollView = UIScrollView(frame: CGRect(x:CGFloat(index) * scrollView.frame.size.width , y: 0 , width: scrollView.frame.size.width, height: scrollView.frame.size.height ))
////            photo.append(imgView)
//            frontScrollView.minimumZoomScale = 1
//            frontScrollView.maximumZoomScale = 2
//            frontScrollView.delegate = self
//            frontScrollView.addSubview(imgView)
//            frontScrollViews.append(frontScrollView)
//            self.scrollView.addSubview(frontScrollView)
//        }
//        }
//    }
    override func viewDidLayoutSubviews() {
        if (!first) {
            first = true
            
            let pagesScrollViewSize = scrollView.frame.size
            //tinh do dai bang bao nhieu anh trong mang
            scrollView.contentOffset = CGPoint(x: CGFloat(currentPage) * scrollView.frame.size.width, y: 0)
            scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count), height: 0)
            //
            for index in 0..<pageImages.count {
                let imgView = UIImageView(image: UIImage(named: pageImages[index] + ".jpg"))
                
                imgView.frame = CGRect(x: 0, y: 0 ,
                                       width: scrollView.frame.size.width , height: scrollView.frame.size.height)
                imgView.contentMode = .scaleAspectFit
                
                imgView.isUserInteractionEnabled = true
                imgView.isMultipleTouchEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapImg))
                ////        //quy dinh tap may lan
                tap.numberOfTapsRequired = 1
                ////        //
                imgView.addGestureRecognizer(tap)
                let doubletap = UITapGestureRecognizer(target: self, action: #selector(doubleTapImg))
                doubletap.numberOfTapsRequired = 2
                //
                tap.require(toFail: doubletap)
                imgView.addGestureRecognizer(doubletap)
                photo.append(imgView)
                let frontScrollView = UIScrollView(frame: CGRect(x: CGFloat(index) * scrollView.frame.size.width, y: 0 ,
                                                                 width: scrollView.frame.size.width , height: scrollView.frame.size.height))
                frontScrollView.minimumZoomScale = 1
                frontScrollView.maximumZoomScale = 2
                frontScrollView.delegate = self
                frontScrollView.addSubview(imgView)
                frontScrollViews.append(frontScrollView)
                self.scrollView.addSubview(frontScrollView)
            }
        }
    }

    func tapImg(gesture: UITapGestureRecognizer){
        //location lay ra vi tri tap tren view
        let position = gesture.location(in: photo[pageController.currentPage])
        zoomRectForScale(scale: frontScrollViews[pageController.currentPage].zoomScale * 1.5 , center : position)
        
    }
    func doubleTapImg(gesture: UITapGestureRecognizer){
        let position = gesture.location(in: photo[pageController.currentPage])
        zoomRectForScale(scale: frontScrollViews[pageController.currentPage].zoomScale * 0.5, center: position)
        //        print("aaaabbb")
    }
    
    func zoomRectForScale(scale: CGFloat ,center: CGPoint){
        var zoomRect = CGRect()
        let scrollViewSize = scrollView.bounds.size
        zoomRect.size.height = scrollViewSize.height / scale
        zoomRect.size.width = scrollViewSize.width / scale
        //origin la toa do cua vi tri nhan
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        frontScrollViews[pageController.currentPage].zoom(to: zoomRect, animated: true)
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo[pageController.currentPage]
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((self.scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        if (pageController.currentPage != page) {
            frontScrollViews[pageController.currentPage].zoomScale = 1
            pageController.currentPage = page
        }
    }

    @IBAction func onChange(_ sender: Any) {
        scrollView.contentOffset = CGPoint(x:
            CGFloat(pageController.currentPage) * scrollView.frame.size.width,y:0)
        pageController.currentPage = Next
        print(pageController.currentPage)
       
    }

    @IBAction func btn_Back(_ sender: Any) {
        if (Next == 0) {
            scrollView.contentOffset = CGPoint(x: CGFloat(2) * scrollView.frame.size.width, y: 0)
            Next = 2
           
        }
        else {
            scrollView.contentOffset = CGPoint(x: CGFloat(Next - 1) * scrollView.frame.size.width,y : 0)
            Next -= 1
               }
    }
    
    @IBAction func btn_Next(_ sender: Any) {
        
        if (Next == 2) {
            scrollView.contentOffset = CGPoint(x: 0 , y: 0)
            Next = 0
           
        }else{
            scrollView.contentOffset = CGPoint(x: CGFloat(Next + 1) * scrollView.frame.size.width,y: 0)
            print(Next)
          
            Next += 1
        }
            }
 
    
}
