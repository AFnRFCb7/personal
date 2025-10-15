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
                            failureX =
                                resources.lib.util.failure
                                    {
                                        coreutils = pkgs.coreutils ;
                                        jq = pkgs.jq ;
                                        mkDerivation = pkgs.stdenv.mkDerivation ;
                                        writeShellApplication = pkgs.writeShellApplication ;
                                        yq-go = pkgs.yq-go ;
                                    } ;
                            failureY = failureX ;
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
                                                        dot-gnupg =
                                                            {
                                                                secret-keys ,
                                                                ownertrust
                                                            } @primary : ignore :
                                                                {
                                                                    init =
                                                                        resources : self :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "init" ;
                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.gnupg ] ;
                                                                                            text =
                                                                                                let
                                                                                                    attributes =
                                                                                                        visitor.lib.implementation
                                                                                                            {
                                                                                                                lambda = path : value : value resources_ ;
                                                                                                                set = path : set : set ;
                                                                                                            }
                                                                                                            primary ;
                                                                                                    in
                                                                                                        ''
                                                                                                            GNUPGHOME=/mount/dot-gnupg
                                                                                                            export GNUPGHOME
                                                                                                            mkdir --parents "$GNUPGHOME"
                                                                                                            chmod 0700 "$GNUPGHOME"
                                                                                                            SECRET_KEYS="$( ${ attributes.secret-keys.resource } )" || ${ failureX "1107ddcd" }
                                                                                                            gpg --batch --yes --homedir "$GNUPGHOME" --import "$SECRET_KEYS/secret" 2>&1
                                                                                                            OWNERTRUST="$( ${ attributes.ownertrust.resource } )" || ${ failureX "1471b338" }
                                                                                                            gpg --batch --yes --homedir "$GNUPGHOME" --import-ownertrust "$OWNERTRUST/${ attributes.ownertrust.target }" 2>&1
                                                                                                            gpg --batch --yes --homedir "$GNUPGHOME" --update-trustdb 2>&1
                                                                                                        '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/init" ;
                                                                    targets = [ "dot-gnupg" ] ;
                                                                } ;
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
                                                                control-master ? null ,
                                                                control-path ? null ,
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
                                                                strict-host-key-checking ? null ,
                                                                user ? null ,
                                                                user-known-hosts-file ? null
                                                            } @primary : ignore :
                                                                let
                                                                    bash-name = name : builtins.replaceStrings [ "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "-" ] [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "_" ] name ;
                                                                    cats =
                                                                        let
                                                                            one = path : value : [ ( builtins.concatStringsSep "" [ ( config-name ( builtins.elemAt path 0 ) ) "=" ''"'' "$" ( bash-name ( builtins.elemAt path 0 ) ) ''"'' ] ) ] ;
                                                                            two =
                                                                                path : value :
                                                                                    let
                                                                                        v = value resources_ ;
                                                                                        in
                                                                                            [ ( builtins.concatStringsSep "" [ ( config-name ( builtins.elemAt path 0 ) ) " " "$" ( bash-name ( builtins.elemAt path 0 ) ) "/" ( v.target ) ] ) ] ;
                                                                            in
                                                                                visitor.lib.implementation
                                                                                    {
                                                                                        bool = one ;
                                                                                        int = one ;
                                                                                        lambda = two ;
                                                                                        set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                        string = one ;
                                                                                    }
                                                                                    primary ;
                                                                    exports =
                                                                        let
                                                                            export = path : value : [ "${ bash-name ( builtins.elemAt path 0 ) }=${ value }" ] ;
                                                                            in
                                                                                visitor.lib.implementation
                                                                                    {
                                                                                        bool = path : value : if value then export path "yes" else "no" ;
                                                                                        int = path : value : export path ( builtins.toString value ) ;
                                                                                        lambda = path : value : let v = value resources_ ; in export path ( ''"$( ${ v.resource } )" || ${ failureX "8e90ad2a" }'' ) ;
                                                                                        set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                        string = path : value : export path ''"${ value }"'' ;
                                                                                    }
                                                                                    primary ;
                                                                    links =
                                                                        let
                                                                            mapper =
                                                                                name : value :
                                                                                    visitor.lib.implementation
                                                                                        {
                                                                                            bool = path : value : null;
                                                                                            int = path : value : null ;
                                                                                            lambda = path : value : "ln --symbolic ${ builtins.concatStringsSep "" [ "$" ( bash-name name ) ] } /links" ;
                                                                                            string = path : value : null ;
                                                                                        }
                                                                                        primary ;
                                                                            in builtins.filter ( link : builtins.typeOf link == "string" ) ( builtins.attrValues ( builtins.mapAttrs mapper primary ) ) ;
                                                                    config-name = name : builtins.replaceStrings [ "-" ] [ "" ] name ;
                                                                    in
                                                                        {
                                                                            init =
                                                                                resources : self :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "application" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            ${ builtins.concatStringsSep "\n" exports }
                                                                                                            ${ builtins.concatStringsSep "\n" links }
                                                                                                            cat > /mount/config <<EOF
                                                                                                            ${ builtins.concatStringsSep "\n" cats }
                                                                                                            EOF
                                                                                                            chmod 0400 /mount/config
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/application" ;
                                                                            targets =
                                                                                [
                                                                                    "config"
                                                                                ] ;
                                                                            transient = false ;
                                                                        } ;
                                                        git =
                                                            {
                                                                configs ? { } ,
                                                                hooks ? { } ,
                                                                remotes ? { } ,
                                                                setup ? null ,
                                                                release ? null
                                                            } : ignore :
                                                                {
                                                                    init =
                                                                        resources : self :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "application" ;
                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    export REPOSITORY_ROOT=/mount
                                                                                                    export GIT_DIR=/mount/git
                                                                                                    export GIT_WORK_TREE=/mount/work-tree
                                                                                                    mkdir --parents "$GIT_DIR"
                                                                                                    mkdir --parents "$GIT_WORK_TREE"
                                                                                                    cat > /mount/.envrc <<EOF
                                                                                                    export REPOSITORY_ROOT=${ self }
                                                                                                    export GIT_DIR=${ self }/git
                                                                                                    export GIT_WORK_TREE=${ self }/work-tree
                                                                                                    EOF
                                                                                                    cd /mount
                                                                                                    git init 2>&1
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git config "${ name }" "${ value }"'' ) configs ) ) }
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''ln --symbolic "${ value }" "$GIT_DIR/hooks/${ name }"'' ) hooks ) ) }
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git remote add "${ name }" "${ value }"'' ) remotes ) ) }
                                                                                                    ${ if builtins.typeOf setup == "string" then ''if read -t 0 ; then cat | exec ${ setup } "$@" ; else exec ${ setup } "$@" ; fi'' else "#" }
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/application" ;
                                                                    release = release ;
                                                                    targets = [ ".envrc" "git" "work-tree" ] ;
                                                                    transient = false ;
                                                                } ;
                                                        milestone =
                                                            let
                                                                application =
                                                                    pkgs.writeShellApplication
                                                                        {
                                                                            name = "milestone" ;
                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                            text =
                                                                                ''
                                                                                    NOW="$( date +%s )" || ${ failureX "f2c1a8a4" }
                                                                                    date --date @$(( ( NOW / ${ builtins.toString config.personal.milestone.epoch } ) * ${ builtins.toString config.personal.milestone.epoch } )) "+${ config.personal.milestone.format }"
                                                                                '' ;
                                                                        } ;
                                                                    in "${ application }/bin/milestone" ;
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
                                                        scratch =
                                                            let
                                                                scratch =
                                                                    pkgs.writeShellApplication
                                                                        {
                                                                            name = "scratch" ;
                                                                            runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ] ;
                                                                            text =
                                                                                ''
                                                                                    SCRATCH="$( uuidgen | sha512sum | cut --bytes -128 )" || ${ failureX "e93c4402" }
                                                                                    BRANCH="$( echo "scratch/$SCRATCH" | cut --bytes -100 )" || ${ failureX "5f0e6fe8" }
                                                                                    git checkout -b "$BRANCH" 2>&1
                                                                                '' ;
                                                                        } ;
                                                                    in "${ scratch }/bin/scratch" ;
                                                        snapshot =
                                                            let
                                                                application =
                                                                    pkgs.writeShellApplication
                                                                        {
                                                                            name = "snapshot" ;
                                                                            runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.gnused ] ;
                                                                            text =
                                                                                ''
                                                                                    TOKEN="$1"
                                                                                    ROOT="$2"
                                                                                    git commit -am "" --allow-empty --allow-empty-message > /dev/null 2>&1
                                                                                    BRANCH="$( git rev-parse --abbrev-ref HEAD )" || ${ failureX "4a921647" }
                                                                                    GIT_DIR="$ROOT/git" GIT_WORK_TREE="$ROOT/work-tree" git config "dependencies.$TOKEN.branch" "$BRANCH"
                                                                                    COMMIT="$( git rev-parse HEAD )" || ${ failureX "20c91416" }
                                                                                    GIT_DIR="$ROOT/git" GIT_WORK_TREE="$ROOT/work-tree" git config "dependencies.$TOKEN.commit" "$COMMIT"
                                                                                    sed --regexp-extended -i "s#(^.*${ builtins.concatStringsSep "" [ "$" "{" "TOKEN" "}" ] }[.]url.*\?ref=)(.*)(\".*\$)#\1$COMMIT\3#" "$ROOT/work-tree/flake.nix"
                                                                                '' ;
                                                                        } ;
                                                            in "${ application }/bin/snapshot" ;
                                                        ssh-command =
                                                            dot-ssh :
                                                                let
                                                                    ssh-command =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "ssh-command" ;
                                                                                runtimeInputs = [ pkgs.openssh ] ;
                                                                                text =
                                                                                    let
                                                                                        point = dot-ssh resources_ ;
                                                                                        in
                                                                                            ''
                                                                                                DOT_SSH="$( echo | ${ point.resource } )" || ${ failureX "ef7a1272" }
                                                                                                exec ssh -F "$DOT_SSH/${ point.target }" "$@"
                                                                                            '' ;
                                                                            } ;
                                                                    in "${ ssh-command }/bin/ssh-command" ;
                                                        in
                                                            {
                                                                applications =
                                                                    {
                                                                        chromium =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.nix ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    mkdir --parents /mount/bin
                                                                                                                    nix-shell --packages pkgs.chromium pkgs.which --run "ln --symbolic \$( which chromium ) /mount/bin"
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                        targets = [ "bin" ] ;
                                                                                } ;
                                                                    } ;
                                                                debug =
                                                                    {
                                                                        alpha =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    echo "ALPHA" > /mount/self
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    release =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "release" ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                ${ failureX "43dd6f7d" }
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/release" ;
                                                                                    targets = [ "self" ] ;
                                                                                } ;
                                                                        beta =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    echo "BETA" > /mount/self
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    release =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "release" ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                echo "${ self }" > /mount/self
                                                                                                                ${ failureX "b2c1ccd0" }
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/release" ;
                                                                                    targets = [ "self" ] ;
                                                                                } ;
                                                                    } ;
                                                                control-paths =
                                                                    {
                                                                        mobile =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    mkdir --parents /mount/control-path
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ "control-path" ] ;
                                                                                } ;
                                                                    } ;
                                                                dot-gnupg =
                                                                    dot-gnupg
                                                                        {
                                                                            secret-keys = resources : { resource = resources.secrets."secret-keys.asc.age" ; target = "secret" ; } ;
                                                                            ownertrust = resources : { resource = resources.secrets."ownertrust.asc.age" ; target = "secret" ; } ;
                                                                        } ;
                                                                dot-password-store =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.mobile ; target = "config" ; } ) ;
                                                                                    "user.name" = config.personal.pass.description ;
                                                                                    "user.email" = config.personal.pass.email ;
                                                                                } ;
                                                                            hooks =
                                                                                {
                                                                                    post-commit = post-commit "origin" ;
                                                                                } ;
                                                                            remotes =
                                                                                {
                                                                                    origin = config.personal.pass.remote ;
                                                                                } ;
                                                                            setup =
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "setup" ;
                                                                                                runtimeInputs = [ pkgs.git ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        # git fetch origin ${ config.personal.pass.branch }
                                                                                                        # git checkout ${ config.personal.pass.branch }
                                                                                                    '' ;
                                                                                            } ;
                                                                                        in "${ application }/bin/setup" ;
                                                                        } ;
                                                                dot-ssh =
                                                                    {
                                                                        github =
                                                                            dot-ssh
                                                                                {
                                                                                    host = "github.com" ;
                                                                                    host-name = "github.com" ;
                                                                                    identity-file = resources : { resource = resources.secrets.dot-ssh.boot."identity.asc.age" ; target = "secret" ; } ;
                                                                                    strict-host-key-checking = true ;
                                                                                    user = "git" ;
                                                                                    user-known-hosts-file = resources : { resource = resources.secrets.dot-ssh.boot."known-hosts.asc.age" ; target = "secret" ; } ;
                                                                                } ;
                                                                        mobile =
                                                                            dot-ssh
                                                                                {
                                                                                    host = "mobile" ;
                                                                                    host-name = "192.168.1.202" ;
                                                                                    identity-file = resources : { resource = resources.secrets.dot-ssh.boot."identity.asc.age" ; target = "secret" ; } ;
                                                                                    port = 8022 ;
                                                                                    strict-host-key-checking = true ;
                                                                                    user = "git" ;
                                                                                    user-known-hosts-file = resources : { resource = resources.secrets.dot-ssh.boot."known-hosts.asc.age" ; target = "secret" ; } ;
                                                                                } ;
                                                                    } ;
                                                                home =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                resources : self :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "application" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            RESOURCES="$( ${ resources.repository.resources } )" || ${ failureX "3f26b4aa" }
                                                                                                            ln --symbolic "$RESOURCES" /links
                                                                                                            ln --symbolic "$RESOURCES" /mount/resources
                                                                                                            PERSONAL="$( ${ resources.repository.personal } )" || ${ failureX "8af3601b" }
                                                                                                            ln --symbolic "$PERSONAL" /links
                                                                                                            ln --symbolic "$PERSONAL" /mount/personal
                                                                                                            PRIVATE="$( ${ resources.repository.private } )" || ${ failureX "35b067fd" }
                                                                                                            ln --symbolic "$PRIVATE" /links
                                                                                                            ln --symbolic "$PRIVATE" /mount/private
                                                                                                            SECRETS="$( ${ resources.repository.secrets } )" || ${ failureX "04d6332b" }
                                                                                                            ln --symbolic "$SECRETS" /links
                                                                                                            ln --symbolic "$SECRETS" /mount/secrets
                                                                                                            VISITOR="$( ${ resources.repository.visitor } )" || ${ failureX "04d6332b" }
                                                                                                            ln --symbolic "$VISITOR" /links
                                                                                                            ln --symbolic "$VISITOR" /mount/visitor
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/application" ;
                                                                            targets =
                                                                                [
                                                                                    "resources"
                                                                                    "personal"
                                                                                    "private"
                                                                                    "secrets"
                                                                                    "visitor"
                                                                                ] ;
                                                                            transient = false ;
                                                                        } ;
                                                                repository =
                                                                    {
                                                                        personal =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "alias.milestone" = "!${ milestone }" ;
                                                                                            "alias.scratch" = "!${ scratch }" ;
                                                                                            "alias.snapshot" = "!${ snapshot }" ;
                                                                                            "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.github ; target = "config" ; } ) ;
                                                                                            "user.email" = config.personal.repository.personal.email ;
                                                                                            "user.name" = config.personal.repository.personal.name ;
                                                                                        } ;
                                                                                    hooks =
                                                                                        {
                                                                                            post-commit = post-commit "origin" ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.personal.remote ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                git fetch origin ${ config.personal.repository.personal.branch } 2>&1
                                                                                                                git checkout origin/${ config.personal.repository.personal.branch } 2>&1
                                                                                                                git scratch
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/setup" ;
                                                                                } ;
                                                                        resources =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "alias.milestone" = "!${ milestone }" ;
                                                                                            "alias.scratch" = "!${ scratch }" ;
                                                                                            "alias.snapshot" = "!${ snapshot }" ;
                                                                                            "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.github ; target = "config" ; } ) ;
                                                                                            "user.email" = config.personal.repository.resources.email ;
                                                                                            "user.name" = config.personal.repository.resources.name ;
                                                                                        } ;
                                                                                    hooks =
                                                                                        {
                                                                                            post-commit = post-commit "origin" ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.resources.remote ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                git fetch origin ${ config.personal.repository.resources.branch } 2>&1
                                                                                                                git checkout origin/${ config.personal.repository.resources.branch } 2>&1
                                                                                                                git scratch
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/setup" ;
                                                                                } ;
                                                                        secrets =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "alias.milestone" = "!${ milestone }" ;
                                                                                            "alias.scratch" = "!${ scratch }" ;
                                                                                            "alias.snapshot" = "!${ snapshot }" ;
                                                                                            "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.github ; target = "config" ; } ) ;
                                                                                            "user.email" = config.personal.repository.secrets.email ;
                                                                                            "user.name" = config.personal.repository.secrets.name ;
                                                                                        } ;
                                                                                    hooks =
                                                                                        {
                                                                                            post-commit = post-commit "origin" ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.secrets.remote ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                git fetch origin ${ config.personal.repository.secrets.branch } 2>&1
                                                                                                                git checkout origin/${ config.personal.repository.secrets.branch } 2>&1
                                                                                                                git scratch
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/setup" ;
                                                                                } ;
                                                                        visitor =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "alias.milestone" = "!${ milestone }" ;
                                                                                            "alias.scratch" = "!${ scratch }" ;
                                                                                            "alias.snapshot" = "!${ snapshot }" ;
                                                                                            "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.github ; target = "config" ; } ) ;
                                                                                            "user.email" = config.personal.repository.visitor.email ;
                                                                                            "user.name" = config.personal.repository.visitor.name ;
                                                                                        } ;
                                                                                    hooks =
                                                                                        {
                                                                                            post-commit = post-commit "origin" ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.visitor.remote ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                git fetch origin ${ config.personal.repository.visitor.branch } 2>&1
                                                                                                                git checkout origin/${ config.personal.repository.visitor.branch } 2>&1
                                                                                                                git scratch
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/setup" ;
                                                                                } ;
                                                                        private =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        let
                                                                                            in
                                                                                                {
                                                                                                    "alias.milestone" = "!${ milestone }" ;
                                                                                                    "alias.scratch" = "!${ scratch }" ;
                                                                                                    "alias.snapshot" =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "snapshot" ;
                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                git commit -am "" --allow-empty --allow-empty-message > /dev/null 2>&1
                                                                                                                                BRANCH="$( git rev-parse --abbrev-ref HEAD )" || ${ failureX "f39f8735" }
                                                                                                                                COMMIT="$( git rev-parse HEAD )" || ${ failureX "28ca95c9" }
                                                                                                                                ${ resources_.promotion.root } "$BRANCH" "$COMMIT"
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                                in "!${ application }/bin/snapshot" ;
                                                                                                    "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.mobile ; target = "config" ; } ) ;
                                                                                                    "user.email" = config.personal.repository.private.email ;
                                                                                                    "user.name" = config.personal.repository.private.name ;
                                                                                                } ;
                                                                                    hooks =
                                                                                        {
                                                                                            post-commit = post-commit "origin" ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.private.remote ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                PERSONAL="$( ${ resources_.repository.personal } )" || ${ failureX "a60e198b" }
                                                                                                                RESOURCES="$( ${ resources_.repository.resources } )" || ${ failureX "00af3985" }
                                                                                                                SECRETS="$( ${ resources_.repository.secrets } )" || ${ failureX "a81a6ac1" }
                                                                                                                VISITOR="$( ${ resources_.repository.visitor } )" || ${ failureX "a64b742f" }
                                                                                                                ln --symbolic "$PERSONAL" /links
                                                                                                                ln --symbolic "$RESOURCES" /links
                                                                                                                ln --symbolic "$SECRETS" /links
                                                                                                                ln --symbolic "$VISITOR" /links
                                                                                                                cat >> /mount/.envrc <<EOF
                                                                                                                export PERSONAL="$PERSONAL"
                                                                                                                export RESOURCES="$RESOURCES"
                                                                                                                export SECRETS="$SECRETS"
                                                                                                                export VISITOR="$VISITOR"
                                                                                                                EOF
                                                                                                                git fetch origin ${ config.personal.repository.private.branch } 2>&1
                                                                                                                git checkout origin/${ config.personal.repository.private.branch } 2>&1
                                                                                                                git scratch
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/setup" ;
                                                                                } ;
                                                                    } ;
                                                                promotion =
                                                                    {
                                                                        build =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.nixos-rebuild ] ;
                                                                                                            text =
                                                                                                                let
                                                                                                                    switch =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "switch" ;
                                                                                                                                        runtimeInputs = [ ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" ) ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                PERSONAL="$( ${ resources_.promotion.squash.dependents.personal } "$SOURCE" personal )" || ${ failureX "91c4c535" }
                                                                                                                                                GIT_DIR="$PERSONAL/git" GIT_WORK_TREE="$PERSONAL/work-tree" git squash-and-merge
                                                                                                                                                RESOURCES="$( ${ resources_.promotion.squash.dependents.resources } "$SOURCE" resources )" || ${ failureX "8dd9d1be" }
                                                                                                                                                GIT_DIR="$RESOURCES/git" GIT_WORK_TREE="$RESOURCES/work-tree" git squash-and-merge
                                                                                                                                                SECRETS="$( ${ resources_.promotion.squash.dependents.secrets } "$SOURCE" secrets )" || ${ failureX "7564ae81" }
                                                                                                                                                GIT_DIR="$SECRETS/git" GIT_WORK_TREE="$SECRETS/work-tree" git squash-and-merge
                                                                                                                                                VISITOR="$( ${ resources_.promotion.squash.dependents.visitor } "$SOURCE" visitor )" || ${ failureX "0aa09fa8" }
                                                                                                                                                GIT_DIR="$VISITOR/git" GIT_WORK_TREE="$VISITOR/work-tree" git squash-and-merge
                                                                                                                                                ROOT="$( ${ resources_.promotion.squash.root } "$BRANCH" "$COMMIT" )" || ${ failureX "a3cdd707" }
                                                                                                                                                nix flake update --flake "$ROOT/work-tree" personal resources secrets visitor
                                                                                                                                                nixos-rebuild switch --flake "$ROOT/work-tree#user"
                                                                                                                                                GIT_DIR="$ROOT/git" GIT_WORK_TREE="$ROOT/work-tree" git squash-and-merge
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                            in "${ application }/bin/switch" ;
                                                                                                                    test =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "test" ;
                                                                                                                                        runtimeInputs = [ ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" ) ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                nixos-rebuild test --flake "$SOURCE/work-tree#user"
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                            in "${ application }/bin/test" ;
                                                                                                                    in
                                                                                                                        ''
                                                                                                                            SOURCE="$1"
                                                                                                                            BRANCH="$2"
                                                                                                                            COMMIT="$3"
                                                                                                                            ln --symbolic "$SOURCE" /links
                                                                                                                            CHECK="$( ${ resources.promotion.check } "$SOURCE" )" || ${ failureX "9767b8fa" }
                                                                                                                            ln --symbolic "$CHECK" /links
                                                                                                                            CHECK_STATUS="$( < "$CHECK/status" )" || ${ failureX "e80f0ccf" }
                                                                                                                            cd /mount
                                                                                                                            cat > /mount/.envrc <<EOF
                                                                                                                            export SOURCE="$SOURCE"
                                                                                                                            export BRANCH="$BRANCH"
                                                                                                                            export COMMIT="$COMMIT"
                                                                                                                            export CHECK_STATUS="$CHECK_STATUS"
                                                                                                                            EOF
                                                                                                                            if [[ "$CHECK_STATUS" == 0 ]] && nixos-rebuild build --flake "$SOURCE/work-tree#user" > /mount/standard-output 2> /mount/standard-error
                                                                                                                            then
                                                                                                                                echo "$?" > /mount/status
                                                                                                                            else
                                                                                                                                echo "$?" > /mount/status
                                                                                                                                touch /mount/standard-output
                                                                                                                                touch /mount/standard-error
                                                                                                                            fi
                                                                                                                            ln --symbolic ${ switch } /mount
                                                                                                                            ln --symbolic ${ test } /mount
                                                                                                                        '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ ".envrc" "result" "standard-error" "standard-output" "status" "switch" "test" ] ;
                                                                                } ;
                                                                        build-vm =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.nixos-rebuild ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    SOURCE="$1"
                                                                                                                    ln --symbolic "$SOURCE" /links
                                                                                                                    CHECK="$( ${ resources.promotion.check } "$SOURCE" )" || ${ failureX "9d52c6ca" }
                                                                                                                    ln --symbolic "$CHECK" /links
                                                                                                                    CHECK_STATUS="$( < "$CHECK/status" )" || ${ failureX "a6c0086f" }
                                                                                                                    cd /mount
                                                                                                                    mkdir --parents /mount/shared
                                                                                                                    cat > /mount/.envrc <<EOF
                                                                                                                    export SHARED_DIR=${ self }/shared
                                                                                                                    export CHECK_STATUS="$CHECK_STATUS"
                                                                                                                    EOF
                                                                                                                    if [[ "$CHECK_STATUS" == 0 ]] && nixos-rebuild build-vm --flake "$SOURCE/work-tree#user" > /mount/standard-output 2> /mount/standard-error
                                                                                                                    then
                                                                                                                        echo "$?" > /mount/status
                                                                                                                    else
                                                                                                                        echo "$?" > /mount/status
                                                                                                                        touch /mount/standard-output
                                                                                                                        touch /mount/standard-error
                                                                                                                    fi
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ ".envrc" "result" "shared" "standard-error" "standard-output" "status" ] ;
                                                                                } ;
                                                                        build-vm-with-bootloader =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.nixos-rebuild ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    SOURCE="$1"
                                                                                                                    ln --symbolic "$SOURCE" /links
                                                                                                                    CHECK="$( ${ resources.promotion.check } "$SOURCE" )" || ${ failureX "4f0b67b3" }
                                                                                                                    ln --symbolic "$CHECK" /links
                                                                                                                    CHECK_STATUS="$( < "$CHECK/status" )" || ${ failureX "683f774e" }
                                                                                                                    cd /mount
                                                                                                                    mkdir --parents /mount/shared
                                                                                                                    cat > /mount/.envrc <<EOF
                                                                                                                    export SHARED_DIR=${ self }/shared
                                                                                                                    export CHECK_STATUS="$CHECK_STATUS"
                                                                                                                    EOF
                                                                                                                    if [[ "$CHECK_STATUS" == 0 ]] && nixos-rebuild build-vm-with-bootloader --flake "$SOURCE/work-tree#user" > /mount/standard-output 2> /mount/standard-error
                                                                                                                    then
                                                                                                                        echo "$?" > /mount/status
                                                                                                                    else
                                                                                                                        echo "$?" > /mount/status
                                                                                                                        touch /mount/standard-output
                                                                                                                        touch /mount/standard-error
                                                                                                                    fi
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ ".envrc" "result" "shared" "standard-error" "standard-output" "status" ] ;
                                                                                } ;
                                                                        check =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        resources : self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.nix ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    SOURCE="$1"
                                                                                                                    ln --symbolic "$SOURCE" /links
                                                                                                                    if nix flake check "$SOURCE/work-tree" > /mount/standard-output 2> /mount/standard-error
                                                                                                                    then
                                                                                                                        echo "$?" > /mount/status
                                                                                                                    else
                                                                                                                        echo "$?" > /mount/status
                                                                                                                    fi
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ "standard-error" "standard-output" "status" ] ;
                                                                                } ;
                                                                        root =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "alias.build" =
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "build" ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        ${ resources_.promotion.build } "$REPOSITORY_ROOT" "$BRANCH" "$COMMIT"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in "!${ application }/bin/build" ;
                                                                                            "alias.build-vm" =
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "build-vm" ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        ${ resources_.promotion.build-vm } "$REPOSITORY_ROOT"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in "!${ application }/bin/build-vm" ;
                                                                                            "alias.build-vm-with-bootloader" =
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "build-vm-with-bootloader" ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        ${ resources_.promotion.build-vm-with-bootloader } "$REPOSITORY_ROOT"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in "!${ application }/bin/build-vm-with-bootloader" ;
                                                                                            "alias.check" =
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "check" ;
                                                                                                                runtimeInputs  = [ pkgs.coreutils pkgs.nix ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        ${ resources_.promotion.check } "$REPOSITORY_ROOT"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in "!${ application }/bin/check" ;
                                                                                            "alias.collect-garbage" =
                                                                                                let
                                                                                                   application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "collect-garbage" ;
                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.nix pkgs.time ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        df -h
                                                                                                                        time nix-collect-garbage 2> /dev/null
                                                                                                                        df -h
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in "!${ application }/bin/collect-garbage" ;
                                                                                            "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.mobile ; target = "config" ; } ) ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.private.remote ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                BRANCH="$1"
                                                                                                                COMMIT="$2"
                                                                                                                cat >> /mount/.envrc <<EOF
                                                                                                                export SOURCE="$REPOSITORY_ROOT"
                                                                                                                export BRANCH="$BRANCH"
                                                                                                                export COMMIT="$COMMIT"
                                                                                                                EOF
                                                                                                                git fetch origin "$BRANCH" 2>&1
                                                                                                                git checkout "$COMMIT" 2>&1
                                                                                                                GIT_DIR="$PERSONAL/git" GIT_WORK_TREE="$PERSONAL/work-tree" git snapshot personal "$REPOSITORY_ROOT"
                                                                                                                GIT_DIR="$RESOURCES/git" GIT_WORK_TREE="$RESOURCES/work-tree" git snapshot resources "$REPOSITORY_ROOT"
                                                                                                                GIT_DIR="$SECRETS/git" GIT_WORK_TREE="$SECRETS/work-tree" git snapshot secrets "$REPOSITORY_ROOT"
                                                                                                                GIT_DIR="$VISITOR/git" GIT_WORK_TREE="$VISITOR/work-tree" git snapshot visitor "$REPOSITORY_ROOT"
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/setup" ;
                                                                                } ;
                                                                            squash =
                                                                                {
                                                                                    dependents =
                                                                                        let
                                                                                            fun =
                                                                                                email : name : origin :
                                                                                                    git
                                                                                                        {
                                                                                                            configs =
                                                                                                                {
                                                                                                                    "alias.scratch" = "!${ scratch }" ;
                                                                                                                    "alias.squash-and-merge" =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "squash-and-merge" ;
                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                if ! git diff --exit-code origin/main
                                                                                                                                                then
                                                                                                                                                    git scratch
                                                                                                                                                    git reset --soft origin/main 2>&1
                                                                                                                                                    git commit --verbose 2>&1
                                                                                                                                                    git push origin HEAD
                                                                                                                                                    SQUASH_BRANCH="$( git rev-parse --abbrev-ref HEAD )" || ${ failureX "4ae5068e" }
                                                                                                                                                    TOKEN="$( ${ resources_.secrets."github-token.asc.age" } )" || ${ failureX "2a2a175a" }
                                                                                                                                                    gh auth login --with-token < "$TOKEN/secret"
                                                                                                                                                    URL="$( gh pr create --base main --head "$SQUASH_BRANCH" --title "Promotion" --body "Automated Promotion Merge" )" || ${ failureX "58c20779" }
                                                                                                                                                    gh pr merge --rebase --subject "Promotion Merge" "$URL"
                                                                                                                                                    gh auth logout
                                                                                                                                                fi
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                            in "!${ application }/bin/squash-and-merge" ;
                                                                                                                    "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.github ; target = "config" ; } ) ;
                                                                                                                    "user.email" = email ;
                                                                                                                    "user.name" = name ;
                                                                                                                } ;
                                                                                                            remotes =
                                                                                                                {
                                                                                                                    origin = origin ;
                                                                                                                } ;
                                                                                                            setup =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "setup" ;
                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        SOURCE="$1"
                                                                                                                                        TYPE="$2"
                                                                                                                                        DEPENDENT_BRANCH="$( GIT_DIR="$SOURCE/git" GIT_WORK_TREE="$SOURCE/work-tree" git config --get "dependencies.$TYPE.branch" )" || ${ failureX "eb615c70" }
                                                                                                                                        git fetch origin "$DEPENDENT_BRANCH" 2>&1
                                                                                                                                        DEPENDENT_COMMIT="$( GIT_DIR="$SOURCE/git" GIT_WORK_TREE="$SOURCE/work-tree" git config --get "dependencies.$TYPE.commit" )" || ${ failureX "1bcc7194" }
                                                                                                                                        git checkout "$DEPENDENT_COMMIT" 2>&1
                                                                                                                                        git fetch origin main 2>&1
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/setup" ;
                                                                                                        } ;
                                                                                            in
                                                                                                {
                                                                                                    personal = fun config.personal.repository.personal.email config.personal.repository.personal.name config.personal.repository.personal.remote ;
                                                                                                    resources = fun config.personal.repository.resources.email config.personal.repository.resources.name config.personal.repository.resources.remote ;
                                                                                                    secrets = fun config.personal.repository.secrets.email config.personal.repository.secrets.name config.personal.repository.secrets.remote ;
                                                                                                    visitor = fun config.personal.repository.visitor.email config.personal.repository.visitor.name config.personal.repository.visitor.remote ;
                                                                                                } ;
                                                                                    root =
                                                                                        git
                                                                                            {
                                                                                                configs =
                                                                                                    {
                                                                                                        "alias.scratch" = "!${ scratch }" ;
                                                                                                        "alias.squash-and-merge" =
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "squash-and-merge" ;
                                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    if ! git diff --exit-code origin/main
                                                                                                                                    then
                                                                                                                                        git scratch
                                                                                                                                        git reset --soft origin/main 2>&1
                                                                                                                                        git add -A
                                                                                                                                        git commit --verbose 2>&1
                                                                                                                                        git push origin HEAD 2>&1
                                                                                                                                        SQUASH_COMMIT="$( git rev-parse --abbrev-ref HEAD )" || ${ failureX "bcf90683" }
                                                                                                                                        git checkout main 2>&1
                                                                                                                                        git rebase "$SQUASH_COMMIT" 2>&1
                                                                                                                                        git push origin HEAD 2>&1
                                                                                                                                    fi
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                            in "!${ application }/bin/squash-and-merge" ;

                                                                                                        "core.sshCommand" = ssh-command ( resources : { resource = resources.dot-ssh.mobile ; target = "config" ; } ) ;
                                                                                                        "user.email" = config.personal.repository.private.email ;
                                                                                                        "user.name" = config.personal.repository.private.name ;
                                                                                                    } ;
	                                                                                        remotes =
        	                                                                                    {
                	                                                                                origin = config.personal.repository.private.remote ;
                        	                                                                    } ;
                                	                                                        setup =
                                        	                                                    let
                                                	                                                application =
                                                        	                                            pkgs.writeShellApplication
                                                                	                                        {
                                                                        	                                    name = "setup" ;
                                                                                	                            runtimeInputs = [ ] ;
                                                                                        	                    text =
                                                                                                	                ''
                                                                                                        	            git fetch origin "$BRANCH" 2>&1
                                                                                                                	    git checkout "$COMMIT" 2>&1
	                                                                                                                    git fetch origin main 2>&1
                                                                                        	                        '' ;
                                                                                                	        } ;
	                                                                                                in "${ application }/bin/setup" ;
        	                                                                        	} ;
										                                        } ;
                                                                    } ;
                                                                secrets =
                                                                    let
                                                                        mapper =
                                                                            path : name : value :
                                                                            if value == "regular" then
                                                                                ignore :
                                                                                    {
                                                                                        init =
                                                                                            resources : self :
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "secret" ;
                                                                                                                runtimeInputs = [ pkgs.age pkgs.coreutils ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        age --decrypt --identity ${ config.personal.agenix } --output /mount/secret ${ builtins.concatStringsSep "/" ( builtins.concatLists [ path [ name ] ] ) }
                                                                                                                        chmod 0400 /mount/secret
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/secret" ;
                                                                                        targets = [ "secret" ] ;
                                                                                    }
                                                                               else if value == "directory" then builtins.mapAttrs ( mapper ( builtins.concatLists [ path [ name ] ] ) ) ( builtins.readDir ( builtins.concatStringsSep "/" ( builtins.concatLists [ path [ name ] ] ) ) )
                                                                               else builtins.throw "We can not handle ${ value }." ;
                                                                        in builtins.mapAttrs ( mapper [ ( builtins.toString secrets ) ] ) ( builtins.readDir ( builtins.toString secrets ) ) ;
                                                                temporary-directory =
                                                                    {
                                                                        init = resources : self : "" ;
                                                                        targets = [ ] ;
                                                                    } ;
                                                            } ;
                                                in
                                                    visitor.lib.implementation
                                                        {
                                                            lambda =
                                                                path : value :
                                                                    let
                                                                        resource-factory =
                                                                            resources.lib.factories.generic
                                                                                {
                                                                                    buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                                                                    coreutils = pkgs.coreutils ;
                                                                                    findutils = pkgs.findutils ;
                                                                                    flock = pkgs.flock ;
                                                                                    init = point.init ;
                                                                                    jq = pkgs.jq ;
                                                                                    makeBinPath = pkgs.lib.makeBinPath ;
                                                                                    makeWrapper = pkgs.makeWrapper ;
                                                                                    mkDerivation = pkgs.stdenv.mkDerivation ;
                                                                                    ps = pkgs.ps ;
                                                                                    redis = pkgs.redis ;
                                                                                    resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                                    seed = { path = path ; seed = seed ; } ;
                                                                                    targets = point.targets ;
                                                                                    transient = point.transient ;
                                                                                    visitor = visitor ;
                                                                                    writeShellApplication = pkgs.writeShellApplication ;
                                                                                    yq-go = pkgs.yq-go ;
                                                                                } ;
                                                                        point =
                                                                            let
                                                                                identity =
                                                                                    {
                                                                                        init ? null ,
                                                                                        release ? null ,
                                                                                        targets ? [ ] ,
                                                                                        transient ? false
                                                                                    } :
                                                                                        {
                                                                                            init =
                                                                                                if builtins.typeOf init == "lambda" then
                                                                                                    let
                                                                                                        in init resources_
                                                                                                else init ;
                                                                                            release = release ;
                                                                                            targets = targets ;
                                                                                            transient = transient ;
                                                                                        } ;
                                                                                in identity ( value null ) ;
                                                                        in resource-factory.implementation ;
                                                        }
                                                        tree ;
                                        secrets_ =
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
                                                        systemd.services.resources-log-listener =
                                                            {
                                                                after = [ "network.target" ] ;
                                                                serviceConfig =
                                                                    {
                                                                        ExecStart =
                                                                            let
                                                                                log-event-listener =
                                                                                    resources.lib.listeners.log-event-listener
                                                                                        {
                                                                                            coreutils = pkgs.coreutils ;
                                                                                            flock = pkgs.flock ;
                                                                                            redis = pkgs.redis ;
                                                                                            resources-directory = "/home/${ config.personal. name }/resources" ;
                                                                                            writeShellApplication = pkgs.writeShellApplication ;
                                                                                            yq-go = pkgs.yq-go ;
                                                                                        } ;
                                                                                in "${ log-event-listener.implementation }/bin/log-event-listener" ;
                                                                        User = config.personal.name ;
                                                                    } ;
                                                                wantedBy = [ "multi-user.target" ] ;
                                                            } ;
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
                                                                                                makeWrapper ${ pkgs.jetbrains.idea-community }/bin/idea-community $out/bin/${ name } --run "REPO=\"\$( ${ repository } )\" || ${ failureX "b7c33f28" }" --add-flags "\$REPO"
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
                                                                                            name = "alpha" ;
                                                                                            text = "echo hi" ;
                                                                                        }
                                                                                )
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "studio" ;
                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.jetbrains.idea-community ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    HOMEY="$( ${ resources_.home } )" || ${ failureX "15daa579" }
                                                                                                    cd "$HOMEY"
                                                                                                    idea-community .
                                                                                                '' ;
                                                                                        }
                                                                                )
                                                                                pkgs.git
                                                                                pkgs.yq
                                                                                pkgs.lsof
                                                                                pkgs.inotify-tools
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "home" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text = resources_.home ;
                                                                                        }
                                                                                )
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "double-check-promotion" ;
                                                                                            text = "echo promotion works" ;
                                                                                        }
                                                                                )
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "foobar" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text = resources_.secrets.dot-ssh.boot."identity.asc.age" ;
                                                                                        }
                                                                                )
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "debugging" ;
                                                                                            runtimeInputs = [ pkgs.bash pkgs.coreutils ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    echo ALPHA=${ resources_.debug.alpha }
                                                                                                    echo BETA=${ resources_.debug.beta }
                                                                                                '' ;
                                                                                        }
                                                                                )
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "studio" ;
                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.jetbrains.idea-community ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    HOMEY="$( ${ resources_.home } )" || ${ failureX "c664bcd6" }
                                                                                                    cd "$HOMEY"
                                                                                                    idea-community
                                                                                                '' ;
                                                                                        }
                                                                                )
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "dot-ssh" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text = resources_.dot-ssh.mobile ;
                                                                                        }
                                                                                )
                                                                                (
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "foobar" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    echo HI
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
                                        let
                                            failure =
                                                resources.lib.util.failure { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                                            log-event-listener =
                                                resources.lib.listeners.log-event-listener
                                                    {
                                                        coreutils = pkgs.coreutils ;
                                                        flock = pkgs.flock ;
                                                        redis = pkgs.redis ;
                                                        resources-directory = "/build/resources" ;
                                                        writeShellApplication = pkgs.writeShellApplication ;
                                                        yq-go = pkgs.yq-go ;
                                                    } ;
                                            test-home =
                                                name :
                                                    {
                                                        name = "test-home:  ${ name }" ;
                                                        value =
                                                            pkgs.nixosTest
                                                               {
                                                                   name = "home-test" ;
                                                                   nodes.machine =
                                                                       { pkgs, ... } :
                                                                           {
                                                                               imports = [ user ] ;
                                                                               environment.systemPackages =
                                                                                   [
                                                                                       (
                                                                                            pkgs.writeShellApplication
                                                                                               {
                                                                                                    name = "test-home" ;
                                                                                                    runtimeInputs =
                                                                                                        [
                                                                                                            (
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "create-mock-repository" ;
                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                BUILD="$1"
                                                                                                                                NAME="$2"
                                                                                                                                FILE="$3"
                                                                                                                                TOKEN="$4"
                                                                                                                                if [[ -e "$BUILD/repo/$NAME" ]]
                                                                                                                                then
                                                                                                                                    echo "$BUILD/repo/$NAME" already exists >&2
                                                                                                                                    # KLUDGE
                                                                                                                                    exit 65
                                                                                                                                fi
                                                                                                                                mkdir --parents "$BUILD/repo/$NAME"
                                                                                                                                cd "$BUILD/repo/$NAME"
                                                                                                                                git init --bare
                                                                                                                                if [[ -e "$BUILD/work/$NAME" ]]
                                                                                                                                then
                                                                                                                                    echo "$BUILD/work/$NAME already exists" >&2
                                                                                                                                    # KLUDGE
                                                                                                                                    exit 65
                                                                                                                                fi
                                                                                                                                mkdir --parents "$BUILD/work/$NAME"
                                                                                                                                cd "$BUILD/work/$NAME"
                                                                                                                                git init
                                                                                                                                git config user.email nina.nix@example.com
                                                                                                                                git config user.name "Nina Nix"
                                                                                                                                git remote add origin "$BUILD/repo/$NAME"
                                                                                                                                git checkout -b branch/test
                                                                                                                                echo "$TOKEN" > "$FILE"
                                                                                                                                git add "$FILE"
                                                                                                                                git commit -m "" --allow-empty-message
                                                                                                                                git push origin branch/test
                                                                                                                                echo "created $NAME repository at $BUILD/repository/$NAME"
                                                                                                                            '' ;
                                                                                                                    }
                                                                                                            )
                                                                                                            (
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "verify-mock-repository" ;
                                                                                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                HOMEY="$1"
                                                                                                                                NAME="$2"
                                                                                                                                FILE="$3"
                                                                                                                                TOKEN="$4"
                                                                                                                                if [[ ! -d "$HOMEY" ]]
                                                                                                                                then
                                                                                                                                    echo Missing HOME >&2
                                                                                                                                    # KLUDGE
                                                                                                                                    exit 65
                                                                                                                               fi
                                                                                                                                if [[ ! -L "$HOMEY/$NAME" ]]
                                                                                                                                then
                                                                                                                                    echo "Missing $NAME" >&2
                                                                                                                                    # KLUDGE
                                                                                                                                    exit 65
                                                                                                                                fi
                                                                                                                                if [[ ! -f "$HOMEY/$NAME/work-tree/$FILE" ]]
                                                                                                                                then
                                                                                                                                    echo "Missing $NAME file" >&2
                                                                                                                                    # KLUDGE
                                                                                                                                    exit 65
                                                                                                                                fi
                                                                                                                                PRIVATE="$( < "$HOMEY/$NAME/work-tree/$FILE" )" || exit 65 }
                                                                                                                                if [[ "$TOKEN" != "$PRIVATE" ]]
                                                                                                                                then
                                                                                                                                    echo "Private $NAME file is wrong" >&2
                                                                                                                                    # KLUDGE
                                                                                                                                    exit 65
                                                                                                                                fi
                                                                                                                            '' ;
                                                                                                                    }
                                                                                                            )
                                                                                                            pkgs.age
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.git
                                                                                                        ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            echo "Starting test-home with $# arguments"
                                                                                                            BUILD="$1"
                                                                                                            echo Using "BUILD=$BUILD"
                                                                                                            mkdir --parents "$BUILD"
                                                                                                            age-keygen -y ${ self }/age.test.key 2>&1
                                                                                                            age-keygen -y ${ self }/age.test.key > "$BUILD/age.test.key.pub" 2>&1
                                                                                                            age-keygen -y ${ self }/age.test.key > "$BUILD/age.test.key.pub" 2>&1
                                                                                                            echo computed public key
                                                                                                            mkdir --parents "$BUILD/secrets/dot-ssh/mobile"
                                                                                                            echo 1fc11953a79d521af9082d3966596b1443048a8d2bbe7c5c2071c205211627fea557812b0014e3f6f3143d94edb2d54dfb728ea3ec3b2d622e35e1b323558494 > "$BUILD/secrets/dot-ssh/mobile/identity.asc"
                                                                                                            echo 1572ace6d3ec3303f01f43c474c40e55f0d707596043b1ce49f7f98711814920e956cbc57754ae93f5f26b0489c2ac467fc7d3f73fb71749d5e861a70aa6245b > "$BUILD/secrets/dot-ssh/mobile/unknown-hosts.asc"
                                                                                                            mkdir --parents "$BUILD/repository/secrets"
                                                                                                            git -C "$BUILD/repository/secrets" init
                                                                                                            git -C "$BUILD/repository/secrets" config user.email nina.nix@example.com
                                                                                                            git -C "$BUILD/repository/secrets" config user.name "Nina Nix"
                                                                                                            git -C "$BUILD/repository/secrets" checkout -b branch/test
                                                                                                            mkdir --parents "$BUILD/repository/secrets/dot-ssh/mobile"
                                                                                                            age --recipients-file "$BUILD/age.test.key.pub" --output "$BUILD/repository/secrets/dot-ssh/mobile/identity.asc.age" "$BUILD/secrets/dot-ssh/mobile/identity.asc"
                                                                                                            age --recipients-file "$BUILD/age.test.key.pub" --output "$BUILD/repository/secrets/dot-ssh/mobile/unknown-hosts.asc.age" "$BUILD/secrets/dot-ssh/mobile/unknown-hosts.asc"
                                                                                                            git -C "$BUILD/repository/secrets" add dot-ssh/mobile/identity.asc.age
                                                                                                            git -C "$BUILD/repository/secrets" add dot-ssh/mobile/unknown-hosts.asc.age
                                                                                                            git -C "$BUILD/repository/secrets" commit -m "" --allow-empty-message
                                                                                                            echo "created secrets repository at $BUILD/repository/secrets"
                                                                                                            PRIVATE_FILE=af96ff1062ec89ceee3384a4e3736b6b7bdbbd78e5ffcf356ee9f9012700baf1ad1ce7b48b25b0a5afc9eaca7e4c2db61d2e83cec49493b89486002ffc8f9302
                                                                                                            PRIVATE_TOKEN=fbadd0b5f32d56b07db1fc5a17daaf574964a0dab54efc8b1932bf77a340af31cc44669859e06d880a3013fe70405058a89435f910b2b84c4bd378bd9cce1049
                                                                                                            create-mock-repository "$BUILD" private "$PRIVATE_FILE" "$PRIVATE_TOKEN"
                                                                                                            PERSONAL_FILE=570ab8317345522e606bec96139429ff4a18b356cde20604c9c95f799ba0d3a54ee9e06bf2c609b073c50c2d25e9889fb39d63f924d6d405064367d3397d1585
                                                                                                            PERSONAL_TOKEN=44a65d206aeb170db164ebe10f4ea2e481c3db8ecad7a1aca05bf843d7f85ed8863cb6b2575fde720d270785bce70f2c451c3b0c91eb637633b470b053e611fd
                                                                                                            create-mock-repository "$BUILD" personal "$PERSONAL_FILE" "$PERSONAL_TOKEN"
                                                                                                            RESOURCES_FILE=1fc5bfc608d9cd345b7d4e3ee0ed073664cf0eda11412131a589fdf66aec961f7d522cc23cd4bf47929ac98bf07bbabe2222166fc4c1e07ecf8cd997c4ea1fe9
                                                                                                            RESOURCES_TOKEN=aeab6d01077166bd8b32ccf8359a425d0bb7b8de4d08166d59482ef77e9de5b1e12cb96bf6dc2de6276bbcae2fb55fd15a81cb1afb70263a4d5048ab22c4fdbe
                                                                                                            create-mock-repository "$BUILD" resources "$RESOURCES_FILE" "$RESOURCES_TOKEN"
                                                                                                            SECRETS_FILE=a863e91ebc08029e473e18f56c2c6b0808a52201a176372c5f67ac87067117ad167dac5b53d9fe932deefbba5b5c3d1efda925f3809560006e746e85e25a90aa
                                                                                                            SECRETS_TOKEN=d4067dcf3f4bec779f0a155eddb4af5397569ac0aa2cf20a3b64ba906cb1d693eae221622467ffe560b86aae678a37af2f8644830930313451f4004902dc8425
                                                                                                            create-mock-repository "$BUILD" secrets "$SECRETS_FILE" "$SECRETS_TOKEN"
                                                                                                            VISITOR_FILE=16909325584e945fe34caa9626543411e777963ced9ee10d11953879f507d4d4c805cf5ccc1030d6297d58ea252c79431d4e76d8435f9444e003e362b9683093
                                                                                                            VISITOR_TOKEN=6d63c2e3a4048012194e5d63436f3e636d73a865c96fa86387e5602d7366df04f87c5ec95922273292268a4976f3c2901a933ce5173b2ce8400de162e440bec1
                                                                                                            create-mock-repository "$BUILD" visitor "$VISITOR_FILE" "$VISITOR_TOKEN"
                                                                                                            echo before execute test code
                                                                                                            HOMEY="$( home )" || exit 65
                                                                                                            echo after execute test code
                                                                                                            verify-mock-repository "$HOMEY" private "$PRIVATE_FILE" "$PRIVATE_TOKEN"
                                                                                                            verify-mock-repository "$HOMEY" personal "$PERSONAL_FILE" "$PERSONAL_TOKEN"
                                                                                                            verify-mock-repository "$HOMEY" resources "$RESOURCES_FILE" "$RESOURCES_TOKEN"
                                                                                                            verify-mock-repository "$HOMEY" secrets "$SECRETS_FILE" "$SECRETS_TOKEN"
                                                                                                            verify-mock-repository "$HOMEY" visitor "$VISITOR_FILE" "$VISITOR_TOKEN"
                                                                                                        '' ;
                                                                                               }
                                                                                        )
                                                                                   ] ;
                                                                               personal =
                                                                                   {
                                                                                        agenix = self + "/age.test.key" ;
                                                                                        description = "Bob Wonderful" ;
                                                                                        name = "bob" ;
                                                                                        password = "password" ;
                                                                                        repository =
                                                                                            {
                                                                                                personal =
                                                                                                    {
                                                                                                        branch = "branch/test" ;
                                                                                                        remote = "/tmp/build/repo/personal" ;
                                                                                                    } ;
                                                                                                private =
                                                                                                    {
                                                                                                        branch = "branch/test" ;
                                                                                                        remote = "/tmp/build/repo/private" ;
                                                                                                    } ;
                                                                                                resources =
                                                                                                    {
                                                                                                        branch = "branch/test" ;
                                                                                                        remote = "/tmp/build/repo/resources" ;
                                                                                                    } ;
                                                                                                secrets =
                                                                                                    {
                                                                                                        branch = "branch/test" ;
                                                                                                        remote = "/tmp/build/repo/secrets" ;
                                                                                                    } ;
                                                                                                visitor =
                                                                                                    {
                                                                                                        branch = "branch/test" ;
                                                                                                        remote = "/tmp/build/repo/visitor" ;
                                                                                                    } ;
                                                                                            } ;
                                                                                   } ;
                                                                           } ;
                                                                   testScript =
                                                                       ''
                                                                           start_all()
                                                                           machine.wait_for_unit("multi-user.target")
                                                                           status, stdout = machine.execute("su - bob --command 'test-home /tmp/build'")
                                                                           print("STDOUT:\n", stdout)
                                                                           assert status == 0, "test-home failed"
                                                                       '' ;
                                                               } ;
                                                    } ;
                                            test-resource =
                                                name : throws-error : has-standard-error : target-mismatch : is-transient : test :
                                                    let
                                                        resource-factory =
                                                            resources.lib.factories.generic
                                                                {
                                                                    buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                                                    coreutils = pkgs.coreutils ;
                                                                    findutils = pkgs.findutils ;
                                                                    error = 129 ;
                                                                    flock = pkgs.flock ;
                                                                    init =
                                                                        self :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "init" ;
                                                                                            runtimeInputs = [ ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    echo f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8
                                                                                                    echo c8fb600c10065059a89aed599cf5e3590d46095b63bcde89c3ecf109ca8f5737a9c3bf97f917eb4e8dd5851a503e3c58296250fd2a9b060bcf3c85daba2b8216 ${ if has-standard-error then ">&2" else "> /scratch/null" }
                                                                                                    touch /mount/${ if target-mismatch then "98236ab2df439c61422251ca03830facf0e9a1e06fecb2d267f8c4574cd8a05b12224b536ab5661adc9a0347fba244e1a3db425ec7044166ae861cc93e50bd49" else "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4" }
                                                                                                    ${ if throws-error then failureX "74e8c518" else "exit 0" }
                                                                                                '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/init" ;
                                                                    jq = pkgs.jq ;
                                                                    makeBinPath = pkgs.lib.makeBinPath ;
                                                                    makeWrapper = pkgs.makeWrapper ;
                                                                    seed = name ;
                                                                    mkDerivation = pkgs.stdenv.mkDerivation ;
                                                                    ps = pkgs.ps ;
                                                                    redis = pkgs.redis ;
                                                                    resources-directory = "/build/resources" ;
                                                                    targets = [ "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4" ] ;
                                                                    transient = false ;
                                                                    visitor = visitor ;
                                                                    writeShellApplication = pkgs.writeShellApplication ;
                                                                    yq-go = pkgs.yq-go ;
                                                                } ;
                                                            in { name = "test-resource:  ${ name }" ; value = resource-factory.check test ; } ;
                                            tests =
                                                [
                                                    { name = "t0" ; value = failure.check { compile-time-arguments = "469c07cdbb13c65f1435bb0b9b7eb5ed2c14d70bc111d12fda44c2cd47c23e99aed06672fec7e138bfa11de61184774d7b2dd2d33aa5958d9df49a4c55e6a8e3" ; run-time-arguments = [ "ba02df6c2bf44bb25e7a23fe02dac230baaabda128f463ce26af83e7787bc16de9260f56beaacdef75743665eededeaae997f50892983be4f40453ef6e817f4f" ] ; } ; }
                                                    # { name = "t2" ; value = log-event-listener.check { log-file = [ "WRONG" "cb530ae0685c39cf856fbef11a8dd0a7345c88c0e76be94a36db7bbc90441d9f858238d65e2aee0293f62d0cfc7520cca766cb0a10c7497adbee4c1647110ad0" "db82bfb27b0bbd524de7967935c64c44abca9c78b6b6882e7ea35e6e2e097f3c899119ed431d257c8a34b537adf87bd464a59022eab26eba7f7cb2daf2ac5a5" ] ; message = "7ec5c1abf8934880c738af14ed3213437edb7e8a3b1833b31a9b253934606a0604cb80ca36f25d0f41e7f134eb9b7e6dc5473a69204b6f7c14aa2bf78d4ad840" ; mkDerivation = pkgs.stdenv.mkDerivation ; } ; }
                                                    { name = "t1" ; value = log-event-listener.check { log-file = [ "409d85c81f91fa72bcb589647e59aa81b9b48a36e7e65e8d562cf86120955fe07d35dd7733f6349bc8c8bb4ed634630a03e5da0150de9ea81ef79c46a64a2456" ] ; message = "7ec5c1abf8934880c738af14ed3213437edb7e8a3b1833b31a9b253934606a0604cb80ca36f25d0f41e7f134eb9b7e6dc5473a69204b6f7c14aa2bf78d4ad840" ; mkDerivation = pkgs.stdenv.mkDerivation ; } ; }
                                                    ( test-home "simple test" )
                                                    (
                                                        test-resource
                                                            "Happy Case"
                                                            false
                                                            false
                                                            false
                                                            false
                                                            {
                                                                arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
                                                                expected-dependencies = [ ] ;
                                                                expected-index = "0000000311691948" ;
                                                                expected-originator-pid = 45 ;
                                                                expected-provenance = "new" ;
                                                                expected-standard-error = "" ;
                                                                expected-standard-output = "f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8" ;
                                                                expected-status = 0 ;
                                                                expected-targets = [ "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4" ] ;
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
                                                            }
                                                    )
                                                ] ;
                                            in builtins.listToAttrs tests ;
                                    modules =
                                        {
                                            user = user ;
                                        } ;
                                    tests =
                                        {
                                        } ;
                                } ;
            } ;
}
