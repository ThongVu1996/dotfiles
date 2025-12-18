# functions/git.nu

export alias lz = lazygit

# Toggle delta side-by-side
export def toggle_side_by_side [] {
    # Lấy giá trị hiện tại (lưu ý trả về string nên cần xử lý kỹ)
    let current = (do { git config --global delta.side-by-side } | complete | get stdout | str trim)
    
    if $current == "true" {
        git config --global delta.side-by-side false
        print "❌ Side-by-side mode disabled"
    } else {
        git config --global delta.side-by-side true
        print "✅ Side-by-side mode enabled"
    }
    
    # Fish: commandline -f repaint 
    # Nu: Không cần làm gì cả, prompt tự refresh sau khi hàm này chạy xong.
}
