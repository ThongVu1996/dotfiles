function tsk --description 'Kill a specific tmux session'
    # Check if the user provided a session name
    if test (count $argv) -eq 0
        echo "Error: Please provide a tmux session name to kill."
        echo "Usage: tsk <session_name>"
        return 1
    end

    set -l session_name $argv[1]

    # Execute tmux kill-session
    tmux kill-session -t "$session_name"

    # Check exit code ($status)
    if test $status -eq 0
        echo "Successfully killed tmux session: $session_name"
    else
        echo "Failed to kill tmux session: $session_name (it might not exist)"
    end
end
