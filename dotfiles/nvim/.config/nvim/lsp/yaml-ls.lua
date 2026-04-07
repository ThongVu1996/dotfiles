return {
	settings = {
		yaml = {
			hover = true,
			completion = true,
			validate = true,
			format = {
				enable = true,
			},
			schemaStore = {
				-- Tự động kéo các schema phổ biến từ Internet (k8s, gitlab, github actions...)
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			schemas = {
				kubernetes = {
					"deployment.y*ml",
					"kustomization.y*ml",
					"service.y*ml",
					"pod.y*ml",
					"ingress.y*ml",
				},
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.y*ml",
				["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.y*ml",
				["https://json.schemastore.org/github-action.json"] = ".github/action.y*ml",
			},
		},
	},
}
