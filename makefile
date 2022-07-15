system_switch:
	sudo nixos-rebuild --upgrade switch

system_clean:
	nix-env --delete-generations 14d

home_switch:
	home-manager switch && source ~/.bash_profile

home_cleanup:
	home-manager expire-generations "-14 days"

firmeware-upgrade:
	fwupdmgr refresh && fwupdmgr upgrade
