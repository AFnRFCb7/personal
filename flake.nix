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
                                        resources_ =
                                            let
                                                seed =
                                                    visitor.lib.implementation
                                                        {
                                                            bool = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                            float = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                            int = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                            lambda = path : value : [ { path = path ; type = builtins.typeOf value ; value = null ; } ] ;
                                                            list = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                            null = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                            path = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                            set = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                            string = path : value : [ { path = path ; type = builtins.typeOf value ; value = value ; } ] ;
                                                        }
                                                        primary ;
                                                tree =
                                                    let
                                                        in
                                                            {
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
                                                                                        init-inputs ? null ,
                                                                                        init-text ? null ,
                                                                                        release-inputs ? null ,
                                                                                        release-text ? null
                                                                                    } :
                                                                                        {
                                                                                            init-inputs = init-inputs ;
                                                                                            init-text = init-text ;
                                                                                            release-inputs = release-inputs ;
                                                                                            release-text = release-text ;
                                                                                        } ;
                                                                                in identity ( value null ) ;
                                                                        in
                                                                            resources.lib.implementation
                                                                                {
                                                                                    coreutils = pkgs.coreutils ;
                                                                                    jq = pkgs.jq ;
                                                                                    init-inputs = point.input-inputs ;
                                                                                    init-text = point.init-text ;
                                                                                    nixpkgs = nixpkgs ;
                                                                                    release-inputs = point.release-inputs ;
                                                                                    release-text = point.release-text ;
                                                                                    seed = seed ;
                                                                                    system = system ;
                                                                                    yq-go = pkgs.yq-go ;
                                                                                } ;

                                                        }
                                                        tree ;
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
                                                                                            name = "debug" ;
                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.libuuid ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    UUID="$( uuidgen | sha512sum | cut --bytes -128 )" || exit 64
                                                                                                    cat <<EOF
                                                                                                    echo "$UUID \"\$*\"" >> /tmp/DEBUG
                                                                                                    EOF
                                                                                                '' ;
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
