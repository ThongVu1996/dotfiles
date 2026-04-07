local blink = require("blink.cmp")

return {
	-- 1. Lệnh chạy server
	cmd = { "yaml-language-server", "--stdio" },

	-- 2. Hỗ trợ YAML (K8s, Docker Compose, CI/CD)
	filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },

	-- 3. Cấu hình chuyên sâu dựa trên tài liệu chính thức
	settings = {
		yaml = {
			-- Tính năng Validation & Intelligence (CẦN BẬT)
			validate = true,
			hover = true,
			completion = true,

			-- Định dạng (TẮT ĐỂ DÙNG PRETTIER CHO ĐẸP HƠN)
			format = {
				enable = false,
			},

			-- Tự động nạp Schema từ SchemaStore (CỰC QUAN TRỌNG)
			schemaStore = {
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},

			-- Hỗ trợ Kubernetes Custom Resource Definitions (CRDs)
			-- Một tính năng cao cấp bạn vừa tìm thấy
			kubernetesCRDStore = {
				enable = true,
				url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main",
			},

			-- Khai báo schema tường minh cho các file phổ biến
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

			-- Tuỳ chỉnh Indent (Theo chuẩn 2 spaces)
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
