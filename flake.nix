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
                                                                                                                # path = path : value : value ;
                                                                                                                set = path : set : set ;
                                                                                                            }
                                                                                                            primary ;
                                                                                                    in
                                                                                                        ''
                                                                                                            GNUPGHOME=${ self }/dot-gnupg
                                                                                                            export GNUPGHOME
                                                                                                            mkdir "$GNUPGHOME"
                                                                                                            SECRET_KEYS="$( ${ attributes.secret-keys.resource } )" || exit 64
                                                                                                            gpg --batch --yes --homedir "$GNUPGHOME" --import "$SECRET_KEYS/${ attributes.secret-keys.target }"
                                                                                                            OWNERTRUST="$( ${ attributes.ownertrust.resource } )" || exit 64
                                                                                                            gpg --batch --yes --homedir "$GNUPGHOME" --import-ownertrust "$OWNERTRUST/${ attributes.ownertrust.target }"
                                                                                                            gpg --batch --yes --homedir "$GNUPGHOME" --update-trustdb
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
                                                                    catted =
                                                                        let
                                                                            mapper = value : "${ value.name } ${ builtins.concatStringsSep "" [ "$" value.name ] }${ if builtins.typeOf value.value == "string" then "" else "/${ value.value.target }" }" ;
                                                                            in builtins.map mapper sorted ;
                                                                    indent = if builtins.typeOf host == "null" then [ ] else [ "\t" ] ;
                                                                    listed = builtins.attrValues setted ;
                                                                    setted =
                                                                        let
                                                                            mapper =
                                                                                name : value :
                                                                                    let
                                                                                        resources =
                                                                                            [
                                                                                                "control-path"
                                                                                                "identity-file"
                                                                                                "user-known-hosts-file"
                                                                                                "identity-agent"
                                                                                                "pkcs11-provider"
                                                                                                "proxy-command"
                                                                                            ] ;
                                                                                        in
                                                                                            {
                                                                                                name =
                                                                                                    let
                                                                                                        lower-case = [ "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" ] ;
                                                                                                        hyphen-case = builtins.map ( letter : builtins.concatStringsSep "" [ "-" letter ] ) lower-case ;
                                                                                                        upper-case = [ "A" "B" "C" "D" "E" "F" "G" "H" "I" "J" "K" "L" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" ] ;
                                                                                                        name-lower-cased = builtins.replaceStrings upper-case lower-case name-prefixed ;
                                                                                                        name-prefixed = builtins.concatStringsSep "" [ "-" name ] ;
                                                                                                        name-space-cased = builtins.replaceStrings hyphen-case upper-case name-lower-cased ;
                                                                                                        in name-space-cased ;
                                                                                                index = if name == "host" then 0 else 1 ;
                                                                                                value =
                                                                                                    let
                                                                                                        booleans =
                                                                                                            [
                                                                                                                "batch-mode"
                                                                                                                "challenge-response-authentication"
                                                                                                                "compression"
                                                                                                                "forward-agent"
                                                                                                                "gateway-ports"
                                                                                                                "gssapi-authentication"
                                                                                                                "gssapi-delegate-credentials"
                                                                                                                "ignore-unknown"
                                                                                                                "kbd-interactive-authentication"
                                                                                                                "no-host-authentication-for-localhost"
                                                                                                                "password-authentication"
                                                                                                                "permit-local-command"
                                                                                                                "permit-remote-open"
                                                                                                                "pubkey-authentication"
                                                                                                                "strict-host-key-checking"
                                                                                                                "verify-host-key-dns"
                                                                                                                "forward-x11"
                                                                                                                "forward-x11-trusted"
                                                                                                            ] ;
                                                                                                    integers =
                                                                                                        [
                                                                                                            "port"
                                                                                                            "connect-timeout"
                                                                                                            "server-alive-count-max"
                                                                                                            "server-alive-interval"
                                                                                                        ] ;
                                                                                                    in
                                                                                                        if builtins.any ( n : n == name ) booleans && builtins.typeOf value == "bool" then if value then ''"YES"'' else ''"NO"''
                                                                                                        else if builtins.any ( n : n == name ) integers then builtins.concatStringsSep "" [ "\"" ( builtins.toString value ) "\"" ]
                                                                                                        else if builtins.any ( n : n == name ) resources then value resources_
                                                                                                        else builtins.concatStringsSep "" [ "\"" value "\"" ] ;
                                                                                            } ;
                                                                            in builtins.mapAttrs mapper primary ;
                                                                    sorted = builtins.sort ( a : b : if a.index < b.index then true else if a.index > b.index then false else a.name < b.name ) listed ;
                                                                    variabled =
                                                                        let
                                                                            mapper =
                                                                                value :
                                                                                    builtins.concatLists
                                                                                        [
                                                                                            ( if builtins.typeOf value.value == "string" then [ ''${ value.name }=${ value.value }'' ] else [ ''${ value.name }="$( ${ value.value.resource } )" || exit 64'' ] )
                                                                                            ( if builtins.typeOf value.value == "string" then [ ] else [ ''ln --symbolic "${ builtins.concatStringsSep "" [ "$" value.name ] }" /links'' ] )
                                                                                        ] ;
                                                                            in builtins.map mapper sorted ;
                                                                    in
                                                                        {
                                                                            description = "ssh config" ;
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
                                                                                                            ${ builtins.concatStringsSep "\n" ( builtins.concatLists variabled ) }
                                                                                                            cat > /mount/config <<EOF
                                                                                                            ${ builtins.concatStringsSep "\n" catted }
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
                                                                    description = "git repository" ;
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
                                                                                    description = seed : builtins.elemAt seed.path 0 ;
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
                                                                                                                exit 155
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/release" ;
                                                                                    targets = [ "self" ] ;
                                                                                } ;
                                                                        beta =
                                                                            ignore :
                                                                                {
                                                                                    description = seed : builtins.elemAt seed.path 0 ;
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
                                                                                    control-path = resources : { resource = resources.control-paths.mobile ; target = "%C" ; } ;
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
                                                                            description = "home" ;
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
                                                                                                            DOT_GNUPG="$( ${ resources.dot-gnupg } )" || exit 64
                                                                                                            ln --symbolic "$DOT_GNUPG" /links
                                                                                                            ln --symbolic "$DOT_GNUPG/dot-gnupg" /mount/.gpg
                                                                                                            mkdir --parents /mount/.ssh
                                                                                                            # DOT_PASSWORD_STORE="$( ${ resources.dot-password-store } )" || exit 64
                                                                                                            # ln --symbolic "$DOT_PASSWORD_STORE" /links
                                                                                                            # ln --symbolic "$DOT_PASSWORD_STORE" ~/.password-store
                                                                                                            MOBILE="$( ${ resources.dot-ssh.mobile } )" || exit 64
                                                                                                            ln --symbolic "$MOBILE" /links
                                                                                                            ln --symbolic "$MOBILE/config" /mount/.ssh/mobile.config
                                                                                                            mkdir --parents /mount/repository
                                                                                                            PRIVATE="$( ${ resources.repository.private } )" || exit 64
                                                                                                            ln --symbolic "$PRIVATE" /links
                                                                                                            ln --symbolic "$PRIVATE" /mount/repository/private
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/application" ;
                                                                            targets =
                                                                                [
                                                                                    ".gpg"
                                                                                    # ".password-store"
                                                                                    ".ssh"
                                                                                    "repository"
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
                                                                                        description = "secret" ;
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
                                                                                    description = point.description ;
                                                                                    findutils = pkgs.findutils ;
                                                                                    flock = pkgs.flock ;
                                                                                    gawk = pkgs.gawk ;
                                                                                    inotify-tools = pkgs.inotify-tools ;
                                                                                    jq = pkgs.jq ;
                                                                                    init = point.init ;
                                                                                    makeBinPath = pkgs.lib.makeBinPath ;
                                                                                    makeWrapper = pkgs.makeWrapper ;
                                                                                    mkDerivation = pkgs.stdenv.mkDerivation ;
                                                                                    ps = pkgs.ps ;
                                                                                    resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                                    release = point.release ;
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
                                                                                        description ? null ,
                                                                                        init ? null ,
                                                                                        release ? null ,
                                                                                        targets ? [ ] ,
                                                                                        transient ? false
                                                                                    } :
                                                                                        {
                                                                                            description = description ;
                                                                                            init = if builtins.typeOf init == "lambda" then init resources_ else init ;
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
                                    modules =
                                        {
                                            user = user ;
                                            tester =
                                                { config , pkgs , ... } :
                                                    {
                                                        systemd.services =
                                                            {
                                                                user-test =
                                                                    {
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
                                                                                                            echo 0 > /tmp/shared/status
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/application" ;
                                                                                User = config.personal.name ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                                root-test =
                                                                    {
                                                                        after = [ "user-test.service" ] ;
                                                                        serviceConfig =
                                                                            {
                                                                                ExecStart = "${ pkgs.systemd }/bin/systemctl poweroff" ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                            } ;
                                                    } ;
                                        } ;
                                    checks.${ system } =
                                        let
                                            list =
                                                builtins.concatLists
                                                    [
                                                        ( resources-fun false false false false false false ( self + "/expected/false/false/false/false/false/false/0/checkpoint-pre" ) ( self + "/expected/false/false/false/false/false/false/0/checkpoint-post" ) [ ] )
                                                        ( resources-fun false false false false false true ( self + "/expected/false/false/false/false/false/true/0/checkpoint-pre" ) ( self + "/expected/false/false/false/false/false/true/0/checkpoint-post" ) [ ] )
                                                        # ( resources-fun false false false true false false ( self + "/expected/false/false/false/true/false/false/0/checkpoint-pre" ) ( self + "/expected/false/false/false/true/false/false/0/checkpoint-post" ) [ { command = "/build/resources/recovery/0000000000000002/recovery.sh" ; checkpoint = self + "/expected/false/false/false/true/false/false/1/checkpoint" ; } ] )
                                                    ] ;
                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                                            resources-fun =
                                                outer-init-error : outer-init-target : inner-init-status : inner-release-status : outer-release-status : transient : checkpoint-pre : checkpoint-post : commands :
                                                    let
                                                        label = "${ builtins.concatStringsSep "/" ( builtins.map ( delta : if delta then "true" else "false" ) [ outer-init-error outer-init-target inner-init-status inner-release-status outer-release-status transient ] ) }" ;
                                                        rsrcs =
                                                            let
                                                                inner =
                                                                    let
                                                                        rsrcs =
                                                                            resources.lib
                                                                                {
                                                                                    buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                                                                    coreutils = pkgs.coreutils ;
                                                                                    findutils = pkgs.findutils ;
                                                                                    flock = pkgs.flock ;
                                                                                    gawk = pkgs.gawk ;
                                                                                    init =
                                                                                        self :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    exit ${ if inner-init-status then "194" else "0" }
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    inotify-tools = pkgs.inotify-tools ;
                                                                                    jq = pkgs.jq ;
                                                                                    makeBinPath = pkgs.lib.makeBinPath ;
                                                                                    makeWrapper = pkgs.makeWrapper ;
                                                                                    mkDerivation = pkgs.stdenv.mkDerivation ;
                                                                                    ps = pkgs.ps ;
                                                                                    release =
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "release" ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                echo a95899206afa17a2a162e5593a1d11edc51659a42e407dfaef5358ca3cdf853c802a1e4ff247a175f63414e0f5d3d6ed879fd3de93315763fe6d956d0bb5f6d9
                                                                                                                echo 2cc598e370346e211791b3753b9b181cb530116a330f1c32047a8c25e696b1c3029082f1630d807fce76cec9bf1ab246a29943f308343fe379b06105d5f857ff ${ if inner-release-status then ">&2" else "> /dev/null" }
                                                                                                                exit ${ if inner-release-status then "124" else "0" }
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/release" ;
                                                                                    resources-directory = "/build/resources" ;
                                                                                    transient = transient ;
                                                                                    visitor = visitor ;
                                                                                    writeShellApplication = pkgs.writeShellApplication ;
                                                                                    yq-go = pkgs.yq-go ;
                                                                                } ;
                                                                        in rsrcs.implementation ;
                                                                in
                                                                    resources.lib
                                                                        {
                                                                            buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                                                            coreutils = pkgs.coreutils ;
                                                                            findutils = pkgs.findutils ;
                                                                            flock = pkgs.flock ;
                                                                            gawk = pkgs.gawk ;
                                                                            init =
                                                                                self :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            # INNER=${ inner } || exit 221
                                                                                                            # ln --symbolic "$INNER" /link
                                                                                                            echo 47327ad3eb2752176d84351d344582a301a89ce0333cd91bb3faa4e5420b1a0ebb1600c368d941c334c003f08683a8f47f8491e557fbb39eae080ba83f81375f > /mount/${ if outer-init-target then "128fea4cfff62960" else "target" }
                                                                                                            echo 0222ce319d2c8cbafe6848639aa582f0479199e8e4e4bda8e6efd915e0113d465b77c1a1a9e6984767c9267e6ebab96e4f3ffb930a83d773533985605584a1c7
                                                                                                            echo 254e430b0d85bf0f03e2cee73734901ac0c6cd6cac0b01522e24ed87efe588b019d82a5edc544de48c72600cffe04836fadaa8b0f4654f1b8a0dfbe2a5b033a0 ${ if outer-init-error then ">&2" else "> /dev/null" }
                                                                                                        '' ;
                                                                                                } ;
                                                                                            in "${ application }/bin/init" ;
                                                                            jq = pkgs.jq ;
                                                                            inotify-tools = pkgs.inotify-tools ;
                                                                            makeBinPath = pkgs.lib.makeBinPath ;
                                                                            makeWrapper = pkgs.makeWrapper ;
                                                                            mkDerivation = pkgs.stdenv.mkDerivation ;
                                                                            ps = pkgs.ps ;
                                                                            release =
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "release" ;
                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        echo 8d6fbfb0600dbadc2cd421f1a212144d023b49cb12388779d4c2f98d51e34795be16ebb7ec6d621bd85f85001adf46ce79711b097cc1d9e3bb65cfdefc2e10fb
                                                                                                        echo a89f5e1a40c37509d44c5f10b22d34c57f58f8516b211e7adb3834223d65dab9e29cb86d180b82db51e5e6561d0d7dfc98848d54f44de69319e0f80dd4caa8b2 ${ if outer-release-status then ">&2" else "> /dev/null" }
                                                                                                        exit ${ if outer-release-status then "249" else "0" }
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/release" ;
                                                                            resources-directory = "/build/resources" ;
                                                                            targets = [ "target" ] ;
                                                                            testing-locks = true ;
                                                                            visitor = visitor ;
                                                                            yq-go = pkgs.yq-go ;
                                                                            writeShellApplication = pkgs.writeShellApplication ;
                                                                        } ;
                                                        in
                                                            [
                                                                {
                                                                    name = builtins.hashString "sha512" label ;
                                                                    value =
                                                                        rsrcs.check
                                                                            {
                                                                                arguments = [ "2e47fd27a17063c94597b1582090b779d761d326d54784a19f3381953d37e1c7d1606cf96139f1d9aa1b9fad63868bc90fe9179d62e70e95d67a62df61a0c917" "1eee5f23d9b8a698d78699954c0d2983a4b871461b738bd72eaa616a52d12fa38a8fc72ffc5d45b946ec5c4b55c36a26896a0901532852650af133f3493f1bbf" ] ;
                                                                                bash = pkgs.bash ;
                                                                                checkpoint-post = checkpoint-post ;
                                                                                checkpoint-pre = checkpoint-pre ;
                                                                                commands = commands ;
                                                                                diffutils = pkgs.diffutils ;
                                                                                label = label ;
                                                                                mount = "/build/resources/mounts/0000000000000002" ;
                                                                                standard-input = "91caebc6ea3ebe5b76e58d6ff22741badf8f57abf854235f20e0850d2aa310e98a8ce80eb5ed97b99c434380c6fd48a0631066cd5d3cb42ac3076de11ccf3d80" ;
                                                                                status = if outer-init-error || outer-init-target || inner-init-status then 184 else 0 ;
                                                                            } ;
                                                                }
                                                            ] ;
					                        in
						                        {
						                            foobar =
						                                pkgs.stdenv.mkDerivation
						                                    {
						                                        installPhase =
						                                            ''
						                                                touch $out
						                                                # echo e16c57c54d280eb8114187386ba375f3e507ee2b91cd76ffa6f2f76da709d2daf51ae387d65ebd8775b715d6b5cb85d17c39d362abda86c6bdb623540f52306d >&2
						                                                # exit 167
						                                            '' ;
                                                                name = "foobar" ;
                                                                src = ./. ;
						                                    } ;
                                                } // ( builtins.listToAttrs list ) ;
                                } ;
            } ;
}
