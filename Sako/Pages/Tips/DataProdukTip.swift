//
//  Tip.swift
//  Sako
//
//  Created by Callista on 07/04/25.
//

import Foundation
import TipKit
import SwiftUI

struct DataProdukTip: Tip {
    var title: Text {
        Text("Kelola Produk")
    }
    
    var message: Text? {
        Text("Data produk yang tersedia di aplikasi ini adalah produk yang telah dibuat oleh pemilik aplikasi.")
    }
}
