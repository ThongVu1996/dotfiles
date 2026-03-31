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
function nixss --description "Build and Switch đa nền tảng (Nix-Darwin / Home Manager)"
    # Lấy hệ điều hành hiện tại
    set -l os_name (uname)
    # ============================
    # 🍎 RẼ NHÁNH CHO MACOS (Darwin)
    # ============================
    if test "$os_name" = "Darwin"
        set -l host (hostname | cut -f1 -d.)
        echo "🍎 [macOS] Đang Build cho cấu hình: darwinConfigurations.$host..."
        nix build .#darwinConfigurations."$host".system
        if test $status -eq 0
            echo "✅ Cấu trúc được tạo thành công! Yêu cầu Mật khẩu quản trị..."
            sudo ./result/sw/bin/darwin-rebuild switch --flake .
            rm result
            echo "🎉 Tích hợp Mac hoàn tất."
        else
            echo "❌ Build Flake MacOS thất bại. Xin kiểm tra log."
        end
    # ============================
    # 🐧 RẼ NHÁNH CHO LINUX (Home Manager Standalone)
    # ============================
    else if test "$os_name" = "Linux"
        # Ở Linux mình gọi cứng vào block "linux" trong file flake
        set -l target "linux"
        echo "🐧 [Linux] Kích hoạt Home Manager cho cấu hình: $target..."
        # Không dùng sudo ở đây để bảo vệ cấu trúc nhóm người dùng!
        home-manager switch --flake .#$target
        if test $status -eq 0
            echo "🎉 Tích hợp Linux hoàn tất."
        else
            echo "❌ Home Manager Switch thất bại. Xin kiểm tra log."
        end
    # ============================
    # ⚠️ HỆ ĐIỀU HÀNH LẠ
    # ============================
    else
        echo "⚠️ Lỗi: Không nhận diện được nền tảng '$os_name'."
    end
end

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
function tsn --description 'Tạo hoặc Switch sang một tmux session'
    # 1. Kiểm tra argument
    if test (count $argv) -eq 0
        echo "Lỗi: Bạn cần cung cấp tên cho session."
        echo "Cú pháp: ts <ten_session>"
        return 1
    end

    set -l session_name $argv[1]

    # Kiểm tra session đã tồn tại hay chưa
    set -l session_exists (tmux has-session -t "$session_name" 2>/dev/null; echo $status)
    
    # 2. Kiểm tra xem có đang ở trong Tmux không (dùng $TMUX)
    if set -q TMUX
        # Đang ở trong Tmux: Chỉ được dùng switch-client (hoặc new-session khi cần tạo mới)
        
        if test $session_exists -eq 0
            # Session đã tồn tại, chuyển đổi session
            tmux switch-client -t "$session_name"
        else
            # Session chưa tồn tại, tạo session mới nhưng phải detach khỏi client hiện tại
            # và sau đó switch-client vào session mới.
            # (Cách an toàn hơn là dùng new-session -d sau đó switch-client)
            tmux new-session -d -s "$session_name"
            tmux switch-client -t "$session_name"
        end

    else
        # Đang ở ngoài Tmux: Dùng new-session -A để tạo hoặc attach
        # Cách này an toàn và gọn gàng khi ở ngoài
        tmux new-session -A -s "$session_name"
    end
end

# Rename for current session
function tsr
    # Kiểm tra xem người dùng có cung cấp tên session hay không
    if test (count $argv) -eq 0
        echo "Lỗi: Bạn cần cung cấp tên mới cho session hiện tại"
        echo "Cú pháp: trs <ten_session_moi>"
        return 1 # Trả về lỗi
    end

    # Thực thi lệnh Tmux new-session với tham số đầu tiên ($argv[1]) là tên session
    tmux rename-session $argv[1]
end

