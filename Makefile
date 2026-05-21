# anskills — install targets
#
# Usage:
#   make install              # add marketplace + install business-plan-research
#   make install-all          # add marketplace + install every listed plugin
#   make install PLUGIN=name  # install a specific plugin
#   make uninstall            # uninstall business-plan-research and remove marketplace
#   make list                 # list installed plugins

MARKETPLACE := anskills
PLUGIN      ?= business-plan-research

.PHONY: install install-all uninstall list marketplace-add marketplace-remove

install: marketplace-add
	claude plugin install $(PLUGIN)@$(MARKETPLACE)
	@echo "Done. Open a new Claude Code session to use the skill."

install-all:
	./scripts/install-all.sh

marketplace-add:
	@claude plugin marketplace add "$(CURDIR)" || echo "(marketplace already added)"

marketplace-remove:
	-claude plugin marketplace remove $(MARKETPLACE)

uninstall:
	-claude plugin uninstall $(PLUGIN)@$(MARKETPLACE)
	$(MAKE) marketplace-remove

list:
	claude plugin list
