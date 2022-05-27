//
//  ViewController.swift
//  PDF-Demo
//
//  Created by lan on 2017/6/27.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

import UIKit
import PDFKit
import SnapKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    private lazy var pdfContentView: UIView = buildPdfContentView()
    private lazy var pdfdocument: PDFDocument? = buildPdfdocument()
    private lazy var pdfview: PDFView = buildPdfview()
    private lazy var pdfThumbView: PDFThumbnailView = buildPdfThumbView()
    private lazy var m_btn: UIButton = buildBtn()
    /// 当前界面显示为竖屏状态
    private var m_theCurrentInterfaceIsDisplayed:Bool = true
    
    private var leftSwipeGesture: UISwipeGestureRecognizer?
    private var rightSwipeGesture: UISwipeGestureRecognizer?

    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if !m_theCurrentInterfaceIsDisplayed {
            return .landscapeLeft
        }
        return .portrait
    }
    
    @objc func tapPdfview(_ ges: UITapGestureRecognizer) {
        pdfThumbView.isHidden = !pdfThumbView.isHidden
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pdfContentView)
        pdfContentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(0)
            make.height.equalTo(250)
            make.top.equalTo(view.snp_topMargin)
        }
        
        pdfview.document = pdfdocument
        view.addSubview(m_btn)
        configPortraitUI()
    }
    private func configPortraitUI() {
        
        pdfContentView.addSubview(pdfview)
        pdfContentView.addSubview(pdfThumbView)
        
 
       
        pdfview.snp.remakeConstraints { make in
            make.edges.equalTo(pdfContentView)
        }
         
        pdfThumbView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(pdfview)
            make.height.equalTo(50)
            make.bottom.equalTo(pdfview.snp.bottom)
        }
        
        m_btn.snp.remakeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(-70)
        }
    }
    private func configLandscapeLeftUI() {
        
        view.addSubview(pdfview)
        view.addSubview(pdfThumbView)
        
 
       
        pdfview.snp.remakeConstraints { make in
            make.edges.equalTo(view)
        }
         
        pdfThumbView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(pdfview)
            make.height.equalTo(50)
            make.bottom.equalTo(pdfview.snp.bottom)
        }
        view.bringSubviewToFront(m_btn)
        m_btn.snp.remakeConstraints { make in
            make.trailing.equalTo(-70)
            make.top.equalTo(70)
        }
    }
    @objc func clickBtn(_ sender: UIButton) {
        if m_theCurrentInterfaceIsDisplayed {
            m_theCurrentInterfaceIsDisplayed = false
            interfaceOrientation(.landscapeLeft)
            // 横屏UI
            configLandscapeLeftUI()
        } else {
            m_theCurrentInterfaceIsDisplayed = true
            interfaceOrientation(.portrait)
            // 竖屏UI
            configPortraitUI()
        }
    }
    private func buildBtn() -> UIButton {
        
        let btn = UIButton(type: .custom)
        btn.setTitle("旋转", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        return btn
    }
    private func buildPdfContentView() -> UIView {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }
    
    private func buildPdfThumbView() -> PDFThumbnailView {
        let view  = PDFThumbnailView()
        view.layoutMode = .horizontal
        view.pdfView = pdfview
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }
    private func buildPdfdocument() -> PDFDocument? {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "pdf") else {
            return nil
        }
        let doc = PDFDocument(url: url)
        return doc
    }
    
    private func buildPdfview() -> PDFView {
        let pdf = PDFView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPdfview))
        pdf.addGestureRecognizer(tap)
        
        pdf.displayMode = .singlePage
        pdf.displayDirection = .horizontal
        pdf.autoScales = true
        //setting swipe gesture
                leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(respondLeftSwipeGesture ))
                leftSwipeGesture?.direction = [UISwipeGestureRecognizer.Direction.left]
        pdf.addGestureRecognizer(leftSwipeGesture!)
                
                rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(respondRightSwipeGesture ))
                rightSwipeGesture?.direction = [UISwipeGestureRecognizer.Direction.right]
        pdf.addGestureRecognizer(rightSwipeGesture!)
        
        leftSwipeGesture?.delegate = self
            leftSwipeGesture?.cancelsTouchesInView = false
            rightSwipeGesture?.delegate = self
            rightSwipeGesture?.cancelsTouchesInView = false
        return pdf
    }
    @objc func respondLeftSwipeGesture(_ sender: UISwipeGestureRecognizer) {
        if pdfview.document == nil { return }
               let scaleOfPdf = pdfview.scaleFactor
        pdfview.goToNextPage(self)
        pdfview.scaleFactor = scaleOfPdf
        }
        
        @objc func respondRightSwipeGesture(_ sender: UISwipeGestureRecognizer) {
            if pdfview.document == nil { return }
            let scaleOfPdf = pdfview.scaleFactor
            pdfview.goToPreviousPage(self)
            pdfview.scaleFactor = scaleOfPdf
        }
    
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == leftSwipeGesture
            || gestureRecognizer == rightSwipeGesture
            || otherGestureRecognizer == leftSwipeGesture
            || otherGestureRecognizer == rightSwipeGesture
    }
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        return otherGestureRecognizer == leftSwipeGesture
            || otherGestureRecognizer == rightSwipeGesture
    }
     func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let _ = otherGestureRecognizer as? UIPanGestureRecognizer else { return false }
        return gestureRecognizer == leftSwipeGesture
            || gestureRecognizer == rightSwipeGesture
    }
}

 
