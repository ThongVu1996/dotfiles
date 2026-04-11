local blink = require("blink.cmp")

local hostname = os.getenv("HOSTNAME") or "MacBook-Pro"
local username = os.getenv("USERNAME") or "thongvu"
local flake_path = os.getenv("FLAKE_PATH") or vim.fn.expand("~/nix-config")

local is_darwin = vim.fn.has("mac") == 1
local nix_options = {}

if is_darwin then
    nix_options.darwin = {
        expr = '(builtins.getFlake "' .. flake_path .. '").darwinConfigurations."' .. hostname .. '".options',
    }
else
    nix_options.nixos = {
        expr = '(builtins.getFlake "' .. flake_path .. '").nixosConfigurations."' .. hostname .. '".options',
    }
end

nix_options["home-manager"] = {
    expr = '(builtins.getFlake "' .. flake_path .. '").homeConfigurations."' .. username .. '@' .. hostname .. '".options',
}

return {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
        nixd = {
            nixpkgs = { expr = "import <nixpkgs> { }" },
            options = nix_options,
        },
    },
    capabilities = blink.get_lsp_capabilities(),
}