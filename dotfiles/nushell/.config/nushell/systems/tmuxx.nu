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

