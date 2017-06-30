


import Foundation
import UIKit

protocol PassChanneldataDelegate {
    
    func passChannelData(value: String)
}


class ChannelPicker: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let channel_array = ["Auto", "1 (2.412 GHz)", "2 (2.417 GHz)", "3 (2.422 GHz)", "4 (2.427 GHz)", "5 (2.432 GHz)", "6 (2.437 GHz)", "7 (2.442 GHz)", "8 (2.447 GHz)", "9 (2.452 GHz)", "10 (2.457 GHz)", "11 (2.462 GHz)"]

    var delegate : PassChanneldataDelegate?

    
    @IBOutlet weak var channelPicker: UIPickerView!
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButton(_ sender: Any) {
        if delegate != nil {
            let row = channelPicker.selectedRow(inComponent: 0)
            print("nunu", channel_array[row])
            self.delegate?.passChannelData(value: channel_array[row])
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return channel_array.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return channel_array[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(channel_array[row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        channelPicker.dataSource = self
        channelPicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
