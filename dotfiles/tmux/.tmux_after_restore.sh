#!/bin/bash

# Start backend server in the 'backend' window
tmux send-keys -t BE.1 "php artisan serve --port=8002" C-m

# Start frontend server in the 'frontend' window
# tmux send-keys -t FE "npm run dev" C-m

