def tsn [
    ...args
]: nothing -> nothing {
    if ($args | length) == 0 {
        print "Lỗi: Bạn cần cung cấp tên cho session."
        print "Cú pháp: tsn <ten_session>"
        return 1
    }

    let $session_name = $args.0
    let $session_exists_code = (tmux has-session -t $session_name --exit-code)
    let $session_exists = ($session_exists_code == 0)
    let $in_tmux = (do { $env.TMUX } catch { false })

    if $in_tmux {
        if $session_exists {
            print $"Đang chuyển sang session: ($session_name)"
            tmux switch-client -t $session_name
        } else {
            print $"Tạo và chuyển sang session mới: ($session_name)"
            tmux new-session -d -s $session_name
            tmux switch-client -t $session_name
        }
    } else {
        print $"Đang khởi động/gắn vào session: ($session_name)"
        tmux new-session -A -s $session_name
    }

    return 0
}
