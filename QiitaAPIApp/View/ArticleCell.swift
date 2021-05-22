//
//  ArticleCell.swift
//  QiitaAPIApp
//
//  Created by 藤井凜 on 2021/03/31.
//

import UIKit

class ArticleCell: UITableViewCell {
  
  
  @IBOutlet weak var articleTitleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var likeCountLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.selectionStyle = .none
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
