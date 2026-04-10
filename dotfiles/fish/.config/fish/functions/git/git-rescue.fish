function git-rescue
    git fsck --lost-found > /dev/null
    set lost_dir ".git/lost-found/other"
    if not test -d "$lost_dir"
        echo "❌ Không tìm thấy file nào khả nghi."
        return
    end
    if test (count $argv) -gt 0
        find $lost_dir -type f -exec grep -l "$argv[1]" {} + | while read file
            echo "------------------------------------------"
            echo "✅ FOUND: "(basename $file)
            head -n 5 $file
        end
    else
        for file in (/bin/ls -t $lost_dir | head -n 10)
            echo "------------------------------------------"
            echo "HASH: $file"
            head -n 3 "$lost_dir/$file"
        end
    end
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "💡 HƯỚNG DẪN KHÔI PHỤC:"
    echo " 1. Tìm chính xác hơn:  git-rescue \"từ_khóa_cần_tìm\""
    echo " 2. Lấy lại file:       cat .git/lost-found/other/<HASH> > tên_file.txt"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
end
