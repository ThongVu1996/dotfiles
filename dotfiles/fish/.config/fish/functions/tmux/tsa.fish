function tsa --description 'Attach or Switch to a tmux session'
    # Check if the user provided a session name
    if test (count $argv) -eq 0
        echo "Error: Please provide a tmux session name to attach/switch."
        echo "Usage: tsa <session_name>"
        return 1
    end

    set -l session_name $argv[1]

    # Verify session existence
    if not tmux has-session -t "$session_name" 2>/dev/null
        echo "Error: Tmux session '$session_name' does not exist."
        return 1
    end

    # Check if already inside a Tmux session
    if set -q TMUX
        # Inside Tmux: Use switch-client
        env -u TMUX tmux switch-client -t "$session_name"
    else
        # Outside Tmux: Use attach-session
        tmux attach-session -t "$session_name"
    end
end
