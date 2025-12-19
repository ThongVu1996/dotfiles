export-env {
    $env.config = ($env.config | upsert hooks.pre_prompt { |old_config|
        # Lấy danh sách hook cũ, nếu chưa có thì mặc định là list rỗng []
        let current_hooks = ($old_config.hooks?.pre_prompt? | default [])

        # Nối hook của direnv vào danh sách cũ
        $current_hooks ++ [
            { ||
                # Logic của direnv
                let direnv = (direnv export json | from json)
                if ($direnv | is-empty) {
                    return
                }
                $direnv | load-env
            }
        ]
    })
}
