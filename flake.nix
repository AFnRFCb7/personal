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
                                        log-channel = "log" ;
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
                                                                                                                ln --symbolic ${ __resource.resource ( { resources = ''"$RESORCES"'' ; seed = path ; } // ( value null ) ) } "$1"/resources/'${ builtins.toJSON path }'
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
                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils pkgs.psmisc ] ;
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
                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils ] ;
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
                                                                                                    dot-ssh =
                                                                                                        {
                                                                                                             config =
                                                                                                                {
                                                                                                                    github =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                error = 101 ;
                                                                                                                                init =
                                                                                                                                    ignore :
                                                                                                                                        {
                                                                                                                                            action =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        targetPkgs =
                                                                                                                                                            { pkgs , resources , ... } :
                                                                                                                                                                [
                                                                                                                                                                    (
                                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                                            {
                                                                                                                                                                                name = "config" ;
                                                                                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                                                                                text =
                                                                                                                                                                                    ''
                                                                                                                                                                                        # shellcheck disable=SC2288
                                                                                                                                                                                        KNOWN_HOSTS="$( "$RESOURCES"/resources/'["production","dot-ssh","known-hosts","github"]' )"
                                                                                                                                                                                        ln --symbolic "$KNOWN_HOSTS" /gc-root/known-hosts
                                                                                                                                                                                        # KLUDGE FOR TESTING
                                                                                                                                                                                        sleep 1s
                                                                                                                                                                                        # shellcheck disable=SC2288
                                                                                                                                                                                        IDENTITY="$( "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]' )"
                                                                                                                                                                                        ln --symbolic "$IDENTITY" /gc-root/identity
                                                                                                                                                                                        cat > config <<EOF
                                                                                                                                                                                        HostName github.com
                                                                                                                                                                                        Host github.com
                                                                                                                                                                                        User git
                                                                                                                                                                                        IdentityFile $IDENTITY
                                                                                                                                                                                        UserKnownHostsFile $KNOWN_HOSTS
                                                                                                                                                                                        StrictHostKeyChecking yes
                                                                                                                                                                                        EOF
                                                                                                                                                                                        chmod 0400 config
                                                                                                                                                                                    '' ;
                                                                                                                                                                            }
                                                                                                                                                                    )
                                                                                                                                                                ] ;
                                                                                                                                                        text = "config" ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                release =
                                                                                                                                    ignore :
                                                                                                                                        {
                                                                                                                                            action =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        targetPkgs = { pkgs , ... } : [ ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                targets = [ "config" ] ;
                                                                                                                                temporary = false ;
                                                                                                                            } ;
                                                                                                                } ;
                                                                                                             known-hosts =
                                                                                                                {
                                                                                                                    github =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                error = 168 ;
                                                                                                                                init =
                                                                                                                                    ignore :
                                                                                                                                        {
                                                                                                                                            action =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        targetPkgs =
                                                                                                                                                            { pkgs , ... } :
                                                                                                                                                                [
                                                                                                                                                                    (
                                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                                            {
                                                                                                                                                                                name = "known-hosts" ;
                                                                                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                                                                                text =
                                                                                                                                                                                    ''
                                                                                                                                                                                        cat ${ config.personal.temporary.ssh.known-hosts } > "known-hosts"
                                                                                                                                                                                        chmod 0400 "known-hosts"
                                                                                                                                                                                    '' ;
                                                                                                                                                                            }
                                                                                                                                                                    )
                                                                                                                                                                ] ;
                                                                                                                                                        text = "known-hosts" ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                release =
                                                                                                                                    ignore :
                                                                                                                                        {
                                                                                                                                            action =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        targetPkgs = { pkgs , ... } : [ ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                targets = [ "known-hosts" ] ;
                                                                                                                                temporary = false ;
                                                                                                                            } ;
                                                                                                                } ;
                                                                                                            identity =
                                                                                                                {
                                                                                                                    github =
                                                                                                                        ignore :
                                                                                                                            {
                                                                                                                                error = 140 ;
                                                                                                                                init =
                                                                                                                                    ignore :
                                                                                                                                        {
                                                                                                                                            action =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        targetPkgs =
                                                                                                                                                            { pkgs , ... } :
                                                                                                                                                                [
                                                                                                                                                                    (
                                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                                            {
                                                                                                                                                                                name = "identity" ;
                                                                                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                                                                                text =
                                                                                                                                                                                    ''
                                                                                                                                                                                        cat ${ config.personal.temporary.ssh.identity } > "identity"
                                                                                                                                                                                        chmod 0400 "identity"
                                                                                                                                                                                    '' ;
                                                                                                                                                                            }
                                                                                                                                                                    )
                                                                                                                                                                ] ;
                                                                                                                                                        text = "identity" ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                release =
                                                                                                                                    ignore :
                                                                                                                                        {
                                                                                                                                            action =
                                                                                                                                                ignore :
                                                                                                                                                    {
                                                                                                                                                        targetPkgs = { pkgs , ... } : [ ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                        } ;
                                                                                                                                targets = [ "identity" ] ;
                                                                                                                                temporary = false ;
                                                                                                                            } ;
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
                                                                                after = [ "network.target" "redis.service" ];
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart = __resource.log ;
                                                                                        Restart = "always";
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ];
                                                                            } ;
                                                                        release =
                                                                            {
                                                                                after = [ "network.target" "redis.service" ];
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart = __resource.release ;
                                                                                        Restart = "always";
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ];
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
                                    let
                                        client =
                                            { nodes , ... }  :
                                                {
                                                    imports = private ;
                                                    networking =
                                                        {
                                                            defaultGateway =
                                                                let
                                                                    router = pkgs.lib.head nodes.github.networking.interfaces.eth1.ipv4.addresses ;
                                                                    in router.address ;
                                                            useDHCP = false ;
                                                        } ;
                                                    personal =
                                                        {
                                                            agenix = "${ shared }/age" ;
                                                            description = "Chester Checker" ;
                                                            email = "chester@checker.com" ;
                                                            name = "checker" ;
                                                            password = "chester" ;
                                                            temporary =
                                                                {
                                                                    ssh =
                                                                        {
                                                                            identity = "${ shared }/openssh/identity" ;
                                                                            known-hosts = "${ shared }/openssh/known-hosts" ;
                                                                        } ;
                                                                } ;
                                                            wifi = { } ;
                                                        } ;
                                                    virtualisation.vlans = [ 1 ] ;
                                                } ;
                                        github =
                                            { nodes , ... } :
                                                {
                                                    networking =
                                                        {
                                                            firewall.enable = false ;
                                                            interfaces.eth2.ipv4.addresses =
                                                                [
                                                                    {
                                                                        address = "192.168.2.234" ;
                                                                        prefixLength = 24 ;
                                                                    }
                                                                ];
                                                            useDHCP = false ;
                                                        } ;
                                                    services.openssh.enable = true ;
                                                    users.users.git =
                                                        {
                                                            isNormalUser = true ;
                                                            openssh.authorizedKeys = { keyFiles = [ "${ shared }/openssh/identity.pub" ] ; } ;
                                                        } ;
                                                    virtualisation.vlans = [ 1 2 ] ;
                                                } ;
                                        shared =
                                            pkgs.stdenv.mkDerivation
                                                {
                                                    installPhase =''install "$out"'' ;
                                                    name = "shared" ;
                                                    nativeBuildInputs =
                                                        [
                                                            (
                                                                pkgs.writeShellApplication
                                                                    {
                                                                        name = "install" ;
                                                                        runtimeInputs = [ pkgs.age pkgs.openssh ] ;
                                                                        text =
                                                                            ''
                                                                                OUT="$1"
                                                                                echo 1723258852938545 1627957233171753 mkdir --parents "$OUT" >&2
                                                                                mkdir --parents "$OUT"
                                                                                echo 1723258852938545 1734789156698614 >&2
                                                                                age-keygen -o "$OUT/age"
                                                                                echo 1723258852938545 5198592423423681 mkdir --parents "$OUT/openssh" >&2
                                                                                mkdir --parents "$OUT/openssh"
                                                                                cat ${ self }/checker/identity > "$OUT/openssh/identity"
                                                                                chmod 0400 "$OUT/openssh/identity"
                                                                                ssh-keygen -f "$OUT/openssh/identity" -y > "$OUT/openssh/identity.pub"
                                                                                chmod a+r "$OUT/openssh/identity"
                                                                                touch "$OUT/openssh/known-hosts"
                                                                            '' ;
                                                                    }
                                                            )
                                                        ] ;
                                                    src = ./. ;
                                                } ;
                                        in
                                            {
                                                "generic resource happy path" =
                                                    _resource.check2
                                                        {
                                                            actions =
                                                                [
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "pre"  ;
                                                                        standard-output =
                                                                            ''
                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                3abb6677af34ac57c0ca5828fd94f9d886c26ce59a8ce60ecf6778079423dccff1d6f19cb655805d56098e6d38a1a710dee59523eed7511e5a9e4b8ccb3a4686
                                                                            '' ;
                                                                        text = "check-redis subscribe invalid-init number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                63e22ec2fbeebabf005e58fbfb0eee607c4aa417045a68a0cc63767b048e3559268d35e72f367d3b2dbd5dbddf12fc4397762ba149260b3795a0391713bddcd7
                                                                            '' ;
                                                                        text = "check-redis subscribe invalid-release number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                2b59d179d9815994f687383a886ea34109889756efca5ab27318cc67ce2a21261d12fa6fee6b8c716f72214ead55ee0d789d6c35cff977d40ef5728ba9188a80
                                                                            '' ;
                                                                        text = "check-redis subscribe log number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                db545c410fd0c8ede533d5b0666cd2798ba380bd25b655619cd5fd3a33a255569b3ccc319bfdef3322d8392d894d15c2e6aa2d53346e6ac54eaf5d627bfe6a9a
                                                                            '' ;
                                                                            text = "check-redis subscribe valid-init number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                29b3573989378848e91465abb8bb12aaad1c40f01ddba6ce5dce4de88d61d49621cd4272bc6f889cd469e9490040b412eb0a237cf2cd49c637da1d5de5903f3d
                                                                            '' ;
                                                                        text = "check-redis subscribe valid-release number" ;
                                                                    }
                                                                    { process = "pre" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        text =
                                                                            ''
                                                                                check-executable "$RESOURCES"/resources/'["checks","true","true"]'
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        reads = false ;
                                                                        process = "pre" ;
                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
                                                                        text =
                                                                            ''
                                                                                # shellcheck disable=SC2288
                                                                                "$RESOURCES"/resources/'["checks","true","true"]'
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "pre"  ;
                                                                        standard-output =
                                                                            ''
                                                                                0b8897e768ec01c1a28d561c612f9803e5d58c883fabacc5c0280c3675b51550fa572ccc5be074b40f9586c7770e0fd908cf6e98b3069f75b2c752d93d28551c
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                7bd79c439ad21624d36b0fb505543eaca8cb76a19df297b1e4f4bb6bd7be538df8797cd140f1895bb789838d4a49450c4d13039a227fb74707576ec1d1b83cd9
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    { process = "pre" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                83f2a3882026a73185f5589d944c1116f6d10066959857757a4121169b26081757b68eb770688639d6002c2cbce996193e33502d70444f024fb665bcc26d1eab
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                    { kludge = true ; process = "post" ; text = "sleep 15s" ; }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "post"  ;
                                                                        standard-output =
                                                                            ''
                                                                                e080d45da797a0d3bfad48e045fb8569393d73ef99157fad371fabef307195d7f63da42912f6e12fe8a71658c75540b227f3b8d5ae8da8b347e5eb91cc676547
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                5fbf21bd53dec5148da75ba0530a4099d61a0a6b2f8dcbcd95dd3c829fbbedd60b8a9b63c9ef300710457689ef64c77a34288f394b3c51f2f9d2c5edd123fd18
                                                                            '' ;
                                                                        text = "check-redis message valid-release set" ;
                                                                    }
                                                                    { process = "post" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                c76deb7556f5960e0388547e064ab106ec038465b436d8e713f2d2d9c9290e97ca768da67649d6268c8a55e4634d415aeed1eb48f5c650ed853f723563f1f9a7
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        text =
                                                                            ''
                                                                                check-executable "$RESOURCES"/clean.sh
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        text =
                                                                            ''
                                                                                "$RESOURCES"/clean.sh
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "post"  ;
                                                                        standard-output =
                                                                            ''
                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    { process = "post" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                ] ;
                                                            gc-roots-directory = "/home/checker/.gc-roots" ;
                                                            nodes = { client = client ; github = github ; } ;
                                                            pkgs = pkgs ;
                                                            resources-directory = "/home/checker/resources" ;
                                                            tests =
                                                                action-derivation :
                                                                    [
                                                                        ''github.wait_for_unit("network-online.target")''
                                                                        ''client.wait_for_unit("network-online.target")''
                                                                        ''client.wait_for_unit("log.service")''
                                                                        ''client.wait_for_unit("release.service")''
                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute")''
                                                                    ] ;
                                                        } ;
                                                "resource happy path : bootstrap github config" =
                                                    _resource.check2
                                                        {
                                                            actions =
                                                                [
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "pre"  ;
                                                                        standard-output =
                                                                            ''
                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                3abb6677af34ac57c0ca5828fd94f9d886c26ce59a8ce60ecf6778079423dccff1d6f19cb655805d56098e6d38a1a710dee59523eed7511e5a9e4b8ccb3a4686
                                                                            '' ;
                                                                        text = "check-redis subscribe invalid-init number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                63e22ec2fbeebabf005e58fbfb0eee607c4aa417045a68a0cc63767b048e3559268d35e72f367d3b2dbd5dbddf12fc4397762ba149260b3795a0391713bddcd7
                                                                            '' ;
                                                                        text = "check-redis subscribe invalid-release number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                2b59d179d9815994f687383a886ea34109889756efca5ab27318cc67ce2a21261d12fa6fee6b8c716f72214ead55ee0d789d6c35cff977d40ef5728ba9188a80
                                                                            '' ;
                                                                        text = "check-redis subscribe log number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                db545c410fd0c8ede533d5b0666cd2798ba380bd25b655619cd5fd3a33a255569b3ccc319bfdef3322d8392d894d15c2e6aa2d53346e6ac54eaf5d627bfe6a9a
                                                                            '' ;
                                                                            text = "check-redis subscribe valid-init number" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                29b3573989378848e91465abb8bb12aaad1c40f01ddba6ce5dce4de88d61d49621cd4272bc6f889cd469e9490040b412eb0a237cf2cd49c637da1d5de5903f3d
                                                                            '' ;
                                                                        text = "check-redis subscribe valid-release number" ;
                                                                    }
                                                                    { process = "pre" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        text =
                                                                            ''
                                                                                check-executable "$RESOURCES"/resources/'["production","dot-ssh","config","github"]'
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        reads = false ;
                                                                        process = "pre" ;
                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
                                                                        text =
                                                                            ''
                                                                                # shellcheck disable=SC2288
                                                                                "$RESOURCES"/resources/'["production","dot-ssh","config","github"]'
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                4d2848684f1f1fa4cc83311a596b72a1314bf59a7b95c006a47ec39a52df87429a777be45e183da1e68197f7d115f08e7cc5a903c099880b13508b7fb19aeb13
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "pre"  ;
                                                                        standard-output =
                                                                            ''
                                                                                2695467bca240cf1a8bac663b4e4ea07c59e2b0c11854fecea11256d71715629003d1853136d0299ea92b47eefa38d4b3f49095c985296dd9a9a0418189f7d91
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                a84e0ccd3477378ead720c2b46f4c23398aa43de0b31b2bcfaafbf592103dacfa3d92661d8726710224e88d34e83fdbafa990f3187eb0d0abc61487d65abfc78
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                4356f74236aadd2b5522e0f7c64cee1232298e7b330fd61bc063d211d9571f5887a011991eebf92e5314166d55f20b282669a12f3a1a600afc8b92694aee4e51
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                6a8b0a64c20ee69fe5f85d2f1a1fd10fe962fc7d433bf72c189aa246dcb3e0bdc0069a709e7985b5b23942f743c42f2f639699ff95fbbf94313ea6b2aefd029f
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    { process = "pre" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                08a62f1df64e9a39354699b2e46fd8dff89e18267da811fb6a87a32a592b0dcd66d5d4e8ab4e531ce97bf32823667ef41ac9b7f2a7ba1098b8b48d02bb42008a
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                    { kludge = true ; process = "post" ; text = "sleep 5s" ; }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "post"  ;
                                                                        standard-output =
                                                                            ''
                                                                                98ce68ad0eb0a01eef2078b5d07808a1ecef9c50c81096be69e73f0f8e43d94b34d9b6395f921a47e26d43098fed9528bf4fbb24455870a6951002e43b6bec33
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                4da9e3339b48613167f63a29d2bade2d276c111f4550a1f9c7f105683bb591bf92bf2e9f9ab6c6710266ce57ca2dc4101c0a47e626e9be116bbd7507d3b839a7
                                                                            '' ;
                                                                        text = "check-redis message valid-release set" ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                28f1bfdb71bf4bc287ed21563cc420406cc35a210877142b90663ca8ea0c04a9ce64b7819b1d1cc36bfcacdfaa4936a89afcdd0cdf14088be5ff11b501ae1430
                                                                            '' ;
                                                                        text = "check-redis message valid-release set" ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                ba8fd424b3c4e20ce2745f988c95a1117c165a0ae9ade33e9398a6e2074d987c8667b7bc1389847f475eddc039a7c5e995d7f4b80ebd6a32552648dde868c3cf
                                                                            '' ;
                                                                        text = "check-redis message valid-release set" ;
                                                                    }
                                                                    { process = "post" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                13c2473e5f0d28031ddf1208ab9eae5f12cfa0c69ead0ae15841de41604b13c243f0c0360c7fefce378543c770c834cb2eca7bf1dad07f6c7f5b591d93ee69f7
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        text =
                                                                            ''
                                                                                check-executable "$RESOURCES"/clean.sh
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        text =
                                                                            ''
                                                                                "$RESOURCES"/clean.sh
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    {
                                                                        process = "post"  ;
                                                                        standard-output =
                                                                            ''
                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    { process = "post" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
                                                                            '';
                                                                        text = ''check-resources-directory'' ;
                                                                    }
                                                                ] ;
                                                            gc-roots-directory = "/home/checker/.gc-roots" ;
                                                            nodes = { github = github ; client = client ; } ;
                                                            pkgs = pkgs ;
                                                            resources-directory = "/home/checker/resources" ;
                                                            tests =
                                                                action-derivation :
                                                                    [
                                                                        ''client.wait_for_unit("network-online.target")''
                                                                        ''client.wait_for_unit("log.service")''
                                                                        ''client.wait_for_unit("release.service")''
                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute")''
                                                                    ] ;
                                                        } ;
#                                                "resource happy path : bootstrap github known hosts" =
#                                                    _resource.check2
#                                                        {
#                                                            actions =
#                                                                [
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                3abb6677af34ac57c0ca5828fd94f9d886c26ce59a8ce60ecf6778079423dccff1d6f19cb655805d56098e6d38a1a710dee59523eed7511e5a9e4b8ccb3a4686
#                                                                            '' ;
#                                                                        text = "check-redis subscribe invalid-init number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                63e22ec2fbeebabf005e58fbfb0eee607c4aa417045a68a0cc63767b048e3559268d35e72f367d3b2dbd5dbddf12fc4397762ba149260b3795a0391713bddcd7
#                                                                            '' ;
#                                                                        text = "check-redis subscribe invalid-release number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                2b59d179d9815994f687383a886ea34109889756efca5ab27318cc67ce2a21261d12fa6fee6b8c716f72214ead55ee0d789d6c35cff977d40ef5728ba9188a80
#                                                                            '' ;
#                                                                        text = "check-redis subscribe log number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                db545c410fd0c8ede533d5b0666cd2798ba380bd25b655619cd5fd3a33a255569b3ccc319bfdef3322d8392d894d15c2e6aa2d53346e6ac54eaf5d627bfe6a9a
#                                                                            '' ;
#                                                                            text = "check-redis subscribe valid-init number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                29b3573989378848e91465abb8bb12aaad1c40f01ddba6ce5dce4de88d61d49621cd4272bc6f889cd469e9490040b412eb0a237cf2cd49c637da1d5de5903f3d
#                                                                            '' ;
#                                                                        text = "check-redis subscribe valid-release number" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        text =
#                                                                            ''
#                                                                                check-executable "$RESOURCES"/resources/'["production","dot-ssh","known-hosts","github"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        reads = false ;
#                                                                        process = "pre" ;
#                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
#                                                                        text =
#                                                                            ''
#                                                                                # shellcheck disable=SC2288
#                                                                                "$RESOURCES"/resources/'["production","dot-ssh","known-hosts","github"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                0a1bd837e70e3f95672a069293d76a6e6d7420247a3b9f7369d862838ed29b400a79779819afa4bc77ccd2e000da424fdb873f167c1ce0321d21fa3e168a6e00
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                176c1dee8f5a13908ce0a88b652f0cc2c2c5b370297e23b69882443223d35cacabb218c8395f1ef47b2016ca0f10e789679e0132583ec1f3672139698928158f
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                244bdbbc645218c015b1ebaf159c25b6e7fad705e8aeac6e2ee18934fd7ec8ee42ee8d102208e8cf6ef9509fcde01c5a0a36b4058194288b206f8c4d2e56a4b3
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b205c607d559d8bc4bb6267db23fe2a44ee918774e8e2a4a245a56d268852e9dda0cf56c2e6a1209b8714f91d50514129a8cd2a49edd4007480f8c15c4a31da4
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                9e8a6508bf1186cfb482a018e73af6843b0f2bc5ba32f291e78eac4327785235197b8aae23d5544cf16206a458e595fd7f03647f8dd41901533531345034d6d2
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        text =
#                                                                            ''
#                                                                                check-executable "$RESOURCES"/clean.sh
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        text =
#                                                                            ''
#                                                                                "$RESOURCES"/clean.sh
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                ] ;
#                                                            gc-roots-directory = "/home/checker/.gc-roots" ;
#                                                            nodes = { github = github ; client = client ; } ;
#                                                            pkgs = pkgs ;
#                                                            resources-directory = "/home/checker/resources" ;
#                                                            tests =
#                                                                action-derivation :
#                                                                    [
#                                                                        ''client.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("log.service")''
#                                                                        ''client.wait_for_unit("release.service")''
#                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute")''
#                                                                    ] ;
#                                                        } ;
#                                                "resource happy path : bootstrap github identity" =
#                                                    _resource.check2
#                                                        {
#                                                            actions =
#                                                                [
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                3abb6677af34ac57c0ca5828fd94f9d886c26ce59a8ce60ecf6778079423dccff1d6f19cb655805d56098e6d38a1a710dee59523eed7511e5a9e4b8ccb3a4686
#                                                                            '' ;
#                                                                        text = "check-redis subscribe invalid-init number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                63e22ec2fbeebabf005e58fbfb0eee607c4aa417045a68a0cc63767b048e3559268d35e72f367d3b2dbd5dbddf12fc4397762ba149260b3795a0391713bddcd7
#                                                                            '' ;
#                                                                        text = "check-redis subscribe invalid-release number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                2b59d179d9815994f687383a886ea34109889756efca5ab27318cc67ce2a21261d12fa6fee6b8c716f72214ead55ee0d789d6c35cff977d40ef5728ba9188a80
#                                                                            '' ;
#                                                                        text = "check-redis subscribe log number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                db545c410fd0c8ede533d5b0666cd2798ba380bd25b655619cd5fd3a33a255569b3ccc319bfdef3322d8392d894d15c2e6aa2d53346e6ac54eaf5d627bfe6a9a
#                                                                            '' ;
#                                                                            text = "check-redis subscribe valid-init number" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                29b3573989378848e91465abb8bb12aaad1c40f01ddba6ce5dce4de88d61d49621cd4272bc6f889cd469e9490040b412eb0a237cf2cd49c637da1d5de5903f3d
#                                                                            '' ;
#                                                                        text = "check-redis subscribe valid-release number" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        text =
#                                                                            ''
#                                                                                check-executable "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        reads = false ;
#                                                                        process = "pre" ;
#                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
#                                                                        text =
#                                                                            ''
#                                                                                # shellcheck disable=SC2288
#                                                                                "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                d1cdc71f6010c13c073a18ea45e4d88edff0dafbc2592f1e04ef6fe29c986f02c153a91047d4954133909d932e8176ac41503a5e95eb905efba098eb39589606
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                f262ee41682301adbeb5d035ef1b80c7139064d2648cb99b68cb8492ea277023d485d897e65ee3a0cde6876c57181942cb9c5796dbbe39e7f7125971624721be
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                c00a49559bf08e754ff97ecebc95366ecfc31c577cc3011b4301f145da983e0e6bff3b237a042fe69498dbb35dbe6c0522433ceaf49fcb9d497adf8b66d17c4f
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b205c607d559d8bc4bb6267db23fe2a44ee918774e8e2a4a245a56d268852e9dda0cf56c2e6a1209b8714f91d50514129a8cd2a49edd4007480f8c15c4a31da4
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                9e8a6508bf1186cfb482a018e73af6843b0f2bc5ba32f291e78eac4327785235197b8aae23d5544cf16206a458e595fd7f03647f8dd41901533531345034d6d2
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        text =
#                                                                            ''
#                                                                                check-executable "$RESOURCES"/clean.sh
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        text =
#                                                                            ''
#                                                                                "$RESOURCES"/clean.sh
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "post"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b7a9336ed3a424b5d4d59d9b20d0bbc33217207b584db6b758fddb9a70b99e7c8c9f8387ef318a6b2039e62f09a3a2592bf5c76d6947a6ea1d107b924d7461f4
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                ] ;
#                                                            gc-roots-directory = "/home/checker/.gc-roots" ;
#                                                            nodes = { github = github ; client = client ; } ;
#                                                            pkgs = pkgs ;
#                                                            resources-directory = "/home/checker/resources" ;
#                                                            tests =
#                                                                action-derivation :
#                                                                    [
#                                                                        ''client.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("log.service")''
#                                                                        ''client.wait_for_unit("release.service")''
#                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute")''
#                                                                    ] ;
#                                                        } ;
#                                                experimental =
#                                                    let
#                                                        pseudo-secrets =
#                                                            pkgs.stdenv.mkDerivation
#                                                                {
#                                                                    installPhase = ''install "$out"'' ;
#                                                                    name = "pseudo-ssecrets" ;
#                                                                    nativeBuildInputs =
#                                                                        [
#                                                                            (
#                                                                                pkgs.writeShellApplication
#                                                                                    {
#                                                                                        name = "install" ;
#                                                                                        runtimeInputs = [ pkgs.openssh ] ;
#                                                                                        text =
#                                                                                            ''
#                                                                                                OUT="$1"
#                                                                                                mkdir --parents "$OUT"
#                                                                                                ssh-keygen -P "" -C "" -f "$OUT/identity" ;
#                                                                                            '' ;
#                                                                                    }
#                                                                            )
#                                                                        ] ;
#                                                                    src = ./. ;
#                                                                } ;
#                                                        in
#                                                        pkgs.nixosTest
#                                                            {
#                                                                name = "experimental" ;
#                                                            nodes =
#                                                                let
#                                                                    routerAlternativeExternalIp = "192.168.2.234";
#                                                                    withFirewall = false ;
#                                                                    nftables = false ;
#                                                                    makeNginxConfig = hostname: {
#                                                                      enable = true;
#                                                                      virtualHosts."${hostname}" = {
#                                                                        root = "/etc";
#                                                                        locations."/".index = "hostname";
#                                                                        listen = [
#                                                                          {
#                                                                            addr = "0.0.0.0";
#                                                                            port = 80;
#                                                                          }
#                                                                          {
#                                                                            addr = "0.0.0.0";
#                                                                            port = 8080;
#                                                                          }
#                                                                        ];
#                                                                      };
#                                                                    };
#                                                                makeCommonConfig = hostname: {
#                                                                  services.nginx = makeNginxConfig hostname;
#                                                                  services.vsftpd = {
#                                                                    enable = true;
#                                                                    anonymousUser = true;
#                                                                    localRoot = "/etc/";
#                                                                    extraConfig = ''
#                                                                      pasv_min_port=51000
#                                                                      pasv_max_port=51999
#                                                                    '';
#                                                                  };
#
#                                                                  # Disable eth0 autoconfiguration
#                                                                  networking.useDHCP = false;
#
#                                                                  environment.systemPackages = [
#                                                                    (pkgs.writeScriptBin "check-connection" ''
#                                                                      #!/usr/bin/env bash
#
#                                                                      set -e
#
#                                                                      if [[ "$2" == "" || "$3" == "" || "$1" == "--help" || "$1" == "-h" ]];
#                                                                      then
#                                                                          echo "check-connection <target-address> <target-hostname> <[expect-success|expect-failure]>"
#                                                                          exit 1
#                                                                      fi
#
#                                                                      ADDRESS="$1"
#                                                                      HOSTNAME="$2"
#
#                                                                      function test_icmp() { timeout 3 ping -c 1 $ADDRESS; }
#                                                                      function test_http() { [[ `timeout 3 curl $ADDRESS` == "$HOSTNAME" ]]; }
#                                                                      function test_ftp() { timeout 3 curl ftp://$ADDRESS; }
#
#                                                                      if [[ "$3" == "expect-success" ]];
#                                                                      then
#                                                                          test_icmp; test_http; test_ftp
#                                                                      else
#                                                                          ! test_icmp; ! test_http; ! test_ftp
#                                                                      fi
#                                                                    '')
#                                                                    (pkgs.writeScriptBin "check-last-clients-ip" ''
#                                                                      #!/usr/bin/env bash
#                                                                      set -e
#
#                                                                      [[ `cat /var/log/nginx/access.log | tail -n1 | awk '{print $1}'` == "$1" ]]
#                                                                    '')
#                                                                  ];
#                                                                };
#                                                                in
#                                                                    {
#                                                                        client =
#                                                                            { _class , config , lib , modulesPath , nodes , options, specialArgs }  :
#                                                                                {
#                                                                                    networking =
#                                                                                        {
#                                                                                            defaultGateway =
#                                                                                                let
#                                                                                                    router = pkgs.lib.head nodes.router.networking.interfaces.eth1.ipv4.addresses ;
#                                                                                                    in router.address ;
#                                                                                            useDHCP = false ;
#                                                                                        } ;
#                                                                                    virtualisation.vlans = [ 1 ] ;
#                                                                                } ;
#                                                                        router =
#                                                                            { nodes , ... } :
#                                                                                {
#                                                                                    networking =
#                                                                                        {
#                                                                                            firewall.enable = false ;
#                                                                                            interfaces.eth2.ipv4.addresses =
#                                                                                                [
#                                                                                                    {
#                                                                                                        address = "192.168.2.234" ;
#                                                                                                        prefixLength = 24 ;
#                                                                                                    }
#                                                                                                ];
#                                                                                            useDHCP = false ;
#                                                                                        } ;
#                                                                                    services.openssh.enable = true ;
#                                                                                    users.users.git =
#                                                                                        {
#                                                                                            description = "GITHUB" ;
#                                                                                            isNormalUser = true ;
#                                                                                            openssh.authorizedKeys = { keyFiles = [ "${ pseudo-secrets }/identity.pub" ] ; } ;
#                                                                                            packages =
#                                                                                                [
#                                                                                                    (
#                                                                                                        pkgs.writeShellApplication
#                                                                                                            {
#                                                                                                                name = "verify-it-works" ;
#                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
#                                                                                                                text =
#                                                                                                                    ''
#                                                                                                                        echo 2847967298513228
#                                                                                                                    '' ;
#                                                                                                            }
#                                                                                                    )
#                                                                                                ] ;
#                                                                                        } ;
#                                                                                    virtualisation.vlans = [ 1 2 ] ;
#                                                                                } ;
#                                                                    } ;
#                                                                    skipLint = true ;
#                                                                    testScript =
#                                                                        ''
#                                                                            # router 192.168.1.2 192.168.2.234
#                                                                            router.wait_for_unit("network-online.target")
#                                                                            router.succeed("ifconfig >&2")
#                                                                            # client 192.168.1.1
#                                                                            client.wait_for_unit("network-online.target")
#                                                                            client.succeed("ifconfig >&2")
#                                                                            client.succeed("ping -c 1 192.168.1.2 >&2")
#                                                                            client.succeed("mkdir -- parents ~/.ssh")
#                                                                            client.succeed("chmod 0700 ~/.ssh")
#                                                                            client.succeed("cat ${ pseudo-secrets }/identity > ~/.ssh/identity")
#                                                                            client.succeed("chmod 0400 ~/.ssh/identity")
#                                                                            client.succeed("ssh -i ~/.ssh/identity -o StrictHostKeyChecking=no -l git 192.168.1.2 verify-it-works >&2")
#                                                                            # router.fail("true")
#                                                                        '' ;
#                                                                } ;
#                                                happy =
#                                                    _resource.check
#                                                        {
#                                                            actions =
#                                                                let
#                                                                    __resource =
#                                                                        _resource.implementation
#                                                                            {
#                                                                                gc-roots-directory = "/home/checker/.gc-roots" ;
#                                                                                resources-directory = "/home/checker/resources" ;
#                                                                            } ;
#                                                                    double-quote = ''"'' ;
#                                                                    single-quote = "'" ;
#                                                                    in
#                                                                        [
#                                                                            { process = "pre" ; text = ''check-executable "$RESOURCES/clean.sh"'' ; }
#                                                                            { process = "pre" ; text = ''"$RESOURCES/clean.sh"'' ; }
#                                                                            {
#                                                                                process = "pre" ;
#                                                                                text =
#                                                                                    ''
#                                                                                        check-executable "$RESOURCES"/resources/'["checks","true","true"]'
#                                                                                    '' ;
#                                                                            }
#                                                                            {
#                                                                                expected-standard-output = "/home/checker/resources/mounts/0000000000000000" ;
#                                                                                process = "pre" ;
#                                                                                text =
#                                                                                    ''
#                                                                                        # shellcheck disable=SC2288
#
#                                                                                        "$RESOURCES"/resources/'["checks","true","true"]' 9416174984176284
#                                                                                    '' ;
#                                                                            }
#                                                                            {
#                                                                                process = "pre" ;
#                                                                                text =
#                                                                                    ''
#                                                                                        jq \
#                                                                                            --null-input \
#                                                                                            '{
#                                                                                                "arguments" : [ "9416174984176284" ] ,
#                                                                                                "index" : "0000000000000000" ,
#                                                                                                "inputs" : { } ,
#                                                                                                "seed" :
#                                                                                                    [
#                                                                                                        {
#                                                                                                            "path" : [ 0 ] ,
#                                                                                                            "type" : "string" ,
#                                                                                                            "value" : "checks"
#                                                                                                        } ,
#                                                                                                        {
#                                                                                                            "path" : [ 1 ] ,
#                                                                                                            "type" : "string" ,
#                                                                                                            "value" : "true"
#                                                                                                        } ,
#                                                                                                        {
#                                                                                                            "path" : [ 2 ] ,
#                                                                                                            "type" : "string" ,
#                                                                                                            "value" : "true"
#                                                                                                        }
#                                                                                                    ] ,
#                                                                                                "standard-output" : "4819688586897478\n" ,
#                                                                                                "targets" : [ "1968976268514822" ] ,
#                                                                                                "text" : "echo 4819688586897478\ntouch 1968976268514822\n" ,
#                                                                                                "temporary" : false
#                                                                                            }' > "$SCRATCH/cleaned.json"
#                                                                                    '' ;
#                                                                            }
#                                                                            { process = "pre" ; text = ''check-redis-message message valid-init "$SCRATCH/cleaned.json" object'' ; }
#                                                                            { process = "pre" ; text = "check-redis-block" ; uuid = "4123733772938815" ;}
#        #                                                                    ### THIS IS WRONG
#                                                                            {
#                                                                                process = "post" ;
#                                                                                text =
#                                                                                    ''
#                                                                                        jq \
#                                                                                            --null-input \
#                                                                                            '{
#                                                                                                "standard-output" : "2679141487527185" ,
#                                                                                                "status" : 0
#                                                                                            }' > "$SCRATCH/post.json"
#                                                                                    '' ;
#                                                                            }
#                                                                            { process = "post" ; text = ''check-redis-message message valid-release "$SCRATCH/post.json" object'' ; uuid = "3177289165823618" ; }
#                                                                            { process = "post" ; text = ''check-executable "$RESOURCES/clean.sh"'' ; }
#                                                                            { process = "post" ; text = ''"$RESOURCES/clean.sh"'' ; }
#                                                                        ] ;
#                                                            gc-roots-directory = "/home/checker/.gc-roots" ;
#                                                            machines = { } ;
#                                                            nixosTest = pkgs.nixosTest ;
#                                                            pkgs = pkgs ;
#                                                            private = private ;
#                                                            resources-directory = "/home/checker/resources" ;
#                                                            user = "checker" ;
#                                                        } ;
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
