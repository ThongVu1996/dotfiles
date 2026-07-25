local blink = require("blink.cmp")

return {
    cmd = { "phpactor", "language-server" },
    filetypes = { "php" },
    root_markers = { "composer.json", ".git" },
    
    -- This is the "Hybrid" magic
    on_attach = function(client, bufnr)
        -- Disable features that Intelephense already does better
        client.server_capabilities.completionProvider = false
        client.server_capabilities.diagnosticProvider = false
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.hoverProvider = false
    end,

    capabilities = blink.get_lsp_capabilities(),
}