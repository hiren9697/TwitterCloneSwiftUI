//
//  Double+Extension.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 07/05/23.
//

import Foundation

extension Double {
    
    var smallFormat: String {
        let number = self
        let billion = number / 1_000_000_000
        let million = number / 1_000_000
        let thousand = number / 1000
        if billion >= 1.0 {
            let billionMultipliedBy10 = billion * 10
            let roundedBillion = billionMultipliedBy10.rounded()
            let finalBillion = roundedBillion / 10
            return "\(finalBillion) B"
        } else if million >= 1.0 {
            let millionMultipliedBy10 = million * 10
            let roundedMillion = millionMultipliedBy10.rounded()
            let finalMillion = roundedMillion / 10
            return "\(finalMillion) M"
        } else if thousand >= 1.0 {
            let thousandMultipliedBy10 = thousand * 10
            let roundedThousand = thousandMultipliedBy10.rounded()
            let finalThousand = roundedThousand / 10
            return "\(finalThousand) K"
        } else {
            return "\(Int(number))"
        }
    }
}

