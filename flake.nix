# 484d2919
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
                        git-repository ,
                        nixpkgs ,
                        private ,
                        private-reporter ,
                        resource ,
                        resource-logger ,
                        resource-releaser ,
                        resource-reporter ,
                        resource-resolver ,
                        string ,
                        system ,
                        visitor
                    } @primary :
                        let
                            _failure = failure.lib { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; visitor = visitor ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                            __failure = _failure.implementation "7fef1fe4" ;
                            ___failure = uuid : "${ __failure }/bin/failure ${ uuid }" ;
                            _fixture = fixture.lib { age = pkgs.age ; coreutils = pkgs.coreutils ; failure = _failure.implementation "6bf7303d" ; gnupg = pkgs.gnupg ; libuuid = pkgs.libuuid ; mkDerivation = pkgs.stdenv.mkDerivation ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _git-repository = git-repository.lib { string = _string.implementation ; visitor = _visitor.implementation ; } ;
                            _private-reporter = private-reporter.lib { failure = _failure.implementation "8e2eb1d7" ; pkgs = pkgs ; } ;
                            _resource =
                                {
                                    channel ,
                                    resources-directory ,
                                    resources ,
                                    store-garbage-collection-root
                                } :
                                    resource.lib
                                        {
                                            buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                            channel = channel ;
                                            coreutils = pkgs.coreutils ;
                                            failure = _failure.implementation "f135add3" ;
                                            findutils = pkgs.findutils ;
                                            flock = pkgs.flock ;
                                            jq = pkgs.jq ;
                                            makeBinPath = pkgs.lib.makeBinPath ;
                                            makeWrapper = pkgs.makeWrapper ;
                                            mkDerivation = pkgs.stdenv.mkDerivation ;
                                            nix = pkgs.nix ;
                                            originator-pid-variable = "c8f5d41a0628fd3c396fe940332263f7cd53f0caa6b656e12466dfdcb4173a6c0537736ab0bc1a37344a748febdd1eab5cc65c20493218afb606dc4c74b4e38d" ;
                                            ps = pkgs.ps ;
                                            redis = pkgs.redis ;
                                            resources = resources ;
                                            resources-directory = resources-directory ;
                                            store-garbage-collection-root = store-garbage-collection-root ;
                                            string = _string.implementation ;
                                            visitor = _visitor.implementation ;
                                            writeShellApplication = pkgs.writeShellApplication ;
                                            yq-go = pkgs.yq-go ;
                                        } ;
                            _resource-logger = resource-logger.lib { failure = _failure.implementation "2aedf93a" ; pkgs = pkgs ; } ;
                            _resource-reporter = resource-reporter.lib { failure = _failure.implementation "029cbc4c" ; pkgs = pkgs ; } ;
                            _resource-releaser = resource-releaser.lib { failure = _failure.implementation "6dd07d42" ; pkgs = pkgs ; } ;
                            _resource-resolver = resource-resolver.lib { failure = _failure.implementation "4321b4b8" ; pkgs = pkgs ; } ;
                            _string = string.lib { visitor = _visitor.implementation ; } ;
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
                                        resources__ =
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
                                                                            resources = resources__ ;
                                                                            resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                            store-garbage-collection-root = "/home/${ config.personal.name }/.gc-roots" ;
                                                                        } ;
                                                                    in
                                                                        r.implementation
                                                                            {
                                                                                init = point.init or null ;
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
                                                            foobar =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                            { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ root __failure ] ;
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
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                                                                            DOT_GNUPG=${ resources__.production.dot-gnupg { failure = "failure 75dc4165" ; } }
                                                                                                                                            export GNUPGHOME="$DOT_GNUPG/dot-gnupg"
                                                                                                                                            gpg --homedir "$GNUPGHOME" --sign --local-user ${ config.personal.chromium.home.data.email } --dry-run
                                                                                                                                        '' ;
                                                                                                                                } ;
                                                                                                                        in "${ application }/bin/unlock" ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        wrap ${ unlock } bin/unlock 0500 --literal-plain DOT_GNUPG --literal-plain GNUPGHOME --literal-plain DOT_GNUPG --literal-plain PATH
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
                                                                            { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                         init =
                                                                                             { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                        RESOURCE=${ resources__.production.repository.pass { } }
                                                                                        export PASSWORD_STORE_DIR="$RESOURCE/repository"
                                                                                        # shellcheck disable=SC1091
                                                                                        source ${ pkgs.pass }/share/bash-completion/completions/pass
                                                                                        _pass "$@"
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
                                                                                init =
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                                                                    runtimeInputs = runtimeInputs pkgs ;
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
                                                                                                                                                    # ${ builtins.concatStringsSep "\n" ( builtins.map ( value : "${ value.name }=${ value.string } # ${ builtins.toString value.oid }" ) list ) }
                                                                                                                                                    # ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : "${ name }=${ value resources }" ) variables ) ) }
                                                                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.map ( name : ''export ${ name }="${ builtins.concatStringsSep "" [ "$" name ] }"'' ) environment ) }
                                                                                                                                                    if [[ -t 0 ]]
                                                                                                                                                    then
                                                                                                                                                        ${ script }
                                                                                                                                                    else
                                                                                                                                                        ${ pkgs.coreutils }/bin/cat | ${ script }
                                                                                                                                                    fi
                                                                                                                                                '' ;
                                                                                                                                } ;
                                                                                                                        in "${ application }/bin/${ name }" ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        wrap ${ bin } ${ name } 0500 --literal-plain PATH ${ builtins.concatStringsSep "" ( builtins.map ( value : " --literal-plain ${ value }" ) ( builtins.attrNames variables ) ) }
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
                                                                                                XDG_CONFIG_HOME_RESOURCE = resources : resources.production.volume.chromium.config { failure = ___failure "a9192261" ; } ;
                                                                                                XDG_DATA_HOME_RESOURCE = resources : resources.production.volume.chromium.data { failure = ___failure "e55856e2" ; } ;
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
                                                                                                DOT_GNUPG = resources : resources.production.dot-gnupg { failure = ___failure "44eb225c" ; } ;
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
                                                                                                RESOURCE = resources : resources.production.repository.studio.entry { failure = ___failure "560f61b9" ; } ;
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
                                                                                                DOT_GNUPG = resources : resources.production.dot-gnupg { failure = ___failure "f68dcf20" ; } ;
                                                                                                RESOURCE = resources : resources.production.repository.pass { failure = ___failure "cf87710c" ; } ;
                                                                                                PASSWORD_STORE_GPG_OPTS = resources : ''"--homedir $DOT_GNUPG/dot-gnupg"'' ;
                                                                                                PASSWORD_STORE_DIR = resources : "$RESOURCE/repository " ;
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
                                                                                                DOT_SSH = resources : resources.production.dot-ssh { failure = ___failure "73be674b" ; } ;
                                                                                            } ;
                                                                                    } ;
                                                                        } ;
                                                                        # FINDME
                                                            dot-gnupg =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { pid , pkgs , resources , root , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gnupg ( ___failure "428d8579" ) ] ;
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
                                                                            { pid , pkgs , resources , root , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ root wrap ( ___failure "ff7d31ef" )] ;
                                                                                                text =
                                                                                                    let
                                                                                                        ssh-config =
                                                                                                            builtins.toFile
                                                                                                                "config"
                                                                                                                ''
                                                                                                                    Host github.com
                                                                                                                        HostName github.com
                                                                                                                        User git
                                                                                                                        IdentityFile $GITHUB_IDENTITY
                                                                                                                        UserKnownHostsFile $GITHUB_KNOWN_HOSTS
                                                                                                                        StrictHostKeyChecking yes

                                                                                                                    Host mobile
                                                                                                                        HostName $MOBILE_IP
                                                                                                                        User git
                                                                                                                        IdentityFile $MOBILE_IDENTITY
                                                                                                                        UserKnownHostsFile $MOBILE_KNOWN_HOSTS
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
                                                            fixture =
                                                                {
                                                                    laptop =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        { pid , pkgs , resources , root , sequential , wrap } :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "init" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    cat ${ identity }/identity > /mount/identity
                                                                                                                    cat ${ identity }/identity.pub > /mount/identity.pub
                                                                                                                    chmod 0400 /mount/identity /mount/identity.pub
                                                                                                                    touch /mount/known-hosts
                                                                                                                    chmod 0600 /mount/known-hosts
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ "identity" "identity.pub" "known-hosts" ] ;
                                                                                } ;
                                                                } ;
                                                            flake =
                                                                {
                                                                    build-vm =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                init =
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
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
                                                                                                            wrap ${ post-commit} repository/.git/hooks/post-commit 0500 --literal-plain PATH
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
                                                                                                            wrap ${ application }/bin/ssh stage/ssh/command 0500 --literal-plain "@" --inherit-plain MOUNT --literal-plain PATH
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
                                                                                    _git-repository.implementation
                                                                                        {
                                                                                            resolutions = [ ] ;
                                                                                            setup =
                                                                                                { pid , resources , pkgs , root , sequential , wrap } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "setup" ;
                                                                                                                    runtimeInputs = [ pkgs.git root wrap ] ;
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
                                                                                                                            ssh =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "ssh" ;
                                                                                                                                                runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        ssh -F "$MOUNT/stage/ssh/config" "$@"
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/ssh" ;
                                                                                                                            in
                                                                                                                                ''
                                                                                                                                    git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                    git config user.email ${ config.personal.pass.email }
                                                                                                                                    git config user.name ${ config.personal.pass.name }
                                                                                                                                    ln --symbolic ${ post-commit } "/mount/repository/.git/hooks/post-commit"
                                                                                                                                    git remote add origin ${ config.personal.pass.remote }
                                                                                                                                    wrap ${ ssh } stage/ssh/command 0500 --literal-plain "@" --inherit-plain MOUNT --literal-plain PATH
                                                                                                                                    DOT_SSH=${ resources.production.dot-ssh { } }
                                                                                                                                    root "$DOT_SSH"
                                                                                                                                    wrap "$DOT_SSH/config" stage/ssh/config 0400
                                                                                                                                    git fetch origin ${ config.personal.pass.branch } 2>&1
                                                                                                                                    git checkout ${ config.personal.pass.branch } 2>&1
                                                                                                                                '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/setup" ;

                                                                                        } ;
                                                                            secrets2 =
                                                                                {
                                                                                    read-only =
                                                                                        ignore :
                                                                                            _git-repository.implementation
                                                                                                {
                                                                                                    resolutions = [ ] ;
                                                                                                    setup =
                                                                                                        { pid , pkgs , resources , root , sequential , wrap } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "setup" ;
                                                                                                                            runtimeInputs = [ pkgs.age pkgs.coreutils pkgs.git wrap ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    git config user.email "no-commit@no-commit"
                                                                                                                                    git config user.name "no commits"
                                                                                                                                    git remote add origin https://github.com/${ config.personal.secrets2.organization }/${ config.personal.secrets2.repository }
                                                                                                                                    git fetch origin ${ config.personal.secrets2.branch } 2>&1
                                                                                                                                    git checkout origin/${ config.personal.secrets2.branch } 2>&1
                                                                                                                                    find /mount/repository -mindepth 1 -type f -name "*.age" ! -path "/mount/repository/.git/*" | while read -r CIPHERTEXT_FILE
                                                                                                                                    do
                                                                                                                                        RELATIVE_PATH="${ builtins.concatStringsSep "" [ "$" "{" "CIPHERTEXT_FILE#/mount/repository/" "}" ] }"
                                                                                                                                        RELATIVE_DIRECTORY="$( dirname "$RELATIVE_PATH" )" || failure af52a03a
                                                                                                                                        CIPHERTEXT_FILE_="$( basename "$CIPHERTEXT_FILE" )" || failure b0e65b58
                                                                                                                                        PLAINTEXT_FILE="/mount/stage/$RELATIVE_DIRECTORY/${ builtins.concatStringsSep "" [ "$" "{" "CIPHERTEXT_FILE_%.age" "}" ] }"
                                                                                                                                        PLAINTEXT_FILE_="$( dirname "$PLAINTEXT_FILE" )" || failure 92381511
                                                                                                                                        mkdir --parents "$PLAINTEXT_FILE_"
                                                                                                                                        age --decrypt --identity ${ config.personal.agenix } --output "$PLAINTEXT_FILE" "$CIPHERTEXT_FILE"
                                                                                                                                        chmod 0400 "$PLAINTEXT_FILE"
                                                                                                                                    done
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/setup" ;
                                                                                                } ;
                                                                                    read-write =
                                                                                        ignore :
                                                                                            _git-repository.implementation
                                                                                                {
                                                                                                    resolutions = [ ] ;
                                                                                                    setup =
                                                                                                        { pid , pkgs , resources , root , sequential , wrap } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "setup" ;
                                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid wrap ] ;
                                                                                                                            text =
                                                                                                                                let
                                                                                                                                    github-identity =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "github-identity" ;
                                                                                                                                                        runtimeInputs = [ pkgs.age pkgs.coreutils pkgs.flock pkgs.gh pkgs.libuuid pkgs.openssh __failure ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                echo 68d9ad41
                                                                                                                                                                exec 201> "$MOUNT/lock"
                                                                                                                                                                flock 201
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                sleep 10
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure b9131928
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 22724f93
                                                                                                                                                                echo 24d3677d 3fbea38b
                                                                                                                                                                SECRETS=${ resources.production.repository.secrets2.read-only { failure = "failure 64ef3c7e" ; } }
                                                                                                                                                                echo 24d3677d 250ac697
                                                                                                                                                                git fetch origin ${ config.personal.secrets2.branch }
                                                                                                                                                                echo 24d3677d e302e18e
                                                                                                                                                                git checkout origin/${ config.personal.secrets2.branch }
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                mkdir --parents "$MOUNT/stage/plain-text/dot-ssh/github"
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                ssh-keygen -f "$MOUNT/stage/plain-text/dot-ssh/github/identity.asc" -C "generated" -P ""
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                RECIPIENT=${ resources.production.age { failure = "failure a4114343" ; } }
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                RECIPIENT_="$( cat "$RECIPIENT/public" )" || failure 259d4017
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                age --encrypt --recipient "$RECIPIENT_" --output "$MOUNT/repository/dot-ssh/github/identity.asc.age" "$MOUNT/stage/plain-text/dot-ssh/github/identity.asc"
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                git checkout -b "$BRANCH"
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                git commit -am "recycled github identity"
                                                                                                                                                                echo 24d3677d
                                                                                                                                                                git push origin "$BRANCH"
                                                                                                                                                                echo 24d3677d a7577b41
                                                                                                                                                                gh auth login --with-token < "$SECRETS/stage/github/token.asc"
                                                                                                                                                                echo 24d3677d acbf7b41
                                                                                                                                                                gh pr create --base ${ config.personal.secrets2.branch } --head "$BRANCH" --title "update github identity" --body ""
                                                                                                                                                                echo 24d3677d 21b2cf3d
                                                                                                                                                                URL="$( gh pr view --json url --jq .url )" || failure 864bc6e6
                                                                                                                                                                echo 24d3677d ef9d97c0
                                                                                                                                                                gh pr merge "$URL" --rebase
                                                                                                                                                                echo 24d3677d 739b0be5
                                                                                                                                                                # gh ssh-key list --json id | jq -r '.[].id' | while read -r key_id
                                                                                                                                                                # do
                                                                                                                                                                #     gh ssh-key delete "$key_id" --confirm
                                                                                                                                                                # done
                                                                                                                                                                echo 24d3677d 1ce1651f
                                                                                                                                                                gh ssh-key add "$MOUNT/stage/plain-text/dot-ssh/github/identity.asc.pub"
                                                                                                                                                                echo 24d3677d 079de5f7
                                                                                                                                                                gh auth logout
                                                                                                                                                                echo 24d3677d 84e05491
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/github-identity" ;
                                                                                                                                    github-token =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "github-token" ;
                                                                                                                                                        runtimeInputs = [ pkgs.age pkgs.coreutils pkgs.flock pkgs.gh pkgs.libuuid pkgs.openssh __failure ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                exec 201> "$MOUNT/lock"
                                                                                                                                                                flock 201
                                                                                                                                                                sleep 20
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                git fetch origin ${ config.personal.secrets2.branch }
                                                                                                                                                                git checkout origin/${ config.personal.secrets2.branch }
                                                                                                                                                                mkdir --parents "$MOUNT/stage/github"
                                                                                                                                                                cat > "$MOUNT/stage/github/token.asc"
                                                                                                                                                                RECIPIENT=${ resources.production.age { failure = "failure a4114343" ; } }
                                                                                                                                                                RECIPIENT_="$( cat "$RECIPIENT/public" )" || failure 259d4017
                                                                                                                                                                age --encrypt --recipient "$RECIPIENT_" --output "$MOUNT/repository/github/token.asc.age" "$MOUNT/stage/github/token.asc"
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure b9131928
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 22724f93
                                                                                                                                                                git checkout -b "$BRANCH"
                                                                                                                                                                git commit -am "recycled github token"
                                                                                                                                                                git push origin "$BRANCH"
                                                                                                                                                                SECRETS=${ resources.production.repository.secrets2.read-only { failure = "failure 64ef3c7e" ; } }
                                                                                                                                                                gh auth login --with-token < "$SECRETS/stage/github/token.asc"
                                                                                                                                                                gh pr create --base ${ config.personal.secrets2.branch } --head "$BRANCH" --title "update github token" --body ""
                                                                                                                                                                URL="$( gh pr view --json url --jq .url )" || failure 864bc6e6
                                                                                                                                                                gh pr merge "$URL" --rebase
                                                                                                                                                                gh auth logout
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/github-token" ;
                                                                                                                                    github-known-hosts =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "github-known-hosts" ;
                                                                                                                                                        runtimeInputs = [ pkgs.age pkgs.coreutils pkgs.flock pkgs.gh pkgs.libuuid __failure ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                exec 201> "$MOUNT/lock"
                                                                                                                                                                flock 201
                                                                                                                                                                sleep 30
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                git fetch origin ${ config.personal.secrets2.branch }
                                                                                                                                                                git checkout origin/${ config.personal.secrets2.branch }
                                                                                                                                                                mkdir --parents "$MOUNT/stage/dot-ssh/github"
                                                                                                                                                                cat > "$MOUNT/stage/dot-ssh/github/known-hosts.asc"
                                                                                                                                                                RECIPIENT=${ resources.production.age { failure = "failure a4114343" ; } }
                                                                                                                                                                RECIPIENT_="$( cat "$RECIPIENT/public" )" || failure 259d4017
                                                                                                                                                                age --encrypt --recipient "$RECIPIENT_" --output "$MOUNT/repository/dot-ssh/github/known-hosts.asc.age" "$MOUNT/stage/dot-ssh/github/known-hosts.asc"
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure b9131928
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 22724f93
                                                                                                                                                                git checkout -b "$BRANCH"
                                                                                                                                                                git commit -am "recycled github known hosts"
                                                                                                                                                                git push origin "$BRANCH"
                                                                                                                                                                SECRETS=${ resources.production.repository.secrets2.read-only { failure = "failure 64ef3c7e" ; } }
                                                                                                                                                                gh auth login --with-token < "$SECRETS/stage/github/token.asc"
                                                                                                                                                                gh pr create --base ${ config.personal.secrets2.branch } --head "$BRANCH" --title "update github known-hosts" --body ""
                                                                                                                                                                URL="$( gh pr view --json url --jq .url )" || failure 864bc6e6
                                                                                                                                                                gh pr merge "$URL" --rebase
                                                                                                                                                                gh auth logout
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/github-known-hosts" ;
                                                                                                                                    gnupg =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "gnupg" ;
                                                                                                                                                        runtimeInputs = [ pkgs.bash pkgs.flock pkgs.gnupg ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                exec 201> "$MOUNT/lock"
                                                                                                                                                                flock 201
                                                                                                                                                                DOT_GNUPG=${ resources.production.dot-gnupg { failure = "b80cddcf" ; } }
                                                                                                                                                                export GNUPGHOME="$DOT_GNUPG/dot-gnupg"
                                                                                                                                                                bash
                                                                                                                                                                mkdir --parents "$MOUNT/stage/plain-text/dot-gnupg"
                                                                                                                                                                gpg --export-ownertrust --armor --output "$MOUNT/stage/plain-text/dot-gnupg/ownertrust.asc"
                                                                                                                                                                gpg --export-secret-keys --armor --output "$MOUNT/stage/plain-text/dot-gnupg/secret-keys.asc"
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure ae3da5c1
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 96713a9a
                                                                                                                                                                SECRETS=${ resources.production.repository.secrets2.read-only { setup = setup : ''${ setup } "$UUID"'' ; failure = "failure 75fe42d1" ; } }
                                                                                                                                                                git fetch origin ${ config.personal.secrets2.branch }
                                                                                                                                                                git checkout origin/${ config.personal.secrets2.branch }
                                                                                                                                                                RECIPIENT=${ resources.production.age { failure = "failure a4114343" ; } }
                                                                                                                                                                RECIPIENT_="$( cat "$RECIPIENT/public" )" || failure 259d4017
                                                                                                                                                                age --encrypt --recipient "$RECIPIENT_" --output "$MOUNT/repository/plain-text/dot-gnupg/ownertrust.asc.age" "$MOUNT/stage/plain-text/dot-gnupg/ownertrust.asc"
                                                                                                                                                                age --encrypt --recipient "$RECIPIENT_" --output "$MOUNT/repository/plain-text/dot-gnupg/secret-keys.asc.age" "$MOUNT/stage/plain-text/dot-gnupg/secret-keys.asc"
                                                                                                                                                                git checkout -b "$BRANCH"
                                                                                                                                                                git commit -am "recycled dot-gnupg"
                                                                                                                                                                git push origin "$BRANCH"
                                                                                                                                                                gh auth login --with-token < "$SECRETS/stage/github/token.asc"
                                                                                                                                                                gh pr create --base ${ config.personal.secrets2.branch } --head "$BRANCH" --title "update dot-gnupg" --body ""
                                                                                                                                                                URL="$( gh pr view --json url --jq .url )" || failure e9f4b560
                                                                                                                                                                gh pr merge "$URL" --rebase
                                                                                                                                                                gh auth logout
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/gnupg" ;
                                                                                                                                    mobile-known-hosts =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mobile-known-hosts" ;
                                                                                                                                                        runtimeInputs = [ pkgs.age pkgs.coreutils pkgs.flock pkgs.gh pkgs.libuuid __failure ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                exec 201> "$MOUNT/lock"
                                                                                                                                                                flock 201
                                                                                                                                                                sleep 40
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                git fetch origin ${ config.personal.secrets2.branch }
                                                                                                                                                                git checkout origin/${ config.personal.secrets2.branch }
                                                                                                                                                                mkdir --parents "$MOUNT/stage/dot-ssh/mobile"
                                                                                                                                                                cat > "$MOUNT/stage/dot-ssh/mobile/known-hosts.asc"
                                                                                                                                                                RECIPIENT=${ resources.production.age { failure = "failure a4114343" ; } }
                                                                                                                                                                RECIPIENT_="$( cat "$RECIPIENT/public" )" || failure 259d4017
                                                                                                                                                                age --encrypt --recipient "$RECIPIENT_" --output "$MOUNT/repository/dot-ssh/mobile/known-hosts.asc.age" "$MOUNT/stage/dot-ssh/mobile/known-hosts.asc"
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure b9131928
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 22724f93
                                                                                                                                                                git checkout -b "$BRANCH"
                                                                                                                                                                git commit -am "recycled mobile known hosts"
                                                                                                                                                                git push origin "$BRANCH"
                                                                                                                                                                SECRETS=${ resources.production.repository.secrets2.read-only { failure = "failure 64ef3c7e" ; } }
                                                                                                                                                                gh auth login --with-token < "$SECRETS/stage/mobile/token.asc"
                                                                                                                                                                gh pr create --base ${ config.personal.secrets2.branch } --head "$BRANCH" --title "update mobile known-hosts" --body ""
                                                                                                                                                                URL="$( gh pr view --json url --jq .url )" || failure 864bc6e6
                                                                                                                                                                gh pr merge "$URL" --rebase
                                                                                                                                                                gh auth logout
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mobile-known-hosts" ;
                                                                                                                                    mobile-identity =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mobile-identity" ;
                                                                                                                                                        runtimeInputs = [ pkgs.age pkgs.coreutils pkgs.flock pkgs.gh pkgs.libuuid pkgs.openssh __failure ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                exec 201> "$MOUNT/lock"
                                                                                                                                                                flock 201
                                                                                                                                                                sleep 50
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure fa87d816
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 7f9ffef5
                                                                                                                                                                SECRETS=${ resources.production.repository.secrets2.read-only { setup = setup : ''${ setup } "$UUID"'' ; failure = "failure bcfd4baf" ; } }
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                DOT_SSH=${ resources.production.dot-ssh { failure = "failure 9335cc7a" ; } }
                                                                                                                                                                git fetch origin ${ config.personal.secrets2.branch }
                                                                                                                                                                git checkout origin/${ config.personal.secrets2.branch }
                                                                                                                                                                mkdir --parents "$MOUNT/stage/plain-text/dot-ssh/mobile"
                                                                                                                                                                ssh-keygen -f "$MOUNT/stage/plain-text/dot-ssh/mobile/identity.asc" -C "generated" -P ""
                                                                                                                                                                RECIPIENT=${ resources.production.age { failure = "failure 1994c57a" ; } }
                                                                                                                                                                RECIPIENT_="$( cat "$RECIPIENT/public" )" || failure 57606f23
                                                                                                                                                                age --encrypt --recipient "$RECIPIENT_" --output "$MOUNT/repository/dot-ssh/mobile/identity.asc.age" "$MOUNT/stage/plain-text/dot-ssh/mobile/identity.asc"
                                                                                                                                                                git checkout -b "$BRANCH"
                                                                                                                                                                git commit -am "recycled mobile identity"
                                                                                                                                                                git push origin "$BRANCH"
                                                                                                                                                                gh auth login --with-token < "$SECRETS/stage/github/token.asc"
                                                                                                                                                                gh pr create --base ${ config.personal.secrets2.branch } --head "$BRANCH" --title "update mobile identity" --body ""
                                                                                                                                                                URL="$( gh pr view --json url --jq .url )" || failure f5fdf2e4
                                                                                                                                                                gh pr merge "$URL" --rebase
                                                                                                                                                                gh auth logout
                                                                                                                                                                # ssh -F "$DOT_SSH/config" mobile "rm ~/.authorized_keys"
                                                                                                                                                                ssh -F "$DOT_SSH/config" mobile "tee --append ~/.ssh/authorized_keys" < "$MOUNT/stage/plain-text/dot-ssh/mobile/identity.asc.pub"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mobile-identity" ;
                                                                                                                                    in
                                                                                                                                        ''
                                                                                                                                            git config alias.github-identity "!$MOUNT/stage/alias/github-identity"
                                                                                                                                            git config alias.github-known-hosts "!$MOUNT/stage/alias/github-known-hosts"
                                                                                                                                            git config alias.github-token "!$MOUNT/stage/alias/github-token"
                                                                                                                                            git config alias.gnupg "!$MOUNT/stage/alias/gnupg"
                                                                                                                                            git config alias.mobile-identity "!$MOUNT/stage/alias/mobile-identity"
                                                                                                                                            git config alias.mobile-known-hosts "!$MOUNT/stage/alias/mobile-known-hosts"
                                                                                                                                            git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                            git config user.email "${ config.personal.secrets2.email }"
                                                                                                                                            git config user.name "${ config.personal.secrets2.name }"
                                                                                                                                            git remote add origin git@github.com:${ config.personal.secrets2.organization }/${ config.personal.secrets2.repository }
                                                                                                                                            ${ ssh pkgs resources root wrap }
                                                                                                                                            wrap ${ github-identity } stage/alias/github-identity 0500 --literal-plain BRANCH --literal-plain key_id --inherit-plain MOUNT --literal-plain PATH --literal-plain RECIPIENT --literal-plain RECIPIENT_ --literal-plain SECRETS --literal-plain UUID --literal-plain URL --uuid b850b6fa
                                                                                                                                            wrap ${ github-known-hosts } stage/alias/github-known-hosts 0500 --literal-plain BRANCH --inherit-plain MOUNT --literal-plain PATH --literal-plain RECIPIENT --literal-plain RECIPIENT_ --literal-plain SECRETS --literal-plain UUID --literal-plain URL --uuid dc3c992e
                                                                                                                                            wrap ${ github-token } stage/alias/github-token 0500 --literal-plain BRANCH --inherit-plain MOUNT --literal-plain PATH --literal-plain RECIPIENT --literal-plain RECIPIENT_ --literal-plain SECRETS --literal-plain UUID --literal-plain URL --uuid 75e8199d
                                                                                                                                            wrap ${ gnupg } stage/alias/gnupg 0500 --literal-plain BRANCH --literal-plain DOT_GNUPG --inherit-plain MOUNT --literal-plain PATH --literal-plain RECIPIENT --literal-plain RECIPIENT_ --literal-plain SECRETS --literal-plain URL --literal-plain UUID --uuid dcf9b75f
                                                                                                                                            wrap ${ mobile-known-hosts } stage/alias/mobile-known-hosts 0500 --literal-plain BRANCH --inherit-plain MOUNT --literal-plain PATH --literal-plain RECIPIENT --literal-plain RECIPIENT_ --literal-plain SECRETS --literal-plain UUID --literal-plain URL --uuid 2873355b
                                                                                                                                            wrap ${ mobile-identity } stage/alias/mobile-identity 0500 --literal-plain BRANCH --literal-plain DOT_SSH --inherit-plain MOUNT --literal-plain PATH --literal-plain RECIPIENT --literal-plain RECIPIENT_ --literal-plain SECRETS --literal-plain UUID --literal-plain URL --uuid 53e13ba0
                                                                                                                                            git fetch origin ${ config.personal.secrets2.branch } 2>&1
                                                                                                                                            git checkout origin/${ config.personal.secrets2.branch } 2>&1
                                                                                                                                            UUID="$( uuidgen | sha512sum )" || failure c0d47742
                                                                                                                                            BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 4b4d1f65
                                                                                                                                            git checkout -b "$BRANCH" 2>&1
                                                                                                                                        '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/setup" ;
                                                                                                } ;
                                                                                } ;
                                                                            secrets_ =
                                                                                ignore :
                                                                                    _git-repository.implementation
                                                                                        {
                                                                                            resolutions = [ ] ;
                                                                                            setup =
                                                                                                { pid , pkgs , resources , root , sequential , wrap } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "setup" ;
                                                                                                                    runtimeInputs = [ pkgs.git ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            mkdir --parents /mount/stage/ssh
                                                                                                                            cat >> /mount/stage/ssh/config <<EOF
                                                                                                                            Host github.com
                                                                                                                                User git
                                                                                                                                HostName github.com
                                                                                                                                IdentityFile $MOUNT/stage/ssh/identity
                                                                                                                                UserKnownHostsFile $MOUNT/stage/ssh/known-hosts
                                                                                                                                StrictHostKeyChecking yes
                                                                                                                            EOF
                                                                                                                            cat ${ config.personal.temporary.ssh.identity } > /mount/stage/ssh/identity
                                                                                                                            cat ${ config.personal.temporary.ssh.known-hosts } > /mount/stage/ssh/known-hosts
                                                                                                                            chmod 0400 /mount/stage/ssh/config /mount/stage/ssh/identity /mount/stage/ssh/known-hosts
                                                                                                                            chmod 0700 /mount/stage/ssh
                                                                                                                            git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $MOUNT/stage/ssh/config"
                                                                                                                            git remote add origin ${ config.personal.secrets.remote }
                                                                                                                            git fetch origin ${ config.personal.secrets.branch } 2>&1
                                                                                                                            git checkout origin/${ config.personal.secrets.branch } 2>&1
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/setup" ;
                                                                                        } ;
                                                                            studio =
                                                                                {
                                                                                    entry =
                                                                                        ignore :
                                                                                            _git-repository.implementation
                                                                                                {
                                                                                                    resolutions = [ ] ;
                                                                                                    setup =
                                                                                                        { pid , resources , pkgs , root , sequential , wrap } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "setup" ;
                                                                                                                            runtimeInputs =
                                                                                                                                [
                                                                                                                                    pkgs.coreutils
                                                                                                                                    pkgs.git
                                                                                                                                    pkgs.libuuid
                                                                                                                                    root
                                                                                                                                    wrap
                                                                                                                                    ( _failure.implementation "6e3e1011" )
                                                                                                                                    (
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "submodule" ;
                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( _failure.implementation "3410b891" ) ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        # aff0c675
                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                        cd "$toplevel/$name"
                                                                                                                                                        git config foobar.alpha "$toplevel/$name"
                                                                                                                                                        git config alias.mutable-audit "!$MOUNT/stage/alias/submodule/mutable-audit"
                                                                                                                                                        git config alias.mutable-mirror "!$MOUNT/stage/alias/submodule/mutable-mirror"
                                                                                                                                                        git config alias.mutable-snapshot "!$MOUNT/stage/alias/submodule/mutable-snapshot"
                                                                                                                                                        git config alias.mutable-squash "!$MOUNT/stage/alias/submodule/mutable-squash"
                                                                                                                                                        git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                                        git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                                        git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                                        UUID="$( uuidgen | sha512sum )" || failure 48cb787a
                                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 348ef190
                                                                                                                                                        git checkout -b "$BRANCH"
                                                                                                                                                        export GIT_SSH_COMMAND="$MOUNT/stage/ssh/command"
                                                                                                                                                        git push origin HEAD
                                                                                                                                                        cd "$toplevel"
                                                                                                                                                        nix flake update --flake "$toplevel" "$name"
                                                                                                                                                        git config foobar.beta 10aadb44
                                                                                                                                                    '' ;
                                                                                                                                            }
                                                                                                                                        )
                                                                                                                                ] ;
                                                                                                                            text =
                                                                                                                                let
                                                                                                                                    mutable- =
                                                                                                                                        command :
                                                                                                                                            let
                                                                                                                                                application =
                                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                                        {
                                                                                                                                                            name = "mutable-${ command }" ;
                                                                                                                                                            runtimeInputs = [ pkgs.git ( _failure.implementation "f2e01bdb" ) ] ;
                                                                                                                                                            text =
                                                                                                                                                                ''
                                                                                                                                                                    MUTABLE_SNAPSHOT="$( git mutable-snapshot )" || failure 24c41cef
                                                                                                                                                                    "$MUTABLE_SNAPSHOT/stage/alias/root/mutable-${ command }"
                                                                                                                                                                '' ;
                                                                                                                                                        } ;
                                                                                                                                                in "${ application }/bin/mutable-${ command }" ;
                                                                                                                                    mutable-audit =
                                                                                                                                        {
                                                                                                                                            root =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-audit" ;
                                                                                                                                                                runtimeInputs = [ pkgs.git ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        cd "$MOUNT/repository"
                                                                                                                                                                        git fetch origin main
                                                                                                                                                                        git checkout --patch origin/main
                                                                                                                                                                        git submodule foreach "git mutable-audit"
                                                                                                                                                                        if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                        then
                                                                                                                                                                            git commit -a --verbose
                                                                                                                                                                        fi
                                                                                                                                                                        git push origin HEAD
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-audit" ;
                                                                                                                                            submodule =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-audit" ;
                                                                                                                                                                runtimeInputs = [ pkgs.git ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                        cd "$toplevel/$name"
                                                                                                                                                                        git fetch origin main
                                                                                                                                                                        git checkout --patch origin/main
                                                                                                                                                                        if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                        then
                                                                                                                                                                            git commit -a --verbose
                                                                                                                                                                        fi
                                                                                                                                                                        git push origin HEAD
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-audit" ;
                                                                                                                                        } ;
                                                                                                                                    mutable-denurse =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-denurse" ;
                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                SUBMODULE="$1"
                                                                                                                                                                git rm -f "$SUBMODULE"
                                                                                                                                                                rm -rf "$SUBMODULE"
                                                                                                                                                                git config -f .git/config --remove-section "submodule.$SUBMODULE"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-denurse" ;
                                                                                                                                    mutable-mirror =
                                                                                                                                        {
                                                                                                                                            root =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-mirror" ;
                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gawk pkgs.git pkgs.libuuid ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        OLD_BRANCH="$1"
                                                                                                                                                                        export GIT_SSH_COMMAND="$MOUNT/stage/ssh/command"
                                                                                                                                                                        git fetch origin "$OLD_BRANCH"
                                                                                                                                                                        git checkout "origin/$OLD_BRANCH"
                                                                                                                                                                        git submodule deinit -f .
                                                                                                                                                                        git reset --hard

                                                                                                                                                                        if [ -d .git/modules ]
                                                                                                                                                                        then
                                                                                                                                                                            for SUB in .git/modules/*; do
                                                                                                                                                                                NAME="$(basename "$SUB")"
                                                                                                                                                                                rm -rf "$NAME"
                                                                                                                                                                            done
                                                                                                                                                                        fi

                                                                                                                                                                        # SUBS=$( git submodule status | awk '{print $2}') || failure 1d3e1a75
                                                                                                                                                                        # for SUB in $SUBS
                                                                                                                                                                        # do
                                                                                                                                                                        #     rm --recursive --force "$SUB"
                                                                                                                                                                        #
                                                                                                                                                                        # done
                                                                                                                                                                        git clean -fdx
                                                                                                                                                                        git submodule update --init --recursive
                                                                                                                                                                        git submodule foreach "$MOUNT/stage/alias/submodule/mutable-mirror"
                                                                                                                                                                        UUID="$( uuidgen | sha512sum )" || failure b10e1bdf
                                                                                                                                                                        NEW_BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 9dcc9629
                                                                                                                                                                        git checkout -b "$NEW_BRANCH"
                                                                                                                                                                        git push origin HEAD
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                   in "${ application }/bin/mutable-mirror" ;
                                                                                                                                            submodule =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-mirror" ;
                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid pkgs.nix ( _failure.implementation "f2523caa" ) ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                        cd "$toplevel/$name"
                                                                                                                                                                        UUID="$( uuidgen | sha512sum )" || failure 95ae98e7
                                                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure e53dc5f9
                                                                                                                                                                        git checkout -b "$BRANCH"
                                                                                                                                                                        git push origin HEAD
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-mirror" ;
                                                                                                                                        } ;
                                                                                                                                    mutable-mutable = null ;
                                                                                                                                    mutable-nurse =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-nurse" ;
                                                                                                                                                        runtimeInputs = [ ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                USER_NAME="$1"
                                                                                                                                                                REPO_NAME="$2"
                                                                                                                                                                TOKEN=${ resources.production.repository.secrets2.read-only { } }
                                                                                                                                                                gh auth login --with-token < "$TOKEN/stage/github/token.asc"
                                                                                                                                                                gh repo create "$USER_NAME/$REPO_NAME" --public
                                                                                                                                                                gh auth logout
                                                                                                                                                                mkdir --parents "$MOUNT/stage/nursery/$USER_NAME/$REPO_NAME"
                                                                                                                                                                cd "$MOUNT/stage/nursery/$USER_NAME/$REPO_NAME"
                                                                                                                                                                git init
                                                                                                                                                                git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                                                git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                                                git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                                                git checkout -b main
                                                                                                                                                                git remote add origin "git@github.com:$USER_NAME/$REPO_NAME.git"
                                                                                                                                                                git commit -am "" --allow-empty --allow-empty-message
                                                                                                                                                                git push origin HEAD
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                git submodule add "git@github.com:$USER_NAME/$REPO_NAME.git"
                                                                                                                                                                git push origin HEAD
                                                                                                                                                                cd "$MOUNT/repository/$REPO_NAME"
                                                                                                                                                                # spellcheck disable=SC2086
                                                                                                                                                                git config alias.mutable-audit "!$MOUNT/stage/alias/root/mutable-audit"
                                                                                                                                                                # spellcheck disable=SC2086
                                                                                                                                                                git config alias.mutable-mirror "!$MOUNT/stage/alias/root/mutable-mirror"
                                                                                                                                                                # spellcheck disable=SC2086
                                                                                                                                                                git config alias.mutable-snapshot "!$MOUNT/stage/alias/root/mutable-snapshot"
                                                                                                                                                                # spellcheck disable=SC2086
                                                                                                                                                                git config alias.mutable-squash "!$MOUNT/stage/alias/root/mutable-squash"
                                                                                                                                                                git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                                                git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                                                git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-nurse" ;
                                                                                                                                    mutable-promote =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-promote" ;
                                                                                                                                                        runtimeInputs =
                                                                                                                                                            [
                                                                                                                                                                pkgs.coreutils
                                                                                                                                                                (
                                                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                                                        {
                                                                                                                                                                            name = "prompt" ;
                                                                                                                                                                            runtimeInputs = [ ( _failure.implementation "47d294b6" )  ] ;
                                                                                                                                                                            text =
                                                                                                                                                                                ''
                                                                                                                                                                                    PROMPT="$1"
                                                                                                                                                                                    read -p "$PROMPT:  " -r ANSWER
                                                                                                                                                                                    if [[ "y" == "$ANSWER" ]]
                                                                                                                                                                                    then
                                                                                                                                                                                        echo YES
                                                                                                                                                                                    else
                                                                                                                                                                                        failure f028fc7a NO "$PROMPT" "$ANSWER"
                                                                                                                                                                                    fi
                                                                                                                                                                                '' ;
                                                                                                                                                                        }
                                                                                                                                                                )
                                                                                                                                                                sequential
                                                                                                                                                                ( _failure.implementation "171dfff6" )
                                                                                                                                                            ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''

                                                                                                                                                                PARENT_1="$MOUNT"
                                                                                                                                                                STUDIO_1="$PARENT_1/repository"
                                                                                                                                                                BIN_1="$PARENT_1/stage/bin"
                                                                                                                                                                if git -C "$STUDIO_1" mutable-check
                                                                                                                                                                then
                                                                                                                                                                    echo "✅ the first checks passed"
                                                                                                                                                                else
                                                                                                                                                                    failure f97f7465 "❌ the first checks failed"
                                                                                                                                                                fi
                                                                                                                                                                git -C "$STUDIO_1" mutable-build-vm
                                                                                                                                                                prompt "mutable-build-vm 1"
                                                                                                                                                                git -C "$STUDIO_1" mutable-test
                                                                                                                                                                prompt "mutable-test 1"
                                                                                                                                                                SEQUENCE="$( sequential )" || failure ae7e6cd4y
                                                                                                                                                                REPO_2="$( studio "$SEQUENCE" )" || failure c26c59b5
                                                                                                                                                                PARENT_2="$( dirname "$REPO_2" )" || failure aa07751f
                                                                                                                                                                # PARENT_2="$( "$SETUP" "$SEQUENCE" )" || failure 1ba93b40
                                                                                                                                                                STUDIO_2="$PARENT_2/repository"
                                                                                                                                                                BRANCH="$( git -C "$STUDIO_1" rev-parse --abbrev-ref HEAD )" || failure 89dfeef9
                                                                                                                                                                PARENT_2="$( dirname "$STUDIO_2" )" || failure 0db898ea
                                                                                                                                                                BIN_2="$PARENT_2/stage/bin"
                                                                                                                                                                git -C "$STUDIO_2" mutable-mirror "$BRANCH"
                                                                                                                                                                if diff --recursive --exclude .git --exclude .idea "$STUDIO_1" "$STUDIO_2"
                                                                                                                                                                then
                                                                                                                                                                    echo "✅ studio repositories are identical"
                                                                                                                                                                else
                                                                                                                                                                    failure 79090607 "❌ the studio repositories are NOT identical"
                                                                                                                                                                fi
                                                                                                                                                                git -C "$STUDIO_2" mutable-reset
                                                                                                                                                                if diff --recursive --exclude .git --exclude .idea --exclude flake.lock "$STUDIO_1" "$STUDIO_2"
                                                                                                                                                                then
                                                                                                                                                                    echo "✅ studio repositories are identical"
                                                                                                                                                                else
                                                                                                                                                                    failure 79090607 "❌ the studio repositories are NOT identical"
                                                                                                                                                                fi
                                                                                                                                                                if git -C "$STUDIO_2" mutable-check
                                                                                                                                                                then
                                                                                                                                                                    echo "✅ the second checks passed"
                                                                                                                                                                else
                                                                                                                                                                    failure 49034d7a "❌ the second checks failed"
                                                                                                                                                                fi
                                                                                                                                                                if diff "$BIN_1/mutable-build-vm" "$BIN_2/mutable-build-vm"
                                                                                                                                                                then
                                                                                                                                                                    echo "🔄 We are not testing the mutable-build-vm script because it is already effectively tested"
                                                                                                                                                                else
                                                                                                                                                                    echo "⚠️ Since we detected a change in the mutable-build-vm script we have to test it again"
                                                                                                                                                                    git -C "$STUDIO_2" mutable-build-vm
                                                                                                                                                                    prompt "mutable-build-vm 2"
                                                                                                                                                                fi
                                                                                                                                                                if diff "$BIN_1/mutable-test" "$BIN_2/mutable-test"
                                                                                                                                                                then
                                                                                                                                                                    echo "🔄 We are not testing the mutable-test script because it is already effectively tested"
                                                                                                                                                                else
                                                                                                                                                                    echo "⚠️ Since we detected a change in the mutable-test script we have to test it again"
                                                                                                                                                                    git -C "$STUDIO_2" mutable-test
                                                                                                                                                                    prompt "mutable-test 2"
                                                                                                                                                                fi
                                                                                                                                                                if diff "$BIN_1/mutable-switch" "$BIN_2/stage/mutable-switch"
                                                                                                                                                                then
                                                                                                                                                                    echo "🔄 We did not detect a change in the mutable-switch script"
                                                                                                                                                                else
                                                                                                                                                                    echo "⚠️ Since we detected a change in the mutable-switch script, do you approve the changes?"
                                                                                                                                                                    prompt "mutable-switch"
                                                                                                                                                                fi
                                                                                                                                                                if diff "$BIN_1/mutable-promote" "$BIN_2/stage/mutable-promote"
                                                                                                                                                                then
                                                                                                                                                                    echo "🔄 We did not detect a change in the mutable-promote script"
                                                                                                                                                                else
                                                                                                                                                                    echo "⚠️ Since we detected a change in the mutable-promote script, do you approve the changes?"
                                                                                                                                                                    prompt "mutable-promote"
                                                                                                                                                                fi
                                                                                                                                                                git -C "$STUDIO_2" mutable-switch
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-promote" ;
                                                                                                                                    mutable-rebase =
                                                                                                                                        {
                                                                                                                                            root =
                                                                                                                                                let
                                                                                                                                                    application = pkgs.writeShellApplication
                                                                                                                                                        {
                                                                                                                                                            name = "mutable-rebase" ;
                                                                                                                                                            runtimeInputs = [ pkgs.git "$MOUNT/stage" root ] ;
                                                                                                                                                            text =
                                                                                                                                                                ''
                                                                                                                                                                    export INDEX="$INDEX"
                                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                                    git submodule foreach '$MOUNT/stage/alias/submodule/mutable-mirror'
                                                                                                                                                                    cd "$MOUNT/repository"
                                                                                                                                                                    git fetch origin main
                                                                                                                                                                    UUID="$( uuidgen | sha512sum )" || failure aae710e7
                                                                                                                                                                    BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure f41b9d20
                                                                                                                                                                    git checkout -b "$BRANCH" >&2
                                                                                                                                                                    git commit -am "" --allow-empty --allow-empty-message
                                                                                                                                                                    git reset --soft origin/main
                                                                                                                                                                    git commit -a --verbose
                                                                                                                                                                    git push origin HEAD >&2
                                                                                                                                                                    COMMIT="$( git rev-parse HEAD )" || failure d0633308
                                                                                                                                                                    MUTABLE_SNAPSHOT=${ resources.production.repository.studio.snapshot { setup = setup : ''${ setup } "$BRANCH" "$COMMIT"'' ; } }
                                                                                                                                                                    root "$MUTABLE_SNAPSHOT"
                                                                                                                                                                    echo "$MUTABLE_SNAPSHOT"
                                                                                                                                                                '' ;
                                                                                                                                                        } ;
                                                                                                                                                    in "${ application }/bin/mutable-rebase" ;
                                                                                                                                            submodule =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-rebase" ;
                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                        git fetch origin main
                                                                                                                                                                        if ! git diff origin/main --quiet || ! git diff origin/main --quiet --cached
                                                                                                                                                                        then
                                                                                                                                                                            cd "$toplevel/$name"
                                                                                                                                                                            UUID="$( uuidgen | sha512sum )" || failure f192db0b
                                                                                                                                                                            BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure 54d22bae
                                                                                                                                                                            git checkout -b "$BRANCH"
                                                                                                                                                                            git rebase -i origin/main
                                                                                                                                                                            git commit -m "SNAPSHOT REBASE COMMIT" --allow-empty
                                                                                                                                                                            git push -u origin HEAD
                                                                                                                                                                            TOKEN_DIRECTORY=${ resources.production.repository.secrets2.read-only { } }
                                                                                                                                                                            TOKEN="$( cat "$TOKEN_DIRECTORY/stage/github/token.asc" )" || failure 4946b99c
                                                                                                                                                                            export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                                                            cd "$toplevel"
                                                                                                                                                                            nix flake update --flake "$toplevel" "$name"
                                                                                                                                                                        fi
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-rebase" ;
                                                                                                                                        } ;
                                                                                                                                    mutable-reset =
                                                                                                                                        {
                                                                                                                                            root =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-reset" ;
                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( _failure.implementation "e0d03f16" ) ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        # shellcheck disable=SC2016
                                                                                                                                                                        git submodule foreach '$MOUNT/stage/alias/submodule/mutable-reset'
                                                                                                                                                                        git fetch origin main
                                                                                                                                                                        UUID="$( uuidgen | sha512sum )" || failure a731cc03
                                                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure ca9d8217
                                                                                                                                                                        if ! git diff --quiet origin/main || ! git diff --quiet --cached origin/main
                                                                                                                                                                        then
                                                                                                                                                                            git checkout -b "$BRANCH"
                                                                                                                                                                            git fetch origin main
                                                                                                                                                                            git reset --soft origin/main
                                                                                                                                                                            git commit -a --verbose
                                                                                                                                                                            git push origin HEAD
                                                                                                                                                                        fi
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-reset" ;
                                                                                                                                            submodule =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-reset" ;
                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid pkgs.nix ( _failure.implementation "846bd5fd" )] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:? 4252d404 this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "name:? 4a3b510c this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                        cd "$toplevel/$name"
                                                                                                                                                                        git fetch origin main
                                                                                                                                                                        UUID="$( uuidgen )" || failure 0f292839
                                                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 57402bed
                                                                                                                                                                        if ! git diff --quiet origin/main || ! git diff --quiet --cached origin/main
                                                                                                                                                                        then
                                                                                                                                                                            git checkout -b "$BRANCH"
                                                                                                                                                                            git reset --soft origin/main
                                                                                                                                                                            git commit -a --verbose
                                                                                                                                                                            git push origin HEAD
                                                                                                                                                                            cd "$toplevel"
                                                                                                                                                                            nix flake update --flake "$toplevel" "$name"
                                                                                                                                                                            nix flake update --flake "$toplevel" "$name"
                                                                                                                                                                        fi
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-reset" ;
                                                                                                                                        } ;
                                                                                                                                    mutable-snapshot =
                                                                                                                                        {
                                                                                                                                            root =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-snapshot" ;
                                                                                                                                                                runtimeInputs = [ pkgs.git "$MOUNT/stage" ( _failure.implementation "63144217" ) ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        cd "$MOUNT/repository"
                                                                                                                                                                        # shellcheck disable=SC2016
                                                                                                                                                                        git submodule foreach '$MOUNT/stage/alias/submodule/mutable-snapshot' >&2
                                                                                                                                                                        BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure 84ef6d86
                                                                                                                                                                        if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                        then
                                                                                                                                                                            git commit -a --verbose --allow-empty-message >&2
                                                                                                                                                                        fi
                                                                                                                                                                        git push origin HEAD >&2
                                                                                                                                                                        COMMIT="$( git rev-parse HEAD )" || failure 79d3c8d2
                                                                                                                                                                        MUTABLE_SNAPSHOT=${ resources.production.repository.studio.snapshot { setup = setup : ''${ setup } "$BRANCH" "$COMMIT"'' ; } }
                                                                                                                                                                        root "$MUTABLE_SNAPSHOT"
                                                                                                                                                                        echo "$MUTABLE_SNAPSHOT"
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-snapshot" ;
                                                                                                                                            submodule =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-snapshot" ;
                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nix ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                        cd "$toplevel/$name"
                                                                                                                                                                        if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                        then
                                                                                                                                                                            UUID="$( uuidgen | sha512sum )" || failure 23d60eed
                                                                                                                                                                            BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 48e374d5
                                                                                                                                                                            git checkout -b "$BRANCH"
                                                                                                                                                                            git commit -a --verbose --allow-empty-message
                                                                                                                                                                        fi
                                                                                                                                                                        git push origin HEAD 2>&1
                                                                                                                                                                        TOKEN_DIRECTORY=${ resources.production.repository.secrets2.read-only { } }
                                                                                                                                                                        TOKEN="$( cat "$TOKEN_DIRECTORY/stage/github/token.asc" )" || failure 9e9e850d
                                                                                                                                                                        export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                                                        cd "$toplevel"
                                                                                                                                                                        nix flake update --flake "$toplevel" "$name"
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-snapshot" ;
                                                                                                                                        } ;
                                                                                                                                    mutable-squash =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-squash" ;
                                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( _failure.implementation "5b1cf042" ) ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                                : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                                cd "$toplevel/$name"
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure 45239811
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure 972b3054
                                                                                                                                                                git checkout -b "$BRANCH"
                                                                                                                                                                git fetch origin main
                                                                                                                                                                git reset --soft origin/main
                                                                                                                                                                git commit -a --verbose
                                                                                                                                                                git push origin HEAD
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                nix flake update --flake "$toplevel" "$name"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-squash" ;
                                                                                                                                    mutable-studio =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-studio" ;
                                                                                                                                                        runtimeInputs = [ sequential failure ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                SEQUENCE="$( sequential )" || failure af81a475
                                                                                                                                                                STUDIO=${ resources.production.repository.studio.entry { setup = setup : ''${ setup } "$SEQUENCE"'' ; failure = "failure 1f1246a8" ; } }
                                                                                                                                                                BRANCH=$( git rev-parse --abbrev-ref HEAD )" || failure b9c7fdf2
                                                                                                                                                                git -C "$STUDIO/repository" mutable-mirror "$BRANCH"
                                                                                                                                                                echo "$STUDIO/repository
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-studio" ;
                                                                                                                                    ssh =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "ssh" ;
                                                                                                                                                        runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                ssh -F "$MOUNT/stage/ssh/config" "$@"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/ssh" ;
                                                                                                                                    in
                                                                                                                                        ''
                                                                                                                                            git config alias.mutable-audit "!$MOUNT/stage/alias/root/mutable-audit"
                                                                                                                                            git config alias.mutable-build-vm "!$MOUNT/stage/alias/root/mutable-build-vm"
                                                                                                                                            git config alias.mutable-build-vm-with-bootloader "!$MOUNT/stage/alias/root/mutable-build-vm-with-bootloader"
                                                                                                                                            git config alias.mutable-check "!$MOUNT/stage/alias/root/mutable-check"
                                                                                                                                            git config alias.mutable-denurse "!$MOUNT/stage/alias/root/mutable-denurse"
                                                                                                                                            git config alias.mutable-mirror "!$MOUNT/stage/alias/root/mutable-mirror"
                                                                                                                                            git config alias.mutable-nurse "!$MOUNT/stage/alias/root/mutable-nurse"
                                                                                                                                            git config alias.mutable-promote "!$MOUNT/stage/alias/root/mutable-promote"
                                                                                                                                            git config alias.mutable-rebase "!$MOUNT/stage/alias/root/mutable-rebase"
                                                                                                                                            git config alias.mutable-reset "!$MOUNT/stage/alias/root/mutable-reset"
                                                                                                                                            git config alias.mutable-snapshot "!$MOUNT/stage/alias/root/mutable-snapshot"
                                                                                                                                            git config alias.mutable-studio "!$MOUNT/stage/alias/mutable-studio"
                                                                                                                                            git config alias.mutable-switch "!$MOUNT/stage/alias/root/mutable-switch"
                                                                                                                                            git config alias.mutable-test "!$MOUNT/stage/alias/root/mutable-test"
                                                                                                                                            git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                            git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                            git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                            git remote add origin "${ config.personal.repository.private.remote }"
                                                                                                                                            wrap ${ mutable- "build-vm" } stage/alias/root/mutable-build-vm 0500 --literal-plain MUTABLE_SNAPSHOT --literal-plain PATH
                                                                                                                                            wrap ${ mutable- "build-vm-with-bootloader" } stage/alias/root/mutable-build-vm-with-bootloader 0500 --literal-plain MUTABLE_SNAPSHOT --literal-plain PATH
                                                                                                                                            wrap ${ mutable- "check" } stage/alias/root/mutable-check 0500 --literal-plain MUTABLE_SNAPSHOT --literal-plain PATH
                                                                                                                                            wrap ${ mutable-denurse } stage/alias/root/mutable-denurse 0500 --literal-plain PATH --literal-plain SUBMODULE --uuid 2039d15a
                                                                                                                                            wrap ${ mutable-mirror.root } stage/alias/root/mutable-mirror 0500 --inherit-plain MOUNT --literal-plain NEW_BRANCH --literal-plain OLD_BRANCH --literal-plain PATH --literal-plain UUID --literal-plain SUB --literal-plain SUBS --literal-plain NAME --uuid 00a02114
                                                                                                                                            wrap ${ mutable-mirror.submodule } stage/alias/submodule/mutable-mirror 0500 --literal-plain BRANCH --literal-plain name --literal-plain PATH --literal-plain toplevel --literal-plain UUID --uuid c36b6d07
                                                                                                                                            wrap ${ mutable-nurse } stage/alias/root/mutable-nurse 0500 --literal-plain 1 --literal-plain 2 --inherit-plain MOUNT --literal-plain REPO_NAME --literal-plain TOKEN --literal-plain USER_NAME
                                                                                                                                            wrap ${ mutable-promote } stage/alias/root/mutable-promote 0500 --literal-plain BIN_1 --literal-plain BIN_2 --literal-plain BRANCH --inherit-plain MOUNT --literal-plain PARENT_1 --literal-plain PARENT_2 --literal-plain PATH --literal-plain SEQUENCE --inherit-plain SETUP --literal-plain STUDIO_1 --literal-plain STUDIO_2 --literal-plain REPO_2 --uuid 3f5bfc02
                                                                                                                                            wrap ${ mutable-rebase.root } stage/alias/root/mutable-rebase 0500 --literal-plain BRANCH --literal-plain COMMIT --set-plain INDEX "$INDEX" --inherit-plain MOUNT --literal-plain MUTABLE_SNAPSHOT --literal-plain PATH --literal-plain UUID --uuid e31d4139
                                                                                                                                            wrap ${ mutable-rebase.submodule } stage/alias/submodule/mutable-rebase 0500 --literal-plain BRANCH --literal-plain name --literal-plain PATH --literal-plain TOKEN --literal-plain TOKEN_DIRECTORY --literal-plain toplevel --literal-plain UUID --uuid f5b5a1c7
                                                                                                                                            wrap ${ mutable-reset.root } stage/alias/root/mutable-reset 0500 --literal-plain BRANCH --inherit-plain MOUNT --literal-plain PATH --literal-plain UUID --uuid 5b1e2753
                                                                                                                                            wrap ${ mutable-reset.submodule } stage/alias/submodule/mutable-reset 0500 --literal-plain BRANCH --literal-plain name --literal-plain PATH --literal-plain toplevel --literal-plain UUID --uuid f01ebe4a
                                                                                                                                            wrap ${ mutable-snapshot.root } stage/alias/root/mutable-snapshot 0500 --literal-plain BRANCH --literal-plain COMMIT --inherit-plain MOUNT --literal-plain MUTABLE_SNAPSHOT --literal-plain PATH
                                                                                                                                            wrap ${ mutable-snapshot.submodule } stage/alias/submodule/mutable-snapshot 0500 --literal-plain BRANCH --literal-plain name --literal-plain PATH --literal-plain TOKEN --literal-plain TOKEN_DIRECTORY --literal-plain toplevel --literal-plain UUID --uuid 3eee33c7
                                                                                                                                            wrap ${ mutable-squash } stage/alias/submodule/mutable-squash 0500 --literal-plain BRANCH --literal-plain name --inherit-plain MOUNT --literal-plain name --literal-plain PATH --literal-plain toplevel --literal-plain UUID --uuid 983f33f0
                                                                                                                                            wrap ${ mutable- "switch" } stage/alias/root/mutable-switch 0500 --literal-plain MUTABLE_SNAPSHOT --literal-plain PATH
                                                                                                                                            wrap ${ mutable- "test" } stage/alias/root/mutable-test 0500 --literal-plain MUTABLE_SNAPSHOT --literal-plain PATH
                                                                                                                                            wrap ${ ssh } stage/ssh/command 0500 --literal-plain "@" --inherit-plain MOUNT --literal-plain PATH
                                                                                                                                            DOT_SSH=${ resources.production.dot-ssh { } }
                                                                                                                                            root "$DOT_SSH"
                                                                                                                                            wrap "$DOT_SSH/config" stage/ssh/config 0400
                                                                                                                                            "$MOUNT/stage/alias/root/mutable-mirror" main 2>&1
                                                                                                                                            echo DIFF 10
                                                                                                                                            git diff origin/main 2>&1
                                                                                                                                            echo DIFF 11
                                                                                                                                            git diff 2>&1
                                                                                                                                            git submodule foreach 'submodule' 2>&1
                                                                                                                                            git add flake.lock
                                                                                                                                            git commit -m "" --allow-empty --allow-empty-message >&1
                                                                                                                                            git push origin HEAD 2>&1
                                                                                                                                            echo DIFF 20
                                                                                                                                            git diff origin/main 2>&1
                                                                                                                                            echo DIFF 21
                                                                                                                                            git diff 2>&1
                                                                                                                                            wrap ${ root }/bin/root stage/bin/root 0500 --literal-plain DIRECTORY --inherit-plain INDEX --literal-plain PATH --literal-plain TARGET
                                                                                                                                            echo DIFF 30
                                                                                                                                            git diff origin/main 2>&1
                                                                                                                                            echo DIFF 31
                                                                                                                                            git diff 2>&1
                                                                                                                                        '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/setup" ;
                                                                                                } ;
                                                                                    secrets =
                                                                                        ignore :
                                                                                            _git-repository.implementation
                                                                                                {
                                                                                                    resolutions = [ ] ;
                                                                                                    setup =
                                                                                                        { pid , pkgs , resources , root , sequential , wrap } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "setup" ;
                                                                                                                            runtimeInputs = [ pkgs.git ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    git remote add origin https://github.com/${ config.personal.secrets.organization }/${ config.personal.secrets.repository }
                                                                                                                                    git fetch origin ${ config.personal.secrets.branch } 2>&1
                                                                                                                                    git checkout origin/${ config.personal.secrets.branch } 2>&1
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/setup" ;
                                                                                                } ;
                                                                                    snapshot =
                                                                                        ignore :
                                                                                            _git-repository.implementation
                                                                                                {
                                                                                                    resolutions = [ ] ;
                                                                                                    setup =
                                                                                                        { pid , pkgs , resources , root , sequential , wrap } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "setup" ;
                                                                                                                            runtimeInputs =
                                                                                                                                [
                                                                                                                                    pkgs.coreutils
                                                                                                                                    pkgs.git
                                                                                                                                    pkgs.libuuid
                                                                                                                                    root
                                                                                                                                    wrap
                                                                                                                                    (
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "submodule" ;
                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.coreutils pkgs.git pkgs.libuuid pkgs.nix ( _failure.implementation "a24ad586" ) ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?this script must be run via git submodule foreach which will export toplevel" "}" ] }"
                                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "name:?this script must be run via git submodule foreach which will export name" "}" ] }"
                                                                                                                                                        git config alias.mutable-switch "!/$toplevel/stage/alias/submodule/mutable-switch"
                                                                                                                                                        git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                                        git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                                        git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                                        UUID="$( uuidgen | sha512sum )" || failure 03931c59
                                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 44ee7b13
                                                                                                                                                        git checkout -b "$BRANCH"
                                                                                                                                                        git push origin HEAD
                                                                                                                                                    '' ;
                                                                                                                                            }
                                                                                                                                    )
                                                                                                                                ] ;
                                                                                                                            text =
                                                                                                                                let
                                                                                                                                    mutable-build-vm =
                                                                                                                                        vm :
                                                                                                                                            let
                                                                                                                                                application =
                                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                                        {
                                                                                                                                                            name = "mutable-build-vm" ;
                                                                                                                                                            runtimeInputs = [ pkgs.nixos-rebuild ] ;
                                                                                                                                                            text =
                                                                                                                                                                ''
                                                                                                                                                                    cd "$MOUNT/stage/artifacts/${ vm }"
                                                                                                                                                                    nixos-rebuild ${ vm } --flake "$MOUNT/repository#user"
                                                                                                                                                                    export SHARED_DIR="$MOUNT/stage/artifacts/${ vm }/shared"
                                                                                                                                                                    echo "$MOUNT/stage/artifacts/${ vm }/result/bin/run-nixos-vm"
                                                                                                                                                                    "$MOUNT/stage/artifacts/${ vm }/result/bin/run-nixos-vm"
                                                                                                                                                                '' ;
                                                                                                                                                        } ;
                                                                                                                                                in "${ application }/bin/mutable-build-vm" ;
                                                                                                                                    mutable-check =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-check" ;
                                                                                                                                                        runtimeInputs = [ pkgs.nix ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                echo nix flake check "$MOUNT/repository" >&2
                                                                                                                                                                nix flake check "$MOUNT/repository"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-check" ;
                                                                                                                                    mutable-switch =
                                                                                                                                        {
                                                                                                                                            root =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-switch" ;
                                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" ) ] ;
                                                                                                                                                                text =
                                                                                                                                                                    ''
                                                                                                                                                                        cd "$MOUNT/stage/artifacts/switch"
                                                                                                                                                                        git -C "$MOUNT/repository" submodule foreach "$MOUNT/stage/alias/submodule/mutable-switch"
                                                                                                                                                                        UUID="$( uuidgen | sha512sum )" || failure 0f1227b6
                                                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure d5910859
                                                                                                                                                                        git -C "$MOUNT/repository" checkout -b "$BRANCH"
                                                                                                                                                                        git -C "$MOUNT/repository" commit -am "" --allow-empty --allow-empty-message
                                                                                                                                                                        git -C "$MOUNT/repository" fetch origin main
                                                                                                                                                                        git -C "$MOUNT/repository" reset --soft origin/main
                                                                                                                                                                        git -C "$MOUNT/repository" commit -a --verbose
                                                                                                                                                                        git -C "$MOUNT/repository" push origin HEAD
                                                                                                                                                                        git -C "$MOUNT/repository" checkout main
                                                                                                                                                                        git -C "$MOUNT/repository" rebase "$BRANCH"
                                                                                                                                                                        git -C "$MOUNT/repository" push origin main
                                                                                                                                                                        echo nixos-rebuild switch --flake "$MOUNT/repository#user" --show-trace
                                                                                                                                                                        nixos-rebuild switch --flake "$MOUNT/repository#user" --show-trace
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                        in "${ application }/bin/mutable-switch" ;
                                                                                                                                            submodule =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "mutable-switch" ;
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
                                                                                                                                                                            TOKEN=${ resources.production.repository.secrets2.read-only { } }
                                                                                                                                                                            gh auth login --with-token < "$TOKEN/stage/github/token.asc"
                                                                                                                                                                            if ! gh label list --json name --jq '.[].name' | grep -qx snapshot
                                                                                                                                                                            then
                                                                                                                                                                                gh label create snapshot --color "#333333" --description "Scripted Snapshot PR"
                                                                                                                                                                            fi
                                                                                                                                                                            gh pr create --base main --head "$BRANCH" --label "snapshot"
                                                                                                                                                                            URL="$( gh pr view --json url --jq .url )" || failure 31ccb1f3
                                                                                                                                                                            gh pr merge "$URL" --rebase
                                                                                                                                                                            gh auth logout
                                                                                                                                                                            NAME="$( basename "$name" )" || failure 368e7b07
                                                                                                                                                                            TOKEN_DIRECTORY=${ resources.production.repository.secrets2.read-only { } }
                                                                                                                                                                            TOKEN="$( cat "$TOKEN_DIRECTORY/stage/github/token.asc" )" || failure 6ad73063
                                                                                                                                                                            export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                                                            PARENT="$( dirname "$toplevel" )" || failure e5630d4d
                                                                                                                                                                            export GIT_SSH_COMMAND="$PARENT/stage/ssh/command"
                                                                                                                                                                            cd "$toplevel"
                                                                                                                                                                            nix flake update --flake "$toplevel" "$NAME"
                                                                                                                                                                        fi
                                                                                                                                                                    '' ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/mutable-switch" ;
                                                                                                                                        } ;
                                                                                                                                    mutable-test =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-test" ;
                                                                                                                                                        runtimeInputs = [ ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" ) ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                cd "$MOUNT/stage/artifacts/test"
                                                                                                                                                                echo "$MOUNT/repository/result/bin/run-nixos-vm"
                                                                                                                                                                nixos-rebuild test --flake "$MOUNT/repository#user"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-test" ;
                                                                                                                                    ssh =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "ssh" ;
                                                                                                                                                        runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                ssh -F "$MOUNT/stage/ssh/config" "$@"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/ssh" ;
                                                                                                                                    in
                                                                                                                                        ''
                                                                                                                                            OLD_BRANCH="$1"
                                                                                                                                            COMMIT="$2"
                                                                                                                                            git config alias.mutable-build-vm "!$MOUNT/stage/alias/root/mutable-build-vm"
                                                                                                                                            git config alias.mutable-build-vm-with-bootloader "!$MOUNT/stage/alias/root/mutable-build-vm-with-bootloader"
                                                                                                                                            git config alias.mutable-check "!$MOUNT/stage/alias/root/mutable-check"
                                                                                                                                            git config alias.mutable-switch "!$MOUNT/stage/alias/root/mutable-switch"
                                                                                                                                            git config alias.mutable-test "!$MOUNT/stage/alias/root/mutable-test"
                                                                                                                                            git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                            git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                            git config core.sshCommand "$MOUNT/stage/ssh/command"
                                                                                                                                            wrap ${ mutable-build-vm "build-vm" } stage/alias/root/mutable-build-vm 0500 --inherit-plain MOUNT --literal-plain PATH
                                                                                                                                            wrap ${ mutable-build-vm "build-vm-with-bootloader" } stage/alias/root/mutable-build-vm-with-bootloader 0500 --inherit-plain MOUNT --literal-plain PATH
                                                                                                                                            wrap ${ mutable-check } stage/alias/root/mutable-check 0500 --inherit-plain MOUNT --literal-plain PATH
                                                                                                                                            wrap ${ mutable-switch.root } stage/alias/root/mutable-switch 0500 --literal-plain BRANCH --inherit-plain MOUNT --literal-plain PATH --literal-plain UUID --uuid 816e68ec
                                                                                                                                            wrap ${ mutable-switch.submodule } stage/alias/submodule/mutable-switch 0500 --literal-plain BRANCH --literal-plain name --literal-plain NAME --literal-plain PARENT --literal-plain PATH --literal-plain TOKEN --literal-plain TOKEN_DIRECTORY --literal-plain toplevel --literal-plain URL
                                                                                                                                            wrap ${ mutable-test } stage/alias/root/mutable-test 0500 --inherit-plain MOUNT --literal-plain PATH
                                                                                                                                            wrap ${ ssh } stage/ssh/command 0500 --literal-plain "@" --inherit-plain MOUNT --literal-plain PATH
                                                                                                                                            DOT_SSH=${ resources.production.dot-ssh { } }
                                                                                                                                            root "$DOT_SSH"
                                                                                                                                            wrap "$DOT_SSH/config" stage/ssh/config 0400
                                                                                                                                            git remote add origin "${ config.personal.repository.private.remote }"
                                                                                                                                            git fetch origin "$OLD_BRANCH" 2>&1
                                                                                                                                            git checkout "$COMMIT" 2>&1
                                                                                                                                            mkdir --parents /mount/stage/artifacts/build-vm/shared
                                                                                                                                            mkdir --parents /mount/stage/artifacts/build-vm-with-bootloader/shared
                                                                                                                                            mkdir --parents /mount/stage/artifacts/test
                                                                                                                                            mkdir --parents /mount/stage/artifacts/switch
                                                                                                                                            export GIT_SSH_COMMAND=/mount/stage/ssh/command
                                                                                                                                            git submodule sync 2>&1
                                                                                                                                            git submodule update --init --recursive 2>&1
                                                                                                                                            git submodule foreach "submodule" 2>&1
                                                                                                                                        '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/setup" ;
                                                                                                } ;
                                                                                } ;
                                                                        } ;
                                                            secret =
                                                                let
                                                                    secret =
                                                                        name : ignore :
                                                                            {
                                                                                init =
                                                                                    { pid , pkgs , resources , root , sequential , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.age pkgs.coreutils ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                SECRETS=${ resources.production.secrets { } }
                                                                                                                age --decrypt "$SECRETS/${ name }" --identity ${ config.personal.agenix } --output /mount/plaintext
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
                                                                        } ;
                                                            secrets =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { pid , pkgs , resources , root , sequential , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        mkdir /mount/repository
                                                                                                        cd /mount/repository
                                                                                                        git init
                                                                                                        git remote add https https://github.com/${ config.personal.secrets2.organization }/${ config.personal.secrets2.repository }
                                                                                                        git remote add ssh github.com:${ config.personal.secrets2.organization }/${ config.personal.secrets2.repository }
                                                                                                        git fetch https main
                                                                                                        git checkout https/main
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ ".git" "dot-gnupg" "dot-ssh" "github" ] ;
                                                                    } ;
                                                            temporary =
                                                                ignore :
                                                                    {
                                                                        init = { pid , pkgs , resources , root , sequential , wrap } : "" ;
                                                                        transient = true ;
                                                                    } ;
                                                            volume =
                                                                let
                                                                    volume =
                                                                        branch : ignore :
                                                                            {
                                                                                init =
                                                                                    { pid , resources , pkgs , root , sequential , wrap } :
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
                                                                                                                        DOT_GNUPG=${ resources.production.dot-gnupg { failure = ___failure "9eea13ac" ; } }
                                                                                                                        export GNUPGHOME="$DOT_GNUPG/dot-gnupg"
                                                                                                                        SECRETS=${ resources.production.repository.secrets2.read-only { failure = ___failure "5fb67974" ; } }
                                                                                                                        gh auth login --with-token < "$SECRETS/stage/github/token.asc"
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
                                                                                                                                wrap ${ gitattributes } .gitattributes 0400
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
                                                                                                                            wrap ${ gitattributes } .gitattributes 0400
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
                                                                                                                    git commit -m "" --allow-empty --allow-empty-message 2>&1
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

                                                                                        _myscript_completions() {
                                                                                            local cur dir
                                                                                            cur="${ builtins.concatStringsSep "" [ "$" "{" "COMP_WORDS[COMP_CWORD]" "}" ] }"
                                                                                            dir="$(pwd)" || "${ __failure }/bin/failure 5e9268bf"
                                                                                            if [[ "$dir" == "/home/${ config.personal.name }/pad" ]]
                                                                                            then
                                                                                                if [[ $COMP_CWORD -eq 1 ]]
                                                                                                then
                                                                                                    NEXT="$( compgen -W "production.age production.application.chromium production.application.mutable production.repository.pass production.repository.secrets.read-only production.repository.secrets.read-write production.dot-gnupg production.dot-ssh archaic" -- "$cur" )" || failure 6bb37017
                                                                                                    COMPREPLY=( $NEXT )
                                                                                                fi
                                                                                            else
                                                                                                COMPREPLY=()
                                                                                            fi
                                                                                        }
                                                                                        complete -F _myscript_completions resource
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
                                                                                                                                                                runtimeInputs = [ pkgs.findutils ( ___failure "973bcfd8" ) ] ;
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
                                                                        resource-logger =
                                                                            {
                                                                                after = [ "network.target" "redis.service" ] ;
                                                                                description =
                                                                                    ''
                                                                                        Logs JSON payloads from Redis resource channel into a YAML list
                                                                                    '' ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            _resource-logger.implementation
                                                                                                {
                                                                                                    log-directory = "/home/${ config.personal.name }/resources/log" ;
                                                                                                } ;
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ] ;
                                                                            } ;
                                                                        resource-releaser =
                                                                            {
                                                                                after = [ "network.target" "redis.service" ] ;
                                                                                enable = true ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            _resource-releaser.implementation
                                                                                                {
                                                                                                    channel = config.personal.channel ;
                                                                                                    gc-roots-directory = "/home/${ config.personal.name }/.gc-roots" ;
                                                                                                    locks-directory = "/home/${ config.personal.name }/resources/locks" ;
                                                                                                    mounts-directory = "/home/${ config.personal.name }/resources/mounts" ;
                                                                                                    quarantine-directory = "/home/${ config.personal.name }/resources/quarantine" ;
                                                                                                } ;
                                                                                            User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ] ;
                                                                            } ;
                                                                        resource-resolver =
                                                                            {
                                                                                after = [ "network.target" "redis.service" ] ;
                                                                                description =
                                                                                    ''
                                                                                        Resolves either invalid-init or invalid-release.  It creates a quarantine directory with a yaml log file and one or more resolution programs.
                                                                                    '' ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            _resource-resolver.implementation
                                                                                                {
                                                                                                    quarantine-directory = "/home/${ config.personal.name }/resources/quarantine" ;
                                                                                                } ;
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ] ;
                                                                            } ;
                                                                    } ;
                                                                timers =
                                                                    {
                                                                        recycle-github-identity =
                                                                            {
                                                                                timerConfig.OnCalendar = "daily" ;
                                                                            } ;
                                                                        recycle-mobile-identity =
                                                                            {
                                                                                timerConfig.OnCalendar = "daily" ;
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
                                                                                            STUDIO=${ resources__.production.repository.studio.entry { setup = setup : ''${ setup } "$HAS_ARGUMENTS" "$ARGUMENTS"'' ; } }
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
                                                                                            FOOBAR=${ resources__.foobar.foobar { setup = setup : ''${ setup } "$@"'' ; failure = "failure 175470c8" ; } }
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
                                                                                                        ( resources__.production.autocomplete.pass { failure = ___failure "28ecf633" ; } )
                                                                                                        ( resources__.production.autocomplete.silly { failure = ___failure "f15371a4" ; } )
                                                                                                    ] ;
                                                                                                bin =
                                                                                                    [
                                                                                                        ( resources__.production.bin.chromium { failure = ___failure "1954d2c7" ; } )
                                                                                                        ( resources__.production.bin.gpg { failure = ___failure "7386330c" ; } )
                                                                                                        ( resources__.production.bin.idea-community { failure = ___failure "7eba8454" ; } )
                                                                                                        ( resources__.production.bin.pass { failure = ___failure "c055f2a0" ; } )
                                                                                                        ( resources__.production.bin.ssh { failure = ___failure "c055f2a0" ; } )
                                                                                                    ] ;
                                                                                                man =
                                                                                                    [
                                                                                                        ( resources__.production.man.chromium { failure = ___failure "967ea0e1" ; } )
                                                                                                        ( resources__.production.man.gpg { failure = ___failure "aa1f5c38" ; } )
                                                                                                        ( resources__.production.man.idea-community { failure = ___failure "f5992d47" ; } )
                                                                                                        ( resources__.production.man.pass { failure = ___failure "4a4c361e" ; } )
                                                                                                        ( resources__.production.man.ssh { failure = ___failure "6d01304d" ; } )
                                                                                                    ] ;
                                                                                            } ;
                                                                                    beta =
                                                                                        ignore :
                                                                                            {
                                                                                                autocomplete =
                                                                                                    [
                                                                                                        ( resources__.production.autocomplete.pass { failure = ___failure "28ecf633" ; } )
                                                                                                        ( resources__.production.autocomplete.silly { failure = ___failure "f15371a4" ; } )
                                                                                                    ] ;
                                                                                                bin =
                                                                                                    [
                                                                                                        ( resources__.production.bin.chromium { failure = ___failure "1954d2c7" ; } )
                                                                                                        ( resources__.production.bin.gpg { failure = ___failure "7386330c" ; } )
                                                                                                        ( resources__.production.bin.idea-community { failure = ___failure "7eba8454" ; } )
                                                                                                        ( resources__.production.bin.pass { failure = ___failure "c055f2a0" ; } )
                                                                                                        ( resources__.production.bin.ssh { failure = ___failure "c055f2a0" ; } )
                                                                                                    ] ;
                                                                                                man =
                                                                                                    [
                                                                                                        ( resources__.production.man.chromium { failure = ___failure "967ea0e1" ; } )
                                                                                                        ( resources__.production.man.gpg { failure = ___failure "aa1f5c38" ; } )
                                                                                                        ( resources__.production.man.idea-community { failure = ___failure "f5992d47" ; } )
                                                                                                        ( resources__.production.man.pass { failure = ___failure "4a4c361e" ; } )
                                                                                                        ( resources__.production.man.ssh { failure = ___failure "6d01304d" ; } )
                                                                                                    ] ;
                                                                                            } ;
                                                                                    testing =
                                                                                        {
                                                                                            resource = { } ;
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
                                                                        fixture =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                repository = lib.mkOption { default = "fixture" ; type = lib.types.str ; } ;
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
                                                                secrets2 =
                                                                    {
                                                                        email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                        name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                        organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                        repository = lib.mkOption { default = "9ebf9ebc" ; type = lib.types.str ; } ;
                                                                        branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                    } ;
                                                                secrets =
                                                                    {
                                                                        remote = lib.mkOption { default = "git@github.com:AFnRFCb7/12e5389b-8894-4de5-9cd2-7dab0678d22b" ; type = lib.types.str ; } ;
                                                                        organization = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                        repository = lib.mkOption { default = "12e5389b-8894-4de5-9cd2-7dab0678d22b" ; type = lib.types.str ; } ;
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
                                    acme =
                                        pkgs.stdenv.mkDerivation
                                            {
                                                installPhase = ''execute-install-phase "$out"'' ;
                                                name = "check" ;
                                                nativeBuildInputs =
                                                    [
                                                        (
                                                            pkgs.writeShellApplication
                                                                {
                                                                    name = "execute-install-phase" ;
                                                                    runtimeInputs =
                                                                        [
                                                                            pkgs.bash
                                                                            pkgs.coreutils
                                                                        ] ;
                                                                    text =
                                                                        ''
                                                                            OUT="$1"
                                                                            mkdir --parents "$OUT"
                                                                        '' ;
                                                                }
                                                        )
                                                    ] ;
                                                src = ./. ;
                                            } ;
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
                                    git-repository =
                                        _git-repository.check
                                            {
                                                expected = "/nix/store/4xwf67qp7hzza1vb0vj5cv3xr2jhpa5n-init/bin/init" ;
                                                failure = _failure.implementation "8a8f3b60" ;
                                                pkgs = pkgs ;
                                            } ;
                                    private-reporter = _private-reporter.check { expected = "/nix/store/jpbp14585f0z5bl3s8vg60j0rxiqhwsq-private-reporter/bin/private-reporter" ; } ;
                                    resource-happy =
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
                                                        store-garbage-collection-root = "/build/gc-roots" ;
                                                    } ;
                                            in
                                                factory.check
                                                    {
                                                        arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
                                                        diffutils = pkgs.diffutils ;
                                                        expected-index = "0000000311691948" ;
                                                        expected-originator-pid = 45 ;
                                                        expected-provenance = "new" ;
                                                        expected-standard-error = "" ;
                                                        expected-standard-output =
                                                            ''
                                                                 _________________________________________
                                                                / f83f1836809a4c2148e7c4d4b3dc543d2d36808 \
                                                                | 5d786a49366fd8b36cd730d93502da258b69d16 |
                                                                | 94f2a437efa86666cf44a72e2c574a452044062 |
                                                                \ 1e8dc2a9fc8                             /
                                                                 -----------------------------------------
                                                                        \   ^__^
                                                                         \  (oo)\_______
                                                                            (__)\       )\/\
                                                                                ||----w |
                                                                                ||     ||
                                                                resources = 5a4c4b30e8f8199aa21f472a633c5eb45e7b530f6d327babb477f67a1e7b2e6c42686f75ebf54ee29b4c48c1ceda5a84a1d192b8953a8362ebce397788934df7
                                                                mount = /build/resources/mounts/0000000311691948
                                                            '' ;
                                                        expected-status = 0 ;
                                                        expected-targets =
                                                                [
                                                                    "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4"
                                                                ] ;
                                                        expected-transient = -1 ;
                                                        expected-type = "valid" ;
                                                        init =
                                                            { pid , pkgs , resources , root , sequential , wrap } :
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "init" ;
                                                                                runtimeInputs = [ pkgs.coreutils pkgs.libuuid pkgs.cowsay root ] ;
                                                                                text =
                                                                                    ''
                                                                                        cowsay f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8
                                                                                        ${ resources.d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 }
                                                                                        echo "mount = $MOUNT"
                                                                                        echo 67db2c662c09536dece7b873915f72c7746539be90c282d1dfd0a00c08bed5070bc9fbe2bb5289bcf10563f9e5421edc5ff3323f87a5bed8a525ff96a13be13d > /mount/e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4
                                                                                        echo 99757ea5f69970ca7258207b42b7e76e09821b228db8906609699f0ed08191f606d6bdde022f8f158b9ecb7b4d70fdc8f520728867f5af35d1e189955d990a64 > /scratch/a127c8975e5203fd4d7ca6f7996aa4497b02fe90236d6aa830ca3add382084b24a3aeefb553874086c904196751b4e9fe17cfa51817e5ca441ef196738f698b5
                                                                                        root ${ resources.d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 }
                                                                                        root ${ pkgs.cowsay }
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ application }/bin/init" ;
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
                                                                "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4"
                                                            ] ;
                                                        transient = false ;
                                                  } ;
                                    resource-sad =
                                       let
                                           factory =
                                               _resource
                                                   {
                                                       channel = "7410b4a734c6e9ffad193874e22750a93798cbedf60c356b56d4ead212851f3b71f091197f2c4835e99be38af552d7d6818786e09ccaae2380c062c24d3d248a" ;
                                                       resources-directory = "/build/resources" ;
                                                       resources =
                                                           {
                                                               fd8e39c7a8bb3055daa71667bb0f21120642956a6ea043d0fb28c48cddba6ed8acac09c4e130da9a5e638ea8553b6fa2f45bcdef92fe62c40b70d257cc19a379 =
                                                                   let
                                                                       application =
                                                                           pkgs.writeShellApplication
                                                                               {
                                                                                   name = "5552fc1d63b863ab116115819c2f0f2f2fb7e47fc59fd4ef3e99651b982f54b050afa38207f9d74d18a7f6e167debc1c9aad4962b22340091c45878cc1abd75c" ;
                                                                                   runtimeInputs = [ pkgs.coreutils ] ;
                                                                                   text =
                                                                                       ''
                                                                                           echo resources = 798a6b1ff7e250f4ad9224d0fd80c642bf4f346971e35455213a03a494e1612871572b3e7996c4306edbbdebf766e81a7d2ca86efb75249718477220f45d6fa1
                                                                                       '' ;
                                                                               } ;
                                                                       in "${ application }/bin/5552fc1d63b863ab116115819c2f0f2f2fb7e47fc59fd4ef3e99651b982f54b050afa38207f9d74d18a7f6e167debc1c9aad4962b22340091c45878cc1abd75c" ;
                                                           } ;
                                                       store-garbage-collection-root = "/build/gc-roots" ;
                                                   } ;
                                         in
                                             factory.check
                                                 {
                                                     arguments = [ "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c" "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d" ] ;
                                                     diffutils = pkgs.diffutils ;
                                                     expected-index = "0000000437766789" ;
                                                     expected-originator-pid = 45 ;
                                                     expected-provenance = "new" ;
                                                     expected-standard-error = "ae7afb90a11109a5cb07209ec48fa2d376ca0338c14c9c505f465c7cb658091549ae5344378e229674606ff46fcaf3db24b2d2b0870587d67bcad79b358ec2b9" ;
                                                     expected-standard-output =
                                                           ''
                                                                 _________________________________________
                                                                / cfb1a86984144d2e4c03594b4299585aa6ec2f5 \
                                                                | 03a7b39b1385a5338c9fc314fd87bd904d01188 |
                                                                | b301b3cf641c4158b28852778515eba52ad7e4b |
                                                                \ 148f216d1d5                             /
                                                                 -----------------------------------------
                                                                        \   ^__^
                                                                         \  (oo)\_______
                                                                            (__)\       )\/\
                                                                                ||----w |
                                                                                ||     ||
                                                                resources = 798a6b1ff7e250f4ad9224d0fd80c642bf4f346971e35455213a03a494e1612871572b3e7996c4306edbbdebf766e81a7d2ca86efb75249718477220f45d6fa1
                                                                mount = /build/resources/mounts/0000000437766789
                                                           '' ;
                                                     expected-status = 70 ;
                                                     expected-targets =
                                                         [
                                                             "3e30e86404135fc6036abb77e19e8cf73bb32074c07b3273a45e1262bb308f68d420d3549624ee2a44030ba23147465ed85b2c320d0661b1835627aeec050289"
                                                         ] ;
                                                     expected-transient = -1 ;
                                                     expected-type = "invalid-init" ;
                                                     init =
                                                         { pid , pkgs , resources , root , sequential , wrap } :
                                                             let
                                                                 application =
                                                                     pkgs.writeShellApplication
                                                                         {
                                                                             name = "init" ;
                                                                             runtimeInputs = [ pkgs.coreutils pkgs.cowsay root ] ;
                                                                             text =
                                                                                 ''
                                                                                     cowsay cfb1a86984144d2e4c03594b4299585aa6ec2f503a7b39b1385a5338c9fc314fd87bd904d01188b301b3cf641c4158b28852778515eba52ad7e4b148f216d1d5
                                                                                     ${ resources.fd8e39c7a8bb3055daa71667bb0f21120642956a6ea043d0fb28c48cddba6ed8acac09c4e130da9a5e638ea8553b6fa2f45bcdef92fe62c40b70d257cc19a379 }
                                                                                     echo "mount = $MOUNT"
                                                                                     echo ae7afb90a11109a5cb07209ec48fa2d376ca0338c14c9c505f465c7cb658091549ae5344378e229674606ff46fcaf3db24b2d2b0870587d67bcad79b358ec2b9 >&2
                                                                                     echo 97d4fec983cd3fd46ce371f0cff6f660f066924c8bd57704e2382fb0df84eb7c03e667cfb6837c2c3638dd6b5aea4f4b1c8e4fd8944de89c458313f31afa2d5b > /mount/3e30e86404135fc6036abb77e19e8cf73bb32074c07b3273a45e1262bb308f68d420d3549624ee2a44030ba23147465ed85b2c320d0661b1835627aeec050289
                                                                                     echo 8393b1c1c760a903ea3a17d3c5831b1ed7b16bbb6ff6d9ccb751406e1fbe7c416a39fc440baf1b4a660dd928e1c060c0c05220cae8028ffde038dba033d25046 > /scratch/ea7c5d3879f282c8d3a0a2c85c464d129bc9a034d2fc9287b6588a96d1659c46a04f0e5e23f4bddd67425cee44043e421420eed8ba7cf7d2d3ecb9d8efab9f37
                                                                                     root ${ resources.fd8e39c7a8bb3055daa71667bb0f21120642956a6ea043d0fb28c48cddba6ed8acac09c4e130da9a5e638ea8553b6fa2f45bcdef92fe62c40b70d257cc19a379 }
                                                                                     exit 70
                                                                                 '' ;
                                                                         } ;
                                                                 in "${ application }/bin/init" ;
                                                     resources-directory-fixture =
                                                         resources-directory :
                                                             ''
                                                                 mkdir --parents ${ resources-directory }/sequential
                                                                 echo 437766789 > ${ resources-directory }/sequential/sequential.counter
                                                             '' ;
                                                    seed = "4259572168968d95098b9a5a8572c6ecfabe61a2522103e4c75b1317ea9cf43f96f7a135d144d2184739b6c4bd7fad1fb13a117dabbc9e58f4d4edbc26cf34f5" ;
                                                    standard-input = "5433bd8482be1f2e1c1db4fa9268ed6e7bb02285083decb86a6166eea2df77f7e2d7524541549a3ee73d03ae955d8ec0714a959944962e8fe18f343fe108ff9f" ;
                                                     standard-error =
                                                         ''
                                                            compile-time-arguments:
                                                              path: []
                                                              type: string
                                                              value: f135add3
                                                            run-time-arguments:
                                                              - a05ad0c3
                                                              - ae7afb90a11109a5cb07209ec48fa2d376ca0338c14c9c505f465c7cb658091549ae5344378e229674606ff46fcaf3db24b2d2b0870587d67bcad79b358ec2b9
                                                              - "70"
                                                              - '['
                                                              - '  "ceb405a144a10b8efca63d9d950ce2b92bb2997ab44a9588ca740b3540a9a532a6b959a0d990dd469a63b16eb7600991bb7a1ef2b79d697b43e17134cbccec6c",'
                                                              - '  "cdca67397f32d23a379284468e099b96c5b53d62659faf4d48dfc650bea444d6bc450b7eefee9b273c12672b9008fa6a077b15efb676b35f9912de977f54724d"'
                                                              - ']'
                                                              - '['
                                                              - '  "3e30e86404135fc6036abb77e19e8cf73bb32074c07b3273a45e1262bb308f68d420d3549624ee2a44030ba23147465ed85b2c320d0661b1835627aeec050289"'
                                                              - ']'
                                                         '' ;
                                                     standard-output = "" ;
                                                     status = 64 ;
                                                       targets =
                                                           [
                                                               "20828320279b5890d7dccda8c6572b676c7954280559beb66be87ab7d2aeb060dd65c81053766fda24c36ed1ab5db40af70a420e913e16501c3b965d2d99c7e6"
                                                           ] ;
                                                       transient = false ;
                                                 } ;
                                        resource-logger = _resource-logger.check { expected = "/nix/store/16wiqsx2y97x3dn8xrsj575s14bvipdc-resource-logger/bin/resource-logger" ; } ;
                                        resource-releaser = _resource-releaser.check { expected = "/nix/store/nay3i58fbin3xv49isc5bd2hrnfd5kig-resource-releaser/bin/resource-releaser" ; } ;
                                        resource-reporter = _resource-reporter.check { expected = "/nix/store/nn3aj176h78zd4nbbwbvbkj85dw43lqf-resource-reporter/bin/resource-reporter" ; } ;
                                        resource-resolver = _resource-resolver.check { expected = "/nix/store/mvdxn8ral6206d6cagin17f3sl6l5i1z-resource-resolver/bin/resource-resolver" ; } ;
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
                                        string-happy =
                                            _string.check
                                                {
                                                    coreutils = pkgs.coreutils ;
                                                    mkDerivation = pkgs.stdenv.mkDerivation ;
                                                    success = true ;
                                                    template = { alpha , beta } : "${ alpha } ${ beta }" ;
                                                    value = "ff29641ab04941b11b8226bc92d883fcc9242e8982584489022f28311ef1c5beb7f0c821d81fa84504311c2c638de8438be82bb802e71dfe4dd98698387dacfd f40b6afea2a29f8d86ea7ea1e0ee785badde4ce1ecc22a4d15b98a2329f0bc11bab9ec1b2575ac2f76b124508160ada9ffb4159b6a5191a47ed17c137690a4fa" ;
                                                    values =
                                                        {
                                                            alpha = "ff29641ab04941b11b8226bc92d883fcc9242e8982584489022f28311ef1c5beb7f0c821d81fa84504311c2c638de8438be82bb802e71dfe4dd98698387dacfd" ;
                                                            beta = "f40b6afea2a29f8d86ea7ea1e0ee785badde4ce1ecc22a4d15b98a2329f0bc11bab9ec1b2575ac2f76b124508160ada9ffb4159b6a5191a47ed17c137690a4fa" ;
                                                        } ;
                                                    writeShellApplication = pkgs.writeShellApplication ;
                                                } ;
                                        string-sad =
                                            _string.check
                                                {
                                                    coreutils = pkgs.coreutils ;
                                                    mkDerivation = pkgs.stdenv.mkDerivation ;
                                                    success = false ;
                                                    template = { alpha , beta } : "${ alpha } ${ beta }" ;
                                                    value = false ;
                                                    values =
                                                        {
                                                            alpha = x : "ff29641ab04941b11b8226bc92d883fcc9242e8982584489022f28311ef1c5beb7f0c821d81fa84504311c2c638de8438be82bb802e71dfe4dd98698387dacfd" ;
                                                            beta = "f40b6afea2a29f8d86ea7ea1e0ee785badde4ce1ecc22a4d15b98a2329f0bc11bab9ec1b2575ac2f76b124508160ada9ffb4159b6a5191a47ed17c137690a4fa" ;
                                                        } ;
                                                    writeShellApplication = pkgs.writeShellApplication ;
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