# kill session by name 
function tsk --description 'Kill a specific tmux session'
    # Kiểm tra xem người dùng có cung cấp tên session không (argument đầu tiên là $argv[1])
    if test (count $argv) -eq 0
        echo "Lỗi: Vui lòng cung cấp tên tmux session để kill."
        echo "Cú pháp: tks <tên_session>"
        return 1
    end

    set -l session_name $argv[1]

    # Thực thi lệnh tmux kill-session
    tmux kill-session -t "$session_name"

    # Kiểm tra mã thoát ($status)
    if test $status -eq 0
        echo "Đã kill session tmux: $session_name"
    else
        echo "Không thể kill session tmux: $session_name (có thể session không tồn tại)"
    end
end

function tsa --description 'Attach hoặc Switch sang một tmux session (Cách 2)'
    if test (count $argv) -eq 0
        echo "Lỗi: Vui lòng cung cấp tên tmux session để attach/switch."
        echo "Cú pháp: ta <tên_session>"
        return 1
    end

    set -l session_name $argv[1]

    if not tmux has-session -t "$session_name" 2>/dev/null
        echo "Lỗi: Session tmux '$session_name' không tồn tại."
        return 1
    end

    # Kiểm tra xem có đang ở trong Tmux không
    if set -q TMUX
        # Đang ở trong Tmux: Dùng switch-client.
        env -u TMUX tmux switch-client -t "$session_name"
    else
        # Đang ở ngoài Tmux: Dùng attach-session.
        tmux attach-session -t "$session_name"
    end
end

# Create new windown
function twn --description 'Tạo một Tmux Window mới với tên chỉ định.'
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
function twr --description 'Đổi tên Window hiện tại của Tmux.'
    # 1. KIỂM TRA THAM SỐ: Đảm bảo người dùng nhập tên mới
    if test (count $argv) -eq 0
        echo (set_color red) "Lỗi:" (set_color normal) "Bạn cần cung cấp tên mới cho Window."
        echo "Cú pháp: twr <ten_moi>"
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


############################
# Open and Close VM fusion #
############################  

# function vmrun 
#   if test (count $argv) -lt 2
#       echo (set_color red) "Lỗi:" (set_color normal) "Bạn cần cung cấp PATH của máy áo"
#       echo "Cú pháp : vmrun stop/start PATH (nodgui/gui với việc start)"
#       return 1
#   end 
#
#   if test (count $argv) -gt 2
#       echo (set_color red) "Lỗi:" (set_color normal) "Bạn đang nhập quá nhiều tham số"
#       echo "Cú pháp : vmrun stop/start PATH (nodgui/gui với việc start)"
#       return 1
#   end
#
#   set start "start"
#   set stop  "stop"
#   set all-in-one "all-in-one"
#   set k8s "k8s"
#   set harbor "harbor"
#
#   function service_run
#     switch "$argv[1]"     
#       case all-in-one
#         echo "Đang khời động máy ảo $argv[1]"
#         vmrun start "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm" nogui
#         return 0
#       case harbor
#         echo "Đang khời động máy ảo $argv[1]"
#         vmrun start "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx" nogui
#         return 0
#       case k8s
#         echo "Đang khời động cụm máy ảo $argv[1]"
#         vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx" nogui
#         vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx" nogui
#         vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx" nogui
#         return 0
#       case '*'
#         echo "Sai tham số đầu vào"
#         echo "Tham số đầu vào chỉ có thể là k8s, all-in-one, harbor"
#         return 1
#     end
#   end
#
#
#   function service_stop
#     switch "$argv[1]"     
#       case all-in-one
#         echo "Đang tắt máy ảo $argv[1]"
#         vmrun stop "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm"
#         return 0
#       case harbor
#         echo "Đang tắ máy ảo $argv[1]"
#         vmrun stop "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx"
#         return 0
#       case k8s
#         echo "Đang tắt cụm máy ảo $argv[1]"
#         vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx"
#         vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx"
#         vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx"
#         return 0
#       case '*'
#         echo "Sai tham số đầu vào"
#         echo "Tham số đầu vào chỉ có thể là k8s, all-in-one, harbor"
#         return 1
#     end
#   end
#
#   switch "$argv[1]"
#       case start
#           service_run $argv[2..-1]
#           return 0
#       case stop
#           service_stop $argv[2..-1]
#           return 0
#       case '*'
#           echo (set_color red) "Lỗi:" (set_color normal) "Tham số không hợp lệ"
#           echo "Cú pháp : vmrun stop/start PATH (nodgui/gui với việc start)"
#           return 1
#   end
# end 

