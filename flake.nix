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
                                                                        failure : resources : self :
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
                                                                                                                # path = path : value : value ;
                                                                                                                set = path : set : set ;
                                                                                                            }
                                                                                                            primary ;
                                                                                                    in
                                                                                                        ''
                                                                                                            GNUPGHOME=/mount/dot-gnupg
                                                                                                            export GNUPGHOME
                                                                                                            mkdir --parents "$GNUPGHOME"
                                                                                                            chmod 0700 "$GNUPGHOME"
                                                                                                            SECRET_KEYS="$( ${ attributes.secret-keys.resource } )" || ${ failure "1107ddcd" }
                                                                                                            gpg --batch --yes --homedir "$GNUPGHOME" --import "$SECRET_KEYS/secret" 2>&1
                                                                                                            OWNERTRUST="$( ${ attributes.ownertrust.resource } )" || ${ failure "1471b338" }
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
                                                                            mapper = name : value : builtins.concatStringsSep "" [ ( config-name name ) "=" ''"'' "$" ( bash-name name ) ''"'' ] ;
                                                                            in builtins.attrValues ( builtins.mapAttrs mapper primary ) ;
                                                                    exports =
                                                                        let
                                                                            mapper =
                                                                                name : value :
                                                                                    let
                                                                                        name_ = bash-name name ;
                                                                                        value_ =
                                                                                            visitor.lib.implementation
                                                                                                {
                                                                                                    bool = path : value : if value then "yes" else "no" ;
                                                                                                    int = path : value : builtins.toString value ;
                                                                                                    lambda = path : value : let v = value resources_ ; in ''"$( ${ v.resource } )" || exit 64'' ;
                                                                                                    string = path : value : ''"${ value }"'' ;
                                                                                                }
                                                                                                primary ;
                                                                                        in "export ${ name_ }=VALUE" ;
                                                                            in builtins.attrValues ( builtins.mapAttrs mapper primary ) ;
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
                                                                                failure : resources : self :
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
                                                                        failure : resources : self :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "application" ;
                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    export GIT_DIR=/mount/git
                                                                                                    export GIT_WORK_TREE=/mount/work-tree
                                                                                                    mkdir --parents "$GIT_DIR"
                                                                                                    mkdir --parents "$GIT_WORK_TREE"
                                                                                                    git init 2>&1
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git config "${ name }" "${ value }"'' ) configs ) ) }
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''ln --symbolic "${ value }" "${ self }/git/hooks/${ name }"'' ) hooks ) ) }
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git remote add "${ name }" "${ value }"'' ) remotes ) ) }
                                                                                                    ${ if builtins.typeOf setup == "string" then ''if read -t 0 ; then cat | exec ${ setup } "$@" ; else exec ${ setup } "$@" ; fi'' else "#" }
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/application" ;
                                                                    release = release ;
                                                                    targets = [ "git" "work-tree" ] ;
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
                                                                                    NOW="$( date +%s )" || exit 64
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
                                                                                    SCRATCH="$( uuidgen | sha512sum | cut --bytes -128 )" || exit 64
                                                                                    BRANCH="$( echo "scratch/$SCRATCH" | cut --bytes -100 )" || exit 64
                                                                                    git checkout -b "$BRANCH"
                                                                                '' ;
                                                                        } ;
                                                                    in "${ scratch }/bin/scratch" ;
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
                                                                                                DOT_SSH="$( ${ point.resource } )" || exit 64
                                                                                                exec ssh -F "$DOT_SSH/${ point.target }" "$@"
                                                                                            '' ;
                                                                            } ;
                                                                    in "${ ssh-command }/bin/ssh-command" ;
                                                        in
                                                            {
                                                                debug =
                                                                    {
                                                                        alpha =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        failure : resources : self :
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
                                                                                                                exit 155
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/release" ;
                                                                                    targets = [ "self" ] ;
                                                                                } ;
                                                                        beta =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        failure : resources : self :
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
                                                                                                                exit 155
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/release" ;
                                                                                    targets = [ "self" ] ;
                                                                                } ;
                                                                    } ;
                                                                control-paths =
                                                                    {
                                                                        mobile = ignore : { } ;
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
                                                                        mobile =
                                                                            dot-ssh
                                                                                {
                                                                                    control-master = "auto" ;
                                                                                    # control-path = resources : { resource = resources.control-paths.mobile ; target = "%C" ; } ;
                                                                                    host = "mobile" ;
                                                                                    host-name = "192.168.1.202" ;
                                                                                    # identity-file = resources : { resource = resources.secrets.dot-ssh.boot."identity.asc.age" ; target = "secret" ; } ;
                                                                                    port = 8022 ;
                                                                                    strict-host-key-checking = true ;
                                                                                    user = "git" ;
                                                                                    user-known-hosts-file = resources : { resource = resources.secrets.dot-ssh.boot."identity.asc.age" ; target = "secret" ; } ;
                                                                                } ;
                                                                    } ;
                                                                home =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                failure : resources : self :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "application" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            DOT_GNUPG="$( ${ resources.dot-gnupg } )" || ${ failure "6b717cd6" }
                                                                                                            ln --symbolic "$DOT_GNUPG" /links
                                                                                                            ln --symbolic "$DOT_GNUPG/dot-gnupg" /mount/dot-gnupg
                                                                                                            # DOT_SSH="$( ${ resources.dot-ssh.mobile } )" || ${ failure "6c398030" }
                                                                                                            # ln --symbolic "$DOT_SSH" /links
                                                                                                            # ln --symbolic "$DOT_SSH/config" /mount/dot-ssh
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/application" ;
                                                                            targets =
                                                                                [
                                                                                    "dot-gnupg"
                                                                                    # "dot-ssh"
                                                                                ] ;
                                                                        } ;
                                                                repository =
                                                                    {
                                                                        private =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "alias.milestone" = "!${ milestone }" ;
                                                                                            "alias.scratch" = "!${ scratch }" ;
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
                                                                                                        name = "application" ;
                                                                                                        runtimeInputs = [ pkgs.git pkgs.libuuid ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                git fetch origin main 2>&1
                                                                                                                # git checkout origin/main
                                                                                                                # git checkout -b "scratch/$( uuidgen )"
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/application" ;
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
                                                                                            failure : resources : self :
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
                                                            } ;
                                                in
                                                    visitor.lib.implementation
                                                        {
                                                            lambda =
                                                                path : value :
                                                                    let
                                                                        rsrcs =
                                                                            resources.lib
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
                                                                                                        failure = string : builtins.concatStringsSep "" [ "exit" " " "1" ( builtins.replaceStrings [ "0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f" ] [ "00" "01" "02" "03" "04" "05" "06" "07" "08" "09" "10" "11" "12" "13" "14" "15" ] ( builtins.substring 0 1 ( builtins.hashString "sha512" string ) ) ) ] ;
                                                                                                        in init failure resources_
                                                                                                else init ;
                                                                                            release = release ;
                                                                                            targets = targets ;
                                                                                            transient = transient ;
                                                                                        } ;
                                                                                in identity ( value null ) ;
                                                                        in rsrcs.implementation ;
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
                                                                                pkgs.git
                                                                                pkgs.yq
                                                                                pkgs.lsof
                                                                                pkgs.inotify-tools
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
                                                                                            name = "home" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text = resources_.home ;
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
                                    checks =
                                        let
                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                                            test-fun =
                                                name : throws-error : has-standard-error : target-mismatch : is-transient : test :
                                                    let
                                                        rsrcs =
                                                            resources.lib
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
                                                                                                    exit ${ if throws-error then "125" else "0" }
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
                                                            in { name = name ; value = rsrcs.check test ; } ;
                                            tests =
                                                [
                                                    (
                                                        test-fun
                                                            "Happy Case"
                                                            false
                                                            false
                                                            false
                                                            false
                                                            {
                                                                arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
                                                                expected-dependencies = [ ] ;
                                                                expected-index = "0000000311691948" ;
                                                                expected-originator-pid = 37 ;
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
                                            tester =
                                                { config , pkgs , ... } :
                                                    {
                                                        systemd.services =
                                                            {
                                                                user-home-test =
                                                                    {
                                                                        after = [ "redis.service" ] ;
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
                                                                                                            if ! which home
                                                                                                            then
                                                                                                                echo "There is no home" >> /tmp/shared/FLAG
                                                                                                            elif ! home
                                                                                                            then
                                                                                                                echo "There was a problem executing home" >> /tmp/shared/FLAG
                                                                                                            else
                                                                                                                RESOURCE="$( home )"
                                                                                                                if [[ -L "$RESOURCE/.gpg" ]]
                                                                                                                then
                                                                                                                    echo "There was no gpg directory" >> /tmp/shared/FLAG
                                                                                                                fi
                                                                                                            fi
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/application" ;
                                                                                User = config.personal.name ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                                root-test =
                                                                    {
                                                                        after = [ "user-home-test.service" ] ;
                                                                        serviceConfig =
                                                                            {
                                                                                ExecStart = "${ pkgs.systemd }/bin/systemctl poweroff" ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                            } ;
                                                    } ;
                                        } ;
                                } ;
            } ;
}
