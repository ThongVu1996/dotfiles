if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Setting config default for MacOS
set -gx XDG_CONFIG_HOME "$HOME/.config"

# 1. Load môi trường của Nix-Darwin (System Packages)
if test -e /run/current-system/sw/bin
    fish_add_path /run/current-system/sw/bin
end

# 2. Load môi trường của Home Manager (Home Packages)
if test -e /etc/profiles/per-user/$USER/bin
    fish_add_path /etc/profiles/per-user/$USER/bin
else if test -e ~/.nix-profile/bin
    fish_add_path ~/.nix-profile/bin
end

# 3. Load Nix Daemon (để đảm bảo các biến môi trường khác)
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

#Config paste image to markdown in nvim
set -g allow_passthrough on
set -ga update_environment TERM
set -ga update_environment TERM_PROGRAM
# Config starship
set -U fish_greeting ""
starship init fish | source
set -Ux STARSHIP_CONFIG ~/.config/starship.toml

# bat 
# alias bat='batcat'

# open nvim
alias vi='nvim'
alias ls='eza'
function ls --wraps eza
    # Kiểm tra: Nếu chỉ có đúng 1 tham số VÀ tham số đó là Số (ví dụ: 1, 2, 3...)
    if test (count $argv) -eq 1; and string match -qr '^[0-9]+$' -- "$argv[1]"
        eza --tree --level=$argv[1]
    else
        # Các trường hợp còn lại (ls, ls -la, ls /tmp...) chạy eza bình thường
        eza $argv
    end
end
alias lz='lazygit'
# System Rebuild Alias
alias nixss="sudo nix run nix-darwin -- switch --flake ~/nix-config#(scutil --get LocalHostName)"

# fzf
fzf --fish | source
alias f=fzf
# preview with bat
alias fp='fzf --preview="bat --color=always {}"'
# open neovim with select file by tab
alias fv='nvim $(fzf -m --preview="bat --color=always {}")'
# Reload Fish Shell configuration
function ss
    source ~/nix-config/dotfiles/fish/.config/fish/config.fish
    echo "Reloaded Fish Shell!"
end

set -x PATH ~/.local/bin $PATH
set -U fish_user_paths /home/linuxbrew/.linuxbrew/bin $fish_user_paths
set -U fish_user_paths $HOME/.local/share/nvim/mason/bin $fish_user_paths

# fastafetch
export PATH="/usr/local/bin:$PATH"

# Alias to dotfiles with echo messages
alias fcf="cd ~/nix-config/dotfiles/fish/.config/fish && echo 'You can configure Fish'"
alias vcf="cd ~/nix-config/dotfiles/nvim/.config/nvim && echo 'You can configure Neovim'"
alias tcf="cd ~/nix-config/dotfiles/tmux && echo 'You can configure Tmux'"
alias scf="cd ~/nix-config/dotfiles/starship/ && echo 'You can configure Starship'"
alias wcf="cd ~/nix-config/dotfiles/wezterm/.config/wezterm"
alias acf="cd ~/nix-config/dotfiles/aerospace/.config/aerospace"
alias lzcf="cd ~/nix-config/dotfiles/lazygit/.config/lazygit"
alias ncf="cd ~/nix-config"
alias pcf="cd ~/Project/"

# Function to toggle delta side-by-side mode
function toggle_side_by_side
    # Get the current value from Git config
    set current_value (git config --global delta.side-by-side)

    # Toggle the value
    if test "$current_value" = "true"
        git config --global delta.side-by-side false
        echo "❌ Side-by-side mode disabled"
    else
        git config --global delta.side-by-side true
        echo "✅ Side-by-side mode enabled"
    end
    echo -e "\n$message"
    commandline -f repaint
end

# Bind Ctrl + G to toggle
bind \cg toggle_side_by_side
direnv hook fish | source

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -U fish_user_paths /usr/sbin $fish_user_paths

# TMUX shortcut

#Reload tmux
function tmux-ss
    tmux source-file ~/nix-config/dotfiles/tmux/.tmux.conf
    echo "Reloaded Tmux"
end

# Create new session with name
function ts
    # Kiểm tra xem người dùng có cung cấp tên session hay không
    if test (count $argv) -eq 0
        echo "Lỗi: Bạn cần cung cấp tên cho session mới."
        echo "Cú pháp: ts <ten_session>"
        return 1 # Trả về lỗi
    end

    # Thực thi lệnh Tmux new-session với tham số đầu tiên ($argv[1]) là tên session
    tmux new-session -s $argv[1]
end

