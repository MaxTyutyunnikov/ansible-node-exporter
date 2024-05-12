build:
	go build -o ipsec_exporter ./cmd/ipsec_exporter

bootstrap_common:: ## bootstrap files
	@echo "=== bootstrap (main) ==========================================="
	git remote add cloudalchemy https://github.com/cloudalchemy/ansible-node-exporter.git || :
	git remote add binbashar https://github.com/binbashar/ansible-node-exporter.git || :
	git remote add superbet-group https://github.com/superbet-group/sre.ansible-role-on-prem-node-exporter || :
	git remote add RatioformIT https://github.com/RatioformIT/ansible-node-exporter.git || :
	git remote add artefactual-labs https://github.com/artefactual-labs/ansible-node-exporter.git || :
	git remote add sdarwin https://github.com/sdarwin/ansible-node-exporter.git || :
	git pull --all
	@export PRE=pre

worktree:
	git worktree add ../ansible-node-exporter.cloudalchemy; cd ../ansible-node-exporter.cloudalchemy; git checkout cloudalchemy/master || :
	git worktree add ../ansible-node-exporter.binbashar; cd ../ansible-node-exporter.binbashar; git checkout binbashar/master || :
	git worktree add ../ansible-node-exporter.superbet-group; cd ../ansible-node-exporter.superbet-group; git checkout superbet-group/master || :
	git worktree add ../ansible-node-exporter.RatioformIT; cd ../ansible-node-exporter.RatioformIT; git checkout RatioformIT/master || :
	git worktree add ../ansible-node-exporter.artefactual-labs; cd ../ansible-node-exporter.artefactual-labs; git checkout artefactual-labs/master || :
	git worktree add ../ansible-node-exporter.sdarwin; cd ../ansible-node-exporter.sdarwin; git checkout sdarwin/master || :
