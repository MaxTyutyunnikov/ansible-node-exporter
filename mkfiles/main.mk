build:
	go build -o ipsec_exporter ./cmd/ipsec_exporter

worktree:
	git worktree add ../ansible-node-exporter.cloudalchemy; cd ../ansible-node-exporter.cloudalchemy; git checkout cloudalchemy/master || :
	git worktree add ../ansible-node-exporter.binbashar; cd ../ansible-node-exporter.binbashar; git checkout binbashar/master || :
	git worktree add ../ansible-node-exporter.superbet-group; cd ../ansible-node-exporter.superbet-group; git checkout superbet-group/master || :
	git worktree add ../ansible-node-exporter.RatioformIT; cd ../ansible-node-exporter.RatioformIT; git checkout RatioformIT/master || :
	git worktree add ../ansible-node-exporter.artefactual-labs; cd ../ansible-node-exporter.artefactual-labs; git checkout artefactual-labs/master || :
	git worktree add ../ansible-node-exporter.sdarwin; cd ../ansible-node-exporter.sdarwin; git checkout sdarwin/master || :
