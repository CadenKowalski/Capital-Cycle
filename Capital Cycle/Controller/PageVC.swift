//
//  PageVC.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 6/17/19.
//  Copyright © 2019 Caden Kowalski. All rights reserved.
//

import UIKit
import FirebaseAuth

class PageVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pageControl = UIPageControl()
    lazy var orderedVCs: [UIViewController] = {
        return [self.newVC(VC: "PageOne"), self.newVC(VC: "PageTwo"), self.newVC(VC: "PageThree"), self.newVC(VC: "PageFour")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        if let firstVC = orderedVCs.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }

        self.delegate = self
        configurePageControl()
    }
    
    // MARK: Set Up Page View Controller
    
    func configurePageControl() {
        if Auth.auth().currentUser?.uid == "fipBSdkNpZXSsr26UGDFvY3zRa52" {
            orderedVCs.append(self.newVC(VC: "PageFive"))
        }
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.numberOfPages = orderedVCs.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        if traitCollection.userInterfaceStyle == .light {
            pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        } else {
            pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
        }
            
        self.view.addSubview(pageControl)
    }
    
    func newVC(VC: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: VC)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore VC: UIViewController) -> UIViewController? {
        guard let VCIndex = orderedVCs.firstIndex(of: VC) else {
            return nil
        }
        
        let previousIndex = VCIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedVCs.count > previousIndex else {
            return nil
        }
        
        return orderedVCs[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter VC: UIViewController) -> UIViewController? {
        guard let VCIndex = orderedVCs.firstIndex(of: VC) else {
            return nil
        }
        
        let nextIndex = VCIndex + 1
        
        guard orderedVCs.count != nextIndex else {
            return nil
        }
        
        guard orderedVCs.count > nextIndex else {
            return nil
        }
        
        return orderedVCs[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentVC = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedVCs.firstIndex(of: pageContentVC)!
    }
}
