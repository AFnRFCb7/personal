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
                                        parameters =
                                            {
                                                personal =
                                                    {
                                                        secrets =
                                                            {

                                                            } ;
                                                    } ;
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
                                                                                            check =
                                                                                                {
                                                                                                    alpha =
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
                                                                                                                                                exit 124
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                        } ;
                                                                                                                targets = [ "1968976268514822" ] ;
                                                                                                                temporary = false ;
                                                                                                            } ;
                                                                                                    beta =
                                                                                                        ignore :
                                                                                                            {
                                                                                                                error = 134 ;
                                                                                                                init =
                                                                                                                    ignore :
                                                                                                                        {
                                                                                                                            action =
                                                                                                                                ignore :
                                                                                                                                    {
                                                                                                                                        targetPkgs = { pkgs , ... } : [ pkgs.coreutils ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                echo 4819688586897478
                                                                                                                                                touch 1968976268514822
                                                                                                                                                # shellcheck disable=SC2288
                                                                                                                                                ALPHA="$( "$RESOURCES"/release/'["checks","alpha"]' )" || exit 136
                                                                                                                                                ln --symbolic "$ALPHA" /gc-root/alpha
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
                                                                                                                                                                                        Host github.com
                                                                                                                                                                                            HostName ${ config.personal.secrets.host }
                                                                                                                                                                                            User git
                                                                                                                                                                                            IdentityFile $IDENTITY/identity.asc
                                                                                                                                                                                            UserKnownHostsFile $KNOWN_HOSTS/known-hosts.asc
                                                                                                                                                                                            StrictHostKeyChecking no
                                                                                                                                                                                        EOF
                                                                                                                                                                                        chmod 0400 config
                                                                                                                                                                                    '' ;
                                                                                                                                                                            }
                                                                                                                                                                    )
                                                                                                                                                                ] ;
                                                                                                                                                        text = "config" ;
                                                                                                                                                    } ;
                                                                                                                                            recovery =
                                                                                                                                                {
                                                                                                                                                    fail =
                                                                                                                                                        ignore :
                                                                                                                                                            {
                                                                                                                                                                targetPkgs = pkgs : [ pkgs.coreutils ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        echo 7179669781491843
                                                                                                                                                                        exit 117
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    pass =
                                                                                                                                                        ignore :
                                                                                                                                                            {
                                                                                                                                                                targetPkgs = pkgs : [ pkgs.coreutils ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        echo 8921335538452797
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
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
                                                                                                                                            recovery =
                                                                                                                                                {
                                                                                                                                                    check =
                                                                                                                                                        ignore :
                                                                                                                                                            {
                                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils  ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        echo 9131352568195371
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
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
                                                                                                                                error = 195 ;
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
                                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.openssh ] ;
                                                                                                                                                                                text =
                                                                                                                                                                                    _visitor.implementation
                                                                                                                                                                                        {
                                                                                                                                                                                            null =
                                                                                                                                                                                                path : value :
                                                                                                                                                                                                    ''
                                                                                                                                                                                                        ssh-keyscan ${ config.personal.secrets.host } > "known-hosts.asc"
                                                                                                                                                                                                        chmod 0400 "known-hosts.asc"
                                                                                                                                                                                                    '' ;
                                                                                                                                                                                            path =
                                                                                                                                                                                                path : value :
                                                                                                                                                                                                    ''
                                                                                                                                                                                                        cat ${ value } > "known-hosts.asc"
                                                                                                                                                                                                        chmod 0400 "known-hosts.asc"
                                                                                                                                                                                                    '' ;
                                                                                                                                                                                        }
                                                                                                                                                                                        config.personal.secrets.known-hosts ;
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
                                                                                                                                targets = [ "known-hosts.asc" ] ;
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
                                                                                                                                                                                        cat ${ config.personal.temporary.ssh.identity } > "identity.asc"
                                                                                                                                                                                        chmod 0400 "identity.asc"
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
                                                                                                                                targets = [ "identity.asc" ] ;
                                                                                                                                temporary = false ;
                                                                                                                            } ;
                                                                                                                } ;
                                                                                                        } ;
                                                                                                    repository =
                                                                                                        {
                                                                                                            secrets =
                                                                                                                ignore :
                                                                                                                    {
                                                                                                                        error = 166 ;
                                                                                                                        init =
                                                                                                                            ignore :
                                                                                                                                {
                                                                                                                                    action =
                                                                                                                                        ignore :
                                                                                                                                            {
                                                                                                                                                targetPkgs =
                                                                                                                                                    { pkgs , ... } :
                                                                                                                                                        [
                                                                                                                                                            pkgs.git
                                                                                                                                                            (
                                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                                    {
                                                                                                                                                                        name = "configure-ssh" ;
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.openssh ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                ln --symbolic ${ pkgs.openssh } /gc-root/open-ssh
                                                                                                                                                                                # shellcheck disable=SC2288
                                                                                                                                                                                CONFIG="$( "$RESOURCES"/resources/'["production","dot-ssh","config","github"]' )" || exit 172
                                                                                                                                                                                ln --symbolic "$CONFIG" /gc-root/config
                                                                                                                                                                                git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $CONFIG/config"
                                                                                                                                                                             '' ;
                                                                                                                                                                    }
                                                                                                                                                            )
                                                                                                                                                        ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        git init 2>&1
                                                                                                                                                        configure-ssh
                                                                                                                                                        git config user.email "${ config.personal.secrets.email }"
                                                                                                                                                        git config user.name "${ config.personal.secrets.name }"
                                                                                                                                                        git remote add origin "${ config.personal.secrets.remotes.ssh }"
                                                                                                                                                        git fetch origin "${ config.personal.secrets.branch }" 2>&1
                                                                                                                                                        git checkout "${ config.personal.secrets.branch }" 2>&1
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                } ;
                                                                                                                        release =
                                                                                                                            ignore :
                                                                                                                                {
                                                                                                                                    action =
                                                                                                                                        ignore :
                                                                                                                                            {
                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils pkgs.findutils pkgs.git ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        git push origin HEAD 2>&1
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                } ;
                                                                                                                        targets = [ ".git" "dot-gnupg" "dot-ssh" "github" ] ;
                                                                                                                        temporary = false ;
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
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nettools }/bin/ifconfig
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
                                                                        host = lib.mkOption { default = "github.com" ; type = lib.types.str ; } ;
                                                                        known-hosts = lib.mkOption { default = null ; type = lib.types.nullOr lib.types.path ; } ;
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
                                                    environment.defaultPackages = [ pkgs.nettools ] ;
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
                                                            agenix = "${ shared }/age/identity" ;
                                                            description = "Chester Checker" ;
                                                            email = "chester@checker.com" ;
                                                            name = "checker" ;
                                                            password = "chester" ;
                                                            secrets =
                                                                {
                                                                    branch = builtins.readFile "${ shared }/branch" ;
                                                                    host = builtins.readFile "${ shared }/ip" ;
                                                                } ;
                                                            temporary =
                                                                {
                                                                    ssh =
                                                                        {
                                                                            identity = "${ shared }/dot-ssh/identity.asc" ;
                                                                            known-hosts = "${ shared }/known-hosts.asc" ;
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
                                                                        address = builtins.readFile "${ shared }/ip" ;
                                                                        prefixLength = 24 ;
                                                                    }
                                                                ];
                                                            useDHCP = false ;
                                                        } ;
                                                    services.openssh.enable = true ;
                                                    systemd =
                                                        {
                                                            services.github =
                                                                {
                                                                    serviceConfig =
                                                                        {
                                                                            after = [ "network.target" ] ;
                                                                            ExecStart =
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "ExecStart" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        mkdir --parents /home/git/AFnRFCb7/9ebf9ebc.git
                                                                                                        cd /home/git/AFnRFCb7/9ebf9ebc.git
                                                                                                        git init
                                                                                                        git config user.email "git@git"
                                                                                                        git config user.name "git"
                                                                                                        git checkout -b ${ builtins.readFile "${ shared }/branch" }
                                                                                                        cp --recursive ${ shared }/repository/secrets/ciphertext/* .
                                                                                                        git add .
                                                                                                        git commit -am "initial commit"
                                                                                                        sleep inf
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/ExecStart" ;
                                                                            User = "git" ;
                                                                        } ;
                                                                    wantedBy = [ "multi-user.target" ] ;
                                                                } ;
                                                        } ;
                                                    users.users.git =
                                                        {
                                                            isNormalUser = true ;
                                                            openssh.authorizedKeys = { keyFiles = [ "${ shared }/dot-ssh/identity.pub.asc" ] ; } ;
                                                            packages = [ pkgs.git ] ;
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
                                                                            let
                                                                                age =
                                                                                    ''
                                                                                        AGE-SECRET-KEY-19MLHEMP493FLEL20MCNQJMAT2K5HS8G2A95NGM5APUGAJLV9AP2Q3YA5A5
                                                                                    '' ;
                                                                                dot-ssh =
                                                                                    {
                                                                                        known-hosts =
                                                                                            ''
                                                                                                # ${ ip }:22 SSH-2.0-OpenSSH_9.9
                                                                                                ${ ip } ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrTrG0R5UiY/LuWfcI4HshSblmijfuibIrtOKSnY0hN7oqWStbGsAeplsHxemmkSic/4zANs9u82TPbwP8hNlOFRUCxYVktybHW3mF/wlVqqBLVPWObzwYAIaQitZV0c4vuablbJcJQT7KaCxVcDD1JuTeA6j6K3llu5eflysbhYPKPFPtxDiAZ3wkeFAO6RHmHC8NbrsDymo4XCg+MiteK4fSr0gn5MMtHKzDf1/xVZQ3UlpKw9s9uQglY2KtFg1wOk4mTx5gFnoizzKCWthq65k2VNSqwQQT7/l93mgkf1JocOQQVqo+rCG9MU/vwjyyPL0sKXwLanos5UeWvQL6qJBHGTLAA7FNay+qtG+014isPyjbjloG2O3u2CKrRqaIv0x1OHGj9k/Lisrv2ur3SLewADBmcTMR6DE2378j75mfetrO1qD1Rh0JuKIZ8GkP3QGJzUN3LS6rTtoZo+LfO5Jyj4iNqR37HaWmgBrWgSQVSJfBbjLLHKiepiUTmkZDrjPZOxKfqbx1mD7lQHZDA3vPUcjTkaz5f7ZMr7KLwChqv17Eseek+z0hH3UfzbK9Mcq+P6jYtKzp5vDyJlD18DTxYfbf6cpv2R1JxNGyPHlyOJphsCXXAaXuPBVC6j2uM/mmEHsISJvUu6uALxiSw4fVyLv5mWfR4DiW/bxKpw==
                                                                                                # ${ ip }:22 SSH-2.0-OpenSSH_9.9
                                                                                                # ${ ip }:22 SSH-2.0-OpenSSH_9.9
                                                                                                ${ ip } ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsmZW90R0rSW2DqAFXeS+ZtfmmqWBXET72O0uyr/i51
                                                                                                # ${ ip }:22 SSH-2.0-OpenSSH_9.9
                                                                                                # ${ ip }:22 SSH-2.0-OpenSSH_9.9
                                                                                            '' ;
                                                                                        identity =
                                                                                            ''
                                                                                                -----BEGIN OPENSSH PRIVATE KEY-----
                                                                                                b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
                                                                                                QyNTUxOQAAACAGm0ovS05RJfJeIFvzVLXKF2a9Efg9v6cDPI/frIAiGQAAAJCG8xbBhvMW
                                                                                                wQAAAAtzc2gtZWQyNTUxOQAAACAGm0ovS05RJfJeIFvzVLXKF2a9Efg9v6cDPI/frIAiGQ
                                                                                                AAAEA15sr1k2IFWcFRf5WAwSvj05E1I0hZNPuBo2pcIPRifAabSi9LTlEl8l4gW/NUtcoX
                                                                                                Zr0R+D2/pwM8j9+sgCIZAAAAC2Vtb3J5QG5peG9zAQI=
                                                                                                -----END OPENSSH PRIVATE KEY-----
                                                                                            '' ;
                                                                                    } ;
                                                                                secrets =
                                                                                    {
                                                                                        dot-gnupg =
                                                                                            {
                                                                                                ownertrust =
                                                                                                    ''
                                                                                                        -----BEGIN AGE ENCRYPTED FILE-----
                                                                                                        YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBrYWE3UWVCOVlnOU1UeHk0
                                                                                                        ZUt0NXNlaDRLYlo3anhWc1grMnVrUmc5Q0QwCmZRREMvSmRtWk9GUkYyWUo0VTJR
                                                                                                        S1RrNUpYcjVoWkRaR05uVGJCL01qeVUKLS0tIGdWTE9SZ0xTSTBTa1l5NE1EY1R4
                                                                                                        ZjBocEhKZVh2eG8vOTFwNGdnZndzUUkKZxEmtPgUfBw9uoLnvnaTtSgXIu+Zflcd
                                                                                                        xQ+auzrqvgwwvmdfyhegDNnfChusmRynuW/k4m5bQBSrgSZbYTJJfI8wpN8iN0Gr
                                                                                                        ln5yA4NFCBqXTbcCBdnQhdsNHC74U3/ZZ5ZAEIMVdNXXBDNiKJQSTqMj1eG4wfGj
                                                                                                        N7MOLTgl+YgMwLLqwLjpWwADyJFYQPcPaXiiHmTxZ+XgHqgHV2ztGY5zkxJXQR+L
                                                                                                        5831Rs8TQ157uUvSTTgkh0/qW+eK2fqBS8bt74Cl
                                                                                                        -----END AGE ENCRYPTED FILE-----
                                                                                                    '' ;
                                                                                                secret-keys =
                                                                                                    ''
                                                                                                        -----BEGIN AGE ENCRYPTED FILE-----
                                                                                                        YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBvU0xzalpjWkJ6YlZ3dXVo
                                                                                                        L3RaV09XRmZpNDVhdzZiL1ZIOW9MMkZaNm1RCmM5RTFBK2dETXdLRzd1WHJuRHlJ
                                                                                                        eldYZHkxVTl2ekMwVEtEOEhnaGx1MncKLS0tIFYvcDRnczl3cTRtcHpOTHVqZE5J
                                                                                                        WTA1UVlhb1ZOTTkxdW41a2FYVGpnanMKnL+wtPzAR2LYfYAXlnV2MjuA5IB2i+RT
                                                                                                        pAYXwgePuiXxe7E9Mz4Pk9WyplFugLAnzWH1F8HT0NcGlqaL/bg0HiaCTVEPwPMy
                                                                                                        oemJaZUDlP6GIGja+u2n6snGVD+0Ck/w+PuQ2tsE+HRtbLe8gdGZuiu6jLtEFf0x
                                                                                                        JfKi5eXjxKLsvuCSjsOk8DP/GEfoCgeUQA5RpTMaTCyrkigueDibNTo/k8WmGYEN
                                                                                                        5eRap3Go2jwM/zzDhHili1vJMqD9FUcbeuwpZSt659uuWhTdxFfkjT7D2xXdMfyb
                                                                                                        QkHPlLQkhJ3Vl92tVBnHvf5r5LVy4IqYZXYS8Ll74Av9SLaTtQkGe3/jD3bWyK/Z
                                                                                                        CYl4Yfc0iAmwRQfcmO9NCgW0oxsOYH9ONtOlFMKzC+YlIE0dMMMYgCOXUiGeCDHa
                                                                                                        YGOVBSS870PPAdMvNdNyU/AstK1IJIsusAn3OjXUzw9tQtiC2BWhSXoKpGcRU8j2
                                                                                                        C//wQNeWCEvu3nZZHr0AHu8mdyVFKYBDqHO+3VKYuCZKTMtS7JaWfAFfJL9xABjb
                                                                                                        i2cPUsYdEz9wSdf/G1EINGEQD7tPXDZDLvsubKd+WrS4I79CdsddFI/7GIO+3k2l
                                                                                                        p/Y1PBDGrMhPldMlNFUF+zS/EcL3t/hl3aOqOcaJtai76Uf1U+wRk5Vg8vpLNAEa
                                                                                                        I+GjDCSx5QdyIulXN9UA0EZcAnGdD5f73vl1AR8tN9xfwhTADQw2LsmF0we2BVbQ
                                                                                                        EC0xQJdmbC1U7UruVCZU5PwWx6CKQcxx1Vj0ab5uHQePw7xTY3tRXYTvSGCjUVXg
                                                                                                        GFO8wPKqmzkGJf/ptiFSUvqmsvDDN89Or3HadCxliN1SN/ZLto9EXsXVFj2aHIn1
                                                                                                        NnJnHb5jKL//OUh+Jfe/giXaQyT8NrU7TyokG8Wku489F2jYSBEsZJ5SUAhzodfs
                                                                                                        TStdZUJvudMqO4THPaIwIzjWNjw8g6sitOri1C4sAzqYglDU+EMhCoRiqfMXrNTk
                                                                                                        wfW+xunA+3mmeL/XudkM/e8wYVplz1lTc/0HNx6SzNNQnqo1QdifI5ctU0OOv4sj
                                                                                                        DTTYWGrQwqXcc/sw5Xk1Avy6oy12CXu8D3SSCMPfBLJWRJHuYKrUMRKUcPciNjyf
                                                                                                        aHdkF4jqlKmt+qy8Q70y17Rni8gNLvZvzdYZPNX/gnJ7eN4qUCaHFV2VQV4ftEKC
                                                                                                        P67AmBP/03V/Y+1jqLpxM+ZwkjMztr6eaX0=
                                                                                                        -----END AGE ENCRYPTED FILE-----
                                                                                                    '' ;
                                                                                            } ;
                                                                                        dot-ssh =
                                                                                            {
                                                                                                mobile =
                                                                                                    {
                                                                                                        known-hosts =
                                                                                                            ''
                                                                                                                -----BEGIN AGE ENCRYPTED FILE-----
                                                                                                                YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBVM1M2Q1lrMGFsKzhpRity
                                                                                                                aCtGOFk4eFFNU2FySm4ySmxXNzdNZkhZWDF3CndSd083OVIrbklhbnA4SkticHpi
                                                                                                                Zmo5MnJtWDhJK3hHQnB4NEFkWjdVV0UKLS0tIEFBQ2JlcHhWQ3FBbnMvUUxnU0R6
                                                                                                                WFBXNk56RFhTT1MvdHZDL04vOUNmS0EK0JBmenvRk7MJv7jG1WvvQNTbzbNI+LAA
                                                                                                                ZijwrZy0p1o=
                                                                                                                -----END AGE ENCRYPTED FILE-----
                                                                                                            '' ;
                                                                                                        identity =
                                                                                                            ''
                                                                                                                -----BEGIN AGE ENCRYPTED FILE-----
                                                                                                                YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBRRGVYK2o4b08xbVVyeTdG
                                                                                                                MlUvRzdBT3BNZXFOakpyeWxUNG9vdi82cDFVCjhCUEN6Y1JXSGYyUFdSTkgrZ3k0
                                                                                                                OU1ocWY5K0x1RXlGTGdaeGlaK1I4ejgKLS0tIDJ3ZDVRY09uUlFNVCszZHY4QnlR
                                                                                                                M2V0QkFLbWhSNDZydWcwWmFqR2R1cmMKUd2lqqyTzDjqRWJhzHmxeBfQkOmSEQBr
                                                                                                                CWZ91o3rAWE0bxtKy+HDN29zWWic40zKmLFbq4mA7q5/DsGKF43Oc8UCMrWTjKCC
                                                                                                                3FiThVID6bEiHzjVrnoCVPdrnSQ9BWPpQ0oTOkmNsdKzxirMVmvUChGKdGMqgRc+
                                                                                                                ePVDP9NBYvd0ay58yH29rk8C45skLXc1q0gieLRVG2p+77QpBY3tggZRrfl6/EPN
                                                                                                                9HUdFQQdozRcSobgaasxZ6LnUkp4OHUKKc5DfXPOPaGQ8MlaVrv7+sFKeSiT1Kd3
                                                                                                                Mpv3maHXGCb8ZvmIUL91ljYgSBMlHqVGsw7zxdaR86c8l9SbFzg0YyY7yuMqX0U7
                                                                                                                DvcLTuTeYHExeiD41GhxndR7I2y/wPh2n6iS12xysOMZtZxWhS8rhrjuOkMrX6i/
                                                                                                                FMIH6DSp4vkhVT98DSpZbr7FXfZOunzdzFEM7kZ4lZdRVcGFea4iyB6PMyyLHGcl
                                                                                                                U866razTT2SG2O+iTqsh7TU9lNvFyno4sT85LwHrL1bBAC6iSqOQPA/hhR4rNRV1
                                                                                                                7dfMMN0mXCrtF5g=
                                                                                                                -----END AGE ENCRYPTED FILE-----
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            } ;
                                                                                       github =
                                                                                            {
                                                                                                token =
                                                                                                    ''
                                                                                                        -----BEGIN AGE ENCRYPTED FILE-----
                                                                                                        YWdlLWVuY3J5cHRpb24ub3JnL3YxCi0+IFgyNTUxOSBCMlZwRUo5cUFiL1Y2Ty9O
                                                                                                        UHJUTzg1ZGhMWUdWaEZuZkN0OUp0clQxMjBjCnpTWDIzUnEvNTVKVnNZT1ZZVFBJ
                                                                                                        R2RyaVFSU0d6cFpaL1lwY1ozNG10RmMKLS0tIHdLRGlwakp0NE02cXJVS1dwRW0z
                                                                                                        KzJNQVpIMWJBaGkzN2VwVWNJWi84M0UKhuUlJyN/lAMMlBS2pojYfqUAPnuya23s
                                                                                                        ZNvePOpZZlh4S6JkabzHG3j2vliE3FIe6zDLkfHp7Z+/5BLSP0n5ilBwiqHR
                                                                                                        -----END AGE ENCRYPTED FILE-----
                                                                                                    '' ;
                                                                                            } ;
                                                                                    } ;
                                                                                branch = "main" ;
                                                                                ip = "192.168.2.234" ;
                                                                                in
                                                                                    ''
                                                                                        OUT="$1"
                                                                                        mkdir --parents  "$OUT"
                                                                                        echo -en ${ branch } > "$OUT/branch"
                                                                                        echo -en ${ ip } > "$OUT/ip"
                                                                                        mkdir --parents "$OUT/age"
                                                                                        cat ${ builtins.toFile "identity" age } > "$OUT/age/identity"
                                                                                        age-keygen -y "$OUT/age/identity" > "$OUT/age/identity.pub"
                                                                                        mkdir --parents "$OUT/age"
                                                                                        mkdir --parents "$OUT/dot-ssh"
                                                                                        cat ${ builtins.toFile "known-hosts" dot-ssh.known-hosts } > "$OUT/dot-ssh/known-hosts.asc"
                                                                                        cat ${ builtins.toFile "identity" dot-ssh.identity } > "$OUT/dot-ssh/identity.asc"
                                                                                        chmod 0400 "$OUT/dot-ssh/identity.asc"
                                                                                        ssh-keygen -f "$OUT/dot-ssh/identity.asc" -y > "$OUT/dot-ssh/identity.pub.asc"
                                                                                        chmod 0400 "$OUT/dot-ssh/identity.pub.asc"
                                                                                        mkdir --parents "$OUT/repository/secrets/ciphertext/dot-gnupg"
                                                                                        ln --symbolic ${ builtins.toFile "ownertrust.asc.age" secrets.dot-gnupg.ownertrust } "$OUT/repository/secrets/ciphertext/dot-gnupg/ownertrust.asc.age"
                                                                                        ln --symbolic ${ builtins.toFile "secret-keys.asc.age" secrets.dot-gnupg.secret-keys } "$OUT/repository/secrets/ciphertext/dot-gnupg/secret-keys.asc.age"
                                                                                        mkdir --parents "$OUT/repository/secrets/ciphertext/dot-ssh/mobile"
                                                                                        ln --symbolic ${ builtins.toFile "identity.asc.age" secrets.dot-ssh.mobile.known-hosts } "$OUT/repository/secrets/ciphertext/dot-ssh/mobile/known-hosts.asc.age"
                                                                                        ln --symbolic ${ builtins.toFile "user-keys.asc.age" secrets.dot-ssh.mobile.identity } "$OUT/repository/secrets/ciphertext/dot-ssh/mobile/identity.asc.age"
                                                                                        mkdir --parents "$OUT/repository/secrets/ciphertext/github"
                                                                                        ln --symbolic ${ builtins.toFile "token.asc.age" secrets.github.token } "$OUT/repository/secrets/ciphertext/github/token.asc.age"
                                                                                        mkdir --parents "$OUT/repository/secrets/plaintext/dot-gnupg"
                                                                                        age --decrypt --identity "$OUT/age/identity" --output "$OUT/repository/secrets/plaintext/dot-gnupg/ownertrust.asc" "$OUT/repository/secrets/ciphertext/dot-gnupg/ownertrust.asc.age"
                                                                                        age --decrypt --identity "$OUT/age/identity" --output "$OUT/repository/secrets/plaintext/dot-gnupg/secret-keys.asc" "$OUT/repository/secrets/ciphertext/dot-gnupg/secret-keys.asc.age"
                                                                                        mkdir --parents "$OUT/repository/secrets/plaintext/dot-ssh/mobile"
                                                                                        age --decrypt --identity "$OUT/age/identity" --output "$OUT/repository/secrets/plaintext/dot-ssh/mobile/user-keyd.asc" "$OUT/repository/secrets/ciphertext/dot-ssh/mobile/known-hosts.asc.age"
                                                                                        cat "$OUT/repository/secrets/ciphertext/dot-ssh/mobile/identity.asc.age" >&2
                                                                                        age --decrypt --identity "$OUT/age/identity" --output "$OUT/repository/secrets/plaintext/dot-ssh/mobile/identity.asc" "$OUT/repository/secrets/ciphertext/dot-ssh/mobile/identity.asc.age"
                                                                                        mkdir --parents "$OUT/repository/secrets/plaintext/github"
                                                                                        age --decrypt --identity "$OUT/age/identity" --output "$OUT/repository/secrets/plaintext/github/token.asc" "$OUT/repository/secrets/ciphertext/github/token.asc.age"
                                                                                    '' ;
                                                                        }
                                                            )
                                                        ] ;
                                                    src = ./. ;
                                                } ;
                                        in
                                            {
#                                                "resource happy path : bootstrap github config" =
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
#                                                                                check-executable "$RESOURCES"/resources/'["production","dot-ssh","config","github"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        reads = false ;
#                                                                        process = "pre" ;
#                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
#                                                                        text =
#                                                                            ''
#                                                                                # shellcheck disable=SC2288,SC2034,SC2153
#                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","dot-ssh","config","github"]' )" || exit 188
#                                                                                echo -en "$RESOURCE"
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                4d2848684f1f1fa4cc83311a596b72a1314bf59a7b95c006a47ec39a52df87429a777be45e183da1e68197f7d115f08e7cc5a903c099880b13508b7fb19aeb13
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                0eeadcccd537f840fcb7b47277723d0a836588a95431bd483a7a124b1b273714d4dd7cc751339ee017be4687e4ce1a66c0fedbcaa54d3a37be66255d62955db8
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                67e07cbe631c9789bec66860033533edecd7614fa8d3a6b88f18a81365ee54f46e74431743db22940363103b7c0ba573604a7ee426340672399eb312cd691318
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                45c80bb7f92f2311861742c0190813f702aa98fa3ad9a84c652f3e23ef330b19af8e58e6f10840c9442c611db4d3015da21a34c4f65230d37fea9e6264f6fd63
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                6a8b0a64c20ee69fe5f85d2f1a1fd10fe962fc7d433bf72c189aa246dcb3e0bdc0069a709e7985b5b23942f743c42f2f639699ff95fbbf94313ea6b2aefd029f
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                0a6854996dd4487338bc0665da2fd0749172adf7c872a5f5623743fa05c40e6cf0c0cf1f1b6743bc4306a777b9e199a4a72707f88d72ce2aba56fcdcc0f4228f
#                                                                            '';
#                                                                        text =
#                                                                            ''
#                                                                                check-resources-directory --exclude "0000000000000001/known-hosts.asc"
#                                                                            '' ;
#                                                                    }
#                                                                    { kludge = true ; process = "post" ; text = "sleep 56s" ; }
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
#                                                                                98ce68ad0eb0a01eef2078b5d07808a1ecef9c50c81096be69e73f0f8e43d94b34d9b6395f921a47e26d43098fed9528bf4fbb24455870a6951002e43b6bec33
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                4da9e3339b48613167f63a29d2bade2d276c111f4550a1f9c7f105683bb591bf92bf2e9f9ab6c6710266ce57ca2dc4101c0a47e626e9be116bbd7507d3b839a7
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                28f1bfdb71bf4bc287ed21563cc420406cc35a210877142b90663ca8ea0c04a9ce64b7819b1d1cc36bfcacdfaa4936a89afcdd0cdf14088be5ff11b501ae1430
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                ba8fd424b3c4e20ce2745f988c95a1117c165a0ae9ade33e9398a6e2074d987c8667b7bc1389847f475eddc039a7c5e995d7f4b80ebd6a32552648dde868c3cf
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                13c2473e5f0d28031ddf1208ab9eae5f12cfa0c69ead0ae15841de41604b13c243f0c0360c7fefce378543c770c834cb2eca7bf1dad07f6c7f5b591d93ee69f7
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
#                                                                        ''github.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("log.service")''
#                                                                        ''client.wait_for_unit("release.service")''
#                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute 7831823836692246")''
#                                                                        # ''client.copy_from_host_machine(".","/tmp/documents/_3")''
#                                                                    ] ;
#                                                        } ;
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
#                                                                                # shellcheck disable=SC2288,SC2034,SC2153
#                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","dot-ssh","known-hosts","github"]' )" || exit 171
#                                                                                echo -en "$RESOURCE"
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
#                                                                                5eb881c616b904467727a392d9762795021cfda1f3316aa4b7b10c12ca9aec50b6b992465cd3f1f7cbc5c29bbd85c17148337fe22b2882d9c119cd2ca0b5ebab
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                235aa9106ef1d2ef95f7c3b958597663b65b466ff9921ae230ac63cdaee52a539e955dbe4ef35bead8a16ad824d7966463ae0ddd3cf5fa5a904ab2197fedcdfe
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                14ba606450c880777d43f9cbf60d5aff69afb21cdbb73ea7f6cbcd949d18aa875dfe4d3caf1a9deb0a05e2f2120653c97a3f9b39931ae2277911593e86aee1a4
#                                                                            '' ;
#                                                                        text =
#                                                                            ''
#                                                                                check-resources-directory --exclude "0000000000000000/known-hosts.asc"
#                                                                            '' ;
#                                                                    }
#                                                                    { kludge = true ; process = "post" ; text = "sleep 56s" ; }
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
#                                                                                18e6f8edc871b599c8fd0c00139f5463dee3e277768b792a4e06163d8350a196fc8c9a3806d4b5ca043066684344a2cb21d2bdcbf4f20a1ab322609318d9298d
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                4da9e3339b48613167f63a29d2bade2d276c111f4550a1f9c7f105683bb591bf92bf2e9f9ab6c6710266ce57ca2dc4101c0a47e626e9be116bbd7507d3b839a7
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                c76deb7556f5960e0388547e064ab106ec038465b436d8e713f2d2d9c9290e97ca768da67649d6268c8a55e4634d415aeed1eb48f5c650ed853f723563f1f9a7
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
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                            '' ;
#                                                                        text = "check-redis" ;
#                                                                    }
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
#                                                                        ''github.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("log.service")''
#                                                                        ''client.wait_for_unit("release.service")''
#                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute")''
#                                                                        # ''client.copy_from_host_via_shell("/tmp/client-documents","/tmp/documents/_1")''
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
#                                                                                # shellcheck disable=SC2288
#                                                                                check-executable "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        reads = false ;
#                                                                        process = "pre" ;
#                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
#                                                                        text =
#                                                                            ''
#                                                                                # shellcheck disable=SC2288,SC2034,SC2153
#                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]' )" || exit 133
#                                                                                echo -en "$RESOURCE"
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
#                                                                                7af8a31a4ada26ab0b87527e60ecc118f7d3cf87bc82fcf4febbd4fb4307bf876b2c7ae95235ae33bae2224f35fe13e9e5dcbb144861f387c3c1a568443eabf3
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b3b21cb2edda2a69eb62b46ac7ba983e042ad0b3f5f7cea55c0510db90b7647ce3fb9c0dc2bae05448a5dd4830d31152c5f59b2ea10211fdeb11cd6346d93264
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                38b0ccb8eb731ebe8c58a6a863af522318fcf3b3439717e4a29890f6e828f74267b353dc133730ea1ce38063067f67a0283f08940f864ebaad0b39416c1e7907
#                                                                            '';
#                                                                        text = ''check-resources-directory'' ;
#                                                                    }
#                                                                    { kludge = true ; process = "post" ; text = "sleep 56s" ; }
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
#                                                                                18e6f8edc871b599c8fd0c00139f5463dee3e277768b792a4e06163d8350a196fc8c9a3806d4b5ca043066684344a2cb21d2bdcbf4f20a1ab322609318d9298d
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                4da9e3339b48613167f63a29d2bade2d276c111f4550a1f9c7f105683bb591bf92bf2e9f9ab6c6710266ce57ca2dc4101c0a47e626e9be116bbd7507d3b839a7
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                c76deb7556f5960e0388547e064ab106ec038465b436d8e713f2d2d9c9290e97ca768da67649d6268c8a55e4634d415aeed1eb48f5c650ed853f723563f1f9a7
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
#                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute 9347215719838394") ''
#                                                                        # ''client.copy_from_host_via_shell("/tmp/client-documents","/tmp/documents/_2")''
#                                                                    ] ;
#                                                        } ;
#                                                "resource happy path : secrets" =
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
#                                                                                check-executable "$RESOURCES"/resources/'["production","repository","secrets"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        reads = false ;
#                                                                        process = "pre" ;
#                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
#                                                                        text =
#                                                                            ''
#                                                                                # shellcheck disable=SC2288,SC2034,SC2153
#                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","repository","secrets"]' )" || exit 183
#                                                                                echo -en "$RESOURCE"
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                23b89e281cb255d1509fab9983a2534b5d47aebc41fc7cf91d133f24dfd82cd1f2543447111fac16c140efeab7298127b6bafce7e346f9246213eeaec1ab5d8a
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                528aa1ff3827265fef3d206c0055bdebbde1d6114ce749c2f52fed85ccf376bec2c0cdcc5ee06aec0733b6bdebcdbf21c5c60cd1c9343750d66dfa236fdf80a8
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                964c18695855de7b8343042780dfa464fbb9ef6aec4aa4f9242f05f6feb144b7df9b4d3e572f718cc1adacd66f789258798a686a055fc60ae7b2bfc331c956b6
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                4b6cc13edd83326c51dc77b708e4b53eae946a06f4e45157e8610f1c837f16dd49df5ec8a5d27a5cc5225bacbdd3b1c543786684ee7d2c3e478c4f5192362577
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                8be929f798ea79f0ee2dccaa0fd7386f1536c0727a33103bcb542c613174e4da49a18d81f0402c83c1424a821d48489aa891949fb3c6780c80f8b27f8c72514e
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                88b2656076cc7bc77a3ee158aeb4044ba263b1fb2792026a00c4a5b0bb5d8ada793c8c3edd14cbde7f214c79992e96e286d6a48bc17515893d78c987d6d77c53
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                8cccc550701e63a163d6e54e379175162a4fd9799c42cc1aed106be7f2aae40f6bcee2929ae08ec2ec8fe492f95682d6fa3f78f4935060913046a9c9e5b3c2e3
#                                                                            '' ;
#                                                                        text =
#                                                                            ''
#                                                                                check-resources-directory --exclude "0000000000000000/.git" --exclude "0000000000000002/known-hosts.asc" --exclude "release/*"
#                                                                            '' ;
#                                                                    }
#                                                                    { kludge = true ; process = "post" ; text = "sleep 56s" ; }
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
#                                                                                396d3134685dcedd7bfc11c851b232eef9ae65ce19d63b8feb41e843f4f4f26751f9ac7e1087f9285773db121ee8a38f444dbe2cb420f7b68a974b402d0e6bb3
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                5be6a14d8ae4466fe84578282d8b38d71a23f07b0864f6606f6843001792e7dfaf60c15362fb0f6d42f8e9efbd9ccc606cdc42d6203bb0a8b9c90602cacceebb
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                28f1bfdb71bf4bc287ed21563cc420406cc35a210877142b90663ca8ea0c04a9ce64b7819b1d1cc36bfcacdfaa4936a89afcdd0cdf14088be5ff11b501ae1430
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                ba8fd424b3c4e20ce2745f988c95a1117c165a0ae9ade33e9398a6e2074d987c8667b7bc1389847f475eddc039a7c5e995d7f4b80ebd6a32552648dde868c3cf
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                3f9e929cf44d1c3ad9e6411a7f0be82aa3721fa7d21c05cb730db9353f2b71ada185ba48e51a84b726c6972351ef6b2548ca1df513eddc92fac1b9e4e378b36c
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                ec99c7a5829357c61bb8cb89673693455b0e1871fee43754b250b7ed4b656a2589beab4e2f78c3b983b9f77da9ebe434bce8559357fdce32b2db7d769d001f0f
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
#                                                                        ''github.wait_for_unit("network-online.target")''
#                                                                        ''github.wait_for_unit("github.service")''
#                                                                        ''client.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("log.service")''
#                                                                        ''client.wait_for_unit("release.service")''
#                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute 3796956764364334")''
#                                                                        # ''client.copy_from_host_machine(".","/tmp/documents/_3")''
#                                                                    ] ;
#                                                        } ;
#                                                "resource sad path : secrets : MODEL" =
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
#                                                                                # shellcheck disable=SC2288,SC2034,SC2153
#                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]' )" || exit 183
#                                                                                echo -en "$RESOURCE"
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
#                                                                                7af8a31a4ada26ab0b87527e60ecc118f7d3cf87bc82fcf4febbd4fb4307bf876b2c7ae95235ae33bae2224f35fe13e9e5dcbb144861f387c3c1a568443eabf3
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                b3b21cb2edda2a69eb62b46ac7ba983e042ad0b3f5f7cea55c0510db90b7647ce3fb9c0dc2bae05448a5dd4830d31152c5f59b2ea10211fdeb11cd6346d93264
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                38b0ccb8eb731ebe8c58a6a863af522318fcf3b3439717e4a29890f6e828f74267b353dc133730ea1ce38063067f67a0283f08940f864ebaad0b39416c1e7907
#                                                                            '' ;
#                                                                        text =
#                                                                            ''
#                                                                                check-resources-directory --exclude "0000000000000000/.git" --exclude "0000000000000002/known-hosts.asc" --exclude "release/*"
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        text =
#                                                                            ''
#                                                                                check-executable "$RESOURCES"/resources/'["production","repository","secrets"]'
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        reads = false ;
#                                                                        process = "pre" ;
#                                                                        standard-output = "/home/checker/resources/mounts/0000000000000001" ;
#                                                                        text =
#                                                                            ''
#                                                                                # shellcheck disable=SC2288,SC2034,SC2153
#                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","repository","secrets"]' )" || exit 183
#                                                                                echo -en "$RESOURCE"
#                                                                            '' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                3defdced7e7bdf575a71f0e23acd0dc7c12728571f054b420b9fce63168d50c903b80644262730f6f43de7b793a6067a1e95e80d72d73eb1735881488dca434e
#                                                                            '';
#                                                                        text = ''check-gc-roots-directory'' ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre"  ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                32b2d6fafeeda8db5240785f1fa4e69c084e79e394e590dd316de490c7eaa13ab0cc99dbb52ba7f3556bd88c4f88eff0a83352b19250d0479f61e9bf74fa9537
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                7fab129b65bc834f7bbece94da6843524b688850162684ac321c050274af1995963572548f29bc99d2be0a5e21f0058e9a8c4f2f2869b125b95e0bbfb97c6fb4
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                655c0985d0c3f6e4078a017052230e009ea76d41a54fd53c3e87555b3d098a5a6982cef0be56ac0f0e38e174849dfff63b470a1c8ee67bbd2d5118840a724be4
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "pre" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                945522f9b04dfd64b166a788280214860cba646707a8e8250cb689381887735d3ed02c7b8981a4681285c768a685e2f3db6b275c11529e87fb9a0bceedd6824f
#                                                                            '' ;
#                                                                        text = "check-redis message valid-init set" ;
#                                                                    }
#                                                                    { process = "pre" ; text = "check-redis" ; }
#                                                                    { kludge = true ; process = "post" ; text = "sleep 56s" ; }
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
#                                                                                b0c9cd83b507693e7c65613f0419aa9477e32fd85a16d278a196e985ecb86bbcbf7da518cee000cf1770ff83007444a9598d3bd52b0c6eff34ec5aaa39fb4dbb
#                                                                            '' ;
#                                                                        text = "check-log" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                a3630365ddf577e5346ec7308712778d31c4a7899795ac31bcdba710f29cc914690f72f97691988e73521426c5e4091fa2e713e3ed53bff0ab56b8bb6859f4e9
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                ba8fd424b3c4e20ce2745f988c95a1117c165a0ae9ade33e9398a6e2074d987c8667b7bc1389847f475eddc039a7c5e995d7f4b80ebd6a32552648dde868c3cf
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                3f9e929cf44d1c3ad9e6411a7f0be82aa3721fa7d21c05cb730db9353f2b71ada185ba48e51a84b726c6972351ef6b2548ca1df513eddc92fac1b9e4e378b36c
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                4da9e3339b48613167f63a29d2bade2d276c111f4550a1f9c7f105683bb591bf92bf2e9f9ab6c6710266ce57ca2dc4101c0a47e626e9be116bbd7507d3b839a7
#                                                                            '' ;
#                                                                        text = "check-redis message valid-release set" ;
#                                                                    }
#                                                                    { process = "post" ; text = "check-redis" ; }
#                                                                    {
#                                                                        process = "post" ;
#                                                                        standard-output =
#                                                                            ''
#                                                                                ec99c7a5829357c61bb8cb89673693455b0e1871fee43754b250b7ed4b656a2589beab4e2f78c3b983b9f77da9ebe434bce8559357fdce32b2db7d769d001f0f
#                                                                            '';
#                                                                        text = ''check-resources-directory --exclude .git'' ;
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
#                                                                        ''github.wait_for_unit("network-online.target")''
#                                                                        ''github.wait_for_unit("github.service")''
#                                                                        ''client.wait_for_unit("network-online.target")''
#                                                                        ''client.wait_for_unit("log.service")''
#                                                                        ''client.wait_for_unit("release.service")''
#                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute 5845348478965617")''
#                                                                        # ''client.copy_from_host_machine(".","/tmp/documents/_3")''
#                                                                    ] ;
#                                                        } ;
                                                "resource sad path : secrets : failure in init and no recovery" =
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
                                                                                check-executable "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]'
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        reads = false ;
                                                                        process = "pre" ;
                                                                        standard-output = "/home/checker/resources/mounts/0000000000000000" ;
                                                                        text =
                                                                            ''
                                                                                # shellcheck disable=SC2288,SC2034,SC2153
                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]' )" || exit 183
                                                                                echo -en "$RESOURCE"
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
                                                                                7af8a31a4ada26ab0b87527e60ecc118f7d3cf87bc82fcf4febbd4fb4307bf876b2c7ae95235ae33bae2224f35fe13e9e5dcbb144861f387c3c1a568443eabf3
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                b3b21cb2edda2a69eb62b46ac7ba983e042ad0b3f5f7cea55c0510db90b7647ce3fb9c0dc2bae05448a5dd4830d31152c5f59b2ea10211fdeb11cd6346d93264
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    { process = "pre" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                38b0ccb8eb731ebe8c58a6a863af522318fcf3b3439717e4a29890f6e828f74267b353dc133730ea1ce38063067f67a0283f08940f864ebaad0b39416c1e7907
                                                                            '' ;
                                                                        text =
                                                                            ''
                                                                                check-resources-directory --exclude "0000000000000000/.git" --exclude "0000000000000002/known-hosts.asc" --exclude "release/*"
                                                                            '' ;
                                                                    }
                                                                    { process = "pre" ; text = "chmod 0777 /home/checker/resources/mounts/0000000000000000/identity.asc" ; }
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
                                                                    { process = "pre" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                6fa44f6c67e3bb665b1d09d559b6a4d023a42c3f175770aa8e2c6d9dbd00a213264908bc519ccecfe6f3adfc81d7cb25232b4e22e4e21fa90c2d77b9cfbc2a62
                                                                            '' ;
                                                                        text =
                                                                            ''
                                                                                check-resources-directory --exclude "0000000000000000/.git" --exclude "0000000000000002/known-hosts.asc" --exclude "release/*"
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        text =
                                                                            ''
                                                                                check-executable "$RESOURCES"/resources/'["production","repository","secrets"]'
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        reads = false ;
                                                                        process = "pre" ;
                                                                        # standard-output = "/home/checker/resources/mounts/0000000000000001" ;
                                                                        status = 124 ;
                                                                        text =
                                                                            ''
                                                                                # shellcheck disable=SC2288,SC2034,SC2153
                                                                                RESOURCE="$( "$RESOURCES"/resources/'["production","repository","secrets"]' )" || exit 183
                                                                                echo -en "$RESOURCE"
                                                                            '' ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                3defdced7e7bdf575a71f0e23acd0dc7c12728571f054b420b9fce63168d50c903b80644262730f6f43de7b793a6067a1e95e80d72d73eb1735881488dca434e
                                                                            '';
                                                                        text = ''check-gc-roots-directory'' ;
                                                                    }
                                                                    { kludge = true ; process = "pre" ; text = "cat /tmp/DEBUG-148" ; }
                                                                    {
                                                                        process = "pre"  ;
                                                                        standard-output =
                                                                            ''
                                                                                WRONG_847b56a587af0fee4c31d77508798d83d2fefb3d452ac4ba0c244dc98d0945ac93a4184a3170dbd71297d5cf475941a668b05dd5bb6a6944d9120f73ff74d49d
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                7fab129b65bc834f7bbece94da6843524b688850162684ac321c050274af1995963572548f29bc99d2be0a5e21f0058e9a8c4f2f2869b125b95e0bbfb97c6fb4
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                655c0985d0c3f6e4078a017052230e009ea76d41a54fd53c3e87555b3d098a5a6982cef0be56ac0f0e38e174849dfff63b470a1c8ee67bbd2d5118840a724be4
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                WRONG 945522f9b04dfd64b166a788280214860cba646707a8e8250cb689381887735d3ed02c7b8981a4681285c768a685e2f3db6b275c11529e87fb9a0bceedd6824f
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    {
                                                                        process = "pre" ;
                                                                        standard-output =
                                                                            ''
                                                                                WRONG2 945522f9b04dfd64b166a788280214860cba646707a8e8250cb689381887735d3ed02c7b8981a4681285c768a685e2f3db6b275c11529e87fb9a0bceedd6824f
                                                                            '' ;
                                                                        text = "check-redis message valid-init set" ;
                                                                    }
                                                                    { process = "pre" ; text = "check-redis" ; }
                                                                    { kludge = true ; process = "post" ; text = "sleep 56s" ; }
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
                                                                                b0c9cd83b507693e7c65613f0419aa9477e32fd85a16d278a196e985ecb86bbcbf7da518cee000cf1770ff83007444a9598d3bd52b0c6eff34ec5aaa39fb4dbb
                                                                            '' ;
                                                                        text = "check-log" ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                a3630365ddf577e5346ec7308712778d31c4a7899795ac31bcdba710f29cc914690f72f97691988e73521426c5e4091fa2e713e3ed53bff0ab56b8bb6859f4e9
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
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                3f9e929cf44d1c3ad9e6411a7f0be82aa3721fa7d21c05cb730db9353f2b71ada185ba48e51a84b726c6972351ef6b2548ca1df513eddc92fac1b9e4e378b36c
                                                                            '' ;
                                                                        text = "check-redis message valid-release set" ;
                                                                    }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                4da9e3339b48613167f63a29d2bade2d276c111f4550a1f9c7f105683bb591bf92bf2e9f9ab6c6710266ce57ca2dc4101c0a47e626e9be116bbd7507d3b839a7
                                                                            '' ;
                                                                        text = "check-redis message valid-release set" ;
                                                                    }
                                                                    { process = "post" ; text = "check-redis" ; }
                                                                    {
                                                                        process = "post" ;
                                                                        standard-output =
                                                                            ''
                                                                                ec99c7a5829357c61bb8cb89673693455b0e1871fee43754b250b7ed4b656a2589beab4e2f78c3b983b9f77da9ebe434bce8559357fdce32b2db7d769d001f0f
                                                                            '';
                                                                        text = ''check-resources-directory --exclude .git'' ;
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
                                                                        ''github.wait_for_unit("network-online.target")''
                                                                        ''github.wait_for_unit("github.service")''
                                                                        ''client.wait_for_unit("network-online.target")''
                                                                        ''client.wait_for_unit("log.service")''
                                                                        ''client.wait_for_unit("release.service")''
                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/execute 5845348478965617")''
                                                                        # ''client.copy_from_host_machine(".","/tmp/documents/_3")''
                                                                    ] ;
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
