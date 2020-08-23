//
//  ViewController.swift
//  aiksixer
//
//  Created by Shishir Ahmed on 8/8/20.
//  Copyright © 2020 Shishir Ahmed. All rights reserved.
//

import UIKit
import BSImagePicker
import Photos
import PDFKit
import MobileCoreServices

class ViewController: UIViewController {
    
    //MARK:: Properties
    
    var selectedImage = [UIImage]()
    var goto:Bool = false{
        didSet{
            if goto == true {
                if self.selectedImage.count > 0 {
                    let vc = FileViewVC.getInstance() as! FileViewVC
                    vc.selectedImage = self.selectedImage
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        selectedImage = [UIImage]()
    }
    
    //MARK:: Actions

    @IBAction func selectPhotos(_ sender: Any) {
        let imagePicker = ImagePickerController()
        imagePicker.settings.selection.max = 5
        imagePicker.settings.theme.selectionStyle = .numbered
        imagePicker.settings.fetch.assets.supportedMediaTypes = [.image]
        imagePicker.settings.selection.unselectOnReachingMax = true

        self.presentImagePicker(imagePicker, select: { (asset) in
            
            PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { (image, info) in
                guard let selecteImage = image else{return}
                self.selectedImage.append(selecteImage)
            }
            
        }, deselect: { (asset) in
           print("Deselected: \(asset)")
        }, cancel: { (assets) in
           print("Canceled with selections: \(assets)")
        }, finish: { (assets) in
            self.goto = true
        }, completion: {
        })
    }
    
    @IBAction func selectFiles(_ sender: Any) {
        let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key","public.image", "com.apple.application", "public.item","public.data", "public.content", "public.audiovisual-content", "public.movie", "public.audiovisual-content", "public.video", "public.audio", "public.text", "public.data", "public.zip-archive", "com.pkware.zip-archive", "public.composite-content", "public.text"], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = true
        documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)

    }
    
    @IBAction func captureImage(_ sender: Any) {
        let vc = CaptureViewVC.getInstance() as! CaptureViewVC
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    
    //MARK:: - Helpers
    
    func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
    
    func getPdfThumd(url: URL){
        guard let image = generatePdfThumbnail(of: CGSize(width: 100, height: 100), for: url, atPage: 0) else{ return}
        selectedImage.append(image)
        self.goto = true
    }
    
    func generateThumbnail(url: URL) {
        guard let image = UIImage(contentsOfFile: url.path) else { return }
        selectedImage.append(image)
        self.goto = true
    }
    
}

extension ViewController: UIDocumentPickerDelegate{
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urls: URL){
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        let fileType = urls.first?.pathExtension
        switch fileType {
        case "pdf" : self.getPdfThumd(url: urls.first!)
        case "doc", "docx" : self.generateThumbnail(url: urls.first!)
        default : print("It's unknown")
        }
    }
    

}

extension ViewController: ModalDelegate{
    func changeValue(value: [UIImage]) {
        self.selectedImage = value
        self.goto = true
    }
}