function vmrun
    # --- PHẦN 1: KIỂM TRA THAM SỐ (CHỈ CHẤP NHẬN 2 THAM SỐ) ---
    echo "$count $argv"
    if test (count $argv) -ne 2
        echo (set_color red) "Lỗi:" (set_color normal) "Cú pháp không hợp lệ. Hàm này chỉ chấp nhận 2 tham số."
        echo "Cú pháp: vmrun <start|stop> <all-in-one|harbor|k8s>"
        return 1
    end

    set cmd $argv[1] # Lệnh: start hoặc stop
    set service_name $argv[2] # Tên dịch vụ: all-in-one, harbor, k8s

    # Bạn có thể giữ lại dòng DEBUG này cho lần kiểm tra cuối cùng
    echo "DEBUG: \$service_name được nhận là: '$service_name'" 
    if test "$service_name = "all-in-one""
    echo "Hai chuỗi bằng nhau."
else
    echo "Hai chuỗi KHÔNG bằng nhau." # Kết quả sẽ là dòng này
end

    # --- PHẦN 2: HÀM CON ĐỂ KHỞI ĐỘNG (service_run) ---
    function service_run
    # Dùng if test để so sánh chuỗi
    echo "Da vao day"
    if test "$service_name = "all-in-one""
        echo "Đang khời động máy ảo $service_name"
        vmrun start "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm" nogui
        return 0
    else if test "$service_name" = "harbor"
        echo "Đang khời động máy ảo $service_name"
        vmrun start "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx" nogui
        return 0
    else if test "$service_name" = "k8s"
        echo "Đang khời động cụm máy ảo $service_name"
        vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx" nogui
        vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx" nogui
        vmrun start "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx" nogui
        return 0
    else
        # Xử lý trường hợp không khớp với bất kỳ dịch vụ nào
        echo "Loi 12234"
        echo (set_color red) "Lỗi:" (set_color normal) "Tên dịch vụ không hợp lệ."
        echo "Tham số đầu vào chỉ có thể là k8s, all-in-one, harbor"
        return 1
    end
end
    # --- PHẦN 3: HÀM CON ĐỂ DỪNG (service_stop) ---
    function service_stop
        switch "$service_name"
            case all-in-one
                echo "Đang tắt máy ảo $service_name"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/all-in-one.vmwarevm/all-in-one.vm"
                return 0
            case harbor
                echo "Đang tắt máy ảo $service_name"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/Harbo-registry.vmwarevm/Harbo-registry.vmx"
                return 0
            case k8s
                echo "Đang tắt cụm máy ảo $service_name"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-1.vmwarevm/k8s-master-1.vmx"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-2.vmwarevm/k8s-master-2.vmx"
                vmrun stop "/Users/thongvu/Virtual Machines.localized/k8s-master-3.vmwarevm/k8s-master-3.vmx"
                return 0
            case '*'
                echo (set_color red) "Lỗi:" (set_color normal) "Tên dịch vụ không hợp lệ."
                echo "Tham số đầu vào chỉ có thể là k8s, all-in-one, harbor"
                return 1
        end
    end

    # --- PHẦN 4: LỆNH CHÍNH XỬ LÝ (cmd) ---
    switch "$cmd"
        case start
            service_run
            return $status 
        case stop
            service_stop
            return $status
        case '*'
            echo (set_color red) "Lỗi:" (set_color normal) "Lệnh không hợp lệ."
            echo "Lệnh chỉ có thể là 'start' hoặc 'stop'."
            return 1
    end
end

# Added by Antigravity
fish_add_path /Users/thongvu/.antigravity/antigravity/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
