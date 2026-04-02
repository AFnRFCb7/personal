# 25594
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
                        resource-logger ,
                        resource-releaser ,
                        system ,
                        visitor
                    } @primary :
                        let
                            _failure = failure.lib { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; visitor = visitor ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                            _resource =
                                { gc-root-directory , resources , resources-directory } :
                                    resource.lib
                                        {
                                            buildFHSUserEnv = pkgs.buildFHSUserEnv ;
                                            coreutils = pkgs.coreutils ;
                                            flock = pkgs.flock ;
                                            gc-root-directory = gc-root-directory ;
                                            invalid-init-channel = "invalid-init" ;
                                            invalid-release-channel = "invalid-release" ;
                                            jq = pkgs.jq ;
                                            procps = pkgs.procps ;
                                            redis = pkgs.redis ;
                                            resources = resources ;
                                            resources-directory = resources-directory ;
                                            stale-init-channel = "stale-init" ;
                                            valid-init-channel = "valid-init" ;
                                            valid-release-channel = "valid-release" ;
                                            visitor = _visitor.implementation ;
                                            writeShellApplication = pkgs.writeShellApplication ;
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
                                        # this derivation is a directory of commands
                                        derivation =
                                            pkgs.stdenv.mkDerivation
                                                {
                                                    installPhase = "execute-install" ;
                                                    name = "derivation" ;
                                                    nativeBuildInputs =
                                                        [
                                                            (
                                                                pkgs.writeShellApplication
                                                                    {
                                                                        name = "execute-install" ;
                                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                                        text =
                                                                            let
                                                                                resources =
                                                                                    _visitor.implementation
                                                                                        {
                                                                                            list = path : list : builtins.concatLists list ;
                                                                                            set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                            string = path : value : [ ''ln --symbolic ${ value } "$out/${ builtins.hashString "sha512" ( builtins.toJSON path ) }"'' ] ;
                                                                                        }
                                                                                        resources__ ;
                                                                                in
                                                                                    builtins.concatStringsSep
                                                                                        "\n"
                                                                                        (
                                                                                            builtins.concatLists
                                                                                                [
                                                                                                    [
                                                                                                        '': "${ builtins.concatStringsSep "" [ "$" "{" "out:?must be exported" "}" ] }"''
                                                                                                        ''mkdir --parents "$out"''
                                                                                                    ]
                                                                                                    ( resources )
                                                                                                ]
                                                                                        ) ;
                                                                    }
                                                            )
                                                        ] ;
                                                    src = ./. ;
                                                } ;
                                        #
                                        resources =
                                            _visitor.implementation
                                                {
                                                    lambda =
                                                        path : value : { derivation ? "$DERIVATION" , failure ? 64 , setup ? setup : setup } :
                                                            let
                                                                command = ''"${ derivation }/${ builtins.hashString "sha512" ( builtins.toJSON path ) }"'' ;
                                                                failure_ =
                                                                    let
                                                                        application =
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "failure" ;
                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.jq pkgs.yq-go ] ;
                                                                                    text =
                                                                                        ''
                                                                                            # shellcheck disable=2140
                                                                                            jq \
                                                                                                --null-input \
                                                                                                --argjson PATH '${ builtins.toJSON path }' \
                                                                                                --argjson FAILURE '${ builtins.toJSON failure }' \
                                                                                                '{
                                                                                                    "failure" $FAILURE ,
                                                                                                    "path" : $PATH
                                                                                                }' | yq eval --prettyPrint "." >&2
                                                                                            exit 64
                                                                                        '' ;
                                                                                } ;
                                                                            in "${ application }/bin/failure" ;
                                                                in ''"$( ${ setup command } )" || ${ failure_ }'' ;
                                                }
                                                resources___ ;
                                        # I am using the cyclic script name to form a command.  It still has the cyclic dependency problem.
                                        resources_ =
                                            _visitor.implementation
                                                {
                                                    string =
                                                        path : value : { setup ? setup : setup } :
                                                            let
                                                                failure =
                                                                    let
                                                                        application =
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "failure" ;
                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                    text =
                                                                                        ''
                                                                                            # shellcheck disable=2140
                                                                                            echo There was a failure in resource '${ builtins.toJSON path }' >&2
                                                                                            exit 64
                                                                                        '' ;
                                                                                } ;
                                                                            in "${ application }/bin/failure" ;
                                                                    in ''"$( ${ setup value } )" || ${ failure }'' ;
                                                }
                                                resources_ ;
                                        # I am turning the raw implementation into a setup script path.  It still has the cyclic dependency problem.
                                        resources__ =
                                            _visitor.implementation
                                                {
                                                    lambda =
                                                        path : value :
                                                            let
                                                                factory =
                                                                    _resource
                                                                        {
                                                                            gc-root-directory = "/home/${ config.personal.name }/.gc-root" ;
                                                                            resources = resources ;
                                                                            resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                        } ;
                                                                r = value null ;
                                                                in
                                                                    factory.implementation
                                                                        {
                                                                            depth = r.depth or 0 ;
                                                                            init = r.init or null ;
                                                                            init-resolutions = r.init-resolutions or null ;
                                                                            release = r.release or null ;
                                                                            release-resolutions = r.release-resolutions or null ;
                                                                            seed = path ;
                                                                            targets = r.targets or [ ] ;
                                                                            transient = false ;
                                                                        } ;
                                                }
                                                resources___ ;
                                        # the raw implementation
                                        resources___ =
                                            {
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
                                                                                            runtimeInputs =
                                                                                                [
                                                                                                    pkgs.bash
                                                                                                    failure
                                                                                                    trace
                                                                                                    (
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "outer" ;
                                                                                                                runtimeInputs =
                                                                                                                    [
                                                                                                                        pkgs.bash
                                                                                                                        failure
                                                                                                                        (
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "inner" ;
                                                                                                                                    runtimeInputs = [ failure pkgs.coreutils pkgs.yq-go ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            trace INNER "$*"
                                                                                                                                            while [[ "$#" -gt 0 ]]
                                                                                                                                            do
                                                                                                                                                case "$1" in
                                                                                                                                                    --init-exit-code)
                                                                                                                                                        INIT_EXIT_CODE="$2"
                                                                                                                                                        shift 2
                                                                                                                                                        ;;
                                                                                                                                                    --release-exit-code)
                                                                                                                                                        RELEASE_EXIT_CODE="$2"
                                                                                                                                                        shift 2
                                                                                                                                                        ;;
                                                                                                                                                    *)
                                                                                                                                                        failure 14578
                                                                                                                                                esac
                                                                                                                                            done
                                                                                                                                            if RESOURCE=${ resources.checks.resource { setup = setup : ''${ setup } --init-exit-code "$INIT_EXIT_CODE" --release-exit-code "$RELEASE_EXIT_CODE"'' ; } }
                                                                                                                                            then
                                                                                                                                                STATUS="$?"
                                                                                                                                            else
                                                                                                                                                STATUS="$?"
                                                                                                                                            fi
                                                                                                                                            # shellcheck disable=SC2016
                                                                                                                                            yq eval --prettyPrint --arg RESOURCE "$RESOURCE" --arg SETUP_STATUS "$STATUS" '[ { "channel" : .[-1].channel , "init-status" : .[-1].status , "resource" : $RESOURCE , "setup-status" : $SETUP_STATUS } ]' /home/${ config.personal.name }/logs/log.yaml >> /mount/observed.yaml
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                    ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        trace OUTER "$*"
                                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                                        do
                                                                                                                            case "$1" in
                                                                                                                                --depth)
                                                                                                                                    DEPTH="$2"
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --init-exit-code)
                                                                                                                                    INIT_EXIT_CODE="$2"
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --release-exit-code)
                                                                                                                                    RELEASE_EXIT_CODE="$2"
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                *)
                                                                                                                                    failure 2846
                                                                                                                            esac
                                                                                                                        done
                                                                                                                        NEXT=$(( DEPTH - 1 ))
                                                                                                                        if [[ "$NEXT" -ge 0 ]]
                                                                                                                        then
                                                                                                                            bash -c "$0 --depth $DEPTH --init-exit-code $INIT_EXIT_CODE --release-exit-code $RELEASE_EXIT_CODE"
                                                                                                                        else
                                                                                                                            bash -c "inner --init-exit-code $INIT_EXIT_CODE --release-exit-code $RELEASE_EXIT_CODE"
                                                                                                                        fi
                                                                                                                        # shellcheck disable=SC2016
                                                                                                                        yq eval --prettyPrint --arg DEPTH "$DEPTH" '[ { "channel" : .[-1].channel , "depth" : $DEPTH , "init-status" : .[-1].status } ]' /home/${ config.personal.name }/logs/log.yaml >> /mount/observed.yaml
                                                                                                                    '' ;
                                                                                                            }
                                                                                                    )
                                                                                                ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    trace HOOK "$*"
                                                                                                    trace 10010 "$*"
                                                                                                    INIT_EXIT_CODE=0
                                                                                                    trace 8532 "$*"
                                                                                                    RELEASE_EXIT_CODE=0
                                                                                                    trace 18566 "$*"
                                                                                                    while [[ "$#" -gt 0 ]]
                                                                                                    do
                                                                                                        trace 30648
                                                                                                        case "$1" in
                                                                                                            --depth)
                                                                                                                trace 7657
                                                                                                                DEPTH="$2"
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            --init-exit-code)
                                                                                                                trace 22414
                                                                                                                INIT_EXIT_CODE="$2"
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            --release-exit-code)
                                                                                                                trace 8458
                                                                                                                RELEASE_EXIT_CODE="$2"
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            *)
                                                                                                                trace 8730
                                                                                                                failure 4168
                                                                                                        esac
                                                                                                    done
                                                                                                    trace 11577 "DEPTH=$DEPTH" "INIT_EXIT_CODE=$INIT_EXIT_CODE" "RELEASE_EXIT_CODE=$RELEASE_EXIT_CODE"
                                                                                                    NEXT=$(( DEPTH - 1 ))
                                                                                                    trace 9019
                                                                                                    bash -c "outer --depth $NEXT --init-exit-code $INIT_EXIT_CODE --release-exit-code $RELEASE_EXIT_CODE"
                                                                                                    trace 25864
                                                                                                    mkdir --parents "/mount/observed/$DEPTH"
                                                                                                    trace 2698
                                                                                                    # shellcheck disable=SC2016
                                                                                                    yq eval --prettyPrint --arg DEPTH "$DEPTH" '{ "channel" : .[-2].channel , "depth" : $DEPTH , "init-status" : .[-1].status }' /home/${ config.personal.name }/logs/log.yaml > /scratch/init.yaml
                                                                                                    trace 1945
                                                                                                    # shellcheck disable=SC2016
                                                                                                    yq eval --prettyPrint --arg DEPTH '{ "channel" : .[-1].channel , "depth" : $DEPTH , "release-status" : .[-1].status }' /home/${ config.personal.name }/logs/log.yaml > /scratch/release.yaml
                                                                                                    # shellcheck disable=SC2016
                                                                                                    yq eval --prettyPrint --argfile INIT /scratch/init.yaml --argfile RELEASE /scratch/release.yaml '{ "init" : $INIT , "release" : $RELEASE }' >> /mount/observed.yaml
                                                                                                '' ;
                                                                                        } ;
                                                                                in ''${ application }/bin/init "$@"'' ;
                                                                    release =
                                                                        { failure , pkgs , resources , seed , sequential , trace } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "release" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    echo 9577
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/release" ;
                                                                    targets = [ "observed.yaml" ] ;
                                                                } ;
                                                        resource =
                                                            ignore :
                                                                {
                                                                    init =
                                                                        { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "init" ;
                                                                                            runtimeInputs = [ failure pkgs.coreutils ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    INIT_EXIT_CODE=0
                                                                                                    RELEASE_EXIT_CODE=0
                                                                                                    while [[ "$#" -gt 0 ]]
                                                                                                    do
                                                                                                        case "$1" in
                                                                                                            --init-exit-code)
                                                                                                                INIT_EXIT_CODE="$2"
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            --release-exit-code)
                                                                                                                RELEASE_EXIT_CODE="$2"
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            *)
                                                                                                                failure 4168
                                                                                                        esac
                                                                                                    done
                                                                                                    echo "$INIT_EXIT_CODE" > /mount/init-exit-code
                                                                                                    echo "$RELEASE_EXIT_CODE" > /mount/release-exit-code
                                                                                                    exit "$INIT_EXIT_CODE"
                                                                                                '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/init" ;
                                                                    release =
                                                                        { failure , pkgs , resources , seed , sequential , trace } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "release" ;
                                                                                            runtimeInputs = [ failure pkgs.coreutils ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    RELEASE_EXIT_CODE="$( cat /mount/release-exit-code )" || failure 19859
                                                                                                    exit "$RELEASE_EXIT_CODE"
                                                                                                '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/release" ;
                                                                    targets = [ "init-exit-code" "release-exit-code" ] ;
                                                                } ;
                                                    } ;
                                                foobar =
                                                    {
                                                        pad =
                                                            ignore :
                                                                {
                                                                    depth = 0 ;
                                                                    init =
                                                                        { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "init" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text =
                                                                                                let
                                                                                                    envrc =
                                                                                                        ''
                                                                                                        '' ;
                                                                                                    in
                                                                                                        ''
                                                                                                            touch /mount/.envrc
                                                                                                            echo 24545
                                                                                                        '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/init" ;
                                                                    release =
                                                                        { failure , pkgs , resources , seed , sequential , trace } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "release" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    echo 11660
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/release" ;
                                                                    targets = [ ".envrc" ] ;
                                                                } ;
                                                        temporary =
                                                            ignore :
                                                                {
                                                                    transient = true ;
                                                                } ;
                                                    } ;
                                                production =
                                                    {
                                                        age =
                                                            {
                                                                ciphertext =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ pkgs.age pkgs.git wrap ] ;
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
                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "GIT_SSH_COMMAND:?must be exported" "}" ] }"
                                                                                                                                        while ! git push ssh HEAD
                                                                                                                                        do
                                                                                                                                            sleep 1
                                                                                                                                        done
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                        in "${ application }/bin/post-commit" ;
                                                                                                            post-push =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "post-push" ;
                                                                                                                                runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "GIT_SSH_COMMAND:?must be exported" "}" ] }"
                                                                                                                                        GPG_OWNERTRUST=${ resources.production.age.plaintext.dot-gnupg.ownertrust { failure = 21711 ; } }
                                                                                                                                        echo false > "$GPG_OWNERTRUST/flag"
                                                                                                                                        GPG_SECRET_KEYS=${ resources.production.age.plaintext.dot-gnupg.secret-keys { failure = 31244 ; } }
                                                                                                                                        echo false > "$GPG_SECRET_KEYS/flag"
                                                                                                                                        GITHUB_KNOWN_HOSTS=${ resources.production.age.plaintext.dot-ssh.github.known-hosts { failure = 17547 ; } }
                                                                                                                                        echo false > "$GITHUB_KNOWN_HOSTS/flag"
                                                                                                                                        GITHUB_IDENTITY=${ resources.production.age.plaintext.dot-ssh.github.identity { failure = 21755 ; } }
                                                                                                                                        echo false > "$GITHUB_IDENTITY/flag"
                                                                                                                                        MOBILE_KNOWN_HOSTS=${ resources.production.age.plaintext.dot-ssh.github.known-hosts { failure = 23344 ; } }
                                                                                                                                        echo false > "$MOBILE_KNOWN_HOSTS/flag"
                                                                                                                                        MOBILE_IDENTITY=${ resources.production.age.plaintext.dot-ssh.github.identity { failure = 10157 ; } }
                                                                                                                                        echo false > "$MOBILE_IDENTITY/flag"
                                                                                                                                        GITHUB_TOKEN=${ resources.production.age.plaintext.github.token { failure = 28945 ; } }
                                                                                                                                        echo false > "$GITHUB_TOKEN/flag"
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                        in "${ application }/bin/post-push" ;
                                                                                                            pre-commit =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "pre-commit" ;
                                                                                                                                runtimeInputs = [ failure pkgs.age pkgs.git ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "GIT_SSH_COMMAND:?must be exported" "}" ] }"
                                                                                                                                        GPG_OWNERTRUST=${ resources.production.age.plaintext.dot-gnupg.ownertrust { failure = 25440 ; } }
                                                                                                                                        GPG_OWNERTRUST_FLAG="$( cat "$GPG_OWNERTRUST/flag" )" || failure 4095
                                                                                                                                        if "$GPG_OWNERTRUST_FLAG"
                                                                                                                                        then
                                                                                                                                            age --encrypt --recipient "$RECIPIENT" --output "/home/${ config.personal.name }/resources/mounts/$INDEX/dot-gnupg/ownertrust.asc.age" --armor "$GPG_OWNERTRUST/plaintext"
                                                                                                                                            git -C "/home/${ config.personal.name }/resources/mounts/$INDEX" add dot-gnupg/ownertrust.asc.age
                                                                                                                                        fi
                                                                                                                                        GPG_SECRET_KEYS=${ resources.production.age.plaintext.dot-gnupg.secret-keys { failure = 31125 ; } }
                                                                                                                                        GPG_SECRET_KEYS_FLAG="$( cat "$GPG_SECRET_KEYS/flag" )" || failure 19375
                                                                                                                                        if "$GPG_SECRET_KEYS_FLAG"
                                                                                                                                        then
                                                                                                                                            age --encrypt --recipient "$RECIPIENT" --output "/home/${ config.personal.name }/resources/mounts/$INDEX/dot-gnupg/secret-keys.asc.age" --armor "$GPG_SECRET_KEYS/plaintext"
                                                                                                                                            git -C "/home/${ config.personal.name }/resources/mounts/$INDEX" add dot-gnupg/secret-keys.asc.age
                                                                                                                                        fi
                                                                                                                                        GITHUB_KNOWN_HOSTS=${ resources.production.age.plaintext.dot-ssh.github.known-hosts { failure = 13704 ; } }
                                                                                                                                        echo "GITHUB_KNOWN_HOSTS=$GITHUB_KNOWN_HOSTS"
                                                                                                                                        GITHUB_KNOWN_HOSTS_FLAG="$( cat "$GITHUB_KNOWN_HOSTS/flag" )" || failure 23236
                                                                                                                                        if "$GITHUB_KNOWN_HOSTS_FLAG"
                                                                                                                                        then
                                                                                                                                            age --encrypt --recipient "$RECIPIENT" --output "/home/${ config.personal.name }/resources/mounts/$INDEX/dot-ssh/github/known-hosts.asc.age" --armor "$GITHUB_KNOWN_HOSTS/plaintext"
                                                                                                                                            git -C "/home/${ config.personal.name }/resources/mounts/$INDEX" add dot-ssh/github/known-hosts.asc.age
                                                                                                                                        fi
                                                                                                                                        GITHUB_IDENTITY=${ resources.production.age.plaintext.dot-ssh.github.identity { failure = 15209 ; } }
                                                                                                                                        GITHUB_IDENTITY_FLAG="$( cat "$GITHUB_IDENTITY/flag" )" || failure 29560
                                                                                                                                        if "$GITHUB_IDENTITY_FLAG"
                                                                                                                                        then
                                                                                                                                            age --encrypt --recipient "$RECIPIENT" --output "/home/${ config.personal.name }/resources/mounts/$INDEX/dot-ssh/github/identity.asc.age" --armor "$GITHUB_IDENTITY/plaintext"
                                                                                                                                            git -C "/home/${ config.personal.name }/resources/mounts/$INDEX" add dot-ssh/github/known-hosts.asc.age
                                                                                                                                        fi
                                                                                                                                        MOBILE_KNOWN_HOSTS=${ resources.production.age.plaintext.dot-ssh.mobile.known-hosts { failure = 28909 ; } }
                                                                                                                                        MOBILE_KNOWN_HOSTS_FLAG="$( cat "$MOBILE_KNOWN_HOSTS/flag" )" || failure 14272
                                                                                                                                        if "$MOBILE_KNOWN_HOSTS_FLAG"
                                                                                                                                        then
                                                                                                                                            age --encrypt --recipient "$RECIPIENT" --output "/home/${ config.personal.name }/resources/mounts/$INDEX/dot-ssh/mobile/known-hosts.asc.age" --armor "$MOBILE_KNOWN_HOSTS/plaintext"
                                                                                                                                            git -C "/home/${ config.personal.name }/resources/mounts/$INDEX" add dot-ssh/mobile/known-hosts.asc.age
                                                                                                                                        fi
                                                                                                                                        MOBILE_IDENTITY=${ resources.production.age.plaintext.dot-ssh.mobile.identity { failure = 13514 ; } }
                                                                                                                                        MOBILE_IDENTITY_FLAG="$( cat "$MOBILE_IDENTITY/flag" )" || failure 16967
                                                                                                                                        if "$MOBILE_IDENTITY_FLAG"
                                                                                                                                        then
                                                                                                                                            age --encrypt --recipient "$RECIPIENT" --output "/home/${ config.personal.name }/resources/mounts/$INDEX/dot-ssh/mobile/identity.asc.age" --armor "$MOBILE_IDENTITY/plaintext"
                                                                                                                                            git -C "/home/${ config.personal.name }/resources/mounts/$INDEX" add dot-ssh/mobile/identity.asc.age
                                                                                                                                        fi
                                                                                                                                        GITHUB_TOKEN=${ resources.production.age.plaintext.github.token { failure = 31431 ; } }
                                                                                                                                        GITHUB_TOKEN_FLAG="$( cat "$GITHUB_TOKEN/flag" )" || failure 27816
                                                                                                                                        if "$GITHUB_TOKEN_FLAG"
                                                                                                                                        then
                                                                                                                                            age --encrypt --recipient "$RECIPIENT" --output "/home/${ config.personal.name }/resources/mounts/$INDEX/github/token.asc.age" --armor "$GITHUB_TOKEN/plaintext"
                                                                                                                                            git -C "/home/${ config.personal.name }/resources/mounts/$INDEX" add github/token.asc.age
                                                                                                                                        fi
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/pre-commit" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    cd /mount
                                                                                                                    git init 2>&1
                                                                                                                    git config user.email "${ config.personal.secrets.email }"
                                                                                                                    git config user.name "${ config.personal.secrets.name }"
                                                                                                                    git remote add https https://github.com/${ config.personal.secrets.organization }/${ config.personal.secrets.repository }.git
                                                                                                                    git remote add ssh git@github.com:${ config.personal.secrets.organization }/${ config.personal.secrets.repository }.git
                                                                                                                    wrap ${ post-commit } .git/hooks/post-commit 0500 --literal brace "GIT_SSH_COMMAND:?must be exported" --literal plain PATH --uuid 31150
                                                                                                                    wrap \
                                                                                                                        ${ post-push } \
                                                                                                                        .git/hooks/post-push \
                                                                                                                        0500 \
                                                                                                                        --literal plain DERIVATION \
                                                                                                                        --literal plain GITHUB_KNOWN_HOSTS \
                                                                                                                        --literal plain GITHUB_IDENTITY \
                                                                                                                        --literal plain GITHUB_TOKEN \
                                                                                                                        --literal plain GPG_OWNERTRUST \
                                                                                                                        --literal plain GPG_SECRET_KEYS \
                                                                                                                        --literal plain MOBILE_KNOWN_HOSTS \
                                                                                                                        --literal plain MOBILE_IDENTITY \
                                                                                                                        --literal plain PATH \
                                                                                                                        --uuid 28649
                                                                                                                    RECIPIENT="$( age-keygen -y ${ config.personal.agenix } )" || failure 16231
                                                                                                                    export RECIPIENT
                                                                                                                    wrap \
                                                                                                                        ${ pre-commit } \
                                                                                                                        .git/hooks/pre-commit \
                                                                                                                        0500 \
                                                                                                                        --literal plain DERIVATION \
                                                                                                                        --literal plain GITHUB_KNOWN_HOSTS \
                                                                                                                        --literal plain GITHUB_KNOWN_HOSTS_FLAG \
                                                                                                                        --literal plain GITHUB_IDENTITY \
                                                                                                                        --literal plain GITHUB_IDENTITY_FLAG \
                                                                                                                        --literal plain GITHUB_TOKEN \
                                                                                                                        --literal plain GITHUB_TOKEN_FLAG \
                                                                                                                        --literal plain GPG_OWNERTRUST \
                                                                                                                        --literal plain GPG_OWNERTRUST_FLAG \
                                                                                                                        --literal plain GPG_SECRET_KEYS \
                                                                                                                        --literal plain GPG_SECRET_KEYS_FLAG \
                                                                                                                        --inherit plain INDEX \
                                                                                                                        --literal plain MOBILE_KNOWN_HOSTS \
                                                                                                                        --literal plain MOBILE_KNOWN_HOSTS_FLAG \
                                                                                                                        --literal plain MOBILE_IDENTITY \
                                                                                                                        --literal plain MOBILE_IDENTITY_FLAG \
                                                                                                                        --literal plain PATH \
                                                                                                                        --inherit plain RECIPIENT \
                                                                                                                        --uuid 12094
                                                                                                                    git fetch https "${ config.personal.secrets.branch }" 2>&1
                                                                                                                    git checkout "https/${ config.personal.secrets.branch }" 2>&1
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ ".git" "dot-gnupg" "dot-ssh" "github" ] ;
                                                                        } ;
                                                                    plaintext =
                                                                        _visitor.implementation
                                                                            {
                                                                                null =
                                                                                    path : value : ignore :
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
                                                                                                                            echo false > /mount/flag
                                                                                                                            SECRETS=${ resources.production.age.ciphertext { failure = 11236 ; } }
                                                                                                                            git -C "$SECRETS" fetch https ${ config.personal.secrets.branch } 2>&1
                                                                                                                            git -C "$SECRETS" checkout https/${ config.personal.secrets.branch } 2>&1
                                                                                                                            age --decrypt --identity ${ config.personal.agenix } --output /mount/plaintext "$SECRETS/${ builtins.concatStringsSep "/" path }.asc.age"
                                                                                                                            chmod 0400 /mount/plaintext
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                            in "${ application }/bin/init" ;
                                                                                            targets = [ "flag" "plaintext" ] ;
                                                                                        } ;
                                                                            }
                                                                            {
                                                                                dot-gnupg =
                                                                                    {
                                                                                        ownertrust = null ;
                                                                                        secret-keys = null ;
                                                                                    } ;
                                                                                dot-ssh =
                                                                                    {
                                                                                        github =
                                                                                            {
                                                                                                identity = null ;
                                                                                                known-hosts = null ;
                                                                                            } ;
                                                                                        mobile =
                                                                                            {
                                                                                                identity = null ;
                                                                                                known-hosts = null ;
                                                                                            } ;
                                                                                    } ;
                                                                                github =
                                                                                    {
                                                                                        token = null ;
                                                                                    } ;
                                                                            } ;
                                                            } ;
                                                        bin =
                                                            {
                                                                checks =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ failure gc-root pkgs.coreutils wrap ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            true-true =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "true-true" ;
                                                                                                                                runtimeInputs = [ pkgs.bash pkgs.redis ] ;
                                                                                                                                text =
                                                                                                                                    let
                                                                                                                                        pre-test =
                                                                                                                                            let
                                                                                                                                                application =
                                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                                        {
                                                                                                                                                            name = "pre-test" ;
                                                                                                                                                            runtimeInputs = [ failure pkgs.coreutils pkgs.gawk pkgs.redis ] ;
                                                                                                                                                            text =
                                                                                                                                                                ''
                                                                                                                                                                    OUTFILE="$( mktemp )" || failure 18422
                                                                                                                                                                    redis-cli --csv SUBSCRIBE invalid-init invalid-release stale-init valid-init valid-release | awk -F',' '$1 == "\"message\"" { print $3 }' | tr -d '"' > "$OUTFILE" &
                                                                                                                                                                    sleep 0.2
                                                                                                                                                                    OBSERVED_RESOURCE=${ resources.production.checks.true-true { failure = 30718 ; } }
                                                                                                                                                                    if [[ "$EXPECTED_RESOURCE" != "$OBSERVED_RESOURCE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 16620 "EXPECTED_RESOURCE=$EXPECTED_RESOURCE" "OBSERVED_RESOURCE=$OBSERVED_RESOURCE"
                                                                                                                                                                    fi
                                                                                                                                                                    OBSERVED_COUNT="$( wc --lines < "$OUTFILE" )" || failure 30154
                                                                                                                                                                    while (( EXPECTED_COUNT > OBSERVED_COUNT ))
                                                                                                                                                                    do
                                                                                                                                                                        sleep 0.2
                                                                                                                                                                        OBSERVED_COUNT="$( wc --lines < "$OUTFILE" )" || failure 26176
                                                                                                                                                                    done
                                                                                                                                                                    EXPECTED_MESSAGES='$EXPECTED_MESSAGES'
                                                                                                                                                                    OBSERVED_MESSAGES="$( cat "$OUTFILE" )" || failure 31892
                                                                                                                                                                    if [[ "$EXPECTED_MESSAGES" != "$OBSERVED_MESSAGES" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 13800 "EXPECTED_MESSAGE" "$EXPECTED_MESSAGES" "OBSERVED_MESSAGES" "$OBSERVED_MESSAGES"
                                                                                                                                                                    fi
                                                                                                                                                                '' ;
                                                                                                                                                        } ;
                                                                                                                                                in "${ application }/bin/pre-test" ;
                                                                                                                                        in
                                                                                                                                            ''
                                                                                                                                                timeout 1m bash -c "${ pre-test }"
                                                                                                                                            '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/true-true" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    export EXPECTED_COUNT=3
                                                                                                                    EXPECTED_MESSAGES="$( cat <<EOF
                                                                                                                    EOF
                                                                                                                    )" || failure 15634
                                                                                                                    export EXPECTED_RESOURCE=""
                                                                                                                    wrap \
                                                                                                                        ${ true-true } \
                                                                                                                        true-true \
                                                                                                                        0500 \
                                                                                                                        --literal plain 1 \
                                                                                                                        --literal plain 3 \
                                                                                                                        --inherit plain EXPECTED_COUNT \
                                                                                                                        --inherit plain EXPECTED_MESSAGES \
                                                                                                                        --inherit plain EXPECTED_RESOURCE \
                                                                                                                        --literal plain OBSERVED_COUNT \
                                                                                                                        --literal plain EXPECTED_MESSAGES \
                                                                                                                        --literal plain OBSERVED_RESOURCE \
                                                                                                                        --literal plain OUTFILE \
                                                                                                                        --inherit plain PATH \
                                                                                                                        --uuid 19713
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "gh" ] ;
                                                                        } ;
                                                                gh =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root wrap ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            gh =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "gh" ;
                                                                                                                                runtimeInputs = [ pkgs.gh ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        export GITHUB_TOKEN="$GITHUB_TOKEN"
                                                                                                                                        if [[ -t 0 ]]
                                                                                                                                        then
                                                                                                                                            gh "${ builtins.concatStringsSep "" [ "$" "{" "@:-" "}" ] }"
                                                                                                                                        else
                                                                                                                                            gh "${ builtins.concatStringsSep "" [ "$" "{" "@:-" "}" ] }" <&0
                                                                                                                                        fi
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/gh" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    GITHUB_TOKEN_DIR=${ resources.production.age.plaintext.github.token { failure = 25133 ; } }
                                                                                                                    GITHUB_TOKEN="$( cat "$GITHUB_TOKEN_DIR/plaintext" )" || failure 31678
                                                                                                                    export GITHUB_TOKEN
                                                                                                                    wrap ${ gh } gh 0500 --inherit plain GITHUB_TOKEN --inherit plain PATH --uuid 32407
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "gh" ] ;
                                                                        } ;
                                                                gpg =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root wrap ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            gpg =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "gpg" ;
                                                                                                                                runtimeInputs = [ pkgs.gnupg ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        export GNUPGHOME="$DOT_GNUPG"
                                                                                                                                        if [[ -t 0 ]]
                                                                                                                                        then
                                                                                                                                            gpg "${ builtins.concatStringsSep "" [ "$" "{" "@:-" "}" ] }"
                                                                                                                                        else
                                                                                                                                            "${ builtins.concatStringsSep "" [ "$" "{" "@:-" "}" ] }" <&0
                                                                                                                                        fi
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/gpg" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    DOT_GNUPG=${ resources.production.dot-gnupg { failure = 26516 ; } }
                                                                                                                    export DOT_GNUPG
                                                                                                                    gc-root "$DOT_GNUPG"
                                                                                                                    wrap \
                                                                                                                        ${ gpg } \
                                                                                                                        gpg \
                                                                                                                        0500 \
                                                                                                                        --inherit plain DOT_GNUPG \
                                                                                                                        --literal plain PATH \
                                                                                                                        --uuid 18224
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in  "${ application }/bin/init" ;
                                                                            targets = [ "gpg" ] ;
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
                                                                                                    runtimeInputs = [ wrap ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            secrets =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "secrets" ;
                                                                                                                                runtimeInputs = [ failure pkgs.coreutils pkgs.git pkgs.less pkgs.nano ] ;
                                                                                                                                text =
                                                                                                                                    let
                                                                                                                                        cases =
                                                                                                                                            _visitor.implementation
                                                                                                                                                {
                                                                                                                                                    lambda =
                                                                                                                                                        path : value :
                                                                                                                                                            [
                                                                                                                                                                ''
                                                                                                                                                                    '${ builtins.toJSON path }')
                                                                                                                                                                        VALUE="$2"
                                                                                                                                                                        RESOURCE=${ value { failure = 19833 ; } }
                                                                                                                                                                        echo true > "$RESOURCE/flag"
                                                                                                                                                                        chmod 0600 "$RESOURCE/plaintext"
                                                                                                                                                                        echo "$VALUE" > "$RESOURCE/plaintext"
                                                                                                                                                                        chmod 0400 "$RESOURCE/plaintext"
                                                                                                                                                                        shift 2
                                                                                                                                                                        echo "VALUE=$VALUE" "RESOURCE=$RESOURCE"
                                                                                                                                                                        ;;
                                                                                                                                                                ''
                                                                                                                                                            ] ;
                                                                                                                                                    list = path : list : builtins.concatLists list ;
                                                                                                                                                    set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                                                                                }
                                                                                                                                                resources.production.age.plaintext ;
                                                                                                                                        in
                                                                                                                                    ''
                                                                                                                                        : "${ builtins.concatStringsSep "" [ "$" "{" "DERIVATION:?must be exported" "}" ] }"
                                                                                                                                        MESSAGE="$1"
                                                                                                                                        shift
                                                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                                                        do
                                                                                                                                            case "$1" in
                                                                                                                                                ${ builtins.concatStringsSep "\n" cases }
                                                                                                                                                *)
                                                                                                                                                    failure 3842 "$*"
                                                                                                                                                    ;;
                                                                                                                                            esac
                                                                                                                                        done
                                                                                                                                        SECRETS=${ resources.production.age.ciphertext { failure = 144434 ; } }
                                                                                                                                        GIT_SSH_COMMAND_RESOURCE=${ resources.production.bin.ssh { failure = 10240 ; } }
                                                                                                                                        export GIT_SSH_COMMAND="$GIT_SSH_COMMAND_RESOURCE/ssh"
                                                                                                                                        git -C "$SECRETS" fetch ssh "${ config.personal.secrets.branch }"
                                                                                                                                        git -C "$SECRETS" switch -C "${ config.personal.secrets.branch }" ssh/"${ config.personal.secrets.branch }"
                                                                                                                                        git -C "$SECRETS" diff --name-only
                                                                                                                                        git -C "$SECRETS" commit --allow-empty -am "$MESSAGE"
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/secrets" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    wrap \
                                                                                                                        ${ secrets } \
                                                                                                                        secrets \
                                                                                                                        0500 \
                                                                                                                        --literal plain DERIVATION \
                                                                                                                        --literal brace "DERIVATION:?must be exported" \
                                                                                                                        --literal plain GIT_SSH_COMMAND_RESOURCE \
                                                                                                                        --literal plain GIT_SSH_COMMAND \
                                                                                                                        --literal plain MESSAGE \
                                                                                                                        --literal plain PATH \
                                                                                                                        --literal plain RESOURCE \
                                                                                                                        --literal plain SECRETS \
                                                                                                                        --literal plain VALUE \
                                                                                                                        --uuid 7100
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "secrets" ] ;
                                                                        } ;
                                                                ssh =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root wrap ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            ssh =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "ssh" ;
                                                                                                                                runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        if [[ -t 0 ]]
                                                                                                                                        then
                                                                                                                                            ssh -F "$DOT_SSH/config" "$@"
                                                                                                                                        else
                                                                                                                                            ssh -F "$DOT_SSH/config" "$@" <&0
                                                                                                                                        fi
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/ssh" ;
                                                                                                        in
                                                                                                            ''
                                                                                                                DOT_SSH=${ resources.production.dot-ssh.config { failure = 15989 ; } }
                                                                                                                export DOT_SSH
                                                                                                                gc-root "$DOT_SSH"
                                                                                                                wrap \
                                                                                                                    ${ ssh } \
                                                                                                                    ssh \
                                                                                                                    0500 \
                                                                                                                    --literal plain @ \
                                                                                                                    --inherit plain DOT_SSH \
                                                                                                                    --literal plain PATH \
                                                                                                                    --uuid 30907
                                                                                                            '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "ssh" ] ;
                                                                        } ;
                                                            } ;
                                                        checks =
                                                            {
                                                                true-true =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ pkgs.gnupg ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            release =
                                                                                { failure , pkgs , resources , seed , sequential , trace } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "release" ;
                                                                                                    runtimeInputs = [ pkgs.gnupg ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/release" ;
                                                                            targets = [ ] ;
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
                                                                                            runtimeInputs = [ pkgs.gnupg ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    export GNUPGHOME=/mount
                                                                                                    SECRET_KEYS=${ resources.production.age.plaintext.dot-gnupg.secret-keys { failure = 31633 ; } }
                                                                                                    gpg --batch --yes --homedir "$GNUPGHOME" --import "$SECRET_KEYS/plaintext" 2>&1
                                                                                                    OWNERTRUST=${ resources.production.age.plaintext.dot-gnupg.ownertrust { failure = 15072 ; } }
                                                                                                    gpg --batch --yes --homedir "$GNUPGHOME" --import-ownertrust "$OWNERTRUST/plaintext" 2>&1
                                                                                                    gpg --batch --yes --homedir "$GNUPGHOME" --update-trustdb 2>&1
                                                                                                    rm --force "$GNUPGHOME"/*~
                                                                                                    chmod 0700 "$GNUPGHOME"
                                                                                                '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/init" ;
                                                                    targets = [ "private-keys-v1.d" "pubring.kbx" "trustdb.gpg" ] ;
                                                                } ;
                                                        dot-ssh =
                                                            {
                                                                config =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root trace wrap ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            config =
                                                                                                                builtins.toFile
                                                                                                                    "config"
                                                                                                                    ''
                                                                                                                        Host github.com
                                                                                                                            ControlMaster auto
                                                                                                                            ControlPath $GITHUB_CONTROL_PATH%C
                                                                                                                            ControlPersist 5m
                                                                                                                            HostName github.com
                                                                                                                            IdentityFile $GITHUB_IDENTITY_FILE
                                                                                                                            StrictHostKeyChecking yes
                                                                                                                            User git
                                                                                                                            UserKnownHostsFile $GITHUB_KNOWN_HOSTS
                                                                                                                        Host mobile
                                                                                                                            ControlMaster auto
                                                                                                                            ControlPath $MOBILE_CONTROL_PATH/%C
                                                                                                                            ControlPersist 5m
                                                                                                                            HostName 192.168.1.192
                                                                                                                            IdentityFile $MOBILE_IDENTITY_FILE
                                                                                                                            Port 8022
                                                                                                                            StrictHostKeyChecking yes
                                                                                                                            User git
                                                                                                                            UserKnownHostsFile $MOBILE_KNOWN_HOSTS
                                                                                                                    '' ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    trace 22520
                                                                                                                    GITHUB_CONTROL_PATH=${ resources.production.dot-ssh.control-path.github { failure = 12555 ; } }
                                                                                                                    trace 25834 "GITHUB_CONTROL_PATH=$GITHUB_CONTROL_PATH"
                                                                                                                    gc-root "$GITHUB_CONTROL_PATH"
                                                                                                                    trace 27831
                                                                                                                    export GITHUB_CONTROL_PATH
                                                                                                                    trace 32106
                                                                                                                    GITHUB_IDENTITY_RESOURCE=${ resources.production.age.plaintext.dot-ssh.github.identity { failure = 21662 ; } }
                                                                                                                    trace 7105
                                                                                                                    gc-root "$GITHUB_IDENTITY_RESOURCE"
                                                                                                                    export GITHUB_IDENTITY_FILE="$GITHUB_IDENTITY_RESOURCE/plaintext"
                                                                                                                    GITHUB_KNOWN_RESOURCE=${ resources.production.age.plaintext.dot-ssh.github.known-hosts { failure = 15323 ; } }
                                                                                                                    gc-root "$GITHUB_KNOWN_RESOURCE"
                                                                                                                    export GITHUB_KNOWN_HOSTS="$GITHUB_KNOWN_RESOURCE/plaintext"
                                                                                                                    MOBILE_CONTROL_PATH=${ resources.production.dot-ssh.control-path.mobile { failure = 27748 ; } }
                                                                                                                    gc-root "$MOBILE_CONTROL_PATH"
                                                                                                                    export MOBILE_CONTROL_PATH
                                                                                                                    MOBILE_IDENTITY_RESOURCE=${ resources.production.age.plaintext.dot-ssh.mobile.identity { failure = 28142 ; } }
                                                                                                                    gc-root "$MOBILE_IDENTITY_RESOURCE"
                                                                                                                    export MOBILE_IDENTITY_FILE="$MOBILE_IDENTITY_RESOURCE/plaintext"
                                                                                                                    MOBILE_KNOWN_RESOURCE=${ resources.production.age.plaintext.dot-ssh.mobile.known-hosts { failure = 30122 ; } }
                                                                                                                    gc-root "$MOBILE_KNOWN_RESOURCE"
                                                                                                                    export MOBILE_KNOWN_HOSTS="$MOBILE_KNOWN_RESOURCE/plaintext"
                                                                                                                    wrap \
                                                                                                                        ${ config } \
                                                                                                                        config \
                                                                                                                        0400 \
                                                                                                                        --inherit plain GITHUB_CONTROL_PATH \
                                                                                                                        --inherit plain GITHUB_IDENTITY_FILE \
                                                                                                                        --inherit plain GITHUB_KNOWN_HOSTS \
                                                                                                                        --inherit plain MOBILE_CONTROL_PATH \
                                                                                                                        --inherit plain MOBILE_IDENTITY_FILE \
                                                                                                                        --inherit plain MOBILE_KNOWN_HOSTS \
                                                                                                                        --uuid 15122
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "config" ] ;
                                                                        } ;
                                                                    control-path =
                                                                        _visitor.implementation
                                                                            {
                                                                                null =
                                                                                    path : value : ignore :
                                                                                        {
                                                                                            init =
                                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "init" ;
                                                                                                                    text = "" ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/init" ;
                                                                                            targets = [ ] ;
                                                                                        } ;
                                                                            }
                                                                            {
                                                                                github = null ;
                                                                                mobile = null ;
                                                                            } ;
                                                                } ;
                                                            pad =
                                                                let
                                                                    pad =
                                                                        products : ignore :
                                                                            {
                                                                                depth = 1 ;
                                                                                init =
                                                                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ gc-root wrap ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                declarations =
                                                                                                                    _visitor.implementation
                                                                                                                        {
                                                                                                                            list = path : list : builtins.concatLists list ;
                                                                                                                            set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                                                            string =
                                                                                                                                path : value :
                                                                                                                                    [
                                                                                                                                        ''PRODUCT_${ builtins.hashString "sha512" ( builtins.toJSON path ) }=${ value }''
                                                                                                                                        ''gc-root "$PRODUCT_${ builtins.hashString "sha512" ( builtins.toJSON path ) }"''
                                                                                                                                    ] ;
                                                                                                                        }
                                                                                                                        products ;
                                                                                                                envrc =
                                                                                                                    let
                                                                                                                        application =
                                                                                                                           pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "envrc" ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            export PATH=$BIN_PATH
                                                                                                                                            # shellcheck disable=SC2153
                                                                                                                                            export MANPATH=$MAN_PATH
                                                                                                                                        '' ;
                                                                                                                                } ;
                                                                                                                        in "${ application }/bin/envrc" ;
                                                                                                                variables =
                                                                                                                    _visitor.implementation
                                                                                                                        {
                                                                                                                            list = path : list : builtins.concatLists list ;
                                                                                                                            set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                                                            string = path : value : ''PRODUCT_${ builtins.hashString "sha512" ( builtins.toJSON path ) }'' ;
                                                                                                                        }
                                                                                                                        products ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        ${ builtins.concatStringsSep "\n" declarations }
                                                                                                                        BIN_PATH="${ builtins.concatStringSep ":" ( builtins.map ( v : "${ builtins.concatStringsSep "" [ "$" v "/bin" ] }" ) variables ) }"
                                                                                                                        MAN_PATH="${ builtins.concatStringSep ":" ( builtins.map ( v : "${ builtins.concatStringsSep "" [ "$" v "/bin" ] }" ) variables ) }"
                                                                                                                        wrap ${ envrc } .envrc 0400 --inherit plain BIN_PATH --inherit plain MAN_PATH --uuid 24177
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ ".envrc" ] ;
                                                                            } ;
                                                                    in
                                                                        {
                                                                            checks =
                                                                                ignore :
                                                                                    {
                                                                                        depth = 1 ;
                                                                                        init =
                                                                                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "init" ;
                                                                                                                runtimeInputs = [ gc-root wrap ] ;
                                                                                                                text =
                                                                                                                    let
                                                                                                                        envrc =
                                                                                                                            let
                                                                                                                                application =
                                                                                                                                   pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "envrc" ;
                                                                                                                                            text =
                                                                                                                                                ''
                                                                                                                                                    export PATH=$BIN_PATH
                                                                                                                                                    # shellcheck disable=SC2153
                                                                                                                                                    export MANPATH=$MAN_PATH
                                                                                                                                                '' ;
                                                                                                                                        } ;
                                                                                                                                in "${ application }/bin/envrc" ;
                                                                                                                        in
                                                                                                                            ''
                                                                                                                                CHECKS=${ resources.production.product.checks { failure = 23739 ; } }
                                                                                                                                gc-root "$CHECKS"
                                                                                                                                export BIN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/bin" ) [ "$CHECKS" ] ) }
                                                                                                                                export MAN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/share/man" ) [ "$CHECKS" ] ) }
                                                                                                                                wrap ${ envrc } .envrc 0400 --inherit plain BIN_PATH --inherit plain MAN_PATH --uuid 24290
                                                                                                                            '' ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/init" ;
                                                                                        targets = [ ".envrc" ] ;
                                                                                    } ;
                                                                            home =
                                                                                ignore :
                                                                                    {
                                                                                        depth = 1 ;
                                                                                        init =
                                                                                            { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                                let
                                                                                                    application =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "init" ;
                                                                                                                runtimeInputs = [ gc-root wrap ] ;
                                                                                                                text =
                                                                                                                    let
                                                                                                                        envrc =
                                                                                                                            let
                                                                                                                                application =
                                                                                                                                   pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "envrc" ;
                                                                                                                                            text =
                                                                                                                                                ''
                                                                                                                                                    export PATH=$BIN_PATH
                                                                                                                                                    # shellcheck disable=SC2153
                                                                                                                                                    export MANPATH=$MAN_PATH
                                                                                                                                                '' ;
                                                                                                                                        } ;
                                                                                                                                in "${ application }/bin/envrc" ;
                                                                                                                        in
                                                                                                                            ''
                                                                                                                                GH=${ resources.production.product.gh { failure = 11371 ; } }
                                                                                                                                gc-root "$GH"
                                                                                                                                GPG=${ resources.production.product.gpg { failure = 16451 ; } }
                                                                                                                                gc-root "$GPG"
                                                                                                                                SECRETS=${ resources.production.product.secrets { failure = 22181 ; } }
                                                                                                                                gc-root "$SECRETS"
                                                                                                                                SSH=${ resources.production.product.ssh { failure = 11121 ; } }
                                                                                                                                gc-root "$SSH"
                                                                                                                                export BIN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/bin" ) [ "$GH" "$GPG" "$SECRETS" "$SSH" ] ) }
                                                                                                                                export MAN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/share/man" ) [ "$GH" "$GPG" "$SECRETS" "$SSH" ] ) }
                                                                                                                                wrap ${ envrc } .envrc 0400 --inherit plain BIN_PATH --inherit plain MAN_PATH --uuid 30754
                                                                                                                            '' ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/init" ;
                                                                                        targets = [ ".envrc" ] ;
                                                                                    } ;
                                                                } ;
                                                        product =
                                                            {
                                                                checks =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            BIN=${ resources.production.bin.checks { failure = 10519 ; } }
                                                                                                            gc-root "$BIN"
                                                                                                            ln --symbolic "$BIN" /mount/bin
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "bin" ] ;
                                                                        } ;
                                                                gh =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            BIN=${ resources.production.bin.gh { failure = 28930 ; } }
                                                                                                            gc-root "$BIN"
                                                                                                            ln --symbolic "$BIN" /mount/bin
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "bin" ] ;
                                                                        } ;
                                                                gpg =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            BIN=${ resources.production.bin.gpg { failure = 24435 ; } }
                                                                                                            gc-root "$BIN"
                                                                                                            ln --symbolic "$BIN" /mount/bin
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "bin" ] ;
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
                                                                                                    runtimeInputs = [ gc-root pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            BIN=${ resources.production.bin.secrets { failure = 16295 ; } }
                                                                                                            gc-root "$BIN"
                                                                                                            ln --symbolic "$BIN" /mount/bin
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "bin" ] ;
                                                                        } ;
                                                                ssh =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ gc-root pkgs.coreutils ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            BIN=${ resources.production.bin.ssh { failure = 18929 ; } }
                                                                                                            gc-root "$BIN"
                                                                                                            ln --symbolic "$BIN" /mount/bin
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "bin" ] ;
                                                                        } ;
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
                                                                        DERIVATION = derivation ;
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
                                                                        resource =
                                                                            {
                                                                                after = [ "network.target" "redis.service" ] ;
                                                                                requires = [ "redis.service" ] ;
                                                                                serviceConfig =
                                                                                    let
                                                                                        clean =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "clean" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.findutils pkgs.inotify-tools] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            if [[ -d /home/${ config.personal.name }/resources/release ]]
                                                                                                            then
                                                                                                                find /home/${ config.personal.name }/resources/release -mindepth 1 -type f | sort | while read -r FILE
                                                                                                                do
                                                                                                                    nohup "$FILE" &
                                                                                                                done
                                                                                                                find /home/${ config.personal.name }/resources/release -mindepth 1 -type f -exec inotifywait --event delete-self {} \;
                                                                                                            fi
                                                                                                            mkdir --parents /home/${config.personal.name}/resources/canonical /home/${config.personal.name}/resources/quarantine.init /home/${config.personal.name}/resources/quarantine.release
                                                                                                            mapfile -t PROBLEMS < <( find /home/${config.personal.name}/resources/canonical /home/${config.personal.name}/resources/quarantine.init /home/${config.personal.name}/resources/quarantine.release -mindepth 1 -type f | sort )
                                                                                                            if [[ "${ builtins.concatStringsSep "" [ "$" "{" "#PROBLEMS[@]" "}" ] }" -gt 0 ]]
                                                                                                            then
                                                                                                                failure "${ builtins.concatStringsSep "" [ "$" "{" "PROBLEMS[@]" "}" ] }"
                                                                                                            else
                                                                                                                ARCHIVE="$( mktemp --dry-run --suffix ".tar.xz" )" || failure 22413
                                                                                                                tar --create --xz --file "$ARCHIVE" /home/${ config.personal.name }/.gcroot /home/${ config.personal.name }/resources
                                                                                                                rm --recursive --force /home/${ config.personal.name }/.gcroot /home/${ config.personal.name }/resources
                                                                                                            fi
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in
                                                                                            {
                                                                                                ExecPreStart = "${ clean }/bin/clean" ;
                                                                                                ExecStart =
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "ExecStart" ;
                                                                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            sleep inf
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/ExecStart" ;
                                                                                                ExecStop =
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "ExecStop" ;
                                                                                                                    runtimeInputs = [ clean pkgs.nix ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            clean
                                                                                                                            nix-collect-garbage
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/ExecStop" ;
                                                                                                RemainAfterExit = true;
                                                                                                User = config.personal.name ;
                                                                                            } ;
                                                                                wantedBy = [ "multi-user.target" ] ;
                                                                            } ;
                                                                        resource-logger =
                                                                            {
                                                                                after = [ "network.target" "redis.service" "resource.service" ] ;
                                                                                requires = [ "redis.service" "resource.service" ] ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "ExecStart" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.jq pkgs.redis pkgs.yq-go ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    failure ( ) {
                                                                                                                        echo "$1" >&2
                                                                                                                        exit 64
                                                                                                                    }
                                                                                                                    redis-cli SUBSCRIBE stale-init valid-init valid-release invalid-init invalid-release | while read -r TYPE  && read -r CHANNEL && read -r PAYLOAD
                                                                                                                    do
                                                                                                                        echo "TYPE=$TYPE" "CHANNEL=$CHANNEL" "PAYLOAD=$PAYLOAD"
                                                                                                                        if [[ "$TYPE" == "message" ]]
                                                                                                                        then
                                                                                                                            SCRIPT_FILE="$( jq --raw-output '."script-file" // empty' "$PAYLOAD" )" || failure 14571
                                                                                                                            STAMP="$( date +%s )" || failure 7521
                                                                                                                            STANDARD_ERROR_FILE="$( jq --raw-output '."standard-error-file" // empty' "$PAYLOAD" )" || failure 18867
                                                                                                                            STANDARD_INPUT_FILE="$( jq --raw-output '."standard-input-file" // empty' "$PAYLOAD" )" || failure 7805
                                                                                                                            STANDARD_OUTPUT_FILE="$( jq --raw-output '."standard-output-file" // empty' "$PAYLOAD" )" || failure 31273
                                                                                                                            mkdir --parents "/home/${ config.personal.name }/resources/logs"
                                                                                                                            jq \
                                                                                                                                --arg CHANNEL "$CHANNEL" \
                                                                                                                                --rawfile SCRIPT "${ builtins.concatStringsSep "" [ "$" "{" "SCRIPT_FILE:-/dev/null" "}" ] }" \
                                                                                                                                --argjson STAMP "$STAMP" \
                                                                                                                                --rawfile STANDARD_ERROR "${ builtins.concatStringsSep "" [ "$" "{" "STANDARD_ERROR_FILE:-/dev/null" "}" ] }" \
                                                                                                                                --rawfile STANDARD_INPUT "${ builtins.concatStringsSep "" [ "$" "{" "STANDARD_INPUT_FILE:-/dev/null" "}" ] }" \
                                                                                                                                --rawfile STANDARD_OUTPUT "${ builtins.concatStringsSep "" [ "$" "{" "STANDARD_OUTPUT_FILE:-/dev/null" "}" ] }" \
                                                                                                                                '
                                                                                                                                .["channel"] = $CHANNEL
                                                                                                                                |
                                                                                                                                (if has("script-file") then del(."script-file") | .["script"] = $SCRIPT else . end)
                                                                                                                                |
                                                                                                                                .["stamp"] = $STAMP
                                                                                                                                |
                                                                                                                                (if has("standard-error-file") then del(."standard-error-file") | .["standard-error"] = $STANDARD_ERROR else . end)
                                                                                                                                |
                                                                                                                                (if has("standard-input-file") then del(."standard-input-file") | .["standard-input"] = $STANDARD_INPUT else . end)
                                                                                                                                |
                                                                                                                                (if has("standard-output-file") then del(."standard-output-file") | .["standard-output"] = $STANDARD_OUTPUT else . end)
                                                                                                                                ' "$PAYLOAD" \
                                                                                                                                | yq eval --prettyPrint '[.]' >> "/home/${ config.personal.name }/resources/logs/log.yaml" || failure 31275
                                                                                                                        fi
                                                                                                                    done
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/ExecStart" ;
                                                                                        ExecStop = "/run/current-system/sw/bin/nix-collect-garbage" ;
                                                                                        RemainAfterExit = true ;
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ] ;
                                                                            } ;
                                                                        resource-releaser =
                                                                            {
                                                                                after = [ "network.target" "redis.service" "resource.service" ] ;
                                                                                requires = [ "redis.service" "resource.service" ] ;
                                                                                description =
                                                                                    ''
                                                                                        Releases the resources
                                                                                    '' ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "ExecStart" ;
                                                                                                            runtimeInputs =
                                                                                                                [
                                                                                                                    (
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "iteration" ;
                                                                                                                                runtimeInputs = [ pkgs.bash pkgs.coreutils pkgs.jq ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        TYPE="$1"
                                                                                                                                        CHANNEL="$2"
                                                                                                                                        PAYLOAD="$3"
                                                                                                                                        failure ( ) {
                                                                                                                                            echo "$2" >&2
                                                                                                                                            exit 64
                                                                                                                                        }
                                                                                                                                        if [[ "$TYPE" == "message" ]]
                                                                                                                                        then
                                                                                                                                            jq --raw-output "." "$PAYLOAD"
                                                                                                                                            RELEASE="$( jq --raw-output '."release" // empty' "$PAYLOAD" )" || failure 24568
                                                                                                                                            "$RELEASE"
                                                                                                                                        else
                                                                                                                                            echo "TYPE=$TYPE" "CHANNEL=$CHANNEL" "PAYLOAD=$PAYLOAD"
                                                                                                                                        fi
                                                                                                                                    '' ;
                                                                                                                            }
                                                                                                                    )
                                                                                                                    pkgs.redis
                                                                                                                ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    redis-cli SUBSCRIBE valid-init | while read -r TYPE  && read -r CHANNEL && read -r PAYLOAD
                                                                                                                    do
                                                                                                                        nohup iteration "$TYPE" "$CHANNEL" "$PAYLOAD" &
                                                                                                                    done
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                    in "${ application }/bin/ExecStart" ;
                                                                                        User = config.personal.name ;
                                                                                    } ;
                                                                                wantedBy = [ "multi-user.target" ] ;
                                                                            } ;
                                                                        purge-trace =
                                                                            {
                                                                                description =
                                                                                    ''
                                                                                        Purge the trace
                                                                                    '' ;
                                                                                serviceConfig =
                                                                                    {
                                                                                        ExecStart =
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "ExecStart" ;
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.flock ] ;
                                                                                                            text =
                                                                                                                ''
                                                                                                                    exec 203> /home/${ config.personal.name }/resources/trace.lock
                                                                                                                    flock -x 203
                                                                                                                    ARCHIVE="$( mktemp --suffix ".tar.xz" )" || exit 63
                                                                                                                    tar --create --file "$ARCHIVE" --remove-files /home/${ config.personal.name }/resources/logs/trace.log.yaml
                                                                                                                    rm /home/${ config.personal.name }/resources/trace.lock
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/ExecStart" ;
                                                                                    } ;
                                                                            } ;
                                                                    } ;
                                                                timers =
                                                                    {
                                                                        purge-trace =
                                                                            {
                                                                                enable = true ;
                                                                                timerConfig =
                                                                                    {
                                                                                        OnCalendar = "hourly" ;
                                                                                        Persistent = true ;
                                                                                    } ;
                                                                            } ;
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
                                                                                    name = "resource" ;
                                                                                    runtimeInputs = [ ] ;
                                                                                    text =
                                                                                        let
                                                                                            conditions =
                                                                                                builtins.concatLists
                                                                                                    [
                                                                                                        [
                                                                                                            ''
                                                                                                                if [[ "$#" -ne 2 ]]
                                                                                                                then
                                                                                                                    exit 99
                                                                                                            ''
                                                                                                        ]
                                                                                                        resource-conditions
                                                                                                        [
                                                                                                            ''
                                                                                                                else
                                                                                                                    exit 98
                                                                                                                fi
                                                                                                            ''
                                                                                                        ]
                                                                                                    ] ;
                                                                                            resource-conditions =
                                                                                                _visitor.implementation
                                                                                                    {
                                                                                                        lambda =
                                                                                                            path : value :
                                                                                                                [
                                                                                                                    ''
                                                                                                                        elif [[ "$2" == '${ builtins.toJSON path }' ]]
                                                                                                                        then
                                                                                                                            RESOURCE=${ value { setup = setup : ''${ setup } "${ builtins.concatStringsSep "" [ "$" "{" "ARGUMENTS[@]:-" "}" ] }"'' ; } }
                                                                                                                    ''
                                                                                                                ] ;
                                                                                                        list = path : list : builtins.concatLists list ;
                                                                                                        set = path : set : builtins.concatLists ( builtins.attrValues set ) ;
                                                                                                    }
                                                                                                    resources ;
                                                                                            in
                                                                                                ''
                                                                                                    export DERIVATION=${ derivation }
                                                                                                    ARGUMENTS=()
                                                                                                    while [[ "$#" -gt 0 ]]
                                                                                                    do
                                                                                                        case "$1" in
                                                                                                            --argument)
                                                                                                                ARGUMENTS+=( "$2" )
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            --resource)
                                                                                                                # shellcheck disable=SC2140,SC2016
                                                                                                                ${ builtins.concatStringsSep "\n" conditions }
                                                                                                                echo "$RESOURCE"
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            *)
                                                                                                                exit 64
                                                                                                        esac
                                                                                                    done
                                                                                                '' ;
                                                                                }
                                                                        )
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "archive-resources" ;
                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.gnutar pkgs.nix pkgs.zstd ] ;
                                                                                    text =
                                                                                        ''
                                                                                            ARCHIVE="$( mktemp --suffix ".tar.xz" )" || exit 63
                                                                                            tar --create --file "$ARCHIVE" --remove-files /home/${ config.personal.name }/.gc-roots /home/${ config.personal.name }/resources
                                                                                            nix-collect-garbage
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        pkgs.age
                                                                        pkgs.gh
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
                                                                                            FOOBAR=${ resources.foobar.pad { } }
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
                                private : testuser :
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
                                                            gc-root-directory = "/build/gc-root-directory" ;
                                                            resources = { } ;
                                                            resources-directory = "/build/resources" ;
                                                        } ;
                                                in
                                                    factory.check { expected = "/nix/store/4wk9h33c2yxy5sh5cxq1ih8ys62qfxb3-setup/bin/setup" ; mkDerivation = pkgs.stdenv.mkDerivation ; } ;
                                        resource-true-true =
                                            pkgs.nixosTest
                                                {
                                                    name = "resource-true-true" ;
                                                    nodes.machine =
                                                        { ... } :
                                                            {
                                                                imports = builtins.concatLists [ [ user ] private ] ;
                                                            } ;
                                                    testScript =
                                                        let
                                                            test =
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "test" ;
                                                                                runtimeInputs = [ ] ;
                                                                                text =
                                                                                    ''
                                                                                        PAD="$( resource --resource '["production","pad","checks"]' )"
                                                                                        cd "$PAD"
                                                                                        # shellcheck disable=SC1091
                                                                                        source .envrc
                                                                                        true-true
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ application }/bin/test" ;
                                                            in
                                                                ''
                                                                    machine.wait_for_unit("multi-user.target")
                                                                    machine.wait_for_unit("network-online.target")
                                                                    machine.succeed("runuser ${ testuser } -- ${ test }")
                                                                '' ;
                                                } ;
                                            # studio =
                                            #     pkgs.nixosTest
                                            #         {
                                            #             name = "studio" ;
                                            #             nodes.machine =
                                            #                 { pkgs , ... } :
                                            #                     {
                                            #                         imports = builtins.concatLists [ [ user ] private ] ;
                                            #                     } ;
                                            #             testScript =
                                            #                 let
                                            #                     test-script =
                                            #                         let
                                            #                             application =
                                            #                                 pkgs.writeShellApplication
                                            #                                     {
                                            #                                         name = "test-script" ;
                                            #                                         runtimeInputs = [ pkgs.coreutils pkgs.direnv ( _failure.implementation "59d475a8" ) ] ;
                                            #                                         text =
                                            #                                             ''
                                            #                                                 while [[ ! -f "config.personal.name/pads/checks/.envrc" ]]
                                            #                                                 do
                                            #                                                    echo f5e2d051 WAIT for .envrc >&2
                                            #                                                    sleep 1
                                            #                                                 done
                                            #                                                 cd "config.personal.name/pads/checks"
                                            #                                                 # shellcheck disable=SC1091
                                            #                                                 source "config.personal.name/pads/checks/.envrc"
                                            #                                                 if ! studio
                                            #                                                 then
                                            #                                                     cat "config.personal.name/resources/log/trace.log" >&2
                                            #                                                     exit 99
                                            #                                                 fi
                                            #                                             '' ;
                                            #                                     } ;
                                            #                             in "${ application }/bin/test-script" ;
                                            #                     in
                                            #                         ''
                                            #                             machine.wait_for_unit("multi-user.target")
                                            #                             machine.wait_for_unit("network-online.target")
                                            #                             machine.wait_until_succeeds("ping -c1 -w5 8.8.8.8")
                                            #                             machine.wait_until_succeeds("timeout 30s getent hosts github.com")
                                            #                             machine.succeed("runuser ${ testuser } -- ${ test-script }")
                                            #                         '' ;
                                            #         } ;
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
