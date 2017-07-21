//
//  MainWindowMobileSetSettingsDataModel9xx.swift
//  rutxxx_IOS
//
//  Created by Gediminas Urbonas on 30/05/2017.
//  Copyright © 2017 Teltonika. All rights reserved.
//

import Foundation
import UIKit


class MainWindowMobileSetSettingsDataModel9xx: UIViewController {
    
    internal func routerServicesSetMobileDataModel (params: [dataToShowMobileSettings], params1: [dataToShowMobileSettings], complete: @escaping ()->()){
        let token = UserDefaults.standard.value(forKey: "saved_token")
        
        
        if (params[0].value.isEmpty) {
            Json().deleteConfigInformation(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: APN) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }            }
        } else {
            Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: APN, value: params[0].value) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        if (!params[1].value.isEmpty) {
            Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: PIN_CODE, value: params[1].value) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        } else {
            Json().deleteConfigInformation(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: PIN_CODE) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        if (!params[2].value.isEmpty) {
            Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: DIALING_NUMBER, value: params[2].value) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        } else {
            Json().deleteConfigInformation(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: DIALING_NUMBER) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        if (!params[3].value.isEmpty) {
            Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: AUTHENTICATION, value: params[3].value.lowercased()) { (response) in
                print(response)
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
            if (!(params[3].value.lowercased() == "none")) {
                Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: USERNAME, value: params[5].value) { (response) in
                    print(response)
                    Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                    }
                }
                Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: PASSWORD, value: params[6].value) { (response) in
                    print(response)
                    Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                    }
                }
            }
        }
        if (!params[4].value.isEmpty) {
            Json().setConfigInformation(token: token as! String, config:SIM_CARD_CONFIG, section: SIM_CARD_1, configOption: SERVICE, value: checkServiceValue(value: params[4].value)) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        
        if (!params1[0].value.isEmpty) {
            Json().setSimCardApn(token: token as! String, simCardNumber: SIM_CARD_2, apnValue: params1[0].value, value: "apn") { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        } else {
            Json().deleteConfigInformation(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, configOption: APN) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        if (!params1[1].value.isEmpty) {
            Json().setSimCardApn(token: token as! String, simCardNumber: SIM_CARD_2, apnValue: params1[1].value, value: "pincode") { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        } else {
            Json().deleteConfigInformation(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, configOption: PIN_CODE) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        if (!params1[2].value.isEmpty) {
            Json().setSimCardApn(token: token as! String, simCardNumber: SIM_CARD_2, apnValue: params1[2].value, value: "dialnumber") { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        } else {
            Json().deleteConfigInformation(token: token as! String, config: SIM_CARD_CONFIG, section: SIM_CARD_2, configOption: DIALING_NUMBER) { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        
        if (!params1[3].value.isEmpty) {
            Json().setSimCardApn(token: token as! String, simCardNumber: SIM_CARD_2, apnValue: params1[3].value.lowercased(), value: "auth_mode") { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
            if (!(params1[3].value.lowercased() == "none")) {
                Json().setSimCardApn(token: token as! String, simCardNumber: SIM_CARD_2, apnValue: params1[5].value.lowercased(), value: "username") { (response) in
                    Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                    }
                }
                Json().setSimCardApn(token: token as! String, simCardNumber: SIM_CARD_2, apnValue: params1[6].value.lowercased(), value: "password") { (response) in
                    Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                    }
                    Json().luciReload(token: token as! String) { (json) in
                    }
                }
            }
        }
        
        if (!params1[4].value.isEmpty) {
            Json().setSimCardApn(token: token as! String, simCardNumber: SIM_CARD_2, apnValue: checkServiceValue(value: params1[4].value), value: "service") { (response) in
                Json().commitConfigsChanges(token: token as! String, config: simcard) { (json) in
                }
                Json().luciReload(token: token as! String) { (json) in
                }
            }
        }
        complete()
    }
    
    
    func checkServiceValue(value: String)->(String) {
        var result = ""
        
        let gprsOnly = "gprs-only", gprs = "gprs", umtsOnly = "umts-only", umts = "umts", lteOnly = "lte-only",
        lte = "lte", auto = "auto", twoGOnly = "2G only", twoGPreferred = "2G preferred", threeGOnly = "3G only",
        threeGPreferred = "3G preferred", fourGOnly = "4G (LTE) only", fourGPreferred = "4G (LTE) preferred",
        automatic = "Automatic"
        
        var upperCaseValue = value.uppercased()
        if (upperCaseValue == twoGOnly.uppercased()) {
            result = gprsOnly
        } else if upperCaseValue == twoGPreferred.uppercased() {
            result = gprs
        } else if (upperCaseValue == threeGOnly.uppercased()) {
            result = umtsOnly
        } else if (upperCaseValue == threeGPreferred.uppercased()) {
            result = umts
        } else if (upperCaseValue == fourGOnly.uppercased()) {
            result = lteOnly
        } else if (upperCaseValue == fourGPreferred.uppercased()) {
            result = lte
        } else if (upperCaseValue == automatic.uppercased()) {
            result = auto
        }
        return result
    }
}
