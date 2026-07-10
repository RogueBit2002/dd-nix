{ self, inputs, ... }: {
	flake.nixosModules.sops = { config, ... }: {
		imports = [
			inputs.sops-nix.nixosModules.sops
		];

		sops.defaultSopsFile = self + /secrets/common.yaml;

		# sops-nix doesn't *really* support native SSH keys, but this workaround seems to work.
		# using sops with SSH keys works fine though, only NixOS needs this weirdness.

		# /persist is used because the key needs to exists before users are created

		sops.age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ]; # Needed to trick sops because it needs at least 1 key	
		sops.environment.SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/persist/etc/ssh/ssh_host_ed25519_key";
	};
}
