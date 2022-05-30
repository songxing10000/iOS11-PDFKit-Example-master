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

class ViewController: UIViewController  {
    private lazy var pdfContentView: UIView = buildPdfContentView()
    private lazy var pdfdocument: PDFDocument? = buildPdfdocument()
    private lazy var pdfview: PDFView = buildPdfview()
    private lazy var pdfThumbView: PDFThumbnailView = buildPdfThumbView()
    private lazy var m_btn: UIButton = buildBtn()
    /// 当前界面显示为竖屏状态
    private var m_theCurrentInterfaceIsDisplayed:Bool = true
    
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
        // 16/9=w/?
        let desH = (UIScreen.main.bounds.size.width*9.0/16.0)
        pdfContentView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(0)
            
            make.height.equalTo(desH)
            make.top.equalTo(view.snp_topMargin)
        }
        
        pdfview.document = pdfdocument
        view.addSubview(m_btn)
        configPortraitUI()
    }
    private func configPortraitUI() {
        
        pdfContentView.addSubview(pdfview)
        pdfContentView.addSubview(pdfThumbView)
        
        view.backgroundColor = .white
        pdfContentView.backgroundColor =  .white
        
        
        pdfview.snp.remakeConstraints { make in
            make.edges.equalTo(pdfContentView)
        }
        
        pdfThumbView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(pdfview)
            make.height.equalTo(40)
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
        
        view.backgroundColor = .black
        pdfContentView.backgroundColor =  .black
        
        pdfview.snp.remakeConstraints { make in
            make.edges.equalTo(view)
            
        }
        
        pdfThumbView.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(pdfview)
            make.height.equalTo(40)
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
        view.thumbnailSize = CGSize(width: 24, height: 32)
        view.pdfView = pdfview
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        return view
    }
    private func buildPdfdocument() -> PDFDocument? {
        guard let url = Bundle.main.url(forResource: "【ppt】工程行为守则与工程行为规范标准培训", withExtension: "pdf") else {
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
        // 这个方法好啊，自动添加左右滑动，滑动效果好，流畅
        // 不用自己添加左右滑动手势了,且自己添加左右滑动手势，滑动太生硬
        pdf.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.interPageSpacing: 10])

        return pdf
         
    }
     
}


