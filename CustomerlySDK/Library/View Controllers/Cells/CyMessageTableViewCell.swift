//
//  CyMessageTableViewCell.swift
//  Customerly
//
//  Created by Paolo Musolino on 10/12/16.
//  Copyright © 2016 Customerly. All rights reserved.
//

import UIKit

class CyMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var adminAvatar: CyImageView!
    @IBOutlet weak var userAvatar: CyImageView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTextView: CyTextView!
    @IBOutlet weak var dateLabel: CyLabel!
    @IBOutlet weak var imagesTableView: CyTableView?
    @IBOutlet var messageViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var messageViewRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imagesTableViewHeightConstraint: NSLayoutConstraint?
    var vcThatShowThisCell : CyViewController?
    
    var imagesAttachments : [String] = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageView.layer.cornerRadius = 8.0
        messageTextView.textContainerInset = UIEdgeInsetsMake(2, 0, -12, 0) //remove padding
        adminAvatar.layer.cornerRadius = adminAvatar.frame.size.width/2 //Circular avatar for admin
        userAvatar.layer.cornerRadius = userAvatar.frame.size.width/2 //Circular avatar for user
        self.backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setAdminVisual(bubbleColor: UIColor? = UIColor(hexString: "#ECEFF1")){
        messageTextView.textAlignment = .left
        userAvatar.isHidden = true
        adminAvatar.isHidden = false
        messageViewRightConstraint.isActive = false
        messageViewLeftConstraint.isActive = true
        messageView.backgroundColor = bubbleColor
    }
    
    func setUserVisual(bubbleColor: UIColor? = UIColor(hexString: "#01B0FF")){
        userAvatar.isHidden = false
        adminAvatar.isHidden = true
        messageTextView.textAlignment = .right
        messageViewRightConstraint.isActive = true
        messageViewLeftConstraint.isActive = false
        messageView.backgroundColor = bubbleColor
    }
    
    func cellContainsImages(configForImages: Bool){
        if configForImages == true{
            imagesTableView?.register(UINib(nibName: "ImageMessageCell", bundle:CyBundle.getBundle()), forCellReuseIdentifier: "imageMessageCell")
            imagesTableView?.delegate = self
            imagesTableView?.dataSource = self
            imagesTableView?.reloadData()
        }
        else{
            imagesTableView = nil
            imagesTableView?.delegate = nil
            imagesTableView?.dataSource = nil
            imagesAttachments = []
        }
    }
}

extension CyMessageTableViewCell: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesAttachments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "imageMessageCell", for: indexPath) as! CyImageMassageTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.messageImageView.kf.indicatorType = .activity
        cell.messageImageView.kf.setImage(with: URL(string:imagesAttachments[indexPath.row]), placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
    
        imagesTableViewHeightConstraint?.constant = imagesTableView!.contentSize.height
        return cell
    }

}


extension CyMessageTableViewCell: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CyImageMassageTableViewCell
        if cell.messageImageView.image != nil{
            let galleryVC = CustomerlyGalleryViewController.instantiate()
            galleryVC.image = cell.messageImageView.image
            vcThatShowThisCell?.present(galleryVC, animated: true, completion: nil)
        }
    }
}

