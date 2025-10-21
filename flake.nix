{
    inputs =
        {
        } ;
    outputs =
        { self } :
            {
                lib =
                    {
                        failure ,
                        nixpkgs ,
                        private ,
                        resources ,
                        secrets ,
                        system ,
                        visitor
                    } @primary :
                        let
                            _failure = failure.lib { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; visitor = visitor ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                            _visitor = visitor.lib { } ;
                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                            user =
                                { config , lib , pkgs , ... } :
                                    let
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
                            checks =
                                {
                                    # failure = _failure.check { compile-time-arguments = "469c07cdbb13c65f1435bb0b9b7eb5ed2c14d70bc111d12fda44c2cd47c23e99aed06672fec7e138bfa11de61184774d7b2dd2d33aa5958d9df49a4c55e6a8e3" ; expected-standard-error = "" ; run-time-arguments = [ "ba02df6c2bf44bb25e7a23fe02dac230baaabda128f463ce26af83e7787bc16de9260f56beaacdef75743665eededeaae997f50892983be4f40453ef6e817f4f" ] ; } ; } ;
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
#                                resource-good =
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
#                                                                                    echo f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8
#                                                                                    echo 67db2c662c09536dece7b873915f72c7746539be90c282d1dfd0a00c08bed5070bc9fbe2bb5289bcf10563f9e5421edc5ff3323f87a5bed8a525ff96a13be13d > /mount/e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4
#                                                                                    echo 99757ea5f69970ca7258207b42b7e76e09821b228db8906609699f0ed08191f606d6bdde022f8f158b9ecb7b4d70fdc8f520728867f5af35d1e189955d990a64 > /scratch/a127c8975e5203fd4d7ca6f7996aa4497b02fe90236d6aa830ca3add382084b24a3aeefb553874086c904196751b4e9fe17cfa51817e5ca441ef196738f698b5
#                                                                                '' ;
#                                                                        } ;
#                                                                in "${ application }/bin/init" ;
#                                                    resources-directory = "/build/resources" ;
#                                                    seed = "4259572168968d95098b9a5a8572c6ecfabe61a2522103e4c75b1317ea9cf43f96f7a135d144d2184739b6c4bd7fad1fb13a117dabbc9e58f4d4edbc26cf34f5" ;
#                                                    targets = [ "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4" ] ;
#                                                    transient = false ;
#                                                } ;
#                                        in
#                                            factory.check
#                                                {
#                                                    arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
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
#                                                                echo 311691948 > ${ resources-directory }/sequential/sequential.counter
#                                                            '' ;
#                                                    standard-input = "5433bd8482be1f2e1c1db4fa9268ed6e7bb02285083decb86a6166eea2df77f7e2d7524541549a3ee73d03ae955d8ec0714a959944962e8fe18f343fe108ff9f" ;
#                                                    standard-output = "/build/resources/mounts/0000000311691948" ;
#                                                    status = 0 ;
#                                                } ;
                                                visitor =
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
                                                                                value = null ;
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
                                                                    path =
                                                                        let
                                                                            constant = pkgs.writeText "constant" "7e01e5896a912a3f5c7b7dcf10677b6538b08d95f3ff01019ce1f80c3c4b6b1f6cdcea222f3ed1e630159ca787a5bd586b8715b38abb1974499a7e854e9dc19b" ;
                                                                            in constant.outPath ;
                                                                    set = { one = 1 ; } ;
                                                                    string = "1" ;
                                                                } ;
                                                            visitors =
                                                                let
                                                                    string = path : value : let type = builtins.typeOf value ; in [ { path = path ; type = type ; value = if type == "lambda" else value ; } ] ;
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

                                            } ;
                                    modules =
                                        {
                                            user = user ;
                                        } ;
                                } ;
            } ;
}
