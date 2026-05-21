# 2248574338742258
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
                                                                                                    "failure" : $FAILURE ,
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
                                                                resolutions =
                                                                    {
                                                                        ignore = null ;
                                                                        issue =
                                                                             { direction , failure , pkgs , resolve-path , resources , seed , sequential , trace } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "resolve" ;
                                                                                                runtimeInputs = [ ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                        do
                                                                                                            case "$1" in
                                                                                                                --title)
                                                                                                                    if [[ "$#" -lt 2 ]]
                                                                                                                    then
                                                                                                                        failure 23816
                                                                                                                    fi
                                                                                                                    TITLE="$2"
                                                                                                                    shift 2
                                                                                                                    ;;
                                                                                                                --body)
                                                                                                                    if [[ "$#" -lt 2 ]]
                                                                                                                    then
                                                                                                                        failure 7518
                                                                                                                    fi
                                                                                                                    BODY="$2"
                                                                                                                    shift 2
                                                                                                                    ;;
                                                                                                                *)
                                                                                                                    failure 10751 "$*"
                                                                                                                    ;;
                                                                                                            esac
                                                                                                        done
                                                                                                        TOKEN=${ resources.production.secrets.plaintext.github.token { failure = 6529 ; } }
                                                                                                        gh auth login --with-token < "$TOKEN/plaintext"
                                                                                                        gh issue create --title "$TITLE" --body "$BODY"
                                                                                                        gh auth logout
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/resolve" ;
                                                                    } ;
                                                                in
                                                                    factory.implementation
                                                                        {
                                                                            depth = r.depth or 0 ;
                                                                            init = r.init or null ;
                                                                            init-resolutions = r.init-resolutions or resolutions ;
                                                                            release = r.release or null ;
                                                                            release-resolutions = r.release-resolutions or resolutions ;
                                                                            seed = r.path or path ;
                                                                            targets = r.targets or [ ] ;
                                                                            transient = r.transient or false ;
                                                                        } ;
                                                }
                                                resources___ ;
                                        # the raw implementation
                                        resources___ =
                                            {
                                                checks =
                                                    {
                                                        script =
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
                                                                                                    alpha-condition =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "alpha-condition" ;
                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        echo "$1"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    alpha-stage =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "alpha-stage" ;
                                                                                                                runtimeInputs = [ alpha-condition compare failure init-condition pkgs.jq release-condition ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        compare --message subscribe --channel invalid-init --payload 1
                                                                                                                        compare --message subscribe --channel invalid-release --payload 2
                                                                                                                        compare --message subscribe --channel valid-init --payload 3
                                                                                                                        compare --message subscribe --channel valid-release --payload 4
                                                                                                                        ALPHA_CONDITION="$( alpha-condition ${ arguments } )" || failure 14402
                                                                                                                        INIT_CONDITION="$( init-condition ${ arguments } )" || failure 7005
                                                                                                                        RELEASE_CONDITION="$( release-condition ${ arguments } )" || failure 17709
                                                                                                                        if [[ "$INIT_CONDITION" == "true" ]]
                                                                                                                        then
                                                                                                                            if [[ "$RELEASE_CONDITION" == "true" ]]
                                                                                                                            then
                                                                                                                                DISTRACTOR=${ resources.checks.targets.true.true { failure = 2829 ; } }
                                                                                                                            else
                                                                                                                                DISTRACTOR=${ resources.checks.targets.true.false { failure = 17544 ; } }
                                                                                                                            fi
                                                                                                                        else
                                                                                                                            if [[ "$RELEASE_CONDITION" == "true" ]]
                                                                                                                            then
                                                                                                                                if ! DISTRACTOR=${ resources.checks.targets.false.true { failure = 13074 ; } }
                                                                                                                                then
                                                                                                                                    failure 26505
                                                                                                                                fi
                                                                                                                            else
                                                                                                                                if ! DISTRACTOR=${ resources.checks.targets.false.false { failure = 27401 ; } }
                                                                                                                                then
                                                                                                                                    failure 22382
                                                                                                                                fi
                                                                                                                            fi
                                                                                                                        fi
                                                                                                                        DISTRACTOR_CHANNEL="$( distractor-channel ${ arguments } )" || failure 23974
                                                                                                                        jq \
                                                                                                                            --null-input \
                                                                                                                            '{
                                                                                                                            }' | compare --message message --channel "$CHANNEL" --payload --uuid 25555
                                                                                                                        if [[ "$INIT_CONDITION" == "false" ]]
                                                                                                                        then
                                                                                                                        jq \
                                                                                                                            --null-input \
                                                                                                                            '{
                                                                                                                            }' | compare --message message --channel "$CHANNEL" --payload --uuid 7021
                                                                                                                        fi
                                                                                                                        files \
                                                                                                                            --uuid 12121
                                                                                                                        block --timeout 1 --uuid 10525
                                                                                                                        echo "$ALPHA_CONDITION" "$DISTRACTOR" "$DISTRACTOR_CHANNEL"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    arguments = ''"${ builtins.concatStringsSep "" [ "$" "{" "@" "}" ] }"'' ;
                                                                                                    beta-stage =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "beta-stage" ;
                                                                                                                runtimeInputs = [ ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    block =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "block" ;
                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                                        do
                                                                                                                            case "$1" in
                                                                                                                                --timeout)
                                                                                                                                    TIMEOUT="$2"
                                                                                                                                    if [[ ! "$TIMEOUT" =~ ^-?[0-9]+$ ]]
                                                                                                                                    then
                                                                                                                                        failure ff4b2472e9efae44 "$TIMEOUT"
                                                                                                                                    fi
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --uuid)
                                                                                                                                    UUID="$2"
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                *)
                                                                                                                                    failure 6734766152668717 "$*"
                                                                                                                                    ;;
                                                                                                                            esac
                                                                                                                        done
                                                                                                                        if [[ -z "$TIMEOUT" ]]
                                                                                                                        then
                                                                                                                            failure 7269648125756695
                                                                                                                        fi
                                                                                                                        if [[ -z "$UUID" ]]
                                                                                                                        then
                                                                                                                            failure 1535338844795893
                                                                                                                        fi
                                                                                                                        if timeout "$TIMEOUT" read -r -u 3
                                                                                                                        then
                                                                                                                            failure 7951884354751442 "We are not expecting a message but we got one anyway"
                                                                                                                        else
                                                                                                                            echo We are not expecting a message and we did not get one
                                                                                                                        fi
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    compare =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "compare" ;
                                                                                                                runtimeInputs = [ failure pkgs.coreutils pkgs.diffutils pkgs.jq pkgs.yq-go ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                                        do
                                                                                                                            case "$1" in
                                                                                                                                --channel)
                                                                                                                                    EXPECTED_CHANNEL="$2"
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --message)
                                                                                                                                    EXPECTED_MESSAGE="$2"
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --payload)
                                                                                                                                    if [[ -t 0 ]]
                                                                                                                                    then
                                                                                                                                        PAYLOAD_IS_JSON=false
                                                                                                                                        EXPECTED_PAYLOAD="$2"
                                                                                                                                        OBSERVED_PAYLOAD="$3"
                                                                                                                                        shift 3
                                                                                                                                    else
                                                                                                                                        PAYLOAD_IS_JSON=true
                                                                                                                                        EXPECTED_PAYLOAD="$( jq --compact-output "." )" || failure 32657
                                                                                                                                        OBSERVED_PAYLOAD="$2""
                                                                                                                                        shift 2
                                                                                                                                    fi
                                                                                                                                    ;;
                                                                                                                                --timeout)
                                                                                                                                    TIMEOUT="$2"
                                                                                                                                    shift 2
                                                                                                                                    if [[ ! "$TIMEOUT" =~ ^-?[0-9]+$ ]]
                                                                                                                                    then
                                                                                                                                        failure 1a9dadf7736235ea "$TIMEOUT"
                                                                                                                                    fi
                                                                                                                                    ;;
                                                                                                                                --uuid)
                                                                                                                                    UUID="$2"
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                *)
                                                                                                                                    failure 8175862286564631 "$*"
                                                                                                                                    ;;
                                                                                                                            esac
                                                                                                                        done
                                                                                                                        if [[ -z "$UUID" ]]
                                                                                                                        then
                                                                                                                            failure d597a2fab86c6288
                                                                                                                        fi
                                                                                                                        if [[ -z "$EXPECTED_CHANNEL" ]]
                                                                                                                        then
                                                                                                                            failure 9262853791516192 "$UUID"
                                                                                                                        fi
                                                                                                                        if [[ -z "$EXPECTED_MESSAGE" ]]
                                                                                                                        then
                                                                                                                            failure 9152341496876694 "$UUID"
                                                                                                                        fi
                                                                                                                        if [[ -z "$EXPECTED_PAYLOAD" ]]
                                                                                                                        then
                                                                                                                            failure 8569324665781814 "$UUID"
                                                                                                                        fi
                                                                                                                        if [[ -z "$PAYLOAD_IS_JSON" ]]
                                                                                                                        then
                                                                                                                            failure 9331276634154662 "$UUID"
                                                                                                                        fi
                                                                                                                        if [[ -z "$TIMEOUT" ]]
                                                                                                                        then
                                                                                                                            failure d855cf3f4d0854ec "$UUID"
                                                                                                                        fi
                                                                                                                        read -r -t "$TIMEOUT" -u 3 OBSERVED_MESSAGE || failure 8957413633575761 MESSAGE TIMEOUT "$TIMEOUT" UUID "$UUID"
                                                                                                                        read -r -t "$TIMEOUT" -u 3 OBSERVED_CHANNEL || failure 3194389162774953 CHANNEL TIMEOUT "$TIMEOUT" UUID "$UUID"
                                                                                                                        read -r -t "$TIMEOUT" -u 3 OBSERVED_PAYLOAD || failure 8294241659373935 PAYLOAD TIMEOUT "$TIMEOUT" UUID "$UUID"
                                                                                                                        if [[ "$EXPECTED_MESSAGE" != "$OBSERVED_MESSAGE" ]]
                                                                                                                        then
                                                                                                                            failure 9358462855663219 "$UUID" EXPECTED_MESSAGE "$EXPECTED_MESSAGE" OBSERVED_MESSAGE "$OBSERVED_MESSAGE"
                                                                                                                        fi
                                                                                                                        if [[ "$EXPECTED_CHANNEL" != "$OBSERVED_CHANNEL" ]]
                                                                                                                        then
                                                                                                                            failure 3246855689569956 "$UUID" EXPECTED_CHANNEL "$EXPECTED_CHANNEL" OBSERVED_CHANNEL "$OBSERVED_CHANNEL"
                                                                                                                        fi
                                                                                                                        if [[ "$PAYLOAD_IS_JSON" == "true" ]]
                                                                                                                        then
                                                                                                                            if [[ "$EXPECTED_PAYLOAD" != "$OBSERVED_PAYLOAD" ]]
                                                                                                                            then
                                                                                                                                EXPECTED_PRINT_PAYLOAD="$( yq --input-format=json eval --prettyPrint "." <<< "$EXPECTED_PAYLOAD" )" || failure 9695639117138292
                                                                                                                                echo "$OBSERVED_PAYLOAD" >&2
                                                                                                                                OBSERVED_PRINT_PAYLOAD="$( yq --input-format=json eval --prettyPrint "." <<< "$OBSERVED_PAYLOAD" )" || failure 3474923945839811 "$OBSERVED_PAYLOAD"
                                                                                                                                # EXPECTED_PRINT_PAYLOAD="$( printf '%q\n' "$EXPECTED_PAYLOAD" )" || failure 4118273929999765
                                                                                                                                # OBSERVED_PRINT_PAYLOAD="$( printf '%q\n' "$OBSERVED_PAYLOAD" )" || failure 6573627312252449
                                                                                                                                EXPECTED_FILE="$( mktemp )" || failure 1812352358347461
                                                                                                                                echo "$EXPECTED_PRINT_PAYLOAD" > "$EXPECTED_FILE"
                                                                                                                                OBSERVED_FILE="$( mktemp )" || failure
                                                                                                                                echo "$OBSERVED_PRINT_PAYLOAD" > "$OBSERVED_FILE"
                                                                                                                                DIFF="$( diff --unified "$EXPECTED_FILE" "$OBSERVED_FILE" )" || true
                                                                                                                                failure 2177767151764594 "$UUID" EXPECTED_PAYLOAD "$EXPECTED_PAYLOAD" OBSERVED_PAYLOAD "$OBSERVED_PAYLOAD" EXPECTED_PRINT_PAYLOAD "$EXPECTED_PRINT_PAYLOAD" OBSERVED_PRINT_PAYLOAD "$OBSERVED_PRINT_PAYLOAD" "" "" DIFF "$DIFF"
                                                                                                                            fi
                                                                                                                        else
                                                                                                                            if [[ "$EXPECTED_PAYLOAD" != "$OBSERVED_PAYLOAD" ]]
                                                                                                                            then
                                                                                                                                failure 2376349973447483 "$UUID" EXPECTED_PAYLOAD "$EXPECTED_PAYLOAD" OBSERVED_PAYLOAD "$OBSERVED_PAYLOAD"
                                                                                                                            fi
                                                                                                                        fi
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    distractor-channel-value =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "distractor-channel-value" ;
                                                                                                                runtimeInputs = [ failure init-condition ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        INIT_CONDITION="$( init-condition ${ arguments } )" || failure 20560
                                                                                                                        if [[ "$INIT_CONDITION" == "true" ]]
                                                                                                                        then
                                                                                                                            echo "valid-init"
                                                                                                                        else
                                                                                                                            echo "invalid-init"
                                                                                                                        fi
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    files =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "files" ;
                                                                                                                runtimeInputs =
                                                                                                                    [
                                                                                                                        (
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "ceiling" ;
                                                                                                                                    runtimeInputs =
                                                                                                                                        [
                                                                                                                                            (
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "ceiling" ;
                                                                                                                                                        runtimeInputs = [ failure pkgs.coreutils ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                FILE="$1"
                                                                                                                                                                INDEX="$2"
                                                                                                                                                                NAME="$( basename "$FILE" )" || failure 6413594228638844
                                                                                                                                                                if [[ "$NAME" > "$INDEX" ]]
                                                                                                                                                                then
                                                                                                                                                                    echo "$NAME"
                                                                                                                                                                fi
                                                                                                                                                            '' ;
                                                                                                                                                    }
                                                                                                                                            )
                                                                                                                                            failure
                                                                                                                                            pkgs.findutils
                                                                                                                                        ] ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            ROOT="$1"
                                                                                                                                            INDEX="$2"
                                                                                                                                            if [[ -d "$ROOT" ]]
                                                                                                                                            then
                                                                                                                                                ZERO="$( find "$ROOT" -type f -mindepth 1 -exec ceiling {} "$INDEX" \; )" || failure 7516122857653918 ROOT "$ROOT" INDEX "$INDEX"
                                                                                                                                                if [[ -n "$ZERO" ]]
                                                                                                                                                then
                                                                                                                                                    failure 4894458326934832 ROOT "$ROOT" INDEX "$INDEX" ZERO "$ZERO"
                                                                                                                                                fi
                                                                                                                                            fi
                                                                                                                                        '' ;
                                                                                                                                }
                                                                                                                        )
                                                                                                                        failure
                                                                                                                        pkgs.coreutils
                                                                                                                        pkgs.findutils
                                                                                                                    ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                                        do
                                                                                                                            case "$1" in
                                                                                                                                --ceiling)
                                                                                                                                    if [[ "$#" -lt 4 ]]
                                                                                                                                    then
                                                                                                                                        failure 6245698427752989 "$*"
                                                                                                                                    fi
                                                                                                                                    ALPHA="$2"
                                                                                                                                    BETA="$3"
                                                                                                                                    GAMMA="$4"
                                                                                                                                    DELTA=$(( ALPHA + BETA ))
                                                                                                                                    EPSILON=$(( ALPHA + GAMMA ))
                                                                                                                                    printf -v DELTA_PRIME "%016d" "$DELTA"
                                                                                                                                    printf -v EPSILON_PRIME "%016d" "$EPSILON"
                                                                                                                                    SEQUENTIAL="$( cat /home/${ config.personal.name }/resources/sequential/sequential.counter )" || failure 6923965577116329
                                                                                                                                    printf -v SEQUENTIAL_PRIME "%016d" "$SEQUENTIAL"
                                                                                                                                    if [[ "$EPSILON_PRIME" != "$SEQUENTIAL_PRIME" ]]
                                                                                                                                    then
                                                                                                                                        failure 1149448538394568 ALPHA "$ALPHA" BETA "$BETA" GAMMA "$GAMMA" DELTA "$DELTA" EPSILON "$EPSILON" DELTA_PRIME "$DELTA_PRIME" EPSILON_PRIME "$EPSILON_PRIME" SEQUENTIAL "$SEQUENTIAL" SEQUENTIAL "$SEQUENTIAL_PRIME" "$*"
                                                                                                                                    fi
                                                                                                                                    ceiling /home/${ config.personal.name }/mounts "$DELTA_PRIME"
                                                                                                                                    ceiling /home/${ config.personal.name }/release "$DELTA_PRIME"
                                                                                                                                    ceiling /home/${ config.personal.name }/invalid-init "$DELTA_PRIME"
                                                                                                                                    ceiling /home/${ config.personal.name }/invalid-release "$DELTA_PRIME"
                                                                                                                                    shift 4
                                                                                                                                    ;;
                                                                                                                                --does-not-exist)
                                                                                                                                    if [[ "$#" -lt 2 ]]
                                                                                                                                    then
                                                                                                                                        failure 2634964638877756 "$*"
                                                                                                                                    fi
                                                                                                                                    if [[ -e "$2" ]]
                                                                                                                                    then
                                                                                                                                        failure 3686358689564748 "$*"
                                                                                                                                    fi
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --equals)
                                                                                                                                    if [[ "$#" -lt 3 ]]
                                                                                                                                    then
                                                                                                                                        failure 4863349623889189 "$*"
                                                                                                                                    fi
                                                                                                                                    if [[ "$2" != "$3" ]]
                                                                                                                                    then
                                                                                                                                        failure 4889758824445288 "$*"
                                                                                                                                    fi
                                                                                                                                    shift 3
                                                                                                                                    ;;
                                                                                                                                --executable)
                                                                                                                                    if [[ "$#" -lt 2 ]]
                                                                                                                                    then
                                                                                                                                        failure 8646391832956534 "$*"
                                                                                                                                    fi
                                                                                                                                    if [[ ! -x "$2" ]]
                                                                                                                                    then
                                                                                                                                        failure 1578895953757495 "$*"
                                                                                                                                    fi
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --file)
                                                                                                                                    if [[ "$#" -lt 2 ]]
                                                                                                                                    then
                                                                                                                                        failure 4351941615743464 "$*"
                                                                                                                                    fi
                                                                                                                                    if [[ ! -f "$2" ]]
                                                                                                                                    then
                                                                                                                                        DIRECTORY="$( dirname "$2" )" || failure 13995
                                                                                                                                        find "$DIRECTORY" >&2
                                                                                                                                        failure 8859813773476672 "$*"
                                                                                                                                    fi
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --directory)
                                                                                                                                    if [[ "$#" -lt 2 ]]
                                                                                                                                    then
                                                                                                                                        failure 6663338412166177 "$*"
                                                                                                                                    fi
                                                                                                                                    if [[ ! -d "$2" ]]
                                                                                                                                    then
                                                                                                                                        failure 6552799518838238 "$*"
                                                                                                                                    fi
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                --not-equals)
                                                                                                                                    if [[ "$#" -lt 3 ]]
                                                                                                                                    then
                                                                                                                                        failure 8676529545266119 "$*"
                                                                                                                                    fi
                                                                                                                                    if [[ "$2" == "$3" ]]
                                                                                                                                    then
                                                                                                                                        failure 9371313715938914 "$*"
                                                                                                                                    fi
                                                                                                                                    shift 3
                                                                                                                                    ;;
                                                                                                                                --uuid)
                                                                                                                                    if [[ "$#" -lt 2 ]]
                                                                                                                                    then
                                                                                                                                        failure 8553559657979292 "$*"
                                                                                                                                    fi
                                                                                                                                    shift 2
                                                                                                                                    ;;
                                                                                                                                *)
                                                                                                                                    failure 6712481499337853 "$*"
                                                                                                                                    ;;
                                                                                                                            esac
                                                                                                                        done
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    init-condition =
                                                                                                         pkgs.writeShellApplication
                                                                                                             {
                                                                                                                 name = "init-condition" ;
                                                                                                                 runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                 text =
                                                                                                                     ''
                                                                                                                         echo "$2"
                                                                                                                     '' ;
                                                                                                             } ;
                                                                                                   release-condition =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "init-condition" ;
                                                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        echo "$3"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    scripts =
                                                                                                        {
                                                                                                            false =
                                                                                                                {
                                                                                                                    false =
                                                                                                                        {
                                                                                                                            init =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "init" ;
                                                                                                                                                text = "/nix/store/xpf9hr2bfzc7fs4qf1szr3dzswm7k4vv-init/bin/init" ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/init" ;
                                                                                                                            release =
                                                                                                                                ''
                                                                                                                                '' ;
                                                                                                                            resolve =
                                                                                                                                {
                                                                                                                                    init =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "init" ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                echo -en 7669863784911683
                                                                                                                                                                if [[ "$1" == 7482446721679967 ]]
                                                                                                                                                                then
                                                                                                                                                                    exit 208
                                                                                                                                                                elif [[ "$1" == 7151639144478587 ]]
                                                                                                                                                                then
                                                                                                                                                                    exit
                                                                                                                                                                else
                                                                                                                                                                    failure 6126927632687914 "$*"
                                                                                                                                                                fi'' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/init" ;
                                                                                                                                    release =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "release" ;
                                                                                                                                                        text = "/nix/store/pqhp7nlihwwy16vnfga1jpap8ml71hs6-release/bin/release" ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/release" ;
                                                                                                                                } ;
                                                                                                                        } ;
                                                                                                                    true =
                                                                                                                        {
                                                                                                                            init =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "init" ;
                                                                                                                                                text = "/nix/store/zp158z04y8a09cravpnxxc8lm37hnwiv-init/bin/init" ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/init" ;
                                                                                                                            release =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "release" ;
                                                                                                                                                text = "/nix/store/baqdlg538bdxj07hr8n72jlpcfjhdnws-release/bin/release" ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/release" ;
                                                                                                                            resolve =
                                                                                                                                {
                                                                                                                                    init =
                                                                                                                                        builtins.toFile
                                                                                                                                            "script"
                                                                                                                                            ''
                                                                                                                                                #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                set -o errexit
                                                                                                                                                set -o nounset
                                                                                                                                                set -o pipefail

                                                                                                                                                echo -en 7669863784911683
                                                                                                                                                if [[ "$1" == 9554464665854115 ]]
                                                                                                                                                then
                                                                                                                                                    exit 185
                                                                                                                                                elif [[ "$1" == 8363144534251594 ]]
                                                                                                                                                then
                                                                                                                                                    exit
                                                                                                                                                else
                                                                                                                                                    failure 6126927632687914 "$*"
                                                                                                                                                fi
                                                                                                                                            '' ;
                                                                                                                                } ;
                                                                                                                        } ;
                                                                                                                } ;
                                                                                                            true =
                                                                                                                {
                                                                                                                    false =
                                                                                                                        {
                                                                                                                            init =
                                                                                                                                builtins.toFile
                                                                                                                                    "script"
                                                                                                                                    ''
                                                                                                                                        #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                        set -o errexit
                                                                                                                                        set -o nounset
                                                                                                                                        set -o pipefail

                                                                                                                                        /nix/store/7l2i4v0ajggraxg79mwc0pqxlc8yhjcf-init/bin/init
                                                                                                                                    '' ;
                                                                                                                            release =
                                                                                                                                ''
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                    true =
                                                                                                                        {
                                                                                                                            init =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "init" ;
                                                                                                                                                text = "/nix/store/qfcw4rcx08yqnfjj7ndxhcqbi719z9m2-init/bin/init" ;
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
                                                                                                                                                        echo -en 7669863784911683q
                                                                                                                                                        if [[ "$1" == 7482446721679967 ]]
                                                                                                                                                        then
                                                                                                                                                            exit 208
                                                                                                                                                        elif [[ "$1" == 7151639144478587 ]]
                                                                                                                                                        then
                                                                                                                                                            exit
                                                                                                                                                        else
                                                                                                                                                            failure 6126927632687914 "$*"
                                                                                                                                                        fi
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/release" ;
                                                                                                                        } ;
                                                                                                                } ;
                                                                                                        } ;
                                                                                                    test =
                                                                                                        pkgs.writeShellApplication
                                                                                                            {
                                                                                                                name = "test" ;
                                                                                                                runtimeInputs = [ alpha-stage beta-stage pkgs.redis-cli ] ;
                                                                                                                text =
                                                                                                                    ''
                                                                                                                        exec 3< <( redis-cli SUBSCRIBE invalid-init invalid-release valid-init valid-release )
                                                                                                                        alpha-stage ${ arguments } <3
                                                                                                                        beta-stage ${ arguments } <3 &
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in
                                                                                                        ''
                                                                                                            wrap ${ test }/bin/test test 0500 --literal plain "@" --uuid 7483697565341694
                                                                                                        '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/init" ;
                                                                    targets = [ "test" ] ;
                                                                } ;
                                                        targets =
                                                            {
                                                                false =
                                                                    {
                                                                        false =
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
                                                                                                                    touch /mount/9427941488926681
                                                                                                                    echo -en "3346844943869582"
                                                                                                                    exit 117
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    init-resolutions =
                                                                                        {
                                                                                            ec36b9ba523f094d =
                                                                                                { direction , failure , pkgs , resolve-path , resources , seed , sequential , trace } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "resolve" ;
                                                                                                                    runtimeInputs = [ ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            echo -en 7669863784911683
                                                                                                                            if [[ "$1" == 7482446721679967 ]]
                                                                                                                            then
                                                                                                                                exit 208
                                                                                                                            elif [[ "$1" == 7151639144478587 ]]
                                                                                                                            then
                                                                                                                                exit
                                                                                                                            else
                                                                                                                                failure 6126927632687914 "$*"
                                                                                                                            fi''  ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/resolve" ;
                                                                                        } ;
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
                                                                                                                    echo -en "3299938456476225"
                                                                                                                    exit 169
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/release" ;
                                                                                    release-resolutions =
                                                                                        {
                                                                                            c5cd75e157ecd42b =
                                                                                                { direction , failure , pkgs , resolve-path , resources , seed , sequential , trace } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "resolve" ;
                                                                                                                    runtimeInputs = [ ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            echo -en 7876299368973293
                                                                                                                            if [[ "$1" == 4597174954562694 ]]
                                                                                                                            then
                                                                                                                                exit 111
                                                                                                                            elif [[ "$1" == 5998136478747541 ]]
                                                                                                                            then
                                                                                                                                exit 244
                                                                                                                            else
                                                                                                                                failure 7486835568334252 "$*"
                                                                                                                            fi''  ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/resolve" ;
                                                                                        } ;
                                                                                    targets = [ "9427941488926681" ] ;
                                                                                } ;
                                                                        true =
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
                                                                                                                    touch /mount/5494881573568661
                                                                                                                    echo -en "3148451947316331"
                                                                                                                    exit 114
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    init-resolutions =
                                                                                        {
                                                                                            d9aeea696dd06d63 =
                                                                                                { direction , failure , pkgs , resolve-path , resources , seed , sequential , trace } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "resolve" ;
                                                                                                                    runtimeInputs = [ ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            echo -en 7669863784911683
                                                                                                                            if [[ "$1" == 9554464665854115 ]]
                                                                                                                            then
                                                                                                                                exit 185
                                                                                                                            elif [[ "$1" == 8363144534251594 ]]
                                                                                                                            then
                                                                                                                                exit
                                                                                                                            else
                                                                                                                                failure 6126927632687914 "$*"
                                                                                                                            fi''  ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/resolve" ;
                                                                                        } ;
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
                                                                                                                    echo -en "4657737859987722"
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/release" ;
                                                                                    targets = [ "5494881573568661" ] ;
                                                                                } ;
                                                                    } ;
                                                                true =
                                                                    {
                                                                        false =
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
                                                                                                                    touch /mount/3297495737778474
                                                                                                                    echo -en "4725766637963872"
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
                                                                                                                    echo -en "6116634951182671"
                                                                                                                    exit 53
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ "3297495737778474" ] ;
                                                                                } ;
                                                                        true =
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
                                                                                                                    touch /mount/2862437261978116
                                                                                                                    echo -en 5175697994459272
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
                                                                                                                    echo -en 1954271241196411
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ "2862437261978116" ] ;
                                                                                } ;
                                                                    } ;
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
                                                                                                            echo -en "9346192144868518"
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
                                                                                                    echo -en "8364111457123239"
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
                                                        bin =
                                                            {
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
                                                                                                                    GITHUB_TOKEN_DIR=${ resources.production.secrets.plaintext.github.token { failure = 25133 ; } }
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
                                                                nonce =
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
                                                                                                            nonce =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "nonce" ;
                                                                                                                                runtimeInputs = [ failure pkgs.coreutils ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        BASE=10
                                                                                                                                        INPUT=
                                                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                                                        do
                                                                                                                                            case "$1" in
                                                                                                                                                --decimal)
                                                                                                                                                    BASE=10
                                                                                                                                                    shift
                                                                                                                                                    ;;
                                                                                                                                                --hexadecimal)
                                                                                                                                                    BASE=16
                                                                                                                                                    shift
                                                                                                                                                    ;;
                                                                                                                                                --input)
                                                                                                                                                    INPUT="$2"
                                                                                                                                                    shift 2
                                                                                                                                                    ;;
                                                                                                                                                *)
                                                                                                                                                    failure 8848222494314276 "$*"
                                                                                                                                            esac
                                                                                                                                        done
                                                                                                                                        if [[ -z "$INPUT" ]]
                                                                                                                                        then
                                                                                                                                            if [[ "$BASE" == 10 ]]
                                                                                                                                            then
                                                                                                                                                PREFIX="$( tr -dc '0-9' </dev/urandom | head -c 6 )" || failure 5936622335446384
                                                                                                                                            elif [[ "$BASE" == 16 ]]
                                                                                                                                            then
                                                                                                                                                PREFIX="$( tr -dc 'a-f' </dev/urandom | head -c 6 )" || failure 5535674693827615
                                                                                                                                            fi
                                                                                                                                            SUFFIX="$( tr -dc '0-9' </dev/urandom | head -c 6 )" || failure 4741951775161798
                                                                                                                                            echo "$PREFIX$SIGNATURE$SUFFIX"
                                                                                                                                        elif [[ "$#" == 1 ]]
                                                                                                                                        then
                                                                                                                                            INPUT="$1"
                                                                                                                                            grep --only-matching --extended-regexp '(^|[^0-9a-f])[0-9a-f]{16}([^0-9a-f]|$)' "$INPUT" | sort | uniq --repeated
                                                                                                                                        fi
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/nonce" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    export SIGNATURE=3383
                                                                                                                    wrap \
                                                                                                                        ${ nonce } \
                                                                                                                        nonce \
                                                                                                                        0500 \
                                                                                                                        --literal plain 1 \
                                                                                                                        --literal plain BASE \
                                                                                                                        --literal plain INPUT \
                                                                                                                        --inherit plain PREFIX \
                                                                                                                        --literal plain PATH \
                                                                                                                        --inherit plain SIGNATURE \
                                                                                                                        --literal plain SUFFIX \
                                                                                                                        --uuid 4741951780798554
                                                                                                                '' ;

                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "nonce" ] ;
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
                                                                                                                DOT_SSH=${ resources.production.dot-ssh { failure = 15989 ; } }
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
                                                                                                    SECRET_KEYS=${ resources.production.secrets.plaintext.dot-gnupg.secret-keys { failure = 31633 ; } }
                                                                                                    gpg --batch --yes --homedir "$GNUPGHOME" --import "$SECRET_KEYS/plaintext" 2>&1
                                                                                                    OWNERTRUST=${ resources.production.secrets.plaintext.dot-gnupg.ownertrust { failure = 15072 ; } }
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
                                                                                                            GITHUB_CONTROL_PATH=${ resources.production.temporary { failure = 12555 ; } }
                                                                                                            gc-root "$GITHUB_CONTROL_PATH"
                                                                                                            export GITHUB_CONTROL_PATH
                                                                                                            GITHUB_IDENTITY_RESOURCE=${ resources.production.secrets.plaintext.dot-ssh.github.identity { failure = 21662 ; } }
                                                                                                            gc-root "$GITHUB_IDENTITY_RESOURCE"
                                                                                                            export GITHUB_IDENTITY_FILE="$GITHUB_IDENTITY_RESOURCE/plaintext"
                                                                                                            GITHUB_KNOWN_RESOURCE=${ resources.production.secrets.plaintext.dot-ssh.github.known-hosts { failure = 15323 ; } }
                                                                                                            gc-root "$GITHUB_KNOWN_RESOURCE"
                                                                                                            export GITHUB_KNOWN_HOSTS="$GITHUB_KNOWN_RESOURCE/plaintext"
                                                                                                            MOBILE_CONTROL_PATH=${ resources.production.temporary { failure = 27748 ; } }
                                                                                                            gc-root "$MOBILE_CONTROL_PATH"
                                                                                                            export MOBILE_CONTROL_PATH
                                                                                                            MOBILE_IDENTITY_RESOURCE=${ resources.production.secrets.plaintext.dot-ssh.mobile.identity { failure = 28142 ; } }
                                                                                                            gc-root "$MOBILE_IDENTITY_RESOURCE"
                                                                                                            export MOBILE_IDENTITY_FILE="$MOBILE_IDENTITY_RESOURCE/plaintext"
                                                                                                            MOBILE_KNOWN_RESOURCE=${ resources.production.secrets.plaintext.dot-ssh.mobile.known-hosts { failure = 30122 ; } }
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
                                                                                                                            NONCE=${ resources.production.product.nonce { failure = 3193681222146392 ; } }
                                                                                                                            gc-root "$NONCE"
                                                                                                                            SSH=${ resources.production.product.ssh { failure = 11121 ; } }
                                                                                                                            gc-root "$SSH"
                                                                                                                            export BIN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/bin" ) [ "$GH" "$GPG" "$NONCE" "$SSH" ] ) }
                                                                                                                            export MAN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/share/man" ) [ "$GH" "$GPG" "$NONCE" "$SSH" ] ) }
                                                                                                                            wrap ${ envrc } .envrc 0400 --inherit plain BIN_PATH --inherit plain MAN_PATH --uuid 30754
                                                                                                                        '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    targets = [ ".envrc" ] ;
                                                                                } ;
                                                            } ;
                                                        private =
                                                            ignore :
                                                                {
                                                                    init =
                                                                        { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "init" ;
                                                                                            runtimeInputs = [ pkgs.git ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    git init 2>&1
                                                                                                    export GIT_SSH_COMMAND ${ resources.production.bin.ssh { failure = 14260 ; } }/bin/ssh
                                                                                                    git config core.sshCommand "$GIT_SSH_COMMAND"
                                                                                                    git config user.email ${ config.personal.repository.private.email }
                                                                                                    git config user.name ${ config.personal.repository.private.name }
                                                                                                    git remote add origin ${ config.personal.repository.private.remote } 2>&1
                                                                                                    git fetch origin ${ config.personal.repository.private.remote } 2>&1
                                                                                                '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/init" ;
                                                                    targets = [ ] ;
                                                                } ;
                                                        product =
                                                            {
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
                                                                nonce =
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
                                                                                                            BIN=${ resources.production.bin.nonce { failure = 4741951720755287 ; } }
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
                                                        secrets =
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
                                                                                                    runtimeInputs = [ pkgs.git ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            git init 2>&1
                                                                                                            git remote add https ${ config.personal.secrets.remotes.https } 2>&1
                                                                                                            git remote add ssh ${ config.personal.secrets.remotes.ssh } 2>&1
                                                                                                            git fetch https ${ config.personal.secrets.branch } 2>&1
                                                                                                            git checkout ${ config.personal.secrets.branch }
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ ] ;
                                                                        } ;
                                                                    plaintext =
                                                                        let
                                                                            decrypt =
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
                                                                                                                        SECRETS=${ resources.production.secrets.ciphertext { failure = 21253 ; } }
                                                                                                                        git -C "$SECRETS" fetch https ${ config.personal.secrets.branch }
                                                                                                                        git -C "SECRETS" checkout ${ config.personal.secrets.branch }
                                                                                                                        age --decrypt --identity ${ config.personal.agenix } --output /mount/plaintext "$SECRETS/${ builtins.concatStringsSep "/" seed }.asc.age"
                                                                                                                    '' ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/init" ;
                                                                                        target = [ "plaintext" ] ;
                                                                                    } ;
                                                                            in
                                                                                {
                                                                                    dot-gnupg =
                                                                                        {
                                                                                            ownertrust = decrypt ;
                                                                                            secret-keys = decrypt ;
                                                                                        } ;
                                                                                    dot-ssh =
                                                                                        {
                                                                                            github =
                                                                                                {
                                                                                                    identity =
                                                                                                        ignore :
                                                                                                            {
                                                                                                                init =
                                                                                                                    { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "init" ;
                                                                                                                                        runtimeInputs = [ ] ;
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
                                                                                                                                        runtimeInputs = [ ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                            in "${ application }/bin/release" ;
                                                                                                                targets = [ "plaintext" ] ;
                                                                                                            } ;
                                                                                                    known-hosts = decrypt ;
                                                                                                } ;
                                                                                            mobile =
                                                                                                {
                                                                                                    identity = decrypt ;
                                                                                                    known-hosts = decrypt ;
                                                                                                } ;
                                                                                        } ;
                                                                                    github =
                                                                                        {
                                                                                            token = decrypt ;
                                                                                        } ;
                                                                                } ;
                                                                } ;
                                                        temporary =
                                                            ignore :
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
                                                                            in ''${ application }/bin/init "${ builtins.concatStringsSep "" [ "$" "{" "@:-" "}" ] }"'' ;
                                                                    release =
                                                                        { failure , pkgs , resources , seed , sequential , trace } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "release" ;
                                                                                            text = "" ;
                                                                                        } ;
                                                                                in "${ application }/bin/release" ;
                                                                    targets = [ ] ;
                                                                    transient = true ;
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
                                                                                                                find /home/${ config.personal.name }/resources/release -mindepth 1 -type f -exec inotifywait --timeout 1 --event delete-self {} \;
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
                                                                                                            runtimeInputs =
                                                                                                                [
                                                                                                                    (
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "log" ;
                                                                                                                                runtimeInputs = [ pkgs.flock pkgs.jq ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        CHANNEL="$1"
                                                                                                                                        STAMP="$2"
                                                                                                                                        PAYLOAD="$3"
                                                                                                                                        TARGET="$4"
                                                                                                                                        exec 203> /home/${ config.personal.name }/resources/locks/log
                                                                                                                                        flock -x 203
                                                                                                                                        jq --arg CHANNEL "$CHANNEL" --argjson STAMP "$STAMP" '. + { "channel" : $CHANNEL , "stamp" : $STAMP }' <<< "$PAYLOAD" | yq eval --prettyPrint "[.]" >> "$TARGET"
                                                                                                                                    '' ;
                                                                                                                            }
                                                                                                                    )
                                                                                                                    pkgs.coreutils
                                                                                                                    pkgs.findutils
                                                                                                                    pkgs.flock
                                                                                                                    pkgs.jq
                                                                                                                    pkgs.redis
                                                                                                                    pkgs.yq-go
                                                                                                                ] ;
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
                                                                                                                            STAMP="$( date +%s )" || failure 4936565359496611
                                                                                                                            mkdir --parents /home/${ config.personal.name }/resources/locks
                                                                                                                            mkdir --parents /home/${ config.personal.name }/resources/logs
                                                                                                                            log "$CHANNEL" "$STAMP" "$PAYLOAD" /home/${ config.personal.name }/resources/logs/log.yaml
                                                                                                                            INDEX="$( jq --raw-output ".index" <<< "$PAYLOAD" )" || failure 6161227368692165
                                                                                                                            if [[ -d /home/${ config.personal.name }/resources/invalid-init ]]
                                                                                                                            then
                                                                                                                                find /home/${ config.personal.name }/resources/invalid-init | while read -r DIRECTORY
                                                                                                                                do
                                                                                                                                    NAME="$( basename "$DIRECTORY" )" || failure 7296472521871757
                                                                                                                                    if [[ "$INDEX" == "$NAME" ]]
                                                                                                                                    then
                                                                                                                                        log "$CHANNEL" "$STAMP" "$PAYLOAD" "$DIRECTORY/log.yaml"
                                                                                                                                    fi
                                                                                                                                done
                                                                                                                            fi
                                                                                                                            if [[ -d /home/${ config.personal.name }/resources/invalid-release ]]
                                                                                                                            then
                                                                                                                                find /home/${ config.personal.name }/resources/invalid-release -mindepth 1 -maxdepth 1 -type d | while read -r DIRECTORY
                                                                                                                                do
                                                                                                                                    NAME="$( basename "$DIRECTORY" )" || failure 6955924246161292
                                                                                                                                    if [[ "$INDEX" == "$NAME" ]]
                                                                                                                                    then
                                                                                                                                        log "$CHANNEL" "$STAMP" "$PAYLOAD" "$DIRECTORY/log.yaml"
                                                                                                                                    fi
                                                                                                                                done
                                                                                                                            fi
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
                                                                                                                                            INDEX="$( jq --raw-output '."index" // empty' <<< "$PAYLOAD" )" || failure 7423695352521722
                                                                                                                                            nohup "/home/${ config.personal.name }/resources/release/$INDEX" &
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
                                                                                                                            if [[ -n "$STANDARD_INPUT" ]]
                                                                                                                            then
                                                                                                                                #shellcheck disable=SC2068
                                                                                                                                RESOURCE=${ value { setup = setup : ''${ setup } ${ builtins.concatStringsSep "" [ "$" "{" "ARGUMENTS[@]:-" "}" ] } <<< "$STANDARD_INPUT"'' ; } }
                                                                                                                            elif [[ -n "$STANDARD_INPUT_FILE" ]]
                                                                                                                            then
                                                                                                                                #shellcheck disable=SC2068
                                                                                                                                RESOURCE=${ value { setup = setup : ''${ setup } ${ builtins.concatStringsSep "" [ "$" "{" "ARGUMENTS[@]:-" "}" ] } < "$STANDARD_INPUT_FILE"'' ; } }
                                                                                                                            elif [[ -t 0 ]]
                                                                                                                            then
                                                                                                                                #shellcheck disable=SC2068
                                                                                                                                RESOURCE=${ value { setup = setup : ''${ setup } ${ builtins.concatStringsSep "" [ "$" "{" "ARGUMENTS[@]:-" "}" ] }'' ; } }
                                                                                                                            else
                                                                                                                                #shellcheck disable=SC2068
                                                                                                                                RESOURCE=${ value { setup = setup : ''${ setup } ${ builtins.concatStringsSep "" [ "$" "{" "ARGUMENTS[@]:-" "}" ] } <&0'' ; } }
                                                                                                                            fi
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
                                                                                                    STANDARD_INPUT=
                                                                                                    STANDARD_INPUT_FILE=
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
                                                                                                            --standard-input)
                                                                                                                STANDARD_INPUT="$2"
                                                                                                                shift 2
                                                                                                                ;;
                                                                                                            --standard-input-file)
                                                                                                                STANDARD_INPUT_FILE="$2"
                                                                                                                if [[ ! -f "$STANDARD_INPUT_FILE" ]]
                                                                                                                then
                                                                                                                    failure 9545742882553268 "$STANDARD_INPUT_FILE"
                                                                                                                fi
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
                    in
                        {
                            checks =
                                private : testuser :
                                    {
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
                                                    factory.check { expected = "/nix/store/ayrqjrkz54hkjl2d79i4dqdmrb8q76a4-setup/bin/setup" ; mkDerivation = pkgs.stdenv.mkDerivation ; } ;
                                        resource--false-false =
                                            pkgs.nixosTest
                                                {
                                                    name = "resource-false-false" ;
                                                    nodes.machine = { ... } : { imports = builtins.concatLists [ [ user ] private ] ; } ;
                                                    testScript =
                                                        let
                                                            test =
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "test" ;
                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                text =
                                                                                    ''
                                                                                        SCRIPT="$( resource --resource '["checks","script"]' )"
                                                                                        timeout 1m "$SCRIPT/test" 6 false false
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ application }/bin/test" ;
                                                            in
                                                                ''
                                                                    machine.wait_for_unit("multi-user.target")
                                                                    machine.wait_for_unit("network-online.target")
                                                                    machine.succeed("runuser --login ${ testuser } -- ${ test }")
                                                                '' ;
                                                } ;
                                        resource--false-true =
                                            pkgs.nixosTest
                                                {
                                                    name = "resource-false-true" ;
                                                    nodes.machine = { ... } : { imports = builtins.concatLists [ [ user ] private ] ; } ;
                                                    testScript =
                                                        let
                                                            test =
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "test" ;
                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                text =
                                                                                    ''
                                                                                        SCRIPT="$( resource --resource '["checks","script"]' )"
                                                                                        timeout 1m "$SCRIPT/test" 6 true true
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ application }/bin/test" ;
                                                            in
                                                                ''
                                                                    machine.wait_for_unit("multi-user.target")
                                                                    machine.wait_for_unit("network-online.target")
                                                                    machine.succeed("runuser --login ${ testuser } -- ${ test }")
                                                                '' ;
                                                } ;
                                        resource--true-false =
                                            pkgs.nixosTest
                                                {
                                                    name = "resource-true-false" ;
                                                    nodes.machine = { ... } : { imports = builtins.concatLists [ [ user ] private ] ; } ;
                                                    testScript =
                                                        let
                                                            test =
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "test" ;
                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                text =
                                                                                    ''
                                                                                        SCRIPT="$( resource --resource '["checks","script"]' )"
                                                                                        timeout 1m "$SCRIPT/test" 6 true false
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ application }/bin/test" ;
                                                            in
                                                                ''
                                                                    machine.wait_for_unit("multi-user.target")
                                                                    machine.wait_for_unit("network-online.target")
                                                                    machine.succeed("runuser --login ${ testuser } -- ${ test }")
                                                                '' ;
                                                } ;
                                        resource--true-true =
                                            pkgs.nixosTest
                                                {
                                                    name = "resource-true-true" ;
                                                    nodes.machine = { ... } : { imports = builtins.concatLists [ [ user ] private ] ; } ;
                                                    testScript =
                                                        let
                                                            test =
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "test" ;
                                                                                runtimeInputs = [ pkgs.coreutils ] ;
                                                                                text =
                                                                                    ''
                                                                                        SCRIPT="$( resource --resource '["checks","script"]' )"
                                                                                        timeout 1m "$SCRIPT/test" 6 true true
                                                                                    '' ;
                                                                            } ;
                                                                    in "${ application }/bin/test" ;
                                                            in
                                                                ''
                                                                    machine.wait_for_unit("multi-user.target")
                                                                    machine.wait_for_unit("network-online.target")
                                                                    machine.succeed("runuser --login ${ testuser } -- ${ test }")
                                                                '' ;
                                                } ;
#                                            private = null ;
#                                            secrets = null ;
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
