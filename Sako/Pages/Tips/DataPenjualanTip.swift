import TipKit

struct DataPenjualanTip: Tip {
    var title: Text {
        Text("Kelola Penjualan")
    }
    
    var message: Text? {
        Text("Segera catat penjualan Anda! Lihat data penjualan yang sudah tercatat, dan tambahkan transaksi baru.")
    }
}
