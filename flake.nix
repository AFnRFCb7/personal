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
			            resources ,
                        secrets ,
                        private ,
                        system ,
                        visitor
                    } @primary :
                        let
                            user =
                                { config , lib , pkgs , ... } :
                                    let
                                        resources_ =
                                            let
                                                seed =
                                                    let
                                                        seed = path : value : [ { path = path ; type = builtins.typeOf value ; value = if builtins.typeOf value == "lambda" then null else value ; } ] ;
                                                        in
                                                            visitor.lib.implementation
                                                                {
                                                                    bool = seed ;
                                                                    float = seed ;
                                                                    int = seed ;
                                                                    lambda = seed ;
                                                                    list = seed ;
                                                                    null = seed ;
                                                                    path = seed ;
                                                                    set = seed ;
                                                                    string = seed ;
                                                                }
                                                                primary ;
                                                tree =
                                                    let
                                                        dot-ssh =
                                                            {
                                                                address-family ? null ,
                                                                batch-mode ? null ,
                                                                bind-address ? null ,
                                                                canonical-domains ? null ,
                                                                canonicalize-fallback-local ? null ,
                                                                canonicalize-hostname ? null ,
                                                                check-host-ip ? null ,
                                                                challenge-response-authentication ? null ,
                                                                ciphers ? null ,
                                                                compression ? null ,
                                                                connect-timeout ? null ,
                                                                forward-agent ? null ,
                                                                gateway-ports ? null ,
                                                                gssapi-authentication ? null ,
                                                                gssapi-delegate-credentials ? null ,
                                                                gssapi-key-exchange ? null ,
                                                                gssapi-renewal-forces-rekey ? null ,
                                                                gssapi-trust-dns ? null ,
                                                                host ? null ,
                                                                hostkey-alias ? null ,
                                                                host-name ? null ,
                                                                identities-only ? null ,
                                                                identity-agent ? null ,
                                                                identity-file ? null ,
                                                                ignore-unknown ? null ,
                                                                ip-qos ? null ,
                                                                kbd-interactive-authentication ? null ,
                                                                kbd-interactive-devices ? null ,
                                                                kex-algorithms ? null ,
                                                                local-forward ? null ,
                                                                log-level ? null ,
                                                                match ? null ,
                                                                no-host-authentication-for-localhost ? null ,
                                                                password-authentication ? null ,
                                                                permit-local-command ? null ,
                                                                permit-remote-open ? null ,
                                                                pkcs11-provider ? null ,
                                                                port ? null ,
                                                                preferred-authentications ? null ,
                                                                protocol ? null ,
                                                                proxy-command ? null ,
                                                                proxy-jump ? null ,
                                                                proxy-use-fdpass ? null ,
                                                                pubkey-accepted-key-types ? null ,
                                                                pubkey-authentication ? null ,
                                                                rekey-limit ? null ,
                                                                remote-forward ? null ,
                                                                server-alive-count-max ? null ,
                                                                server-alive-interval ? null ,
                                                                sessiontype ? null ,
                                                                user ? null ,
                                                                user-known-hosts-file ? null
                                                            } @primary :
                                                                let
                                                                    environmented =
                                                                        let
                                                                            mapper = value : builtins.concatStringsSep "" [ value.name "=" value.value ] ;
                                                                            in builtins.map mapper sorted ;
                                                                    indent = if builtins.typeOf host == "null" then [ ] else [ "\t" ] ;
                                                                    listed =
                                                                        let
                                                                            mapper =
                                                                                name : value :
                                                                                    {
                                                                                        index = if name == "host" then 0 else 1 ;
                                                                                        name =
                                                                                            let
                                                                                                lower-case = [ "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" ] ;
                                                                                                space-case = builtins.map ( letter : builtins.concatStringsSep "" [ "_" letter ] ) lower-case ;
                                                                                                upper-case = [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" ] ;
                                                                                                name-lower-cased = builtins.replaceStrings upper-case lower-case name ;
                                                                                                name-prefixed = builtins.concatStringsSep "" [ "_" name ] ;
                                                                                                name-space-cased = builtins.replaceStrings space-case upper-case ;
                                                                                                in name-space-cased ;
                                                                                        value =
                                                                                            let
                                                                                                booleans =
                                                                                                    [
                                                                                                        "batch-mode"
                                                                                                        "challenge-response-authentication"
                                                                                                        "compression"
                                                                                                        "forward-agent"
                                                                                                        "gateway-ports"
                                                                                                        "gssapi-authentication"
                                                                                                        "gssapi-delegate-credentials"
                                                                                                        "ignore-unknown"
                                                                                                        "kbd-interactive-authentication"
                                                                                                        "no-host-authentication-for-localhost"
                                                                                                        "password-authentication"
                                                                                                        "permit-local-command"
                                                                                                        "permit-remote-open"
                                                                                                        "pubkey-authentication"
                                                                                                        "verify-host-key-dns"
                                                                                                        "forward-x11"
                                                                                                        "forward-x11-trusted"
                                                                                                    ] ;
                                                                                            integers =
                                                                                                [
                                                                                                    "port"
                                                                                                    "connect-timeout"
                                                                                                    "server-alive-count-max"
                                                                                                    "server-alive-interval"
                                                                                                ] ;
                                                                                            resources =
                                                                                                [
                                                                                                    "identity-file"
                                                                                                    "user-known-hosts-file"
                                                                                                    "identity-agent"
                                                                                                    "pkcs11-provider"
                                                                                                    "proxy-command"
                                                                                                ] ;
                                                                                            in
                                                                                                if builtins.any ( n : n == name ) booleans then if value then ''"YES"'' else ''"NO"''
                                                                                                else if builtins.any ( n : n == name ) integers then builtins.concatStringsSep "" [ "\"" ( builtins.toString value ) "\"" ]
                                                                                                else if builtins.any ( n : n == name ) resources then builtins.concatStringsSep "" [ "\"$( " ( value resources_ ) ")\" || exit 64" ]
                                                                                                else builtins.concatStringsSep "" [ "\"" value "\"" ] ;
                                                                                    } ;
                                                                            in builtins.mapAttrs mapper primary ;
                                                                    sorted = builtins.sort ( a : b : if a.index < b.index then true else if a.index > b.index then false else a.name < b.name ) listed ;
                                                                    stringed =
                                                                        let
                                                                            mapper = value : builtins.concatStringsSep "" ( builtins.concatLists [ indent [ value.name " $" value.name ] ] ) ;
                                                                            in builtins.map mapper sorted ;
                                                                    in
                                                                        {
                                                                            init =
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "application" ;
                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        ${ builtins.concatStringsSep "\n" environmented }
                                                                                                        cat > /mount/config <<EOF
                                                                                                        ${ builtins.concatStringsSep "\n" stringed }
                                                                                                        EOF
                                                                                                        chmod 0400 /mount/config
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/application" ;
                                                                        } ;
                                                        git =
                                                            {
                                                                configs ? { } ,
                                                                hooks ? { } ,
                                                                remotes ? { } ,
                                                                setup ? null ,
                                                                release-inputs ? null ,
                                                                release-text ? null
                                                            } : ignore :
                                                                {
                                                                    init =
                                                                        self :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            inputs = [ pkgs.coreutils  pkgs.git ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    export GIT_DIR=/mount/git
                                                                                                    export GIT_WORK_TREE=/mount/work-treee
                                                                                                    mkdir --parents "$GIT_DIR"
                                                                                                    mkdir --parents "$GIT_WORK_TREE"
                                                                                                    git init
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git config "${ name }" "${ value }"'' ) configs ) ) }
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''ln --symbolic "${ value }" "$"{ self }/git/hooks/${ name }"'' ) hooks ) ) }
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git remote add "${ name }" "${ value }"'' ) remotes ) ) }
                                                                                                    ${ if builtins.typeOf setup == "string" then ''if read -t 0 ; then cat exec ${ setup } "$@" ; else cat exec ${ setup } "$@" ; fi'' else "#" }
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/application" ;
                                                                    release =
                                                                        let
                                                                        application =
                                                                                pkgs.writeShellApplication
                                                                                    {
                                                                                        inputs = release-inputs ;
                                                                                        text = release-text ;
                                                                                    } ;
                                                                            in "${ application }/bin/application" ;
                                                                } ;
                                                        post-commit =
                                                            remote :
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
                                                                                            sleep 1s
                                                                                        done
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ post-commit }/bin/post-commit" ;
                                                        ssh-command =
                                                            ssh-config :
                                                                let
                                                                    ssh-command =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "ssh-command" ;
                                                                                runtimeInputs = [ pkgs.openssh ] ;
                                                                                text =
                                                                                    ''
                                                                                        exec ssh -F "${ ssh-config }" "$@"
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ ssh-command }/bin/ssh-command" ;
                                                        in
                                                            {
                                                                dot-ssh =
                                                                    {
                                                                        mobile =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "application" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    cat ${ _secrets.dot-ssh.boot."identity.asc.age" } > /mount/identity
                                                                                                                    cat ${ _secrets.dot-ssh.boot."known-hosts.asc.age" } > /mount/known-hosts
                                                                                                                    cat > /mount/config <<EOF
                                                                                                                    HostName mobile
                                                                                                                    Host 192.168.1.202
                                                                                                                    Port 8022
                                                                                                                    IdentityFile $SELF/identity
                                                                                                                    UserKnownHostsFile $SELF/known-hosts
                                                                                                                    StrictHostKeyChecking yes
                                                                                                                    EOF
                                                                                                                    chmod 0400 /mount/identity /mount/known-hosts /mount/config
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/application" ;
                                                                                } ;
                                                                    } ;
                                                                home =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "application" ;
                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        mkdir --parents /mount/.gpg
                                                                                                        mkdir --parents /mount/.ssh
                                                                                                        mkdir --parents /mount/bin
                                                                                                        mkdir --parents /mount/repository
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/application" ;
                                                                        } ;
                                                                repository =
                                                                    {
                                                                    } ;
                                                            } ;
                                                in
                                                    visitor.lib.implementation
                                                        {
                                                            lambda =
                                                                path : value :
                                                                    let
                                                                        point =
                                                                            let
                                                                                identity =
                                                                                    {
                                                                                        init ? null ,
                                                                                        release ? null
                                                                                    } :
                                                                                        {
                                                                                            init = init ;
                                                                                            release = release ;
                                                                                        } ;
                                                                                in identity ( value null ) ;
                                                                        in
                                                                            resources.lib.implementation
                                                                                {
                                                                                    buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                                                                    coreutils = pkgs.coreutils ;
                                                                                    findutils = pkgs.findutils ;
                                                                                    flock = pkgs.flock ;
                                                                                    gnutar = pkgs.gnutar ;
                                                                                    inotify-tools = pkgs.inotify-tools ;
                                                                                    jq = pkgs.jq ;
                                                                                    init = point.init ;
                                                                                    resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                                    release = point.release ;
                                                                                    seed = seed ;
                                                                                    visitor = visitor ;
                                                                                    writeShellApplication = pkgs.writeShellApplication ;
                                                                                    yq-go = pkgs.yq-go ;
                                                                                    zstd = pkgs.zstd ;
                                                                                } ;

                                                        }
                                                        tree ;
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
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nixos-rebuild }/bin/nixos-rebuild
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nix }/bin/nix-collect-garbage
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nix }/bin/nix-store
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
                                                                                                makeWrapper ${ pkgs.jetbrains.idea-community }/bin/idea-community $out/bin/${ name } --run "REPO=\"\$( ${ repository } )\" || exit 64" --add-flags "\$REPO"
                                                                                            '' ;
                                                                                        name = "derivation" ;
                                                                                        nativeBuildInputs = [ pkgs.makeWrapper ] ;
                                                                                        src = ./. ;
                                                                                    } ;
									                                    in
                                                                            [
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "home" ;
                                                                                            text = resources_.home ;
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
                                                                        epoch = lib.mkOption { default = 60 * 60 * 24 * 7 ; type = lib.types.int ; } ;
                                                                        format = lib.mkOption { default = "weekly/%Y-%m-%d" ; type = lib.types.str ; } ;
                                                                        timeout = lib.mkOption { default = 60 * 60 ; type = lib.types.int ; } ;
                                                                        timeout2 = lib.mkOption { default = 60 ; type = lib.types.int ; } ;
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
                                                                                user = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/applications" ; type = lib.types.str ; } ;
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
                                                                                ssh-config = lib.mkOption { default = dot-ssh : dot-ssh.mobile ; type = lib.types.funcTo lib.types.str ; } ;
                                                                                user-email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                user-name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        resources =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/resources.git" ; type = lib.types.str ; } ;
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
                                            user = user ;
                                            tester =
                                                { config , pkgs , ... } :
                                                    {
                                                        systemd.services =
                                                            {
                                                                user-test =
                                                                    {
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
                                                                                                            echo 0 > /tmp/shared/status
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/application" ;
                                                                                User = config.personal.name ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                                root-test =
                                                                    {
                                                                        after = [ "user-test.service" ] ;
                                                                        serviceConfig =
                                                                            {
                                                                                ExecStart = "${ pkgs.systemd }/bin/systemctl poweroff" ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                            } ;
                                                    } ;
                                        } ;
                                    checks.${ system } =
                                        let
                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
					                        in
						                        {
						                            foobar =
						                                pkgs.stdenv.mkDerivation
						                                    {
						                                        installPhase =
						                                            ''
						                                                touch $out
						                                                exit 0
						                                            '' ;
                                                                name = "foobar" ;
                                                                src = ./. ;
						                                    } ;
                                                } ;
                                } ;
            } ;
}
