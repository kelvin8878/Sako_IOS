//
//  Tip.swift
//  Sako
//
//  Created by Callista on 07/04/25.
//

import Foundation
import TipKit
import SwiftUI

struct dataProdukTip: Tip {
    var title: Text {
        Text("Data Produk")
    }
    
    var message: Text? {
        Text("Data produk yang tersedia di aplikasi ini adalah produk yang telah dibuat oleh pemilik aplikasi.")
    }
    
    var image: Image? {
        Image(systemName: "shippingbox.fill")
    }
    
    var id: String {
            "DataProdukTip"  // Unique ID for the tip
        }
}
