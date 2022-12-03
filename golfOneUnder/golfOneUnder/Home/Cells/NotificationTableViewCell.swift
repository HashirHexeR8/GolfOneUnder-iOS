//
//  NotificationTableViewCell.swift
//  golfOneUnder
//
//  Created by Muhammad Hashir on 12/1/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceName: UILabel!
    
    private var onTapViewLocation: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTapViewLocationButton(_ sender: Any) {
        onTapViewLocation!()
    }
    
    func setupCell(deviceInfo: DeviceInfoDTO, onTapLocation: @escaping (() -> ())) {
        self.onTapViewLocation = onTapLocation
        deviceName.text = deviceInfo.deviceName
    }
    

}
