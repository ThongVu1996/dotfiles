local blink = require("blink.cmp")

return {
	-- 1. Server execution command
	cmd = { "yaml-language-server", "--stdio" },

	-- 2. Supported filetypes (K8s, Docker Compose, CI/CD)
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },

	-- 3. Advanced configurations based on official documentation
	settings = {
		yaml = {
			-- Validation & Intelligence (MUST BE ENABLED)
			validate = true,
			hover = true,
			completion = true,

			-- Formatting (DISABLED TO USE PRETTIER FOR BETTER RESULTS)
			format = {
				enable = false,
			},

			-- Auto-load schemas from SchemaStore (CRITICAL)
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},

			-- Kubernetes Custom Resource Definitions (CRDs) support
			kubernetesCRDStore = {
				enable = true,
				url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main",
			},

			-- Explicit schema mappings for common files
			schemas = {
				kubernetes = {
					"deployment.y*ml",
					"kustomization.y*ml",
					"service.y*ml",
					"pod.y*ml",
					"ingress.y*ml",
					"cluster-role.y*ml",
					"role.y*ml",
					"configmap.y*ml",
				},
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.y*ml",
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.y*ml",
				["https://json.schemastore.org/github-action.json"] = ".github/action.y*ml",
				["https://raw.githubusercontent.com/argoproj/argo-cd/master/assets/schema/kubernetes.json"] = "argocd*.y*ml",
			},

			-- Indent customization (Standard 2 spaces)
			editor = {
				tabSize = 2,
			},
		},
	},

	-- 4. Capabilities (Blink.cmp support)
	capabilities = vim.tbl_deep_extend(
		"force",
		{},
		vim.lsp.protocol.make_client_capabilities(),
		blink.get_lsp_capabilities()
	),
}
