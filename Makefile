HELM=helm
HELM_REPO_ROOT=https://v3io.github.io/helm-charts/
WORKDIR=stable

cd-stable:
WORKDIR := stable

stable: stable-repo-helm cd-stable update-req package-all index
	@echo "Done"

update-req:
	@echo "Updating chart requirements"
	@cd $(WORKDIR) && for chart in $$(ls); do \
		if [ -e "$$chart/requirements.yaml" ]; then \
			echo "Updating '$$chart' requirements" ; \
			$(HELM) dependency build $$chart ; \
		fi ; \
	done

package-all:
	@echo "Packing charts"
	@cd $(WORKDIR) && for chart in $$(ls -d */); do \
		$(HELM) lint $$chart ; \
		if [ "$$?" != "0" ]; then \
			echo "Chart $$chart failed lint" ; \
		fi ; \
		$(HELM) package $$chart ; \
	done

index:
	@echo "Generating index.yaml"
	$(HELM) repo index --merge $(WORKDIR)/index.yaml --url $(HELM_REPO) $(WORKDIR)

stable-repo-helm: check-helm
HELM_REPO := $(HELM_REPO_ROOT)/stable
$(debug $(shell $(HELM) repo add v3io-stable $(HELM_REPO)))

check-helm:
	@echo "Checking if helm command exists"
	@$(HELM) --help &> /dev/null
	@if [ "$$?" != "0" ]; then \
		echo "Missing helm command" ; \
		exit 2 ; \
	fi
