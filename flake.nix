# 4115944124362533
{
    inputs = { } ;
    outputs =
        { self } :
            {
                lib =
                    {
                        android-application ,
                        failure ,
                        fixture ,
                        lazy-shell-application ,
                        nixpkgs ,
                        node-package ,
                        portal ,
                        private ,
                        resource ,
                        sally ,
                        system ,
                        trump5000 ,
                        visa ,
                        visitor
                    } @primary :
                        let
                            _android-application = android-application.lib { } ;
                            _failure = failure.lib { } ;
                            _lazy-shell-application = lazy-shell-application.lib { } ;
                            _node-package = node-package.lib { } ;
                            _resource =
                                resource.lib
                                    {
                                        buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                        coreutils = pkgs.coreutils ;
                                        error-code = 111 ;
                                        findutils = pkgs.findutils ;
                                        invalid-init-channel = "invalid-init" ;
                                        invalid-release-channel = "invalid-release" ;
                                        flock = pkgs.flock ;
                                        gnused = pkgs.gnused ;
                                        log-channel = "log" ;
                                        mkDerivation = pkgs.stdenv.mkDerivation ;
                                        jq = pkgs.jq ;
                                        pstree = pkgs.pstree ;
                                        redis = pkgs.redis ;
                                        valid-init-channel = "valid-init" ;
                                        valid-release-channel = "valid-release" ;
                                        writeShellApplication = pkgs.writeShellApplication ;
                                    } ;
                            _sally = sally.lib
                                {
                                    lazy-shell-application = _lazy-shell-application.implementation ;
                                } ;
                            _trump5000 = trump5000.lib
                                {
                                    lazy-shell-application = _lazy-shell-application.implementation ;
                                } ;
                            _visa = visa.lib { } ;
                            _visitor = visitor.lib { } ;
                            implementation =
                                { config , lib , pkgs , ... } :
                                    let
                                        __resource =
                                            _resource.implementation
                                                {
                                                    config = config ;
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
#                                        resources =
#                                            pkgs.stdenv.mkDerivation
#                                                {
#                                                    installPhase = ''resources "$out"'' ;
#                                                    name = "resources" ;
#                                                    nativeBuildInputs =
#                                                        [
#                                                            (
#                                                                pkgs.writeShellApplication
#                                                                    {
#                                                                        name = "resources" ;
#                                                                        runtimeInputs =
#                                                                            [
#                                                                            ] ;
#                                                                        text =
#                                                                            let
#                                                                                clean =
#                                                                                    [
#                                                                                        ''
#                                                                                            mkdir --parents "$1"
#                                                                                        ''
#                                                                                        ''
#                                                                                            ln --symbolic ${ __resource.clean } "$1/clean.sh"
#                                                                                        ''
#                                                                                    ] ;
#                                                                                release =
#                                                                                    [
#                                                                                        ''
#                                                                                            mkdir --parents "$1"
#                                                                                        ''
#                                                                                        ''
#                                                                                            ln --symbolic ${ __resource.release } "$1/release.sh"
#                                                                                        ''
#                                                                                    ] ;
#                                                                                resources =
#                                                                                    _visitor.implementation
#                                                                                        {
#                                                                                            lambda =
#                                                                                                path : value :
#                                                                                                    [
#                                                                                                        ''
#                                                                                                            mkdir --parents "$1/resources"
#                                                                                                        ''
#                                                                                                        (
#                                                                                                            ''
#                                                                                                                ln --symbolic ${ __resource.resource ( { resources = ''"$RESOURCES"'' ; seed = path ; } // ( value null ) ) } "$1"/resources/'${ builtins.toJSON path }'
#                                                                                                            ''
#                                                                                                        )
#                                                                                                    ] ;
#                                                                                            list = path : list : builtins.concatLists list ;
#                                                                                            set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
#                                                                                        }
#                                                                                        {
#                                                                                            production =
#                                                                                                {
#                                                                                                    dot-ssh =
#                                                                                                        {
#                                                                                                             config =
#                                                                                                                {
#                                                                                                                    github =
#                                                                                                                        ignore :
#                                                                                                                            {
#                                                                                                                                error = 195 ;
#                                                                                                                                init =
#                                                                                                                                    ignore :
#                                                                                                                                        {
#                                                                                                                                            action =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs =
#                                                                                                                                                            { pkgs , resources , ... } :
#                                                                                                                                                                [
#                                                                                                                                                                    (
#                                                                                                                                                                        pkgs.writeShellApplication
#                                                                                                                                                                            {
#                                                                                                                                                                                name = "dot-ssh-configure" ;
#                                                                                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
#                                                                                                                                                                                text =
#                                                                                                                                                                                    ''
#                                                                                                                                                                                        # shellcheck disable=SC2288
#                                                                                                                                                                                        KNOWN_HOSTS="$( "$RESOURCES"/resources/'["production","dot-ssh","known-hosts","github"]' )" || exit 106
#                                                                                                                                                                                        ln --symbolic "$KNOWN_HOSTS" /gc-root/known-hosts
#                                                                                                                                                                                        # shellcheck disable=SC2288
#                                                                                                                                                                                        IDENTITY="$( "$RESOURCES"/resources/'["production","dot-ssh","identity","github"]' )" || exit 133
#                                                                                                                                                                                        ln --symbolic "$IDENTITY" /gc-root/identity
#                                                                                                                                                                                        cat > config.asc <<EOF
#                                                                                                                                                                                        Host github.com
#                                                                                                                                                                                            HostName ${ config.personal.secrets.host }
#                                                                                                                                                                                            User git
#                                                                                                                                                                                            IdentityFile $IDENTITY/identity.asc
#                                                                                                                                                                                            UserKnownHostsFile $KNOWN_HOSTS/known-hosts.asc
#                                                                                                                                                                                            StrictHostKeyChecking no
#                                                                                                                                                                                        EOF
#                                                                                                                                                                                        chmod 0400 config.asc
#                                                                                                                                                                                    '' ;
#                                                                                                                                                                            }
#                                                                                                                                                                    )
#                                                                                                                                                                ] ;
#                                                                                                                                                        text = "dot-ssh-configure" ;
#                                                                                                                                                    } ;
#                                                                                                                                            recovery =
#                                                                                                                                                {
#                                                                                                                                                    fail =
#                                                                                                                                                        ignore :
#                                                                                                                                                            {
#                                                                                                                                                                targetPkgs = pkgs : [ pkgs.coreutils ] ;
#                                                                                                                                                                text =
#                                                                                                                                                                    ''
#                                                                                                                                                                        echo 7179669781491843
#                                                                                                                                                                        exit 117
#                                                                                                                                                                    '' ;
#                                                                                                                                                            } ;
#                                                                                                                                                    pass =
#                                                                                                                                                        ignore :
#                                                                                                                                                            {
#                                                                                                                                                                targetPkgs = pkgs : [ pkgs.coreutils ] ;
#                                                                                                                                                                text =
#                                                                                                                                                                    ''
#                                                                                                                                                                        echo 8921335538452797
#                                                                                                                                                                    '' ;
#                                                                                                                                                            } ;
#                                                                                                                                                } ;
#                                                                                                                                        } ;
#                                                                                                                                release =
#                                                                                                                                    ignore :
#                                                                                                                                        {
#                                                                                                                                            action =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs = { pkgs , ... } : [ ] ;
#                                                                                                                                                        text =
#                                                                                                                                                            ''
#                                                                                                                                                            '' ;
#                                                                                                                                                    } ;
#                                                                                                                                            recovery =
#                                                                                                                                                {
#                                                                                                                                                    check =
#                                                                                                                                                        ignore :
#                                                                                                                                                            {
#                                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils  ] ;
#                                                                                                                                                                text =
#                                                                                                                                                                    ''
#                                                                                                                                                                        echo 9131352568195371
#                                                                                                                                                                    '' ;
#                                                                                                                                                            } ;
#                                                                                                                                                } ;
#                                                                                                                                        } ;
#                                                                                                                                targets = [ "config.asc" ] ;
#                                                                                                                                temporary = false ;
#                                                                                                                            } ;
#                                                                                                                } ;
#                                                                                                            identity =
#                                                                                                                {
#                                                                                                                    github =
#                                                                                                                        ignore :
#                                                                                                                            {
#                                                                                                                                error = 195 ;
#                                                                                                                                init =
#                                                                                                                                    ignore :
#                                                                                                                                        {
#                                                                                                                                            action =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs =
#                                                                                                                                                            { pkgs , ... } :
#                                                                                                                                                                [
#                                                                                                                                                                    (
#                                                                                                                                                                        pkgs.writeShellApplication
#                                                                                                                                                                            {
#                                                                                                                                                                                name = "identity" ;
#                                                                                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
#                                                                                                                                                                                text =
#                                                                                                                                                                                    ''
#                                                                                                                                                                                        cat ${ config.personal.temporary.ssh.identity } > "identity.asc"
#                                                                                                                                                                                        chmod 0400 "identity.asc"
#                                                                                                                                                                                    '' ;
#                                                                                                                                                                            }
#                                                                                                                                                                    )
#                                                                                                                                                                ] ;
#                                                                                                                                                        text = "identity" ;
#                                                                                                                                                    } ;
#                                                                                                                                        } ;
#                                                                                                                                release =
#                                                                                                                                    ignore :
#                                                                                                                                        {
#                                                                                                                                            action =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs = { pkgs , ... } : [ ] ;
#                                                                                                                                                        text =
#                                                                                                                                                            ''
#                                                                                                                                                            '' ;
#                                                                                                                                                    } ;
#                                                                                                                                            recovery =
#                                                                                                                                                {
#                                                                                                                                                    check =
#                                                                                                                                                        ignore :
#                                                                                                                                                            {
#                                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils  ] ;
#                                                                                                                                                                text =
#                                                                                                                                                                    ''
#                                                                                                                                                                        echo 9131352568195371
#                                                                                                                                                                    '' ;
#                                                                                                                                                            } ;
#                                                                                                                                                } ;
#                                                                                                                                        } ;
#                                                                                                                                targets = [ "identity.asc" ] ;
#                                                                                                                                temporary = false ;
#                                                                                                                            } ;
#                                                                                                                } ;
#                                                                                                             known-hosts =
#                                                                                                                {
#                                                                                                                    github =
#                                                                                                                        ignore :
#                                                                                                                            {
#                                                                                                                                error = 195 ;
#                                                                                                                                init =
#                                                                                                                                    ignore :
#                                                                                                                                        {
#                                                                                                                                            action =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs =
#                                                                                                                                                            { pkgs , ... } :
#                                                                                                                                                                [
#                                                                                                                                                                    (
#                                                                                                                                                                        pkgs.writeShellApplication
#                                                                                                                                                                            {
#                                                                                                                                                                                name = "known-hosts" ;
#                                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.openssh ] ;
#                                                                                                                                                                                text =
#                                                                                                                                                                                    _visitor.implementation
#                                                                                                                                                                                        {
#                                                                                                                                                                                            null =
#                                                                                                                                                                                                path : value :
#                                                                                                                                                                                                    ''
#                                                                                                                                                                                                        ssh-keyscan ${ config.personal.secrets.host } > "known-hosts.asc"
#                                                                                                                                                                                                        chmod 0400 "known-hosts.asc"
#                                                                                                                                                                                                    '' ;
#                                                                                                                                                                                            path =
#                                                                                                                                                                                                path : value :
#                                                                                                                                                                                                    ''
#                                                                                                                                                                                                        cat ${ value } > "known-hosts.asc"
#                                                                                                                                                                                                        chmod 0400 "known-hosts.asc"
#                                                                                                                                                                                                    '' ;
#                                                                                                                                                                                        }
#                                                                                                                                                                                        config.personal.secrets.known-hosts ;
#                                                                                                                                                                            }
#                                                                                                                                                                    )
#                                                                                                                                                                ] ;
#                                                                                                                                                        text = "known-hosts" ;
#                                                                                                                                                    } ;
#                                                                                                                                        } ;
#                                                                                                                                release =
#                                                                                                                                    ignore :
#                                                                                                                                        {
#                                                                                                                                            action =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs = { pkgs , ... } : [ ] ;
#                                                                                                                                                        text =
#                                                                                                                                                            ''
#                                                                                                                                                            '' ;
#                                                                                                                                                    } ;
#                                                                                                                                            recovery =
#                                                                                                                                                {
#                                                                                                                                                    check =
#                                                                                                                                                        ignore :
#                                                                                                                                                            {
#                                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils  ] ;
#                                                                                                                                                                text =
#                                                                                                                                                                    ''
#                                                                                                                                                                        echo 9131352568195371
#                                                                                                                                                                    '' ;
#                                                                                                                                                            } ;
#                                                                                                                                                } ;
#                                                                                                                                        } ;
#                                                                                                                                targets = [ "known-hosts.asc" ] ;
#                                                                                                                                temporary = false ;
#                                                                                                                            } ;
#                                                                                                                } ;
#                                                                                                        } ;
#                                                                                                    repository =
#                                                                                                        {
#                                                                                                            secrets =
#                                                                                                                ignore :
#                                                                                                                    {
#                                                                                                                        error = 195 ;
#                                                                                                                        init =
#                                                                                                                            ignore :
#                                                                                                                                {
#                                                                                                                                    action =
#                                                                                                                                        ignore :
#                                                                                                                                            {
#                                                                                                                                                targetPkgs =
#                                                                                                                                                    { pkgs , ... } :
#                                                                                                                                                        [
#                                                                                                                                                            pkgs.git
#                                                                                                                                                            (
#                                                                                                                                                                pkgs.writeShellApplication
#                                                                                                                                                                    {
#                                                                                                                                                                        name = "configure-ssh" ;
#                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.openssh ] ;
#                                                                                                                                                                        text =
#                                                                                                                                                                            ''
#                                                                                                                                                                                ln --symbolic ${ pkgs.openssh } /gc-root/open-ssh
#                                                                                                                                                                                # shellcheck disable=SC2288
#                                                                                                                                                                                CONFIG="$( "$RESOURCES"/resources/'["production","dot-ssh","config","github"]' )" || exit 172
#                                                                                                                                                                                git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $CONFIG/config.asc"
#                                                                                                                                                                                ln --symbolic "$CONFIG" /gc-root/config
#                                                                                                                                                                             '' ;
#                                                                                                                                                                    }
#                                                                                                                                                            )
#                                                                                                                                                        ] ;
#                                                                                                                                                text =
#                                                                                                                                                    ''
#                                                                                                                                                        git init 2>&1
#                                                                                                                                                        configure-ssh
#                                                                                                                                                        git config user.email "${ config.personal.secrets.email }"
#                                                                                                                                                        git config user.name "${ config.personal.secrets.name }"
#                                                                                                                                                        git remote add origin "${ config.personal.secrets.remotes.ssh }"
#                                                                                                                                                        git fetch origin "${ config.personal.secrets.branch }" 2>&1
#                                                                                                                                                        git checkout "${ config.personal.secrets.branch }" 2>&1
#                                                                                                                                                    '' ;
#                                                                                                                                            } ;
#                                                                                                                                } ;
#                                                                                                                        release =
#                                                                                                                            ignore :
#                                                                                                                                {
#                                                                                                                                    action =
#                                                                                                                                        ignore :
#                                                                                                                                            {
#                                                                                                                                                targetPkgs = { pkgs , ... } : [ pkgs.coreutils pkgs.findutils pkgs.git ] ;
#                                                                                                                                                text =
#                                                                                                                                                    ''
#                                                                                                                                                        git push origin HEAD 2>&1
#                                                                                                                                                    '' ;
#                                                                                                                                            } ;
#                                                                                                                                    recovery =
#                                                                                                                                        {
#                                                                                                                                            recoverable =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs = { pkgs , ... } : [ pkgs.coreutils ] ;
#                                                                                                                                                        text =
#                                                                                                                                                            ''
#                                                                                                                                                                echo RECOVERABLE
#                                                                                                                                                            '' ;
#                                                                                                                                                    } ;
#                                                                                                                                            unrecoverable =
#                                                                                                                                                ignore :
#                                                                                                                                                    {
#                                                                                                                                                        targetPkgs = { pkgs , ... } : [ pkgs.coreutils ] ;
#                                                                                                                                                        text =
#                                                                                                                                                            ''
#                                                                                                                                                                echo UNRECOVERABLE >&2
#                                                                                                                                                                exit 110
#                                                                                                                                                            '' ;
#                                                                                                                                                    } ;
#                                                                                                                                        } ;
#                                                                                                                                } ;
#                                                                                                                        targets = [ ".git" "dot-gnupg" "dot-ssh" "github" ] ;
#                                                                                                                        temporary = false ;
#                                                                                                                    } ;
#                                                                                                        } ;
#                                                                                                } ;
#                                                                                        } ;
#                                                                                in builtins.concatStringsSep "\n" ( builtins.concatLists [ clean release resources ] ) ;
#                                                                    }
#                                                            )
#                                                        ] ;
#                                                    src = ./. ;
#                                                } ;
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
#                                                                        RESOURCES = "${ builtins.toString resources }" ;
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
                                                imports =
                                                    [
                                                        _failure.implementation
                                                        _visitor.implementation
                                                        _lazy-shell-application.implementation
                                                        _visa.implementation
                                                        _node-package.implementation
                                                        _visitor.implementation
                                                    ] ;
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
                            pkgs =
                                import nixpkgs
                                    {
                                        inherit system ;
                                        config =
                                            {
                                                allowUnfree = true ;
                                                android_sdk.accept_license = true ;
                                            } ;
                                    } ;
                    in
                        {
                            checks =
                                builtins.listToAttrs
                                    (
                                        let
                                            generator =
                                                index :
                                                    let
                                                        l = builtins.elemAt list index ;
                                                        in
                                                            {
                                                                name = builtins.concatStringsSep "-" [ "check" ( builtins.toString ( index + 1 ) ) ] ;
                                                                value = l.test ;
                                                            } ;
                                            list =
                                                builtins.sort
                                                    (
                                                        a : b :
                                                            if builtins.elem a.type b.obviated-by && builtins.elem b.type a.obviated-by then builtins.throw "circular dependency"
                                                            else if builtins.elem a.type b.obviated-by then true
                                                            else if builtins.elem b.type a.obviated-by then false
                                                            else "${ a.test }" < "${ b.test }"
                                                    )
                                                    (
                                                        builtins.foldl'
                                                            (
                                                                previous : current :
                                                                    let
                                                                        closure =
                                                                            builtins.concatLists
                                                                                [
                                                                                    current.obviated-by
                                                                                    (
                                                                                        builtins.map
                                                                                            ( p : p.obviated-by )
                                                                                            (
                                                                                                builtins.filter
                                                                                                    ( p : builtins.elem p.type current.obviated-by )
                                                                                                    previous
                                                                                            )
                                                                                    )
                                                                                ] ;
                                                                        in
                                                                            builtins.concatLists
                                                                                [
                                                                                    (
                                                                                        builtins.map
                                                                                            (
                                                                                                p :
                                                                                                    {
                                                                                                        obviated-by = builtins.concatLists [ p.obviated-by ( if builtins.elem current.type p.obviated-by then closure else [ ] ) ] ;
                                                                                                        test = p.test ;
                                                                                                        type = p.type ;
                                                                                                    }
                                                                                            )
                                                                                            previous
                                                                                    )
                                                                                    [
                                                                                        {
                                                                                            obviated-by = closure ;
                                                                                            test = current.test ;
                                                                                            type = current.type ;
                                                                                        }
                                                                                    ]
                                                                                ]
                                                            )
                                                            [ ]
                                                            [
    #                                                                            (
    #                                                                                _failure.check
    #                                                                                    {
    #                                                                                        obviated-by = [ ] ;
    #                                                                                        nixosTest = pkgs.nixosTest ;
    #                                                                                    }
    #                                                                                    {
    #                                                                                        compile-time-arguments = [ "6699768429138615" ] ;
    #                                                                                        planned-error = 182 ;
    #                                                                                        unplanned-error = 162 ;
    #                                                                                    }
    #                                                                                    {
    #                                                                                        run-time-arguments = [ "9641181236542922" ] ;
    #                                                                                    }
    #                                                                            )
    #                                                                            (
    #                                                                                _visitor.check
    #                                                                                    {
    #                                                                                        obviated-by = [ "failure" ] ;
    #                                                                                        failure = _failure.implementation ;
    #                                                                                        nixosTest = pkgs.nixosTest ;
    #                                                                                    }
    #                                                                                    {
    #                                                                                        arguments = null ;
    #                                                                                        success = true ;
    #                                                                                        value = null ;
    #                                                                                        visitors = { null = path : value : value ; } ;
    #                                                                                    }
    #                                                                            )
    #                                                                            (
    #                                                                                _lazy-shell-application.check
    #                                                                                    {
    #                                                                                        failure = _failure.implementation ;
    #                                                                                        obviated-by = [ "failure" "visitor" ] ;
    #                                                                                        nixosTest = pkgs.nixosTest ;
    #                                                                                        test-setup =
    #                                                                                            ''
    #                                                                                                echo -n 4899124582768405 > /tmp/test-6439766751988115
    #                                                                                                echo -n 1690621093050334 > /tmp/test-7929034698529557
    #                                                                                            '' ;
    #                                                                                        visitor = _visitor.implementation ;
    #                                                                                    }
    #                                                                                    {
    #                                                                                        mounts =
    #                                                                                            {
    #                                                                                                test-3727269441937947 = { type = "tmp" ; } ;
    #                                                                                                test-7115328188030250 = { source = "/tmp/test-6439766751988115" ; type = "bind" ; } ;
    #                                                                                                test-7482109308014871 = { source = "/tmp/test-7929034698529557" ; type = "ro-bind" ; } ;
    #                                                                                            } ;
    #                                                                                        name = "test-application" ;
    #                                                                                        runtime-inputs = pkgs : [ pkgs.coreutils pkgs.which pkgs.yq ] ;
    #                                                                                        post = null ;
    #                                                                                        text =
    #                                                                                            ''
    #                                                                                                echo -n "$1"
    #                                                                                                exit 120
    #                                                                                            '' ;
    #                                                                                    }
    #                                                                                    {
    #                                                                                        arguments = [ "8153426608580965" ] ;
    #                                                                                        standard-error = "" ;
    #                                                                                        standard-input = null ;
    #                                                                                        standard-output = "8153426608580965" ;
    #                                                                                        status = 120 ;
    #                                                                                    }
    #                                                                            )
    #                                                                            (
    #                                                                                _visa.check
    #                                                                                    {
    #                                                                                        failure = _failure.implementation ;
    #                                                                                        lazy-shell-application = _lazy-shell-application.implementation ;
    #                                                                                        node-package = _node-package.implementation ;
    #                                                                                        obviated-by = [ "failure" "lazy-shell-application" "node-package" ] ;
    #                                                                                        nixosTest = pkgs.nixosTest ;
    #                                                                                    }
    #                                                                            )
                                                            ]
                                                    ) ;
                                        in builtins.genList generator ( builtins.length list )
                                    ) ;
                                    implementation = implementation ;
                                } ;
            } ;
}

