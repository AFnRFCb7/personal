{
    inputs =
        {
        } ;
    outputs =
        { self } :
            {
                lib =
                    {
                        dot-gnupg ,
                        dot-ssh ,
                        ephemeral-bin ,
                        failure ,
                        fixture ,
                        nixpkgs ,
                        private ,
                        resources ,
                        secret ,
                        secrets ,
                        system ,
                        visitor
                    } @primary :
                        let
                            _dot-gnupg = { ownertrust , secret-keys } : dot-gnupg.lib { coreutils = pkgs.coreutils ; ownertrust = ownertrust ; secret-keys = secret-keys ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _dot-ssh = { } : dot-ssh.lib { coreutils = pkgs.coreutils ; gettext = pkgs.gettext ; visitor = _visitor.implementation ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _ephemeral-bin = { garbage-collection-root , package } : ephemeral-bin.lib { coreutils = pkgs.coreutils ; failure = _failure ; garbage-collection-root = garbage-collection-root ; nix = pkgs.nix ; package = package ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _failure = failure.lib { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; visitor = visitor ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                            _fixture = fixture.lib { age = pkgs.age ; coreutils = pkgs.coreutils ; failure = _failure ; gnupg = pkgs.gnupg ; libuuid = pkgs.libuuid ; mkDerivation = pkgs.stdenv.mkDerivation ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _resources =
                                {
                                    init ? null ,
                                    resources-directory ,
                                    resources_ready ,
                                    seed ,
                                    targets ,
                                    transient
                                } :
                                    resources.lib
                                        {
                                            buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                            coreutils = pkgs.coreutils ;
                                            failure = failure ;
                                            findutils = pkgs.findutils ;
                                            flock = pkgs.flock ;
                                            init = init ;
                                            jq = pkgs.jq ;
                                            makeBinPath = pkgs.lib.makeBinPath ;
                                            makeWrapper = pkgs.makeWrapper ;
                                            mkDerivation = pkgs.stdenv.mkDerivation ;
                                            ps = pkgs.ps ;
                                            redis = pkgs.redis ;
                                            resources = resources_ready ;
                                            resources-directory = resources-directory ;
                                            seed = seed ;
                                            targets = targets ;
                                            transient = transient ;
                                            visitor = visitor ;
                                            writeShellApplication = pkgs.writeShellApplication ;
                                            yq-go = pkgs.yq-go ;
                                        } ;
                            _secret = { } : secret.lib { age = pkgs.age ; coreutils = pkgs.coreutils ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _visitor = visitor.lib { } ;
                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                            user =
                                { config , lib , pkgs , ... } :
                                    let
                                        resources_ready =
                                            _visitor.implementation
                                                {
                                                    lambda =
                                                        path : value :
                                                            let
                                                                point = value null ;
                                                                r =
                                                                    _resources
                                                                        {
                                                                            init = point.init or null;
                                                                            resources_ready = resources_ready ;
                                                                            resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                            seed = path ;
                                                                            targets = point.targets or [ ] ;
                                                                            transient = point.transient or false ;
                                                                        } ;
                                                                    in r.implementation ;
                                                }
                                                {
                                                    foobar =
                                                        {
                                                            dot-gnupg =
                                                                ignore :
                                                                    let
                                                                        x = _dot-gnupg { ownertrust = ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/ownertrust.asc" ; secret-keys =  ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/secret-keys.asc" ; } ;
                                                                        in x.implementation ;
                                                            dot-ssh =
                                                                ignore :
                                                                    let
                                                                        x = _dot-ssh { } ;
                                                                        in
                                                                            x.implementation
                                                                                {
                                                                                    host-name = "mobile" ;
                                                                                    port = 8022 ;
                                                                                    strict-host-key-checking = true ;
                                                                                    identity-file = { resources , self } : { directory = resources.foobar.secret ( setup : setup ) ; file = "secret" ; } ;
                                                                                } ;
                                                            ephemeral =
                                                                ignore :
                                                                    let
                                                                        bin = _ephemeral-bin { garbage-collection-root = "/home/${ config.personal.name }/.nix-gcroots" ; package = "nixpkgs#cowsay" ; } ;
                                                                        in bin.implementation ;
                                                            foobar =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { resources , self } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        DOT_GNUPG=${ resources.foobar.dot-gnupg ( setup : setup ) }
                                                                                                        ln --symbolic "$DOT_GNUPG" /links
                                                                                                        ln --symbolic "$DOT_GNUPG/dot-gnupg" /mount
                                                                                                        DOT_SSH=${ resources.foobar.dot-ssh ( setup : setup ) }
                                                                                                        ln --symbolic "$DOT_SSH" /links
                                                                                                        ln --symbolic "$DOT_SSH/dot-ssh" /mount
                                                                                                        EPHEMERAL=${ resources.foobar.ephemeral ( setup : setup ) }
                                                                                                        ln --symbolic "$EPHEMERAL" /links
                                                                                                        ln --symbolic "$EPHEMERAL/ephemeral" /mount
                                                                                                        SECRET=${ resources.foobar.secret ( setup : setup ) }
                                                                                                        ln --symbolic "$SECRET" /links
                                                                                                        ln --symbolic "$SECRET/secret" /mount
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ "dot-gnupg" "dot-ssh" "ephemeral" "secret" ] ;
                                                                        transient = true ;
                                                                    } ;
                                                            secret =
                                                                ignore :
                                                                    let
                                                                        x = _secret { } ;
                                                                        in x.implementation { encrypted = ignore : "${ _fixture.implementation }/age/encrypted/known-hosts.asc" ; identity = ignore : "${ _fixture.implementation }/age/identity/private" ; } ;
                                                        } ;
                                                } ;
                                        password-less-wrap =
                                            derivation : target :
                                                pkgs.writeShellApplication
                                                    {
                                                        name = target ;
                                                        runtimeInputs = [ ( password-less-core derivation target ) ] ;
                                                        text =
                                                            ''
                                                                if read -t 0
                                                                then
                                                                    cat | sudo ${ target } "$@"
                                                                else
                                                                    sudo ${ target } "$@"
                                                                fi
                                                            '' ;
                                                    } ;
                                        password-less-core =
                                            derivation : target :
                                                pkgs.writeShellApplication
                                                    {
                                                        name = target ;
                                                        runtimeInputs = [ pkgs.coreutils derivation ] ;
                                                        text =
                                                            ''
                                                                if read -t 0
                                                                then
                                                                    cat | ${ target } "$@"
                                                                else
                                                                    ${ target } "$@"
                                                                fi
                                                            '' ;
                                                    } ;
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
                                                                        pinentryPackage = pkgs.pinentry-curses ;
                                                                    } ;
                                                            } ;
                                                        security =
                                                            {
                                                                rtkit.enable = true;
                                                                sudo.extraConfig =
                                                                    ''
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ password-less-core pkgs.nix "nix-collect-garbage" }/src/nix-collect-garbage
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ password-less-core pkgs.nixos-rebuild "nixos-rebuild" }/src/nixos-rebuild
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
                                                                redis.enable = true ;
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
                                                        system =
                                                            {
                                                                activationScripts.resourcesSubvolume =
                                                                    {
                                                                        text =
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "activation" ;
                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.mount pkgs.util-linux ] ;
                                                                                            text  =
                                                                                                ''
                                                                                                    if [ ! -e /tmp/fake-btrfs.img ]
                                                                                                    then
                                                                                                        echo "Creating temporary Btrfs image for VM..."
                                                                                                        truncate -s 1G /tmp/fake-btrfs.img
                                                                                                        mkfs.btrfs /tmp/fake-btrfs.img
                                                                                                        mkdir -p /home/${config.personal.name}/resources
                                                                                                        mount -o subvol=resources /tmp/fake-btrfs.img /home/${config.personal.name}/resources
                                                                                                    fi
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/activation" ;
                                                                    } ;
                                                                stateVersion = "23.05" ;
                                                            } ;
                                                        # systemd.services.resources-log-listener =
                                                        #    {
                                                        #         after = [ "network.target" ] ;
                                                        #         serviceConfig =
                                                        #             {
                                                        #                 ExecStart =
                                                        #                     let
                                                        #                         log-event-listener =
                                                        #                             resources.lib.listeners.log-event-listener
                                                        #                                 {
                                                        #                                     coreutils = pkgs.coreutils ;
                                                        #                                     flock = pkgs.flock ;
                                                        #                                     redis = pkgs.redis ;
                                                        #                                     resources-directory = "/home/${ config.personal. name }/resources" ;
                                                        #                                     writeShellApplication = pkgs.writeShellApplication ;
                                                        #                                     yq-go = pkgs.yq-go ;
                                                        #                                 } ;
                                                        #                         in "${ log-event-listener.implementation }/bin/log-event-listener" ;
                                                        #                 User = config.personal.name ;
                                                        #             } ;
                                                        #         wantedBy = [ "multi-user.target" ] ;
                                                        #     } ;
                                                        time.timeZone = "America/New_York" ;
                                                        users.users.user =
                                                            {
                                                                description = config.personal.description ;
                                                                extraGroups = [ "wheel" ] ;
                                                                isNormalUser = true ;
                                                                name = config.personal.name ;
                                                                packages =
                                                                    [
                                                                        pkgs.redis
                                                                        pkgs.yq-go
                                                                        pkgs.jq
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "foobar-read" ;
                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.jq ] ;
                                                                                    text =
                                                                                        ''
                                                                                            jq "." < /tmp/message
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "foobar-listen" ;
                                                                                    runtimeInputs = [ pkgs.redis ] ;
                                                                                    text =
                                                                                        ''
                                                                                            redis-cli SUBSCRIBE resource | while read -r MESSAGE
                                                                                            do
                                                                                                echo "$MESSAGE" > /tmp/message
                                                                                            done
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "foobar" ;
                                                                                    text =
                                                                                        ''
                                                                                            FOOBAR=${ resources_ready.foobar.foobar ( setup : "${ setup }" ) }
                                                                                            echo "$FOOBAR"
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
                                                                        description = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                        email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
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
                                                                        failure =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                owner = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/failure.git" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        pass =
                                                                            {
                                                                                branch = lib.mkOption { default = "scratch/8060776f-fa8d-443e-9902-118cf4634d9e" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:nextmoose/secrets.git" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        personal =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                owner = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/personal.git" ; type = lib.types.str ; } ;
                                                                                repo = lib.mkOption { default = "personal.git" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        private =
                                                                            {
                                                                                user = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "mobile:private" ; type = lib.types.str ; } ;
                                                                                ssh-config = lib.mkOption { default = resources : resources.dot-ssh.mobile ; type = lib.types.funcTo lib.types.str ; } ;
                                                                            } ;
                                                                        resources =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/resources.git" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                        secrets =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
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
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
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
                            apps =
                                {
                                    chromium =
                                        {
                                            type = "app" ;
                                            program = "${ pkgs.chromium }/bin/chromium" ;
                                        } ;
                                    pass =
                                        {
                                            type = "app" ;
                                            program = "${ pkgs.pass }/bin/pass" ;
                                        } ;
                                } ;
                            checks =
                                {
                                    dot-gnupg =
                                        let
                                            factory =
                                                _dot-gnupg
                                                    {
                                                        ownertrust = ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/ownertrust.asc" ;
                                                        secret-keys = ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/secret-keys.asc" ;
                                                    } ;
                                            in factory.check { expected = "/nix/store/rmlxnm0376g7mxxj612811bvfhg0g6ps-init/bin/init" ; failure = _failure ; mkDerivation = pkgs.stdenv.mkDerivation ; } ;
                                    dot-ssh =
                                        let
                                            factory =
                                                _dot-ssh
                                                    {
                                                    } ;
                                            in
                                                factory.check
                                                    {
                                                        configuration =
                                                            {
                                                                host = "mobile" ;
                                                                identity-file = { resources , self } :
                                                                    {
                                                                        directory = resources.directory ;
                                                                        file = resources.file ;
                                                                    } ;
                                                                port = 8022 ;
                                                                user = "git" ;
                                                                strict-host-key-checking = true ;
                                                            } ;
                                                        expected = "/nix/store/spw2lwmlvbvvlpi5x69rjy61ndzdag2j-init/bin/init" ;
                                                        failure = _failure ;
                                                        mkDerivation = pkgs.stdenv.mkDerivation ;
                                                        resources =
                                                            {
                                                                directory = "8fc5318ded93faad225f0a476792c71f33b244d0bb6bc72a4f4e52b7d1d05d04f73d4c9df8d51551ee3103a583147e4f704d39fb5330ead882155b8288d5df13" ;
                                                                file = "0aafe25583f5d05bcac9292354f28cf3010a84015ffebd0abb61cf712123133f14a909abf08c17be1ec7f0c8c9f13a4afab7e25056609457d5e7959b2d5612d9" ;
                                                            } ;
                                                        self = "50a6090ed9d519bef70bc48269f1ae80065a778abdb0dbb4aa709a82636adefd39e1e32cea576c5202ef2fc8b1a96df9b911cd8eeecacef1320a7a84afba186c" ;
                                                    } ;
                                    ephemeral =
                                        let
                                            factory =
                                                _ephemeral-bin
                                                    {
                                                        garbage-collection-root = "/build/garbage-collection-root" ;
                                                        package = "nixpkgs#cowsay" ;
                                                    } ;
                                            in factory.check { expected-init = "/nix/store/i8fxl1a8p5ajnnyfl1f1hs49gpsq11x8-init/bin/init" ; mkDerivation = pkgs.stdenv.mkDerivation ; } ;
                                    failure =
                                        _failure.check
                                            {
                                                compile-time-arguments = "469c07cdbb13c65f1435bb0b9b7eb5ed2c14d70bc111d12fda44c2cd47c23e99aed06672fec7e138bfa11de61184774d7b2dd2d33aa5958d9df49a4c55e6a8e3" ;
                                                diffutil = pkgs.diffutil ;
                                                expected-standard-error =
                                                    ''
                                                        compile-time-arguments:
                                                          path: []
                                                          type: string
                                                          value: 469c07cdbb13c65f1435bb0b9b7eb5ed2c14d70bc111d12fda44c2cd47c23e99aed06672fec7e138bfa11de61184774d7b2dd2d33aa5958d9df49a4c55e6a8e3
                                                        run-time-arguments:
                                                          - ba02df6c2bf44bb25e7a23fe02dac230baaabda128f463ce26af83e7787bc16de9260f56beaacdef75743665eededeaae997f50892983be4f40453ef6e817f4f
                                                          - b026466b770b22f738c176f6130e1d5daaca7cbffee8605eeb9f3cb2c9c7a65eb3af44cc202745bc168a7b19e2fc87a909762516f697b7dee855f5454b90c39b
                                                     '' ;
                                                run-time-arguments =
                                                    [
                                                        "ba02df6c2bf44bb25e7a23fe02dac230baaabda128f463ce26af83e7787bc16de9260f56beaacdef75743665eededeaae997f50892983be4f40453ef6e817f4f"
                                                        "b026466b770b22f738c176f6130e1d5daaca7cbffee8605eeb9f3cb2c9c7a65eb3af44cc202745bc168a7b19e2fc87a909762516f697b7dee855f5454b90c39b"
                                                    ] ;
                                            } ;
                                    # { name = "t1" ; value = log-event-listener.check { log-file = [ "409d85c81f91fa72bcb589647e59aa81b9b48a36e7e65e8d562cf86120955fe07d35dd7733f6349bc8c8bb4ed634630a03e5da0150de9ea81ef79c46a64a2456" ] ; message = "7ec5c1abf8934880c738af14ed3213437edb7e8a3b1833b31a9b253934606a0604cb80ca36f25d0f41e7f134eb9b7e6dc5473a69204b6f7c14aa2bf78d4ad840" ; mkDerivation = pkgs.stdenv.mkDerivation ; } ; }
                                    # home =
                                    #     pkgs.nixosTest
#                                        {
#                                            name = "home-test" ;
#                                            nodes.machine =
#                                                { pkgs, ... } :
#                                                    {
#                                                        imports = [ user ] ;
#                                                        environment.systemPackages =
#                                                            [
#                                                                (
#                                                                    pkgs.writeShellApplication
#                                                                        {
#                                                                            name = "test-home" ;
#                                                                            runtimeInputs =
#                                                                                [
#                                                                                    (
#                                                                                        pkgs.writeShellApplication
#                                                                                            {
#                                                                                                name = "create-mock-repository" ;
#                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
#                                                                                                text =
#                                                                                                    ''
#                                                                                                        BUILD="$1"
#                                                                                                        NAME="$2"
#                                                                                                        TOKEN="$3"
#                                                                                                        if [[ -e "$BUILD/repo/$NAME" ]]
#                                                                                                        then
#                                                                                                            ${ _failure.implementation "bf9496b6" } "$BUILD/repo/$NAME already exists"
#                                                                                                        fi
#                                                                                                        mkdir --parents "$BUILD/repo/$NAME"
#                                                                                                        cd "$BUILD/repo/$NAME"
#                                                                                                        git init --bare
#                                                                                                        if [[ -e "$BUILD/work/$NAME" ]]
#                                                                                                        then
#                                                                                                            ${ _failure.implementation "05fce8e3" } "$BUILD/work/$NAME already exists"
#                                                                                                        fi
#                                                                                                        GIT_DIR="$BUILD/work/$NAME/git"
#                                                                                                        export GIT_DIR
#                                                                                                        mkdir --parents "$GIT_DIR"
#                                                                                                        GIT_WORK_TREE="$BUILD/work/$NAME/work-tree"
#                                                                                                        export GIT_WORK_TREE
#                                                                                                        mkdir --parents "$GIT_WORK_TREE"
#                                                                                                        git init
#                                                                                                        git config user.email nina.nix@example.com
#                                                                                                        git config user.name "Nina Nix"
#                                                                                                        git remote add origin "$BUILD/repo/$NAME"
#                                                                                                        git checkout -b branch/test
#                                                                                                        touch "$GIT_WORK_TREE/$TOKEN"
#                                                                                                        git add "$TOKEN"
#                                                                                                        git commit -m "" --allow-empty-message
#                                                                                                        git push origin branch/test
#                                                                                                        echo "created $NAME repository at $BUILD/repository/$NAME"
#                                                                                                    '' ;
#                                                                                                }
#                                                                                    )
#                                                                                    (
#                                                                                        pkgs.writeShellApplication
#                                                                                            {
#                                                                                                name = "verify-mock-repository" ;
#                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.diffutils ] ;
#                                                                                                text =
#                                                                                                    ''
#                                                                                                        BUILD="$1"
#                                                                                                        HOMEY="$2"
#                                                                                                        NAME="$3"
#                                                                                                        if [[ ! -d "$HOMEY" ]]
#                                                                                                        then
#                                                                                                            ${ _failure.implementation "13510afd" } Missing HOME
#                                                                                                        fi
#                                                                                                        if [[ ! -L "$HOMEY/$NAME" ]]
#                                                                                                        then
#                                                                                                            ${ _failure.implementation "863a3d5b" } "Missing $NAME"
#                                                                                                        fi
#                                                                                                        if ! diff --recursive "$BUILD/work/$NAME/work-tree" "$HOMEY/$NAME/work-tree"
#                                                                                                        then
#                                                                                                            ${ _failure.implementation "eb549b33" } Not the same
#                                                                                                        fi
#                                                                                                        echo "tested $NAME"
#                                                                                                        '' ;
#                                                                                            }
#                                                                                    )
#                                                                                    pkgs.age
#                                                                                    pkgs.coreutils
#                                                                                    pkgs.git
#                                                                                    pkgs.which
#                                                                                ] ;
#                                                                            text =
#                                                                                ''
#                                                                                    echo "Starting test-home with $# arguments"
#                                                                                    BUILD="$1"
#                                                                                    echo Using "BUILD=$BUILD"
#                                                                                    mkdir --parents "$BUILD"
#                                                                                    age-keygen -y ${ self }/age.test.key 2>&1
#                                                                                    age-keygen -y ${ self }/age.test.key > "$BUILD/age.test.key.pub" 2>&1
#                                                                                    age-keygen -y ${ self }/age.test.key > "$BUILD/age.test.key.pub" 2>&1
#                                                                                    echo computed public key
#                                                                                    mkdir --parents "$BUILD/secrets/dot-ssh/mobile"
#                                                                                    echo 1fc11953a79d521af9082d3966596b1443048a8d2bbe7c5c2071c205211627fea557812b0014e3f6f3143d94edb2d54dfb728ea3ec3b2d622e35e1b323558494 > "$BUILD/secrets/dot-ssh/mobile/identity.asc"
#                                                                                    echo 1572ace6d3ec3303f01f43c474c40e55f0d707596043b1ce49f7f98711814920e956cbc57754ae93f5f26b0489c2ac467fc7d3f73fb71749d5e861a70aa6245b > "$BUILD/secrets/dot-ssh/mobile/unknown-hosts.asc"
#                                                                                    mkdir --parents "$BUILD/repository/secrets"
#                                                                                    git -C "$BUILD/repository/secrets" init
#                                                                                    git -C "$BUILD/repository/secrets" config user.email nina.nix@example.com
#                                                                                    git -C "$BUILD/repository/secrets" config user.name "Nina Nix"
#                                                                                    git -C "$BUILD/repository/secrets" checkout -b branch/test
#                                                                                    mkdir --parents "$BUILD/repository/secrets/dot-ssh/mobile"
#                                                                                    age --recipients-file "$BUILD/age.test.key.pub" --output "$BUILD/repository/secrets/dot-ssh/mobile/identity.asc.age" "$BUILD/secrets/dot-ssh/mobile/identity.asc"
#                                                                                    age --recipients-file "$BUILD/age.test.key.pub" --output "$BUILD/repository/secrets/dot-ssh/mobile/unknown-hosts.asc.age" "$BUILD/secrets/dot-ssh/mobile/unknown-hosts.asc"
#                                                                                    git -C "$BUILD/repository/secrets" add dot-ssh/mobile/identity.asc.age
#                                                                                    git -C "$BUILD/repository/secrets" add dot-ssh/mobile/unknown-hosts.asc.age
#                                                                                    git -C "$BUILD/repository/secrets" commit -m "" --allow-empty-message
#                                                                                    echo "created secrets repository at $BUILD/repository/secrets"
#                                                                                    create-mock-repository "$BUILD" failure f72362bddf315fe5959b74a5ce95d0fbb93155178c4f2e0c5c2dc4804be9fb3a3310b0a0f5621b2f737cdabecd84b5826fb1368888557f5b414a25f418e211bd
#                                                                                    create-mock-repository "$BUILD" personal 1ffb60928ded3a21bbff490191b3e3c6c19182d242d68b40aec1aece20bcde205c48e09b7d002c1498ab37cf865e83acdee15ad81a64ef5579f5e8b35d446eae
#                                                                                    create-mock-repository "$BUILD" private ad10b001d2d3d601bbba2c09c1df1c931098cec29d8f80901d5f21514477b1f8425c0a7d9df779da4376e911931bc83ffd48daee06d309573288e0200baf9038
#                                                                                    create-mock-repository "$BUILD" resources 604966cdd13bc61481fd84915aac1639a409de6020b88a0ac0f95196cd29201beae8d4c30990325a799c8ee14c44d9f038bae7963e83c368e5c48f43cd8b5e90
#                                                                                    create-mock-repository "$BUILD" secrets 386436e6b7328385c261d1ec574c023f88140e66507f698968014281f02d15b2eb17d0d7f434ce7f6b0298e23c47da4f78e32a8e1c0b54bb2902948d1be1c8bb
#                                                                                    create-mock-repository "$BUILD" visitor 0cd4c650d1051817e663a4a1a5e3133f029919991ab5fa85845d5c0ac1c09e2e0bb4ae65fc8e3c3735c123993ff75e6f5359572a344b6c060c844378a9788ef3
#                                                                                    echo before execute test code
#                                                                                    HOMEY="$( home )" || ${ _failure.implementation "013a89e9" }
#                                                                                    echo after execute test code
#                                                                                    verify-mock-repository "$BUILD" "$HOMEY" failure
#                                                                                    verify-mock-repository "$BUILD" "$HOMEY" personal
#                                                                                    verify-mock-repository "$BUILD" "$HOMEY" private
#                                                                                    verify-mock-repository "$BUILD" "$HOMEY" resources
#                                                                                    verify-mock-repository "$BUILD" "$HOMEY" secrets
#                                                                                    verify-mock-repository "$BUILD" "$HOMEY" visitor
#                                                                                '' ;
#                                                                        }
#                                                                )
#                                                            ] ;
#                                                        personal =
#                                                            {
#                                                                agenix = self + "/age.test.key" ;
#                                                                description = "Bob Wonderful" ;
#                                                                name = "bob" ;
#                                                                password = "password" ;
#                                                                repository =
#                                                                    {
#                                                                        failure =
#                                                                            {
#                                                                                branch = "branch/test" ;
#                                                                                remote = "/tmp/build/repo/failure" ;
#                                                                            } ;
#                                                                        personal =
#                                                                            {
#                                                                                branch = "branch/test" ;
#                                                                                remote = "/tmp/build/repo/personal" ;
#                                                                            } ;
#                                                                        private =
#                                                                            {
#                                                                                branch = "branch/test" ;
#                                                                                remote = "/tmp/build/repo/private" ;
#                                                                            } ;
#                                                                        resources =
#                                                                            {
#                                                                                branch = "branch/test" ;
#                                                                                remote = "/tmp/build/repo/resources" ;
#                                                                            } ;
#                                                                        secrets =
#                                                                            {
#                                                                                branch = "branch/test" ;
#                                                                                remote = "/tmp/build/repo/secrets" ;
#                                                                            } ;
#                                                                        visitor =
#                                                                            {
#                                                                                branch = "branch/test" ;
#                                                                                remote = "/tmp/build/repo/visitor" ;
#                                                                            } ;
#                                                                    } ;
#                                                            } ;
#                                                    } ;
#                                                testScript =
#                                                    ''
#                                                        start_all()
#                                                        machine.wait_for_unit("multi-user.target")
#                                                        status, stdout = machine.execute("su - bob --command 'test-home /tmp/build'")
#                                                        print("STDOUT:\n", stdout)
#                                                        assert status == 0, "test-home failed"
#                                                    '' ;
#                                resource-bad =
#                                    let
#                                        factory =
#                                            resources_
#                                                {
#                                                    init =
#                                                        self :
#                                                            let
#                                                                application =
#                                                                    pkgs.writeShellApplication
#                                                                        {
#                                                                            name = "init" ;
#                                                                            runtimeInputs = [ pkgs.coreutils ] ;
#                                                                            text =
#                                                                                ''
#                                                                                    echo 34605ca64083100d5f5ed3240310469417c1e03c630b45785cb0debcc663659558c6b92a9f8ea95566752ed56817575e39a15b9489580d1beb95c73f1145cf75
#                                                                                    echo 19c5d236d134a17bc43c6c6054a0f6b27215ae5958e2920b95f9a6628a297d52adae3cf56f6d2bda9803537de5eff7b9289a5c5e88f4539365c86efe42bd2eb0 > /mount/70c563fb0b88da43ed36153d14a687d740952fae000ff2d5f9ecd248cf4ce1b7672501b87c74f35072567dc7ee9b76fb97fdd344792540601a0268e080f514cd
#                                                                                    echo 476f12e58ec335340a549acbec8af647247dded6d8ce0bd099d1efaf01ffd4e4e5d2bb23490709a5621bd415510102cb81cb4d522f4ee5549af67e7c48eb7fcf > /scratch/c0a6849f689a9fb872ab666fb3dfa3af24b674e5a7fa18e2410e4be2c6cc3a064b57e4d27a9476e32bede4ab20c7d1fef4001bb005471d4068a4d7973f42919d
#                                                                                    ${ failure.implementation "11e27ca6" }
#                                                                                '' ;
#                                                                        } ;
#                                                                in "${ application }/bin/init" ;
#                                                    resources-directory = "/build/resources" ;
#                                                    seed = "2b96ee3e5a833391bc075f01f00527d33dea253ba0ba8411aea0c6dd3f2af9b92bab155b048835aefa80aa8d4a1fb0d57c4bdfbb5ececde98d817e52d16489c0" ;
#                                                    targets = [ "6e14f5ccd9489b7e3dbaec77d41c7ca6f965fcfa953839a2664b2028498b49eacc9e2f4f5846c2a1dd11e9b4dcd91d36d42483e5f12937ac5fe533385cadb2bb" ] ;
#                                                    transient = false ;
#                                                } ;
#                                        in
#                                            factory.check
#                                                {
#                                                    arguments = [ "95770bf5b1acee914409e715847308a6617c4e25b332a3d5770db63de79bfec11d40ee6a38f12f2c05970211a787740be12fa2d7175224abc215171e8526c5b3" "24c4baec1ecb46f22235b32d3d098fc2fb5b780a5f334b3519ca309433cd2cbad9cf13e06053c0eab9201e26a6dcc77ff8bf6922ebe27abeb259b746181e68e2" ] ;
#                                                    expected-dependencies = [ ] ;
#                                                    expected-index = "0000000311691948" ;
#                                                    expected-originator-pid = 45 ;
#                                                    expected-provenance = "new" ;
#                                                    expected-standard-error = "" ;
#                                                    expected-standard-output = "f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8" ;
#                                                    expected-status = 0 ;
#                                                    expected-targets = [ "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4" ] ;
#                                                    expected-transient = -1 ;
#                                                    resources-directory-fixture =
#                                                        resources-directory :
#                                                            ''
#                                                                mkdir --parents ${ resources-directory }/sequential
#                                                                echo 399813150 > ${ resources-directory }/sequential/sequential.counter
#                                                            '' ;
#                                                    standard-input = "0350c4ae74a553a0c0462b732b0d1d8439901f9535cf580b76e6d264922e6811db202f39349fe29454cc54ea966ed09225475d7776704b5cad02ff66d8350569" ;
#                                                    standard-output = "/build/resources/mounts/0000000311691948" ;
#                                                    status = 0 ;
#                                                } ;
                                                resource-happy =
                                                    let
                                                        factory =
                                                            _resources
                                                                {
                                                                    init =
                                                                        { resources , self } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "init" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    echo f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8
                                                                                                    ${ resources.d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 }
                                                                                                    echo "self = ${ self }"
                                                                                                    echo 67db2c662c09536dece7b873915f72c7746539be90c282d1dfd0a00c08bed5070bc9fbe2bb5289bcf10563f9e5421edc5ff3323f87a5bed8a525ff96a13be13d > /mount/e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4
                                                                                                    echo 99757ea5f69970ca7258207b42b7e76e09821b228db8906609699f0ed08191f606d6bdde022f8f158b9ecb7b4d70fdc8f520728867f5af35d1e189955d990a64 > /scratch/a127c8975e5203fd4d7ca6f7996aa4497b02fe90236d6aa830ca3add382084b24a3aeefb553874086c904196751b4e9fe17cfa51817e5ca441ef196738f698b5
                                                                                                '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/init" ;
                                                                    resources-directory = "/build/resources" ;
                                                                    resources_ready =
                                                                        {
                                                                            d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 =
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "f70dbffba5f85b11de293ea0f9383ff05f210b1bcca0443f79657db645a2187594511f7ce158302a8c7f249e8dc47128baa17302e96b3be43b6e33d26e822a77" ;
                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        echo resources = 5a4c4b30e8f8199aa21f472a633c5eb45e7b530f6d327babb477f67a1e7b2e6c42686f75ebf54ee29b4c48c1ceda5a84a1d192b8953a8362ebce397788934df7
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/f70dbffba5f85b11de293ea0f9383ff05f210b1bcca0443f79657db645a2187594511f7ce158302a8c7f249e8dc47128baa17302e96b3be43b6e33d26e822a77" ;
                                                                        } ;
                                                                    seed = "4259572168968d95098b9a5a8572c6ecfabe61a2522103e4c75b1317ea9cf43f96f7a135d144d2184739b6c4bd7fad1fb13a117dabbc9e58f4d4edbc26cf34f5" ;
                                                                    targets =
                                                                        [
                                                                            "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4"
                                                                        ] ;
                                                                    transient = false ;
                                                                } ;
                                                        in
                                                            factory.check
                                                                {
                                                                    arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
                                                                    diffutils = pkgs.diffutils ;
                                                                    expected-dependencies = [ ] ;
                                                                    expected-index = "0000000311691948" ;
                                                                    expected-originator-pid = 45 ;
                                                                    expected-provenance = "new" ;
                                                                    expected-standard-error = "" ;
                                                                    expected-standard-output =
                                                                        ''
                                                                            f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8
                                                                            resources = 5a4c4b30e8f8199aa21f472a633c5eb45e7b530f6d327babb477f67a1e7b2e6c42686f75ebf54ee29b4c48c1ceda5a84a1d192b8953a8362ebce397788934df7
                                                                            self = /build/resources/mounts/0000000311691948
                                                                        '' ;
                                                                    expected-status = 0 ;
                                                                    expected-targets =
                                                                        [
                                                                            "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4"
                                                                        ] ;
                                                                    expected-transient = -1 ;
                                                                    resources-directory-fixture =
                                                                        resources-directory :
                                                                            ''
                                                                                mkdir --parents ${ resources-directory }/sequential
                                                                                echo 311691948 > ${ resources-directory }/sequential/sequential.counter
                                                                            '' ;
                                                                    standard-input = "5433bd8482be1f2e1c1db4fa9268ed6e7bb02285083decb86a6166eea2df77f7e2d7524541549a3ee73d03ae955d8ec0714a959944962e8fe18f343fe108ff9f" ;
                                                                    standard-output = "/build/resources/mounts/0000000311691948" ;
                                                                    status = 0 ;
                                                                } ;
                                                resource-sad =
                                                    let
                                                        factory =
                                                          _resources
                                                              {
                                                                  init =
                                                                      { resources , self } :
                                                                          let
                                                                              application =
                                                                                  pkgs.writeShellApplication
                                                                                      {
                                                                                          name = "init" ;
                                                                                          runtimeInputs = [ pkgs.coreutils ] ;
                                                                                          text =
                                                                                              ''
                                                                                                  echo cfb1a86984144d2e4c03594b4299585aa6ec2f503a7b39b1385a5338c9fc314fd87bd904d01188b301b3cf641c4158b28852778515eba52ad7e4b148f216d1d5
                                                                                                  ${ resources.fd8e39c7a8bb3055daa71667bb0f21120642956a6ea043d0fb28c48cddba6ed8acac09c4e130da9a5e638ea8553b6fa2f45bcdef92fe62c40b70d257cc19a379 }
                                                                                                  echo "self = ${ self }"
                                                                                                  echo ae7afb90a11109a5cb07209ec48fa2d376ca0338c14c9c505f465c7cb658091549ae5344378e229674606ff46fcaf3db24b2d2b0870587d67bcad79b358ec2b9 >&2
                                                                                                  echo 97d4fec983cd3fd46ce371f0cff6f660f066924c8bd57704e2382fb0df84eb7c03e667cfb6837c2c3638dd6b5aea4f4b1c8e4fd8944de89c458313f31afa2d5b > /mount/3e30e86404135fc6036abb77e19e8cf73bb32074c07b3273a45e1262bb308f68d420d3549624ee2a44030ba23147465ed85b2c320d0661b1835627aeec050289
                                                                                                  echo 8393b1c1c760a903ea3a17d3c5831b1ed7b16bbb6ff6d9ccb751406e1fbe7c416a39fc440baf1b4a660dd928e1c060c0c05220cae8028ffde038dba033d25046 > /scratch/ea7c5d3879f282c8d3a0a2c85c464d129bc9a034d2fc9287b6588a96d1659c46a04f0e5e23f4bddd67425cee44043e421420eed8ba7cf7d2d3ecb9d8efab9f37
                                                                                                  exit 70
                                                                                              '' ;
                                                                                      } ;
                                                                              in "${ application }/bin/init" ;
                                                                    resources-directory = "/build/resources" ;
                                                                    resources_ready =
                                                                        {
                                                                            fd8e39c7a8bb3055daa71667bb0f21120642956a6ea043d0fb28c48cddba6ed8acac09c4e130da9a5e638ea8553b6fa2f45bcdef92fe62c40b70d257cc19a379 =
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "5552fc1d63b863ab116115819c2f0f2f2fb7e47fc59fd4ef3e99651b982f54b050afa38207f9d74d18a7f6e167debc1c9aad4962b22340091c45878cc1abd75c" ;
                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        echo resources = 798a6b1ff7e250f4ad9224d0fd80c642bf4f346971e35455213a03a494e1612871572b3e7996c4306edbbdebf766e81a7d2ca86efb75249718477220f45d6fa1
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/5552fc1d63b863ab116115819c2f0f2f2fb7e47fc59fd4ef3e99651b982f54b050afa38207f9d74d18a7f6e167debc1c9aad4962b22340091c45878cc1abd75c" ;
                                                                        } ;
                                                                  seed = "4259572168968d95098b9a5a8572c6ecfabe61a2522103e4c75b1317ea9cf43f96f7a135d144d2184739b6c4bd7fad1fb13a117dabbc9e58f4d4edbc26cf34f5" ;
                                                                  targets =
                                                                      [
                                                                          "20828320279b5890d7dccda8c6572b676c7954280559beb66be87ab7d2aeb060dd65c81053766fda24c36ed1ab5db40af70a420e913e16501c3b965d2d99c7e6"
                                                                      ] ;
                                                                  transient = false ;
                                                              } ;
                                                      in
                                                          factory.check
                                                              {
                                                                  arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
                                                                  diffutils = pkgs.diffutils ;
                                                                  expected-dependencies = [ ] ;
                                                                  expected-index = "0000000311691948" ;
                                                                  expected-originator-pid = 45 ;
                                                                  expected-provenance = "new" ;
                                                                  expected-standard-error = "ae7afb90a11109a5cb07209ec48fa2d376ca0338c14c9c505f465c7cb658091549ae5344378e229674606ff46fcaf3db24b2d2b0870587d67bcad79b358ec2b9" ;
                                                                  expected-standard-output =
                                                                        ''
                                                                            cfb1a86984144d2e4c03594b4299585aa6ec2f503a7b39b1385a5338c9fc314fd87bd904d01188b301b3cf641c4158b28852778515eba52ad7e4b148f216d1d5
                                                                            resources = 798a6b1ff7e250f4ad9224d0fd80c642bf4f346971e35455213a03a494e1612871572b3e7996c4306edbbdebf766e81a7d2ca86efb75249718477220f45d6fa1
                                                                            self = /build/resources/mounts/0000000311691948
                                                                        '' ;
                                                                  expected-status = 70 ;
                                                                  expected-targets =
                                                                      [
                                                                          "3e30e86404135fc6036abb77e19e8cf73bb32074c07b3273a45e1262bb308f68d420d3549624ee2a44030ba23147465ed85b2c320d0661b1835627aeec050289"
                                                                      ] ;
                                                                  expected-transient = -1 ;
                                                                  resources-directory-fixture =
                                                                      resources-directory :
                                                                          ''
                                                                              mkdir --parents ${ resources-directory }/sequential
                                                                              echo 311691948 > ${ resources-directory }/sequential/sequential.counter
                                                                          '' ;
                                                                  standard-input = "5433bd8482be1f2e1c1db4fa9268ed6e7bb02285083decb86a6166eea2df77f7e2d7524541549a3ee73d03ae955d8ec0714a959944962e8fe18f343fe108ff9f" ;
                                                                  standard-error =
                                                                      ''
                                                                          compile-time-arguments:
                                                                            path: []
                                                                            type: string
                                                                            value: 5b05da86
                                                                          run-time-arguments:
                                                                            - ""
                                                                      '' ;
                                                                  standard-output = "" ;
                                                                  status = 64 ;
                                                              } ;
                                                secret =
                                                    let
                                                        x =
                                                            _secret { } ;
                                                        in
                                                            x.check
                                                                {
                                                                    encrypted = ignore : "${ fixture }/age/encrypted/known-hosts.asc" ;
                                                                    expected = "/nix/store/lhfyrmgkb7d2s9kkvlzidkll609wllf7-init/bin/init" ;
                                                                    identity = ignore : "${ fixture }/age/identity/private" ;
                                                                    failure = _failure ;
                                                                    mkDerivation = pkgs.stdenv.mkDerivation ;
                                                               } ;
                                                visitor-happy =
                                                    _visitor.check
                                                        {
                                                            coreutils = pkgs.coreutils ;
                                                            diffutil = pkgs.diffutil ;
                                                            expected =
                                                                {
                                                                    bool =
                                                                        [
                                                                            {
                                                                                path = [ "bool" ] ;
                                                                                type = "bool" ;
                                                                                value = true ;
                                                                            }
                                                                        ] ;
                                                                    float =
                                                                        [
                                                                            {
                                                                                path = [ "float" ] ;
                                                                                type = "float" ;
                                                                                value = 1.0 ;
                                                                            }
                                                                        ] ;
                                                                    int =
                                                                        [
                                                                            {
                                                                                path = [ "int" ] ;
                                                                                type = "int" ;
                                                                                value = 1 ;
                                                                            }
                                                                        ] ;
                                                                    lambda =
                                                                        [
                                                                            {
                                                                                path = [ "lambda" ] ;
                                                                                type = "lambda" ;
                                                                                value = null ;
                                                                            }
                                                                        ] ;
                                                                    list =
                                                                        [
                                                                            [
                                                                                {
                                                                                    path = [ "list" 0 ] ;
                                                                                    type = "int" ;
                                                                                    value = 1 ;
                                                                                }
                                                                            ]
                                                                        ] ;
                                                                    null =
                                                                        [
                                                                            {
                                                                                path = [ "null" ] ;
                                                                                type = "null" ;
                                                                                value = null ;
                                                                            }
                                                                        ] ;
                                                                    path =
                                                                        [
                                                                            {
                                                                                path = [ "path" ] ;
                                                                                type = "path" ;
                                                                                value = ./. ;
                                                                            }
                                                                        ] ;
                                                                    set =
                                                                        {
                                                                            one =
                                                                                [
                                                                                    {
                                                                                        path = [ "set" "one" ] ;
                                                                                        type = "int" ;
                                                                                        value = 1 ;
                                                                                    }
                                                                                ] ;
                                                                        } ;
                                                                    string =
                                                                        [
                                                                            {
                                                                                path = [ "string" ] ;
                                                                                type = "string" ;
                                                                                value = "1" ;
                                                                            }
                                                                        ] ;
                                                                } ;
                                                            mkDerivation = pkgs.stdenv.mkDerivation ;
                                                            success = true ;
                                                            value =
                                                                {
                                                                    bool = true ;
                                                                    float = 1.0 ;
                                                                    int = 1 ;
                                                                    lambda = i : i ;
                                                                    list = [ 1 ] ;
                                                                    null = null ;
                                                                    path = ./. ;
                                                                    set = { one = 1 ; } ;
                                                                    string = "1" ;
                                                                } ;
                                                            visitors =
                                                                let
                                                                    string = path : value : let type = builtins.typeOf value ; in [ { path = path ; type = type ; value = if type == "lambda" then null else value ; } ] ;
                                                                    in
                                                                        {
                                                                            bool = string ;
                                                                            float = string ;
                                                                            int = string ;
                                                                            lambda = string ;
                                                                            null = string ;
                                                                            path = string ;
                                                                            string = string ;
                                                                        } ;
                                                            writeShellApplication = pkgs.writeShellApplication ;
                                                            yq-go = pkgs.yq-go ;
                                                        } ;
                                                visitor-sad =
                                                    _visitor.check
                                                        {
                                                            coreutils = pkgs.coreutils ;
                                                            diffutil = pkgs.diffutil ;
                                                            mkDerivation = pkgs.stdenv.mkDerivation ;
                                                            writeShellApplication = pkgs.writeShellApplication ;
                                                            yq-go = pkgs.yq-go ;
                                                        } ;
                                            } ;
                                    modules =
                                        {
                                            user = user ;
                                        } ;
                                } ;
            } ;
}
