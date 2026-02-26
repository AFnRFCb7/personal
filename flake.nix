# 727688ed
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
                        fixture ,
                        nixpkgs ,
                        private ,
                        resource ,
                        system ,
                        visitor
                    } @primary :
                        let
                            _failure = failure.lib { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; visitor = visitor ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                            _resource =
                                {
                                    channel ,
                                    resources-directory ,
                                    resources ,
                                    root-directory
                                } :
                                    resource.lib
                                        {
                                            buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                            channel = channel ;
                                            coreutils = pkgs.coreutils ;
                                            failure = _failure.implementation "f135add3" ;
                                            findutils = pkgs.findutils ;
                                            flock = pkgs.flock ;
                                            gnutar = pkgs.gnutar ;
                                            inotify-tools = pkgs.inotify-tools ;
                                            jq = pkgs.jq ;
                                            makeWrapper = pkgs.makeWrapper ;
                                            mkDerivation = pkgs.stdenv.mkDerivation ;
                                            nix = pkgs.nix ;
                                            ps = pkgs.ps ;
                                            redis = pkgs.redis ;
                                            resources = resources ;
                                            resources-directory = resources-directory ;
                                            sequential-start = ''$( head /dev/urandom | tr -dc '1-9' | head -c 15 )'' ;
                                            root-directory = root-directory ;
                                            util-linux = pkgs.util-linux ;
                                            visitor = _visitor.implementation ;
                                            writeShellApplication = pkgs.writeShellApplication ;
                                            yq-go = pkgs.yq-go ;
                                            zstd = pkgs.zstd ;
                                        } ;
                            _visitor = visitor.lib { } ;
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
                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
                            user =
                                { config , lib , pkgs , ... } :
                                    let
                                        resources =
                                            _visitor.implementation
                                                {
                                                    lambda =
                                                        path : value :
                                                            let
                                                                point = value null ;
                                                                r =
                                                                    _resource
                                                                        {
                                                                            channel = config.personal.channel ;
                                                                            resources = resources ;
                                                                            resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                            root-directory = "/home/${ config.personal.name }/.gc-roots" ;
                                                                        } ;
                                                                    in
                                                                        r.implementation
                                                                            {
                                                                                depth = point.depth or 0 ;
                                                                                init = point.init or null ;
                                                                                init-resolutions = point.init-resolutions or [ ] ;
                                                                                release = point.release or null ;
                                                                                release-resolutions = point.release-resolutions or [ ] ;
                                                                                seed =
                                                                                    ( point.seed or { } ) //
                                                                                    {
                                                                                        path = path ;
                                                                                    } ;
                                                                                targets = point.targets or [ ] ;
                                                                                transient = point.transient or false ;
                                                                            } ;
                                                }
                                                {
                                                    foobar =
                                                        {
                                                            bin =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils wrap ] ;
                                                                                                text =
                                                                                                    let
                                                                                                        bin =
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "bin" ;
                                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    echo bin
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/bin" ;
                                                                                                        in
                                                                                                            ''
                                                                                                                echo "$$"
                                                                                                                wrap ${ bin } bin 0500 --literal-plain PATH
                                                                                                            '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ "bin" ] ;
                                                                    } ;
                                                            foobar =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils root ( _failure.implementation "fe174c03" ) ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        INIT_STATUS="$1"
                                                                                                        INIT_ARGUMENTS="$2"
                                                                                                        RELEASE_STATUS="$3"
                                                                                                        RELEASE_ARGUMENTS="$4"
                                                                                                        echo "$INIT_ARGUMENTS"
                                                                                                        echo "$RELEASE_STATUS" > /mount/status
                                                                                                        echo "$RELEASE_ARGUMENTS" > /mount/arguments
                                                                                                        if "$INIT_STATUS"
                                                                                                        then
                                                                                                            failure 375c5e8c
                                                                                                        fi
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        seed =
                                                                            {
                                                                                release =
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "release" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils ( _failure.implementation "f99f6e39" ) ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            RELEASE_STATUS="$( cat /mount/status )" || failure "6e02a8fe"
                                                                                                            RELEASE_ARGUMENTS="$( cat /mount/arguments )" || failure "1991407b"
                                                                                                            echo "$RELEASE_ARGUMENTS"
                                                                                                            if $RELEASE_STATUS
                                                                                                            then
                                                                                                                failure e82ab2c6
                                                                                                            fi
                                                                                                        '' ;
                                                                                                } ;
                                                                                            in "${ application }/bin/release" ;
                                                                                resolutions =
                                                                                    {
                                                                                        init = [ "alpha" "beta" ] ;
                                                                                        release = [ "gamma" "delta" ] ;
                                                                                    } ;
                                                                            } ;
                                                                        targets = [ "arguments" "status" ] ;
                                                                        transient = true ;
                                                                    } ;
                                                        } ;
                                                    production =
                                                        {
                                                            age =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.age pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        age-keygen -y ${ config.personal.agenix } | tr -d '\n' > /mount/public
                                                                                                        chmod 0400 /mount/public
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ "public" ] ;
                                                                    } ;
                                                            application =
                                                                {
                                                                    chromium =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ root failure ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                CONFIG=${ resources.production.repository.pads.home.chromium.data { failure = "failure 0c755ed8" ; } }
                                                                                                                root "$CONFIG"
                                                                                                                mkdir --parents /mount/etc
                                                                                                                ln --symbolic "$CONFIG/repository/secret" /mount/etc/config
                                                                                                                mkdir --parents /mount/bin
                                                                                                                DATA=${ resources.production.repository.pads.home.chromium.data { failure = "fdcf6e38" ; } }
                                                                                                                root "$DATA"
                                                                                                                ln --symbolic "$DATA/repository/secret" /mount/etc/data
                                                                                                                root ${ pkgs.chromium }
                                                                                                                ln --symbolic ${ pkgs.chromium }/bin/chromium /mount/bin/chromium
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "bin" "etc" ] ;
                                                                            } ;
                                                                    mutable =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                mkdir --parents /mount/bin
                                                                                                                mkdir --parents /mount/etc
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "bin" "etc" ] ;
                                                                            } ;
                                                                    unlock =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ wrap ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                unlock =
                                                                                                                    let
                                                                                                                        application =
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "unlock" ;
                                                                                                                                    runtimeInputs = [ pkgs.gnupg ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            DOT_GNUPG=${ resources.production.dot-gnupg { failure = "failure 75dc4165" ; } }
                                                                                                                                            export GNUPGHOME="$DOT_GNUPG/dot-gnupg"
                                                                                                                                            gpg --homedir "$GNUPGHOME" --sign --local-user ${ config.personal.chromium.home.data.email } --dry-run
                                                                                                                                        '' ;
                                                                                                                                } ;
                                                                                                                        in "${ application }/bin/unlock" ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        wrap ${ unlock } bin/unlock 0500 --literal-plain DOT_GNUPG --literal-plain GNUPGHOME --literal-plain DOT_GNUPG --literal-plain PATH --uuid 1c39417f
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                targets = [ "bin" ] ;
                                                                            } ;
                                                                } ;
                                                            alpha =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        touch /mount/secret
                                                                                                    '' ;
                                                                                            } ;
                                                                                        in "${ application }/bin/init" ;
                                                                        targets = [ "secret" ] ;
                                                                    } ;
                                                             autocomplete =
                                                                let
                                                                     autocomplete =
                                                                         name : value : ignore :
                                                                             let
                                                                                 hash = builtins.hashString "sha512" "${ name }${ value }" ;
                                                                                 in
                                                                                     {
                                                                                        depth = 1 ;
                                                                                         init =
                                                                                             { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                                 let
                                                                                                     application =
                                                                                                         pkgs.writeShellApplication
                                                                                                             {
                                                                                                                 name = "init" ;
                                                                                                                 text =
                                                                                                                     let
                                                                                                                         autocomplete =
                                                                                                                            let
                                                                                                                                application =
                                                                                                                                     pkgs.writeShellApplication
                                                                                                                                         {
                                                                                                                                             name = "autocomplete" ;
                                                                                                                                             text =
                                                                                                                                                 ''
                                                                                                                                                     A${ hash } ( ) {
                                                                                                                                                        ${ value }
                                                                                                                                                     }
                                                                                                                                                     complete -F A${ hash } ${ name }
                                                                                                                                                 '' ;
                                                                                                                                         } ;
                                                                                                                                 in "${ application }/bin/autocomplete" ;
                                                                                                                         in
                                                                                                                             ''
                                                                                                                                 ln --symbolic ${ autocomplete } /mount/autocomplete.sh
                                                                                                                             '' ;
                                                                                                             } ;
                                                                                                        in "${ application }/bin/init" ;
                                                                                         targets = [ "autocomplete.sh" ] ;
                                                                                     } ;
                                                                     in
                                                                         {
                                                                            pass =
                                                                                autocomplete
                                                                                    "pass"
                                                                                    ''
                                                                                        RESOURCE=${ resources.production.repository.pass { } }
                                                                                        export PASSWORD_STORE_DIR="$RESOURCE/repository"
                                                                                        # shellcheck disable=SC1091
                                                                                        source ${ pkgs.pass }/share/bash-completion/completions/pass
                                                                                        _pass "$@"
                                                                                    '' ;
                                                                            secrets =
                                                                                autocomplete
                                                                                    "secrets"
                                                                                    ''
                                                                                            local cur
                                                                                            cur="${ builtins.concatStringsSep "" [ "$" "{" "COMP_WORDS[COMP_CWORD]" "}" ] }"

                                                                                            # list of allowed names
                                                                                            local allowed=(
                                                                                                "dot-gnupg/ownertrust"
                                                                                                "dot-gnupg/secret-keys"
                                                                                                "dot-ssh/github/known-hosts"
                                                                                                "dot-ssh/github/identity"
                                                                                                "dot-ssh/mobile/known-hosts"
                                                                                                "dot-ssh/mobile/identity"
                                                                                                "github/token"
                                                                                            )
                                                                                        COMPREPLY=()
                                                                                        mapfile -t COMPREPLY < <(compgen -W "${builtins.concatStringsSep "" [ "$" "{" "allowed[*]" "}" ] }" -- "$cur")
                                                                                    '' ;
                                                                            silly =
                                                                                 autocomplete
                                                                                     "silly"
                                                                                    ''
                                                                                        # shellcheck disable=SC2207
                                                                                        COMPREPLY=( $( compgen -W "alpha beta" -- "${ builtins.concatStringsSep "" [ "$" "{" "COMP_WORDS[1]" "}" ] }" ) )
                                                                                    '' ;
                                                                         } ;
                                                            bin =
                                                                let
                                                                    bin =
                                                                        { name , environment , runtimeInputs , script , variables } : ignore :
                                                                            {
                                                                                depth = 1 ;
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ wrap ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                bin =
                                                                                                                    let
                                                                                                                        application =
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = name ;
                                                                                                                                    runtimeInputs = builtins.concatLists [ ( runtimeInputs pkgs ) [ failure ] ] ;
                                                                                                                                    text =
                                                                                                                                        let
                                                                                                                                            list =
                                                                                                                                                let
                                                                                                                                                    mapper =
                                                                                                                                                        name : value :
                                                                                                                                                            let
                                                                                                                                                                length-a = builtins.stringLength string ;
                                                                                                                                                                length-b = builtins.stringLength stripped ;
                                                                                                                                                                oid = length-a - length-b ;
                                                                                                                                                                string = value resources ;
                                                                                                                                                                stripped = builtins.replaceStrings ( builtins.attrNames variables ) ( builtins.map ( value : "" ) ( builtins.attrNames variables ) ) string ;
                                                                                                                                                                in
                                                                                                                                                                    {
                                                                                                                                                                        length-a = length-a ;
                                                                                                                                                                        length-b = length-b ;
                                                                                                                                                                        oid = oid ;
                                                                                                                                                                        name = name ;
                                                                                                                                                                        string = string ;
                                                                                                                                                                        stripped = stripped ;
                                                                                                                                                                    } ;
                                                                                                                                                    in builtins.attrValues ( builtins.mapAttrs mapper variables ) ;
                                                                                                                                            sorted =
                                                                                                                                                let
                                                                                                                                                    comparator = a : b : ( a.oid < b.oid ) || ( a.oid == b.oid && a.name < b.name ) ;
                                                                                                                                                    in builtins.sort comparator list ;
                                                                                                                                            in
                                                                                                                                                ''
                                                                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.map ( value : "${ value.name }=${ value.string } # ${ builtins.toString value.oid }" ) sorted ) }
                                                                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.map ( name : ''export ${ name }="${ builtins.concatStringsSep "" [ "$" name ] }"'' ) environment ) }
                                                                                                                                                    if [[ -t 0 ]]
                                                                                                                                                    then
                                                                                                                                                        ${ script }
                                                                                                                                                    else
                                                                                                                                                        # shellcheck disable=SC2216
                                                                                                                                                        ${ pkgs.coreutils }/bin/cat | ${ script }
                                                                                                                                                    fi
                                                                                                                                                '' ;
                                                                                                                                } ;
                                                                                                                        in "${ application }/bin/${ name }" ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        wrap ${ bin } ${ name } 0500 --literal-plain PATH ${ builtins.concatStringsSep "" ( builtins.map ( value : " --literal-plain ${ value }" ) ( builtins.attrNames variables ) ) } --uuid 3d888900
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ name ] ;
                                                                            } ;
                                                                    in
                                                                        {
                                                                            chromium =
                                                                                bin
                                                                                    {
                                                                                        environment =
                                                                                            [
                                                                                                "XDG_CONFIG_HOME"
                                                                                                "XDG_DATA_HOME"
                                                                                            ] ;
                                                                                        name = "chromium" ;
                                                                                        runtimeInputs = pkgs : [ pkgs.chromium ] ;
                                                                                        script = ''chromium "$@"'' ;
                                                                                        variables =
                                                                                            {
                                                                                                XDG_CONFIG_HOME_RESOURCE = resources : resources.production.volume.chromium.config { } ;
                                                                                                XDG_DATA_HOME_RESOURCE = resources : resources.production.volume.chromium.data { } ;
                                                                                                XDG_CONFIG_HOME = resources : "$XDG_CONFIG_HOME_RESOURCE/secret" ;
                                                                                                XDG_DATA_HOME = resources : "$XDG_DATA_HOME_RESOURCE/secret" ;
                                                                                            } ;
                                                                                    } ;
                                                                            gpg =
                                                                                bin
                                                                                    {
                                                                                        environment =
                                                                                            [
                                                                                                "GNUPGHOME"
                                                                                            ] ;
                                                                                        name = "gpg" ;
                                                                                        runtimeInputs = pkgs : [ pkgs.gnupg ] ;
                                                                                        script = ''gpg --homedir "$GNUPGHOME" "$@"'' ;
                                                                                        variables =
                                                                                            {
                                                                                                DOT_GNUPG = resources : resources.production.dot-gnupg { } ;
                                                                                                GNUPGHOME = resources : "$DOT_GNUPG/dot-gnupg" ;
                                                                                            } ;
                                                                                    } ;
                                                                            idea-community =
                                                                                bin
                                                                                    {
                                                                                        environment = [ ] ;
                                                                                        name = "idea-community" ;
                                                                                        runtimeInputs = pkgs : [ pkgs.jetbrains.idea-community ] ;
                                                                                        script = ''idea-community "$RESOURCE/repository" "$@"'' ;
                                                                                        variables =
                                                                                            {
                                                                                                RESOURCE = resources : resources.production.repository.studio.entry { } ;
                                                                                            } ;
                                                                                    } ;
                                                                            pass =
                                                                                bin
                                                                                    {
                                                                                        environment =
                                                                                            [
                                                                                                "PASSWORD_STORE_GPG_OPTS"
                                                                                                "PASSWORD_STORE_DIR"
                                                                                            ] ;
                                                                                        name = "pass" ;
                                                                                        runtimeInputs = pkgs : [ pkgs.pass ] ;
                                                                                        script = ''pass "$@"'' ;
                                                                                        variables =
                                                                                            {
                                                                                                DOT_GNUPG = resources : resources.production.dot-gnupg { } ;
                                                                                                RESOURCE = resources : resources.production.repository.pass { } ;
                                                                                                PASSWORD_STORE_GPG_OPTS = resources : ''"--homedir $DOT_GNUPG/dot-gnupg"'' ;
                                                                                                PASSWORD_STORE_DIR = resources : "$RESOURCE/repository " ;
                                                                                            } ;
                                                                                    } ;
                                                                            secrets =
                                                                                bin
                                                                                    {
                                                                                        environment = [ "DOT_SSH" "SECRETS" ] ;
                                                                                        name = "secrets" ;
                                                                                        runtimeInputs = pkgs : [ pkgs.coreutils ] ;
                                                                                        script =
                                                                                            let
                                                                                                secret =
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "secret" ;
                                                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            # d38bd06d
                                                                                                                            NAME="$1"
                                                                                                                            ALLOWED=( "dot-gnupg/ownertrust" "dot-gnupg/secret-keys" "dot-ssh/github/known-hosts" "dot-ssh/github/identity" "dot-ssh/mobile/known-hosts" "dot-ssh/mobile/identity" "github/token" )
                                                                                                                            if [[ ! "${ builtins.concatStringsSep "" [ "$" "{" "ALLOWED[*]" "}" ] }" =~ $NAME ]]
                                                                                                                            then
                                                                                                                                failure da86aba0 "NAME=$NAME"
                                                                                                                            fi
                                                                                                                            cat > "$SECRETS/plain/$NAME.asc.age"
                                                                                                                            export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                            git -C "$SECRETS/cipher" commit --verbose
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/secret" ;
                                                                                                in ''${ secret } "$@"'' ;
                                                                                        variables =
                                                                                            {
                                                                                                DOT_SSH = resources : resources.production.dot-ssh { failure = 24402 ; } ;
                                                                                                SECRETS = resources : resources.production.secrets { failure = 13166 ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                            ssh =
                                                                                bin
                                                                                    {
                                                                                        environment = [ ] ;
                                                                                        name = "ssh" ;
                                                                                        runtimeInputs = pkgs : [ pkgs.openssh ] ;
                                                                                        script = ''ssh -F "$DOT_SSH/config" "$@"'' ;
                                                                                        variables =
                                                                                            {
                                                                                                DOT_SSH = resources : resources.production.dot-ssh { } ;
                                                                                            } ;
                                                                                    } ;
                                                                        } ;
                                                                        # FINDME
                                                            dot-gnupg =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gnupg failure ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        OWNERTRUST=${ resources.production.secret.dot-gnupg.ownertrust { failure = "failure 4f690149" ; } }
                                                                                                        SECRET_KEYS=${ resources.production.secret.dot-gnupg.secret-keys { failure = "failure a0e69797" ; } }
                                                                                                        GNUPGHOME=/mount/dot-gnupg
                                                                                                        export GNUPGHOME
                                                                                                        mkdir --parents "$GNUPGHOME"
                                                                                                        chmod 0700 "$GNUPGHOME"
                                                                                                        gpg --batch --yes --homedir "$GNUPGHOME" --import "$SECRET_KEYS/plaintext" 2>&1
                                                                                                        gpg --batch --yes --homedir "$GNUPGHOME" --import-ownertrust "$OWNERTRUST/plaintext" 2>&1
                                                                                                        gpg --batch --yes --homedir "$GNUPGHOME" --update-trustdb 2>&1
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ "dot-gnupg" ] ;
                                                                    } ;
                                                            dot-ssh =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ root wrap failure ] ;
                                                                                                text =
                                                                                                    let
                                                                                                        ssh-config =
                                                                                                            builtins.toFile
                                                                                                                "config"
                                                                                                                ''
                                                                                                                    Host github.com
                                                                                                                        HostName github.com
                                                                                                                        User git
                                                                                                                        IdentityFile $GITHUB_IDENTITY/plaintext
                                                                                                                        UserKnownHostsFile $GITHUB_KNOWN_HOSTS/plaintext
                                                                                                                        StrictHostKeyChecking yes

                                                                                                                    Host mobile
                                                                                                                        HostName $MOBILE_IP
                                                                                                                        User git
                                                                                                                        IdentityFile $MOBILE_IDENTITY/plaintext
                                                                                                                        UserKnownHostsFile $MOBILE_KNOWN_HOSTS/plaintext
                                                                                                                        StrictHostKeyChecking yes
                                                                                                                        Port = $MOBILE_PORT
                                                                                                                '' ;
                                                                                                        in
                                                                                                            ''
                                                                                                                GITHUB_KNOWN_HOSTS=${ resources.production.secret.dot-ssh.github.known-hosts { failure = "failure 29e0e495" ; } }
                                                                                                                export GITHUB_KNOWN_HOSTS
                                                                                                                GITHUB_IDENTITY=${ resources.production.secret.dot-ssh.github.identity { failure = "failure 29e0e495" ; } }
                                                                                                                export GITHUB_IDENTITY
                                                                                                                MOBILE_IP="${ config.personal.mobile.ip }"
                                                                                                                export MOBILE_IP
                                                                                                                MOBILE_PORT=${ builtins.toString config.personal.mobile.port }
                                                                                                                export MOBILE_PORT
                                                                                                                MOBILE_KNOWN_HOSTS=${ resources.production.secret.dot-ssh.mobile.known-hosts { failure = "failure 5f6b6c0d" ; } }
                                                                                                                export MOBILE_KNOWN_HOSTS
                                                                                                                MOBILE_IDENTITY=${ resources.production.secret.dot-ssh.mobile.identity { failure = "failure 5f6b6c0d" ; } }
                                                                                                                export MOBILE_IDENTITY
                                                                                                                root "$GITHUB_KNOWN_HOSTS"
                                                                                                                root "$GITHUB_IDENTITY"
                                                                                                                root "$MOBILE_KNOWN_HOSTS"
                                                                                                                root "$MOBILE_IDENTITY"
                                                                                                                wrap ${ ssh-config } config 0400 --inherit-plain GITHUB_KNOWN_HOSTS --inherit-plain GITHUB_IDENTITY --inherit-plain MOBILE_KNOWN_HOSTS --inherit-plain MOBILE_IDENTITY --inherit-plain MOBILE_IP --inherit-plain MOBILE_PORT --uuid c4629ece
                                                                                                            '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ "config" ] ;
                                                                    } ;
                                                            flake =
                                                                {
                                                                    build-vm =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nixos-rebuild ( _failure.implementation "e8f7af55" ) ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                SNAPSHOT="$1"
                                                                                                                cd /mount
                                                                                                                mkdir /mount/shared
                                                                                                                if nixos-rebuild build-vm --flake "$SNAPSHOT/#user" > standard-output 2> standard-error
                                                                                                                then
                                                                                                                    echo "$?" > status
                                                                                                                else
                                                                                                                    touch result
                                                                                                                    echo "$?" > status
                                                                                                                fi
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "result" "shared" "standard-error" "standard-output" "status" ] ;
                                                                            } ;
                                                                    build-vm-with-bootloader =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nixos-rebuild ( _failure.implementation "e8f7af55" ) ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                SNAPSHOT="$1"
                                                                                                                cd /mount
                                                                                                                mkdir /mount/shared
                                                                                                                if nixos-rebuild build-vm-with-bootloader --flake "$SNAPSHOT/#user" > standard-output 2> standard-error
                                                                                                                then
                                                                                                                    echo "$?" > status
                                                                                                                else
                                                                                                                    touch result
                                                                                                                    echo "$?" > status
                                                                                                                fi
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "result" "shared" "standard-error" "standard-output" "status" ] ;
                                                                            } ;
                                                                } ;
                                                            man =
                                                                let
                                                                    man =
                                                                        name :
                                                                        {
                                                                            user ? null ,
                                                                            system ? null ,
                                                                            library ? null ,
                                                                            special ? null ,
                                                                            format ? null ,
                                                                            games ? null ,
                                                                            miscellaneous ? null ,
                                                                            administration ? null
                                                                        } : ignore :
                                                                            {
                                                                                depth = 1 ;
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                mkdir --parents /mount/man1
                                                                                                                ${ if builtins.typeOf user == "string" then "ln --symbolic ${ builtins.toFile "man" user } /mount/man1/${ name }.1" else "#" }
                                                                                                                mkdir --parents /mount/man2
                                                                                                                ${ if builtins.typeOf system == "string" then "ln --symbolic ${ builtins.toFile "man" system } /mount/man2/${ name }.2" else "#" }
                                                                                                                mkdir --parents /mount/man3
                                                                                                                ${ if builtins.typeOf library == "string" then "ln --symbolic ${ builtins.toFile "man" library } /mount/man3/${ name }.3" else "#" }
                                                                                                                mkdir --parents /mount/man4
                                                                                                                ${ if builtins.typeOf special == "string" then "ln --symbolic ${ builtins.toFile "man" special } /mount/man4/${ name }.4" else "#" }
                                                                                                                mkdir --parents /mount/man5
                                                                                                                ${ if builtins.typeOf format == "string" then "ln --symbolic ${ builtins.toFile "man" format } /mount/man5/${ name }.5" else "#" }
                                                                                                                mkdir --parents /mount/man6
                                                                                                                ${ if builtins.typeOf games == "string" then "ln --symbolic ${ builtins.toFile "man" games } /mount/man6/${ name }.6" else "#" }
                                                                                                                mkdir --parents /mount/man7
                                                                                                                mkdir --parents /mount/man8
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "man1" "man2" "man3" "man4" "man5" "man6" "man7" "man8" ] ;
                                                                            } ;
                                                                    in
                                                                        {
                                                                            chromium =
                                                                                man
                                                                                    "chromium"
                                                                                    {
                                                                                        user =
                                                                                            ''
                                                                                                .TH CHROMIUM 1 "February 2026" "1.0" "Chromium Browser"
                                                                                                .SH NAME
                                                                                                chromium \- Open-source web browser
                                                                                                .SH SYNOPSIS
                                                                                                .B chromium
                                                                                                [\fIoptions\fR]
                                                                                                .SH DESCRIPTION
                                                                                                Chromium is a free and open-source web browser developed by the Chromium Project. It serves as the base for Google Chrome and is designed to be fast, secure, and minimal.

                                                                                                .SH OPTIONS
                                                                                                .TP
                                                                                                .B \-h, \-\-help
                                                                                                Display help message.
                                                                                                .TP
                                                                                                .B \-v, \-\-version
                                                                                                Display the version of Chromium.
                                                                                                .TP
                                                                                                .B \-incognito
                                                                                                Open a new window in incognito mode.
                                                                                                .TP
                                                                                                .B \-disable-extensions
                                                                                                Launch Chromium with extensions disabled.
                                                                                                .TP
                                                                                                .B \-proxy-server=[address]
                                                                                                Specify a proxy server.
                                                                                                .TP
                                                                                                .B \-user-data-dir=[directory]
                                                                                                Use a specified directory for user data.

                                                                                                .SH AUTHOR
                                                                                                Written by the Chromium Project developers.
                                                                                            '' ;
                                                                                    } ;
                                                                            gpg =
                                                                                man
                                                                                    "gpg"
                                                                                    {
                                                                                        user =
                                                                                            ''
                                                                                                .TH GPG 1 "February 2026" "2.0" "GNU Privacy Guard"
                                                                                                .SH NAME
                                                                                                gpg \- GNU Privacy Guard encryption and signing tool
                                                                                                .SH SYNOPSIS
                                                                                                .B gpg
                                                                                                [\fIoptions\fR] \fIcommand\fR [arguments]
                                                                                                .SH DESCRIPTION
                                                                                                GPG (GNU Privacy Guard) is a free implementation of the OpenPGP standard for encrypting and signing data and communications. It is commonly used to protect emails, files, and ensure data integrity by cryptographically verifying messages and files.

                                                                                                You can use GPG to:
                                                                                                - Encrypt and decrypt files
                                                                                                - Sign messages and verify signatures
                                                                                                - Manage public and private keys

                                                                                                .SH COMMANDS
                                                                                                These are the basic commands available in GPG:
                                                                                                .TP
                                                                                                .B init [gpg-id]
                                                                                                Initialize a new keyring with a specified GPG key.
                                                                                                .TP
                                                                                                .B generate
                                                                                                Generate a new GPG keypair (public and private keys).
                                                                                                .TP
                                                                                                .B sign
                                                                                                Sign a file or message with your private key to verify its authenticity.
                                                                                                .TP
                                                                                                .B encrypt
                                                                                                Encrypt a file or message for a specified recipient.
                                                                                                .TP
                                                                                                .B decrypt
                                                                                                Decrypt a previously encrypted file or message.
                                                                                                .TP
                                                                                                .B verify
                                                                                                Verify the signature on a file or message.
                                                                                                .TP
                                                                                                .B list-keys
                                                                                                List all keys in your keyring.
                                                                                                .TP
                                                                                                .B export
                                                                                                Export a public key to a file or other location.
                                                                                                .TP
                                                                                                .B import
                                                                                                Import a public or private key into your keyring.
                                                                                                .TP
                                                                                                .B revoke
                                                                                                Revoke a public key.
                                                                                                .TP
                                                                                                .B delete-keys
                                                                                                Remove a key from your keyring.

                                                                                                .SH OPTIONS
                                                                                                These are the most commonly used options in **gpg**:

                                                                                                .TP
                                                                                                .B \-h, \-\-help
                                                                                                Display help information for GPG.
                                                                                                .TP
                                                                                                .B \-v, \-\-version
                                                                                                Show the version of GPG.
                                                                                                .TP
                                                                                                .B \-r, \-\-recipient=[email]
                                                                                                Specify the recipient for encryption, using their email or key ID.
                                                                                                .TP
                                                                                                .B \-e, \-\-encrypt
                                                                                                Encrypt the file or message for the specified recipient.
                                                                                                .TP
                                                                                                .B \-d, \-\-decrypt
                                                                                                Decrypt the specified file or message.
                                                                                                .TP
                                                                                                .B \-s, \-\-sign
                                                                                                Sign a file or message with your private key.
                                                                                                .TP
                                                                                                .B \-a, \-\-armor
                                                                                                Create ASCII-armored output (so the result can be safely copied to text-based media).
                                                                                                .TP
                                                                                                .B \-k, \-\-list-keys
                                                                                                List all public keys in the keyring.
                                                                                                .TP
                                                                                                .B \-K, \-\-list-secret-keys
                                                                                                List all secret keys in the keyring.
                                                                                                .TP
                                                                                                .B \-f, \-\-fingerprint
                                                                                                Show the fingerprint of a specified key.
                                                                                                .TP
                                                                                                .B \-a, \-\-armor
                                                                                                Generate ASCII armored output (text format) instead of binary.
                                                                                                .TP
                                                                                                .B \-l, \-\-list-signatures
                                                                                                List the signatures on a given key.

                                                                                                .SH EXAMPLES
                                                                                                Here are a few common examples of GPG usage:

                                                                                                .TP
                                                                                                Sign a file:
                                                                                                .nf
                                                                                                  $ gpg --sign myfile.txt
                                                                                                .fi

                                                                                                .TP
                                                                                                Encrypt a file for a specific recipient:
                                                                                                .nf
                                                                                                  $ gpg --encrypt --recipient example@example.com myfile.txt
                                                                                                .fi

                                                                                                .TP
                                                                                                Decrypt a file:
                                                                                                .nf
                                                                                                  $ gpg --decrypt myfile.txt.gpg
                                                                                                .fi

                                                                                                .TP
                                                                                                Verify a signature on a file:
                                                                                                .nf
                                                                                                  $ gpg --verify myfile.txt.sig myfile.txt
                                                                                                .fi

                                                                                                .TP
                                                                                                Generate a new keypair:
                                                                                                .nf
                                                                                                  $ gpg --full-generate-key
                                                                                                .fi

                                                                                                .TP
                                                                                                Export a public key:
                                                                                                .nf
                                                                                                  $ gpg --export --armor example@example.com > public-key.asc
                                                                                                .fi

                                                                                                .TP
                                                                                                List all keys in your keyring:
                                                                                                .nf
                                                                                                  $ gpg --list-keys
                                                                                                .fi

                                                                                                .TP
                                                                                                Delete a key from your keyring:
                                                                                                .nf
                                                                                                  $ gpg --delete-keys example@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Revoke a key:
                                                                                                .nf
                                                                                                  $ gpg --gen-revoke example@example.com
                                                                                                .fi

                                                                                                .SH FILES
                                                                                                By default, GPG stores its keys in the following locations:

                                                                                                .TP
                                                                                                .B ~/.gnupg/
                                                                                                Contains all the GPG configuration files and keyrings (both public and private).

                                                                                                .SH SEE ALSO
                                                                                                The official GPG documentation can be found at:
                                                                                                .B https://gnupg.org/documentation/

                                                                                                .SH AUTHOR
                                                                                                Written by the GPG team and contributors.
                                                                                            '' ;
                                                                                    } ;
                                                                            idea-community =
                                                                                man
                                                                                    "idea-community"
                                                                                    {
                                                                                        user =
                                                                                            ''
                                                                                                .TH IDEA-COMMUNITY 1 "February 2026" "1.0" "IntelliJ IDEA Community Edition"
                                                                                                .SH NAME
                                                                                                idea-community \- Integrated Development Environment (IDE) for Java and JVM languages
                                                                                                .SH SYNOPSIS
                                                                                                .B idea-community
                                                                                                [\fIoptions\fR]
                                                                                                .SH DESCRIPTION
                                                                                                IntelliJ IDEA Community Edition is a free and open-source Integrated Development Environment (IDE) for Java, Kotlin, Groovy, and other JVM-based languages. It provides support for a wide range of programming languages, modern frameworks, and tools.

                                                                                                You can use IntelliJ IDEA for Java development, Android development (using Kotlin), web development, and more. It comes with advanced code completion, debugging, and integration with various build systems like Gradle and Maven.

                                                                                                .SH OPTIONS
                                                                                                .TP
                                                                                                .B \-h, \-\-help
                                                                                                Display help message with available options.
                                                                                                .TP
                                                                                                .B \-v, \-\-version
                                                                                                Show the version of IntelliJ IDEA Community Edition.
                                                                                                .TP
                                                                                                .B \-d, \-\-disable-plugins
                                                                                                Launch IDEA without loading any plugins.
                                                                                                .TP
                                                                                                .B \-p, \-\-project=[path]
                                                                                                Open a specific project located at the given path.
                                                                                                .TP
                                                                                                .B \-n, \-\-new-project
                                                                                                Create a new project in the IDE.
                                                                                                .TP
                                                                                                .B \-r, \-\-recent
                                                                                                Open a recently used project.
                                                                                                .TP
                                                                                                .B \-j, \-\-jdk=[path]
                                                                                                Specify a custom Java JDK to use with IDEA.
                                                                                                .TP
                                                                                                .B \-m, \-\-maximize
                                                                                                Launch IDEA in a maximized window.
                                                                                                .TP
                                                                                                .B \-l, \-\-localize
                                                                                                Set the language for the user interface. For example: \-l en, \-l de.
                                                                                                .TP
                                                                                                .B \-c, \-\-clear-cache
                                                                                                Clear the IDE cache and restart the application.
                                                                                                .TP
                                                                                                .B \-i, \-\-install
                                                                                                Install necessary IDE components if missing (e.g., Java SDKs, plugins).

                                                                                                .SH EXAMPLES
                                                                                                Here are some common examples of how to use IntelliJ IDEA from the command line:

                                                                                                .TP
                                                                                                Launch IDEA with a specific project:
                                                                                                .nf
                                                                                                  $ idea-community --project /path/to/project
                                                                                                .fi

                                                                                                .TP
                                                                                                Open IDEA with the most recent project:
                                                                                                .nf
                                                                                                  $ idea-community --recent
                                                                                                .fi

                                                                                                .TP
                                                                                                Create a new project:
                                                                                                .nf
                                                                                                  $ idea-community --new-project
                                                                                                .fi

                                                                                                .TP
                                                                                                Launch IDEA with a specific JDK:
                                                                                                .nf
                                                                                                  $ idea-community --jdk /path/to/jdk
                                                                                                .fi

                                                                                                .TP
                                                                                                Start IDEA with plugins disabled:
                                                                                                .nf
                                                                                                  $ idea-community --disable-plugins
                                                                                                .fi

                                                                                                .TP
                                                                                                Show IDEA version:
                                                                                                .nf
                                                                                            '' ;
                                                                                    } ;
                                                                            pass =
                                                                                man
                                                                                    "pass"
                                                                                    {
                                                                                        user =
                                                                                            ''
                                                                                                .TH PASS 1 "February 2026" "1.0" "Password Manager"
                                                                                                .SH NAME
                                                                                                pass \- A simple, Unix-based password manager using GPG
                                                                                                .SH SYNOPSIS
                                                                                                .B pass
                                                                                                [\fIoptions\fR] \fIcommand\fR [arguments]
                                                                                                .SH DESCRIPTION
                                                                                                pass is a simple, yet powerful password manager that stores passwords securely in GPG-encrypted files. The tool uses standard Unix utilities and provides a simple, effective way to manage and retrieve passwords.

                                                                                                The passwords are stored in a directory of files (the password store) that is encrypted with GPG. You can access your passwords and other secrets using a simple command-line interface.

                                                                                                .SH COMMANDS
                                                                                                The following commands are supported by **pass**:

                                                                                                .TP
                                                                                                .B init [gpg-id]
                                                                                                Initialize a new password store, using the specified GPG key ID for encryption. This is typically the first step after installing pass.
                                                                                                .TP
                                                                                                .B show [name]
                                                                                                Show the password for the specified entry in the password store.
                                                                                                .TP
                                                                                                .B insert [name]
                                                                                                Insert a new password entry into the password store. After executing, you will be prompted to enter the password.
                                                                                                .TP
                                                                                                .B edit [name]
                                                                                                Edit an existing password entry. This opens the password in your default editor.
                                                                                                .TP
                                                                                                .B generate [name]
                                                                                                Generate a random password for the specified entry. You can optionally specify the length and complexity of the generated password.
                                                                                                .TP
                                                                                                .B rm [name]
                                                                                                Remove a password entry from the password store.
                                                                                                .TP
                                                                                                .B ls
                                                                                                List all password entries in the password store.
                                                                                                .TP
                                                                                                .B find [name]
                                                                                                Search for a password entry by name (supports fuzzy matching).
                                                                                                .TP
                                                                                                .B sync
                                                                                                Synchronize the password store with a remote repository (typically a git remote).
                                                                                                .TP
                                                                                                .B help
                                                                                                Display help information.

                                                                                                .SH OPTIONS
                                                                                                The following options can be used to modify the behavior of **pass**:

                                                                                                .TP
                                                                                                .B \-h, \-\-help
                                                                                                Display help information about **pass**.
                                                                                                .TP
                                                                                                .B \-v, \-\-version
                                                                                                Show the version of the **pass** tool.
                                                                                                .TP
                                                                                                .B \-e, \-\-editor=[editor]
                                                                                                Specify the text editor to use for editing password entries. If not set, the `EDITOR` environment variable is used.
                                                                                                .TP
                                                                                                .B \-p, \-\-password-store=[dir]
                                                                                                Specify a custom password store directory. By default, **pass** uses `~/.password-store`.
                                                                                                .TP
                                                                                                .B \-r, \-\-recipient=[email]
                                                                                                Specify a GPG key to use for encryption/decryption, overriding the default key.
                                                                                                .TP
                                                                                                .B \-a, \-\-armor
                                                                                                Generate ASCII-armored output (for copy-pasting passwords easily).
                                                                                                .TP
                                                                                                .B \-d, \-\-decrypt
                                                                                                Decrypt the password store. This allows you to view the encrypted files in plaintext.

                                                                                                .SH EXAMPLES
                                                                                                Here are some examples of how to use **pass**:

                                                                                                .TP
                                                                                                Initialize a password store:
                                                                                                .nf
                                                                                                  $ pass init your-email@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Insert a new password for "example.com":
                                                                                                .nf
                                                                                                  $ pass insert example.com
                                                                                                  # Enter the password when prompted
                                                                                                .fi

                                                                                                .TP
                                                                                                Show the password for "example.com":
                                                                                                .nf
                                                                                                  $ pass show example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Edit an existing password for "example.com":
                                                                                                .nf
                                                                                                  $ pass edit example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Generate a random password for "example.com":
                                                                                                .nf
                                                                                                  $ pass generate example.com
                                                                                                  # You can specify the length and complexity as arguments, e.g.:
                                                                                                  $ pass generate example.com 20
                                                                                                .fi

                                                                                                .TP
                                                                                                List all passwords stored:
                                                                                                .nf
                                                                                                  $ pass ls
                                                                                                .fi

                                                                                                .TP
                                                                                                Remove an entry from the store:
                                                                                                .nf
                                                                                                  $ pass rm example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Sync your password store with a remote repository:
                                                                                                .nf
                                                                                                  $ pass sync
                                                                                                .fi

                                                                                                .TP
                                                                                                Find a password entry by name (fuzzy match):
                                                                                                .nf
                                                                                                  $ pass find example
                                                                                                .fi

                                                                                                .SH FILES
                                                                                                By default, **pass** stores passwords and other secrets in the following directory:

                                                                                                .TP
                                                                                                .B ~/.password-store/
                                                                                                This is where the encrypted password files are stored. The passwords are stored as individual GPG-encrypted files, with each file corresponding to a password entry.

                                                                                                .SH SEE ALSO
                                                                                                For more information, refer to the official documentation and the **pass** GitHub repository:
                                                                                                .B https://git.zx2c4.com/password-store/

                                                                                                .SH AUTHOR
                                                                                                Written by Jason A. Donenfeld and contributors to the **pass** project.
                                                                                            '' ;
                                                                                    } ;
                                                                            secrets =
                                                                                man
                                                                                    "secrets"
                                                                                    {
                                                                                        user =
                                                                                            ''


                                                                                                .TH SECRETS 1 "February 2026" "v1.0" "User Commands"
                                                                                                .SH NAME
                                                                                                secrets \- securely write and commit secrets to the repository
                                                                                                .SH SYNOPSIS
                                                                                                .B secrets
                                                                                                .RI "<name>"
                                                                                                .SH DESCRIPTION
                                                                                                The
                                                                                                .B secrets
                                                                                                script writes a secret to the repository and commits it to Git. The secret is read from standard input and stored encrypted in the appropriate location.

                                                                                                Only a predefined set of secret names is allowed. Using any other name will cause the script to fail.
                                                                                                .SH ALLOWED NAMES
                                                                                                .nf
                                                                                                dot-gnupg/ownertrust
                                                                                                dot-gnupg/secret-keys
                                                                                                dot-ssh/github/known-hosts
                                                                                                dot-ssh/github/identity
                                                                                                dot-ssh/mobile/known-hosts
                                                                                                dot-ssh/mobile/identity
                                                                                                github/token
                                                                                                .fi
                                                                                                .SH ENVIRONMENT
                                                                                                .TP
                                                                                                SECRETS
                                                                                                Root path of the secrets repository.
                                                                                                .TP
                                                                                                DOT_SSH
                                                                                                Path to the directory containing SSH configuration files.
                                                                                                .TP
                                                                                                pkgs.openssh
                                                                                                Path to the OpenSSH binary used by Git for committing.
                                                                                                .SH EXIT STATUS
                                                                                                The script exits with a non-zero status if:
                                                                                                .RS
                                                                                                - The provided NAME is not in the allowed list.
                                                                                                - Any command fails (writing the secret or committing).
                                                                                                .RE
                                                                                                It exits with zero on successful write and commit.
                                                                                                .SH EXAMPLES
                                                                                                Write a GitHub identity secret:
                                                                                                .nf
                                                                                                $ echo "my-ssh-key" | secrets dot-ssh/github/identity
                                                                                                .fi
                                                                                                Commit the mobile known-hosts secret:
                                                                                                .nf
                                                                                                $ cat mobile-known-hosts.txt | secrets dot-ssh/mobile/known-hosts
                                                                                                .fi
                                                                                                .SH AUTHOR
                                                                                                Written by Emory Merryman.
                                                                                                .SH SEE ALSO
                                                                                                git(1)
                                                                                            '' ;
                                                                                    } ;
                                                                            ssh =
                                                                                man
                                                                                    "ssh"
                                                                                    {
                                                                                        user =
                                                                                            ''
                                                                                                .TH SSH 1 "February 2026" "1.0" "SSH Client"
                                                                                                .SH NAME
                                                                                                ssh \- OpenSSH client for remote connections
                                                                                                .SH SYNOPSIS
                                                                                                .B ssh [\fIoptions\fR] \fIuser@hostname\fR
                                                                                                .SH DESCRIPTION
                                                                                                SSH (Secure Shell) is a protocol for securely accessing remote systems over an unsecured network. The **ssh** command is used to connect to remote systems, execute commands on those systems, and transfer files.

                                                                                                It uses encryption to secure communication, ensuring confidentiality and integrity of data exchanged between the client and the server. The `ssh` command is widely used for remote administration, file transfers (with `scp` and `sftp`), and tunneling.

                                                                                                .SH OPTIONS
                                                                                                .TP
                                                                                                .B \-h, \-\-help
                                                                                                Display help message and exit.
                                                                                                .TP
                                                                                                .B \-v, \-\-version
                                                                                                Show the version of SSH and exit.
                                                                                                .TP
                                                                                                .B \-p, \-\-port=[port]
                                                                                                Specify the port number to connect to on the remote host. The default SSH port is 22.
                                                                                                .TP
                                                                                                .B \-i, \-\-identity-file=[file]
                                                                                                Use the specified private key file for authentication instead of the default (`~/.ssh/id_rsa`).
                                                                                                .TP
                                                                                                .B \-X, \-\-X11-forwarding
                                                                                                Enable X11 forwarding. This allows graphical applications to be displayed on the local machine.
                                                                                                .TP
                                                                                                .B \-A, \-\-agent-forwarding
                                                                                                Enable SSH agent forwarding, which allows you to use your local SSH keys on the remote server.
                                                                                                .TP
                                                                                                .B \-L, \-\-local-port-forwarding=[local-port:remote-host:remote-port]
                                                                                                Establish a local port forwarding. This forwards connections on the specified local port to the remote host and port.
                                                                                                .TP
                                                                                                .B \-R, \-\-remote-port-forwarding=[remote-port:local-host:local-port]
                                                                                                Establish a remote port forwarding. This forwards connections on the specified remote port to the local host and port.
                                                                                                .TP
                                                                                                .B \-C, \-\-compression
                                                                                                Enable compression. This can reduce the amount of data transmitted, but may increase CPU usage.
                                                                                                .TP
                                                                                                .B \-q, \-\-quiet
                                                                                                Suppress most warning and diagnostic messages.
                                                                                                .TP
                                                                                                .B \-o, \-\-option=[option]
                                                                                                Set a specific SSH configuration option, like `User`, `Port`, or `IdentityFile`. This is the same as specifying options in the `~/.ssh/config` file.
                                                                                                .TP
                                                                                                .B \-f, \-\-fork
                                                                                                Run in the background before executing the command. This is useful for tunneling or when you want to connect without an interactive session.
                                                                                                .TP
                                                                                                .B \-T, \-\-no-pty
                                                                                                Disables the allocation of a pseudo-terminal. This is often used when running remote commands.
                                                                                                .TP
                                                                                                .B \-N
                                                                                                Do not execute any commands; this is used for setting up port forwarding only.
                                                                                                .TP
                                                                                                .B \-M
                                                                                                Enable master mode for connection sharing. This allows multiple `ssh` sessions to share a single network connection, reducing latency for multiple connections.

                                                                                                .SH EXAMPLES
                                                                                                Below are several common examples of how to use the `ssh` command:

                                                                                                .TP
                                                                                                Connect to a remote host:
                                                                                                .nf
                                                                                                  $ ssh user@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Connect to a remote host on a non-default port:
                                                                                                .nf
                                                                                                  $ ssh -p 2222 user@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Use a specific private key for authentication:
                                                                                                .nf
                                                                                                  $ ssh -i ~/.ssh/id_rsa user@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Enable X11 forwarding to run graphical applications remotely:
                                                                                                .nf
                                                                                                  $ ssh -X user@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Enable SSH agent forwarding:
                                                                                                .nf
                                                                                                  $ ssh -A user@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Create a local port forwarding:
                                                                                                .nf
                                                                                                  $ ssh -L 8080:localhost:80 user@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Create a remote port forwarding:
                                                                                                .nf
                                                                                                  $ ssh -R 8080:localhost:80 user@example.com
                                                                                                .fi

                                                                                                .TP
                                                                                                Run a command on a remote host without opening an interactive session:
                                                                                                .nf
                                                                                                  $ ssh user@example.com 'ls -l'
                                                                                                .fi

                                                                                                .TP
                                                                                                Connect in the background for use with port forwarding:
                                                                                                .nf
                                                                                                  $ ssh -f -L 8080:localhost:80 user@example.com sleep 60
                                                                                                .fi

                                                                                                .TP
                                                                                                Establish an SSH connection and set an option, like the `User`:
                                                                                                .nf
                                                                                                  $ ssh -o User=myuser example.com
                                                                                                .fi

                                                                                                .SH FILES
                                                                                                The following files are typically used by SSH:

                                                                                                .TP
                                                                                                .B ~/.ssh/config
                                                                                                The SSH client configuration file, where you can define default options for SSH connections (e.g., `User`, `Port`, `IdentityFile`).
                                                                                                .TP
                                                                                                .B ~/.ssh/id_rsa
                                                                                                The default private key used for authentication.
                                                                                                .TP
                                                                                                .B ~/.ssh/id_rsa.pub
                                                                                                The default public key associated with the private key.
                                                                                                .TP
                                                                                                .B ~/.ssh/known_hosts
                                                                                                A file that stores the public keys of previously connected servers to verify their identity in future connections.

                                                                                                .SH SEE ALSO
                                                                                                For more information, refer to the OpenSSH documentation:
                                                                                                .B https://www.openssh.com/manual.html

                                                                                                .SH AUTHOR
                                                                                                Written by the OpenSSH team and contributors.

                                                                                                .SH BUGS
                                                                                                To report bugs, refer to the OpenSSH project's bug tracker:
                                                                                                .B https://bugs.openbsd.org/bugzilla/

                                                                                            '' ;
                                                                                    } ;
                                                                        } ;
                                                            repository =
                                                                let
                                                                    post-commit =
                                                                        pkgs : wrap :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "post-commit" ;
                                                                                            runtimeInputs = [ pkgs.git wrap ] ;
                                                                                            text =
                                                                                                let
                                                                                                    post-commit =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "post-commit" ;
                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                while ! git push origin HEAD
                                                                                                                                do
                                                                                                                                    sleep 1
                                                                                                                                done
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                            in "${ application }/bin/post-commit" ;
                                                                                                    in
                                                                                                        ''
                                                                                                            wrap ${ post-commit} repository/.git/hooks/post-commit 0500 --literal-plain PATH --uuid 9ed6a1d0
                                                                                                        '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/post-commit" ;
                                                                    ssh =
                                                                        pkgs : resources : root : wrap :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "ssh" ;
                                                                                            runtimeInputs = [ root wrap ] ;
                                                                                            text =
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "ssh" ;
                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.openssh ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        if [[ -t 0 ]]
                                                                                                                        then
                                                                                                                            ssh -F "$MOUNT/stage/ssh/config" "$@"
                                                                                                                        else
                                                                                                                            cat | ssh -F "$MOUNT/stage/ssh/config" "$@"
                                                                                                                        fi
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in
                                                                                                        ''
                                                                                                            git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                            wrap ${ application }/bin/ssh stage/ssh/command 0500 --literal-plain "@" --inherit-plain MOUNT --literal-plain PATH --uuid 90c5bc0c
                                                                                                            DOT_SSH=${ resources.production.dot-ssh { } }
                                                                                                            root "$DOT_SSH"
                                                                                                            wrap "$DOT_SSH/config" stage/ssh/config 0400
                                                                                                        '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/ssh" ;
                                                                    in
                                                                        {
                                                                            pass =
                                                                                ignore :
                                                                                    {
                                                                                        init =
                                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "init" ;
                                                                                                                runtimeInputs = [ pkgs.git pkgs.openssh root ] ;
                                                                                                                text =
                                                                                                                    let
                                                                                                                        post-commit =
                                                                                                                            let
                                                                                                                                application =
                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "post-commit" ;
                                                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                                                            text =
                                                                                                                                                ''
                                                                                                                                                    while ! git push origin HEAD
                                                                                                                                                    do
                                                                                                                                                        sleep 1
                                                                                                                                                    done
                                                                                                                                                '' ;
                                                                                                                                        } ;
                                                                                                                                in "${ application }/bin/post-commit" ;
                                                                                                                        in
                                                                                                                            ''
                                                                                                                                mkdir --parents /mount/repository
                                                                                                                                cd /mount/repository
                                                                                                                                git init 2>&1
                                                                                                                                root ${ pkgs.openssh }
                                                                                                                                DOT_SSH=${ resources.production.dot-ssh { failure = "failure f2774d0a" ; } }
                                                                                                                                root "$DOT_SSH"
                                                                                                                                git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                                git config user.email "${ config.personal.pass.email }"
                                                                                                                                git config user.name "${ config.personal.pass.name }"
                                                                                                                                ln --symbolic ${ post-commit } "/mount/repository/.git/hooks/post-commit"
                                                                                                                                git remote add origin ${ config.personal.pass.remote }
                                                                                                                                git fetch origin ${ config.personal.pass.branch } 2>&1
                                                                                                                                git checkout ${ config.personal.pass.branch } 2>&1
                                                                                                                            '' ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/init" ;
                                                                                        targets = [ "repository" ] ;
                                                                                    } ;
                                                                            studio =
                                                                                {
                                                                                    entry =
                                                                                        ignore :
                                                                                            {
                                                                                                init =
                                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "init" ;
                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git root wrap ] ;
                                                                                                                        text =
                                                                                                                            let
                                                                                                                                scripts =
                                                                                                                                    let
                                                                                                                                        mapper =
                                                                                                                                            name : { runtimeInputs , text } :
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = name ;
                                                                                                                                                                runtimeInputs = runtimeInputs ;
                                                                                                                                                                text = text ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/${ name }" ;
                                                                                                                                        in
                                                                                                                                            {
                                                                                                                                                root =
                                                                                                                                                    let
                                                                                                                                                        mutable- =
                                                                                                                                                            command :
                                                                                                                                                                {
                                                                                                                                                                    runtimeInputs = [ pkgs.git ] ;
                                                                                                                                                                    text =
                                                                                                                                                                        ''
                                                                                                                                                                            # dispatch the ${ command } command to the snapshot
                                                                                                                                                                            REPOSITORY="$( git rev-parse --show-toplevel )" || failure 302057cb
                                                                                                                                                                            cd "$REPOSITORY"
                                                                                                                                                                            SNAPSHOT="$( ${ scripts.root.snapshot } )" || failure 33677eea
                                                                                                                                                                            git -C "$SNAPSHOT" mutable-${ command }
                                                                                                                                                                        '' ;
                                                                                                                                                                } ;
                                                                                                                                                        set =
                                                                                                                                                            {
                                                                                                                                                                build-vm = mutable- "build-vm" ;
                                                                                                                                                                build-vm-with-bootloader = mutable- "build-vm-with-bootloader" ;
                                                                                                                                                                check = mutable- "check" ;
                                                                                                                                                                mirror =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git sequential ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                # mirror $SOURCE_BRANCH from origin to this
                                                                                                                                                                                SOURCE_BRANCH="$1"
                                                                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure f82885fe
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                git fetch origin "$SOURCE_BRANCH"
                                                                                                                                                                                git checkout "origin/$SOURCE_BRANCH"
                                                                                                                                                                                UUID="$( sequential )" || failure b3329fb1
                                                                                                                                                                                TARGET_BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 0fbafe21
                                                                                                                                                                                git checkout -b "$TARGET_BRANCH"
                                                                                                                                                                                git submodule deinit -f .
                                                                                                                                                                                git submodule update --init --recursive
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                promote =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs =
                                                                                                                                                                            [
                                                                                                                                                                                pkgs.coreutils
                                                                                                                                                                                pkgs.diffutils
                                                                                                                                                                                pkgs.git
                                                                                                                                                                                (
                                                                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                                                                        {
                                                                                                                                                                                            name = "prompt" ;
                                                                                                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                                                                                            text =
                                                                                                                                                                                                ''
                                                                                                                                                                                                    MESSAGE="$1"
                                                                                                                                                                                                    read -p "$MESSAGE?  " -r ANSWER
                                                                                                                                                                                                    if [[ "$ANSWER" == "y" ]]
                                                                                                                                                                                                    then
                                                                                                                                                                                                        echo YES "$MESSAGE"
                                                                                                                                                                                                    else
                                                                                                                                                                                                        failure "$MESSAGE" "$ANSWER"
                                                                                                                                                                                                    fi
                                                                                                                                                                                                '' ;
                                                                                                                                                                                        }
                                                                                                                                                                                )
                                                                                                                                                                            ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                # promote this feature set
                                                                                                                                                                                #
                                                                                                                                                                                # run check, build-vm, and test on this studio
                                                                                                                                                                                # use studio to obtain a brand new studio
                                                                                                                                                                                # use mirror to make the new studio the same as this one
                                                                                                                                                                                # comparison check the new studio with the old
                                                                                                                                                                                # run check, build-vm, and test on the new studio
                                                                                                                                                                                # run switch on the new studio
                                                                                                                                                                                #
                                                                                                                                                                                # this process is lengthy and repeats most things twice
                                                                                                                                                                                # the reason is that most everything will be done with the new code not the old code
                                                                                                                                                                                #
                                                                                                                                                                                # for example, say in this feature set we change how the build-vm works
                                                                                                                                                                                # in our first iteration of build-vm we will use the code from before the change
                                                                                                                                                                                # but in our second iteration of build-vm we will use the code from after the change
                                                                                                                                                                                #
                                                                                                                                                                                # sometimes you may want to manually promote.
                                                                                                                                                                                # this script will show you the steps
                                                                                                                                                                                #
                                                                                                                                                                                INDEX="${ builtins.concatStringsSep "" [ "$" "{" "1:-2" "}" ] }"
                                                                                                                                                                                REPOSITORY="${ builtins.concatStringsSep "" [ "$" "{" ''2:-"$( git rev-parse --show-toplevel )"'' "}" ] }" || failure c9ca5124
                                                                                                                                                                                BRANCH="${ builtins.concatStringsSep "" [ "$" "{" "3:-" "}" ] }"
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                if [[ -n "$BRANCH" ]]
                                                                                                                                                                                then
                                                                                                                                                                                    git mutable-mirror "$BRANCH"
                                                                                                                                                                                fi
                                                                                                                                                                                if [[ "$INDEX" == 0 ]]
                                                                                                                                                                                then
                                                                                                                                                                                    git mutable-reset
                                                                                                                                                                                fi
                                                                                                                                                                                git mutable-check
                                                                                                                                                                                git mutable-build-vm
                                                                                                                                                                                prompt "mutable-build-vm $INDEX"
                                                                                                                                                                                git mutable-test
                                                                                                                                                                                prompt "mutable-test $INDEX"
                                                                                                                                                                                if [[ "$INDEX" == 0 ]]
                                                                                                                                                                                then
                                                                                                                                                                                    git mutable-switch
                                                                                                                                                                                    prompt "mutable-switch"
                                                                                                                                                                                else
                                                                                                                                                                                    NEXT_INDEX=$(( INDEX - 1 ))
                                                                                                                                                                                    NEXT_REPOSITORY="$( git mutable-studio )" || failure 00b2b3fb
                                                                                                                                                                                    NEXT_BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure 9cf16a4e
                                                                                                                                                                                    git mutable-promote "$NEXT_INDEX" "$NEXT_REPOSITORY" "$NEXT_BRANCH"
                                                                                                                                                                                fi
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                reset =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.git sequential ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''

                                                                                                                                                                                # reset this to main, squashing all comments to one; iteratively do the same for submodules
                                                                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure 3b2b98e3
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                git submodule foreach 'git config --get core.sshCommand'
                                                                                                                                                                                git submodule foreach '${ scripts.submodule.reset }'
                                                                                                                                                                                git fetch origin main
                                                                                                                                                                                if ! git diff --quiet origin/main || git diff --quiet --cached origin/main
                                                                                                                                                                                then
                                                                                                                                                                                    UUID="$( sequential | sha512sum )" || failure 15ff04d3
                                                                                                                                                                                    BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure c7dc3ee2
                                                                                                                                                                                    git checkout -b "$BRANCH"
                                                                                                                                                                                    git reset --soft origin/main
                                                                                                                                                                                    git commit -a --verbose --allow-empty --allow-empty-message
                                                                                                                                                                                    git push origin HEAD
                                                                                                                                                                                fi
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                snapshot =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git root ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                # create a snapshot (read-only copy) of this (and root it)
                                                                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure ca25d32c
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                git submodule foreach '${ scripts.submodule.snapshot }' >&2
                                                                                                                                                                                if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                                then
                                                                                                                                                                                    git commit -a --verbose --allow-empty-message >&2
                                                                                                                                                                                fi
                                                                                                                                                                                git push origin HEAD >&2
                                                                                                                                                                                BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure d14e84bf
                                                                                                                                                                                COMMIT="$( git rev-parse HEAD )" || failure e6fec78a
                                                                                                                                                                                SNAPSHOT=${ resources.production.repository.studio.snapshot { failure = 8500 ; setup = setup : ''${ setup } "$BRANCH" "$COMMIT"'' ; } }
                                                                                                                                                                                ../bin/root "$SNAPSHOT"
                                                                                                                                                                                echo "$SNAPSHOT/repository"
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                studio =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                # create a studio (read-write copy of main) of this repository
                                                                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure 37eb0a7a
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                STUDIO="$( ../bin/studio )" || failure 9d7604c6
                                                                                                                                                                                echo "$STUDIO"
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                switch = mutable- "switch" ;
                                                                                                                                                                test = mutable- "test" ;
                                                                                                                                                            } ;
                                                                                                                                                        in builtins.mapAttrs mapper set ;
                                                                                                                                                submodule =
                                                                                                                                                    let
                                                                                                                                                        set =
                                                                                                                                                            {
                                                                                                                                                                reset =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.git pkgs.nix sequential ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                # reset this to main and update nix
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                                cd "$toplevel/$name"
                                                                                                                                                                                git fetch origin main
                                                                                                                                                                                if ! git diff --quiet origin/main || ! git diff --quiet --cached origin/main
                                                                                                                                                                                then
                                                                                                                                                                                    UUID="$( sequential | sha512sum )" || failure 78ffc3fb
                                                                                                                                                                                    BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 6e29e051
                                                                                                                                                                                    git checkout -b "$BRANCH"
                                                                                                                                                                                    git reset --soft origin/main
                                                                                                                                                                                    git commit -a --verbose --allow-empty-message
                                                                                                                                                                                    git push origin HEAD
                                                                                                                                                                                    ${ scripts.submodule.update }
                                                                                                                                                                                fi
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                snapshot =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nix sequential ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                # create a snapshot and update nix
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                                cd "$toplevel/$name"
                                                                                                                                                                                if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                                then
                                                                                                                                                                                    UUID="$( sequential | sha512sum )" || failure e2e7dad7
                                                                                                                                                                                    BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 20b63f59
                                                                                                                                                                                    git checkout -b "$BRANCH"
                                                                                                                                                                                    git commit -a --verbose --allow-empty-message
                                                                                                                                                                                    git push origin HEAD
                                                                                                                                                                                    ${ scripts.submodule.update }
                                                                                                                                                                                fi
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                update =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.nix ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                # update nix
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                                TOKEN_DIRECTORY=${ resources.production.secret.github.token { failure = 4865 ; } }
                                                                                                                                                                                TOKEN="$( cat "$TOKEN_DIRECTORY/plaintext" )" || failure 5f06a5e9
                                                                                                                                                                                export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                                                                cd "$toplevel"
                                                                                                                                                                                nix flake update --flake "$toplevel" "$name"
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                            } ;
                                                                                                                                                        in builtins.mapAttrs mapper set ;
                                                                                                                                        } ;
                                                                                                                                    studio =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "studio" ;
                                                                                                                                                        runtimeInputs = [ pkgs.coreutils sequential ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                # create a studio (read write copy) of this repository and root it
                                                                                                                                                                SEQUENCE="$( sequential )" || failure a5f58156
                                                                                                                                                                STUDIO="$( "$SETUP" "$SEQUENCE" )" || failure 3c02f464
                                                                                                                                                                "$MOUNT/bin/root" "$STUDIO"
                                                                                                                                                                echo "$STUDIO/repository"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/studio" ;
                                                                                                                                in
                                                                                                                                    ''
                                                                                                                                        # initialize a read write copy of main
                                                                                                                                        wrap ${ root }/bin/root bin/root 0500 --literal-plain DIRECTORY --inherit-plain INDEX --literal-plain PATH --literal-plain TARGET --uuid 608bd8f9
                                                                                                                                        wrap ${ studio } bin/studio 0500 --inherit-plain MOUNT --literal-plain PATH --literal-plain SEQUENCE --inherit-plain SETUP --literal-plain STUDIO --uuid 79a37900
                                                                                                                                        mkdir --parents /mount/repository
                                                                                                                                        cd /mount/repository
                                                                                                                                        git init 2>&1
                                                                                                                                        root ${ pkgs.openssh }
                                                                                                                                        DOT_SSH=${ resources.production.dot-ssh { failure = 2564 ; } }
                                                                                                                                        root "$DOT_SSH"
                                                                                                                                        echo "472ee5ee" GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                                        export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                                        ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git config alias.mutable-${ name } "!${ value }"'' ) scripts.root ) ) }
                                                                                                                                        git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                                        git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                        git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                        git remote add origin "${ config.personal.repository.private.remote }"
                                                                                                                                        git mutable-mirror main 2>&1
                                                                                                                                        export DOT_SSH
                                                                                                                                        git submodule foreach "git config core.sshCommand \"${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config\"" 2>&1
                                                                                                                                        # shellcheck disable=SC2016
                                                                                                                                        git submodule foreach 'git config user.email "${ config.personal.repository.private.email }"' 2>&1
                                                                                                                                        # shellcheck disable=SC2016
                                                                                                                                        git submodule foreach 'git config user.name "${ config.personal.repository.private.name }"' 2>&1
                                                                                                                                    '' ;
                                                                                                                    } ;
                                                                                                            in "${ application }/bin/init" ;
                                                                                                targets = [ "bin" "repository" ] ;
                                                                                            } ;
                                                                                    snapshot =
                                                                                        ignore :
                                                                                            {
                                                                                                init =
                                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "init" ;
                                                                                                                        runtimeInputs = [ pkgs.git sequential wrap ] ;
                                                                                                                        text =
                                                                                                                            let
                                                                                                                                scripts =
                                                                                                                                    let
                                                                                                                                        mapper =
                                                                                                                                            name : { runtimeInputs , text } :
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = name ;
                                                                                                                                                                runtimeInputs = runtimeInputs ;
                                                                                                                                                                text = text ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/${ name }" ;
                                                                                                                                        in
                                                                                                                                            {
                                                                                                                                                root =
                                                                                                                                                    let
                                                                                                                                                        build-vm =
                                                                                                                                                            vm :
                                                                                                                                                                {
                                                                                                                                                                    runtimeInputs = [ pkgs.nixos-rebuild ] ;
                                                                                                                                                                    text =
                                                                                                                                                                        ''
                                                                                                                                                                            REPOSITORY="$( git rev-parse --show-toplevel )" || failure 06532bae
                                                                                                                                                                            cd "$REPOSITORY"
                                                                                                                                                                            cd "../stage/artifacts/${ vm }"
                                                                                                                                                                            nixos-rebuild ${ vm } --flake "$REPOSITORY#user"
                                                                                                                                                                            PRESENT_WORKING_DIRECTORY="$( pwd )" || failure 2ca1d683
                                                                                                                                                                            export SHARED_DIR="$PRESENT_WORKING_DIRECTORY/shared"
                                                                                                                                                                            echo "$PRESENT_WORKING_DIRECTORY/result/bin/run-nixos-vm"
                                                                                                                                                                            "$PRESENT_WORKING_DIRECTORY/result/bin/run-nixos-vm"
                                                                                                                                                                        '' ;
                                                                                                                                                                } ;
                                                                                                                                                        set =
                                                                                                                                                            {
                                                                                                                                                                build-vm = build-vm "build-vm" ;
                                                                                                                                                                build-vm-with-bootloader = build-vm "build-vm-with-bootloader" ;
                                                                                                                                                                check =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.nix ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure 62f13008
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                echo nix flake check "$REPOSITORY" >&2
                                                                                                                                                                                nix flake check "$REPOSITORY"
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                switch =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" ) ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure 31943c1f
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                DOT_SSH=${ resources.production.dot-ssh { failure = 9624 ; } }
                                                                                                                                                                                export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                                                                                cd "../stage/artifacts/switch"
                                                                                                                                                                                git -C "$REPOSITORY" submodule foreach '${ scripts.submodule.switch }'
                                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure 0f1227b6
                                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure d5910859
                                                                                                                                                                                git -C "$REPOSITORY"  checkout -b "$BRANCH"
                                                                                                                                                                                git -C "$REPOSITORY"  commit -am "" --allow-empty --allow-empty-message
                                                                                                                                                                                git -C "$REPOSITORY"  fetch origin main
                                                                                                                                                                                git -C "$REPOSITORY"  reset --soft origin/main
                                                                                                                                                                                git -C "$REPOSITORY"  commit -a --verbose --allow-empty-message
                                                                                                                                                                                git -C "$REPOSITORY"  push origin HEAD
                                                                                                                                                                                git -C "$REPOSITORY"  checkout main
                                                                                                                                                                                git -C "$REPOSITORY"  rebase "$BRANCH"
                                                                                                                                                                                echo nixos-rebuild switch --flake "$REPOSITORY#user" --show-trace
                                                                                                                                                                                nixos-rebuild switch --flake "$REPOSITORY#user" --show-trace
                                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure ff7829b8
                                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure ef1f826c
                                                                                                                                                                                git -C "$REPOSITORY"  push origin HEAD
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                                test =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" ) ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure 2402a278
                                                                                                                                                                                cd "$REPOSITORY"
                                                                                                                                                                                cd ../stage/artifacts/test
                                                                                                                                                                                echo nixos-rebuild test --flake "$REPOSITORY#user"
                                                                                                                                                                                nixos-rebuild test --flake "$REPOSITORY#user"
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                            } ;
                                                                                                                                                        in builtins.mapAttrs mapper set ;
                                                                                                                                                submodule =
                                                                                                                                                    let
                                                                                                                                                        set =
                                                                                                                                                            {
                                                                                                                                                                switch =
                                                                                                                                                                    {
                                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git pkgs.nix ( _failure.implementation "c0f7e8f6" ) ] ;
                                                                                                                                                                        text =
                                                                                                                                                                            ''
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                                cd "$toplevel/$name"
                                                                                                                                                                                git fetch origin main
                                                                                                                                                                                if ! git diff origin/main --quiet || ! git diff origin/main --quiet --cached
                                                                                                                                                                                then
                                                                                                                                                                                    BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure b7fb71d9
                                                                                                                                                                                    TOKEN=${ resources.production.secret.github.token { failure = "failure 271f8c4f" ; } }
                                                                                                                                                                                    gh auth login --with-token < "$TOKEN/plaintext"
                                                                                                                                                                                    if ! gh label list --json name --jq '.[].name' | grep -qx snapshot
                                                                                                                                                                                    then
                                                                                                                                                                                        gh label create snapshot --color "#333333" --description "Scripted Snapshot PR"
                                                                                                                                                                                    fi
                                                                                                                                                                                    gh pr create --base main --head "$BRANCH" --label "snapshot"
                                                                                                                                                                                    URL="$( gh pr view --json url --jq .url )" || failure 31ccb1f3
                                                                                                                                                                                    gh pr merge "$URL" --rebase
                                                                                                                                                                                    gh auth logout
                                                                                                                                                                                    NAME="$( basename "$name" )" || failure 368e7b07
                                                                                                                                                                                    TOKEN_DIRECTORY=${ resources.production.secret.github.token { failure = "failure ad27f961" ; } }
                                                                                                                                                                                    TOKEN="$( cat "$TOKEN_DIRECTORY/plaintext" )" || failure 6ad73063
                                                                                                                                                                                    export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                                                                    DOT_SSH=${ resources.production.dot-ssh { failure = 2980 ; } }
                                                                                                                                                                                    cd "$toplevel"
                                                                                                                                                                                    ../stage/root ${ pkgs.openssh }
                                                                                                                                                                                    export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                                                                                    nix flake update --flake "$toplevel" "$NAME"
                                                                                                                                                                                fi
                                                                                                                                                                            '' ;
                                                                                                                                                                    } ;
                                                                                                                                                            } ;
                                                                                                                                                        in builtins.mapAttrs mapper set ;
                                                                                                                                            } ;
                                                                                                                                in
                                                                                                                                    ''
                                                                                                                                        OLD_BRANCH="$1"
                                                                                                                                        COMMIT="$2"
                                                                                                                                        mkdir --parents /mount/repository
                                                                                                                                        cd /mount/repository
                                                                                                                                        git init 2>&1
                                                                                                                                        ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git config alias.mutable-${ name } "!${ value }"'' ) scripts.root ) ) }
                                                                                                                                        root ${ pkgs.openssh }
                                                                                                                                        DOT_SSH=${ resources.production.dot-ssh { failure = 7513 ; } }
                                                                                                                                        root "$DOT_SSH"
                                                                                                                                        export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                                        root ${ pkgs.git }
                                                                                                                                        git config core.sshCommand "$GIT_SSH_COMMAND"
                                                                                                                                        git config user.email "${ config.personal.email }"
                                                                                                                                        git config user.name "${ config.personal.description }"
                                                                                                                                        git remote add origin "${ config.personal.repository.private.remote }"
                                                                                                                                        git fetch origin "$OLD_BRANCH" 2>&1
                                                                                                                                        git checkout "$COMMIT" 2>&1
                                                                                                                                        mkdir --parents /mount/stage/artifacts/build-vm/shared
                                                                                                                                        mkdir --parents /mount/stage/artifacts/build-vm-with-bootloader/shared
                                                                                                                                        mkdir --parents /mount/stage/artifacts/test
                                                                                                                                        mkdir --parents /mount/stage/artifacts/switch
                                                                                                                                        git submodule sync 2>&1
                                                                                                                                        git submodule update --init --recursive 2>&1
                                                                                                                                        echo 380b7b99 cb5fe1a6
                                                                                                                                        git submodule foreach "git config core.sshCommand \"$GIT_SSH_COMMAND\"" 2>&1
                                                                                                                                        echo 380b7b99 b4542105
                                                                                                                                        UUID="$( sequential | sha512sum )" || failure 2ecf55e5
                                                                                                                                        echo 380b7b99 fb8ae5e7
                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure ee625965
                                                                                                                                        echo 380b7b99 2bb86aa3
                                                                                                                                        git submodule foreach "git checkout -b $BRANCH" 2>&1
                                                                                                                                        echo 380b7b99 b29cd747
                                                                                                                                        git submodule foreach "git push origin HEAD" 2>&1
                                                                                                                                        echo 380b7b99 a7df32c6
                                                                                                                                        wrap ${ root }/bin/root stage/root 0500 --literal-plain DIRECTORY --inherit-plain INDEX --literal-plain PATH --literal-plain TARGET --uuid c3aaf5d8
                                                                                                                                    '' ;
                                                                                                                    } ;
                                                                                                            in "${ application }/bin/init" ;
                                                                                                release =
                                                                                                    { failure , pkgs , resources , seed , sequential } :
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "release" ;
                                                                                                                        runtimeInputs = [ ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                echo RELEASE
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                            in "${ application }/bin/release" ;
                                                                                                targets = [ "repository" "stage" ] ;
                                                                                            } ;
                                                                                } ;
                                                                        } ;
                                                            secret =
                                                                let
                                                                    secret =
                                                                        name : ignore :
                                                                            {
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.age pkgs.coreutils ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                SECRETS=${ resources.production.secrets { } }
                                                                                                                age --decrypt --identity ${ config.personal.agenix } --output /mount/plaintext "$SECRETS/cipher/${ name }.asc.age"
                                                                                                                chmod 0400 /mount/plaintext
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "plaintext" ] ;
                                                                            } ;
                                                                    in
                                                                        {
                                                                            dot-gnupg =
                                                                                {
                                                                                    ownertrust = secret "dot-gnupg/ownertrust" ;
                                                                                    secret-keys = secret "dot-gnupg/secret-keys" ;
                                                                                } ;
                                                                            dot-ssh =
                                                                                {
                                                                                    github =
                                                                                        {
                                                                                            known-hosts = secret "dot-ssh/github/known-hosts" ;
                                                                                            identity = secret "dot-ssh/github/identity" ;
                                                                                        } ;
                                                                                    mobile =
                                                                                        {
                                                                                            known-hosts = secret "dot-ssh/mobile/known-hosts" ;
                                                                                            identity = secret "dot-ssh/mobile/identity" ;
                                                                                        } ;
                                                                                } ;
                                                                            github.token = secret "github/token" ;
                                                                        } ;
                                                            secrets =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git wrap ] ;
                                                                                                text =
                                                                                                    let
                                                                                                        post-commit =
                                                                                                           let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "post-commit" ;
                                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.openssh ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    : "${ builtins.concatStringsSep "" [ "$" "{" "GIT_SSH_COMMAND:?GIT_SSH_COMMAND must be exported" "}" ] }"
                                                                                                                                    cd "$MOUNT/cipher"
                                                                                                                                    while ! git push ssh HEAD
                                                                                                                                    do
                                                                                                                                        sleep 1s
                                                                                                                                    done
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/post-commit" ;
                                                                                                        pre-commit =
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "pre-commit" ;
                                                                                                                            runtimeInputs = [ pkgs.age pkgs.findutils pkgs.gnugrep failure ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    cd "$MOUNT/cipher"
                                                                                                                                    IDENTITY="$( grep '^AGE-SECRET-KEY' ${ config.personal.agenix } | cut -d' ' -f2 | age-keygen -y )" || failure cf83e135
                                                                                                                                    find "$MOUNT/plain" -mindepth 1 -type f -name "*.asc" | while read -r PLAINTEXT_FILE
                                                                                                                                    do
                                                                                                                                        FILE="${ builtins.concatStringsSep "" [ "$" "{" ''PLAINTEXT_FILE#"$MOUNT"/plain/'' "}" ] }"
                                                                                                                                        age --encrypt --identity "$IDENTITY" --output "$MOUNT/cipher/$FILE.age"
                                                                                                                                        git add "$MOUNT/cipher/$FILE.age"
                                                                                                                                    done
                                                                                                                                    git diff --name-only --cached | while read -r STAGED_FILE
                                                                                                                                    do
                                                                                                                                        echo "STAGED_FILE=$STAGED_FILE"
                                                                                                                                        case "$STAGED_FILE" in
                                                                                                                                            dot-gnupg/ownertrust.asc.age)
                                                                                                                                                ;;
                                                                                                                                            dot-gnupg/secret-keys.asc.age)
                                                                                                                                                ;;
                                                                                                                                            dot-ssh/github/known-hosts.asc.age)
                                                                                                                                                ;;
                                                                                                                                            dot-ssh/github/identity.asc.age)
                                                                                                                                                ;;
                                                                                                                                            dot-ssh/mobile/known-hosts.asc.age)
                                                                                                                                                ;;
                                                                                                                                            dot-ssh/mobile/identity.asc.age)
                                                                                                                                                ;;
                                                                                                                                            gnupg/token.asc.age)
                                                                                                                                                ;;
                                                                                                                                           *)
                                                                                                                                                failure 654f86bb "$STAGED_FILE"
                                                                                                                                        esac
                                                                                                                                    done
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/pre-commit" ;
                                                                                                        pre-push =
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "pre-push" ;
                                                                                                                            runtimeInputs = [ pkgs.gh pkgs.openssh failure ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    if [[ -f "$MOUNT/plain/dot-ssh/github/identity.asc" ]]
                                                                                                                                    then
                                                                                                                                        ssh-keygen -y -f "$MOUNT/plain/dot-ssh/github/identity.asc" | gh ssh-key add -
                                                                                                                                    fi
                                                                                                                                    if [[ -f "$MOUNT/plain/dot-ssh/mobile/identity.asc" ]]
                                                                                                                                    then
                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "GIT_SSH_COMMAND:?GIT_SSH_COMMAND must be exported" "}" ] }"
                                                                                                                                        MOBILE_PUBLIC="$( ssh-keygen -y -f "$MOUNT/plain/dot-ssh/mobile/identity.asc" )" || failure 47cc9859
                                                                                                                                        "$GIT_SSH_COMMAND" mobile "chmod 0600 ~/.ssh/authorized-keys"
                                                                                                                                        echo "$MOBILE_PUBLIC" | "$GIT_SSH_COMMAND" mobile "cat >> ~/.ssh/authorized-keys"
                                                                                                                                        "$GIT_SSH_COMMAND" "chmod 0400 ~/.ssh/authorized-keys"
                                                                                                                                    fi
                                                                                                                               '' ;
                                                                                                                        } ;
                                                                                                               in "${ application }/bin/pre-push" ;
                                                                                                        in
                                                                                                            ''
                                                                                                                mkdir --parents /mount/cipher
                                                                                                                cd /mount/cipher
                                                                                                                cd /mount/cipher
                                                                                                                git init 2>&1
                                                                                                                git remote add https https://github.com/${ config.personal.secrets.organization }/${ config.personal.secrets.repository }
                                                                                                                git remote add ssh github.com:${ config.personal.secrets.organization }/${ config.personal.secrets.repository }
                                                                                                                git fetch https main 2>&1
                                                                                                                git checkout https/main 2>&1
                                                                                                                mkdir --parents /mount/plain/dot-gnupg
                                                                                                                mkdir --parents /mount/plain/dot-ssh/github
                                                                                                                mkdir --parents /mount/plain/dot-ssh/mobile
                                                                                                                mkdir --parents /mount/plain/github
                                                                                                                git config user.email "${ config.personal.repository.private.email }"
                                                                                                                git config user.name "${ config.personal.repository.private.name }"
                                                                                                                wrap ${ post-commit } cipher/.git/hooks/post-commit 0500 --literal-brace "GIT_SSH_COMMAND:?GIT_SSH_COMMAND must be exported" --inherit-plain MOUNT --literal-plain PATH --uuid 708e9f8d
                                                                                                                # shellcheck disable=SC2016
                                                                                                                wrap ${ pre-commit } cipher/.git/hooks/pre-commit 0500 --literal-plain FILE --literal-plain IDENTITY --inherit-plain MOUNT --literal-plain PATH --literal-brace 'PLAINTEXT_FILE#"$MOUNT"/plain/' --literal-plain STAGED_FILE --uuid e7266fc5
                                                                                                                wrap ${ pre-push } cipher/.git/hooks/pre-push 0500 --literal-plain GIT_SSH_COMMAND --literal-brace "GIT_SSH_COMMAND:?GIT_SSH_COMMAND must be exported" --literal-plain MOBILE_PUBLIC --inherit-plain MOUNT --literal-plain PATH --uuid c49c4509
                                                                                                            '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ "cipher" "plain" ] ;
                                                                        transient = true ;
                                                                    } ;
                                                            temporary =
                                                                ignore :
                                                                    {
                                                                        init = { failure , pkgs , resources , root , seed , sequential , wrap } : "" ;
                                                                        transient = true ;
                                                                    } ;
                                                            volume =
                                                                let
                                                                    volume =
                                                                        branch : ignore :
                                                                            {
                                                                                init =
                                                                                    { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git pkgs.git-lfs pkgs.git-crypt pkgs.gnupg root wrap ( _failure.implementation "8fa509de" ) ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                gitattributes =
                                                                                                                    builtins.toFile
                                                                                                                        "gitattributes"
                                                                                                                        ''
                                                                                                                            secret filter=git-crypt diff=git-crypt
                                                                                                                        '' ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        DOT_SSH=${ resources.production.dot-ssh { failure = "failure 3a5de85d" ; } }
                                                                                                                        root "$DOT_SSH"
                                                                                                                        root ${ pkgs.openssh }
                                                                                                                        cd /mount
                                                                                                                        git init 2>&1
                                                                                                                        git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                        git config user.email "${ config.personal.volume.email }"
                                                                                                                        git config user.name "${ config.personal.volume.name }"
                                                                                                                        git remote add origin git@github.com:${ config.personal.volume.organization }/${ config.personal.volume.repository }
                                                                                                                        DOT_GNUPG=${ resources.production.dot-gnupg { } }
                                                                                                                        export GNUPGHOME="$DOT_GNUPG/dot-gnupg"
                                                                                                                        SECRETS=${ resources.production.secret.github.token { failure = "failure ba4fc2f1" ; } }
                                                                                                                        gh auth login --with-token < "$SECRETS/plaintext"
                                                                                                                        if gh repo view ${ config.personal.volume.organization }/${ config.personal.volume.repository } 2>&1
                                                                                                                        then
                                                                                                                            if git fetch origin ${ builtins.hashString "sha512" branch } 2>&1
                                                                                                                            then
                                                                                                                                gh auth logout 2>&1
                                                                                                                                git checkout ${ builtins.hashString "sha512" branch } 2>&1
                                                                                                                                git-crypt unlock 2>&1
                                                                                                                                if [[ ! -d /mount/secrets ]]
                                                                                                                                then
                                                                                                                                    mkdir --parents /mount/secrets
                                                                                                                                fi
                                                                                                                            else
                                                                                                                                gh auth logout 2>&1
                                                                                                                                git checkout -b ${ builtins.hashString "sha512" branch } 2>&1
                                                                                                                                git-crypt init 2>&1
                                                                                                                                wrap ${ gitattributes } .gitattributes 0400 --uuid 2a75750b
                                                                                                                                git-crypt add-gpg-user "${ config.personal.volume.email }" 2>&1
                                                                                                                                mkdir secret
                                                                                                                                git lfs install
                                                                                                                                git lfs track "secret/**"
                                                                                                                                git add .gitattributes
                                                                                                                                git commit -m "" --allow-empty --allow-empty-message 2>&1
                                                                                                                                git push origin HEAD 2>&1
                                                                                                                            fi
                                                                                                                        else
                                                                                                                            echo 34863932 gh repo create ${ config.personal.volume.organization }/${ config.personal.volume.repository } --private --confirm
                                                                                                                            gh repo create ${ config.personal.volume.organization }/${ config.personal.volume.repository } --private --confirm 2>&1
                                                                                                                            echo f1128459
                                                                                                                            gh auth logout 2>&1
                                                                                                                            git checkout -b ${ builtins.hashString "sha512" branch } 2>&1
                                                                                                                            git-crypt init 2>&1
                                                                                                                            wrap ${ gitattributes } .gitattributes 0400 --uuid 3ad5c843
                                                                                                                            git-crypt add-gpg-user "${ config.personal.volume.email }" 2>&1
                                                                                                                            mkdir secret
                                                                                                                            git lfs install
                                                                                                                            git lfs track "secret/**"
                                                                                                                            git add .gitattributes
                                                                                                                            git commit -m "" --allow-empty --allow-empty-message 2>&1
                                                                                                                            git push origin HEAD 2>&1
                                                                                                                        fi
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                seed =
                                                                                    {
                                                                                        release =
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "release" ;
                                                                                                            runtimeInputs = [ pkgs.git ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    cd /mount/repository
                                                                                                                    git add secret
                                                                                                                    git -m "" --allow-empty --allow-empty-message 2>&1
                                                                                                                    git push origin HEAD 2>&1
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/release" ;
                                                                                    } ;
                                                                                targets = [ ".git" ".gitattributes" "secret" ] ;
                                                                            } ;
                                                                    in
                                                                        {
                                                                            chromium =
                                                                                {
                                                                                    config = volume "f4857b9d" ;
                                                                                    data = volume "2b6879b7" ;
                                                                                } ;
                                                                        } ;
                                                        } ;
                                                } ;
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
                                                                        interactiveShellInit =
                                                                            let
                                                                                mapper =
                                                                                    name : value :
                                                                                        ''
                                                                                            /home/${ config.personal.name }/pad/${ name })
                                                                                                ;;
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
                                                                        pads =
                                                                            {
                                                                                after = [ "network.target" ] ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "ExecStart" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                            text =
                                                                                                                let
                                                                                                                    list =
                                                                                                                        _visitor.implementation
                                                                                                                            {
                                                                                                                                lambda =
                                                                                                                                    path : value :
                                                                                                                                        let
                                                                                                                                            autocomplete =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "autocomplete" ;
                                                                                                                                                                runtimeInputs = [ pkgs.findutils failure ] ;
                                                                                                                                                                text =
                                                                                                                                                                    let
                                                                                                                                                                        mapper =
                                                                                                                                                                            value :
                                                                                                                                                                                let
                                                                                                                                                                                    double-quote = builtins.concatStringsSep "" [ "'" "'" ] ;
                                                                                                                                                                                    in
                                                                                                                                                                                        ''
                                                                                                                                                                                            RESOURCE=${ value }
                                                                                                                                                                                            while IFS= read -r -d ${ double-quote } f
                                                                                                                                                                                            do
                                                                                                                                                                                                # shellcheck disable=SC1090
                                                                                                                                                                                                source "$f"
                                                                                                                                                                                            done < <(find "$RESOURCE" \( -type f -o -type l \) -print0 )
                                                                                                                                                                                        '' ;
                                                                                                                                                                        in
                                                                                                                                                                            ''
                                                                                                                                                                                ${ builtins.concatStringsSep "\n" ( builtins.map mapper node.autocomplete ) }
                                                                                                                                                                            '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/autocomplete" ;
                                                                                                                                            double-quotes = builtins.concatStringsSep "" [ "'" "'" ] ;
                                                                                                                                            envrc =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "envrc" ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        ${ builtins.concatStringsSep "\n" ( builtins.map ( value : "M${ builtins.hashString "sha512" value }=${ value }" ) node.man ) }
                                                                                                                                                                        export MANPATH="${ builtins.concatStringsSep ":" ( builtins.map ( value : "$M${ builtins.hashString "sha512" value }" ) node.man ) }"
                                                                                                                                                                        ${ builtins.concatStringsSep "\n" ( builtins.map ( value : "B${ builtins.hashString "sha512" value }=${ value }" ) node.bin ) }
                                                                                                                                                                        PATH="${ builtins.concatStringsSep ":" ( builtins.map ( value : "$B${ builtins.hashString "sha512" value }" ) node.bin ) }"
                                                                                                                                                                        export PATH="$PATH:${ pkgs.less }/bin:${ pkgs.man-db }/bin"
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/envrc" ;
                                                                                                                                            node = value null ;
                                                                                                                                            in
                                                                                                                                                [
                                                                                                                                                    ''
                                                                                                                                                        mkdir --parents /home/${ config.personal.name }/shells/${ builtins.concatStringsSep "/" path }
                                                                                                                                                        cat > /home/${ config.personal.name }/shells/${ builtins.concatStringsSep "/" path }/shell.nix <<EOF
                                                                                                                                                            { pkgs ? import <nixpkgs> {} } :
                                                                                                                                                                pkgs.mkShell
                                                                                                                                                                    {
                                                                                                                                                                        shellHook =
                                                                                                                                                                            ${ double-quotes }
                                                                                                                                                                                source /home/${ config.personal.name }/pads/${ builtins.concatStringsSep "/" path }/.envrc
                                                                                                                                                                                source ${ autocomplete }
                                                                                                                                                                            ${ double-quotes } ;
                                                                                                                                                                    }
                                                                                                                                                        EOF
                                                                                                                                                        cat > /home/${ config.personal.name }/shells/${ builtins.concatStringsSep "/" path }/.envrc <<EOF
                                                                                                                                                        use nix
                                                                                                                                                        EOF
                                                                                                                                                        mkdir --parents /home/${ config.personal.name }/pads/${ builtins.concatStringsSep "/" path }
                                                                                                                                                        ln --symbolic --force ${ envrc } /home/${ config.personal.name }/pads/${ builtins.concatStringsSep "/" path }/.envrc
                                                                                                                                                    ''
                                                                                                                                                ] ;
                                                                                                                                list = path : list : builtins.concatLists list ;
                                                                                                                                set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                                                            }
                                                                                                                            config.personal.pads ;
                                                                                                                    in builtins.concatStringsSep "\n" list ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/ExecStart" ;
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ] ;
                                                                            } ;
                                                                        recycle-identities =
                                                                            {
                                                                                description =
                                                                                    ''
                                                                                        Recycle the identities for mobile and for github
                                                                                    '' ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "ExecStart" ;
                                                                                                            runtimeInputs = [ pkgs.gh pkgs.git pkgs.openssh ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    TOKEN=${ resources.production.secret.github.token { } }
                                                                                                                    gh auth login --with-token < "$TOKEN/plaintext"
                                                                                                                    DOT_SSH=${ resources.production.dot-ssh { } }
                                                                                                                    SECRETS=${ resources.production.secrets { } }
                                                                                                                    export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                    git -C "$SECRETS/cipher" config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                                                                    ssh-keygen -y -f "$SECRETS/plain/dot-ssh/mobile/identity.asc" -C "systemd recycler" -P ""
                                                                                                                    git -C "$SECRETS/cipher" commit -am "systemd recycler"
                                                                                                                    gh auth logout
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/ExecStart" ;
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                            } ;
                                                                    } ;
                                                                timers =
                                                                    {
                                                                        recycle-identities =
                                                                            {
                                                                                enable = true ;
                                                                                timerConfig =
                                                                                    {
                                                                                        OnCalendar = "daily" ;
                                                                                        Persistent = true ;
                                                                                    } ;
                                                                            } ;
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
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "secrets" ;
                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                    text =
                                                                                        ''
                                                                                            SECRETS=${ resources.production.secrets { } }
                                                                                            echo "$SECRETS/plain"
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        pkgs.age
                                                                        pkgs.gh
                                                                        ( _failure.implementation "762e3818" )
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "studio" ;
                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.jetbrains.idea-community ] ;
                                                                                    text =
                                                                                        ''
                                                                                            if [[ "$#" -gt 0 ]]
                                                                                            then
                                                                                                HAS_ARGUMENTS=true
                                                                                                ARGUMENTS="$1"
                                                                                            else
                                                                                                HAS_ARGUMENTS=false
                                                                                                ARGUMENTS=
                                                                                            fi
                                                                                            STUDIO=${ resources.production.repository.studio.entry { setup = setup : ''${ setup } "$HAS_ARGUMENTS" "$ARGUMENTS"'' ; } }
                                                                                            if $HAS_ARGUMENTS
                                                                                            then
                                                                                                echo "$STUDIO/repository"
                                                                                            else
                                                                                                idea-community "$STUDIO/repository"
                                                                                            fi
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        pkgs.git
                                                                        pkgs.redis
                                                                        pkgs.yq-go
                                                                        pkgs.jq
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "foobar" ;
                                                                                    runtimeInputs = [ ] ;
                                                                                    text =
                                                                                        ''
                                                                                            FOOBAR=${ resources.foobar.foobar { setup = setup : ''${ setup } "$@"'' ; failure = "failure 175470c8" ; } }
                                                                                            echo "$FOOBAR"
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
                                                                pads =
                                                                    lib.mkOption
                                                                        {
                                                                            type =
                                                                                let
                                                                                    leaf =
                                                                                        let
                                                                                            type =
                                                                                                lib.types.submodule
                                                                                                    {
                                                                                                        options =
                                                                                                            {
                                                                                                                autocomplete = lib.mkOption { default = { } ; type = lib.types.listOf lib.types.str ; } ;
                                                                                                                bin = lib.mkOption { default = [ ] ; type = lib.types.listOf lib.types.str ; } ;
                                                                                                                man = lib.mkOption { default = [ ] ; type = lib.types.listOf lib.types.str ; } ;
                                                                                                            } ;
                                                                                                    } ;
                                                                                            in lib.types.functionTo type ;
                                                                                    list = lib.types.listOf type ;
                                                                                    set = lib.types.attrsOf type ;
                                                                                    type = lib.types.oneOf [ leaf list set ] ;
                                                                                    in type ;
                                                                            default =
                                                                                {
                                                                                    alpha =
                                                                                        ignore :
                                                                                            {
                                                                                                autocomplete =
                                                                                                    [
                                                                                                        ( resources.production.autocomplete.pass { } )
                                                                                                        ( resources.production.autocomplete.silly { } )
                                                                                                    ] ;
                                                                                                bin =
                                                                                                    [
                                                                                                        ( resources.production.bin.chromium { } )
                                                                                                        ( resources.production.bin.gpg { } )
                                                                                                        ( resources.production.bin.idea-community { } )
                                                                                                        ( resources.production.bin.pass { } )
                                                                                                        ( resources.production.bin.secrets { } )
                                                                                                        ( resources.production.bin.ssh { } )
                                                                                                    ] ;
                                                                                                man =
                                                                                                    [
                                                                                                        ( resources.production.man.chromium { } )
                                                                                                        ( resources.production.man.gpg { } )
                                                                                                        ( resources.production.man.idea-community { } )
                                                                                                        ( resources.production.man.pass { } )
                                                                                                        ( resources.production.man.secrets { } )
                                                                                                        ( resources.production.man.ssh { } )
                                                                                                    ] ;
                                                                                            } ;
                                                                                    beta =
                                                                                        ignore :
                                                                                            {
                                                                                                autocomplete =
                                                                                                    [
                                                                                                        ( resources.production.autocomplete.pass { } )
                                                                                                        ( resources.production.autocomplete.silly { } )
                                                                                                    ] ;
                                                                                                bin =
                                                                                                    [
                                                                                                        ( resources.production.bin.chromium { } )
                                                                                                        ( resources.production.bin.gpg { } )
                                                                                                        ( resources.production.bin.idea-community { } )
                                                                                                        ( resources.production.bin.pass { } )
                                                                                                        ( resources.production.bin.ssh { } )
                                                                                                    ] ;
                                                                                                man =
                                                                                                    [
                                                                                                        ( resources.production.man.chromium { } )
                                                                                                        ( resources.production.man.gpg { } )
                                                                                                        ( resources.production.man.idea-community { } )
                                                                                                        ( resources.production.man.pass { } )
                                                                                                        ( resources.production.man.ssh { } )
                                                                                                    ] ;
                                                                                            } ;
                                                                                    career = { } ;
                                                                                    home =
                                                                                        ignore :
                                                                                            {
                                                                                                autocomplete =
                                                                                                    [
                                                                                                        ( resources.production.autocomplete.pass { } )
                                                                                                        # ( resources.production.autocomplete.secrets { } )
                                                                                                        ( resources.production.autocomplete.silly { } )
                                                                                                    ] ;
                                                                                                bin =
                                                                                                    [
                                                                                                        "${ pkgs.coreutils }/bin"
                                                                                                        "${ pkgs.which }/bin"
                                                                                                        ( resources.production.bin.chromium { } )
                                                                                                        ( resources.production.bin.gpg { } )
                                                                                                        ( resources.production.bin.idea-community { } )
                                                                                                        ( resources.production.bin.pass { } )
                                                                                                        ( resources.production.bin.secrets { } )
                                                                                                        ( resources.production.bin.ssh { } )
                                                                                                    ] ;
                                                                                                man =
                                                                                                    [
                                                                                                        ( resources.production.man.chromium { } )
                                                                                                        ( resources.production.man.gpg { } )
                                                                                                        ( resources.production.man.idea-community { } )
                                                                                                        ( resources.production.man.pass { } )
                                                                                                        ( resources.production.man.secrets { } )
                                                                                                        ( resources.production.man.ssh { } )
                                                                                                    ] ;
                                                                                            } ;
                                                                                    foobar =
                                                                                        ignore :
                                                                                            {
                                                                                                autocomplete = [ ] ;
                                                                                                bin = [ ( resources.foobar.bin { } ) ] ;
                                                                                                man = [ ] ;
                                                                                            } ;
                                                                                } ;
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
                                                                        resource-logger =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "resource-logger" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        resource-releaser =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "resource-releaser" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        resource-reporter =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "resource-reporter" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        resource-resolver =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "resource-resolver" ; type = lib.types.str ; } ;
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
                    in
                        {
                            checks =
                                {
                                   failure =
                                       _failure.check
                                           {
                                               compile-time-arguments = "469c07cdbb13c65f1435bb0b9b7eb5ed2c14d70bc111d12fda44c2cd47c23e99aed06672fec7e138bfa11de61184774d7b2dd2d33aa5958d9df49a4c55e6a8e3" ;
                                               diffutil = pkgs.diffutil ;
                                               expected-standard-error =
                                                   ''
                                                       compile-time-arguments:
                                                         path: []
                                                         type: string
                                                         value: 469c07cdbb13c65f1435bb0b9b7eb5ed2c14d70bc111d12fda44c2cd47c23e99aed06672fec7e138bfa11de61184774d7b2dd2d33aa5958d9df49a4c55e6a8e3
                                                       run-time-arguments:
                                                         - ba02df6c2bf44bb25e7a23fe02dac230baaabda128f463ce26af83e7787bc16de9260f56beaacdef75743665eededeaae997f50892983be4f40453ef6e817f4f
                                                         - b026466b770b22f738c176f6130e1d5daaca7cbffee8605eeb9f3cb2c9c7a65eb3af44cc202745bc168a7b19e2fc87a909762516f697b7dee855f5454b90c39b
                                                    '' ;
                                               run-time-arguments =
                                                   [
                                                       "ba02df6c2bf44bb25e7a23fe02dac230baaabda128f463ce26af83e7787bc16de9260f56beaacdef75743665eededeaae997f50892983be4f40453ef6e817f4f"
                                                       "b026466b770b22f738c176f6130e1d5daaca7cbffee8605eeb9f3cb2c9c7a65eb3af44cc202745bc168a7b19e2fc87a909762516f697b7dee855f5454b90c39b"
                                                   ] ;
                                           } ;
                                    resource =
                                        let
                                            factory =
                                                _resource
                                                    {
                                                        channel = "58c7d369b0ce01c248dc06747e2414e64190b49ec8b54ab8b5d20f96a2033759636788d718be578255e47ea0ab95810bfe7e027b8bd7f7eb4c1d3bfb5e682480" ;
                                                        resources-directory = "/build/resources" ;
                                                        resources =
                                                            {
                                                                d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 =
                                                                    let
                                                                        application =
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "f70dbffba5f85b11de293ea0f9383ff05f210b1bcca0443f79657db645a2187594511f7ce158302a8c7f249e8dc47128baa17302e96b3be43b6e33d26e822a77" ;
                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                    text =
                                                                                        ''
                                                                                            echo resources = 5a4c4b30e8f8199aa21f472a633c5eb45e7b530f6d327babb477f67a1e7b2e6c42686f75ebf54ee29b4c48c1ceda5a84a1d192b8953a8362ebce397788934df7
                                                                                        '' ;
                                                                                } ;
                                                                        in "${ application }/bin/f70dbffba5f85b11de293ea0f9383ff05f210b1bcca0443f79657db645a2187594511f7ce158302a8c7f249e8dc47128baa17302e96b3be43b6e33d26e822a77" ;
                                                            } ;
                                                        root-directory = "/build/gc-roots" ;
                                                    } ;
                                            in
                                                factory.check
                                                    {
                                                        arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
                                                        diffutils = pkgs.diffutils ;
                                                        expected = ./resource.json ;
                                                        expected-resource = "/build/resources/mounts/0000000311691948" ;
                                                        init =
                                                            { failure , pkgs , resources , root , seed , sequential , wrap } :
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "init" ;
                                                                                runtimeInputs = [ pkgs.coreutils pkgs.libuuid pkgs.cowsay root ] ;
                                                                                text =
                                                                                    ''
                                                                                        cowsay 995246ed
                                                                                        RESOURCE=${ resources.d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 }
                                                                                        echo "mount = $MOUNT"
                                                                                        echo 577c4dbd > /mount/7938c529
                                                                                        echo f3ae034e > /scratch/f6f540b2
                                                                                        root "$RESOURCE"
                                                                                        root ${ pkgs.cowsay }
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ application }/bin/init" ;
                                                        jd-diff-patch = pkgs.jd-diff-patch ;
                                                        resources-directory-fixture =
                                                            resources-directory :
                                                                ''
                                                                    mkdir --parents ${ resources-directory }/sequential
                                                                    echo 311691948 > ${ resources-directory }/sequential/sequential.counter
                                                                '' ;
                                                        seed = "4259572168968d95098b9a5a8572c6ecfabe61a2522103e4c75b1317ea9cf43f96f7a135d144d2184739b6c4bd7fad1fb13a117dabbc9e58f4d4edbc26cf34f5" ;
                                                        standard-input = "5433bd8482be1f2e1c1db4fa9268ed6e7bb02285083decb86a6166eea2df77f7e2d7524541549a3ee73d03ae955d8ec0714a959944962e8fe18f343fe108ff9f" ;
                                                        standard-output = "/build/resources/mounts/0000000311691948" ;
                                                        status = 0 ;
                                                        targets =
                                                            [
                                                                "7938c529"
                                                            ] ;
                                                        transient = false ;
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
                                    modules =
                                        {
                                            user = user ;
                                        } ;
                                } ;
            } ;
}
