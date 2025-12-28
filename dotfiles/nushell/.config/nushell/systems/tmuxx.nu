########################################
# tmuxx.nu — tmux helpers + completion
########################################

########################################
# COMPLETION HELPERS
########################################

# List tmux sessions
def "nu-complete tmux-sessions" [] {
    tmux list-sessions -F '#S'
    | lines
}

# List tmux windows (current session)
def "nu-complete tmux-windows" [] {
    tmux list-windows -F '#W'
    | lines
}

########################################
# CORE HELPERS
########################################

def in-tmux [] {
    ($env.TMUX? | is-not-empty)
}

def session-exists [name: string] {
    (tmux has-session -t $name | complete).exit_code == 0
}

########################################
# COMMANDS
########################################

# Reload tmux config
export def ss [] {
    tmux source-file ~/nix-config/dotfiles/tmux/.tmux.conf
    print "🔁 Reloaded tmux config"
}

########################################
# tsn — create or switch session
########################################
export def tsn [
    session: string@"nu-complete tmux-sessions"
] {
    let inside = (in-tmux)
    let exists = (session-exists $session)

    if $inside {
        if $exists {
            tmux switch-client -t $session
        } else {
            tmux new-session -d -s $session
            tmux switch-client -t $session
        }
    } else {
        tmux new-session -A -s $session
    }
}

########################################
# tsr — rename session
########################################
export def tsr [
    new_name: string
] {
    tmux rename-session $new_name
}

########################################
# tsk — kill session
########################################
export def tsk [
    session: string@"nu-complete tmux-sessions"
] {
    let r = (tmux kill-session -t $session | complete)

    if $r.exit_code == 0 {
        print $"🗑️ Killed session: ($session)"
    } else {
        print $"❌ Failed to kill session: ($session)"
    }
}

########################################
# tsa — attach or switch session
########################################
export def tsa [
    session: string@"nu-complete tmux-sessions"
] {
    if not (session-exists $session) {
        print $"❌ Session not found: ($session)"
        return
    }

    if (in-tmux) {
        tmux switch-client -t $session
    } else {
        tmux attach-session -t $session
    }
}

########################################
# tsda — delete all session and memory ressurrect
########################################

def tmux-running [] {
    (do -i { ^tmux ls } | complete | get exit_code) == 0
}

# Function dọn dẹp sạch sẽ tmux
export def tsda [] {
    let resurrect_path = $"($env.HOME)/.local/share/tmux/resurrect/"

    # --- BƯỚC 1: DỌN DẸP FILE TRƯỚC ---
    # Chúng ta phải làm việc này trước vì nếu ở trong tmux, lệnh kill-server sẽ ngắt script ngay lập tức
    if ($resurrect_path | path exists) {
        let files = (do -i { glob $"($resurrect_path)*" })
        if ($files | is-not-empty) {
            print "🗑️ Đang xóa bộ nhớ resurrect vật lý..."
            $files | each { |it| do -i { rm -rf $it } }
        }
    }

    # --- BƯỚC 2: XỬ LÝ ĐÓNG SERVER ---
    if (in-tmux) {
        print "⚠️ Đang ở trong tmux. Server sẽ đóng và thoát ngay bây giờ..."
        # Cho người dùng 1 chút thời gian để đọc thông báo trước khi pane bị đóng
        sleep 500ms 
        ^tmux kill-server
        # Dòng "✨ Xong" sẽ không hiện ở đây vì session đã bị kill
    } else {
        if (tmux-running) {
            print "🛑 Đang đóng tmux server từ bên ngoài..."
            ^tmux kill-server
        }
        print "✨ Xong! Tmux đã hoàn toàn sạch sẽ."
    }
}

########################################
# twn — new window
########################################
export def twn [
    name: string
] {
    if (in-tmux) {
        tmux new-window -n $name
    } else {
        print "❌ Must be inside tmux"
    }
}

########################################
# twr — rename window
########################################
export def twr [
    name: string
] {
    if not (in-tmux) {
        print "❌ Must be inside tmux"
        return
    }

    tmux rename-window $name
}

