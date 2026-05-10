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
                                                                                                                                    EXPECTED_PAYLOAD="$2"
                                                                                                                                    PAYLOAD_IS_JSON="$3"
                                                                                                                                    shift 3
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
                                                                                                                            EXPECTED_PAYLOAD="$( cat )" || failure 1393872535428486
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
                                                                                                    post-test =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "post-test" ;
                                                                                                                        runtimeInputs =
                                                                                                                            [
                                                                                                                                block
                                                                                                                                compare
                                                                                                                                failure
                                                                                                                                files
                                                                                                                                pkgs.coreutils
                                                                                                                                pkgs.redis
                                                                                                                                (
                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "pre-test" ;
                                                                                                                                            runtimeInputs = [ block compare failure files pkgs.coreutils pkgs.jq pkgs.redis ] ;
                                                                                                                                            text =
                                                                                                                                                let
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
                                                                                                                                                                                } ;
                                                                                                                                                                        } ;
                                                                                                                                                                    true =
                                                                                                                                                                        {
                                                                                                                                                                            init =
                                                                                                                                                                                builtins.toFile
                                                                                                                                                                                    "script"
                                                                                                                                                                                    ''
                                                                                                                                                                                        #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                                        set -o errexit
                                                                                                                                                                                        set -o nounset
                                                                                                                                                                                        set -o pipefail

                                                                                                                                                                                        /nix/store/zp158z04y8a09cravpnxxc8lm37hnwiv-init/bin/init
                                                                                                                                                                                    '' ;
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
                                                                                                                                                                                builtins.toFile
                                                                                                                                                                                    "script"
                                                                                                                                                                                    ''
                                                                                                                                                                                        #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                                        set -o errexit
                                                                                                                                                                                        set -o nounset
                                                                                                                                                                                        set -o pipefail

                                                                                                                                                                                        /nix/store/qfcw4rcx08yqnfjj7ndxhcqbi719z9m2-init/bin/init
                                                                                                                                                                                    '' ;
                                                                                                                                                                            release =
                                                                                                                                                                                let
                                                                                                                                                                                    application =
                                                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                                                            {
                                                                                                                                                                                                name = "release" ;
                                                                                                                                                                                                text =
                                                                                                                                                                                                    ''
                                                                                                                                                                                                        echo -en 7669863784911683q
                                                                                                                                                                                                        if [[ \"$1\" == 7482446721679967 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            exit 208
                                                                                                                                                                                                        elif [[ \"$1\" == 7151639144478587 ]]
                                                                                                                                                                                                        then
                                                                                                                                                                                                            exit
                                                                                                                                                                                                        else
                                                                                                                                                                                                            failure 6126927632687914 \"$*\"
                                                                                                                                                                                                        fi
                                                                                                                                                                                                    '' ;
                                                                                                                                                                                            } ;
                                                                                                                                                                                    in "${ application }/bin/release" ;
                                                                                                                                                                        } ;
                                                                                                                                                                } ;
                                                                                                                                                        } ;
                                                                                                                                                    in
                                                                                                                                                        ''
                                                                                                                                                            while [[ "$#" -gt 0 ]]
                                                                                                                                                            do
                                                                                                                                                                case "$1" in
                                                                                                                                                                    --alpha)
                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                        then
                                                                                                                                                                            failure 3253579886131153 "$*"
                                                                                                                                                                        fi
                                                                                                                                                                        ALPHA="$2"
                                                                                                                                                                        shift 2
                                                                                                                                                                        ;;
                                                                                                                                                                    --init)
                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                        then
                                                                                                                                                                            failure 7356781469476321 "$*"
                                                                                                                                                                        fi
                                                                                                                                                                        INIT="$2"
                                                                                                                                                                        if [[ "$INIT" != "true" ]] && [[ "$INIT" != "false" ]]
                                                                                                                                                                        then
                                                                                                                                                                            failure 6955793956212518 "$INIT"
                                                                                                                                                                        fi
                                                                                                                                                                        shift 2
                                                                                                                                                                        ;;
                                                                                                                                                                    --release)
                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                        then
                                                                                                                                                                            failure 6729112877839317 "$*"
                                                                                                                                                                        fi
                                                                                                                                                                        RELEASE="$2"
                                                                                                                                                                        if [[ "$RELEASE" != "true" ]] && [[ "$RELEASE" != "false" ]]
                                                                                                                                                                        then
                                                                                                                                                                            failure 7365993421498947 "$RELEASE"
                                                                                                                                                                        fi
                                                                                                                                                                        shift 2
                                                                                                                                                                        ;;
                                                                                                                                                                    --uuid)
                                                                                                                                                                        if [[ "$#" -lt 2 ]]
                                                                                                                                                                        then
                                                                                                                                                                            failure 6293418861389592 "$*"
                                                                                                                                                                        fi
                                                                                                                                                                        shift 2
                                                                                                                                                                        ;;
                                                                                                                                                                    *)
                                                                                                                                                                        failure 3186874731515892 "$*"
                                                                                                                                                                        ;;
                                                                                                                                                                esac
                                                                                                                                                            done
                                                                                                                                                            if [[ -z "$ALPHA" ]]
                                                                                                                                                            then
                                                                                                                                                                failure 2468219387197693
                                                                                                                                                            fi
                                                                                                                                                            if [[ ! "$ALPHA" =~ ^-?[0-9]+$ ]]
                                                                                                                                                            then
                                                                                                                                                                failure 3514254328772311
                                                                                                                                                            fi
                                                                                                                                                            if [[ -z "$INIT" ]]
                                                                                                                                                            then
                                                                                                                                                                failure 1871763771129953
                                                                                                                                                            fi
                                                                                                                                                            if [[ -z "$RELEASE" ]]
                                                                                                                                                            then
                                                                                                                                                                failure 4957596197169642
                                                                                                                                                            fi
                                                                                                                                                            block --timeout 1 --uuid 5984995243749875 3<&3
                                                                                                                                                            files \
                                                                                                                                                                --ceiling "$ALPHA" 0 2 \
                                                                                                                                                                --uuid 7299736113522788
                                                                                                                                                            if [[ "$INIT" == "true" ]]
                                                                                                                                                            then
                                                                                                                                                                if [[ "$RELEASE" == "true" ]]
                                                                                                                                                                then
                                                                                                                                                                    DISTRACTOR=${ resources.checks.targets.true.true { failure = 8829996994479772 ; setup = setup : ''${ setup } 3564731485791737'' ; } }
                                                                                                                                                                    printf -v DISTRACTOR_INDEX "%016d" $(( ALPHA + 4 ))
                                                                                                                                                                    STANDARD_OUTPUT=5175697994459272
                                                                                                                                                                    TARGET=2862437261978116
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg ARGUMENT 3564731485791737 \
                                                                                                                                                                        --arg INDEX "$DISTRACTOR_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.true.true.init } \
                                                                                                                                                                        --arg STANDARD_OUTPUT "$STANDARD_OUTPUT" \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ $ARGUMENT ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "seed" : [ "checks" , "targets" , "true" , "true" ] ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : $STANDARD_OUTPUT ,
                                                                                                                                                                               "status" : 0 ,
                                                                                                                                                                               "targets" : [ $TARGET ] ,
                                                                                                                                                                               "transient" : -1
                                                                                                                                                                            }' | compare --message message --channel valid-init --payload false true --timeout 1 --uuid 7689926124362862 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 6925921732651899 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 2 10 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$DISTRACTOR_INDEX" "$DISTRACTOR" \
                                                                                                                                                                        --directory "$DISTRACTOR" \
                                                                                                                                                                        --file "$DISTRACTOR/$TARGET" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/release/$DISTRACTOR_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$DISTRACTOR_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$DISTRACTOR_INDEX" \
                                                                                                                                                                        --uuid 6764498451529627
                                                                                                                                                                    echo We created a distractor resource
                                                                                                                                                                    FRESH=${ resources.checks.targets.true.true { failure = 3438984915657231 ; } }
                                                                                                                                                                    printf -v FRESH_INDEX "%016d" $(( ALPHA + 12 ))
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.true.true.init } \
                                                                                                                                                                        --arg STANDARD_OUTPUT "$STANDARD_OUTPUT" \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "seed" : [ "checks" , "targets" , "true" , "true" ] ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : $STANDARD_OUTPUT ,
                                                                                                                                                                               "status" : 0 ,
                                                                                                                                                                               "targets" : [ $TARGET ] ,
                                                                                                                                                                               "transient" : -1
                                                                                                                                                                            }' | compare --message message --channel valid-init --payload false true --timeout 1 --uuid 8535513643619133 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 7411277161553272 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 18 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --not-equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$DISTRACTOR" \
                                                                                                                                                                        --directory "$FRESH" \
                                                                                                                                                                        --file "$FRESH/$TARGET" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 9485816288686382
                                                                                                                                                                    echo We created a fresh resource
                                                                                                                                                                    STALE=${ resources.checks.targets.true.true { failure = 4599312279872888 ; } }
                                                                                                                                                                    block --timeout 1 --uuid 2497785224611422 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 19 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$STALE" \
                                                                                                                                                                        --equals "$STALE" "$FRESH" \
                                                                                                                                                                        --not-equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$DISTRACTOR" \
                                                                                                                                                                        --directory "$STALE" \
                                                                                                                                                                        --file "$STALE/$TARGET" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 5556886441562925
                                                                                                                                                                    echo We created a stale resource
                                                                                                                                                                else
                                                                                                                                                                    DISTRACTOR=${ resources.checks.targets.true.false { failure = 1965713756848597 ; setup = setup : ''${ setup } 2764421667212817'' ; } }
                                                                                                                                                                    printf -v DISTRACTOR_INDEX "%016d" $(( ALPHA + 4 ))
                                                                                                                                                                    STANDARD_OUTPUT=4725766637963872
                                                                                                                                                                    TARGET=3297495737778474
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg ARGUMENT 2764421667212817 \
                                                                                                                                                                        --arg INDEX "$DISTRACTOR_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.true.false.init } \
                                                                                                                                                                        --arg STANDARD_OUTPUT "$STANDARD_OUTPUT" \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ $ARGUMENT ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "seed" : [ "checks" , "targets" , "true" , "false" ] ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : $STANDARD_OUTPUT ,
                                                                                                                                                                               "status" : 0 ,
                                                                                                                                                                               "targets" : [ $TARGET ] ,
                                                                                                                                                                               "transient" : -1
                                                                                                                                                                            }' | compare --message message --channel valid-init --payload false true --timeout 1 --uuid 6784546776754448 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 7866414393983313 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 2 10 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$DISTRACTOR_INDEX" "$DISTRACTOR" \
                                                                                                                                                                        --directory "$DISTRACTOR" \
                                                                                                                                                                        --file "$DISTRACTOR/$TARGET" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/release/$DISTRACTOR_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$DISTRACTOR_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$DISTRACTOR_INDEX" \
                                                                                                                                                                        --uuid 5686665366486275
                                                                                                                                                                    echo We created a distractor resource
                                                                                                                                                                    FRESH=${ resources.checks.targets.true.false { failure = 2198254319735746 ; } }
                                                                                                                                                                    printf -v FRESH_INDEX "%016d" $(( ALPHA + 12 ))
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.true.false.init } \
                                                                                                                                                                        --arg STANDARD_OUTPUT "$STANDARD_OUTPUT" \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "seed" : [ "checks" , "targets" , "true" , "false" ] ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : $STANDARD_OUTPUT ,
                                                                                                                                                                               "status" : 0 ,
                                                                                                                                                                               "targets" : [ $TARGET ] ,
                                                                                                                                                                               "transient" : -1
                                                                                                                                                                            }' | compare --message message --channel valid-init --payload false true --timeout 1 --uuid 1174392364636542 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 4699596933562198 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 18 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --not-equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$DISTRACTOR" \
                                                                                                                                                                        --directory "$FRESH" \
                                                                                                                                                                        --file "$FRESH/$TARGET" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 6824767566554982
                                                                                                                                                                    echo We created a fresh resource
                                                                                                                                                                    STALE=${ resources.checks.targets.true.false { failure = 7378826536491738 ; } }
                                                                                                                                                                    block --timeout 1 --uuid 3651865773299727 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 19 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$STALE" \
                                                                                                                                                                        --equals "$STALE" "$FRESH" \
                                                                                                                                                                        --not-equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$DISTRACTOR" \
                                                                                                                                                                        --directory "$STALE" \
                                                                                                                                                                        --file "$STALE/$TARGET" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 1183691326215391
                                                                                                                                                                    echo We created a stale resource
                                                                                                                                                                fi
                                                                                                                                                            else
                                                                                                                                                                if [[ "$RELEASE" == "true" ]]
                                                                                                                                                                then
                                                                                                                                                                    TARGET=5494881573568661
                                                                                                                                                                    if FRESH=${ resources.checks.targets.false.true { failure = 4524846869486114 ; } }
                                                                                                                                                                    then
                                                                                                                                                                        failure 5213962914665347
                                                                                                                                                                    fi
                                                                                                                                                                    printf -v FRESH_INDEX "%016d" $(( ALPHA + 4 ))
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.false.true.init } \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "seed" : [ "checks" , "targets" , "false" , "true" ] ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : "3148451947316331" ,
                                                                                                                                                                               "status" : 114 ,
                                                                                                                                                                               "targets" : { "expected" : [ $TARGET ] , "observed" : [ $TARGET ] } ,
                                                                                                                                                                               "transient" : -1
                                                                                                                                                                            }' | compare --message message --channel invalid-init --payload false true --timeout 1 --uuid 9746578686273853 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 2336958223494764 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 4 10 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --directory "$FRESH" \
                                                                                                                                                                        --file "$FRESH/$TARGET" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve.sh" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/d9aeea696dd06d63/resolve.sh" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 1433129797798735
                                                                                                                                                                    echo We failed to create a resource
                                                                                                                                                                    if "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/d9aeea696dd06d63/resolve.sh" 9554464665854115
                                                                                                                                                                    then
                                                                                                                                                                        failure 1446655397623276
                                                                                                                                                                    fi
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.false.true.resolve.init } \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ "9554464665854115" ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "resolve-path" : [ "d9aeea696dd06d63" ] ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" :  "7669863784911683" ,
                                                                                                                                                                               "status" : 185
                                                                                                                                                                            }' | compare --message message --channel invalid-init --payload false true --timeout 1 --uuid 4487711927678726 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 891566c578f25dca 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 14 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --directory "$FRESH" \
                                                                                                                                                                        --file "$FRESH/$TARGET" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve.sh" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/d9aeea696dd06d63/resolve.sh" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 1919721337591632
                                                                                                                                                                    echo We failed to resolve a resource
                                                                                                                                                                    "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/d9aeea696dd06d63/resolve.sh" 8363144534251594
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.false.true.resolve.init } \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ "8363144534251594" ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "resolve-path" : [ "d9aeea696dd06d63" ] ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : "7669863784911683"
                                                                                                                                                                            }' | compare --message message --channel valid-init --payload false true --timeout 1 --uuid 8398518585436176 3<&3
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.false.true.release } \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "seed" : [ "checks" , "targets" , "false" , "true" ] ,
                                                                                                                                                                               "standard-output" : "4657737859987722"
                                                                                                                                                                            }' | compare --message message --channel valid-release --payload false true --timeout 60 --uuid 1118336254258565 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 1875f81650ebb984 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 23 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --does-not-exist "$FRESH" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve.sh" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/d9aeea696dd06d63/resolve.sh" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 3242249797342583
                                                                                                                                                                    echo We resolved a resource
                                                                                                                                                                else
                                                                                                                                                                    TARGET=9427941488926681
                                                                                                                                                                    if FRESH=${ resources.checks.targets.false.false { failure = 3762281293673372 ; } }
                                                                                                                                                                    then
                                                                                                                                                                        failure 8218882526454666
                                                                                                                                                                    fi
                                                                                                                                                                    printf -v FRESH_INDEX "%016d" $(( ALPHA + 4 ))
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.false.false.init } \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "seed" : [ "checks" , "targets" , "false" , "false" ] ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : "3346844943869582" ,
                                                                                                                                                                               "status" : 117 ,
                                                                                                                                                                               "targets" : { "expected" : [ $TARGET ] , "observed" : [ $TARGET ] } ,
                                                                                                                                                                               "transient" : -1
                                                                                                                                                                            }' | compare --message message --channel invalid-init --payload false true --timeout 1 --uuid 9138135958783964 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 3477585267872325 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 4 10 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --directory "$FRESH" \
                                                                                                                                                                        --file "$FRESH/$TARGET" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve.sh" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/ec36b9ba523f094d/resolve.sh" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 1136919975781834
                                                                                                                                                                    echo We failed to create a resource
                                                                                                                                                                    if "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/ec36b9ba523f094d/resolve.sh" 7482446721679967
                                                                                                                                                                    then
                                                                                                                                                                        failure 5127357481675282
                                                                                                                                                                    fi
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.false.false.resolve.init } \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ "7482446721679967" ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "resolve-path" : [ "ec36b9ba523f094d" ] ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "standard-error" : "" ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" :  "7669863784911683" ,
                                                                                                                                                                               "status" : 208
                                                                                                                                                                            }' | compare --message message --channel invalid-init --payload false true --timeout 1 --uuid 6677293467823958 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 6631241829779291a 3<&3
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 14 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --directory "$FRESH" \
                                                                                                                                                                        --file "$FRESH/$TARGET" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve.sh" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/ec36b9ba523f094d/resolve.sh" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX" \
                                                                                                                                                                        --uuid 5499964149571681
                                                                                                                                                                    echo We failed to resolve a resource
                                                                                                                                                                    "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/ec36b9ba523f094d/resolve.sh" 7151639144478587
                                                                                                                                                                    jq \
                                                                                                                                                                        --null-input \
                                                                                                                                                                        --compact-output \
                                                                                                                                                                        --arg INDEX "$FRESH_INDEX" \
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.false.false.resolve.init } \
                                                                                                                                                                        --arg TARGET "$TARGET" \
                                                                                                                                                                            '{
                                                                                                                                                                               "arguments" : [ "7151639144478587" ] ,
                                                                                                                                                                               "has-standard-input" : false ,
                                                                                                                                                                               "index" : $INDEX ,
                                                                                                                                                                               "resolve-path" : [ "ec36b9ba523f094d" ] ,
                                                                                                                                                                               "script" : $SCRIPT ,
                                                                                                                                                                               "standard-input" : "" ,
                                                                                                                                                                               "standard-output" : "7669863784911683"
                                                                                                                                                                            }' | compare --message message --channel valid-init --payload false true --timeout 1 --uuid 9328879138585611 3<&3
                                                                                                                                                                    block --timeout 1 --uuid 7322152747664447
                                                                                                                                                                    files \
                                                                                                                                                                        --ceiling "$ALPHA" 8 18 \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --equals "/home/${ config.personal.name }/resources/mounts/$FRESH_INDEX" "$FRESH" \
                                                                                                                                                                        --directory "$FRESH" \
                                                                                                                                                                        --file "$FRESH/$TARGET" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/release/$FRESH_INDEX" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve.sh" \
                                                                                                                                                                        --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$FRESH_INDEX/resolve/ec36b9ba523f094d/resolve.sh" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX/resolve.sh" \
                                                                                                                                                                        --executable "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX/resolve/c5cd75e157ecd42b/resolve.sh" \
                                                                                                                                                                        --uuid 2952237333687496
                                                                                                                                                                    if "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX/resolve/ec36b9ba523f094d/resolve.sh" 7486835568334252
                                                                                                                                                                    then
                                                                                                                                                                        failure 9153213577858634
                                                                                                                                                                    fi
                                                                                                                                                                    echo We resolved a resource
                                                                                                                                                                    if ! /home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX/resolve/ec36b9ba523f094d/resolve.sh 4597174954562694
                                                                                                                                                                    then
                                                                                                                                                                        failure 2947678287368849
                                                                                                                                                                    fi
                                                                                                                                                                    # "/home/${ config.personal.name }/resources/invalid-release/$FRESH_INDEX/resolve/c5cd75e157ecd42b/resolve.sh" 7486835568334252
                                                                                                                                                                fi
                                                                                                                                                            fi
                                                                                                                                                            # block --timeout 1 --uuid 8293659991281846
                                                                                                                                                        '' ;
                                                                                                                                        }
                                                                                                                                )
                                                                                                                            ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                while [[ "$#" -gt 0 ]]
                                                                                                                                do
                                                                                                                                    case "$1" in
                                                                                                                                        --alpha)
                                                                                                                                            ALPHA="$2"
                                                                                                                                            shift 2
                                                                                                                                            ;;
                                                                                                                                        --init)
                                                                                                                                            INIT="$2"
                                                                                                                                            shift 2
                                                                                                                                            ;;
                                                                                                                                        --release)
                                                                                                                                            RELEASE="$2"
                                                                                                                                            shift 2
                                                                                                                                            ;;
                                                                                                                                        *)
                                                                                                                                            failure 7725171477728387 "$*"
                                                                                                                                            ;;
                                                                                                                                    esac
                                                                                                                                done
                                                                                                                                if [[ -z "$ALPHA" ]]
                                                                                                                                then
                                                                                                                                    failure 2987265819228115
                                                                                                                                fi
                                                                                                                                if [[ ! "$ALPHA" =~ ^-?[0-9]+$ ]]
                                                                                                                                then
                                                                                                                                    failure 4368143965676452
                                                                                                                                fi
                                                                                                                                if [[ -z "$INIT" ]]
                                                                                                                                then
                                                                                                                                    failure 6984279614593412
                                                                                                                                fi
                                                                                                                                if [[ -z "$RELEASE" ]]
                                                                                                                                then
                                                                                                                                    failure 9276983686635566
                                                                                                                                fi
                                                                                                                                block --timeout 1 --uuid 4899964636364281 3<&3
                                                                                                                                printf -v ALPHA_INDEX "%016d" $(( ALPHA ))
                                                                                                                                files \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/mounts/$ALPHA_INDEX" \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/release/$ALPHA_INDEX" \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$ALPHA_INDEX" \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$ALPHA_INDEX" \
                                                                                                                                    --uuid 1289673385791639
                                                                                                                                exec 3< <( timeout 1m redis-cli SUBSCRIBE invalid-init invalid-release stale-init valid-init valid-release )
                                                                                                                                compare --message subscribe --channel invalid-init --payload 1 false --timeout 1 --uuid 3376489199378444 3<&3
                                                                                                                                compare --message subscribe --channel invalid-release --payload 2 false --timeout 1 --uuid 2339378822363186 3<&3
                                                                                                                                compare --message subscribe --channel stale-init --payload  3 false --timeout 1 --uuid 3319464677934952 3<&3
                                                                                                                                compare --message subscribe --channel valid-init --payload 4 false --timeout 1 --uuid 6233777653511116 3<&3
                                                                                                                                compare --message subscribe --channel valid-release --payload 5 false --timeout 1 --uuid 3668165924724399 3<&3
                                                                                                                                block --timeout 1 --uuid 8549964153339418 3<&3
                                                                                                                                files \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/mounts/$ALPHA_INDEX" \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/release/$ALPHA_INDEX" \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/invalid-init/$ALPHA_INDEX" \
                                                                                                                                    --does-not-exist "/home/${ config.personal.name }/resources/invalid-release/$ALPHA_INDEX" \
                                                                                                                                    --uuid 1289673385791639
                                                                                                                                pre-test --alpha "$ALPHA" --init "$INIT" --release "$RELEASE" --uuid 3316116883378534 3<&3
                                                                                                                                if [[ "$INIT" == "true" ]]
                                                                                                                                then
                                                                                                                                    if [[ "$RELEASE" == "true" ]]
                                                                                                                                    then
                                                                                                                                        true
                                                                                                                                    else
                                                                                                                                        true
                                                                                                                                    fi
                                                                                                                                else
                                                                                                                                    if [[ "$RELEASE" == "true" ]]
                                                                                                                                    then
                                                                                                                                        true
                                                                                                                                    else
                                                                                                                                        true
                                                                                                                                    fi
                                                                                                                                fi
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                            in "${ application }/bin/post-test" ;
                                                                                                    in
                                                                                                        ''
                                                                                                            wrap \
                                                                                                                ${ post-test } \
                                                                                                                test \
                                                                                                                0500 \
                                                                                                                --literal plain 1 \
                                                                                                                --literal plain 2 \
                                                                                                                --literal plain '#' \
                                                                                                                --literal plain ALPHA \
                                                                                                                --literal plain ALPHA_INDEX \
                                                                                                                --literal plain INIT \
                                                                                                                --literal plain PATH \
                                                                                                                --literal plain RELEASE \
                                                                                                                --uuid 7483697565341694
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
                                                                                                in "${ application }/bin/init" ;
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
                                                                                                                    GITHUB_CONTROL_PATH=${ resources.production.dot-ssh.control-path.github { failure = 12555 ; } }
                                                                                                                    gc-root "$GITHUB_CONTROL_PATH"
                                                                                                                    export GITHUB_CONTROL_PATH
                                                                                                                    GITHUB_IDENTITY_RESOURCE=${ resources.production.age.plaintext.dot-ssh.github.identity { failure = 21662 ; } }
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
                                                                                                                                SECRETS=${ resources.production.product.secrets { failure = 22181 ; } }
                                                                                                                                gc-root "$SECRETS"
                                                                                                                                SSH=${ resources.production.product.ssh { failure = 11121 ; } }
                                                                                                                                gc-root "$SSH"
                                                                                                                                export BIN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/bin" ) [ "$GH" "$GPG" "$NONCE" "$SECRETS" "$SSH" ] ) }
                                                                                                                                export MAN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/share/man" ) [ "$GH" "$GPG" "$NONCE" "$SECRETS" "$SSH" ] ) }
                                                                                                                                wrap ${ envrc } .envrc 0400 --inherit plain BIN_PATH --inherit plain MAN_PATH --uuid 30754
                                                                                                                            '' ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/init" ;
                                                                                        targets = [ ".envrc" ] ;
                                                                                    } ;
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
                                                        temporary =
                                                            {
                                                                argument =
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
                                                                                                            echo -en "$1" > /mount/holder
                                                                                                            chmod 0400 /mount/holder
                                                                                                        '' ;
                                                                                                } ;
                                                                                    in ''${ application }/bin/init "${ builtins.concatStringsSep "" [ "$" "{" "@:-" "}" ] }"'' ;
                                                                            targets = [ "holder" ] ;
                                                                        } ;
                                                                redis =
                                                                    ignore :
                                                                        {
                                                                            init =
                                                                                { failure , gc-root , pkgs , resources , seed , sequential , trace , wrap } :
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "init" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.redis ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            touch /mount/holder
                                                                                                            redis-cli --csv SUBSCRIBE invalid-init invalid-release stale-init valid-init valid-release > /mount/holder &
                                                                                                        '' ;
                                                                                                } ;
                                                                                    in "${ application }/bin/init" ;
                                                                            targets = [ "holder" ] ;
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
                                                                                        timeout 1m "$SCRIPT/test" --alpha 6 --init false --release false
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
                                                                                        timeout 1m "$SCRIPT/test" --alpha 6 --init false --release true
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
                                                                                        timeout 1m "$SCRIPT/test" --alpha 6 --init true --release false
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
                                                                                        timeout 1m "$SCRIPT/test" --alpha 6 --init true --release true
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
