function tsr --description 'Rename current tmux session'
    # Check if the user provided a new session name
    if test (count $argv) -eq 0
        echo "Error: Please provide a new name for the current session"
        echo "Usage: tsr <new_session_name>"
        return 1 # Return error
    end

    # Execute tmux rename-session with the first argument ($argv[1])
    tmux rename-session $argv[1]
end