# Rename for current session
function trs
    # Kiểm tra xem người dùng có cung cấp tên session hay không
    if test (count $argv) -eq 0
        echo "Lỗi: Bạn cần cung cấp tên mới cho session hiện tại"
        echo "Cú pháp: trs <ten_session_moi>"
        return 1 # Trả về lỗi
    end

    # Thực thi lệnh Tmux new-session với tham số đầu tiên ($argv[1]) là tên session
    tmux rename-session $argv[1]
end

# Create new windown
function tw --description 'Tạo một Tmux Window mới với tên chỉ định.'
    # 1. KIỂM TRA THAM SỐ: Đảm bảo người dùng nhập tên Window
    if test (count $argv) -eq 0
        echo (set_color red) "Lỗi:" (set_color normal) "Bạn cần cung cấp tên cho Window mới."
        echo "Cú pháp: tw <ten_window>"
        return 1
    end

    set window_name $argv[1]

    # 2. KIỂM TRA MÔI TRƯỜNG: Xác định trạng thái của Tmux

    # Kiểm tra biến môi trường $TMUX: Nếu đang ở TRONG session
    if set -q TMUX
        echo (set_color green) "Đang trong Session:" (set_color normal) "Tạo Window '$window_name' trong Session hiện tại."
        tmux new-window -n $window_name

    # Kiểm tra nếu KHÔNG ở trong Session, nhưng có Tmux Server đang chạy ngầm
    else if tmux has-session >/dev/null 2>&1
        echo (set_color yellow) "Cảnh báo:" (set_color normal) "Tmux Server đang chạy ngầm, nhưng bạn chưa đính kèm."
        echo "Tạo Window '$window_name' trong Session MẶC ĐỊNH (hoặc Session gần nhất) và đính kèm vào đó."
        # Lệnh này tạo window và chuyển đến nó, hoặc bạn có thể dùng 'tmux new-window -d' để tạo ngầm.
        tmux attach -c (tmux new-window -d -n $window_name -P -F "#{session_name}")

    # Không có Session nào đang chạy
    else
        echo (set_color red) "Lỗi:" (set_color normal) "Không có Tmux Session nào đang hoạt động."
        echo "Vui lòng tạo Session mới trước bằng lệnh 'ts <ten_session>'."
        return 1
    end
end

# Rename window
function trw --description 'Đổi tên Window hiện tại của Tmux.'
    # 1. KIỂM TRA THAM SỐ: Đảm bảo người dùng nhập tên mới
    if test (count $argv) -eq 0
        echo (set_color red) "Lỗi:" (set_color normal) "Bạn cần cung cấp tên mới cho Window."
        echo "Cú pháp: trw <ten_moi>"
        return 1
    end

    set new_window_name $argv[1]

    # 2. KIỂM TRA MÔI TRƯỜNG: Xác định trạng thái của Tmux

    # Kiểm tra biến môi trường $TMUX: PHẢI đang ở TRONG session mới rename được
    if set -q TMUX
        echo (set_color green) "Đang trong Session:" (set_color normal) "Đổi tên Window hiện tại thành '$new_window_name'."
        tmux rename-window $new_window_name
    else
        # Nếu KHÔNG ở trong Session, lệnh rename-window sẽ không hoạt động
        echo (set_color red) "Lỗi:" (set_color normal) "Lệnh đổi tên Window (trw) chỉ có thể chạy từ BÊN TRONG Tmux Session."
        echo "Vui lòng đính kèm vào Session trước (tmux attach) hoặc đổi tên thủ công (tmux rename-window) nếu bạn biết id."
        return 1
    end
end

# Attach session with name
function ta --description 'Đính kèm (Attach) vào một Tmux Session đã có.'
    # 1. KIỂM TRA THAM SỐ: Đảm bảo có tên Session được cung cấp
    if test (count $argv) -eq 0
        echo (set_color yellow) "Cảnh báo:" (set_color normal) "Không có tên Session được cung cấp."
        echo "Thử đính kèm vào Session cuối cùng hoặc duy nhất (tmux attach)."
        tmux attach
        return 0
    end

    set session_name $argv[1]

    # 2. KIỂM TRA SESSION CÓ TỒN TẠI KHÔNG (Sử dụng lệnh has-session)
    if tmux has-session -t $session_name 2>/dev/null
        # Session tồn tại, tiến hành đính kèm
        echo (set_color green) "Đang đính kèm vào Session:" (set_color normal) "$session_name"
        tmux attach -t $session_name
    else
        # Session không tồn tại
        echo (set_color red) "Lỗi:" (set_color normal) "Không tìm thấy Tmux Session có tên '$session_name'."
        echo "Kiểm tra danh sách các Session đang chạy bằng lệnh: tmux ls"
        return 1
    end
end
