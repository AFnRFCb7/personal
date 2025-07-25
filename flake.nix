{
    inputs =
        {
        } ;
    outputs =
        { self } :
            {
                lib =
                    {
                        nixpkgs ,
			secret ,
                        secrets ,
                        system ,
                        visitor
                    } :
                        let
                            module =
                                { config , lib , pkgs , ... } :
                                    let
					_secrets =
						let
							mapper =
							       path : name : value :
							       	    if value == "regular" then
                                    let
										derivation =
											pkgs.stdenv.mkDerivation
												{
													installPhase =	
														''
															age --decrypt --identity ${ config.personal.agenix } --output $out ${ builtins.concatStringsSep "/" ( builtins.concatLists [ path [ name ] ] ) }
														'' ;
													name = "derivation" ;
													nativeBuildInputs = [ pkgs.age pkgs.coreutils pkgs.makeWrapper ] ;
													src = ./. ;
												} ;
										in "${ derivation }"
								   else if value == "directory" then builtins.mapAttrs ( mapper ( builtins.concatLists [ path [ name ] ] ) ) ( builtins.readDir ( builtins.concatStringsSep "/" ( builtins.concatLists [ path [ name ] ] ) ) ) 
								   else builtins.throw "We can not handle ${ value }." ;
							in builtins.mapAttrs ( mapper [ ( builtins.toString secrets ) ] ) ( builtins.readDir ( builtins.toString secrets ) ) ;
					resources =
						let
							tree =
								{
									dot-gnupg =
										path :
											{
												init-inputs = [ pkgs.coreutils pkgs.gnupg ] ;
												init-text =
													''
														export GNUPGHOME="$SELF/dot-gnupg"
														mkdir "$GNUPGHOME"
														chmod 0700 "$GNUPGHOME"
														gpg --homedir "$GNUPGHOME" --batch --yes --import ${ _secrets."secret-keys.asc.age" }
														gpg --homedir "$GNUPGHOME" --batch --yes --import-ownertrust ${ _secrets."ownertrust.asc.age" }
														gpg --homedir "$GNUPGHOME" --batch --yes --update-trustdb
													'' ;
											} ;
									dot-ssh =
										path :
											{
												init-inputs = [ pkgs.coreutils ] ;		
												init-text =
													''
														cat ${ _secrets.dot-ssh.boot."identity.asc.age" } > "$SELF/identity"
														cat ${ _secrets.dot-ssh.boot."known-hosts.asc.age" } > "$SELF/known-hosts"
cat > "$SELF/config" <<EOF
Host github.com
	HostName github.com
	IdentityFile $SELF/identity
	UserKnownHostsFile $SELF/known-hosts
	StrictHostKeyChecking yes
	BatchMode yes
Host mobile
	HostName 192.168.1.202
	IdentityFile $SELF/identity
	UserKnownHostsFile $SELF/known-hosts
	Port 8022
	StrictHostKeyChecking yes
	BatchMode yes
EOF
														chmod 0400 "$SELF/config" "$SELF/identity" "$SELF/known-hosts"
													'' ;
											} ;
									dot-pass =
										ignore :
											{
												init-inputs = [ pkgs.coreutils pkgs.git ] ;
												init-text =
													''
														export PASSWORD_STORE_DIR="$SELF/dot-pass"
														mkdir --parents "$PASSWORD_STORE_DIR"
														cd "$PASSWORD_STORE_DIR"
														git init
														git config user.email ${ config.personal.email }
														git config user.name "${ config.personal.description }"
														git remote add origin ${ config.personal.pass.remote }
														DOT_SSH=$( ${ resources.dot-ssh } )/config || echo "FAILED TO ASSIGN"
														export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH"
														echo "GIT_SSH_COMMAND=$GIT_SSH_COMMAND"
														git fetch origin ${ config.personal.pass.branch }
														git checkout ${ config.personal.pass.branch }
													'' ;
											} ;
                                    milestone =
                                        {
                                            build =
                                                ignore :
                                                    {
                                                        init-inputs = [ pkgs.nixos-rebuild ] ;
                                                        init-text =
                                                            ''
                                                                time timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build --flake "$( ${ resources.milestone.source } "$*" )/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace
                                                            '' ;
                                                    } ;
                                            build-vm =
                                                ignore :
                                                    {
                                                        init-inputs = [ pkgs.coreutils pkgs.nixos-rebuild ] ;
                                                        init-text =
                                                            ''
                                                                cd "$SELF"
                                                                time timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build-vm-with-bootloader --flake "$( ${ resources.milestone.source } "$*" )/work-tree#tester" --verbose --print-build-logs --log-format raw --show-trace
                                                                mkdir --parents "$SELF/test"
                                                            '' ;
                                                    } ;
                                            build-vm-with-bootloader =
                                                ignore :
                                                    {
                                                        init-inputs = [ pkgs.coreutils pkgs.nixos-rebuild ] ;
                                                        init-text =
                                                            ''
                                                                cd "$SELF"
                                                                time timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build-vm --flake "$( ${ resources.milestone.source } "$*" )/work-tree#tester" --verbose --print-build-logs --log-format raw --show-trace
                                                                mkdir --parents "$SELF/test"
                                                            '' ;
                                                    } ;
                                            check =
                                                ignore :
                                                    {
                                                        init-inputs = [ pkgs.nixos-rebuild ] ;
                                                        init-text =
                                                            ''
                                                                export NIX_SHOW_TRACE=1
                                                                export NIX_LOG=trace
                                                                time timeout ${ builtins.toString config.personal.milestone.timeout } nix flake check "$( ${ resources.milestone.source } "$*" )/work-tree" --verbose --print-build-logs --log-format raw --show-trace --timeout ${ builtins.toString config.personal.milestone.timeout }
                                                            '' ;
                                                    } ;
                                            source =
                                                ignore :
                                                    {
                                                        init-inputs = [ pkgs.coreutils pkgs.git pkgs.gnused ] ;
                                                        init-text =
                                                            ''
                                                                SOURCE_BRANCH="$1"
                                                                SOURCE_COMMIT="$2"
                                                                shift 2 &&
                                                                SUBSTITUTION=( "$@" )
                                                                export GIT_DIR="$SELF/git"
                                                                export GIT_WORK_TREE="$SELF/work-tree"
                                                                mkdir --parents "$GIT_DIR"
                                                                mkdir --parents "$GIT_WORK_TREE"
                                                                git init
                                                                DOT_SSH="$( "${ resources.dot-ssh }" )/config"
                                                                git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $DOT_SSH"
                                                                git config user.email ${ config.personal.email }
                                                                git config user.name "${ config.personal.description }"
                                                                git remote add origin ${ config.personal.repository.private.remote }
                                                                git fetch --depth 1 origin "$SOURCE_BRANCH"
                                                                git checkout "$SOURCE_COMMIT"
                                                                sed -i "${ builtins.concatStringsSep "" [ "$" "{" "SUBSTITUTION[@]" "}" ] }" "$GIT_WORK_TREE/flake.nix"
                                                            '' ;
                                                    } ;
                                        } ;
									repository =
										let
											repository =
												origin : flake-input : ignore :
													{
														init-inputs = [ pkgs.coreutils pkgs.git ] ;
														init-text =
														    let
														        ssh =
														            pkgs.stdenv.mkDerivation
														                {
														                    installPhase =
														                        ''
														                            mkdir --parents $out/bin
                                                                                    makeWrapper \
                                                                                        ${ pkgs.openssh }/bin/ssh \
                                                                                        $out/bin/ssh \
                                                                                        --add-flags "-F \$( ${ resources.dot-ssh } )/config"
														                        '' ;
                                                                            name = "ssh" ;
                                                                            nativeBuildInputs = [ pkgs.coreutils pkgs.makeWrapper ] ;
                                                                            src = ./. ;
														                } ;
                                                                    in
                                                                        ''
                                                                            if [[ "$#" == 1 ]]
                                                                            then
                                                                                BRANCH="$1"
                                                                                COMMIT_HASH=
                                                                            elif [[ "$#" == 2 ]]
                                                                            then
                                                                                BRANCH="$1"
                                                                                COMMIT_HASH="$2"
                                                                            else
                                                                                BRANCH=
                                                                                COMMIT_HASH=
                                                                            fi
                                                                            export GIT_DIR="$SELF/git"
                                                                            export GIT_WORK_TREE="$SELF/work-tree"
                                                                            mkdir --parents "$SELF/home"
                                                                            mkdir --parents "$GIT_DIR"
                                                                            mkdir --parents "$GIT_WORK_TREE"
                                                                            git init
                                                                            git config core.sshCommand ${ ssh }/bin/ssh
                                                                            git config promote.input ${ flake-input }
                                                                            git config user.email ${ config.personal.email }
                                                                            git config user.name "${ config.personal.description }"
                                                                            ln --symbolic ${ post-commit } "$GIT_DIR/hooks"
                                                                            git remote add origin ${ origin }
                                                                            if [[ -z "$BRANCH" ]] || [[ -z "$COMMIT_HASH" ]]
                                                                            then
                                                                                git fetch origin main
                                                                                git checkout origin/main
                                                                            elif [[ -n "$BRANCH" ]] && [[ -n "$COMMIT_HASH" ]]
                                                                            then
                                                                                git fetch --depth 1 origin "$BRANCH"
                                                                                git checkout "$COMMIT_HASH"
                                                                            else
                                                                                git fetch --depth 1 origin "$BRANCH"
                                                                                git checkout "origin/$BRANCH"
                                                                            fi
                                                                            git checkout -b "scratch/$( uuidgen )"
                                                                        '' ;
                                                        # lease = 60 * 60 ;
													} ;
											in
												{
													applications = repository config.personal.repository.personal.remote "github:AFnRFCb7/applications" ;
													personal = repository config.personal.repository.personal.remote "github:AFnRFCb7/personal" ;
													private = repository config.personal.repository.private.remote "" ;
													secret = repository config.personal.repository.secret.remote "github:AFnRFCb7/secret" ;
													secrets = repository config.personal.repository.secrets.remote "github:AFnRFCb7/secrets" ;
													visitor = repository config.personal.repository.visitor.remote "github:AFnRFCb7/personal" ;
												} ;
                                    temporary-directory =
                                        ignore :
                                            {
                                                init-inputs = [ pkgs.coreutils ] ;
                                                init-text =
                                                    ''
                                                        mkdir "$SELF/directory"
                                                    '' ;
                                            } ;
								} ;
							post-commit =
								let
									post-commit =
										pkgs.writeShellApplication
											{
												name = "post-commit" ;
												runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
												text =
													''
														while ! git push origin HEAD
														do
															sleep 1m
														done
													'' ;
											} ;
										in "${ post-commit }/bin/post-commit" ;
							in visitor.lib.implementation { lambda = path : value : secret.lib.implementation ( { nixpkgs = nixpkgs ; path = path ; system = system ; } // ( value path ) ) ; } tree ;
					xxx =
						secret.lib.implementation
							{
								init-inputs = [ pkgs.coreutils ] ;
								init-text =
									''
										echo hi > /mount/target
									'' ;
								lease = 60 ;
								nixpkgs = nixpkgs ;
								system = system ;
							} ;
					secrets-scripts =
							let
								mapper =
                                        path : name : value :
								       	    if value == "regular" then
                                        let
											derivation =
												pkgs.stdenv.mkDerivation
													{
														installPhase =	
															let
																script =
																	pkgs.writeShellApplication
																		{
																			name = "script" ;
																			runtimeInputs = [ pkgs.coreutils ] ;
																			text =
																				''
																					if [ ! -e /tmp/resources/${ builtins.hashString "sha512" token } ]
																					then
																						mkdir --parents /tmp/resources
																						cat "$OUT/secret" > /tmp/resources/${ builtins.hashString "sha512" token }
																						chmod 0400 /tmp/resources/${ builtins.hashString "sha512" token }
																					fi
																					echo /tmp/resources/${ builtins.hashString "sha512" token }
																				'' ;
																		} ;
																token = builtins.concatStringsSep "/" ( builtins.concatLists [ path [ name ] ] ) ;
																in
																	''
																		mkdir $out
																		age --decrypt --identity ${ config.personal.agenix } --output $out/secret ${ token }
																		makeWrapper ${ script }/bin/script $out/script --set OUT $out
																	'' ;
														name = "derivation" ;
														nativeBuildInputs = [ pkgs.age pkgs.coreutils pkgs.makeWrapper ] ;
														src = ./. ;
													} ;
											in "${ derivation }/script"
									   else if value == "directory" then builtins.mapAttrs ( mapper ( builtins.concatLists [ path [ name ] ] ) ) ( builtins.readDir ( builtins.concatStringsSep "/" ( builtins.concatLists [ path [ name ] ] ) ) ) 
									   else builtins.throw "wtf" ;
								in builtins.mapAttrs ( mapper [ ( builtins.toString secrets ) ] ) ( builtins.readDir ( builtins.toString secrets ) ) ;
                                        in
                                            {
                                                config =
                                                    {
                                                        boot.loader =
                                                            {
                                                                efi.canTouchEfiVariables = true ;
                                                                systemd-boot.enable = true ;
                                                            } ;
                                                        hardware.pulseaudio =
                                                            {
                                                                enable = false ;
                                                                support32Bit = true ;
                                                            } ;
                                                        i18n =
                                                            {
                                                                defaultLocale = "en_US.UTF-8" ;
                                                                extraLocaleSettings =
                                                                    {
                                                                        LC_ADDRESS = "en_US.UTF-8" ;
                                                                        LC_IDENTIFICATION = "en_US.UTF-8" ;
                                                                        LC_MEASUREMENT = "en_US.UTF-8" ;
                                                                        LC_MONETARY = "en_US.UTF-8" ;
                                                                        LC_NAME = "en_US.UTF-8" ;
                                                                        LC_NUMERIC = "en_US.UTF-8" ;
                                                                        LC_PAPER = "en_US.UTF-8" ;
                                                                        LC_TELEPHONE = "en_US.UTF-8" ;
                                                                        LC_TIME = "en_US.UTF-8" ;
                                                                    } ;
                                                            } ;
                                                        networking =
								{
								    wireless =
        	                                                    	{
                	                                                	enable = true ;
	                	                                                networks = config.personal.wifi ;
        	                	                                    } ;
								} ;
                                                        nix =
                                                            {
                                                                nixPath =
                                                                    [
                                                                        "nixpkgs=https://github.com/NixOS/nixpkgs/archive/b6bbc53029a31f788ffed9ea2d459f0bb0f0fbfc.tar.gz"
                                                                        "nixos-config=/etc/nixos/configuration.nix"
                                                                        "/nix/var/nix/profiles/per-user/root/channels"
                                                                    ] ;
                                                                settings.experimental-features = [ "nix-command" "flakes" ] ;
                                                            } ;
                                                        programs =
                                                            {
                                                                bash =
                                                                    {
                                                                        enableCompletion = true ;
                                                                        interactiveShellInit = ''eval "$( ${ pkgs.direnv }/bin/direnv hook bash )"'' ;
                                                                    } ;
                                                                dconf.enable = true ;
                                                                direnv =
                                                                    {
                                                                        nix-direnv.enable = true ;
                                                                        enable = true ;
                                                                    } ;
                                                                gnupg.agent =
                                                                    {
                                                                        enable = true ;
                                                                        pinentryFlavor = "curses" ;
                                                                    } ;
                                                            } ;
                                                        security =
                                                            {
                                                                rtkit.enable = true;
                                                                sudo.extraConfig =
                                                                    ''
                                                                        %wheel ALL=(ALL) NOPASSWD: /run/current-system/sw/bin/shutdown
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.umount }/bin/umount
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.mount }/bin/mount
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nixos-rebuild }/bin/nixos-rebuild
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.unixtools.fsck }/bin/fsck
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.e2fsprogs }/bin/mkfs.ext4
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.coreutils }/bin/chown
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nixos-rebuild }/bin/nixos-rebuild
                                                                    '' ;
                                                            } ;
                                                        services =
                                                            {
                                                                blueman.enable = true ;
                                                                dbus.packages = [ pkgs.gcr ] ;
                                                                openssh =
                                                                    {
                                                                        enable = true ;
                                                                    } ;
                                                                pcscd.enable = true ;
                                                                pipewire =
                                                                    {
                                                                        alsa =
                                                                            {
                                                                                enable = true ;
                                                                                support32Bit = true ;
                                                                            } ;
                                                                        enable = true ;
                                                                        pulse.enable = true ;
                                                                    };
                                                                printing.enable = true ;
                                                                tlp =
                                                                    {
                                                                        enable = true;
                                                                        settings =
                                                                            {
                                                                                START_CHARGE_THRESH_BAT0 = 40 ;
                                                                                STOP_CHARGE_THRESH_BAT0 = 80 ;
                                                                            } ;
                                                                    } ;
                                                                xserver =
                                                                    {
                                                                        desktopManager =
                                                                            {
                                                                                xfce.enable = true;
                                                                                xterm.enable = false;
                                                                            }   ;
                                                                        displayManager =
                                                                            {
                                                                                defaultSession = "none+i3" ;
                                                                                lightdm.enable = true ;
                                                                            } ;
                                                                        enable = true ;
                                                                        layout = "us" ;
                                                                        libinput =
                                                                            {
                                                                                enable = true ;
                                                                                touchpad =
                                                                                    {
                                                                                        horizontalScrolling = true ;
                                                                                        scrollMethod = "twofinger" ;
                                                                                    } ;
                                                                            } ;
                                                                        windowManager =
                                                                            {
                                                                                fvwm2.gestures = true ;
                                                                                i3 =
                                                                                    {
                                                                                        enable = true ;
                                                                                        extraPackages =
                                                                                            [
                                                                                                pkgs.dmenu
                                                                                                pkgs.i3status
                                                                                                pkgs.i3lock
                                                                                                pkgs.i3blocks
                                                                                            ] ;
                                                                                    } ;
                                                                            } ;
                                                                        xkbVariant = "" ;
                                                                    } ;
                                                            } ;
							                                                        system.stateVersion = "23.05" ;
                                                        time.timeZone = "America/New_York" ;
                                                        users.users.user =
                                                            {
                                                                description = config.personal.description ;
                                                                extraGroups = [ "wheel" ] ;
                                                                isNormalUser = true ;
                                                                name = config.personal.name ;
                                                                packages =
									let
										studio =
											name : repository :
												pkgs.stdenv.mkDerivation
													{
														installPhase =
                                                            ''
                                                                mkdir --parents $out/bin
                                                                makeWrapper \
                                                                    ${ pkgs.jetbrains.idea-community }/bin/idea-community \
                                                                    $out/bin/${ name } \
                                                                    --add-flags '$( ${ repository } )' \
                                                                    --run 'export NAME=$( ${ repository } )' \
                                                                    --run 'export HOME=$NAME/home' \
                                                                    --run 'export GIT_DIR=$NAME/git' \
                                                                    --run 'export GIT_WORK_TREE=$NAME/work-tree'
                                                            '' ;
														name = "derivation" ;
														nativeBuildInputs = [ pkgs.makeWrapper ] ;
														src = ./. ;
													} ;
									in
									[
									    # (
									    #     pkgs.writeShellApplication
									    #         {
									    #             name = "launch" ;
									    #             runtimeInputs = [ pkgs.nixos-rebuild ] ;
									    #             text =
									    #                 ''
                                        #                     INCREMENT="$1"
                                        #                     MONTH=monthly/$( date -d "$( date +%Y-%m-1 ) +$INCREMENT month" +%Y-%m )
                                        #                     PRIVATE="$( ${ resources.repository.private } "$MONTH" )"
                                        #                     sudo time timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild test --flake "$( ${ resources.milestone.source } "$PRIVATE" )" --verbose --print-build-logs --log-format raw --show-trace
									    #                 '' ;
									    #         }
									    # )
                                        (
                                            pkgs.writeShellApplication
                                                {
                                                    name = "promote" ;
                                                    runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git ] ;
                                                    text =
                                                        ''
                                                            INCREMENT="$1"
                                                            MONTH=monthly/$( date -d "$( date +%Y-%m-1 ) +$INCREMENT month" +%Y-%m )
                                                            PRIVATE_INPUT="$( ${ resources.repository.private } )"
                                                            export GIT_DIR="$PRIVATE_INPUT/git"
                                                            export GIT_WORK_TREE="$PRIVATE_INPUT/work-tree"
                                                            git add .
                                                            git commit -am "" --allow-empty --allow-empty-message
                                                            PRIVATE_BRANCH="$( git rev-parse --abbrev-ref HEAD )"
                                                            PRIVATE_COMMIT_HASH="$( git rev-parse HEAD )"
                                                            PRIVATE_OUTPUT="$( ${ resources.repository.private } "$PRIVATE_BRANCH" "$PRIVATE_REPOSITORY" )"
                                                            INPUT_REPO_SCRIPTS=( "${ resources.repository.applications }" "${ resources.repository.personal }" "${ resources.repository.secret }" "${ resources.repository.secrets }" "${ resources.repository.visitor }" )
                                                            SUBSTITUTION=( )
                                                            cat > "$PRIVATE_OUTPUT/month.sh" <<EOF
                                                                MONTH="$MONTH"
                                                                GIT_DIR="$PRIVATE_REPO_OUTPUT/git" GIT_WORK_TREE="$PRIVATE_REPO_INPUT/work-tree" git push -u origin "$MONTH"
                                                            EOF
                                                            for INPUT_REPO_SCRIPT in "${ builtins.concatStringsSep "" [ "$" "{" "INPUT_REPO_SCRIPTS[@]" "}" ] }"
                                                            do
                                                                INPUT_REPO_INPUT="$( "$INPUT_REPO_SCRIPT" )"
                                                                export GIT_DIR="$INPUT_REPO_INPUT/git"
                                                                export GIT_WORK_TREE="$INPUT_REPO_INPUT/work-tree"
                                                                git add .
                                                                git commit -am "" --allow-empty --allow-empty-message
                                                                git push origin HEAD
                                                                INPUT_BRANCH="$( git rev-parse --abbrev-ref HEAD )"
                                                                INPUT_COMMIT_HASH="$( git rev-parse HEAD )"
                                                                OLD_HASH="$( git config --get promote.input )"
                                                                NEW_HASH="$OLD_HASH?rev=$INPUT_COMMIT_HASH"
                                                                SUBSTITUTION+=( "-e" "s#$OLD_HASH#$NEW_HASH#" )
                                                                INPUT_REPO_OUTPUT="$( "$INPUT_REPO_SCRIPT" "$INPUT_BRANCH" "$INPUT_COMMIT_HASH" )"
                                                                export GIT_DIR="$INPUT_REPO_OUTPUT/git"
                                                                export GIT_WORK_TREE="$INPUT_REPO_OUTPUT/work-tree"
                                                                git fetch origin
                                                                if ! git show-ref --quiet "refs/remotes/origin/$MONTH"
                                                                then
                                                                    git checkout -b "$MONTH" origin/main
                                                                else
                                                                    git checkout "$MONTH"
                                                                fi
                                                                git merge "$INPUT_COMMIT_HASH" --no-edit
                                                                cat >> "$PRIVATE_OUTPUT/month.sh" <<EOF
                                                            GIT_DIR="$INPUT_REPO_OUTPUT/git" GIT_WORK_TREE="$INPUT_REPO_INPUT/work-tree" git push -u origin "$MONTH"
                                                            EOF
                                                            done
                                                            chmod 0500 "$PRIVATE_OUTPUT/month.sh"
                                                            export GIT_DIR="$PRIVATE_OUTPUT/git"
                                                            export GIT_WORK_TREE="$PRIVATE_OUTPUT/work-tree"
                                                            SOURCE="$( ${ resources.milestone.source } "$PRIVATE_BRANCH" "$PRIVATE_COMMIT_HASH" "${ builtins.concatStringsSep "" [ "$" "{" "SUBSTITUTION[@]" "}" ] }" )"
                                                            cd "$SOURCE"
                                                            CHECK="$( ${ resources.milestone.check } "$PRIVATE_BRANCH" "$PRIVATE_COMMIT_HASH" "${ builtins.concatStringsSep "" [ "$" "{" "SUBSTITUTION[@]" "}" ] }" )"
                                                            cd "$CHECK"
                                                            BUILD_VM="$( ${ resources.milestone.build-vm } "$PRIVATE_BRANCH" "$PRIVATE_COMMIT_HASH" "${ builtins.concatStringsSep "" [ "$" "{" "SUBSTITUTION[@]" "}" ] }" )"
                                                            cd "$BUILD_VM"
                                                            export QEMU_OPTS="-virtfs local,path=$BUILD_VM/test,mount_tag=test_folder,security_model=none"
                                                            "$BUILD_VM/result/bin/run-nixos-vm"
                                                            [[ -f "$BUILD_VM/test" ]] || exit 64
                                                            BUILD_VM_WITH_BOOTLOADER="$( ${ resources.milestone.build-vm-with-bootloader } "$PRIVATE_BRANCH" "$PRIVATE_COMMIT_HASH" "${ builtins.concatStringsSep "" [ "$" "{" "SUBSTITUTION[@]" "}" ] }" )"
                                                            cd "$BUILD_VM_WITH_BOOTLOADER"
                                                            "$BUILD_VM_WITH_BOOTLOADER/result/bin/run-nixos-vm"
                                                            [[ -f "$BUILD_VM_WITH_BOOTLOADER/test" ]] || exit 64
                                                            BUILD="$( ${ resources.milestone.build } "$PRIVATE_BRANCH" "$PRIVATE_COMMIT_HASH" "${ builtins.concatStringsSep "" [ "$" "{" "SUBSTITUTION[@]" "}" ] }" )"
                                                            cd "$BUILD"
                                                            sudo time timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild test --flake "$( ${ resources.milestone.source } "$@" )" --verbose --print-build-logs --log-format raw --show-trace
                                                            git fetch origin
                                                            if ! git show-ref --quiet "refs/remotes/origin/$MONTH"
                                                            then
                                                                git checkout -b "$MONTH" origin/main
                                                            else
                                                                git checkout "$MONTH"
                                                            fi
                                                            git merge "$PRIVATE_COMMIT_HASH" --no-edit
                                                            "$PRIVATE_OUTPUT/month.sh"
                                                        '' ;
                                                }
                                        )
									    (
									        pkgs.writeShellApplication
									            {
									                name = "promote-to-candidate" ;
                                                    runtimeInputs = [ pkgs.findutils pkgs.git pkgs.gh pkgs.libuuid pkgs.time ] ;
                                                    text =
                                                        ''
                                                            PRIVATE_1="$( ${ resources.repository.private } )"
                                                            echo "PRIVATE_1=$PRIVATE_1"
                                                            SCRATCH="scratch/$( uuidgen )"
                                                            echo "SCRATCH=$SCRATCH"
                                                            GIT_DIR="$PRIVATE_1/git" GIT_WORK_TREE="$PRIVATE_1/work-tree" git checkout -b "$SCRATCH"
                                                            GIT_DIR="$PRIVATE_1/git" GIT_WORK_TREE="$PRIVATE_1/work-tree" git add .
                                                            GIT_DIR="$PRIVATE_1/git" GIT_WORK_TREE="$PRIVATE_1/work-tree" git commit -am "" --allow-empty --allow-empty-message
                                                            GIT_DIR="$PRIVATE_1/git" GIT_WORK_TREE="$PRIVATE_1/work-tree" git push origin HEAD
                                                            echo "COMMITED AND PUSHED TO PRIVATE_1"
                                                            PRIVATE_2=$( ${ resources.repository.private } "$SCRATCH" "$( GIT_DIR="$PRIVATE_1/git" GIT_WORK_TREE="$PRIVATE_1/work-tree" git rev-parse HEAD )" )
                                                            echo "PRIVATE_2=$PRIVATE_2"
                                                            GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git rm -r --ignore-unmatch inputs/*
                                                            PERSONAL_1="$( ${ resources.repository.personal } )"
                                                            echo "PERSONAL_1=$PERSONAL_1"
                                                            GIT_DIR="$PERSONAL_1/git" GIT_WORK_TREE="$PERSONAL_1/work-tree" git checkout -b "$SCRATCH"
                                                            GIT_DIR="$PERSONAL_1/git" GIT_WORK_TREE="$PERSONAL_1/work-tree" git add .
                                                            GIT_DIR="$PERSONAL_1/git" GIT_WORK_TREE="$PERSONAL_1/work-tree" git commit -am "" --allow-empty --allow-empty-message
                                                            GIT_DIR="$PERSONAL_1/git" GIT_WORK_TREE="$PERSONAL_1/work-tree" git push origin HEAD
                                                            echo "COMMITED AND PUSHED TO PERSONAL_1"
                                                            PERSONAL_2="$( ${ resources.repository.personal } "$SCRATCH" "$( GIT_DIR="$PERSONAL_1/git" GIT_WORK_TREE="$PERSONAL_1/work-tree" git rev-parse HEAD )" )"
                                                            echo "PERSONAL_2=$PERSONAL_2"
                                                            GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git fetch origin "$SCRATCH"
                                                            mkdir --parents "$PRIVATE_2/work-tree/inputs"
                                                            GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git rev-parse HEAD > "$PRIVATE_2/work-tree/inputs/personal"
                                                            GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git add inputs/personal
                                                            GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git commit -am "" --allow-empty-message
                                                            GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git push origin HEAD
                                                            # echo
                                                            # echo "#####"
                                                            # echo "nix flake check"
                                                            # cd "$PRIVATE_1/work-tree"
                                                            # export NIX_SHOW_TRACE=1
                                                            # export NIX_LOG=trace
                                                            # nix flake check --override-input personal "$PERSONAL_2/work-tree" --print-build-logs --show-trace
                                                            # echo "STATUS=$?"
                                                            echo
                                                            echo "#####"
                                                            echo build vm
                                                            BUILD_VM="$( ${ resources.temporary-directory } build-vm "$PRIVATE_2" "$PERSONAL_2" )"
                                                            cd "$BUILD_VM"
                                                            date
                                                            echo time timeout 10m nixos-rebuild build-vm --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            time timeout 10m nixos-rebuild build-vm --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            echo "STATUS=$?"
                                                            echo
                                                            echo "#####"
                                                            echo run vm 1
                                                            ./result/bin/run-nixos-vm
                                                            SATISFACTORY_VM_1="X"
                                                            while [[ "$SATISFACTORY_VM_1" != "y" ]] && [[ "$SATISFACTORY_VM_1" != "n" ]] && [[ "$SATISFACTORY_VM_1" != "" ]]
                                                            do
                                                                read -rp "Was the first run of the vm satisfactory:  Y/n?  " SATISFACTORY_VM_1
                                                            done
                                                            if [[ "$SATISFACTORY_VM_1" == "n" ]]
                                                            then
                                                                echo "First Run of the VM was unsatisfactory." > failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git commit --allow-empty -e -F failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git push origin HEAD
                                                                exit 64
                                                            fi
                                                            echo
                                                            echo "#####"
                                                            echo run vm 2
                                                            SATISFACTORY_VM_2="X"
                                                            while [[ "$SATISFACTORY_VM_2" != "y" ]] && [[ "$SATISFACTORY_VM_2" != "n" ]] && [[ "$SATISFACTORY_VM_2" != "" ]]
                                                            do
                                                                read -rp "Was the second run of the vm satisfactory:  Y/n?  " SATISFACTORY_VM_2
                                                            done
                                                            if [[ "$SATISFACTORY_VM_2" == "n" ]]
                                                            then
                                                                echo "Second run of the VM was unsatisfactory." > failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git commit --allow-empty -e -F failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" git push origin HEAD
                                                                exit 64
                                                            fi
                                                            echo "#####"
                                                            BUILD_VM_WITH_BOOTLOADER="$( ${ resources.temporary-directory } build-vm-with-bootloader "$PRIVATE_2" "$PERSONAL_2" )"
                                                            cd "$BUILD_VM_WITH_BOOTLOADER"
                                                            date
                                                            time timeout 10m nixos-rebuild build-vm-with-bootloader --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            time timeout 10m nixos-rebuild build-vm-with-bootloader --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            echo "STATUS=$?"
                                                            echo
                                                            echo "#####"
                                                            echo run vm-with-bootloader 1
                                                            SATISFACTORY_VM_WITH_BOOTLOADER_1="X"
                                                            while [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_1" != "y" ]] && [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_1" != "n" ]] && [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_1" != "" ]]
                                                            do
                                                                read -rp "Was the first run of the vm with bootloader satisfactory:  Y/n?  " SATISFACTORY_VM_WITH_BOOTLOADER_1
                                                            done
                                                            if [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_1" == "n" ]]
                                                            then
                                                                echo "First Run of the VM with bootloader was unsatisfactory." > failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" commit --allow-empty -e -F failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" push origin HEAD
                                                                exit 64
                                                            fi
                                                            echo
                                                            echo "#####"
                                                            echo run vm-with-bootloader 2
                                                            SATISFACTORY_VM_WITH_BOOTLOADER_2="X"
                                                            while [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_2" != "y" ]] && [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_2" != "n" ]] && [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_2" != "" ]]
                                                            do
                                                                read -rp "Was the second run of the vm with bootloader satisfactory:  Y/n?  " SATISFACTORY_VM_WITH_BOOTLOADER_2
                                                            done
                                                            if [[ "$SATISFACTORY_VM_WITH_BOOTLOADER_2" == "n" ]]
                                                            then
                                                                echo "Second run of the VM with bootloader was unsatisfactory." > failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" commit --allow-empty -e -F failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" push origin HEAD
                                                                exit 64
                                                            fi
                                                            echo
                                                            echo "#####"
                                                            echo build
                                                            date
                                                            echo time timeout 10m nixos-rebuild build --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            time timeout 10m nixos-rebuild build --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            echo "STATUS=$?"
                                                            echo
                                                            echo "#####"
                                                            echo test
                                                            date
                                                            sudo time timeout 10m nix-collect-garbage
                                                            sudo time timeout 10m nix-store --verify --check-contents --repair
                                                            date
                                                            echo sudo time timeout 10m nixos-rebuild test --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            sudo time timeout 10m nixos-rebuild test --flake "$PRIVATE_2/work-tree#user" --verbose --print-build-logs --log-format raw --show-trace --override-input personal "$PERSONAL_2/work-tree"
                                                            echo "STATUS=$?"
                                                            SATISFACTORY_TEST="X"
                                                            while [[ "$SATISFACTORY_TEST" != "y" ]] && [[ "$SATISFACTORY_TEST" != "n" ]] && [[ "$SATISFACTORY_TEST" != "" ]]
                                                            do
                                                                read -rp "Was the test satisfactory:  Y/n?  " SATISFACTORY_TEST
                                                            done
                                                            if [[ "$SATISFACTORY_TEST" == "n" ]]
                                                            then
                                                                echo "test was unsatisfactory." > failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" commit --allow-empty -e -F failure.txt
                                                                GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" push origin HEAD
                                                                exit 64
                                                            else
                                                                echo
                                                                echo "#####"
                                                                echo "READY FOR PROMOTION"
                                                                CANDIDATE=candidate/$( uuidgen )
                                                                gh auth login --with-token < ${ _secrets."github-token.asc.age" }
                                                                GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git fetch origin main
                                                                if GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git diff --quiet origin/main
                                                                then
                                                                    echo "We are not pushing a PR for personal"
                                                                else
                                                                    echo "We are pushing a PR for personal"
                                                                    GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git diff origin/main
                                                                    PR_BRANCH="scratch/$( uuidgen )"
                                                                    GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git checkout -b "$PR_BRANCH"
                                                                    GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git reset --soft origin/main
                                                                    GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git commit -a
                                                                    GIT_DIR="$PERSONAL_2/git" GIT_WORK_TREE="$PERSONAL_2/work-tree" git push origin "$PR_BRANCH"
                                                                    cd "$PERSONAL_2"
                                                                    if ! gh pr create --fill --base main --head "$PR_BRANCH"
                                                                    then
                                                                        echo Failed to create a PR for personal
                                                                        GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" commit --allow-empty -e -F failure.txt
                                                                        GIT_DIR="$PRIVATE_2/git" GIT_WORK_TREE="$PRIVATE_2/work-tree" push origin HEAD
                                                                        exit 64
                                                                    fi
                                                                fi
                                                                gh auth logout
                                                                echo "CANDIDATE=$CANDIDATE"
                                                                git -C "$PRIVATE_2/git" checkout -b "$CANDIDATE"
                                                                git -C "$PRIVATE_2/git" fetch origin main
                                                                git -C "$PRIVATE_2/git" diff origin/main
                                                                git -C "$PRIVATE_2/git" reset --soft origin/main
                                                                git -C "$PRIVATE_2/git" commit -a
                                                                git -C "$PRIVATE_2/git" push origin "$CANDIDATE"
                                                            fi
                                                        '' ;
                                                }
									    )
										( studio "studio-personal" resources.repository.personal )
										( studio "studio-private" resources.repository.private )
										( studio "studio-secret" resources.repository.secret )
										( studio "studio-secrets" resources.repository.secrets )
										( studio "studio-visitor" resources.repository.visitor )
										pkgs.git
										(
											pkgs.writeShellApplication
												{
													name = "widget-01" ;
													text = resources.dot-ssh ;
												}
										)
										(
											pkgs.writeShellApplication
												{
													name = "widget-02" ;
													text = resources.dot-pass ;
												}
										)
										(
											pkgs.stdenv.mkDerivation
												{
													installPhase =
														''
															mkdir --parents $out/bin
															makeWrapper \
																${ pkgs.pass }/bin/pass \
																$out/bin/pass \
																--run "export PASSWORD_STORE_DIR=\"\$( ${ resources.dot-pass } )/dot-pass\"" \
																--run "export PASSWORD_STORE_GPG_OPTS=\"--homedir \$( ${ resources.dot-gnupg } )/dot-gnupg\""
														'' ;
													name = "pass" ;
													nativeBuildInputs = [ pkgs.coreutils pkgs.makeWrapper ] ;
													src = ./. ;
												}
										)
									] ;
                                                                password = config.personal.password ;
                                                            } ;
                                                    } ;
                                                options =
                                                    {
                                                        personal =
                                                            {
                                                                agenix = lib.mkOption { type = lib.types.path ; } ;
                                                                calcurse =
                                                                    {
                                                                        branch = lib.mkOption { default = "artifact/b4cd8c0c6133a53020e6125e4162332e5fdb99902d3b53240045d0a" ; type = lib.types.str ; } ;
                                                                        recipient = lib.mkOption { default = "688A5A79ED45AED4D010D56452EDF74F9A9A6E20" ; type = lib.types.str ; } ;
                                                                        remote = lib.mkOption { default = "git@github.com:AFnRFCb7/artifacts.git" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                chromium =
                                                                    {
                                                                        branch = lib.mkOption { default = "artifact/eb5e3536f8f42f3e6d42d135cc85c4e0df4b955faaf7d221a0ed5ef" ; type = lib.types.str ; } ;
                                                                        recipient = lib.mkOption { default = "688A5A79ED45AED4D010D56452EDF74F9A9A6E20" ; type = lib.types.str ; } ;
                                                                        remote = lib.mkOption { default = "git@github.com:AFnRFCb7/artifacts.git" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                description = lib.mkOption { type = lib.types.str ; } ;
                                                                email = lib.mkOption { type = lib.types.str ; } ;
                                                                github = lib.mkOption { type = lib.types.path ; } ;
                                                                git-crypt = lib.mkOption { default = "" ; type = lib.types.str ; } ;
                                                                jrnl =
                                                                    {
                                                                        branch = lib.mkOption { default = "artifact/26cd15c3965a659263334b9ffc8b01020a1e5b6fe84fddc66c98b51" ; type = lib.types.str ; } ;
                                                                        recipient = lib.mkOption { default = "688A5A79ED45AED4D010D56452EDF74F9A9A6E20" ; type = lib.types.str ; } ;
                                                                        remote = lib.mkOption { default = "git@github.com:AFnRFCb7/artifacts.git" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                ledger =
                                                                    {
                                                                        branch = lib.mkOption { default = "artifact/32c193fb3a5310462e48a7c5174d9c3110f83077d13de52a9a80a40" ; type = lib.types.str ; } ;
                                                                        file = lib.mkOption { default = "ledger.txt" ; type = lib.types.str ; } ;
                                                                        recipient = lib.mkOption { default = "688A5A79ED45AED4D010D56452EDF74F9A9A6E20" ; type = lib.types.str ; } ;
                                                                        remote = lib.mkOption { default = "git@github.com:AFnRFCb7/artifacts.git" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                milestone =
                                                                    {
                                                                        timeout = lib.mkOption { default = 60 * 10 ; type = lib.types.int ; } ;
                                                                    } ;
                                                                name = lib.mkOption { type = lib.types.str ; } ;
                                                                pass =
                                                                    {
                                                                        branch = lib.mkOption { default = "scratch/8060776f-fa8d-443e-9902-118cf4634d9e" ; type = lib.types.str ; } ;
                                                                        character-set = lib.mkOption { default = ".,_=2345ABCDEFGHJKLMabcdefghjkmn" ; type = lib.types.str ; } ;
                                                                        character-set-no-symbols = lib.mkOption { default = "6789NPQRSTUVWXYZpqrstuvwxyz" ; type = lib.types.str ; } ;
                                                                        deadline = lib.mkOption { default = 60 * 60 * 24 * 366 ; type = lib.types.int ; } ;
                                                                        generated-length = lib.mkOption { default = 25 ; type = lib.types.int ; } ;
                                                                        remote = lib.mkOption { default = "git@github.com:nextmoose/secrets.git" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                password = lib.mkOption { type = lib.types.str ; } ;
                                                                repository =
                                                                    {
                                                                        pass =
                                                                            {
                                                                                branch = lib.mkOption { default = "scratch/8060776f-fa8d-443e-9902-118cf4634d9e" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:nextmoose/secrets.git" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        personal =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                owner = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/personal.git" ; type = lib.types.str ; } ;
                                                                                repo = lib.mkOption { default = "personal.git" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        private =
                                                                            {
                                                                                user = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "mobile:private" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        secret =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/secret" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                        secrets =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/12e5389b-8894-4de5-9cd2-7dab0678d22b" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                        temporary =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/temporary" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                        visitor =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/visitor" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                    } ;
                                                                wifi =
                                                                    lib.mkOption
                                                                        {
                                                                            default = { } ;
                                                                            type =
                                                                                let
                                                                                    config =
                                                                                        lib.types.submodule
                                                                                            {
                                                                                                options =
                                                                                                    {
                                                                                                        psk = lib.mkOption { type = lib.types.str ; } ;
                                                                                                    } ;
                                                                                            } ;
                                                                                        in lib.types.attrsOf config ;
                                                                        } ;
                                                            } ;
                                                    } ;
                                            } ;
                            in
                                {
                                    module = module ;
                                    tests.${ system } =
                                        let
                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
					    in
						{			
                                                } ;
                                } ;
            } ;
}
