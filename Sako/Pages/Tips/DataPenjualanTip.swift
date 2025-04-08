//
//  DataPenjualanTip.swift
//  Sako
//
//  Created by Callista on 08/04/25.
//

import Foundation
import TipKit
import SwiftUI

struct DataPenjualanTip: Tip {
    var title: Text {
        Text("Kelola Penjualan")
    }
    
    var message: Text? {
        Text("Data penjualan yang tersedia di aplikasi ini adalah produk yang telah dibuat oleh pemilik aplikasi.")
    }
    
}
