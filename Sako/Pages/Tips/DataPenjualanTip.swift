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
        Text("Segera catat penjualan Anda! Lihat data penjualan yang sudah tercatat, dan tambahkan transaksi baru.")
    }
    
}
