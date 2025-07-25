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
                            tester =
                                { config , pkgs , ... } :
                                    {
                                        boot.kernelModules = [ "9p" "9pnet" "9pnet_virtio" ] ;
                                        fileSystems."/tmp/xchng" =
                                            {
                                                fsType = "9p" ;
                                                device = "shared" ;
                                                options = [ "trans=virtio" "version=9p2000.L" "cache=loose" ] ;
                                            } ;
                                        systemd.services.test =
                                            {
                                                after = [ "test.mount" ] ;
                                                requires = [ "test.mount" ] ;
                                                serviceConfig =
                                                    {
                                                        ExecStart =
                                                            let
                                                                application =
                                                                    pkgs.writeShellApplication
                                                                        {
                                                                            name = "application" ;
                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                            text =
                                                                                ''
                                                                                    touch /tmp/xchng/FLAG || true
                                                                                    /usr/bin/systemctl poweroff
                                                                                '' ;
                                                                        } ;
                                                                in "${ application }/bin/application" ;
                                                        Type = "oneshot" ;
                                                        User = config.personal.name ;
                                                    } ;
                                                wantedBy = [ "multi-user.target" ];
                                            } ;
                                    } ;
                            user =
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
                                                                            DOT_SSH=$( ${ resources.dot-ssh } )/config
                                                                            export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH"
                                                                            git fetch origin ${ config.personal.pass.branch }
                                                                            git checkout ${ config.personal.pass.branch }
                                                                        '' ;
                                                                } ;
                                                        milestone =
                                                            {
                                                                check =
                                                                    ignore :
                                                                        {
                                                                            init-inputs = [ pkgs.coreutils pkgs.nix ] ;
                                                                            init-text =
                                                                                ''
                                                                                    export NIX_LOG=trace
                                                                                    export NIX_SHOW_TRACE=1
                                                                                    cd "$( ${ resources.milestone.source.private } "$@" )/work-tree"
                                                                                    nix flake check --print-build-logs --verbose --verbose --verbose
                                                                                '' ;
                                                                        } ;
                                                                configuration =
                                                                    ignore :
                                                                        {
                                                                            init-text =
                                                                                ''
                                                                                    echo "overrides:" > "$SELF/configuration.yaml"
                                                                                    while [[ "$#" -gt 0 ]]
                                                                                    do
                                                                                        SHIFT=0
                                                                                        case "$1" in
                                                                                            --shift)
                                                                                                if [[ "$#" -lt 2 ]]
                                                                                                then
                                                                                                    echo SHIFT needs one argument >&2
                                                                                                    exit 64
                                                                                                fi
                                                                                                SHIFT="$2"
                                                                                                shift 2
                                                                                                ;;
                                                                                            --override-input)
                                                                                                if [[ "$#" -lt 3 ]]
                                                                                                then
                                                                                                    echo OVERRIDE_INPUT needs two arguments >&2
                                                                                                    exit 64
                                                                                                fi
                                                                                                echo "  $2: $3" >> "$SELF/configuration.yaml"
                                                                                                shift 3
                                                                                                ;;
                                                                                            *)
                                                                                                shift
                                                                                                ;;
                                                                                        esac
                                                                                    done
                                                                                    echo "shift: $SHIFT" >> "$SELF/configuration.yaml"
                                                                                '' ;
                                                                        } ;
                                                                source =
                                                                    let
                                                                        repository =
                                                                            name : origin : input-script : sed : ignore :
                                                                                {
                                                                                    init-inputs = [ pkgs.coreutils pkgs.git pkgs.yq ] ;
                                                                                    init-text =
                                                                                        ''
                                                                                            CONFIGURATION="$1"
                                                                                            export GIT_DIR="$SELF/git"
                                                                                            export GIT_WORK_TREE="$SELF/work-tree"
                                                                                            mkdir --parents "$GIT_DIR"
                                                                                            mkdir --parents "$GIT_WORK_TREE"
                                                                                            git init
                                                                                            DOT_SSH=$( ${ resources.dot-ssh } )/config
                                                                                            git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $DOT_SSH"
                                                                                            git config user.email ${ config.personal.email }
                                                                                            git config user.name "${ config.personal.name }"
                                                                                            git remote add origin "${ origin }"
                                                                                            echo "84fb26cb-4105-4a5f-be7a-bf5b3806239f" > /tmp/DEBUG
                                                                                            cat >> /tmp/DEBUG <<EOF
                                                                                            INPUTP="\$( yq --raw-output ".overrides.${ name }" "$CONFIGURATION" )"
                                                                                            EOF
                                                                                            INPUTP="$( yq --raw-output ".overrides.${ name }" "$CONFIGURATION" )"
                                                                                            echo "59f57e79-bede-40ae-b397-1c4196e2dccb $INPUTP" >> /tmp/DEBUG
                                                                                            INPUT="$( echo -n "$INPUTP" )"
                                                                                            echo "7b7bf5ed-70cc-48ac-bfd5-e031ab1f9b14" >> /tmp/DEBUG
                                                                                            if [[ "$INPUT" != "null" ]]
                                                                                            then
                                                                                                INPUT="$( ${ input-script } )"
                                                                                            fi
                                                                                            echo "561cc4f2-7014-4a65-8ead-121ab958a928" >> /tmp/DEBUG
                                                                                            GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git add .
                                                                                            GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git commit -am "" --allow-empty --allow-empty-message
                                                                                            BRANCH="$( GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git rev-parse --abbrev-ref HEAD )"
                                                                                            git fetch origin "$BRANCH"
                                                                                            COMMIT="$( GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git rev-parse HEAD )"
                                                                                            git checkout "$COMMIT"
                                                                                            ${ if sed then "git fetch origin scratch/f91bb4c0-5c10-41f0-bb3c-cab9bd3ee3fc && git checkout scratch/f91bb4c0-5c10-41f0-bb3c-cab9bd3ee3fc" else "# " }
                                                                                            ${ if sed then "# shellcheck disable=SC2027,SC2086,SC2068" else "#" }
                                                                                            ${ if sed then ''sed -i ${ builtins.concatStringsSep " " ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''-e "s#\(${ name }.url.*?ref=\)main\(\".*\)\$#\1$( GIT_DIR="$( ${ value } "$@" )/git" GIT_WORK_TREE="$( ${ value } "$@" )/work-tree" ${ pkgs.git }/bin/git rev-parse HEAD )\2#"'' ) resources.milestone.source.inputs ) ) } "$GIT_WORK_TREE/flake.nix"'' else "# " }
                                                                                        '' ;
                                                                                } ;
                                                                        in
                                                                            {
                                                                                private = repository "private" config.personal.repository.private.remote resources.repository.private true ;
                                                                                inputs =
                                                                                    {
                                                                                        # applications = repository "applications" config.personal.repository.applications.remote resources.repository.applications false ;
                                                                                        personal = repository "personal" config.personal.repository.personal.remote resources.repository.personal false ;
                                                                                        secret = repository "secret" config.personal.repository.secret.remote resources.repository.secret false ;
                                                                                        secrets = repository "secrets" config.personal.repository.secrets.remote resources.repository.secrets false ;
                                                                                        visitor = repository "visitor" config.personal.repository.visitor.remote resources.repository.visitor false ;
                                                                                    } ;
                                                                            } ;
                                                                virtual-machine =
                                                                    {
                                                                        build =
                                                                            ignore :
                                                                                {
                                                                                    init-inputs = [ pkgs.nixos-rebuild ] ;
                                                                                    init-text =
                                                                                        ''
                                                                                            cd "$SELF"
                                                                                            nixos-rebuild build-vm --flake "$( ${ resources.milestone.source.private } "$@" )/work-tree#tester"
                                                                                        '' ;
                                                                                } ;
                                                                        run =
                                                                            ignore :
                                                                                {
                                                                                    init-inputs = [ pkgs.coreutils ] ;
                                                                                    init-text =
                                                                                        ''
                                                                                            mkdir --parents "$SELF/test"
                                                                                            export QEMU_OPTS="-virtfs local,path=$SELF/test,mount_tag=test,security_model=none"
                                                                                            ${ resources.milestone.virtual-machine.build }/result/bin/run-nixos-vm
                                                                                        '' ;
                                                                                } ;
                                                                    } ;
                                                            } ;
                                                        repository =
                                                            let
                                                                repository =
                                                                    origin : ignore :
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
                                                                                                export GIT_DIR="$SELF/git"
                                                                                                export GIT_WORK_TREE="$SELF/work-tree"
                                                                                                mkdir --parents "$SELF/home"
                                                                                                mkdir --parents "$GIT_DIR"
                                                                                                mkdir --parents "$GIT_WORK_TREE"
                                                                                                git init
                                                                                                git config core.sshCommand ${ ssh }/bin/ssh
                                                                                                git config user.email ${ config.personal.email }
                                                                                                git config user.name "${ config.personal.description }"
                                                                                                ln --symbolic ${ post-commit } "$GIT_DIR/hooks"
                                                                                                git remote add origin ${ origin }
                                                                                                git fetch origin main
                                                                                                git checkout origin/main
                                                                                                git checkout -b "scratch/$( uuidgen )"
                                                                                            '' ;
                                                                        } ;
                                                                in
                                                                    {
                                                                        applications = repository config.personal.repository.personal.remote ;
                                                                        personal = repository config.personal.repository.personal.remote ;
                                                                        private = repository config.personal.repository.private.remote ;
                                                                        secret = repository config.personal.repository.secret.remote ;
                                                                        secrets = repository config.personal.repository.secrets.remote ;
                                                                        visitor = repository config.personal.repository.visitor.remote ;
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
                                                                                (
                                                                                    pkgs.stdenv.mkDerivation
                                                                                        {
                                                                                            installPhase =
                                                                                                let
                                                                                                    milestone =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "milestone" ;
                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        date --date "$( )" +%Y-%m
                                                                                                                    '' ;
                                                                                                           } ;
                                                                                                    promote =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "promote" ;
                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.nix ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        SOURCE="$( ${ resources.milestone.source.private } "$@" )"
                                                                                                                        echo "$SOURCE"
                                                                                                                        head "$SOURCE/work-tree/flake.nix"
                                                                                                                        # export NIX_LOG=trace
                                                                                                                        # export NIX_SHOW_TRACE=1
                                                                                                                        # cd "$SOURCE/work-tree"
                                                                                                                        # nix flake check --print-build-logs --verbose --verbose --verbose
                                                                                                                        CHECK="$( ${ resources.milestone.check } "$@" )"
                                                                                                                        echo "CHECK=$CHECK"
                                                                                                                        BUILD_VM="$( ${ resources.milestone.virtual-machine.build } "$@" )"
                                                                                                                        echo "BUILD_VM=$BUILD_VM"
                                                                                                                        RUN_VM="$( ${ resources.milestone.virtual-machine.run } "$@" )"
                                                                                                                        echo "RUN_VM=$RUN_VM"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in
                                                                                                        ''
                                                                                                            mkdir --parents $out/bin
                                                                                                            makeWrapper ${ resources.milestone.configuration } $out/bin/configuration
                                                                                                            makeWrapper ${ milestone }/bin/milestone $out/bin/milestone
                                                                                                            makeWrapper ${ promote }/bin/promote $out/bin/promote
                                                                                                        '' ;
                                                                                            name = "promotion" ;
                                                                                            nativeBuildInputs = [ pkgs.coreutils pkgs.makeWrapper ] ;
                                                                                            src = ./. ;
                                                                                        }
                                                                                )
                                                                                ( studio "studio-personal" resources.repository.personal )
                                                                                ( studio "studio-private" resources.repository.private )
                                                                                ( studio "studio-secret" resources.repository.secret )
                                                                                ( studio "studio-secrets" resources.repository.secrets )
                                                                                ( studio "studio-visitor" resources.repository.visitor )
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
                                                                inputs =
                                                                    {
                                                                        main-off = lib.mkOption { default = "2b4089c055570df1fb70398d50f1404d125aaa36475d85cc6d8fd2ec7d46047ca912a86ff6709b9e2a929719be9e463093c7d925243cbd9db75f7dfefea1dbe0" ; type = lib.types.str ; } ;
                                                                        main-on = lib.mkOption { default = "cc73ebe6bbcaf395ab8c215a31c09c731abc2c0e8a457d7c8335bd5ede769f8db56f21facf2fe87e45ab5b1f735df78e149b1999ff5d347e1f9e9dc6bf82b905" ; type = lib.types.str ; } ;
                                                                        milestone-off = lib.mkOption { default = "7de191948d9835eb76b0d675f26fa8bf2a4fc9c9a63315ecb3f09b82c80ac3eb227258a14114175b627b8d2fbb8f1d9a622fd8ff04d0744c53e9d2fedeaff96f" ; type = lib.types.str ; } ;
                                                                        milestone-on = lib.mkOption { default = "7de191948d9835eb76b0d675f26fa8bf2a4fc9c9a63315ecb3f09b82c80ac3eb227258a14114175b627b8d2fbb8f1d9a622fd8ff04d0744c53e9d2fedeaff96f" ; type = lib.types.str ; } ;
                                                                        revision = lib.mkOption { default = "aa916f7d28b9813003790426ff3059ad5d8d2c9b7cdc8983da8c474b1fe899544b398a1a22966dde3cd4282e56ee4764d93e6ada1eab13b0f7bf03ca9693a623" ; type = lib.types.str ; } ;
                                                                    } ;
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
                                                                        applications =
                                                                            {
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/applications.git" ; type = lib.types.str ; } ;
                                                                            } ;
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
                                    modules =
                                        {
                                            tester = tester ;
                                            user = user ;
                                        } ;
                                    tests.${ system } =
                                        let
                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
					                        in
						                        {
                                                } ;
                                } ;
            } ;
}
