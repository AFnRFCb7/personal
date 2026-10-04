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
                            _visa = visa.lib { lazy-shell-application = _lazy-shell-application.implementation ; } ;
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
                                                        # imports = [ _trump5000.implementation ] ;
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
                                                        systemd =
                                                            {
                                                                services =
                                                                    {
                                                                        log =
                                                                            {
                                                                                after = [ "network.target" "redis.service" ] ;
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
                                                imports =
                                                    [
                                                        _failure.implementation
                                                        _visitor.implementation
                                                        # _sally.implementation
                                                        # _visa.implementation
                                                        # _trump5000.implementation
                                                        # _android-application.implementation
                                                        # _node-package.implementation
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
                                private :
                                    let
                                        client =
                                            { nodes , ... }  :
                                                {
                                                    fileSystems."/tmp" =
                                                        {
                                                            fsType = "vboxsf" ;
                                                            device = "beta" ;
                                                            options =
                                                                [
                                                                    "rw"
                                                                    "nofail"
                                                                ] ;
                                                        } ;
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
                                                                                                        cp --dereference --recursive ${ shared }/repository/secrets/ciphertext/* .
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
                                                                                artifacts =
                                                                                    {
                                                                                        github =
                                                                                            index :
                                                                                                builtins.toFile
                                                                                                    "config.asc"
                                                                                                    ''
                                                                                                        Host github.com
                                                                                                            HostName ${ ip }
                                                                                                            User git
                                                                                                            IdentityFile /home/checker/resources/mounts/${ pkgs.lib.fixedWidthString 16 "0" ( builtins.toString ( index + 2 ) ) }/identity.asc
                                                                                                            UserKnownHostsFile /home/checker/resources/mounts/${ pkgs.lib.fixedWidthString 16 "0" ( builtins.toString ( index + 1 ) ) }/known-hosts.asc
                                                                                                            StrictHostKeyChecking no
                                                                                                    '' ;
                                                                                    } ;
                                                                                branch = "main" ;
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
                                                                                ip = "192.168.2.234" ;
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
                                                                                in
                                                                                    ''
                                                                                        OUT="$1"
                                                                                        mkdir --parents  "$OUT"
                                                                                        mkdir --parents "$OUT/artifacts/production/dot-ssh/config/github"
                                                                                        ln --symbolic ${ artifacts.github 0 } "$OUT/artifacts/production/dot-ssh/config/github/config.asc"
                                                                                        mkdir --parents "$OUT/artifacts/production/dot-ssh/known-hosts/github"
                                                                                        mkdir --parents "$OUT/artifacts/production/dot-ssh/identity/github"
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
                                                                                        mkdir --parents "$OUT/hashes"
                                                                                        echo -n "0de3b11f7c8aa1c54b6ebc7e7f3b7150d438ce0be9e3fd9a396983fba8cd116d0f4221c09312f0b426b48697d4ddf1d2c132672c063fdb219563417c4809c447" > "$OUT"/hashes/'["production","dot-ssh","config","github"]'
                                                                                        echo -n "6d6aa4a9f7504a8ae0dbc19fb4dc54d048b781b07f92ac0753f6f980954e66b3bea86219302c9e0bfb727301efae2766812ed8cf13af98fc0c592342f7fc0a6b" > "$OUT"/hashes/'["production","dot-ssh","identity","github"]'
                                                                                        echo -n "68b45fb93af883c4bf2105f8f5bd94c87499ffa9d180bf1a458dcfd02101a2cf86f81c5a14be784f294710e431125505407f79be96f6f38f292f8bfb81556880" > "$OUT"/hashes/'["production","dot-ssh","known-hosts","github"]'
                                                                                        echo -n "2cf9b5764e63babd485f143c543d41935a3c2cab0046ed26422e78f6ccb4c45ece30497d74bd55cd0c65e3d62f95248cdeb953fe67d9d6c67428751d625ff5cb" > "$OUT"/hashes/'["production","repository","secrets"]'
                                                                                        mkdir --parents "$OUT/release"
                                                                                        echo -n "/nix/store/hrzb6v6x1cfi417sd7ml8nd56a6niaky-release/bin/release" > "$OUT"/release/'["production","dot-ssh","config","github"]'.sh
                                                                                        ln --symbolic "$OUT"/release/'["production","dot-ssh","config","github"]'.sh "$OUT"/release/'["production","dot-ssh","identity","github"]'.sh
                                                                                        ln --symbolic "$OUT"/release/'["production","dot-ssh","config","github"]'.sh "$OUT"/release/'["production","dot-ssh","known-hosts","github"]'.sh
                                                                                        echo -n "/nix/store/8zy742iw3jdphs0p4jlphfgqr9zxi4gg-release/bin/release" > "$OUT"/release/'["production","repository","secrets"]'.sh
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
                                            tests =
                                                let
                                                    generic =
                                                        {
                                                            case ,
                                                            command ,
                                                            exclusions ,
                                                            init ,
                                                            non-deterministic-regular-files ,
                                                            order ,
                                                            release ,
                                                            stage
                                                        } :
                                                            let
                                                                files =
                                                                    let
                                                                        init-array =
                                                                            builtins.concatLists
                                                                                [
                                                                                    generic-parameters.init.action.files
                                                                                    [
                                                                                        {
                                                                                            name = "/home/checker/.gc-roots" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/.gc-roots/0000000000000000" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/canonical" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/invalid-init" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/mounts" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/mounts/0000000000000000" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/release" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            cat = builtins.toString size ;
                                                                                            name = "/home/checker/resources/sequential" ;
                                                                                            stat = "-rw-r--r--" ;
                                                                                            type = "sequential file" ;
                                                                                        }
                                                                                    ]
                                                                                ] ;
                                                                        release-array =
                                                                            builtins.concatLists
                                                                                [
                                                                                    [
                                                                                        {
                                                                                            name = "/home/checker/.gc-roots" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/canonical" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/invalid-init" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/invalid-release" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/mounts" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            name = "/home/checker/resources/release" ;
                                                                                            stat = "drwxr-xr-x" ;
                                                                                            type = "directory" ;
                                                                                        }
                                                                                        {
                                                                                            cat = builtins.toString size ;
                                                                                            name = "/home/checker/resources/sequential" ;
                                                                                            stat = "-rw-r--r--" ;
                                                                                            type = "sequential file" ;
                                                                                        }
                                                                                    ]
                                                                                ] ;
                                                                        in
                                                                            {
                                                                                clean =
                                                                                    {
                                                                                        true =
                                                                                            {
                                                                                                true =
                                                                                                    jq.files
                                                                                                        [
                                                                                                            {
                                                                                                                name = "/home/checker/.gc-roots" ;
                                                                                                                stat = "drwxr-xr-x" ;
                                                                                                                type = "directory" ;
                                                                                                            }
                                                                                                            {
                                                                                                                name = "/home/checker/resources" ;
                                                                                                                stat = "drwxr-xr-x" ;
                                                                                                                type = "directory" ;
                                                                                                            }
                                                                                                        ] ;
                                                                                                false = files.release.true.false ;
                                                                                            } ;
                                                                                        false =
                                                                                            {
                                                                                                true = files.clean.true.true ;
                                                                                                false = files.release.false.false ;
                                                                                            } ;
                                                                                    } ;
                                                                                empty =
                                                                                    jq.files
                                                                                        [
                                                                                            {
                                                                                                name = "/home/checker/resources" ;
                                                                                                stat = "drwxr-xr-x" ;
                                                                                                type = "directory" ;
                                                                                            }
                                                                                            {
                                                                                                log = [ ] ;
                                                                                                name = "/home/checker/resources/log.yaml" ;
                                                                                                stat = "-rw-r--r--" ;
                                                                                                type = "log file" ;
                                                                                            }
                                                                                        ] ;
                                                                                init =
                                                                                    {
                                                                                        true =
#                                                                                            jq.files_
#                                                                                                init-array
#                                                                                                false
#                                                                                                false
#                                                                                                (
#                                                                                                    let
#                                                                                                        mapper =
#                                                                                                            { index , seed , standard-output , targets , text } :
#                                                                                                                {
#                                                                                                                    channel = "valid-init" ;
#                                                                                                                    payload =
#                                                                                                                        {
#                                                                                                                            arguments = [ ] ;
#                                                                                                                            index = index ;
#                                                                                                                            inputs = { } ;
#                                                                                                                            seed = seed ;
#                                                                                                                            standard-output = standard-output ;
#                                                                                                                            targets = targets ;
#                                                                                                                            temporary = false ;
#                                                                                                                            text = text ;
#                                                                                                                        } ;
#                                                                                                                    type = "message" ;
#                                                                                                                } ;
#                                                                                                        in builtins.map mapper generic-parameters.init.action.messages
#                                                                                                ) ;
                                                                                            jq.array
                                                                                                init-array
                                                                                                [
                                                                                                    {
                                                                                                        log =
                                                                                                            let
                                                                                                                mapper =
                                                                                                                    { index , seed , standard-output , targets , text } :
                                                                                                                        {
                                                                                                                            channel = "valid-init" ;
                                                                                                                            payload =
                                                                                                                                {
                                                                                                                                    arguments = [ ] ;
                                                                                                                                    index = index ;
                                                                                                                                    inputs = { } ;
                                                                                                                                    seed = seed ;
                                                                                                                                    standard-output = standard-output ;
                                                                                                                                    targets = targets ;
                                                                                                                                    temporary = false ;
                                                                                                                                    text = text ;
                                                                                                                                } ;
                                                                                                                            type = "message" ;
                                                                                                                        } ;
                                                                                                                in builtins.map mapper generic-parameters.init.action.messages ;
                                                                                                        name = "/home/checker/resources/log.yaml" ;
                                                                                                        stat = "-rw-r--r--" ;
                                                                                                        type = "log file" ;
                                                                                                    }
                                                                                                    {
                                                                                                        name = "/home/checker/resources/canonical/${ builtins.readFile "${ shared }/hashes/${ builtins.head ( builtins.match ".*resources/'(.*)' *" generic-parameters.command ) }" }" ;
                                                                                                        stat = "lrwxrwxrwx" ;
                                                                                                        target = "/home/checker/resources/mounts/0000000000000000" ;
                                                                                                        type = "symbolic link" ;
                                                                                                    }
                                                                                                    {
                                                                                                        name = "/home/checker/resources/release/0000000000000000" ;
                                                                                                        stat = "lrwxrwxrwx" ;
                                                                                                        target = generic-parameters.release.script ;
                                                                                                        type = "symbolic link" ;
                                                                                                    }
                                                                                                ] ;
                                                                                        false =
                                                                                            jq.array
                                                                                                (
                                                                                                    builtins.filter
                                                                                                        ( i : i.type != "regular file" )
                                                                                                        init-array
                                                                                                )
                                                                                                (
                                                                                                    builtins.concatLists
                                                                                                        [
                                                                                                            [
                                                                                                                {
                                                                                                                    log =
                                                                                                                        [
                                                                                                                            {
                                                                                                                                channel = "invalid-release" ;
                                                                                                                                payload =
                                                                                                                                    {
                                                                                                                                        index = "0000000000000000" ;
                                                                                                                                        standard-output = generic-parameters.release.action.standard-output ;
                                                                                                                                        status = generic-parameters.release.action.status ;
                                                                                                                                    } ;
                                                                                                                                type = "message" ;
                                                                                                                            }
                                                                                                                        ] ;
                                                                                                                    name = "/home/checker/resources/log.yaml" ;
                                                                                                                    stat = "-rw-r--r--" ;
                                                                                                                    type = "log file" ;
                                                                                                                }
                                                                                                                {
                                                                                                                    name = "/home/checker/resources/invalid-release" ;
                                                                                                                    stat = "drwxr-xr-x" ;
                                                                                                                    type = "directory" ;
                                                                                                                }
                                                                                                                {
                                                                                                                    name = "/home/checker/resources/invalid-release/0000000000000000" ;
                                                                                                                    stat = "drwxr-xr-x" ;
                                                                                                                    type = "directory" ;
                                                                                                                }
                                                                                                            ]
                                                                                                            (
                                                                                                                let
                                                                                                                    mapper =
                                                                                                                        { path , target } :
                                                                                                                            {
                                                                                                                                name = "/home/checker/resources/invalid-release/0000000000000000/${ builtins.toJSON path }.sh" ;
                                                                                                                                stat = "lrwxrwxrwx" ;
                                                                                                                                target = target ;
                                                                                                                                type = "symbolic link" ;
                                                                                                                            } ;
                                                                                                                    in builtins.map mapper generic-parameters.release.recovery.scripts
                                                                                                            )
                                                                                                        ]
                                                                                                ) ;
                                                                                    } ;
                                                                                release =
                                                                                    {
                                                                                        true =
                                                                                            {
                                                                                                true =
                                                                                                    jq.array
                                                                                                        release-array
                                                                                                        [
                                                                                                            {
                                                                                                                log =
                                                                                                                    let
                                                                                                                        mapper =
                                                                                                                            { channel , index , standard-output , status } :
                                                                                                                                {
                                                                                                                                    channel = channel ;
                                                                                                                                    payload =
                                                                                                                                        {
                                                                                                                                            index = pkgs.lib.fixedWidthString 16 "0" ( builtins.toString index ) ;
                                                                                                                                            standard-output = standard-output ;
                                                                                                                                            status = status ;
                                                                                                                                        } ;
                                                                                                                                    type = "message" ;
                                                                                                                                } ;
                                                                                                                        in builtins.map mapper release.action.messages ;
                                                                                                                    name = "/home/checker/resources/log.yaml" ;
                                                                                                                    stat = "-rw-r--r--" ;
                                                                                                                    type = "log file" ;
                                                                                                            }
                                                                                                        ] ;
                                                                                                recovered =
                                                                                                    jq.array
                                                                                                        release-array
                                                                                                        [
                                                                                                            {
                                                                                                                log =
                                                                                                                    let
                                                                                                                        mapper =
                                                                                                                            { channel , index , standard-output , status } :
                                                                                                                                {
                                                                                                                                    channel = channel ;
                                                                                                                                    payload =
                                                                                                                                        {
                                                                                                                                            index = pkgs.lib.fixedWidthString 16 "0" ( builtins.toString index ) ;
                                                                                                                                            standard-output = standard-output ;
                                                                                                                                            status = status ;
                                                                                                                                        } ;
                                                                                                                                    type = "message" ;
                                                                                                                                } ;
                                                                                                                        in
                                                                                                                            builtins.map mapper
                                                                                                                                (
                                                                                                                                    [
                                                                                                                                        ( builtins.elemAt release.action.messages 0 )
                                                                                                                                        { channel = "valid-release" ; index = "0000000000000000" ; standard-output = "" ; status = 0 ; }
                                                                                                                                    ] ++ ( builtins.tail release.action.messages )
                                                                                                                                ) ;
                                                                                                                    name = "/home/checker/resources/log.yaml" ;
                                                                                                                    stat = "-rw-r--r--" ;
                                                                                                                    type = "log file" ;
                                                                                                            }
                                                                                                        ] ;
                                                                                                false =
                                                                                                    jq.files
                                                                                                        (
                                                                                                            builtins.concatLists
                                                                                                                [
                                                                                                                    (
                                                                                                                        builtins.filter
                                                                                                                            ( i : i.type != "regular file" || i.name == "/home/checker/resources/sequential" )
                                                                                                                            init-array
                                                                                                                    )
                                                                                                                    [
                                                                                                                        {
                                                                                                                            log =
                                                                                                                                [
                                                                                                                                    {
                                                                                                                                        channel = "invalid-release" ;
                                                                                                                                        payload =
                                                                                                                                            {
                                                                                                                                                index = "0000000000000000" ;
                                                                                                                                                standard-output = generic-parameters.release.action.standard-output ;
                                                                                                                                                status = generic-parameters.release.action.status ;
                                                                                                                                            } ;
                                                                                                                                        type = "message" ;
                                                                                                                                    }
                                                                                                                                ] ;
                                                                                                                            name = "/home/checker/resources/log.yaml" ;
                                                                                                                            stat = "-rw-r--r--" ;
                                                                                                                            type = "log file" ;
                                                                                                                        }
                                                                                                                        {
                                                                                                                            name = "/home/checker/resources/invalid-release" ;
                                                                                                                            stat = "drwxr-xr-x" ;
                                                                                                                            type = "directory" ;
                                                                                                                        }
                                                                                                                        {
                                                                                                                            name = "/home/checker/resources/invalid-release/0000000000000000" ;
                                                                                                                            stat = "drwxr-xr-x" ;
                                                                                                                            type = "directory" ;
                                                                                                                        }
                                                                                                                    ]
                                                                                                                    (
                                                                                                                        let
                                                                                                                            mapper =
                                                                                                                                { path , target } :
                                                                                                                                    {
                                                                                                                                        name = "/home/checker/resources/invalid-release/0000000000000000/${ builtins.toJSON path }.sh" ;
                                                                                                                                        stat = "lrwxrwxrwx" ;
                                                                                                                                        target = target ;
                                                                                                                                        type = "symbolic link" ;
                                                                                                                                    } ;
                                                                                                                            in builtins.map mapper generic-parameters.release.recovery.scripts
                                                                                                                    )
                                                                                                                ]
                                                                                                        ) ;
                                                                                            } ;
                                                                                        false =
                                                                                            {
                                                                                                true = null ;
                                                                                                false = null ;
                                                                                            } ;
                                                                                    } ;
                                                                            } ;
                                                                generic-parameters =
                                                                    {
                                                                        case = _visitor.implementation { list = path : list : builtins.throw "unsupported 6314294198285596" ; set = path : set : builtins.throw "unsupported 8389691287776329" ; string = path : value : value ; } case ;
                                                                        command = _visitor.implementation { list = path : list : builtins.throw "unsupported 5565718583448517" ; set = path : set : builtins.throw "unsupported 1975775495651532" ; string = path : value : value ; } command ;
                                                                        exclusions = _visitor.implementation { set = path : set : builtins.throw "unsupported 3513373234215328" ; string = path : value : value ; } exclusions ;
                                                                        init =
                                                                            let
                                                                                identity =
                                                                                    {
                                                                                        action ,
                                                                                        corruption ,
                                                                                        recovery
                                                                                    } :
                                                                                        {
                                                                                            action =
                                                                                                let
                                                                                                    identity =
                                                                                                        {
                                                                                                            files ,
                                                                                                            messages
                                                                                                        } :
                                                                                                            {
                                                                                                                files = _visitor.implementation { string = path : value : value ; } files ;
                                                                                                                messages = _visitor.implementation { int = path : value : value ; string = path : value : value ; } messages ;
                                                                                                            } ;
                                                                                                    in identity action ;
                                                                                            corruption = _visitor.implementation { bool = path : value : value ; } corruption ;
                                                                                            recovery = recovery ;
                                                                                        } ;
                                                                                in identity init ;
                                                                        non-deterministic-regular-files = _visitor.implementation { set = path : set : builtins.throw "unsupported 1272865764937351" ; string = path : value : value ; } non-deterministic-regular-files ;
                                                                        order = _visitor.implementation { int = path : value : value ; list = path : list : builtins.throw "unsupported 4882767679771347" ; set = path : set : builtins.throw "unsupported 7144156552857862" ; } order ;
                                                                        release =
                                                                            let
                                                                                identity =
                                                                                    {
                                                                                        action ,
                                                                                        recovery ,
                                                                                        script
                                                                                    } :
                                                                                        {
                                                                                            action =
                                                                                                let
                                                                                                    identity =
                                                                                                        {
                                                                                                            messages ,
                                                                                                            standard-output ,
                                                                                                            status
                                                                                                        } :
                                                                                                            {
                                                                                                                messages = _visitor.implementation { int = path : value : value ; string = path : value : value ; } messages ;
                                                                                                                standard-output = _visitor.implementation { null = path : value : value ; string = path : value : value ; } standard-output ;
                                                                                                                status = _visitor.implementation { int = path : value : value ; null = path : value : value ; } status ;
                                                                                                            } ;
                                                                                                    in identity action ;
                                                                                            recovery =
                                                                                                let
                                                                                                    identity =
                                                                                                        {
                                                                                                            standard-error ,
                                                                                                            standard-output ,
                                                                                                            status ,
                                                                                                            script ,
                                                                                                            scripts ,
                                                                                                            success
                                                                                                        } :
                                                                                                            let
                                                                                                                scripts_ = _visitor.implementation { null = path : value : [ ] ; string = path : value : value ; } scripts ;
                                                                                                                in
                                                                                                                    {
                                                                                                                        standard-error = _visitor.implementation { null = path : value : null ; string = path : value : value ; } standard-error ;
                                                                                                                        standard-output = _visitor.implementation { null = path : value : null ; string = path : value : value ; } standard-output ;
                                                                                                                        script = _visitor.implementation { null = path : value : value ; string = path : value : value ; } script ;
                                                                                                                        scripts = scripts_ ;
                                                                                                                        status = _visitor.implementation { int = path : value : value ; null = path : value : null ; } status ;
                                                                                                                        success = _visitor.implementation { bool = path : value : value ; null = path : value : true ; } success ;
                                                                                                                    } ;
                                                                                                    in identity recovery ;
                                                                                            script = _visitor.implementation { string = path : value : value ; } script ;
                                                                                        } ;
                                                                                in identity release ;
                                                                        stage =
                                                                            let
                                                                                identity =
                                                                                    {
                                                                                        action ,
                                                                                        corruption
                                                                                    } :
                                                                                        {
                                                                                            action =
                                                                                                let
                                                                                                    identity =
                                                                                                        {
                                                                                                            messages
                                                                                                        } :
                                                                                                            {
                                                                                                                messages = _visitor.implementation { int = path : value : value ; string = path : value : value ; } messages ;
                                                                                                            } ;
                                                                                                    in identity action ;
                                                                                            corruption = _visitor.implementation { bool = path : value : value ; } corruption ;
                                                                                        } ;
                                                                                in identity stage ;
                                                                    } ;
                                                                jq =
                                                                    let
                                                                        files = json : jq ( builtins.sort ( a : b : a.name < b.name ) json ) ;
                                                                        jq =
                                                                            json :
                                                                                let
                                                                                    derivation =
                                                                                        pkgs.runCommand
                                                                                            "data.json"
                                                                                            { nativeBuildInputs = [ pkgs.jq ] ; }
                                                                                            ''
                                                                                                jq --sort-keys "." ${ builtins.toFile "data.json" ( builtins.toJSON json ) } > $out
                                                                                            '' ;
                                                                                    in builtins.readFile derivation ;
                                                                        in
                                                                            {
                                                                                array = json : extra : files ( builtins.concatLists [ json extra ] ) ;
                                                                                files = files ;
                                                                                files_ =
                                                                                    base-array : corruption : log-file :
                                                                                        let
                                                                                            corrupted = builtins.filter ( t : ( ! corruption ) || ( t.type != "regular file" ) ) base-array ;
                                                                                            directories =
                                                                                                let
                                                                                                    grouper = { name , stat , type } : name ;
                                                                                                    mapper =
                                                                                                        { cat , name , stat , type } :
                                                                                                            {
                                                                                                                name = builtins.dirOf name ;
                                                                                                                stat = "drwxr-xr-x" ;
                                                                                                                type = "directory" ;
                                                                                                            } ;
                                                                                                    in builtins.attrValues ( builtins.mapAttrs builtins.head ( builtins.groupBy grouper ( builtins.map mapper base-array ) ) ) ;
                                                                                            log =
                                                                                                {
                                                                                                    log =
                                                                                                        let
                                                                                                            mapper =
                                                                                                                { index , seed , standard-output , targets , text } :
                                                                                                                    {
                                                                                                                        channel = "valid-init" ;
                                                                                                                        payload =
                                                                                                                            {
                                                                                                                                arguments = [ ] ;
                                                                                                                                index = index ;
                                                                                                                                inputs = { } ;
                                                                                                                                seed = seed ;
                                                                                                                                standard-output = standard-output ;
                                                                                                                                targets = targets ;
                                                                                                                                temporary = false ;
                                                                                                                                text = text ;
                                                                                                                            } ;
                                                                                                                        type = "message" ;
                                                                                                                    } ;
                                                                                                            in builtins.map mapper generic-parameters.init.action.messages ;
                                                                                                    name = "/home/checker/resources/log.yaml" ;
                                                                                                    stat = "-rw-r--r--" ;
                                                                                                    type = "log file" ;
                                                                                                } ;
                                                                                            sequential =
                                                                                                {
                                                                                                    cat = builtins.toString size ;
                                                                                                    name = "/home/checker/resources/sequential" ;
                                                                                                    stat = "-rw-r--r--" ;
                                                                                                    type = "sequential file" ;
                                                                                                } ;
                                                                                            symbolic-links =
                                                                                                {
                                                                                                    mount =
                                                                                                        {
                                                                                                            name = "/home/checker/resources/canonical/${ builtins.readFile "${ shared }/hashes/${ builtins.head ( builtins.match ".*resources/'(.*)' *" generic-parameters.command ) }" }" ;
                                                                                                            stat = "lrwxrwxrwx" ;
                                                                                                            target = "/home/checker/resources/mounts/0000000000000000" ;
                                                                                                            type = "symbolic link" ;
                                                                                                        } ;
                                                                                                    release =
                                                                                                        {
                                                                                                            name = "/home/checker/resources/release/0000000000000000" ;
                                                                                                            stat = "lrwxrwxrwx" ;
                                                                                                            target = generic-parameters.release.script ;
                                                                                                            type = "symbolic link" ;
                                                                                                        } ;
                                                                                                } ;
                                                                                            total =
                                                                                                builtins.concatLists
                                                                                                    [
                                                                                                        corrupted
                                                                                                        directories
                                                                                                        [ log sequential symbolic-links.mount symbolic-links.release ]
                                                                                                    ] ;
                                                                                            in jq total ;
                                                                                message = { channel , payload , type } : jq { channel = channel ; payload = payload ; type = type ; } ;
                                                                            } ;
                                                                messages =
                                                                    {
                                                                        init =
                                                                            {
                                                                                true = payload : jq.message { channel = "valid-init" ; payload = payload ; type = "message" ; } ;
                                                                                false = null ;
                                                                            } ;
                                                                        subscribe =
                                                                            let
                                                                                channels = [ "invalid-init" "invalid-release" "valid-init" "valid-release" ] ;
                                                                                generator =
                                                                                    index :
                                                                                        let
                                                                                            channel = builtins.elemAt channels index ;
                                                                                            in { name = channel ; value = jq.message { channel = channel ; payload = index + 1 ; type = "subscribe" ; } ; } ;
                                                                                in builtins.listToAttrs ( builtins.genList generator ( builtins.length channels ) ) ;
                                                                        release =
                                                                            {
                                                                                true =
                                                                                    {
                                                                                        true = payload : jq.message { channel = "valid-release" ; payload = payload ; type = "message" ; } ;
                                                                                        false = payload : jq.message { channel = "invalid-release" ; payload = payload ; type = "message" ; } ;
                                                                                    } ;
                                                                                false =
                                                                                    {
                                                                                        true = payload : jq.message { channel = "valid-init" ; payload = payload ; type = "message" ; } ;
                                                                                        false = payload : jq.message { channel = "invalid-init" ; payload = payload ; type = "message" ; } ;
                                                                                    } ;
                                                                            } ;
                                                                    } ;
                                                                sequences =
                                                                    {
                                                                        clean =
                                                                            [
                                                                                {
                                                                                    process = "post" ;
                                                                                    status =
                                                                                        if generic-parameters.init.corruption then
                                                                                            if generic-parameters.release.recovery.success then 0
                                                                                            else 124
                                                                                        else 0 ;
                                                                                    text = '' "$RESOURCES"/clean.sh '' ;
                                                                                }
                                                                                {
                                                                                    process = "post" ;
                                                                                    text = "force-sync" ;
                                                                                }
                                                                                {
                                                                                    process = "post" ;
                                                                                    reads = false ;
                                                                                    standard-output = if generic-parameters.release.recovery.success then files.clean.true.true else files.clean.true.false ;
                                                                                    text =
                                                                                        ''
                                                                                            check-files --delete true --exclusion "*.flag" --exclusion "*.lock" ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--exclusion ${ ndrf }" ) generic-parameters.exclusions ) } ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--non-deterministic-regular-file ${ ndrf }" ) generic-parameters.non-deterministic-regular-files ) }
                                                                                        '' ;
                                                                                }
                                                                                {
                                                                                    process = "post" ;
                                                                                    standard-output = "183" ;
                                                                                    text = "check-redis" ;
                                                                                }
                                                                            ] ;
                                                                        init =
                                                                            {
                                                                                action =
                                                                                    if generic-parameters.stage.corruption then [ ]
                                                                                    else
                                                                                        builtins.concatLists
                                                                                            [
                                                                                                [
                                                                                                    {
                                                                                                            process = "pre" ;
                                                                                                            standard-output = "/home/checker/resources/mounts/0000000000000000" ;
                                                                                                            text = generic-parameters.command ;
                                                                                                    }
                                                                                                    {
                                                                                                            process = "pre" ;
                                                                                                            text = "force-sync" ;
                                                                                                    }
                                                                                                    {
                                                                                                            fix =
                                                                                                                ''
                                                                                                                    DIRNAME="$( dirname "$0" )" || exit 122
                                                                                                                    mapfile -t TARGETS < <(
                                                                                                                        sed \
                                                                                                                            -n \
                                                                                                                            -e 's/^-.*"target": "\(.*\)",$/\1/p' \
                                                                                                                            -e 's/^+.*"target": "\(.*\)",$/\1/p' \
                                                                                                                            "$DIRNAME/diff"
                                                                                                                    )
                                                                                                                    OLD_TARGET="${ builtins.concatStringsSep "" [ "$" "{" "TARGETS[0]" "}" ] }"
                                                                                                                    NEW_TARGET="${ builtins.concatStringsSep "" [ "$" "{" "TARGETS[1]" "}" ] }"
                                                                                                                    sed \
                                                                                                                        -i \
                                                                                                                        "s#$OLD_TARGET#$NEW_TARGET#" \
                                                                                                                        personal/flake.nix
                                                                                                                '' ;
                                                                                                            process = "pre" ;
                                                                                                            reads = false ;
                                                                                                            standard-output = files.init.true ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    check-files --delete false --exclusion "*.flag" --exclusion "*.lock" ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--exclusion ${ ndrf }" ) generic-parameters.exclusions ) } ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--non-deterministic-regular-file ${ ndrf }" ) generic-parameters.non-deterministic-regular-files ) }
                                                                                                                '' ;
                                                                                                    }
                                                                                                ]
                                                                                                (
                                                                                                    let
                                                                                                        mapper =
                                                                                                            init :
                                                                                                                {
                                                                                                                    process = "pre" ;
                                                                                                                    standard-output = messages.init.true ( { arguments = [ ] ; inputs = { } ; temporary = false ; } // init ) ;
                                                                                                                    text = ''check-redis --exclude'' ;
                                                                                                                } ;
                                                                                                        in builtins.map mapper generic-parameters.init.action.messages
                                                                                                )
                                                                                                [
                                                                                                    {
                                                                                                            process = "pre" ;
                                                                                                            standard-output = "183" ;
                                                                                                            text = "check-redis" ;
                                                                                                    }
                                                                                                    {
                                                                                                            process = "mid" ;
                                                                                                            standard-output = "/home/checker/resources/mounts/0000000000000000" ;
                                                                                                            text = '' ${ generic-parameters.command } '' ;
                                                                                                    }
                                                                                                    {
                                                                                                            process = "pre" ;
                                                                                                            text = "force-sync" ;
                                                                                                    }
                                                                                                    {
                                                                                                            process = "pre" ;
                                                                                                            reads = false ;
                                                                                                            standard-output = files.init.true ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    check-files --delete true --exclusion "*.flag" --exclusion "*.lock" ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--exclusion ${ ndrf }" ) generic-parameters.exclusions ) } ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--non-deterministic-regular-file ${ ndrf }" ) generic-parameters.non-deterministic-regular-files ) }
                                                                                                                '' ;
                                                                                                    }
                                                                                                    {
                                                                                                            process = "pre" ;
                                                                                                            standard-output = "183" ;
                                                                                                            text = "check-redis" ;
                                                                                                    }
                                                                                                ]
                                                                                            ] ;
                                                                                corruption =
                                                                                    if generic-parameters.stage.corruption then
                                                                                        if generic-parameters.init.corruption then [ ]
                                                                                        else [ ]
                                                                                    else
                                                                                        if generic-parameters.init.corruption then [ { process = "pre" ; text = "force-corruption" ; } ]
                                                                                        else [ ] ;
                                                                            } ;
                                                                        release =
                                                                            {
                                                                                action =
                                                                                    if generic-parameters.stage.corruption then
                                                                                        if generic-parameters.stage.corruption then [ ]
                                                                                        else [ ]
                                                                                    else
                                                                                        if generic-parameters.init.corruption then
                                                                                            [
                                                                                                {
                                                                                                    process = "post" ;
                                                                                                    reads = false ;
                                                                                                    standard-output = files.init.false ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            check-files --delete false --exclusion "*.flag" --exclusion "*.lock" ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--exclusion ${ ndrf }" ) generic-parameters.exclusions ) } ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--non-deterministic-regular-file ${ ndrf }" ) generic-parameters.non-deterministic-regular-files ) }
                                                                                                        '' ;
                                                                                                }
                                                                                                {
                                                                                                    process = "post" ;
                                                                                                    standard-output = messages.release.true.false { index = "0000000000000000" ; standard-output = generic-parameters.release.action.standard-output ; status = generic-parameters.release.action.status ; } ;
                                                                                                    text = "check-redis --exclude" ;
                                                                                                }
                                                                                            ]
                                                                                        else
                                                                                            builtins.concatLists
                                                                                                [
                                                                                                    [
                                                                                                        {
                                                                                                            process = "post" ;
                                                                                                            reads = false ;
                                                                                                            standard-output = files.release.true.true ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    check-files --exclusion "/home/checker/resources/*.lock" --delete true
                                                                                                                '' ;
                                                                                                        }
                                                                                                    ]
                                                                                                    (
                                                                                                        let
                                                                                                            mapper =
                                                                                                                { channel , index , standard-output , status } :
                                                                                                                    {
                                                                                                                        process = "post" ;
                                                                                                                        standard-output = messages.release.true.true { index = index ; standard-output = standard-output ; status = status ; } ;
                                                                                                                        text = ''check-redis --exclude'' ;
                                                                                                                    } ;
                                                                                                            in builtins.map mapper generic-parameters.release.action.messages
                                                                                                    )
                                                                                                ] ;
                                                                                recovery =
                                                                                    if builtins.typeOf generic-parameters.release.recovery.script == "null" then [ ]
                                                                                    else
                                                                                        if generic-parameters.release.recovery.success then
                                                                                            builtins.concatLists
                                                                                                [
                                                                                                    [
                                                                                                        {
                                                                                                            process = "post" ;
                                                                                                            status = generic-parameters.release.recovery.status ;
                                                                                                            standard-error = generic-parameters.release.recovery.standard-error ;
                                                                                                            standard-output = generic-parameters.release.recovery.standard-output ;
                                                                                                            text = generic-parameters.release.recovery.script ;
                                                                                                        }
                                                                                                        {
                                                                                                            process = "post" ;
                                                                                                            text = "force-sync" ;
                                                                                                        }
                                                                                                        {
                                                                                                            process = "post" ;
                                                                                                            standard-output = if generic-parameters.release.recovery.success then files.release.true.recovered else files.release.true.false ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    check-files --delete false --exclusion "*.flag" --exclusion "*.lock" ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--exclusion ${ ndrf }" ) generic-parameters.exclusions ) } ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--non-deterministic-regular-file ${ ndrf }" ) generic-parameters.non-deterministic-regular-files ) }
                                                                                                                '' ;
                                                                                                        }
                                                                                                        {
                                                                                                            process = "post" ;
                                                                                                            standard-output = messages.release.true.true { index = "0000000000000000" ; standard-output = "" ; status = 0 ; } ;
                                                                                                            text = "check-redis" ;
                                                                                                        }
                                                                                                    ]
                                                                                                    (
                                                                                                        let
                                                                                                            mapper =
                                                                                                                { channel , index , standard-output , status } :
                                                                                                                    {
                                                                                                                        process = "post" ;
                                                                                                                        standard-output = messages.release.true.true { index = index ; standard-output = standard-output ; status = status ; } ;
                                                                                                                        text = ''check-redis --exclude'' ;
                                                                                                                    } ;
                                                                                                            in builtins.map mapper ( builtins.tail generic-parameters.release.action.messages )
                                                                                                    )
                                                                                                    [
                                                                                                        {
                                                                                                            process = "post" ;
                                                                                                            standard-output = "183" ;
                                                                                                            text = "check-redis" ;
                                                                                                        }
                                                                                                    ]
                                                                                                ]
                                                                                        else
                                                                                            [
                                                                                                {
                                                                                                    process = "post" ;
                                                                                                    status = generic-parameters.release.recovery.status ;
                                                                                                    standard-error = generic-parameters.release.recovery.standard-error ;
                                                                                                    standard-output = generic-parameters.release.recovery.standard-output ;
                                                                                                    text = generic-parameters.release.recovery.script ;
                                                                                                }
                                                                                                {
                                                                                                    process = "post" ;
                                                                                                    text = "force-sync" ;
                                                                                                }
                                                                                                {
                                                                                                    process = "post" ;
                                                                                                    standard-output = if generic-parameters.release.recovery.success then files.release.true.recovered else files.release.true.false ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            check-files --delete false --exclusion "*.flag" --exclusion "*.lock" ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--exclusion ${ ndrf }" ) generic-parameters.exclusions ) } ${ builtins.concatStringsSep " " ( builtins.map ( ndrf : "--non-deterministic-regular-file ${ ndrf }" ) generic-parameters.non-deterministic-regular-files ) }
                                                                                                        '' ;
                                                                                                }
                                                                                                {
                                                                                                    process = "post" ;
                                                                                                    standard-output = "183" ;
                                                                                                    text = "check-redis" ;
                                                                                                }
                                                                                            ] ;
                                                                                } ;
                                                                        setup =
                                                                            [
                                                                                {
                                                                                        process = "pre" ;
                                                                                        text = "force-garbage-collection" ;
                                                                                }
                                                                                {
                                                                                        process = "pre" ;
                                                                                        text = "force-sync" ;
                                                                                }
                                                                                {
                                                                                        process = "pre" ;
                                                                                        reads = false ;
                                                                                        standard-output = files.empty ;
                                                                                        text = "check-files --delete true" ;
                                                                                }
                                                                                {
                                                                                        process = "pre" ;
                                                                                        standard-output = messages.subscribe.invalid-init ;
                                                                                        text = "check-redis" ;
                                                                                }
                                                                                {
                                                                                        process = "pre" ;
                                                                                        standard-output = messages.subscribe.invalid-release ;
                                                                                        text = "check-redis" ;
                                                                                }
                                                                                {
                                                                                        process = "pre" ;
                                                                                        standard-output = messages.subscribe.valid-init ;
                                                                                        text = "check-redis" ;
                                                                                }
                                                                                {
                                                                                        process = "pre" ;
                                                                                        standard-output = messages.subscribe.valid-release ;
                                                                                        text = "check-redis" ;
                                                                                }
                                                                                {
                                                                                        process = "pre" ;
                                                                                        standard-output = "183" ;
                                                                                        text = "check-redis" ;
                                                                                }
                                                                            ] ;
                                                                    } ;
                                                                size = if builtins.length generic-parameters.init.action.messages == builtins.length generic-parameters.release.action.messages then builtins.length generic-parameters.init.action.messages else builtins.throw "the length of init ${ builtins.toString ( builtins.length generic-parameters.init.action.messages ) } must equal the length of release ${ builtins.toString ( builtins.length generic-parameters.release.action.messages ) }" ;
                                                                in
                                                                    _resource.check2
                                                                        {
                                                                            gc-roots-directory = "/home/checker/.gc-roots" ;
                                                                            inputs =
                                                                                builtins.concatLists
                                                                                    [
                                                                                        sequences.setup
                                                                                        sequences.init.action
                                                                                        [
                                                                                            { process = "pre" ; standard-output = "183" ; text = "check-redis" ; }
                                                                                        ]
                                                                                        sequences.init.corruption
                                                                                        [
                                                                                            { process = "pre" ; standard-output = "183" ; text = "check-redis" ; }
                                                                                            { process = "post" ; text = "force-sync" ; }
                                                                                        ]
                                                                                        sequences.release.action
                                                                                        [ { process = "post" ; standard-output = "183" ; text = "check-redis" ; } ]
                                                                                        sequences.release.recovery
                                                                                        sequences.clean
                                                                                    ] ;
                                                                            name = "resource : ${ generic-parameters.case } : ${ generic-parameters.command }" ;
                                                                            nodes = { github = github ; client = client ; } ;
                                                                            order = generic-parameters.order ;
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
                                                                                        ''client.copy_from_vm("/tmp/scratch/","scratch")''
                                                                                        ''client.succeed("runuser checker -- ${ action-derivation }/test")''
                                                                                        ''client.shutdown()''
                                                                                        ''github.shutdown()''
                                                                                    ] ;
                                                                        } ;
                                                    in
                                                        {
                                                            happy =
                                                                {
                                                                    command ,
                                                                    exclusions ,
                                                                    init ,
                                                                    non-deterministic-regular-files ,
                                                                    order ,
                                                                    release
                                                                } @primary :
                                                                    let
                                                                        case-defaults =
                                                                            {
                                                                                case = "happy" ;
                                                                                init =
                                                                                    {
                                                                                        action = init.action ;
                                                                                        corruption = false ;
                                                                                        recovery = null ;
                                                                                    } ;
                                                                                order = order ;
                                                                                release =
                                                                                    {
                                                                                        action = release.action // { standard-output = null ; status = 0 ; } ;
                                                                                        recovery =
                                                                                            {
                                                                                                standard-error = null ;
                                                                                                standard-output = null ;
                                                                                                script = null ;
                                                                                                scripts = null ;
                                                                                                status = null ;
                                                                                                success = null ;
                                                                                            } ;
                                                                                        script = release.script ;
                                                                                    } ;
                                                                                stage =
                                                                                    {
                                                                                        action.messages = [ ] ;
                                                                                        corruption = false ;
                                                                                    } ;
                                                                            } ;
                                                                        parameters = primary // case-defaults ;
                                                                        in generic parameters ;
                                                            init-and-release-recovered = null ;
                                                            init-unrecoverable
                                                             = null ;
                                                            init-recovered-release-unrecoverable = null ;
                                                            release-recovered =
                                                                {
                                                                    command ,
                                                                    exclusions ,
                                                                    init ,
                                                                    non-deterministic-regular-files ,
                                                                    order ,
                                                                    release
                                                                } @primary :
                                                                    let
                                                                        case-defaults =
                                                                            {
                                                                                case = "release-recovered" ;
                                                                                init =
                                                                                    {
                                                                                        action = init.action ;
                                                                                        corruption = true ;
                                                                                        recovery = null ;
                                                                                    } ;
                                                                                order = order ;
                                                                                release =
                                                                                    {
                                                                                        action = release.action ;
                                                                                        recovery =
                                                                                            let
                                                                                                recovery-defaults =
                                                                                                    {
                                                                                                        standard-error = "" ;
                                                                                                        status = 0 ;
                                                                                                        success = true ;
                                                                                                    } ;
                                                                                                in release.recovery // recovery-defaults ;
                                                                                        script = release.script ;
                                                                                    } ;
                                                                                stage =
                                                                                    {
                                                                                        action.messages = [ ] ;
                                                                                        corruption = false ;
                                                                                    } ;
                                                                            } ;
                                                                        parameters = primary // case-defaults ;
                                                                        in generic parameters ;
                                                            release-unrecoverable =
                                                                {
                                                                    command ,
                                                                    exclusions ,
                                                                    init ,
                                                                    non-deterministic-regular-files ,
                                                                    order ,
                                                                    release
                                                                } @primary :
                                                                    let
                                                                        case-defaults =
                                                                            {
                                                                                case = "release-unrecoverable" ;
                                                                                init =
                                                                                    {
                                                                                        action = init.action ;
                                                                                        corruption = true ;
                                                                                        recovery = null ;
                                                                                    } ;
                                                                                order = order ;
                                                                                release =
                                                                                    {
                                                                                        action = release.action ;
                                                                                        recovery =
                                                                                            let
                                                                                                recovery-defaults =
                                                                                                    {
                                                                                                        status = 111 ;
                                                                                                        success = false ;
                                                                                                    } ;
                                                                                                in release.recovery // recovery-defaults ;
                                                                                        script = release.script ;
                                                                                    } ;
                                                                                stage =
                                                                                    {
                                                                                        action.messages = [ ] ;
                                                                                        corruption = false ;
                                                                                    } ;
                                                                            } ;
                                                                        parameters = primary // case-defaults ;
                                                                        in generic parameters ;
                                                        } ;
                                        in
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
                                                                            (
                                                                                _failure.check
                                                                                    {
                                                                                        obviated-by = [ ] ;
                                                                                        nixosTest = pkgs.nixosTest ;
                                                                                    }
                                                                                    {
                                                                                        compile-time-arguments = [ "6699768429138615" ] ;
                                                                                        planned-error = 182 ;
                                                                                        unplanned-error = 162 ;
                                                                                    }
                                                                                    {
                                                                                        run-time-arguments = [ "9641181236542922" ] ;
                                                                                    }
                                                                            )
                                                                            (
                                                                                _visitor.check
                                                                                    {
                                                                                        obviated-by = [ "failure" ] ;
                                                                                        failure = _failure.implementation ;
                                                                                        nixosTest = pkgs.nixosTest ;
                                                                                    }
                                                                                    {
                                                                                        arguments = null ;
                                                                                        success = true ;
                                                                                        value = null ;
                                                                                        visitors = { null = path : value : value ; } ;
                                                                                    }
                                                                            )
                                                                            (
                                                                                _lazy-shell-application.check
                                                                                    {
                                                                                        obviated-by = [ "failure" "visitor" ] ;
                                                                                        nixosTest = pkgs.nixosText ;
                                                                                    }
                                                                                    {
                                                                                        mounts =
                                                                                            {
                                                                                                test-7482109308014871 = { type = "tmp" ; } ;
                                                                                            } ;
                                                                                        name = "test" ;
                                                                                        runtime-inputs = pkgs : [ pkgs.which pkgs.yq ] ;
                                                                                        post = null ;
                                                                                        text =
                                                                                            ''
                                                                                                which yq
                                                                                            '' ;
                                                                                    }
                                                                                    {
                                                                                        arguments = [ ] ;
                                                                                        standard-error = "" ;
                                                                                        standard-input = null ;
                                                                                        standard-output = "" ;
                                                                                        status = 0 ;
                                                                                    }
                                                                            )
                                                                        ]
                                                                ) ;
                                                    in builtins.genList generator ( builtins.length list )
                                                ) ;
                                    implementation = implementation ;
                                } ;
            } ;
}

