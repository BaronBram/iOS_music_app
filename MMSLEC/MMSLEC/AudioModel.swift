//
//  AudioModel.swift
//  MMSLEC
//
//  Created by Baron Bram on 03/12/23.
//

import SwiftUI

struct Audio: Identifiable {
    var id = UUID()
  
    var title: String
    var Singer: String
    
    
    var imageName: String{
        switch title {
                    case "Storm":
                        return "storm.jpeg"
                    case "Valley":
                        return "valley.jpeg"
                    case "Pandora":
                        return "wolf.jpeg"
                    case "Hill":
                        return "hill.jpeg"
                    case "Fontaine":
                        return "fontaine.jpeg"
                    default:
                        return "rain.jpeg"
                }
    }
    
    var audioTitle: String
}

let tesData = [
    Audio(title: "Rain", Singer: "RainCorp", audioTitle: "lightrain"),
    Audio(title: "Storm", Singer: "RainCorp", audioTitle: "storm"),
    Audio(title: "Valley", Singer: "Dortnu", audioTitle: "timepass"),
    Audio(title: "Pandora", Singer: "Casiio", audioTitle: "pandora"),
    Audio(title: "Hill", Singer: "Casiio", audioTitle: "hill"),
    Audio(title: "Fontaine", Singer: "Hoyo-Mix", audioTitle: "souvenir")
  
   
]
