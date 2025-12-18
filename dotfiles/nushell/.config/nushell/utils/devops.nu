export def check-ports [] {
    # Thay đổi: Thêm cờ -sTCP:LISTEN để lsof tự lọc các cổng đang mở
    # Giúp loại bỏ các kết nối rác, detect columns sẽ chuẩn hơn
    let data = (^lsof -iTCP -sTCP:LISTEN -P -n | complete)

    if ($data.stdout | is-empty) {
        print "Không tìm thấy port nào đang mở (hoặc cần quyền sudo)."
    } else {
        $data.stdout
        | detect columns
        | select COMMAND PID USER NAME
        | rename process pid user address
        | upsert port {|row|
            # Logic lấy port: Cắt chuỗi sau dấu hai chấm cuối cùng
            $row.address | split row ':' | last | into int
        }
        | sort-by port
    }
}
