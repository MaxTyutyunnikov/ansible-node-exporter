bootstrap_common:: ## bootstrap files
	@echo "=== bootstrap (main) ==========================================="
	git remote add cloudalchemy https://github.com/cloudalchemy/ansible-node-exporter.git || :
	git remote add binbashar https://github.com/binbashar/ansible-node-exporter.git || :
	git remote add superbet-group https://github.com/superbet-group/sre.ansible-role-on-prem-node-exporter || :
	git remote add RatioformIT https://github.com/RatioformIT/ansible-node-exporter.git || :
	git remote add artefactual-labs https://github.com/artefactual-labs/ansible-node-exporter.git || :
	git remote add sdarwin https://github.com/sdarwin/ansible-node-exporter.git || :
	git pull --all
	@export PRE_BOOTSTRAP=pre

export PRE_BOOTSTRAP=pre
