{
    check =
        ignore :
            {
                init =
                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                        let
                            application =
                                pkgs.writeShellApplication
                                    {
                                        name = "init" ;
                                        runtimeInputs = [ pkgs.coreutils failure ] ;
                                        text =
                                            ''
                                                INIT="$1"
                                                RELEASE="$2"
                                                echo "$INIT" /mount/init
                                                echo "$RELEASE" /mount/release
                                                if "$INIT"
                                                then
                                                    exit 0
                                                else
                                                    failure 14537
                                                fi
                                            '' ;
                                    } ;
                            in "${ application }/bin/init" ;
                release =
                    { failure , pkgs , resources , seed , trace , sequential } :
                        let
                            application =
                                pkgs.writeShellApplication
                                    {
                                        name = "release" ;
                                        runtimeInputs = [ pkgs.coreutils failure ] ;
                                        text =
                                            ''
                                                RELEASE="$( cat /mount/release" )" || failure 14011
                                                if "$RELEASE"
                                                then
                                                    exit 0
                                                else
                                                    failure 29374
                                                fi
                                            '' ;
                                    } ;
                            in "${ application }/bin/release" ;
                    targets = [ "init" "release" ] ;
            } ;
    foobar =
        {
            bin =
                ignore :
                    {
                        init =
                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                                                                    TOKEN=${ resources.production.secret.github.token { failure = 9408 ; } }
                                                                                    echo "TOKEN=$TOKEN/plaintext"
                                                                                    cat "$TOKEN/plaintext"
                                                                                    echo bin
                                                                                '' ;
                                                                        } ;
                                                                in "${ application }/bin/bin" ;
                                                        in
                                                            ''
                                                                echo "$$"
                                                                wrap ${ bin } bin 0500 --literal-plain PATH --literal-plain TOKEN
                                                            '' ;
                                            } ;
                                    in "${ application }/bin/init" ;
                        targets = [ "bin" ] ;
                    } ;
            foobar =
                ignore :
                    {
                        init =
                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                let
                                    application =
                                        pkgs.writeShellApplication
                                            {
                                                name = "init" ;
                                                runtimeInputs = [ pkgs.coreutils failure ] ;
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
                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                        let
                                            application =
                                                pkgs.writeShellApplication
                                                    {
                                                        name = "init" ;
                                                        runtimeInputs = [ failure gc-root ] ;
                                                        text =
                                                            ''
                                                                CONFIG=${ resources.production.repository.pads.home.chromium.data { failure = 9230 ; } }
                                                                root "$CONFIG"
                                                                mkdir --parents /mount/etc
                                                                ln --symbolic "$CONFIG/repository/secret" /mount/etc/config
                                                                mkdir --parents /mount/bin
                                                                DATA=${ resources.production.repository.pads.home.chromium.data { failure = 21221 ; } }
                                                                gc-root "$DATA"
                                                                ln --symbolic "$DATA/repository/secret" /mount/etc/data
                                                                gc-root ${ pkgs.chromium }
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                                                                                DOT_GNUPG=${ resources.production.dot-gnupg { failure = 16736 ; } }
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
                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                             { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                                                                                    if [[ -t 0 ]]
                                                                                                    then
                                                                                                        HAS_STANDARD_INPUT=false
                                                                                                        STANDARD_INPUT=
                                                                                                    else
                                                                                                        HAS_STANDARD_INPUT=true
                                                                                                        STANDARD_INPUT="$( cat )" || failure nc2a57f68
                                                                                                    fi
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.map ( value : "${ value.name }=${ value.string } # ${ builtins.toString value.oid }" ) sorted ) }
                                                                                                    ${ builtins.concatStringsSep "\n" ( builtins.map ( name : ''export ${ name }="${ builtins.concatStringsSep "" [ "$" name ] }"'' ) environment ) }
                                                                                                    if $HAS_STANDARD_INPUT
                                                                                                    then
                                                                                                        # shellcheck disable=SC2216
                                                                                                        echo "$STANDARD_INPUT" | ${ script } "$@"
                                                                                                    else
                                                                                                        ${ script } "$@"
                                                                                                    fi
                                                                                                '' ;
                                                                                } ;
                                                                        in "${ application }/bin/${ name }" ;
                                                                in
                                                                    ''
                                                                        echo 7e1212fd 9c61617b
                                                                        wrap ${ bin } ${ name } 0500 --literal-plain HAS_STANDARD_INPUT --literal-plain PATH ${ builtins.concatStringsSep "" ( builtins.map ( value : " --literal-plain ${ value }" ) ( builtins.attrNames variables ) ) } --literal-plain STANDARD_INPUT --uuid 3d888900
                                                                    '' ;
                                                    } ;
                                            in "${ application }/bin/init" ;
                                release =
                                    { failure , pkgs , resources , seed , trace , sequential } :
                                        let
                                            application =
                                                pkgs.writeShellApplication
                                                    {
                                                        name = "release" ;
                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                        text =
                                                            ''
                                                                echo 7e1212fd e6278bb8
                                                                echo RELEASING ${ name }
                                                            '' ;
                                                    } ;
                                            in "${ application }/bin/release" ;
                                targets = [ name ] ;
                            } ;
                    in
                        {
                            checks =
                                {
                                    false =
                                        {
                                            false =
                                                bin
                                                    {
                                                        environment = [ ] ;
                                                        name = "false-false" ;
                                                        runtimeInputs = pkgs : [ pkgs.coreutils ] ;
                                                        script = ''echo "$CHECK"'' ;
                                                        variables = { CHECK = resources : resources.production.checks.hook { failure = 6405 ; setup = setup : ''${ setup } false false'' ; } ; } ;
                                                    } ;
                                            true =
                                                bin
                                                    {
                                                        environment = [ ] ;
                                                        name = "false-true" ;
                                                        runtimeInputs = pkgs : [ pkgs.coreutils ] ;
                                                        script = ''echo "$CHECK"'' ;
                                                        variables = { CHECK = resources : resources.production.checks.hook { failure = 21403 ; setup = setup : ''${ setup } false true'' ; } ; } ;
                                                    } ;
                                        } ;
                                    true =
                                        {
                                            false =
                                                bin
                                                    {
                                                        environment = [ ] ;
                                                        name = "true-false" ;
                                                        runtimeInputs = pkgs : [ pkgs.coreutils ] ;
                                                        script = ''echo "$CHECK"'' ;
                                                        variables = { CHECK = resources : resources.production.checks.hook { failure = 15585 ; setup = setup : ''${ setup } true false'' ; } ; } ;
                                                    } ;
                                            true =
                                                bin
                                                    {
                                                        environment = [ ] ;
                                                        name = "true-true" ;
                                                        runtimeInputs = pkgs : [ pkgs.coreutils ] ;
                                                        script = ''echo "$CHECK"'' ;
                                                        variables = { CHECK = resources : resources.production.checks.hook { failure = 26489 ; setup = setup : ''${ setup } true true'' ; } ; } ;
                                                    } ;
                                        } ;
                                } ;
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
                                                                    runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nano ] ;
                                                                    text =
                                                                        ''
                                                                            NAME="$1"
                                                                            MESSAGE="$2"
                                                                            ALLOWED=( "dot-gnupg/ownertrust" "dot-gnupg/secret-keys" "dot-ssh/github/known-hosts" "dot-ssh/github/identity" "dot-ssh/mobile/known-hosts" "dot-ssh/mobile/identity" "github/token" )
                                                                            if [[ ! "${ builtins.concatStringsSep "" [ "$" "{" "ALLOWED[*]" "}" ] }" =~ $NAME ]]
                                                                            then
                                                                                failure da86aba0 "NAME=$NAME"
                                                                            fi
                                                                            cat > "$SECRETS/plain/$NAME.asc"
                                                                            export GIT_SSH_COMMAND="${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                            git -C "$SECRETS/cipher" commit -am "$MESSAGE" --allow-empty
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
            checks =
                {
                    hook =
                        ignore :
                            {
                                init =
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                        let
                                            application =
                                                pkgs.writeShellApplication
                                                    {
                                                        name = "init" ;
                                                        runtimeInputs = [ pkgs.findutils failure trace ] ;
                                                        text =
                                                            let
                                                                script =
                                                                    let
                                                                        application =
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "script" ;
                                                                                    runtimeInputs = [ pkgs.coreutils trace ] ;
                                                                                    text =
                                                                                        ''
                                                                                            trace 2710
                                                                                            INIT="$1"
                                                                                            RELEASE="$2"
                                                                                            trace 4702 "INIT=$INIT" "RELEASE=$RELEASE"
                                                                                            if "$INIT"
                                                                                            then
                                                                                                if RESOURCE=${ resources.production.checks.pre-test { failure = 2905 ; setup = setup : ''${ setup } "$INIT" "$RELEASE"'' ; } }
                                                                                                then
                                                                                                    echo "GOOD:  We were able to run the pre-test $RESOURCE"
                                                                                                else
                                                                                                    failure 17957
                                                                                                fi
                                                                                            else

                                                                                                if RESOURCE=${ resources.production.checks.pre-test { failure = 4900 ; setup = setup : ''${ setup } "$INIT" "$RELEASE"'' ; } }
                                                                                                then
                                                                                                    failure 14905 "RESOURCE=$RESOURCE"
                                                                                                else
                                                                                                    echo GOOD:  We errored on the pre-test
                                                                                                fi
                                                                                            fi
                                                                                        '' ;
                                                                                } ;
                                                                        in "${ application }/bin/script" ;
                                                                in
                                                                    ''
                                                                        trace 3310 "=\$*=$*"
                                                                        INIT="$1"
                                                                        RELEASE="$2"
                                                                        trace 14195 "INIT=$INIT" "RELEASE=$RELEASE"
                                                                        mkdir --parents /home/${ config.personal.name }/resources/mounts
                                                                        PRE_COUNT="$( find /home/${ config.personal.name }/resources/mounts -maxdepth 1 | wc --lines )" || failure 23762
                                                                        find /home/${ config.personal.name }/resources/mounts -maxdepth 1 | sort
                                                                        mkdir --parents /home/${ config.personal.name }/resources/quarantine.init
                                                                        find /home/${ config.personal.name }/resources/quarantine.init -name "*.sh" -exec {} \;
                                                                        if ! bash -c "${ script } $INIT $RELEASE"
                                                                        then
                                                                            failure 7057
                                                                        fi
                                                                        if "$INIT"
                                                                        then
                                                                            find /home/${ config.personal.name }/resources/quarantine.init -name "*.sh" -exec failure 16482 {} \;
                                                                        else
                                                                            COUNT="$( find /home/${ config.personal.name }/resources/quarantine.init -name "*.sh" | wc --lines )" || failure 22471
                                                                            if [[ "$COUNT" == 1 ]]
                                                                            then
                                                                                find /home/${ config.personal.name }/resources/quarantine.init -name "*.sh" -exec {} \;
                                                                            else
                                                                                failure 6604 "COUNT=$COUNT"
                                                                            fi
                                                                        fi
                                                                        sleep 10s
                                                                        POST_COUNT="$( find /home/${ config.personal.name }/resources/mounts -maxdepth 1 | wc --lines )" || failure 23762
                                                                        if [[ "$PRE_COUNT" != "$POST_COUNT" ]]
                                                                        then
                                                                            find /home/${ config.personal.name }/resources/mounts -maxdepth 1 | sort
                                                                            failure 5236 "PRE_COUNT=$PRE_COUNT" "POST_COUNT=$POST_COUNT"
                                                                        fi
                                                                    '' ;
                                                    } ;
                                            in "${ application }/bin/init" ;
                            } ;
                    pre-test =
                        ignore :
                            {
                                init =
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                        let
                                            application =
                                                pkgs.writeShellApplication
                                                    {
                                                        name = "init" ;
                                                        runtimeInputs = [ pkgs.coreutils trace ] ;
                                                        text =
                                                            ''
                                                                INIT="$1"
                                                                RELEASE="$2"
                                                                echo "$INIT" > /mount/init
                                                                echo "$RELEASE" > /mount/release
                                                                chmod 0400 /mount/init /mount/release
                                                                if ! "$INIT"
                                                                then
                                                                    failure 12945
                                                                fi
                                                            '' ;
                                                    } ;
                                            in "${ application }/bin/init" ;
                                release =
                                    { failure , pkgs , resources , seed , trace , sequential } :
                                        let
                                            application =
                                                pkgs.writeShellApplication
                                                    {
                                                        name = "release" ;
                                                        runtimeInputs = [ failure ] ;
                                                        text =
                                                            ''
                                                                RELEASE="$( cat /mount/release )" || failure 16006
                                                                if ! "$RELEASE"
                                                                then
                                                                    failure 12945
                                                                fi
                                                            '' ;
                                                    } ;
                                            in "${ application }/bin/init" ;
                                targets = [ "init" "release" ] ;
                            } ;
                } ;
            dot-gnupg =
                ignore :
                    {
                        init =
                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                let
                                    application =
                                        pkgs.writeShellApplication
                                            {
                                                name = "init" ;
                                                runtimeInputs = [ pkgs.coreutils pkgs.gnupg failure ] ;
                                                text =
                                                    ''
                                                        OWNERTRUST=${ resources.production.secret.dot-gnupg.ownertrust { failure = 4010 ; } }
                                                        SECRET_KEYS=${ resources.production.secret.dot-gnupg.secret-keys { failure = 23457 ; } }
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
                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                let
                                    application =
                                        pkgs.writeShellApplication
                                            {
                                                name = "init" ;
                                                runtimeInputs = [ failure gc-root wrap ] ;
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
                                                                GITHUB_KNOWN_HOSTS=${ resources.production.secret.dot-ssh.github.known-hosts { failure = 1052 ; } }
                                                                export GITHUB_KNOWN_HOSTS
                                                                GITHUB_IDENTITY=${ resources.production.secret.dot-ssh.github.identity { failure = 5152 ; } }
                                                                export GITHUB_IDENTITY
                                                                MOBILE_IP="${ config.personal.mobile.ip }"
                                                                export MOBILE_IP
                                                                MOBILE_PORT=${ builtins.toString config.personal.mobile.port }
                                                                export MOBILE_PORT
                                                                MOBILE_KNOWN_HOSTS=${ resources.production.secret.dot-ssh.mobile.known-hosts { failure = 18157 ; } }
                                                                export MOBILE_KNOWN_HOSTS
                                                                MOBILE_IDENTITY=${ resources.production.secret.dot-ssh.mobile.identity { failure = 25017 ; } }
                                                                export MOBILE_IDENTITY
                                                                gc-root "$GITHUB_KNOWN_HOSTS"
                                                                gc-root "$GITHUB_IDENTITY"
                                                                gc-root "$MOBILE_KNOWN_HOSTS"
                                                                gc-root "$MOBILE_IDENTITY"
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                let
                                                    application =
                                                        pkgs.writeShellApplication
                                                            {
                                                                name = "init" ;
                                                                runtimeInputs = [ pkgs.git pkgs.openssh gc-root ] ;
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
                                                                                gc-root ${ pkgs.openssh }
                                                                                DOT_SSH=${ resources.production.dot-ssh { failure = 19660 ; } }
                                                                                gc-root "$DOT_SSH"
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
                                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                        let
                                                            application =
                                                                pkgs.writeShellApplication
                                                                    {
                                                                        name = "init" ;
                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git gc-root wrap ] ;
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
                                                                                                                                echo 7e1212fd 4189b9b3
                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure f82885fe
                                                                                                                                echo 7e1212fd a6b6f95f
                                                                                                                                cd "$REPOSITORY"
                                                                                                                                echo 7e1212fd 53374213
                                                                                                                                GIT_SSH_COMMAND="$( git config --get core.sshCommand )" || failure 29341
                                                                                                                                echo 7e1212fd 4585117f
                                                                                                                                export GIT_SSH_COMMAND
                                                                                                                                echo 7e1212fd 2381eedf
                                                                                                                                git fetch origin "$SOURCE_BRANCH"
                                                                                                                                echo 7e1212fd 63851310
                                                                                                                                git checkout "origin/$SOURCE_BRANCH"
                                                                                                                                echo 7e1212fd 684db174
                                                                                                                                UUID="$( sequential )" || failure b3329fb1
                                                                                                                                echo 7e1212fd f5c928d1
                                                                                                                                TARGET_BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 0fbafe21
                                                                                                                                echo 7e1212fd af01d36b
                                                                                                                                git checkout -b "$TARGET_BRANCH"
                                                                                                                                echo 7e1212fd f088a05a
                                                                                                                                git submodule deinit -f --all
                                                                                                                                echo 7e1212fd f202b681
                                                                                                                                git submodule update --init --recursive
                                                                                                                                echo 7e1212fd 0c9e9c4f "GIT_SSH_COMMAND=$GIT_SSH_COMMAND"
                                                                                                                                git submodule foreach "git config core.sshCommand \"$GIT_SSH_COMMAND\""
                                                                                                                                echo 7e1212fd a0ca5e44
                                                                                                                                git submodule foreach 'git config user.email "${ config.personal.repository.private.email }"'
                                                                                                                                echo 7e1212fd aedc25f6
                                                                                                                                git submodule foreach 'git config user.name "${ config.personal.repository.private.name }"'
                                                                                                                                echo 7e1212fd 3d263411
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
                                                                                                                                echo 7e1212fd aaca2e34 "INDEX=$INDEX" "REPOSITORY=$REPOSITORY" "BRANCH=$BRANCH"
                                                                                                                                cd "$REPOSITORY"
                                                                                                                                echo 7e1212fd 7cc78d36
                                                                                                                                if [[ -n "$BRANCH" ]]
                                                                                                                                then
                                                                                                                                    echo 7e1212fd e0464ef9 "BRANCH=$BRANCH"
                                                                                                                                    git mutable-mirror "$BRANCH"
                                                                                                                                    echo 7e1212fd 28843fa5
                                                                                                                                fi
                                                                                                                                if [[ "$INDEX" == 0 ]]
                                                                                                                                then
                                                                                                                                    echo 7e1212fd 9911010b
                                                                                                                                    git mutable-reset
                                                                                                                                    echo 7e1212fd b5c69247
                                                                                                                                fi
                                                                                                                                git mutable-check
                                                                                                                                git mutable-build-vm
                                                                                                                                prompt "mutable-build-vm $INDEX"
                                                                                                                                git mutable-test
                                                                                                                                prompt "mutable-test $INDEX"
                                                                                                                                echo 7e1212fd a338b730 "$INDEX"
                                                                                                                                if [[ "$INDEX" == 0 ]]
                                                                                                                                then
                                                                                                                                    echo 7e1212fd 0b784f4e
                                                                                                                                    git mutable-switch
                                                                                                                                    prompt "mutable-switch"
                                                                                                                                else
                                                                                                                                    echo 7e1212fd e1a606bc
                                                                                                                                    NEXT_INDEX=$(( INDEX - 1 ))
                                                                                                                                    echo 7e1212fd 94a1dcc2 "NEXT_INDEX=$NEXT_INDEX"
                                                                                                                                    NEXT_REPOSITORY="$( git mutable-studio )" || failure 00b2b3fb
                                                                                                                                    echo 7e1212fd 2c357870 "NEXT_REPOSITORY=$NEXT_REPOSITORY"
                                                                                                                                    NEXT_BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure 9cf16a4e
                                                                                                                                    echo 7e1212fd d78279e5 "NEXT_BRANCH=$NEXT_BRANCH"
                                                                                                                                    git mutable-promote "$NEXT_INDEX" "$NEXT_REPOSITORY" "$NEXT_BRANCH"
                                                                                                                                    echo 7e1212fd 39b0c4d3
                                                                                                                                fi
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                                reset =
                                                                                                                    {
                                                                                                                        runtimeInputs = [ pkgs.git sequential ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                # reset this to main, squashing all comments to one; iteratively do the same for submodules
                                                                                                                                echo 7e1212fd 5b710c4f
                                                                                                                                REPOSITORY="$( git rev-parse --show-toplevel )" || failure 3b2b98e3
                                                                                                                                echo 7e1212fd 49144c77
                                                                                                                                cd "$REPOSITORY"
                                                                                                                                echo 7e1212fd 5331d409
                                                                                                                                GIT_SSH_COMMAND="$( git config --get core.sshCommand )" || failure fb0cc50b
                                                                                                                                export GIT_SSH_COMMAND
                                                                                                                                echo 7e1212fd fb61288c
                                                                                                                                git submodule foreach '${ scripts.submodule.reset }'
                                                                                                                                echo 7e1212fd c2164dac
                                                                                                                                git fetch origin main
                                                                                                                                echo 7e1212fd 2f6892c5
                                                                                                                                if ! git diff --quiet origin/main || git diff --quiet --cached origin/main
                                                                                                                                then
                                                                                                                                    echo 7e1212fd f53126b8
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
                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
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
                                                                                                                                ../bin/gc-root "$SNAPSHOT"
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
                                                                                                                                echo 7e1212fd 9c8f1310
                                                                                                                                git config user.email "${ config.personal.email }"
                                                                                                                                git config user.name "${ config.personal.description }"
                                                                                                                                echo 7e1212fd fcc973ed
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
                                                                                                                                    GIT_SSH_COMMAND="$( git config --get core.sshCommand )" || failure c55a7d2f
                                                                                                                                    if [[ -z "$GIT_SSH_COMMAND" ]]
                                                                                                                                    then
                                                                                                                                        failure 10ce8944
                                                                                                                                    fi
                                                                                                                                    USER_EMAIL="$( git config --get user.email )" || failure e9471d87
                                                                                                                                    if [[ -z "$USER_EMAIL" ]]
                                                                                                                                    then
                                                                                                                                        failure a328a496
                                                                                                                                    fi
                                                                                                                                    USER_NAME="$( git config --get user.name )" || failure 6cd6c5b8
                                                                                                                                    if [[ -z "$USER_NAME" ]]
                                                                                                                                    then
                                                                                                                                        failure d980340a
                                                                                                                                    fi
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
                                                                                                                "$MOUNT/bin/gc-root" "$STUDIO"
                                                                                                                echo "$STUDIO/repository"
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/studio" ;
                                                                                in
                                                                                    ''
                                                                                        # initialize a read write copy of main
                                                                                        wrap ${ gc-root }/bin/gc-root bin/gc-root 0500 --literal-plain DIRECTORY --inherit-plain INDEX --literal-plain PATH --literal-plain TARGET --uuid 608bd8f9
                                                                                        wrap ${ studio } bin/studio 0500 --inherit-plain MOUNT --literal-plain PATH --literal-plain SEQUENCE --inherit-plain SETUP --literal-plain STUDIO --uuid 79a37900
                                                                                        mkdir --parents /mount/repository
                                                                                        cd /mount/repository
                                                                                        git init 2>&1
                                                                                        gc-root ${ pkgs.openssh }
                                                                                        DOT_SSH=${ resources.production.dot-ssh { failure = 2564 ; } }
                                                                                        gc-root "$DOT_SSH"
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
                                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                                                                                                                echo 7e1212fd 76cd421a
                                                                                                                                git -C "$REPOSITORY" submodule foreach '${ scripts.submodule.switch }'
                                                                                                                                echo 7e1212fd 59aa8693
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
                                                                                                                                echo 7e1212fd 1fcca264 "$toplevel/$name"
                                                                                                                                cd "$toplevel/$name"
                                                                                                                                git fetch origin main
                                                                                                                                if ! git diff origin/main --quiet || ! git diff origin/main --quiet --cached
                                                                                                                                then
                                                                                                                                    BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure b7fb71d9
                                                                                                                                    TOKEN=${ resources.production.secret.github.token { failure = 24794 ; } }
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
                                                                                                                                    TOKEN_DIRECTORY=${ resources.production.secret.github.token { failure = 3414 ; } }
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
                                                                                        git submodule foreach 'git config user.email "${ config.personal.email }"'
                                                                                        git submodule foreach 'git config user.name "${ config.personal.description }"'
                                                                                        echo 380b7b99 b4542105
                                                                                        UUID="$( sequential | sha512sum )" || failure 2ecf55e5
                                                                                        echo 380b7b99 fb8ae5e7
                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure ee625965
                                                                                        echo 380b7b99 2bb86aa3
                                                                                        git submodule foreach "git checkout -b $BRANCH" 2>&1
                                                                                        echo 380b7b99 b29cd747
                                                                                        git submodule foreach "git push origin HEAD" 2>&1
                                                                                        echo 380b7b99 a7df32c6
                                                                                        wrap ${ gc-root }/bin/gc-root stage/root 0500 --literal-plain DIRECTORY --inherit-plain INDEX --literal-plain PATH --literal-plain TARGET --uuid c3aaf5d8
                                                                                    '' ;
                                                                    } ;
                                                            in "${ application }/bin/init" ;
                                                release =
                                                    { failure , pkgs , resources , seed , trace , sequential } :
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
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                transient = true ;
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
                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
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
                                                                                    find "$MOUNT/plain" -mindepth 1 -type f -name "*.asc" | while read -r PLAINTEXT_FILE
                                                                                    do
                                                                                        FILE="${ builtins.concatStringsSep "" [ "$" "{" ''PLAINTEXT_FILE#"$MOUNT"/plain/'' "}" ] }"
                                                                                        CIPHERTEXT_FILE="$MOUNT/cipher/$FILE.age"
                                                                                        RECIPIENT="$( age-keygen -y ${ config.personal.agenix } )" || failure 48550b32
                                                                                        age --encrypt --recipient "$RECIPIENT" --output "$CIPHERTEXT_FILE" --armor "$PLAINTEXT_FILE"
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
                                                                                            github/token.asc.age)
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
                                                                git checkout -b main 2>&1
                                                                mkdir --parents /mount/plain/dot-gnupg
                                                                mkdir --parents /mount/plain/dot-ssh/github
                                                                mkdir --parents /mount/plain/dot-ssh/mobile
                                                                mkdir --parents /mount/plain/github
                                                                git config user.email "${ config.personal.repository.private.email }"
                                                                git config user.name "${ config.personal.repository.private.name }"
                                                                wrap ${ post-commit } cipher/.git/hooks/post-commit 0500 --literal-brace "GIT_SSH_COMMAND:?GIT_SSH_COMMAND must be exported" --inherit-plain MOUNT --literal-plain PATH --uuid 708e9f8d
                                                                # shellcheck disable=SC2016
                                                                wrap ${ pre-commit } cipher/.git/hooks/pre-commit 0500 --literal-plain CIPHERTEXT_FILE --literal-plain FILE --inherit-plain MOUNT --literal-plain PATH --literal-plain PLAINTEXT_FILE --literal-brace 'PLAINTEXT_FILE#"$MOUNT"/plain/' --literal-plain RECIPIENT --literal-plain STAGED_FILE --uuid e7266fc5
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
                        init = { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } : "" ;
                        transient = true ;
                    } ;
            volume =
                let
                    volume =
                        branch : ignore :
                            {
                                init =
                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                        let
                                            application =
                                                pkgs.writeShellApplication
                                                    {
                                                        name = "init" ;
                                                        runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git pkgs.git-lfs pkgs.git-crypt pkgs.gnupg failure gc-root wrap ] ;
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
                                                                        DOT_SSH=${ resources.production.dot-ssh { failure = 10159 ; } }
                                                                        gc-root "$DOT_SSH"
                                                                        gc-root ${ pkgs.openssh }
                                                                        cd /mount
                                                                        git init 2>&1
                                                                        git config core.sshCommand "${ pkgs.openssh }/bin/ssh -F $DOT_SSH/config"
                                                                        git config user.email "${ config.personal.volume.email }"
                                                                        git config user.name "${ config.personal.volume.name }"
                                                                        git remote add origin git@github.com:${ config.personal.volume.organization }/${ config.personal.volume.repository }
                                                                        DOT_GNUPG=${ resources.production.dot-gnupg { } }
                                                                        export GNUPGHOME="$DOT_GNUPG/dot-gnupg"
                                                                        TOKEN=${ resources.production.secret.github.token { failure = 5445 ; } }
                                                                        gh auth login --with-token < "$TOKEN/plaintext"
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
                                                                            gh repo create ${ config.personal.volume.organization }/${ config.personal.volume.repository } --private --confirm 2>&1
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
}