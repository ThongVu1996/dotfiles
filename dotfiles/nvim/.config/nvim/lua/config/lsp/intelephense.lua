local blink = require("blink.cmp")

return {
    cmd = { "intelephense", "--stdio" },
    filetypes = { "php", "blade" },
    root_markers = { "composer.json", ".git" },
    
    -- Primary Settings
    settings = {
        intelephense = {
            stubs = {
                "apache", "bcmath", "bz2", "calendar", "Core", "curl", "date", 
                "dom", "filter", "gd", "gettext", "hash", "iconv", "imap", 
                "intl", "json", "libxml", "mbstring", "mcrypt", "mysqli", 
                "password", "pcntl", "pcre", "PDO", "pdo_mysql", "Phar", 
                "readline", "recode", "Reflection", "regex", "session", 
                "SimpleXML", "soap", "sockets", "sodium", "SPL", "standard", 
                "superglobals", "sysvmsg", "sysvsem", "sysvshm", "tokenizer", 
                "xml", "xdebug", "xmlreader", "xmlwriter", "yaml", "zip", "zlib",
            },
            files = {
                maxSize = 5000000,
                exclude = {
                    "**/.git/**",
                    "**/.DS_Store/**",
                    "**/node_modules/**",
                    "**/vendor/**/{Test,test,Tests,tests}/**",
                    "**/.direnv/**",
                },
            },
            completion = {
                fullyQualifiedImport = true, -- Auto-adds 'use' statements
            },
        },
    },
    capabilities = blink.get_lsp_capabilities(),
}