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
        Text("Tambahkan produk Anda dulu untuk memulai serta akses informasi produk dan ubah detail produk yang sudah ditambah.")
    }
}
