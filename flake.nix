# 7465649313643859
{
    inputs = { } ;
    outputs =
        { self } :
            {
                lib =
                    {
                        fixture ,
                        nixpkgs ,
                        private ,
                        resource ,
                        system ,
                        visitor
                    } @primary :
                        let
                            _resource =
                                resource.lib
                                    {
                                        buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                        coreutils = pkgs.coreutils ;
                                        findutils = pkgs.findutils ;
                                        invalid-init-channel = "invalid-init" ;
                                        invalid-release-channel = "invalid-release" ;
                                        flock = pkgs.flock ;
                                        gnused = pkgs.gnused ;
                                        mkDerivation = pkgs.stdenv.mkDerivation ;
                                        jq = pkgs.jq ;
                                        redis = pkgs.redis ;
                                        valid-init-channel = "valid-init" ;
                                        valid-release-channel = "valid-release" ;
                                        visitor = _visitor.implementation ;
                                        writeShellApplication = pkgs.writeShellApplication ;
                                    } ;
                            _visitor = visitor.lib { } ;
                            implementation =
                                { config , lib , pkgs , ... } :
                                    let
                                        __resource =
                                            _resource.implementation
                                                {
                                                    gc-roots-directory = "/home/${ config.personal.name }/.gc-roots" ;
                                                    resources-directory = "/home/${ config.personal.name }/resources" ;
                                                } ;
                                        identity =
                                            pkgs.stdenv.mkDerivation
                                                {
                                                    installPhase = "execute-install $out" ;
                                                    name = "identity" ;
                                                    nativeBuildInputs =
                                                        [
                                                            (
                                                                pkgs.writeShellApplication
                                                                    {
                                                                        name = "execute-install" ;
                                                                        runtimeInputs = [ pkgs.openssh ] ;
                                                                        text =
                                                                            ''
                                                                                OUT="$1"
                                                                                mkdir --parents "$OUT"
                                                                                ssh-keygen -f "$OUT/identity" -P "" -C "nixos store key"
                                                                            '' ;
                                                                    }
                                                            )
                                                        ] ;
                                                    src = ./. ;
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
                                        resources =
                                            pkgs.stdenv.mkDerivation
                                                {
                                                    installPhase = ''resources "$out"'' ;
                                                    name = "resources" ;
                                                    nativeBuildInputs =
                                                        [
                                                            (
                                                                pkgs.writeShellApplication
                                                                    {
                                                                        name = "resources" ;
                                                                        runtimeInputs =
                                                                            [
                                                                            ] ;
                                                                        text =
                                                                            let
                                                                                clean =
                                                                                    [
                                                                                        ''
                                                                                            mkdir --parents "$1"
                                                                                        ''
                                                                                        ''
                                                                                            ln --symbolic ${ __resource.clean } "$1/clean.sh"
                                                                                        ''
                                                                                    ] ;
                                                                                release =
                                                                                    [
                                                                                        ''
                                                                                            mkdir --parents "$1"
                                                                                        ''
                                                                                        ''
                                                                                            ln --symbolic ${ __resource.release } "$1/release.sh"
                                                                                        ''
                                                                                    ] ;
                                                                                resources =
                                                                                    _visitor.implementation
                                                                                        {
                                                                                            lambda =
                                                                                                path : value :
                                                                                                    [
                                                                                                        ''
                                                                                                            mkdir --parents "$1/resources"
                                                                                                        ''
                                                                                                        (
                                                                                                            ''
                                                                                                                ln --symbolic ${ __resource.resource ( { seed = path ; } // ( value null ) ) } "$1"/resources/'${ builtins.toJSON path }'
                                                                                                            ''
                                                                                                        )
                                                                                                    ] ;
                                                                                            list = path : list : builtins.concatLists list ;
                                                                                            set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                        }
                                                                                        {
                                                                                            checks =
                                                                                                {
                                                                                                    true =
                                                                                                        {
                                                                                                            true =
                                                                                                                ignore :
                                                                                                                    {
                                                                                                                        error = 134 ;
                                                                                                                        init =
                                                                                                                            ignore :
                                                                                                                                {
                                                                                                                                    action =
                                                                                                                                        ignore :
                                                                                                                                            {
                                                                                                                                                targetPkgs = pkgs : [ pkgs.coreutils pkgs.psmisc ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        echo 4819688586897478
                                                                                                                                                        touch 1968976268514822
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                } ;
                                                                                                                        release =
                                                                                                                            ignore :
                                                                                                                                {
                                                                                                                                    action =
                                                                                                                                        ignore :
                                                                                                                                            {
                                                                                                                                                targetPkgs = pkgs : [ pkgs.coreutils ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        echo 2679141487527185
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                } ;
                                                                                                                        targets = [ "1968976268514822" ] ;
                                                                                                                        temporary = false ;
                                                                                                                    } ;
                                                                                                        } ;
                                                                                                } ;
                                                                                            production =
                                                                                                {
                                                                                                    secrets =
                                                                                                        {
                                                                                                            ciphertext =
                                                                                                                ignore :
                                                                                                                    {
                                                                                                                        error = 107 ;
                                                                                                                        init =
                                                                                                                            ignore :
                                                                                                                                {
                                                                                                                                    action =
                                                                                                                                        ignore :
                                                                                                                                            {
                                                                                                                                                targetPkgs = pkgs : [ pkgs.git ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        git init 2> /scratch/init
                                                                                                                                                        git remote add https ${ config.personal.secrets.remotes.https }
                                                                                                                                                        git remote add ssh ${ config.personal.secrets.remotes.ssh }
                                                                                                                                                        git fetch https ${ config.personal.secrets.branch } 2> /scratch/fetch
                                                                                                                                                        git checkout https/${ config.personal.secrets.branch } 2> /scratch/checkout
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                } ;
                                                                                                                        release =
                                                                                                                            ignore :
                                                                                                                                {
                                                                                                                                    action =
                                                                                                                                        ignore :
                                                                                                                                            {
                                                                                                                                                targetPkgs = pkgs : [ ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                } ;
                                                                                                                        targets = [ ".git" "dot-gnupg" "dot-ssh" "github" ] ;
                                                                                                                        # targets = [ ".git" ] ;
                                                                                                                        temporary = false ;
                                                                                                                    } ;
                                                                                                            plaintext =
                                                                                                                let
                                                                                                                    in
                                                                                                                        {
                                                                                                                            dot-gnupg =
                                                                                                                                {
                                                                                                                                    secret-keys = { } ;
                                                                                                                                    ownertrust = { } ;
                                                                                                                                } ;
                                                                                                                            dot-ssh =
                                                                                                                                {
                                                                                                                                    github =
                                                                                                                                        {
                                                                                                                                            identity = { } ;
                                                                                                                                            known-hosts = { } ;
                                                                                                                                        } ;
                                                                                                                                    mobile =
                                                                                                                                        {
                                                                                                                                            identity = { } ;
                                                                                                                                            known-hosts = { } ;
                                                                                                                                        } ;
                                                                                                                                } ;
                                                                                                                            github = { } ;
                                                                                                                        } ;
                                                                                                        } ;
                                                                                                } ;
                                                                                        } ;
                                                                                in builtins.concatStringsSep "\n" ( builtins.concatLists [ clean release resources ] ) ;
                                                                    }
                                                            )
                                                        ] ;
                                                    src = ./. ;
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
                                                        environment =
                                                            {
                                                                sessionVariables =
                                                                    {
                                                                        RESOURCES = "${ builtins.toString resources }" ;
                                                                        IS_NIX_FLAKE_CHECK= "false" ;
                                                                    } ;
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
                                                                # interfaces.wlp0s20f3.ipv4.addresses = [ { address = "192.168.0.105" ; prefixLength = 24 ; } ] ;
                                                                # interfaces.wlp0s20f3.ipv4.addresses = [ ] ;
                                                                wireless =
                                                                    {
                                                                        enable = true ;
                                                                        networks = config.personal.wifi ;
                                                                    } ;
                                                            } ;
                                                        nix =
                                                            {
                                                                gc =
                                                                    {
                                                                        automatic = true ;
                                                                        dates = "weekly" ;
                                                                        options = "--delete-older-than 35d" ;
                                                                    } ;
                                                                nixPath =
                                                                    [
                                                                        "nixpkgs=https://github.com/NixOS/nixpkgs/archive/b6bbc53029a31f788ffed9ea2d459f0bb0f0fbfc.tar.gz"
                                                                        "nixos-config=/etc/nixos/configuration.nix"
                                                                        "/nix/var/nix/profiles/per-user/root/channels"
                                                                    ] ;
                                                                optimise.automatic = true ;
                                                                settings.experimental-features = [ "nix-command" "flakes" ] ;
                                                            } ;
                                                        programs =
                                                            {
                                                                bash =
                                                                    {
                                                                        enableCompletion = true ;
                                                                        interactiveShellInit =
                                                                            let
                                                                                mapper =
                                                                                    name : value :
                                                                                        ''
                                                                                            /home/${ config.personal.name }/pad/${ name })
                                                                                        '' ;
                                                                                in
                                                                                    ''
                                                                                        eval "$( ${ pkgs.direnv }/bin/direnv hook bash )"
                                                                                    '' ;
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
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ password-less-core pkgs.nix "nix-collect-garbage" }/bin/nix-collect-garbage
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ password-less-core pkgs.nixos-rebuild "nixos-rebuild" }/bin/nixos-rebuild
                                                                    '' ;
                                                            } ;
                                                        services =
                                                            {
                                                                atd.enable = true ;
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
                                                                                            runtimeInputs = [ pkgs.btrfs-progs pkgs.coreutils pkgs.mount pkgs.util-linux ] ;
                                                                                            text  =
                                                                                                ''
                                                                                                    if [ ! -e /tmp/fake-btrfs.img ]
                                                                                                    then
                                                                                                        echo "Creating temporary Btrfs image for VM..."
                                                                                                        truncate -s 1G /tmp/fake-btrfs.img
                                                                                                        mkfs.btrfs /tmp/fake-btrfs.img
                                                                                                        mkdir --parents /home/${ config.personal.name }/resources
                                                                                                        chown -R ${ config.personal.name } /home/${ config.personal.name }/resources
                                                                                                        mount -o subvol=resources /tmp/fake-btrfs.img /home/${ config.personal.name }/resources
                                                                                                    fi
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/activation" ;
                                                                    } ;
                                                                stateVersion = "23.05" ;
                                                            } ;
                                                        systemd =
                                                            {
                                                                services =
                                                                    {
                                                                        log =
                                                                            {
                                                                                wantedBy = [ "multi-user.target" ];
                                                                                after = [ "network.target" ];
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart = __resource.log ;
                                                                                        Restart = "always";
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                            } ;
                                                                        release =
                                                                            {
                                                                                wantedBy = [ "multi-user.target" ];
                                                                                after = [ "network.target" ];
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart = __resource.release ;
                                                                                        Restart = "always";
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                            } ;
                                                                    } ;
                                                                timers =
                                                                    {
                                                                    } ;
                                                            } ;
                                                        time.timeZone = "America/New_York" ;
                                                        users.users.user =
                                                            {
                                                                description = config.personal.description ;
                                                                extraGroups = [ "wheel" ] ;
                                                                isNormalUser = true ;
                                                                name = config.personal.name ;
                                                                openssh =
                                                                    {
                                                                        authorizedKeys =
                                                                            {
                                                                                keyFiles = [ "${ identity }/identity.pub" ] ;
                                                                            } ;
                                                                    } ;
                                                                packages =
                                                                    [
                                                                        pkgs.age
                                                                        pkgs.gh
                                                                        pkgs.git
                                                                        pkgs.redis
                                                                        pkgs.yq-go
                                                                        pkgs.jq
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
                                                                channel = lib.mkOption { default = "redis" ; type = lib.types.str ; } ;
                                                                chromium =
                                                                    {
                                                                        home =
                                                                            {
                                                                                config =
                                                                                    {
                                                                                        branch = lib.mkOption { default = "550263ebac4ad73472a99fdb9d9a9cc61e7ef2842d5edd586055cf877f4f1405" ; type = lib.types.str ; } ;
                                                                                        email = lib.mkOption { default = "E.20260109124809@local" ; type = lib.types.str ; } ;
                                                                                        name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                        organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                        repository = lib.mkOption { default = "170c48bfd29d9625" ; type = lib.types.str ; } ;
                                                                                    } ;
                                                                                data =
                                                                                    {
                                                                                        branch = lib.mkOption { default = "2897539d1c3aeab568e6348d480b6348ef8b55f9cbe105c6ab355aee48510892" ; type = lib.types.str ; } ;
                                                                                        email = lib.mkOption { default = "E.20260109124809@local" ; type = lib.types.str ; } ;
                                                                                        name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                        organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                        repository = lib.mkOption { default = "ec59af155460eb89" ; type = lib.types.str ; } ;
                                                                                    } ;
                                                                            } ;
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
                                                                mobile =
                                                                    {
                                                                        ip = lib.mkOption { default = "192.168.1.192" ; type = lib.types.str ; } ;
                                                                        port = lib.mkOption { default = 8022 ; type = lib.types.int ; } ;
                                                                    } ;
                                                                name = lib.mkOption { type = lib.types.str ; } ;
                                                                pass =
                                                                    {
                                                                        branch = lib.mkOption { default = "scratch/8060776f-fa8d-443e-9902-118cf4634d9e" ; type = lib.types.str ; } ;
                                                                        character-set = lib.mkOption { default = ".,_=2345ABCDEFGHJKLMabcdefghjkmn" ; type = lib.types.str ; } ;
                                                                        character-set-no-symbols = lib.mkOption { default = "6789NPQRSTUVWXYZpqrstuvwxyz" ; type = lib.types.str ; } ;
                                                                        deadline = lib.mkOption { default = 60 * 60 * 24 * 366 ; type = lib.types.int ; } ;
                                                                        name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                        email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                        generated-length = lib.mkOption { default = 25 ; type = lib.types.int ; } ;
                                                                        remote = lib.mkOption { default = "git@github.com:nextmoose/secrets.git" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                password = lib.mkOption { type = lib.types.str ; } ;
                                                                repository =
                                                                    {
                                                                        dot-gnupg =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "dot-gnupg" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        dot-ssh =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "dot-ssh" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        failure =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "failure" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        git-repository =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "git-repository" ; type = lib.types.str ; } ;
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
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/personal.git" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "personal" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        private =
                                                                            {
                                                                                alternate = lib.mkOption { default = "laptop:private.git" ; type = lib.types.str ; } ;
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "mobile:private" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        resource =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "resource" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                        secret =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "secret" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        secrets =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "secret" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/12e5389b-8894-4de5-9cd2-7dab0678d22b" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                        string =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "string" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        visitor =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "visitor" ; type = lib.types.str ; } ;
                                                                           } ;
                                                                    } ;
                                                                secrets =
                                                                    {
                                                                        email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                        name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                        organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                        remotes =
                                                                            {
                                                                                https = lib.mkOption { default = "https://github.com/AFnRFCb7/9ebf9ebc.git" ; type = lib.types.str ; } ;
                                                                                ssh = lib.mkOption { default = "git@github.com:AFnRFCb7/9ebf9ebc.git" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        repository = lib.mkOption { default = "9ebf9ebc" ; type = lib.types.str ; } ;
                                                                        branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                temporary =
                                                                    {
                                                                        ssh =
                                                                            {
                                                                                identity = lib.mkOption { type = lib.types.path ; } ;
                                                                                known-hosts = lib.mkOption { type = lib.types.path ; } ;
                                                                            } ;
                                                                    } ;
                                                                volume =
                                                                    {
                                                                        email = lib.mkOption { default = "E.20260109124809@local" ; type = lib.types.str ; } ;
                                                                        name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                        organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                        repository = lib.mkOption { default = "1541f8f188b69533c612196a1884dfa074bdf60c3fdafc52bcb8a254951c7944" ; type = lib.types.str ; } ;
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
                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                    in
                        {
                            checks =
                                private :
                                    {
                                        experimental =
                                            pkgs.nixosTest
                                                {
                                                    name = "experimental" ;
                                                nodes =
                                                    let
                                                        routerAlternativeExternalIp = "192.168.2.234";
                                                        withFirewall = false ;
                                                        nftables = false ;
                                                        makeNginxConfig = hostname: {
                                                          enable = true;
                                                          virtualHosts."${hostname}" = {
                                                            root = "/etc";
                                                            locations."/".index = "hostname";
                                                            listen = [
                                                              {
                                                                addr = "0.0.0.0";
                                                                port = 80;
                                                              }
                                                              {
                                                                addr = "0.0.0.0";
                                                                port = 8080;
                                                              }
                                                            ];
                                                          };
                                                        };
                                                    makeCommonConfig = hostname: {
                                                      services.nginx = makeNginxConfig hostname;
                                                      services.vsftpd = {
                                                        enable = true;
                                                        anonymousUser = true;
                                                        localRoot = "/etc/";
                                                        extraConfig = ''
                                                          pasv_min_port=51000
                                                          pasv_max_port=51999
                                                        '';
                                                      };

                                                      # Disable eth0 autoconfiguration
                                                      networking.useDHCP = false;

                                                      environment.systemPackages = [
                                                        (pkgs.writeScriptBin "check-connection" ''
                                                          #!/usr/bin/env bash

                                                          set -e

                                                          if [[ "$2" == "" || "$3" == "" || "$1" == "--help" || "$1" == "-h" ]];
                                                          then
                                                              echo "check-connection <target-address> <target-hostname> <[expect-success|expect-failure]>"
                                                              exit 1
                                                          fi

                                                          ADDRESS="$1"
                                                          HOSTNAME="$2"

                                                          function test_icmp() { timeout 3 ping -c 1 $ADDRESS; }
                                                          function test_http() { [[ `timeout 3 curl $ADDRESS` == "$HOSTNAME" ]]; }
                                                          function test_ftp() { timeout 3 curl ftp://$ADDRESS; }

                                                          if [[ "$3" == "expect-success" ]];
                                                          then
                                                              test_icmp; test_http; test_ftp
                                                          else
                                                              ! test_icmp; ! test_http; ! test_ftp
                                                          fi
                                                        '')
                                                        (pkgs.writeScriptBin "check-last-clients-ip" ''
                                                          #!/usr/bin/env bash
                                                          set -e

                                                          [[ `cat /var/log/nginx/access.log | tail -n1 | awk '{print $1}'` == "$1" ]]
                                                        '')
                                                      ];
                                                    };
                                                    in
                                                        {
                                                            client =
                                                                { _class , config , lib , modulesPath , nodes , options, specialArgs }  :
                                                                    {
                                                                        networking =
                                                                            {
                                                                                defaultGateway =
                                                                                    let
                                                                                        router = pkgs.lib.head nodes.router.networking.interfaces.eth1.ipv4.addresses ;
                                                                                        in router.address ;
                                                                                useDHCP = false ;
                                                                            } ;
                                                                        virtualisation.vlans = [ 1 ] ;
                                                                    } ;
                                                            router =
                                                                { nodes , ... } :
                                                                    {
                                                                        networking =
                                                                            {
                                                                                interfaces.eth2.ipv4.addresses =
                                                                                    [
                                                                                        {
                                                                                            address = "192.168.2.234" ;
                                                                                            prefixLength = 24 ;
                                                                                        }
                                                                                    ];
                                                                                useDHCP = false ;
                                                                            } ;
                                                                        virtualisation.vlans = [ 1 2 ] ;
                                                                    } ;
                                                        } ;
                                                        skipLint = true ;
                                                        testScript =
                                                            ''
                                                                router.wait_for_unit("network-online.target")
                                                                router.succeed("ifconfig")
                                                                router.fail("true")
                                                            '' ;
                                                    } ;
#                                        happy =
#                                            _resource.check
#                                                {
#                                                    actions =
#                                                        let
#                                                            __resource =
#                                                                _resource.implementation
#                                                                    {
#                                                                        gc-roots-directory = "/home/checker/.gc-roots" ;
#                                                                        resources-directory = "/home/checker/resources" ;
#                                                                    } ;
#                                                            double-quote = ''"'' ;
#                                                            single-quote = "'" ;
#                                                            in
#                                                                [
#                                                                    { process = "pre" ; text = ''check-executable "$RESOURCES/clean.sh"'' ; }
#                                                                    { process = "pre" ; text = ''"$RESOURCES/clean.sh"'' ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        text =
#                                                                            ''
#                                                                                check-executable "$RESOURCES"/resources/'["checks","true","true"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        expected-standard-output = "/home/checker/resources/mounts/0000000000000000" ;
#                                                                        process = "pre" ;
#                                                                        text =
#                                                                            ''
#                                                                                # shellcheck disable=SC2288
#
#                                                                                "$RESOURCES"/resources/'["checks","true","true"]' 9416174984176284
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        text =
#                                                                            ''
#                                                                                jq \
#                                                                                    --null-input \
#                                                                                    '{
#                                                                                        "arguments" : [ "9416174984176284" ] ,
#                                                                                        "index" : "0000000000000000" ,
#                                                                                        "inputs" : { } ,
#                                                                                        "seed" :
#                                                                                            [
#                                                                                                {
#                                                                                                    "path" : [ 0 ] ,
#                                                                                                    "type" : "string" ,
#                                                                                                    "value" : "checks"
#                                                                                                } ,
#                                                                                                {
#                                                                                                    "path" : [ 1 ] ,
#                                                                                                    "type" : "string" ,
#                                                                                                    "value" : "true"
#                                                                                                } ,
#                                                                                                {
#                                                                                                    "path" : [ 2 ] ,
#                                                                                                    "type" : "string" ,
#                                                                                                    "value" : "true"
#                                                                                                }
#                                                                                            ] ,
#                                                                                        "standard-output" : "4819688586897478\n" ,
#                                                                                        "targets" : [ "1968976268514822" ] ,
#                                                                                        "text" : "echo 4819688586897478\ntouch 1968976268514822\n" ,
#                                                                                        "temporary" : false
#                                                                                    }' > "$SCRATCH/cleaned.json"
#                                                                            '' ;
#                                                                    }
#                                                                    { process = "pre" ; text = ''check-redis-message message valid-init "$SCRATCH/cleaned.json" object'' ; }
#                                                                    { process = "pre" ; text = "check-redis-block" ; uuid = "4123733772938815" ;}
##                                                                    ### THIS IS WRONG
#                                                                    {
#                                                                        process = "post" ;
#                                                                        text =
#                                                                            ''
#                                                                                jq \
#                                                                                    --null-input \
#                                                                                    '{
#                                                                                        "standard-output" : "2679141487527185" ,
#                                                                                        "status" : 0
#                                                                                    }' > "$SCRATCH/post.json"
#                                                                            '' ;
#                                                                    }
#                                                                    { process = "post" ; text = ''check-redis-message message valid-release "$SCRATCH/post.json" object'' ; uuid = "3177289165823618" ; }
#                                                                    { process = "post" ; text = ''check-executable "$RESOURCES/clean.sh"'' ; }
#                                                                    { process = "post" ; text = ''"$RESOURCES/clean.sh"'' ; }
#                                                                ] ;
#                                                    gc-roots-directory = "/home/checker/.gc-roots" ;
#                                                    machines = { } ;
#                                                    nixosTest = pkgs.nixosTest ;
#                                                    pkgs = pkgs ;
#                                                    private = private ;
#                                                    resources-directory = "/home/checker/resources" ;
#                                                    user = "checker" ;
#                                                } ;
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
                                                                    recur =
                                                                        {
                                                                            int =
                                                                                [
                                                                                    {
                                                                                        path = [ "set" "recur" "int" ] ;
                                                                                        type = "int" ;
                                                                                        value = 1 ;
                                                                                    }
                                                                                ] ;
                                                                            lambda =
                                                                                [
                                                                                    {
                                                                                        path = [ "set" "recur" "lambda" ] ;
                                                                                        type = "lambda" ;
                                                                                        value = null ;
                                                                                    }
                                                                                ] ;
                                                                        } ;
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
                                                            set = { one = 1 ; recur = { int = 1 ; lambda = i : i ; } ; } ;
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
                                        visitor-set =
                                            _visitor.check
                                                {
                                                    coreutils = pkgs.coreutils ;
                                                    diffutil = pkgs.diffutil ;
                                                    expected = [ "bool,float,int,lambda,list,null,path,set,string" ] ;
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
                                                            set = { one = 1 ; recur = { int = 1 ; lambda = i : i ; } ; } ;
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
                                                                    set = path : set : [ ( builtins.concatStringsSep "," ( builtins.attrNames set ) ) ] ;
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
                                    implementation = implementation ;
                                } ;
            } ;
}
