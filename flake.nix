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
                        private ,
                        system ,
                        visitor
                    } :
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
                                        resources =
                                            let
                                                checkout =
                                                    let
                                                        checkout =
                                                            pkgs.writeShellApplication
                                                                {
                                                                    name = "checkout" ;
                                                                    runtimeInputs = [ pkgs.git ] ;
                                                                    text =
                                                                        ''
                                                                            MILESTONE="$( ${ milestone } )"
                                                                            if git fetch origin "$MILESTONE"
                                                                            then
                                                                                git checkout "origin/$MILESTONE"
                                                                            else
                                                                                git fetch origin main
                                                                                git checkout origin/main
                                                                                git checkout -b "$MILESTONE"
                                                                                git push -u origin "$MILESTONE"
                                                                            fi
                                                                            git checkout -b "scratch/$( uuidgen )"
                                                                        '' ;
                                                                } ;
                                                        in "${ checkout }/bin/checkout" ;
                                                git =
                                                    {
                                                        configs ? { } ,
                                                        environments ? { } ,
                                                        hooks ? { } ,
                                                        remotes ? { } ,
                                                        setup ? null ,
                                                        release-inputs ? [ ] ,
                                                        release-text ? null
                                                    } : ignore :
                                                        {
                                                            init-inputs = [ pkgs.coreutils pkgs.git ] ;
                                                            init-text =
                                                                ''
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''${ name }="${ value }"'' ) environments ) ) }
                                                                    # ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''export ${ name }="${ builtins.concatStringsSep "" [ "$" "{" name "}" ] }"'' ) environments ) ) }
                                                                    export GIT_DIR="$SELF/git"
                                                                    export GIT_WORK_TREE="$SELF/work-tree"
                                                                    HOMEY="$SELF/home"
                                                                    mkdir --parents "$GIT_DIR"
                                                                    mkdir --parents "$GIT_WORK_TREE"
                                                                    mkdir --parents "$HOMEY"
                                                                    cat > "$SELF/.envrc" <<EOF
                                                                    export GIT_DIR="$GIT_DIR"
                                                                    export GIT_WORK_TREE="$GIT_WORK_TREE"
                                                                    export HOME="$HOMEY"
                                                                    export SELF="$SELF"
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''export ${ name }="${ builtins.concatStringsSep "" [ "$" "{" name "}" ] }"'' ) environments ) ) }
                                                                    EOF
                                                                    git init
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git config "${ name }" "${ value }"'' ) configs ) ) }
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''ln --symbolic "${ value }" "$GIT_DIR/hooks/${ name }"'' ) hooks ) ) }
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git remote add "${ name }" "${ value }"'' ) remotes ) ) }
                                                                    ${ if builtins.typeOf setup == "string" then "exec ${ setup }" else "" }
                                                                '' ;
                                                            release-inputs = release-inputs ;
                                                            release-text = release-text ;
                                                        } ;
                                                milestone =
                                                    let
                                                        milestone =
                                                            pkgs.writeShellApplication
                                                                {
                                                                    name = "milestone" ;
                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                    text =
                                                                        ''
                                                                            date --date "@$(( ${ builtins.toString config.personal.milestone.epoch } * ( "$( date +%s )" / ${ builtins.toString config.personal.milestone.epoch } ) ))" "+${ config.personal.milestone.format }"
                                                                        '' ;
                                                                } ;
                                                            in "${ milestone }/bin/milestone" ;
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
                                                ssh =
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
                                                        in "${ ssh }/bin/ssh" ;
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
                                                            git
                                                                {
                                                                    configs =
                                                                        {
                                                                            "core.sshCommand" = ssh ;
                                                                            "user.email" = config.personal.email ;
                                                                            "user.name" = config.personal.description ;
                                                                        } ;
                                                                    hooks = { post-commit = post-commit ; } ;
                                                                    remotes = { origin = config.personal.pass.remote ; } ;
                                                                    setup =
                                                                        let
                                                                            setup =
                                                                                pkgs.writeShellApplication
                                                                                    {
                                                                                        name = "setup" ;
                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                        text =
                                                                                            ''
                                                                                                git fetch origin ${ config.personal.pass.branch }
                                                                                                git checkout ${ config.personal.pass.branch }
                                                                                            '' ;
                                                                                    } ;
                                                                            in "${ setup }/bin/setup" ;
                                                                } ;
                                                        milestone =
                                                            {
                                                                check =
                                                                    ignore :
                                                                        {
                                                                            init-inputs = [ pkgs.nix ] ;
                                                                            init-text =
                                                                                ''
                                                                                    export NIX_DEBUG=1
                                                                                    export NIX_SHOW_STATS=1
                                                                                    export NIX_SHOW_TRACE=1
                                                                                    export NIX_LOG=stderr
                                                                                    nix --log-format raw --show-trace -vvv flake check "$( ${ resources.milestone.source.root } "$@" )/work-tree" > /tmp/DEBUG 2>&1
                                                                                '' ;
                                                                        } ;
                                                                snapshot =
                                                                    ignore :
                                                                        {
                                                                            init-inputs = [ pkgs.coreutils ] ;
                                                                            init-text =
                                                                                ''
                                                                                    while [[ "$#" -gt 0 ]]
                                                                                    do
                                                                                        case "$1" in
                                                                                            --link)
                                                                                                TYPE="$2"
                                                                                                DIR="$3"
                                                                                                COMMIT="$4"
                                                                                                NAME="$( basename "$DIR" )"
                                                                                                if [[ "$TYPE" == "root" ]]
                                                                                                then
                                                                                                    ROOT="$SELF/root"
                                                                                                else
                                                                                                    ROOT="$SELF/inputs/$NAME"
                                                                                                fi
                                                                                                mkdir --parents "$ROOT"
                                                                                                GIT_DIR="$DIR/git" GIT_WORK_TREE="$DIR/work-tree" git rev-parse --abbrev-ref HEAD > "$ROOT/branch"
                                                                                                GIT_DIR="$DIR/git" GIT_WORK_TREE="$DIR/work-tree" git push origin HEAD
                                                                                                echo "$COMMIT" > "$ROOT/commit"
                                                                                                echo "$NAME" > "$ROOT/name"
                                                                                                ln --symbolic "$DIR" "$ROOT/local"
                                                                                                git remote --verbose | head --lines 1 | sed -E "s#[[:space:]]+#_#g" | cut --delimiter "_" --fields 2 > "$ROOT/remote"
                                                                                                shift 4
                                                                                                ;;
                                                                                            *)
                                                                                                mkdir --parents "$SELF/garbage"
                                                                                                echo "$1" > "$( mktemp "$SELF/garbage/XXXXXXXX" )"
                                                                                                shift
                                                                                                ;;
                                                                                        esac
                                                                                    done
                                                                                '' ;
                                                                            lease = 60 * 60 ;
                                                                        } ;
                                                                source =
                                                                    {
                                                                        root =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "core.sshCommand" = ssh ;
                                                                                            "user.email" = config.personal.email ;
                                                                                            "user.name" = config.personal.description ;
                                                                                        } ;
                                                                                    environments =
                                                                                        {
                                                                                            LOCO1 = builtins.trace resources.milestone.snapshot resources.milestone.snapshot ;
                                                                                            LOCO = ''$( ${ resources.milestone.snapshot } "$@" )'' ;
                                                                                            ZBRANCH = ''$( < "$LOCO/root/branch" )'' ;
                                                                                            ZCOMMIT = ''$( cat "$LOCO/root/commit" )'' ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            local = "$LOCO/root/local" ;
                                                                                            remote = ''$( < "$LOCO/root/remote" )'' ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            setup =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.findutils pkgs.git pkgs.gnused ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                LOCO20="$( ${ resources.milestone.snapshot } "$@" )"
                                                                                                                REMOTE="$( < "$LOCO20/root/remote" )"
                                                                                                                BRANCH="$( < "$LOCO20/root/branch" )"
                                                                                                                COMMIT="$( < "$LOCO20/root/commit" )"
                                                                                                                git fetch "$REMOTE" "$BRANCH"
                                                                                                                git checkout "$COMMIT" >> /tmp/DEBUG 2>&1
                                                                                                                find "$LOCO20/inputs" -mindepth 1 -maxdepth 1 -type d | while read -r DIR
                                                                                                                do
                                                                                                                    NAME="$( < "$DIR/name" )"
                                                                                                                    COMMIT="$( < "$DIR/commit" )"
                                                                                                                    sed -i "s#\($NAME\.url.*?ref=\)main#\1$COMMIT#" "$GIT_WORK_TREE/flake.nix"
                                                                                                                done
                                                                                                                date +%s > "$GIT_WORK_TREE/current-time.nix"
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ setup }/bin/setup \"$@\"" ;
                                                                                } ;
                                                                    } ;
                                                                virtual-machines =
                                                                    let
                                                                        virtual-machine =
                                                                            bootloader :
                                                                                {
                                                                                    build =
                                                                                        ignore :
                                                                                            {
                                                                                                init-inputs = [ pkgs.nixos-rebuild ] ;
                                                                                                init-text =
                                                                                                    ''
                                                                                                        export NIX_SHOW_STATS=5
                                                                                                        export NIX_DEBUG=1
                                                                                                        nixos-rebuild build-vm${ if bootloader then "-with-bootloader" else "" } --flake "$( "${ resources.milestone.source.root } "$@" )" --verbose --show-trace
                                                                                                    '' ;
                                                                                            } ;
                                                                                } ;
                                                                        in
                                                                            {
                                                                                virtual-machine = virtual-machine false ;
                                                                                virtual-machine-with-bootloader = virtual-machine true ;
                                                                            } ;
                                                            } ;
                                                        repository =
                                                            {
                                                                applications =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.applications.remote ; } ;
                                                                            setup =
                                                                                let
                                                                                    setup =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "setup" ;
                                                                                                runtimeInputs = [ ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ setup }/bin/setup" ;
                                                                        } ;
                                                                personal =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.personal.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                                private =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "alias.promote" =
                                                                                        let
                                                                                            promote =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "promote" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                mkdir --parents "$SELF/promote"
                                                                                                                ROOT="$( mktemp --directory "$SELF/promote/XXXXXXXX" )"
                                                                                                                commit ( )
                                                                                                                    {
                                                                                                                        REPO="$1"
                                                                                                                        GIT_DIR="$REPO/git" GIT_WORK_TREE="$REPO/work-tree" git rev-parse HEAD
                                                                                                                    }
                                                                                                                mkdir --parents "$SELF/promote"
                                                                                                                if [[ ! -e "$SELF/promote/snapshot" ]]
                                                                                                                then
                                                                                                                    SNAPSHOT="$( ${ resources.milestone.snapshot } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$SNAPSHOT" "$ROOT/snapshot"
                                                                                                                    echo 6c6f5fda-c41a-4175-8061-4e1d77e110d4 >> /tmp/DEBUG
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/source" ]]
                                                                                                                then
                                                                                                                    SOURCE="$( ${ resources.milestone.source.root } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$SOURCE" "$ROOT/source"
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/check" ]]
                                                                                                                then
                                                                                                                    CHECK="$( ${ resources.milestone.check } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$CHECK" "$ROOT/check"
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/vm" ]]
                                                                                                                then
                                                                                                                    BUILD_VM="$( ${ resources.milestone.check } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$BUILD_VM" "$ROOT/build_vm"
                                                                                                                fi
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "!${ promote }/bin/promote" ;
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.private.remote ; } ;
                                                                            setup =
                                                                                let
                                                                                    setup =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "setup" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        MILESTONE="$( ${ milestone } )"
                                                                                                        if git fetch origin "$MILESTONE"
                                                                                                        then
                                                                                                            git checkout "origin/$MILESTONE"
                                                                                                        else
                                                                                                            git fetch origin main
                                                                                                            git checkout origin/main
                                                                                                            git checkout -b "$MILESTONE"
                                                                                                            git push -u origin "$MILESTONE"
                                                                                                        fi
                                                                                                        git checkout -b "scratch/$( uuidgen )"
                                                                                                        mkdir --parents "$SELF/inputs"
                                                                                                        ln --symbolic "$( ${ resources.repository.personal } "$@" )" "$SELF/inputs/personal"
                                                                                                        ln --symbolic "$( ${ resources.repository.secret } "$@" )" "$SELF/inputs/secret"
                                                                                                        # ln --symbolic "$( ${ resources.repository.secrets } "$@" )" "$SELF/inputs/secrets"
                                                                                                        # ln --symbolic "$( ${ resources.repository.visitor } "$@" )" "$SELF/inputs/visitor"
                                                                                                    '' ;
                                                                                            } ;
                                                                                        in "${ setup }/bin/setup" ;
                                                                        } ;
                                                                secret =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.secret.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                                secrets =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.secrets.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                                visitor =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.visitor.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                            } ;
                                                    } ;
							                    in visitor.lib.implementation { lambda = path : value : secret.lib.implementation ( { nixpkgs = nixpkgs ; path = path ; secret-directory = "/home/${ config.personal.name }/resources" ; seed = [ nixpkgs path private self secret system visitor ] ; system = system ; } // ( value path ) ) ; } tree ;
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
                                                                                                makeWrapper ${ pkgs.jetbrains.idea-community }/bin/idea-community $out/bin/${ name } --add-flags '$( ${ repository } )'
                                                                                            '' ;
                                                                                        name = "derivation" ;
                                                                                        nativeBuildInputs = [ pkgs.makeWrapper ] ;
                                                                                        src = ./. ;
                                                                                    } ;
									                                    in
                                                                            [
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
                                            user = user ;
                                            tester = { ... } : { } ;
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
						                                            '' ;
                                                                name = "foobar" ;
                                                                src = ./. ;
						                                    } ;
                                                } ;
                                } ;
            } ;
}
