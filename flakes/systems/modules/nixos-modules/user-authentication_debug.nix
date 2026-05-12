{ ... }: {
	flake.nixosModules.user-authentication_debug = { config, ... }: let

		password-hash = "$y$j9T$CDDZhg4BoZ5xjPiWqXZzW/$XR/Sj90HtTeoEK/.AiCwv3OpMEmRdf/n6qsDBNWa2h6";
	in {
		
		/*users.users = builtins.foldl' 
			(acc: name: acc // { ${name}.hashedPassword = password-hash; }) 
			{} 
			(builtins.attrNames config.users.users ++ [ "root" ]);*/
		users.users.roguebit.hashedPassword = password-hash;
		users.users.root.hashedPassword = password-hash;
	};
}
