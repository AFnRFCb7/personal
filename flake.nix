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
                                                                                                                        read -r -t "$TIMEOUT" -u 3 OBSERVED_MESSAGE
                                                                                                                        read -r -t "$TIMEOUT" -u 3 OBSERVED_CHANNEL
                                                                                                                        read -r -t "$TIMEOUT" -u 3 OBSERVED_PAYLOAD
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
                                                                                                                                OBSERVED_PRINT_PAYLOAD="$( yq --input-format=json eval --prettyPrint "." <<< "$OBSERVED_PAYLOAD" )" || failure 3474923945839811
                                                                                                                                # EXPECTED_PRINT_PAYLOAD="$( printf '%q\n' "$EXPECTED_PAYLOAD" )" || failure 4118273929999765
                                                                                                                                # OBSERVED_PRINT_PAYLOAD="$( printf '%q\n' "$OBSERVED_PAYLOAD" )" || failure 6573627312252449
                                                                                                                                EXPECTED_FILE="$( mktemp )" || failure 1812352358347461
                                                                                                                                echo "$EXPECTED_PRINT_PAYLOAD" > "$EXPECTED_FILE"
                                                                                                                                OBSERVED_FILE="$( mktemp )" || failure
                                                                                                                                echo "$OBSERVED_PRINT_PAYLOAD" > "$OBSERVED_FILE"
                                                                                                                                DIFF="$( diff --unified "$EXPECTED_FILE" "$OBSERVED_FILE" )" || true
                                                                                                                                failure 2177767151764594 "$UUID" EXPECTED_PAYLOAD "$EXPECTED_PAYLOAD" OBSERVED_PAYLOAD "$OBSERVED_PAYLOAD" EXPECTED_PRINT_PAYLOAD "$EXPECTED_PRINT_PAYLOAD" OBSERVED_PRINT_PAYLOAD "$OBSERVED_PRINT_PAYLOAD" "$EXPECTED_PRINT_PAYLOAD" OBSERVED_PRINT_PAYLOAD "$OBSERVED_PRINT_PAYLOAD" DIFF "$DIFF"
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
                                                                                                                            echo 7521793223743459 "$@" >&2
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
                                                                                                                            echo 4722685275418763 "$*" >&2
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
                                                                                                                                                                                ''
                                                                                                                                                                                '' ;
                                                                                                                                                                            release =
                                                                                                                                                                                ''
                                                                                                                                                                                '' ;
                                                                                                                                                                        } ;
                                                                                                                                                                    true =
                                                                                                                                                                        {
                                                                                                                                                                            init =
                                                                                                                                                                                ''
                                                                                                                                                                                '' ;
                                                                                                                                                                            release =
                                                                                                                                                                                ''
                                                                                                                                                                                '' ;
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

                                                                                                                                                                                        /nix/store/7l2i4v0ajggraxg79mwc0pqxlc8yhjcf-init/bin/init
                                                                                                                                                                                    '' ;
                                                                                                                                                                            release =
                                                                                                                                                                                ''
                                                                                                                                                                                '' ;
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
                                                                                                                                                                        --rawfile SCRIPT ${ scripts.true.true.init } \
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
                                                                                                                                                                    STALE=${ resources.checks.targets.true.true { failure = 7378826536491738 ; } }
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
                                                                                                                                                                    true
                                                                                                                                                                else
                                                                                                                                                                    true
                                                                                                                                                                fi
                                                                                                                                                            fi
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
                                                                                                in "${ application }/bin/init" ;
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
                                                                                                            file-16 = prefix : a : b : "${ prefix }/${ pad-16 a b }" ;
                                                                                                            gc-root = file-16 "/home/${ config.personal.name }/.gc-root" ;
                                                                                                            invalid-init-16 = file-16 "/home/${ config.personal.name }/resources/invalid-init" ;
                                                                                                            invalid-release-16 = file-16 "/home/${ config.personal.name }/resources/invalid-release" ;
                                                                                                            log-16 = file-16 "/home/${ config.personal.name }/resources/logs" ;
                                                                                                            mount-16 = file-16 "/home/${ config.personal.name }/resources/mounts" ;
                                                                                                            pad-16 =
                                                                                                                a : b :
                                                                                                                    let
                                                                                                                        constant = 10000000000000000 ;
                                                                                                                        length = builtins.stringLength sum ;
                                                                                                                        number = a + b ;
                                                                                                                        sum = builtins.toString ( constant + number ) ;
                                                                                                                        in
                                                                                                                            if length < 16 then builtins.throw "number ${ builtins.toString number } is negative"
                                                                                                                            else builtins.substring 1 16 sum ;
                                                                                                            release-16 = file-16 "/home/emory/resources/release" ;
                                                                                                            false-false =
                                                                                                                let
                                                                                                                    alpha = 21 ;
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "false-false" ;
                                                                                                                                runtimeInputs =
                                                                                                                                    [
                                                                                                                                        failure
                                                                                                                                        pkgs.bash
                                                                                                                                        pkgs.coreutils
                                                                                                                                        pkgs.diffutils
                                                                                                                                        pkgs.findutils
                                                                                                                                        pkgs.jq
                                                                                                                                        pkgs.inotify-tools
                                                                                                                                        pkgs.redis
                                                                                                                                        (
                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                {
                                                                                                                                                    name = "pre-test" ;
                                                                                                                                                    runtimeInputs = [ failure pkgs.coreutils pkgs.diffutils pkgs.findutils pkgs.jq pkgs.inotify-tools pkgs.redis sequential ] ;
                                                                                                                                                    text =
                                                                                                                                                        let
                                                                                                                                                            init =
                                                                                                                                                                {
                                                                                                                                                                    arguments = [ "" ] ;
                                                                                                                                                                    has-standard-input = "false" ;
                                                                                                                                                                    hash = "e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764" ;
                                                                                                                                                                    index = pad-16 alpha 1 ;
                                                                                                                                                                    release-file = release-file ;
                                                                                                                                                                    script-file = script-file ;
                                                                                                                                                                    scripts-hash = "d167f7da399e6b01b83f44c3ecb00eb43f5b666e767882bd27e1758abd7c7cc87797e80307d86f0b3cf8a2946115f6cba1b7e99622f17cd83c1631cf92a5c464" ;
                                                                                                                                                                    seed = [ "production" "checks" "true" "true" ] ;
                                                                                                                                                                    standard-error-file = standard-error-file ;
                                                                                                                                                                    standard-input-file = standard-input-file ;
                                                                                                                                                                    standard-output-file = standard-output-file ;
                                                                                                                                                                    status = "0" ;
                                                                                                                                                                    targets =
                                                                                                                                                                        {
                                                                                                                                                                            expected = [ "31321" ] ;
                                                                                                                                                                            observed = [ "31321" ] ;
                                                                                                                                                                        } ;
                                                                                                                                                                } ;
                                                                                                                                                            init-message-file = log-16 alpha 8 ;
                                                                                                                                                            release =
                                                                                                                                                                ''
                                                                                                                                                                    #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                    set -o errexit
                                                                                                                                                                    set -o nounset
                                                                                                                                                                    set -o pipefail

                                                                                                                                                                    export PATH="/nix/store/xy9sa2741cinqmfpmqhdrk38gcv1waxb-trace/bin:/nix/store/54f702arxcxl6xv5dn8x9gy16yqxfddw-destroy/bin:$PATH"

                                                                                                                                                                    mkdir --parents "${ gc-root alpha 1 }"
                                                                                                                                                                    export HASH=e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764
                                                                                                                                                                    export INDEX=${ pad-16 alpha 1 }
                                                                                                                                                                    destroy'' ;
                                                                                                                                                            release-file = release-16 alpha 1 ;
                                                                                                                                                            script =
                                                                                                                                                                ''
                                                                                                                                                                    #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                    set -o errexit
                                                                                                                                                                    set -o nounset
                                                                                                                                                                    set -o pipefail

                                                                                                                                                                    /nix/store/6avrj20bbivwnl6y8fsmhalzwiqd11n8-init/bin/init''  ;
                                                                                                                                                            script-file = log-16 alpha 5 ;
                                                                                                                                                            standard-error = "" ;
                                                                                                                                                            standard-error-file = log-16 alpha 3 ;
                                                                                                                                                            standard-input = "" ;
                                                                                                                                                            standard-input-file = log-16 alpha 3 ;
                                                                                                                                                            standard-output = "14060" ;
                                                                                                                                                            standard-output-file = log-16 alpha 4 ;
                                                                                                                                                            in
                                                                                                                                                                ''
                                                                                                                                                                    EXPECTED_RESOURCE=${ mount-16 alpha 4 }
                                                                                                                                                                    OBSERVED_RESOURCE=${ resources.production.checks.true.true { failure = 21760 ; } }
                                                                                                                                                                    if [[ "$EXPECTED_RESOURCE" != "$OBSERVED_RESOURCE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 15789 EXPECTED_RESOURCE "$EXPECTED_RESOURCE" OBSERVED_RESOURCE "$OBSERVED_RESOURCE"
                                                                                                                                                                    fi
                                                                                                                                                                    COUNT_SIX=0
                                                                                                                                                                    while [[ "$COUNT_SIX" -lt "6" ]]
                                                                                                                                                                    do
                                                                                                                                                                        sleep 1
                                                                                                                                                                        COUNT_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 24769
                                                                                                                                                                    done
                                                                                                                                                                    EXPECTED_INIT="\"message\",\"valid-init\",\"${ init-message-file }\""
                                                                                                                                                                    OBSERVED_INIT="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20277
                                                                                                                                                                    if [[ "$EXPECTED_INIT" != "$OBSERVED_INIT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 14530 EXPECTED_INIT "$EXPECTED_INIT" OBSERVED_INIT "$OBSERVED_INIT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_INIT_JSON='${ builtins.toJSON init }'
                                                                                                                                                                    OBSERVED_INIT_JSON="$( jq --compact-output "." ${ init-message-file } )" || failure 9412
                                                                                                                                                                    if [[ "$EXPECTED_INIT_JSON" != "$OBSERVED_INIT_JSON" ]]
                                                                                                                                                                    then
                                                                                                                                                                        PRINT_INIT_JSON="$( jq "." ${ init-message-file } )" || failure 23617
                                                                                                                                                                        failure 16098 EXPECTED_INIT_JSON "$EXPECTED_INIT_JSON" OBSERVED_INIT_JSON "$OBSERVED_INIT_JSON" PRINT_INIT_JSON "$PRINT_INIT_JSON"
                                                                                                                                                                    fi
                                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                                    EXPECTED_RELEASE='${ release }'
                                                                                                                                                                    OBSERVED_RELEASE="$( cat ${ release-file } )" || failure 19359
                                                                                                                                                                    if [[ "$EXPECTED_RELEASE" != "$OBSERVED_RELEASE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        RELEASE_SEQUENCE="$( sequential )" || failure 20665
                                                                                                                                                                        echo "$EXPECTED_RELEASE" > "$TEMPORARY/$RELEASE_SEQUENCE"
                                                                                                                                                                        DIFF_RELEASE="$( diff --unified "$TEMPORARY/$RELEASE_SEQUENCE" ${ release-file } )" || true
                                                                                                                                                                        failure 15837186198099820 EXPECTED_RELEASE "$EXPECTED_RELEASE" OBSERVED_RELEASE "$OBSERVED_RELEASE" DIFF_RELEASE "$DIFF_RELEASE"
                                                                                                                                                                    fi
                                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                                    EXPECTED_SCRIPT='${ script }'
                                                                                                                                                                    OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 11196
                                                                                                                                                                    if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        RELEASE_SEQUENCE="$( sequential )" || failure 16175
                                                                                                                                                                        echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$RELEASE_SEQUENCE"
                                                                                                                                                                        DIFF_SCRIPT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/SCRIPT" ${ script-file } )" || true
                                                                                                                                                                        failure 18539 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                                    OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 31412
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 21857
                                                                                                                                                                        echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_ERROR="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_ERROR" ${ standard-error-file } )" || true
                                                                                                                                                                        failure 30053 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_INPUT='${ standard-input }'
                                                                                                                                                                    OBSERVED_STANDARD_INPUT="$( cat ${ standard-input-file } )" || failure 23070
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_INPUT" != "$OBSERVED_STANDARD_INPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_INPUT_SEQUENCE="$( sequential )" || failure 30671
                                                                                                                                                                        echo "$EXPECTED_STANDARD_INPUT" > "$TEMPORARY/$STANDARD_INPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_INPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 13551 EXPECTED_STANDARD_INPUT "$EXPECTED_STANDARD_INPUT" OBSERVED_STANDARD_INPUT "$OBSERVED_STANDARD_INPUT" DIFF_STANDARD_INPUT "$DIFF_STANDARD_INPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                                    OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 18330
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 22790
                                                                                                                                                                        echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_OUTPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 16668 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    WC_SEVEN="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 21345
                                                                                                                                                                    if [[ "$WC_SEVEN" != 6 ]]
                                                                                                                                                                    then
                                                                                                                                                                        SEVEN="$( head --lines 7 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                                        failure 20505 SEVEN "$SEVEN"
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "${ invalid-init-16 alpha 17293 }" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 23500
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "${ invalid-release-16 alpha 17293 }" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 13101
                                                                                                                                                                    fi
                                                                                                                                                                '' ;
                                                                                                                                                }
                                                                                                                                        )
                                                                                                                                        sequential
                                                                                                                                    ] ;
                                                                                                                                text =
                                                                                                                                    let
                                                                                                                                        release =
                                                                                                                                            {
                                                                                                                                                hash = "e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764" ;
                                                                                                                                                index = pad-16 alpha 1 ;
                                                                                                                                                script-file = script-file ;
                                                                                                                                                seed = [ "production" "checks" "true" "true" ] ;
                                                                                                                                                standard-error-file = standard-error-file ;
                                                                                                                                                standard-output-file = standard-output-file ;
                                                                                                                                                status = "0" ;
                                                                                                                                            } ;
                                                                                                                                        release-message-file = log-16 alpha 9 ;
                                                                                                                                        script =
                                                                                                                                            ''
                                                                                                                                                #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                set -o errexit
                                                                                                                                                set -o nounset
                                                                                                                                                set -o pipefail

                                                                                                                                                /nix/store/ivcji4xkipn8zfiqj50yfgrq8g9cfxn1-release/bin/release'' ;
                                                                                                                                        script-file = log-16 alpha 6;
                                                                                                                                        standard-error = "" ;
                                                                                                                                        standard-error-file = log-16 alpha 7 ;
                                                                                                                                        standard-output = "18719" ;
                                                                                                                                        standard-output-file = log-16 alpha 8 ;
                                                                                                                                        in
                                                                                                                                            ''
                                                                                                                                                OUTPUT_SEQUENCE="$( sequential )" || failure 27462
                                                                                                                                                OUTPUT_FILE="$TEMPORARY/$OUTPUT_SEQUENCE"
                                                                                                                                                export OUTPUT_FILE
                                                                                                                                                touch "$OUTPUT_FILE"
                                                                                                                                                redis-cli --csv SUBSCRIBE invalid-init invalid-release stale-init valid-init valid-release > "$OUTPUT_FILE" &
                                                                                                                                                COUNT_5=0
                                                                                                                                                while [[ "$COUNT_5" -lt "5" ]]
                                                                                                                                                do
                                                                                                                                                    echo "$COUNT_5=$COUNT_5"
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_5="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 13785
                                                                                                                                                done
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_INIT="\"subscribe\",\"invalid-init\",1"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_INIT="$( head --lines 1 "$OUTPUT_FILE" )" || failure 29807
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_INIT" != "$OBSERVED_SUBSCRIBE_INVALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 30918 EXPECTED_SUBSCRIBE_INVALID_INIT "$EXPECTED_SUBSCRIBE_INVALID_INIT" OBSERVED_SUBSCRIBE_INVALID_INIT "$OBSERVED_SUBSCRIBE_INVALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_RELEASE="\"subscribe\",\"invalid-release\",2"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_RELEASE="$( head --lines 2 "$OUTPUT_FILE" | tail --lines 1 )" || failure 10496
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" != "$OBSERVED_SUBSCRIBE_INVALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 21324 EXPECTED_SUBSCRIBE_INVALID_RELEASE "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" OBSERVED_SUBSCRIBE_INVALID_RELEASE "$OBSERVED_SUBSCRIBE_INVALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_STALE_INIT="\"subscribe\",\"stale-init\",3"
                                                                                                                                                OBSERVED_SUBSCRIBE_STALE_INIT="$( head --lines 3 "$OUTPUT_FILE" | tail --lines 1 )" || failure 16256
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_STALE_INIT" != "$OBSERVED_SUBSCRIBE_STALE_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 11841 EXPECTED_SUBSCRIBE_STALE_INIT "$EXPECTED_SUBSCRIBE_STALE_INIT" OBSERVED_SUBSCRIBE_STALE_INIT "$OBSERVED_SUBSCRIBE_STALE_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_INIT="\"subscribe\",\"valid-init\",4"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_INIT="$( head --lines 4 "$OUTPUT_FILE" | tail --lines 1 )" || failure 32080
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_INIT" != "$OBSERVED_SUBSCRIBE_VALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20315 EXPECTED_SUBSCRIBE_VALID_INIT "$EXPECTED_SUBSCRIBE_VALID_INIT" OBSERVED_SUBSCRIBE_VALID_INIT "$OBSERVED_SUBSCRIBE_VALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_RELEASE="\"subscribe\",\"valid-release\",5"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_RELEASE="$( head --lines 5 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20683
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_RELEASE" != "$OBSERVED_SUBSCRIBE_VALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 28681 EXPECTED_SUBSCRIBE_VALID_RELEASE "$EXPECTED_SUBSCRIBE_VALID_RELEASE" OBSERVED_SUBSCRIBE_VALID_RELEASE "$OBSERVED_SUBSCRIBE_VALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                WC_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 17924
                                                                                                                                                if [[ "$WC_SIX" != "5" ]]
                                                                                                                                                then
                                                                                                                                                    SIX="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                    failure 24681 SIX "$SIX"
                                                                                                                                                fi
                                                                                                                                                timeout 1m bash -c pre-test
                                                                                                                                                COUNT_7=0
                                                                                                                                                while [[ "$COUNT_7" != "7" ]]
                                                                                                                                                do
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_7="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 24082
                                                                                                                                                done
                                                                                                                                                EXPECTED_RELEASE="\"message\",\"valid-release\",\"${ release-message-file }\""
                                                                                                                                                OBSERVED_RELEASE="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 14819
                                                                                                                                                if [[ "$EXPECTED_RELEASE" != "$OBSERVED_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 13751 EXPECTED_RELEASE "$EXPECTED_RELEASE" OBSERVED_RELEASE "$OBSERVED_RELEASE" "$( cat /home/emory/resources/logs/0000000000000031 )"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_RELEASE_JSON='${ builtins.toJSON release }'
                                                                                                                                                OBSERVED_RELEASE_JSON="$( jq --compact-output "." ${ release-message-file } )" || failure 20816 ${ release-message-file }
                                                                                                                                                if [[ "$EXPECTED_RELEASE_JSON" != "$OBSERVED_RELEASE_JSON" ]]
                                                                                                                                                then
                                                                                                                                                    PRINT_RELEASE_JSON="$( jq "." ${ release-message-file } )" || failure 18266
                                                                                                                                                    failure 25932 EXPECTED_RELEASE_JSON "$EXPECTED_RELEASE_JSON" OBSERVED_RELEASE_JSON "$OBSERVED_RELEASE_JSON" PRINT_RELEASE_JSON "$PRINT_RELEASE_JSON"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SCRIPT='${ script }'
                                                                                                                                                OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 19776
                                                                                                                                                if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                then
                                                                                                                                                    SCRIPT_SEQUENCE="$( sequential )" || failure 29176
                                                                                                                                                    echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$SCRIPT_SEQUENCE"
                                                                                                                                                    DIFF_SCRIPT="$( diff --unified "$TEMPORARY/$SCRIPT_SEQUENCE" ${ script-file } )" || true
                                                                                                                                                    failure 5478 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 4256
                                                                                                                                                if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 27101
                                                                                                                                                    echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_ERROR="$( diff --unified "$TEMPORARY/$STANDARD_ERROR_SEQUENCE" ${ standard-error-file } )" || true
                                                                                                                                                    failure 20376 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 11369
                                                                                                                                                if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 29999
                                                                                                                                                    echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_OUTPUT="$( diff --unified "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE" ${ standard-output-file } )" || true
                                                                                                                                                    failure 22430 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                fi
                                                                                                                                                if [[ -e "${ invalid-init-16 alpha 17293 }" ]]
                                                                                                                                                then
                                                                                                                                                    failure 31812
                                                                                                                                                fi
                                                                                                                                                if [[ -e "${ invalid-release-16 alpha 17293 }" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20789
                                                                                                                                                fi
                                                                                                                                                WC_EIGHT="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 17418
                                                                                                                                                if [[ "$WC_EIGHT" != 7 ]]
                                                                                                                                                then
                                                                                                                                                    EIGHT="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 14060
                                                                                                                                                    failure 12459 EIGHT "$EIGHT"
                                                                                                                                                fi
                                                                                                                                            '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/false-false" ;
                                                                                                            ### FIND ME
                                                                                                            false-true =
                                                                                                                let
                                                                                                                    alpha = 21 ;
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "false-true" ;
                                                                                                                                runtimeInputs =
                                                                                                                                    [
                                                                                                                                        failure
                                                                                                                                        pkgs.bash
                                                                                                                                        pkgs.coreutils
                                                                                                                                        pkgs.diffutils
                                                                                                                                        pkgs.findutils
                                                                                                                                        pkgs.jq
                                                                                                                                        pkgs.inotify-tools
                                                                                                                                        pkgs.redis
                                                                                                                                        (
                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                {
                                                                                                                                                    name = "pre-test" ;
                                                                                                                                                    runtimeInputs = [ failure pkgs.coreutils pkgs.diffutils pkgs.findutils pkgs.jq pkgs.inotify-tools pkgs.redis sequential ] ;
                                                                                                                                                    text =
                                                                                                                                                        let
                                                                                                                                                            good-init =
                                                                                                                                                                {
                                                                                                                                                                    files =
                                                                                                                                                                        {
                                                                                                                                                                            standard-error-file = log-16 alpha 10 ;
                                                                                                                                                                            standard-input-file = log-16 alpha 11 ;
                                                                                                                                                                            standard-output-file = log-16 alpha 12 ;
                                                                                                                                                                        } ;
                                                                                                                                                                    json =
                                                                                                                                                                        {
                                                                                                                                                                            arguments = [ "9929554118572229" ] ;
                                                                                                                                                                            has-script = "true" ;
                                                                                                                                                                            has-standard-input = "false" ;
                                                                                                                                                                            resolution-path = [ "d6f7e33e04336ec1" "f76cca72fe96d8d9" ] ;
                                                                                                                                                                            script-file = "/nix/store/y4dhnfw1f576l6nlkxjwbg5mkljrhs4h-resolve/bin/resolve" ;
                                                                                                                                                                            standard-error-file = log-16 alpha 10 ;
                                                                                                                                                                            standard-input-file = log-16 alpha 11 ;
                                                                                                                                                                            standard-output-file = log-16 alpha 12 ;
                                                                                                                                                                            status = "0" ;
                                                                                                                                                                        } ;
                                                                                                                                                                    standard-error =
                                                                                                                                                                        ''
                                                                                                                                                                        '' ;
                                                                                                                                                                    standard-input =
                                                                                                                                                                        ''
                                                                                                                                                                        '' ;
                                                                                                                                                                    standard-output =
                                                                                                                                                                        ''
                                                                                                                                                                            3292477133481244'' ;
                                                                                                                                                                } ;
                                                                                                                                                            good-resolve =
                                                                                                                                                                {
                                                                                                                                                                    file = "" ;
                                                                                                                                                                    json =
                                                                                                                                                                        {

                                                                                                                                                                        } ;
                                                                                                                                                                } ;
                                                                                                                                                            good-init-resolve =
                                                                                                                                                                {
                                                                                                                                                                    arguments = [ "9929554118572229" ] ;
                                                                                                                                                                    has-script = "true" ;
                                                                                                                                                                    has-standard-input = "false" ;
                                                                                                                                                                    release-file = release-file ;
                                                                                                                                                                    resolution-path = [ "b4a45784de5a710c" "c5db23113303796b" ] ;
                                                                                                                                                                    script-file = "/nix/store/y4dhnfw1f576l6nlkxjwbg5mkljrhs4h-resolve/bin/resolve" ;
                                                                                                                                                                    standard-error-file = log-16 alpha 10 ;
                                                                                                                                                                    standard-input-file = log-16 alpha 11 ;
                                                                                                                                                                    standard-output-file = log-16 alpha 12 ;
                                                                                                                                                                    status = "0" ;
                                                                                                                                                                } ;
                                                                                                                                                            good-init-resolve-file = log-16 alpha 13 ;
                                                                                                                                                            index = pad-16 alpha 5 ;
                                                                                                                                                            init =
                                                                                                                                                                {
                                                                                                                                                                    arguments = [ "" ] ;
                                                                                                                                                                    has-standard-input = "false" ;
                                                                                                                                                                    hash = "94d5a974b6db637e2ba111869172da71281c2cc7b70cf3ecd9e59ff34083834d904b9f3f94605907595586b8a9f53f7f9dc09909fec5fb1e8770149d7c26a282" ;
                                                                                                                                                                    index = index ;
                                                                                                                                                                    script-file = script-file ;
                                                                                                                                                                    scripts-hash = "9098a9a1c83c2247c2c734f3bbadec1dd8332754227f67cba6cab8f551e4bd4a48c61bd04793b792a0da15857d245f751a3afc86f75d22119db7e1f8e5160e70" ;
                                                                                                                                                                    seed = [ "production" "checks" "false" "true" ] ;
                                                                                                                                                                    standard-error-file = standard-error-file ;
                                                                                                                                                                    standard-input-file = standard-input-file ;
                                                                                                                                                                    standard-output-file = standard-output-file ;
                                                                                                                                                                    status = "123" ;
                                                                                                                                                                    targets =
                                                                                                                                                                        {
                                                                                                                                                                            expected = [ "32051" ] ;
                                                                                                                                                                            observed = [ "32051" ] ;
                                                                                                                                                                        } ;
                                                                                                                                                                } ;
                                                                                                                                                            init-message-file = log-16 alpha 9 ;
                                                                                                                                                            release =
                                                                                                                                                                ''
                                                                                                                                                                '' ;
                                                                                                                                                            release-file = release-16 alpha 5 ;
                                                                                                                                                            script =
                                                                                                                                                                ''
                                                                                                                                                                    #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                    set -o errexit
                                                                                                                                                                    set -o nounset
                                                                                                                                                                    set -o pipefail

                                                                                                                                                                    /nix/store/06sz5z4zpzrn8jr2g3zdd97qmgpwkd34-init/bin/init''  ;
                                                                                                                                                            script-file = log-16 alpha 6 ;
                                                                                                                                                            standard-error = "" ;
                                                                                                                                                            standard-error-file = log-16 alpha 7 ;
                                                                                                                                                            standard-input = "" ;
                                                                                                                                                            standard-input-file = log-16 alpha 3 ;
                                                                                                                                                            standard-output = "14060" ;
                                                                                                                                                            standard-output-file = log-16 alpha 8 ;
                                                                                                                                                            in
                                                                                                                                                                ''
                                                                                                                                                                    if OBSERVED_RESOURCE=${ resources.production.checks.false.true { failure = 4712192148713563 ; } }
                                                                                                                                                                    then
                                                                                                                                                                        failure 20136 OBSERVED_RESOURCE "$OBSERVED_RESOURCE"
                                                                                                                                                                    fi
                                                                                                                                                                    COUNT_SIX=0
                                                                                                                                                                    while [[ "$COUNT_SIX" -lt "6" ]]
                                                                                                                                                                    do
                                                                                                                                                                        sleep 1
                                                                                                                                                                        COUNT_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 24769
                                                                                                                                                                    done
                                                                                                                                                                    EXPECTED_INIT="\"message\",\"invalid-init\",\"${ init-message-file }\""
                                                                                                                                                                    OBSERVED_INIT="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20277
                                                                                                                                                                    if [[ "$EXPECTED_INIT" != "$OBSERVED_INIT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 14530 EXPECTED_INIT "$EXPECTED_INIT" OBSERVED_INIT "$OBSERVED_INIT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_INIT_JSON='${ builtins.toJSON init }'
                                                                                                                                                                    OBSERVED_INIT_JSON="$( jq --compact-output "." ${ init-message-file } )" || failure 9412
                                                                                                                                                                    if [[ "$EXPECTED_INIT_JSON" != "$OBSERVED_INIT_JSON" ]]
                                                                                                                                                                    then
                                                                                                                                                                        PRINT_INIT_JSON="$( jq "." ${ init-message-file } )" || failure 23617
                                                                                                                                                                        failure 8195484594960100 EXPECTED_INIT_JSON "$EXPECTED_INIT_JSON" OBSERVED_INIT_JSON "$OBSERVED_INIT_JSON" PRINT_INIT_JSON "$PRINT_INIT_JSON"
                                                                                                                                                                    fi
                                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                                    EXPECTED_SCRIPT='${ script }'
                                                                                                                                                                    OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 11196
                                                                                                                                                                    if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        SCRIPT_SEQUENCE="$( sequential )" || failure 16175
                                                                                                                                                                        echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$SCRIPT_SEQUENCE"
                                                                                                                                                                        DIFF_SCRIPT="$( diff --unified "$TEMPORARY/$SCRIPT_SEQUENCE" ${ script-file } )" || true
                                                                                                                                                                        failure 1275594965878699 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                                    OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 31412
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 21857
                                                                                                                                                                        echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_ERROR="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_ERROR" ${ standard-error-file } )" || true
                                                                                                                                                                        failure 30053 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_INPUT='${ standard-input }'
                                                                                                                                                                    OBSERVED_STANDARD_INPUT="$( cat ${ standard-input-file } )" || failure 23070
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_INPUT" != "$OBSERVED_STANDARD_INPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_INPUT_SEQUENCE="$( sequential )" || failure 30671
                                                                                                                                                                        echo "$EXPECTED_STANDARD_INPUT" > "$TEMPORARY/$STANDARD_INPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_INPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 13551 EXPECTED_STANDARD_INPUT "$EXPECTED_STANDARD_INPUT" OBSERVED_STANDARD_INPUT "$OBSERVED_STANDARD_INPUT" DIFF_STANDARD_INPUT "$DIFF_STANDARD_INPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                                    OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 18330
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 22790
                                                                                                                                                                        echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_OUTPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 16668 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    WC_SEVEN="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 21345
                                                                                                                                                                    if [[ "$WC_SEVEN" != 6 ]]
                                                                                                                                                                    then
                                                                                                                                                                        SEVEN="$( head --lines 7 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                                        failure 20505 SEVEN "$SEVEN"
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "/home/${ config.personal.name }/resources/release/${ index }" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 3874459131291981
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ ! -d "/home/${ config.personal.name }/resources/invalid-init/${ index }" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 2727914588929012
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ ! -f "/home/${ config.personal.name }/resources/invalid-init/${ index }/resolve.sh" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 6087257765469090
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ ! -x "/home/${ config.personal.name }/resources/invalid-init/${ index }/resolve.sh" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 4145801929253151
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ ! -f "/home/${ config.personal.name }/resources/invalid-init/${ index }/resolve/b4a45784de5a710c/c5db23113303796b/resolve.sh" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 5344476823433508
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ ! -x "/home/${ config.personal.name }/resources/invalid-init/${ index }/resolve/b4a45784de5a710c/c5db23113303796b/resolve.sh" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 7155352788913521
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ ! -f "/home/${ config.personal.name }/resources/invalid-init/${ index }/resolve/d6f7e33e04336ec1/f76cca72fe96d8d9/resolve.sh" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 3468826656472517
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ ! -x "/home/${ config.personal.name }/resources/invalid-init/${ index }/resolve/d6f7e33e04336ec1/f76cca72fe96d8d9/resolve.sh" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 7884424186543724
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "/home/${ config.personal.name }/resources/invalid-release" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 4857756770187742
                                                                                                                                                                    fi
                                                                                                                                                                    ## failure 8799432489754527
                                                                                                                                                                    if /home/${ config.personal.name }/resources/invalid-init/${ index }/resolve/b4a45784de5a710c/c5db23113303796b/resolve.sh 9929554118572229 >&2
                                                                                                                                                                    then
                                                                                                                                                                        failure 5864462541924729 "$?"
                                                                                                                                                                    fi
                                                                                                                                                                    if true
                                                                                                                                                                    then
                                                                                                                                                                        exit 0
                                                                                                                                                                    fi
                                                                                                                                                                    # failure 8799432489754527
                                                                                                                                                                    COUNT_SEVEN=0
                                                                                                                                                                    while [[ "$COUNT_SEVEN" -lt "7" ]]
                                                                                                                                                                    do
                                                                                                                                                                        sleep 1
                                                                                                                                                                        COUNT_SEVEN="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 24769
                                                                                                                                                                    done
                                                                                                                                                                    failure 8799432489754527
                                                                                                                                                                    EXPECTED_GOOD_INIT_RESOLVE="\"message\",\"valid-init\",\"${ good-init-resolve-file }\""
                                                                                                                                                                    OBSERVED_GOOD_INIT_RESOLVE="$( head --lines 7 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20277
                                                                                                                                                                    if [[ "$EXPECTED_GOOD_INIT_RESOLVE" != "$OBSERVED_GOOD_INIT_RESOLVE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 7696948145827181 EXPECTED_GOOD_INIT_RESOLVE "$EXPECTED_GOOD_INIT_RESOLVE" OBSERVED_GOOD_INIT_RESOLVE "$OBSERVED_GOOD_INIT_RESOLVE"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_GOOD_INIT_RESOLVE_JSON='${ builtins.toJSON good-init-resolve }'
                                                                                                                                                                    OBSERVED_GOOD_INIT_RESOLVE_JSON="$( jq --compact-output "." ${ good-init-resolve-file } )" || failure 1916621691452317
                                                                                                                                                                    if [[ "$EXPECTED_GOOD_INIT_RESOLVE_JSON" != "$OBSERVED_GOOD_INIT_RESOLVE_JSON" ]]
                                                                                                                                                                    then
                                                                                                                                                                        PRINT_GOOD_INIT_RESOLVE_JSON="$( jq "." ${ good-init-resolve-file } )" || failure 8997333792138166
                                                                                                                                                                        failure 5972293388135472 EXPECTED_GOOD_INIT_RESOLVE_JSON "$EXPECTED_GOOD_INIT_RESOLVE_JSON" OBSERVED_GOOD_INIT_RESOLVE_JSON "$OBSERVED_GOOD_INIT_RESOLVE_JSON" PRINT_GOOD_INIT_RESOLVE_JSON "$PRINT_GOOD_INIT_RESOLVE_JSON"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_RELEASE=${ release }
                                                                                                                                                                    OBSERVED_RELEASE="$( cat ${ release-file } )" || failure 2451821366891961
                                                                                                                                                                    if [[ "$EXPECTED_RELEASE" != "$OBSERVED_RELEASE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        RELEASE_SEQUENCE="$( sequential )" || failure 7216522251215261
                                                                                                                                                                        echo "$EXPECTED_RELEASE" > "$TEMPORARY/$RELEASE_SEQUENCE"
                                                                                                                                                                        DIFF_RELEASE="$( diff --unified "$EXPECTED_RELEASE" "$OBSERVED_RELEASE" )" || true
                                                                                                                                                                        failure 4647629147888793 EXPECTED_RELEASE "$EXPECTED_RELEASE" OBSERVED_RELEASE "$OBSERVED_RELEASE" DIFF_RELEASE "$DIFF_RELEASE"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_GOOD_INIT_STANDARD_ERROR='${ good-init.standard-error }'
                                                                                                                                                                    OBSERVED_GOOD_INIT_STANDARD_ERROR="$( cat ${ good-init.json.standard-error-file } )" || failure 3367377293755565
                                                                                                                                                                    if [[ "$EXPECTED_GOOD_INIT_STANDARD_ERROR" != "$OBSERVED_GOOD_INIT_STANDARD_ERROR" ]]
                                                                                                                                                                    then
                                                                                                                                                                        GOOD_INIT_STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 9219241536577672
                                                                                                                                                                        echo "$EXPECTED_GOOD_INIT_STANDARD_ERROR" > "$TEMPORARY/$GOOD_INIT_STANDARD_ERROR_SEQUENCE"
                                                                                                                                                                        DIFF_GOOD_INIT_STANDARD_ERROR="$( diff --unified "$EXPECTED_GOOD_INIT_STANDARD_ERROR" "$OBSERVED_GOOD_INIT_STANDARD_ERROR" )" || true
                                                                                                                                                                        failure 6641433375568169 EXPECTED_GOOD_INIT_STANDARD_ERROR "$EXPECTED_GOOD_INIT_STANDARD_ERROR" OBSERVED_GOOD_INIT_STANDARD_ERROR "$OBSERVED_GOOD_INIT_STANDARD_ERROR" DIFF_GOOD_INIT_STANDARD_ERROR "$DIFF_GOOD_INIT_STANDARD_ERROR"
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e ${ good-init.json.standard-input-file } ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 3785958457935511
                                                                                                                                                                    fi
                                                                                                                                                                    ## failure 8799432489754527
                                                                                                                                                                    EXPECTED_GOOD_INIT_STANDARD_OUTPUT='${ good-init.standard-output }'
                                                                                                                                                                    OBSERVED_GOOD_INIT_STANDARD_OUTPUT="$( cat ${ good-init.json.standard-output-file } )" || failure 9189941118444955
                                                                                                                                                                    if [[ "$EXPECTED_GOOD_INIT_STANDARD_OUTPUT" != "$OBSERVED_GOOD_INIT_STANDARD_OUTPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        GOOD_INIT_STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 9219241536577672
                                                                                                                                                                        echo "$EXPECTED_GOOD_INIT_STANDARD_OUTPUT" > "$TEMPORARY/$GOOD_INIT_STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                                        DIFF_GOOD_INIT_STANDARD_OUTPUT="$( diff --unified "$EXPECTED_GOOD_INIT_STANDARD_OUTPUT" "$OBSERVED_GOOD_INIT_STANDARD_OUTPUT" )" || true
                                                                                                                                                                        failure 2423837637322547 EXPECTED_GOOD_INIT_STANDARD_OUTPUT "$EXPECTED_GOOD_INIT_STANDARD_OUTPUT" OBSERVED_GOOD_INIT_STANDARD_OUTPUT "$OBSERVED_GOOD_INIT_STANDARD_OUTPUT" DIFF_GOOD_INIT_STANDARD_OUTPUT "$DIFF_GOOD_INIT_STANDARD_OUTPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    failure 8799432489754527
                                                                                                                                                                    COUNT_EIGHT=0
                                                                                                                                                                    while [[ "$COUNT_EIGHT" -lt "8" ]]
                                                                                                                                                                    do
                                                                                                                                                                        sleep 1
                                                                                                                                                                        COUNT_EIGHT="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 8631511829865393
                                                                                                                                                                    done
                                                                                                                                                                    failure 8799432489754527
                                                                                                                                                                    EXPECTED_GOOD_RELEASE="\"message\",\"valid-release\",\"${ good-resolve.file }\""
                                                                                                                                                                    OBSERVED_GOOD_RELEASE="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20277
                                                                                                                                                                    if [[ "$EXPECTED_GOOD_RELEASE" != "$OBSERVED_GOOD_RELEASE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 6729279153419344 EXPECTED_GOOD_RELEASE "$EXPECTED_GOOD_RELEASE" OBSERVED_GOOD_RELEASE "$OBSERVED_GOOD_RELEASE"
                                                                                                                                                                    fi
                                                                                                                                                                '' ;
                                                                                                                                                }
                                                                                                                                        )
                                                                                                                                        sequential
                                                                                                                                    ] ;
                                                                                                                                text =
                                                                                                                                    let
                                                                                                                                        release =
                                                                                                                                            {
                                                                                                                                                hash = "e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764" ;
                                                                                                                                                index = pad-16 alpha 1 ;
                                                                                                                                                script-file = script-file ;
                                                                                                                                                seed = [ "production" "checks" "true" "true" ] ;
                                                                                                                                                standard-error-file = standard-error-file ;
                                                                                                                                                standard-output-file = standard-output-file ;
                                                                                                                                                status = "0" ;
                                                                                                                                            } ;
                                                                                                                                        release-message-file = log-16 alpha 13 ;
                                                                                                                                        script =
                                                                                                                                            ''
                                                                                                                                                #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                set -o errexit
                                                                                                                                                set -o nounset
                                                                                                                                                set -o pipefail

                                                                                                                                                /nix/store/ivcji4xkipn8zfiqj50yfgrq8g9cfxn1-release/bin/release'' ;
                                                                                                                                        script-file = log-16 alpha 6;
                                                                                                                                        standard-error = "" ;
                                                                                                                                        standard-error-file = log-16 alpha 7 ;
                                                                                                                                        standard-output = "18719" ;
                                                                                                                                        standard-output-file = log-16 alpha 8 ;
                                                                                                                                        in
                                                                                                                                            ''
                                                                                                                                                OUTPUT_SEQUENCE="$( sequential )" || failure 27462
                                                                                                                                                OUTPUT_FILE="$TEMPORARY/$OUTPUT_SEQUENCE"
                                                                                                                                                export OUTPUT_FILE
                                                                                                                                                touch "$OUTPUT_FILE"
                                                                                                                                                redis-cli --csv SUBSCRIBE invalid-init invalid-release stale-init valid-init valid-release > "$OUTPUT_FILE" &
                                                                                                                                                COUNT_5=0
                                                                                                                                                while [[ "$COUNT_5" -lt "5" ]]
                                                                                                                                                do
                                                                                                                                                    echo "$COUNT_5=$COUNT_5"
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_5="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 13785
                                                                                                                                                done
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_INIT="\"subscribe\",\"invalid-init\",1"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_INIT="$( head --lines 1 "$OUTPUT_FILE" )" || failure 29807
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_INIT" != "$OBSERVED_SUBSCRIBE_INVALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 30918 EXPECTED_SUBSCRIBE_INVALID_INIT "$EXPECTED_SUBSCRIBE_INVALID_INIT" OBSERVED_SUBSCRIBE_INVALID_INIT "$OBSERVED_SUBSCRIBE_INVALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_RELEASE="\"subscribe\",\"invalid-release\",2"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_RELEASE="$( head --lines 2 "$OUTPUT_FILE" | tail --lines 1 )" || failure 10496
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" != "$OBSERVED_SUBSCRIBE_INVALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 21324 EXPECTED_SUBSCRIBE_INVALID_RELEASE "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" OBSERVED_SUBSCRIBE_INVALID_RELEASE "$OBSERVED_SUBSCRIBE_INVALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_STALE_INIT="\"subscribe\",\"stale-init\",3"
                                                                                                                                                OBSERVED_SUBSCRIBE_STALE_INIT="$( head --lines 3 "$OUTPUT_FILE" | tail --lines 1 )" || failure 16256
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_STALE_INIT" != "$OBSERVED_SUBSCRIBE_STALE_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 11841 EXPECTED_SUBSCRIBE_STALE_INIT "$EXPECTED_SUBSCRIBE_STALE_INIT" OBSERVED_SUBSCRIBE_STALE_INIT "$OBSERVED_SUBSCRIBE_STALE_INIT"
                                                                                                                                                    failure 11841 EXPECTED_SUBSCRIBE_STALE_INIT "$EXPECTED_SUBSCRIBE_STALE_INIT" OBSERVED_SUBSCRIBE_STALE_INIT "$OBSERVED_SUBSCRIBE_STALE_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_INIT="\"subscribe\",\"valid-init\",4"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_INIT="$( head --lines 4 "$OUTPUT_FILE" | tail --lines 1 )" || failure 32080
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_INIT" != "$OBSERVED_SUBSCRIBE_VALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20315 EXPECTED_SUBSCRIBE_VALID_INIT "$EXPECTED_SUBSCRIBE_VALID_INIT" OBSERVED_SUBSCRIBE_VALID_INIT "$OBSERVED_SUBSCRIBE_VALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_RELEASE="\"subscribe\",\"valid-release\",5"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_RELEASE="$( head --lines 5 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20683
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_RELEASE" != "$OBSERVED_SUBSCRIBE_VALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 28681 EXPECTED_SUBSCRIBE_VALID_RELEASE "$EXPECTED_SUBSCRIBE_VALID_RELEASE" OBSERVED_SUBSCRIBE_VALID_RELEASE "$OBSERVED_SUBSCRIBE_VALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                WC_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 17924
                                                                                                                                                if [[ "$WC_SIX" != "5" ]]
                                                                                                                                                then
                                                                                                                                                    SIX="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                    failure 24681 SIX "$SIX"
                                                                                                                                                fi
                                                                                                                                                timeout 1m bash -c pre-test
                                                                                                                                                if true
                                                                                                                                                then
                                                                                                                                                    exit 0
                                                                                                                                                fi
                                                                                                                                                COUNT_7=0
                                                                                                                                                while [[ "$COUNT_7" != "7" ]]
                                                                                                                                                do
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_7="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 24082
                                                                                                                                                done
                                                                                                                                                EXPECTED_RELEASE="\"message\",\"valid-release\",\"${ release-message-file }\""
                                                                                                                                                OBSERVED_RELEASE="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 14819
                                                                                                                                                if [[ "$EXPECTED_RELEASE" != "$OBSERVED_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 13751 EXPECTED_RELEASE "$EXPECTED_RELEASE" OBSERVED_RELEASE "$OBSERVED_RELEASE"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_RELEASE_JSON='${ builtins.toJSON release }'
                                                                                                                                                OBSERVED_RELEASE_JSON="$( jq --compact-output "." ${ release-message-file } )" || failure 20816 ${ release-message-file }
                                                                                                                                                if [[ "$EXPECTED_RELEASE_JSON" != "$OBSERVED_RELEASE_JSON" ]]
                                                                                                                                                then
                                                                                                                                                    PRINT_RELEASE_JSON="$( jq "." ${ release-message-file } )" || failure 18266
                                                                                                                                                    failure 25932 EXPECTED_RELEASE_JSON "$EXPECTED_RELEASE_JSON" OBSERVED_RELEASE_JSON "$OBSERVED_RELEASE_JSON" PRINT_RELEASE_JSON "$PRINT_RELEASE_JSON"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SCRIPT='${ script }'
                                                                                                                                                OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 19776
                                                                                                                                                if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                then
                                                                                                                                                    SCRIPT_SEQUENCE="$( sequential )" || failure 29176
                                                                                                                                                    echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$SCRIPT_SEQUENCE"
                                                                                                                                                    DIFF_SCRIPT="$( diff --unified "$TEMPORARY/$SCRIPT_SEQUENCE" ${ script-file } )" || true
                                                                                                                                                    failure 5478 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 4256
                                                                                                                                                if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 27101
                                                                                                                                                    echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_ERROR="$( diff --unified "$TEMPORARY/$STANDARD_ERROR_SEQUENCE" ${ standard-error-file } )" || true
                                                                                                                                                    failure 20376 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 11369
                                                                                                                                                if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 29999
                                                                                                                                                    echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_OUTPUT="$( diff --unified "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE" ${ standard-output-file } )" || true
                                                                                                                                                    failure 22430 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                fi
                                                                                                                                                if [[ -e "${ invalid-init-16 alpha 17293 }" ]]
                                                                                                                                                then
                                                                                                                                                    failure 31812
                                                                                                                                                fi
                                                                                                                                                if [[ -e "${ invalid-release-16 alpha 17293 }" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20789
                                                                                                                                                fi
                                                                                                                                                WC_EIGHT="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 17418
                                                                                                                                                if [[ "$WC_EIGHT" != 7 ]]
                                                                                                                                                then
                                                                                                                                                    EIGHT="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 14060
                                                                                                                                                    failure 12459 EIGHT "$EIGHT"
                                                                                                                                                fi
                                                                                                                                            '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/false-true" ;
                                                                                                            true-false =
                                                                                                                let
                                                                                                                    alpha = 21 ;
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "true-false" ;
                                                                                                                                runtimeInputs =
                                                                                                                                    [
                                                                                                                                        failure
                                                                                                                                        pkgs.bash
                                                                                                                                        pkgs.coreutils
                                                                                                                                        pkgs.diffutils
                                                                                                                                        pkgs.findutils
                                                                                                                                        pkgs.jq
                                                                                                                                        pkgs.inotify-tools
                                                                                                                                        pkgs.redis
                                                                                                                                        (
                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                {
                                                                                                                                                    name = "pre-test" ;
                                                                                                                                                    runtimeInputs = [ failure pkgs.coreutils pkgs.diffutils pkgs.findutils pkgs.jq pkgs.inotify-tools pkgs.redis sequential ] ;
                                                                                                                                                    text =
                                                                                                                                                        let
                                                                                                                                                            init =
                                                                                                                                                                {
                                                                                                                                                                    arguments = [ "" ] ;
                                                                                                                                                                    has-standard-input = "false" ;
                                                                                                                                                                    hash = "e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764" ;
                                                                                                                                                                    index = pad-16 alpha 1 ;
                                                                                                                                                                    release-file = release-file ;
                                                                                                                                                                    script-file = script-file ;
                                                                                                                                                                    scripts-hash = "d167f7da399e6b01b83f44c3ecb00eb43f5b666e767882bd27e1758abd7c7cc87797e80307d86f0b3cf8a2946115f6cba1b7e99622f17cd83c1631cf92a5c464" ;
                                                                                                                                                                    seed = [ "production" "checks" "true" "true" ] ;
                                                                                                                                                                    standard-error-file = standard-error-file ;
                                                                                                                                                                    standard-input-file = standard-input-file ;
                                                                                                                                                                    standard-output-file = standard-output-file ;
                                                                                                                                                                    status = "0" ;
                                                                                                                                                                    targets =
                                                                                                                                                                        {
                                                                                                                                                                            expected = [ "31321" ] ;
                                                                                                                                                                            observed = [ "31321" ] ;
                                                                                                                                                                        } ;
                                                                                                                                                                } ;
                                                                                                                                                            init-message-file = log-16 alpha 5 ;
                                                                                                                                                            release =
                                                                                                                                                                ''
                                                                                                                                                                    #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                    set -o errexit
                                                                                                                                                                    set -o nounset
                                                                                                                                                                    set -o pipefail

                                                                                                                                                                    export PATH="/nix/store/xy9sa2741cinqmfpmqhdrk38gcv1waxb-trace/bin:/nix/store/f36dwk36j5pmkkdhzbnkds0aqvrrl2q3-destroy/bin:$PATH"

                                                                                                                                                                    mkdir --parents "${ gc-root alpha 5 }"
                                                                                                                                                                    export HASH=e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764
                                                                                                                                                                    export INDEX=${ pad-16 alpha 5 }
                                                                                                                                                                    destroy'' ;
                                                                                                                                                            release-file = release-16 alpha 1 ;
                                                                                                                                                            script =
                                                                                                                                                                ''
                                                                                                                                                                    #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                    set -o errexit
                                                                                                                                                                    set -o nounset
                                                                                                                                                                    set -o pipefail

                                                                                                                                                                    /nix/store/6avrj20bbivwnl6y8fsmhalzwiqd11n8-init/bin/init''  ;
                                                                                                                                                            script-file = log-16 alpha 2 ;
                                                                                                                                                            standard-error = "" ;
                                                                                                                                                            standard-error-file = log-16 alpha 3 ;
                                                                                                                                                            standard-input = "" ;
                                                                                                                                                            standard-input-file = log-16 alpha 0 ;
                                                                                                                                                            standard-output = "14060" ;
                                                                                                                                                            standard-output-file = log-16 alpha 4 ;
                                                                                                                                                            in
                                                                                                                                                                ''
                                                                                                                                                                    if OBSERVED_RESOURCE=${ resources.production.checks.true.false { failure = 16630 ; } }
                                                                                                                                                                    then
                                                                                                                                                                        failure 28991 OBSERVED_RESOURCE "$OBSERVED_RESOURCE"
                                                                                                                                                                    fi
                                                                                                                                                                    COUNT_SIX=0
                                                                                                                                                                    while [[ "$COUNT_SIX" -lt "6" ]]
                                                                                                                                                                    do
                                                                                                                                                                        sleep 1
                                                                                                                                                                        COUNT_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 20751
                                                                                                                                                                    done
                                                                                                                                                                    EXPECTED_INIT="\"message\",\"invalid-init\",\"${ init-message-file }\""
                                                                                                                                                                    OBSERVED_INIT="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 19870
                                                                                                                                                                    if [[ "$EXPECTED_INIT" != "$OBSERVED_INIT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 21911 EXPECTED_INIT "$EXPECTED_INIT" OBSERVED_INIT "$OBSERVED_INIT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_INIT_JSON='${ builtins.toJSON init }'
                                                                                                                                                                    OBSERVED_INIT_JSON="$( jq --compact-output "." ${ init-message-file } )" || failure 28702
                                                                                                                                                                    if [[ "$EXPECTED_INIT_JSON" != "$OBSERVED_INIT_JSON" ]]
                                                                                                                                                                    then
                                                                                                                                                                        PRINT_INIT_JSON="$( jq "." ${ init-message-file } )" || failure 23617
                                                                                                                                                                        failure 25864 EXPECTED_INIT_JSON "$EXPECTED_INIT_JSON" OBSERVED_INIT_JSON "$OBSERVED_INIT_JSON" PRINT_INIT_JSON "$PRINT_INIT_JSON"
                                                                                                                                                                    fi

                                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                                    EXPECTED_SCRIPT='${ script }'
                                                                                                                                                                    OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 29143
                                                                                                                                                                    if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        RELEASE_SEQUENCE="$( sequential )" || failure 15542
                                                                                                                                                                        echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$RELEASE_SEQUENCE"
                                                                                                                                                                        DIFF_SCRIPT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/SCRIPT" ${ script-file } )" || true
                                                                                                                                                                        failure 27209 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                                    OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 26985
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 21857
                                                                                                                                                                        echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_ERROR="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_ERROR" ${ standard-error-file } )" || true
                                                                                                                                                                        failure 14712 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_INPUT='${ standard-input }'
                                                                                                                                                                    OBSERVED_STANDARD_INPUT="$( cat ${ standard-input-file } )" || failure 23070
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_INPUT" != "$OBSERVED_STANDARD_INPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_INPUT_SEQUENCE="$( sequential )" || failure 30671
                                                                                                                                                                        echo "$EXPECTED_STANDARD_INPUT" > "$TEMPORARY/$STANDARD_INPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_INPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 14540 EXPECTED_STANDARD_INPUT "$EXPECTED_STANDARD_INPUT" OBSERVED_STANDARD_INPUT "$OBSERVED_STANDARD_INPUT" DIFF_STANDARD_INPUT "$DIFF_STANDARD_INPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                                    OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 14565
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 22790
                                                                                                                                                                        echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_OUTPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 17133 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    WC_SEVEN="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 21345
                                                                                                                                                                    if [[ "$WC_SEVEN" != 6 ]]
                                                                                                                                                                    then
                                                                                                                                                                        SEVEN="$( head --lines 7 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                                        failure 15295 SEVEN "$SEVEN"
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "${ invalid-init-16 alpha 17293 }" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 25204
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "${ invalid-release-16 alpha 17293 }" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 17711
                                                                                                                                                                    fi
                                                                                                                                                                '' ;
                                                                                                                                                }
                                                                                                                                        )
                                                                                                                                        sequential
                                                                                                                                    ] ;
                                                                                                                                text =
                                                                                                                                    let
                                                                                                                                        release =
                                                                                                                                            {
                                                                                                                                                hash = "e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764" ;
                                                                                                                                                index = pad-16 alpha 1 ;
                                                                                                                                                script-file = script-file ;
                                                                                                                                                seed = [ "production" "checks" "true" "true" ] ;
                                                                                                                                                standard-error-file = standard-error-file ;
                                                                                                                                                standard-output-file = standard-output-file ;
                                                                                                                                                status = "0" ;
                                                                                                                                            } ;
                                                                                                                                        release-message-file = log-16 alpha 9 ;
                                                                                                                                        script =
                                                                                                                                            ''
                                                                                                                                                #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                set -o errexit
                                                                                                                                                set -o nounset
                                                                                                                                                set -o pipefail

                                                                                                                                                /nix/store/ivcji4xkipn8zfiqj50yfgrq8g9cfxn1-release/bin/release'' ;
                                                                                                                                        script-file = log-16 alpha 6;
                                                                                                                                        standard-error = "" ;
                                                                                                                                        standard-error-file = log-16 alpha 7 ;
                                                                                                                                        standard-output = "18719" ;
                                                                                                                                        standard-output-file = log-16 alpha 8 ;
                                                                                                                                        in
                                                                                                                                            ''
                                                                                                                                                OUTPUT_SEQUENCE="$( sequential )" || failure 27462
                                                                                                                                                OUTPUT_FILE="$TEMPORARY/$OUTPUT_SEQUENCE"
                                                                                                                                                export OUTPUT_FILE
                                                                                                                                                touch "$OUTPUT_FILE"
                                                                                                                                                redis-cli --csv SUBSCRIBE invalid-init invalid-release stale-init valid-init valid-release > "$OUTPUT_FILE" &
                                                                                                                                                COUNT_5=0
                                                                                                                                                while [[ "$COUNT_5" -lt "5" ]]
                                                                                                                                                do
                                                                                                                                                    echo "$COUNT_5=$COUNT_5"
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_5="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 25731
                                                                                                                                                done
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_INIT="\"subscribe\",\"invalid-init\",1"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_INIT="$( head --lines 1 "$OUTPUT_FILE" )" || failure 17300
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_INIT" != "$OBSERVED_SUBSCRIBE_INVALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 14600 EXPECTED_SUBSCRIBE_INVALID_INIT "$EXPECTED_SUBSCRIBE_INVALID_INIT" OBSERVED_SUBSCRIBE_INVALID_INIT "$OBSERVED_SUBSCRIBE_INVALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_RELEASE="\"subscribe\",\"invalid-release\",2"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_RELEASE="$( head --lines 2 "$OUTPUT_FILE" | tail --lines 1 )" || failure 10496
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" != "$OBSERVED_SUBSCRIBE_INVALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 24664 EXPECTED_SUBSCRIBE_INVALID_RELEASE "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" OBSERVED_SUBSCRIBE_INVALID_RELEASE "$OBSERVED_SUBSCRIBE_INVALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_STALE_INIT="\"subscribe\",\"stale-init\",3"
                                                                                                                                                OBSERVED_SUBSCRIBE_STALE_INIT="$( head --lines 3 "$OUTPUT_FILE" | tail --lines 1 )" || failure 15439
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_STALE_INIT" != "$OBSERVED_SUBSCRIBE_STALE_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 30546 EXPECTED_SUBSCRIBE_STALE_INIT "$EXPECTED_SUBSCRIBE_STALE_INIT" OBSERVED_SUBSCRIBE_STALE_INIT "$OBSERVED_SUBSCRIBE_STALE_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_INIT="\"subscribe\",\"valid-init\",4"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_INIT="$( head --lines 4 "$OUTPUT_FILE" | tail --lines 1 )" || failure 32080
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_INIT" != "$OBSERVED_SUBSCRIBE_VALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20315 EXPECTED_SUBSCRIBE_VALID_INIT "$EXPECTED_SUBSCRIBE_VALID_INIT" OBSERVED_SUBSCRIBE_VALID_INIT "$OBSERVED_SUBSCRIBE_VALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_RELEASE="\"subscribe\",\"valid-release\",5"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_RELEASE="$( head --lines 5 "$OUTPUT_FILE" | tail --lines 1 )" || failure 29977
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_RELEASE" != "$OBSERVED_SUBSCRIBE_VALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20618 EXPECTED_SUBSCRIBE_VALID_RELEASE "$EXPECTED_SUBSCRIBE_VALID_RELEASE" OBSERVED_SUBSCRIBE_VALID_RELEASE "$OBSERVED_SUBSCRIBE_VALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                WC_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 27876
                                                                                                                                                if [[ "$WC_SIX" != "5" ]]
                                                                                                                                                then
                                                                                                                                                    SIX="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                    failure 12828 SIX "$SIX"
                                                                                                                                                fi
                                                                                                                                                timeout 1m bash -c pre-test
                                                                                                                                                failure 24924
                                                                                                                                                COUNT_7=0
                                                                                                                                                while [[ "$COUNT_7" != "7" ]]
                                                                                                                                                do
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_7="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 12422
                                                                                                                                                done
                                                                                                                                                EXPECTED_RELEASE="\"message\",\"valid-release\",\"${ release-message-file }\""
                                                                                                                                                OBSERVED_RELEASE="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 23165
                                                                                                                                                if [[ "$EXPECTED_RELEASE" != "$OBSERVED_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 21263 EXPECTED_RELEASE "$EXPECTED_RELEASE" OBSERVED_RELEASE "$OBSERVED_RELEASE" "$( cat /home/emory/resources/logs/0000000000000031 )"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_RELEASE_JSON='${ builtins.toJSON release }'
                                                                                                                                                OBSERVED_RELEASE_JSON="$( jq --compact-output "." ${ release-message-file } )" || failure 17324 ${ release-message-file }
                                                                                                                                                if [[ "$EXPECTED_RELEASE_JSON" != "$OBSERVED_RELEASE_JSON" ]]
                                                                                                                                                then
                                                                                                                                                    PRINT_RELEASE_JSON="$( jq "." ${ release-message-file } )" || failure 18266
                                                                                                                                                    failure 25932 EXPECTED_RELEASE_JSON "$EXPECTED_RELEASE_JSON" OBSERVED_RELEASE_JSON "$OBSERVED_RELEASE_JSON" PRINT_RELEASE_JSON "$PRINT_RELEASE_JSON"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SCRIPT='${ script }'
                                                                                                                                                OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 19776
                                                                                                                                                if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                then
                                                                                                                                                    SCRIPT_SEQUENCE="$( sequential )" || failure 27296
                                                                                                                                                    echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$SCRIPT_SEQUENCE"
                                                                                                                                                    DIFF_SCRIPT="$( diff --unified "$TEMPORARY/$SCRIPT_SEQUENCE" ${ script-file } )" || true
                                                                                                                                                    failure 22017 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 16063
                                                                                                                                                if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 31245
                                                                                                                                                    echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_ERROR="$( diff --unified "$TEMPORARY/$STANDARD_ERROR_SEQUENCE" ${ standard-error-file } )" || true
                                                                                                                                                    failure 28994 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 11369
                                                                                                                                                if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 21495
                                                                                                                                                    echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_OUTPUT="$( diff --unified "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE" ${ standard-output-file } )" || true
                                                                                                                                                    failure 29333 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                fi
                                                                                                                                                if [[ -e "${ invalid-init-16 alpha 17293 }" ]]
                                                                                                                                                then
                                                                                                                                                    failure 29251
                                                                                                                                                fi
                                                                                                                                                if [[ -e "${ invalid-release-16 alpha 17293 }" ]]
                                                                                                                                                then
                                                                                                                                                    failure 29221
                                                                                                                                                fi
                                                                                                                                                WC_EIGHT="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 30599
                                                                                                                                                if [[ "$WC_EIGHT" != 7 ]]
                                                                                                                                                then
                                                                                                                                                    EIGHT="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 14060
                                                                                                                                                    failure 32020 EIGHT "$EIGHT"
                                                                                                                                                fi
                                                                                                                                            '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/true-false" ;
                                                                                                            true-true =
                                                                                                                let
                                                                                                                    alpha = 21 ;
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "true-true" ;
                                                                                                                                runtimeInputs =
                                                                                                                                    [
                                                                                                                                        failure
                                                                                                                                        pkgs.bash
                                                                                                                                        pkgs.coreutils
                                                                                                                                        pkgs.diffutils
                                                                                                                                        pkgs.findutils
                                                                                                                                        pkgs.jq
                                                                                                                                        pkgs.inotify-tools
                                                                                                                                        pkgs.redis
                                                                                                                                        (
                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                {
                                                                                                                                                    name = "pre-test" ;
                                                                                                                                                    runtimeInputs = [ failure pkgs.coreutils pkgs.diffutils pkgs.findutils pkgs.jq pkgs.inotify-tools pkgs.redis sequential ] ;
                                                                                                                                                    text =
                                                                                                                                                        let
                                                                                                                                                            init =
                                                                                                                                                                {
                                                                                                                                                                    arguments = [ "" ] ;
                                                                                                                                                                    has-standard-input = "false" ;
                                                                                                                                                                    hash = "e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764" ;
                                                                                                                                                                    index = pad-16 alpha 5 ;
                                                                                                                                                                    release-file = release-file ;
                                                                                                                                                                    script-file = script-file ;
                                                                                                                                                                    scripts-hash = "d167f7da399e6b01b83f44c3ecb00eb43f5b666e767882bd27e1758abd7c7cc87797e80307d86f0b3cf8a2946115f6cba1b7e99622f17cd83c1631cf92a5c464" ;
                                                                                                                                                                    seed = [ "production" "checks" "true" "true" ] ;
                                                                                                                                                                    standard-error-file = standard-error-file ;
                                                                                                                                                                    standard-input-file = standard-input-file ;
                                                                                                                                                                    standard-output-file = standard-output-file ;
                                                                                                                                                                    status = "0" ;
                                                                                                                                                                    targets =
                                                                                                                                                                        {
                                                                                                                                                                            expected = [ "31321" ] ;
                                                                                                                                                                            observed = [ "31321" ] ;
                                                                                                                                                                        } ;
                                                                                                                                                                } ;
                                                                                                                                                            init-message-file = log-16 alpha 9 ;
                                                                                                                                                            release =
                                                                                                                                                                ''
                                                                                                                                                                    #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                    set -o errexit
                                                                                                                                                                    set -o nounset
                                                                                                                                                                    set -o pipefail

                                                                                                                                                                    export PATH="/nix/store/xy9sa2741cinqmfpmqhdrk38gcv1waxb-trace/bin:/nix/store/f36dwk36j5pmkkdhzbnkds0aqvrrl2q3-destroy/bin:$PATH"

                                                                                                                                                                    mkdir --parents "${ gc-root alpha 5 }"
                                                                                                                                                                    export HASH=e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764
                                                                                                                                                                    export INDEX=${ pad-16 alpha 5 }
                                                                                                                                                                    destroy'' ;
                                                                                                                                                            release-file = release-16 alpha 5 ;
                                                                                                                                                            script =
                                                                                                                                                                ''
                                                                                                                                                                    #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                                    set -o errexit
                                                                                                                                                                    set -o nounset
                                                                                                                                                                    set -o pipefail

                                                                                                                                                                    /nix/store/6avrj20bbivwnl6y8fsmhalzwiqd11n8-init/bin/init''  ;
                                                                                                                                                            script-file = log-16 alpha 6 ;
                                                                                                                                                            standard-error = "" ;
                                                                                                                                                            standard-error-file = log-16 alpha 7 ;
                                                                                                                                                            standard-input = "" ;
                                                                                                                                                            standard-input-file = log-16 alpha 3 ;
                                                                                                                                                            standard-output = "14060" ;
                                                                                                                                                            standard-output-file = log-16 alpha 8 ;
                                                                                                                                                            in
                                                                                                                                                                ''
                                                                                                                                                                    EXPECTED_RESOURCE=${ mount-16 alpha 5 }
                                                                                                                                                                    OBSERVED_RESOURCE=${ resources.production.checks.true.true { failure = 21760 ; } }
                                                                                                                                                                    if [[ "$EXPECTED_RESOURCE" != "$OBSERVED_RESOURCE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 15789 EXPECTED_RESOURCE "$EXPECTED_RESOURCE" OBSERVED_RESOURCE "$OBSERVED_RESOURCE"
                                                                                                                                                                    fi
                                                                                                                                                                    COUNT_SIX=0
                                                                                                                                                                    while [[ "$COUNT_SIX" -lt "6" ]]
                                                                                                                                                                    do
                                                                                                                                                                        sleep 1
                                                                                                                                                                        COUNT_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 24769
                                                                                                                                                                    done
                                                                                                                                                                    EXPECTED_INIT="\"message\",\"valid-init\",\"${ init-message-file }\""
                                                                                                                                                                    OBSERVED_INIT="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20277
                                                                                                                                                                    if [[ "$EXPECTED_INIT" != "$OBSERVED_INIT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 14530 EXPECTED_INIT "$EXPECTED_INIT" OBSERVED_INIT "$OBSERVED_INIT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_INIT_JSON='${ builtins.toJSON init }'
                                                                                                                                                                    OBSERVED_INIT_JSON="$( jq --compact-output "." ${ init-message-file } )" || failure 9412
                                                                                                                                                                    if [[ "$EXPECTED_INIT_JSON" != "$OBSERVED_INIT_JSON" ]]
                                                                                                                                                                    then
                                                                                                                                                                        PRINT_INIT_JSON="$( jq "." ${ init-message-file } )" || failure 23617
                                                                                                                                                                        failure 16098 EXPECTED_INIT_JSON "$EXPECTED_INIT_JSON" OBSERVED_INIT_JSON "$OBSERVED_INIT_JSON" PRINT_INIT_JSON "$PRINT_INIT_JSON"
                                                                                                                                                                    fi
                                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                                    EXPECTED_RELEASE='${ release }'
                                                                                                                                                                    OBSERVED_RELEASE="$( cat ${ release-file } )" || failure 19359
                                                                                                                                                                    if [[ "$EXPECTED_RELEASE" != "$OBSERVED_RELEASE" ]]
                                                                                                                                                                    then
                                                                                                                                                                        RELEASE_SEQUENCE="$( sequential )" || failure 20665
                                                                                                                                                                        echo "$EXPECTED_RELEASE" > "$TEMPORARY/$RELEASE_SEQUENCE"
                                                                                                                                                                        DIFF_RELEASE="$( diff --unified "$TEMPORARY/$RELEASE_SEQUENCE" ${ release-file } )" || true
                                                                                                                                                                        failure 4741951735942239 EXPECTED_RELEASE "$EXPECTED_RELEASE" OBSERVED_RELEASE "$OBSERVED_RELEASE" DIFF_RELEASE "$DIFF_RELEASE"
                                                                                                                                                                    fi
                                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                                    EXPECTED_SCRIPT='${ script }'
                                                                                                                                                                    OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 11196
                                                                                                                                                                    if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        RELEASE_SEQUENCE="$( sequential )" || failure 16175
                                                                                                                                                                        echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$RELEASE_SEQUENCE"
                                                                                                                                                                        DIFF_SCRIPT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/SCRIPT" ${ script-file } )" || true
                                                                                                                                                                        failure 18539 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                                    OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 31412
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 21857
                                                                                                                                                                        echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_ERROR="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_ERROR" ${ standard-error-file } )" || true
                                                                                                                                                                        failure 30053 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_INPUT='${ standard-input }'
                                                                                                                                                                    OBSERVED_STANDARD_INPUT="$( cat ${ standard-input-file } )" || failure 23070
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_INPUT" != "$OBSERVED_STANDARD_INPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_INPUT_SEQUENCE="$( sequential )" || failure 30671
                                                                                                                                                                        echo "$EXPECTED_STANDARD_INPUT" > "$TEMPORARY/$STANDARD_INPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_INPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 13551 EXPECTED_STANDARD_INPUT "$EXPECTED_STANDARD_INPUT" OBSERVED_STANDARD_INPUT "$OBSERVED_STANDARD_INPUT" DIFF_STANDARD_INPUT "$DIFF_STANDARD_INPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                                    OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 18330
                                                                                                                                                                    if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                                    then
                                                                                                                                                                        STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 22790
                                                                                                                                                                        echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                                        DIFF_STANDARD_OUTPUT="$( diff --unified "/home/${ config.personal.name }/resources/mounts/$INDEX/true-true/pre-test/STANDARD_INPUT" ${ standard-output-file } )" || true
                                                                                                                                                                        failure 16668 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                                    fi
                                                                                                                                                                    WC_SEVEN="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 21345
                                                                                                                                                                    if [[ "$WC_SEVEN" != 6 ]]
                                                                                                                                                                    then
                                                                                                                                                                        SEVEN="$( head --lines 7 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                                        failure 20505 SEVEN "$SEVEN"
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "/home/${ config.personal.name }/resources/invalid-init" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 23500
                                                                                                                                                                    fi
                                                                                                                                                                    if [[ -e "/home/${ config.personal.name }/resources/invalid-release" ]]
                                                                                                                                                                    then
                                                                                                                                                                        failure 13101
                                                                                                                                                                    fi
                                                                                                                                                                '' ;
                                                                                                                                                }
                                                                                                                                        )
                                                                                                                                        sequential
                                                                                                                                    ] ;
                                                                                                                                text =
                                                                                                                                    let
                                                                                                                                        release =
                                                                                                                                            {
                                                                                                                                                hash = "e0a0a4e4ae26d30986f07d58634add724195ef807bc6697193f9a89fe62e012113db34929a6409d830991489bf49e1cc16eba4bd2c21032220c95941c1a8b764" ;
                                                                                                                                                index = pad-16 alpha 5 ;
                                                                                                                                                script-file = script-file ;
                                                                                                                                                seed = [ "production" "checks" "true" "true" ] ;
                                                                                                                                                standard-error-file = standard-error-file ;
                                                                                                                                                standard-output-file = standard-output-file ;
                                                                                                                                                status = "0" ;
                                                                                                                                            } ;
                                                                                                                                        release-message-file = log-16 alpha 13 ;
                                                                                                                                        script =
                                                                                                                                            ''
                                                                                                                                                #!/nix/store/mjhcjikhxps97mq5z54j4gjjfzgmsir5-bash-5.2p37/bin/bash
                                                                                                                                                set -o errexit
                                                                                                                                                set -o nounset
                                                                                                                                                set -o pipefail

                                                                                                                                                /nix/store/ivcji4xkipn8zfiqj50yfgrq8g9cfxn1-release/bin/release'' ;
                                                                                                                                        script-file = log-16 alpha 10 ;
                                                                                                                                        standard-error = "" ;
                                                                                                                                        standard-error-file = log-16 alpha 11 ;
                                                                                                                                        standard-output = "18719" ;
                                                                                                                                        standard-output-file = log-16 alpha 12 ;
                                                                                                                                        in
                                                                                                                                            ''
                                                                                                                                                OUTPUT_SEQUENCE="$( sequential )" || failure 27462
                                                                                                                                                OUTPUT_FILE="$TEMPORARY/$OUTPUT_SEQUENCE"
                                                                                                                                                export OUTPUT_FILE
                                                                                                                                                touch "$OUTPUT_FILE"
                                                                                                                                                redis-cli --csv SUBSCRIBE invalid-init invalid-release stale-init valid-init valid-release > "$OUTPUT_FILE" &
                                                                                                                                                COUNT_5=0
                                                                                                                                                while [[ "$COUNT_5" -lt "5" ]]
                                                                                                                                                do
                                                                                                                                                    echo "$COUNT_5=$COUNT_5"
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_5="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 13785
                                                                                                                                                done
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_INIT="\"subscribe\",\"invalid-init\",1"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_INIT="$( head --lines 1 "$OUTPUT_FILE" )" || failure 29807
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_INIT" != "$OBSERVED_SUBSCRIBE_INVALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 30918 EXPECTED_SUBSCRIBE_INVALID_INIT "$EXPECTED_SUBSCRIBE_INVALID_INIT" OBSERVED_SUBSCRIBE_INVALID_INIT "$OBSERVED_SUBSCRIBE_INVALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_INVALID_RELEASE="\"subscribe\",\"invalid-release\",2"
                                                                                                                                                OBSERVED_SUBSCRIBE_INVALID_RELEASE="$( head --lines 2 "$OUTPUT_FILE" | tail --lines 1 )" || failure 10496
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" != "$OBSERVED_SUBSCRIBE_INVALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 21324 EXPECTED_SUBSCRIBE_INVALID_RELEASE "$EXPECTED_SUBSCRIBE_INVALID_RELEASE" OBSERVED_SUBSCRIBE_INVALID_RELEASE "$OBSERVED_SUBSCRIBE_INVALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_STALE_INIT="\"subscribe\",\"stale-init\",3"
                                                                                                                                                OBSERVED_SUBSCRIBE_STALE_INIT="$( head --lines 3 "$OUTPUT_FILE" | tail --lines 1 )" || failure 16256
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_STALE_INIT" != "$OBSERVED_SUBSCRIBE_STALE_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 11841 EXPECTED_SUBSCRIBE_STALE_INIT "$EXPECTED_SUBSCRIBE_STALE_INIT" OBSERVED_SUBSCRIBE_STALE_INIT "$OBSERVED_SUBSCRIBE_STALE_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_INIT="\"subscribe\",\"valid-init\",4"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_INIT="$( head --lines 4 "$OUTPUT_FILE" | tail --lines 1 )" || failure 32080
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_INIT" != "$OBSERVED_SUBSCRIBE_VALID_INIT" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20315 EXPECTED_SUBSCRIBE_VALID_INIT "$EXPECTED_SUBSCRIBE_VALID_INIT" OBSERVED_SUBSCRIBE_VALID_INIT "$OBSERVED_SUBSCRIBE_VALID_INIT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SUBSCRIBE_VALID_RELEASE="\"subscribe\",\"valid-release\",5"
                                                                                                                                                OBSERVED_SUBSCRIBE_VALID_RELEASE="$( head --lines 5 "$OUTPUT_FILE" | tail --lines 1 )" || failure 20683
                                                                                                                                                if [[ "$EXPECTED_SUBSCRIBE_VALID_RELEASE" != "$OBSERVED_SUBSCRIBE_VALID_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 28681 EXPECTED_SUBSCRIBE_VALID_RELEASE "$EXPECTED_SUBSCRIBE_VALID_RELEASE" OBSERVED_SUBSCRIBE_VALID_RELEASE "$OBSERVED_SUBSCRIBE_VALID_RELEASE"
                                                                                                                                                fi
                                                                                                                                                WC_SIX="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 17924
                                                                                                                                                if [[ "$WC_SIX" != "5" ]]
                                                                                                                                                then
                                                                                                                                                    SIX="$( head --lines 6 "$OUTPUT_FILE" | tail --lines 1 )" || failure 17032
                                                                                                                                                    failure 24681 SIX "$SIX"
                                                                                                                                                fi
                                                                                                                                                timeout 1m bash -c pre-test
                                                                                                                                                COUNT_7=0
                                                                                                                                                while [[ "$COUNT_7" != "7" ]]
                                                                                                                                                do
                                                                                                                                                    sleep 1
                                                                                                                                                    COUNT_7="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 24082
                                                                                                                                                done
                                                                                                                                                EXPECTED_RELEASE="\"message\",\"valid-release\",\"${ release-message-file }\""
                                                                                                                                                OBSERVED_RELEASE="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 14819
                                                                                                                                                if [[ "$EXPECTED_RELEASE" != "$OBSERVED_RELEASE" ]]
                                                                                                                                                then
                                                                                                                                                    failure 13751 EXPECTED_RELEASE "$EXPECTED_RELEASE" OBSERVED_RELEASE "$OBSERVED_RELEASE" "$( cat /home/emory/resources/logs/0000000000000031 )"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_RELEASE_JSON='${ builtins.toJSON release }'
                                                                                                                                                OBSERVED_RELEASE_JSON="$( jq --compact-output "." ${ release-message-file } )" || failure 20816 ${ release-message-file }
                                                                                                                                                if [[ "$EXPECTED_RELEASE_JSON" != "$OBSERVED_RELEASE_JSON" ]]
                                                                                                                                                then
                                                                                                                                                    PRINT_RELEASE_JSON="$( jq "." ${ release-message-file } )" || failure 18266
                                                                                                                                                    failure 25932 EXPECTED_RELEASE_JSON "$EXPECTED_RELEASE_JSON" OBSERVED_RELEASE_JSON "$OBSERVED_RELEASE_JSON" PRINT_RELEASE_JSON "$PRINT_RELEASE_JSON"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_SCRIPT='${ script }'
                                                                                                                                                OBSERVED_SCRIPT="$( cat ${ script-file } )" || failure 19776
                                                                                                                                                if [[ "$EXPECTED_SCRIPT" != "$OBSERVED_SCRIPT" ]]
                                                                                                                                                then
                                                                                                                                                    SCRIPT_SEQUENCE="$( sequential )" || failure 29176
                                                                                                                                                    echo "$EXPECTED_SCRIPT" > "$TEMPORARY/$SCRIPT_SEQUENCE"
                                                                                                                                                    DIFF_SCRIPT="$( diff --unified "$TEMPORARY/$SCRIPT_SEQUENCE" ${ script-file } )" || true
                                                                                                                                                    failure 5478 EXPECTED_SCRIPT "$EXPECTED_SCRIPT" OBSERVED_SCRIPT "$OBSERVED_SCRIPT" DIFF_SCRIPT "$DIFF_SCRIPT"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_ERROR='${ standard-error }'
                                                                                                                                                OBSERVED_STANDARD_ERROR="$( cat ${ standard-error-file } )" || failure 4256
                                                                                                                                                if [[ "$EXPECTED_STANDARD_ERROR" != "$OBSERVED_STANDARD_ERROR" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_ERROR_SEQUENCE="$( sequential )" || failure 27101
                                                                                                                                                    echo "$EXPECTED_STANDARD_ERROR" > "$TEMPORARY/$STANDARD_ERROR_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_ERROR="$( diff --unified "$TEMPORARY/$STANDARD_ERROR_SEQUENCE" ${ standard-error-file } )" || true
                                                                                                                                                    failure 20376 EXPECTED_STANDARD_ERROR "$EXPECTED_STANDARD_ERROR" OBSERVED_STANDARD_ERROR "$OBSERVED_STANDARD_ERROR" DIFF_STANDARD_ERROR "$DIFF_STANDARD_ERROR"
                                                                                                                                                fi
                                                                                                                                                EXPECTED_STANDARD_OUTPUT='${ standard-output }'
                                                                                                                                                OBSERVED_STANDARD_OUTPUT="$( cat ${ standard-output-file } )" || failure 11369
                                                                                                                                                if [[ "$EXPECTED_STANDARD_OUTPUT" != "$OBSERVED_STANDARD_OUTPUT" ]]
                                                                                                                                                then
                                                                                                                                                    STANDARD_OUTPUT_SEQUENCE="$( sequential )" || failure 29999
                                                                                                                                                    echo "$EXPECTED_STANDARD_OUTPUT" > "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE"
                                                                                                                                                    DIFF_STANDARD_OUTPUT="$( diff --unified "$TEMPORARY/$STANDARD_OUTPUT_SEQUENCE" ${ standard-output-file } )" || true
                                                                                                                                                    failure 22430 EXPECTED_STANDARD_OUTPUT "$EXPECTED_STANDARD_OUTPUT" OBSERVED_STANDARD_OUTPUT "$OBSERVED_STANDARD_OUTPUT" DIFF_STANDARD_OUTPUT "$DIFF_STANDARD_OUTPUT"
                                                                                                                                                fi
                                                                                                                                                if [[ -e "/home/${ config.personal.name }/resources/invalid-init" ]]
                                                                                                                                                then
                                                                                                                                                    failure 31812
                                                                                                                                                fi
                                                                                                                                                if [[ -e "/home/${ config.personal.name }/resources/invalid-release" ]]
                                                                                                                                                then
                                                                                                                                                    failure 20789
                                                                                                                                                fi
                                                                                                                                                WC_EIGHT="$( wc "$OUTPUT_FILE" --lines | cut --delimiter " " --fields 1 )" || failure 17418
                                                                                                                                                if [[ "$WC_EIGHT" != 7 ]]
                                                                                                                                                then
                                                                                                                                                    EIGHT="$( head --lines 8 "$OUTPUT_FILE" | tail --lines 1 )" || failure 14060
                                                                                                                                                    failure 12459 EIGHT "$EIGHT"
                                                                                                                                                fi
                                                                                                                                            '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/true-true" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    wrap \
                                                                                                                        ${ false-false } \
                                                                                                                        false-false \
                                                                                                                        0500 \
                                                                                                                        --literal plain COUNT_5 \
                                                                                                                        --literal plain COUNT_7 \
                                                                                                                        --literal plain DIFF_SCRIPT \
                                                                                                                        --literal plain DIFF_STANDARD_ERROR \
                                                                                                                        --literal plain DIFF_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_RELEASE \
                                                                                                                        --literal plain EXPECTED_RELEASE_JSON \
                                                                                                                        --literal plain EXPECTED_SCRIPT \
                                                                                                                        --literal plain EXPECTED_STANDARD_ERROR \
                                                                                                                        --literal plain EXPECTED_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain EIGHT \
                                                                                                                        --literal plain OBSERVED_RELEASE \
                                                                                                                        --literal plain OBSERVED_RELEASE_JSON \
                                                                                                                        --literal plain OBSERVED_SCRIPT \
                                                                                                                        --literal plain OBSERVED_STANDARD_ERROR \
                                                                                                                        --literal plain OBSERVED_STANDARD_OUTPUT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain OUTPUT_FILE \
                                                                                                                        --literal plain OUTPUT_SEQUENCE \
                                                                                                                        --literal plain PATH \
                                                                                                                        --literal plain SIX \
                                                                                                                        --literal plain SCRIPT_SEQUENCE \
                                                                                                                        --literal plain STANDARD_ERROR_SEQUENCE \
                                                                                                                        --literal plain STANDARD_OUTPUT_SEQUENCE \
                                                                                                                        --literal plain TEMPORARY \
                                                                                                                        --literal plain PRINT_RELEASE_JSON \
                                                                                                                        --literal plain WC_SIX \
                                                                                                                        --literal plain WC_EIGHT \
                                                                                                                        --uuid 20437
                                                                                                                    wrap \
                                                                                                                        ${ false-true } \
                                                                                                                        false-true \
                                                                                                                        0500 \
                                                                                                                        --literal plain COUNT_5 \
                                                                                                                        --literal plain COUNT_7 \
                                                                                                                        --literal plain DIFF_SCRIPT \
                                                                                                                        --literal plain DIFF_STANDARD_ERROR \
                                                                                                                        --literal plain DIFF_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_RELEASE \
                                                                                                                        --literal plain EXPECTED_RELEASE_JSON \
                                                                                                                        --literal plain EXPECTED_SCRIPT \
                                                                                                                        --literal plain EXPECTED_STANDARD_ERROR \
                                                                                                                        --literal plain EXPECTED_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain EIGHT \
                                                                                                                        --literal plain OBSERVED_RELEASE \
                                                                                                                        --literal plain OBSERVED_RELEASE_JSON \
                                                                                                                        --literal plain OBSERVED_SCRIPT \
                                                                                                                        --literal plain OBSERVED_STANDARD_ERROR \
                                                                                                                        --literal plain OBSERVED_STANDARD_OUTPUT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain OUTPUT_FILE \
                                                                                                                        --literal plain OUTPUT_SEQUENCE \
                                                                                                                        --literal plain PATH \
                                                                                                                        --literal plain SIX \
                                                                                                                        --literal plain SCRIPT_SEQUENCE \
                                                                                                                        --literal plain STANDARD_ERROR_SEQUENCE \
                                                                                                                        --literal plain STANDARD_OUTPUT_SEQUENCE \
                                                                                                                        --literal plain TEMPORARY \
                                                                                                                        --literal plain PRINT_RELEASE_JSON \
                                                                                                                        --literal plain WC_SIX \
                                                                                                                        --literal plain WC_EIGHT \
                                                                                                                        --uuid 21038
                                                                                                                    wrap \
                                                                                                                        ${ true-false } \
                                                                                                                        true-false \
                                                                                                                        0500 \
                                                                                                                        --literal plain COUNT_5 \
                                                                                                                        --literal plain COUNT_7 \
                                                                                                                        --literal plain DIFF_SCRIPT \
                                                                                                                        --literal plain DIFF_STANDARD_ERROR \
                                                                                                                        --literal plain DIFF_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_RELEASE \
                                                                                                                        --literal plain EXPECTED_RELEASE_JSON \
                                                                                                                        --literal plain EXPECTED_SCRIPT \
                                                                                                                        --literal plain EXPECTED_STANDARD_ERROR \
                                                                                                                        --literal plain EXPECTED_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain EIGHT \
                                                                                                                        --literal plain OBSERVED_RELEASE \
                                                                                                                        --literal plain OBSERVED_RELEASE_JSON \
                                                                                                                        --literal plain OBSERVED_SCRIPT \
                                                                                                                        --literal plain OBSERVED_STANDARD_ERROR \
                                                                                                                        --literal plain OBSERVED_STANDARD_OUTPUT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain OUTPUT_FILE \
                                                                                                                        --literal plain OUTPUT_SEQUENCE \
                                                                                                                        --literal plain PATH \
                                                                                                                        --literal plain SIX \
                                                                                                                        --literal plain SCRIPT_SEQUENCE \
                                                                                                                        --literal plain STANDARD_ERROR_SEQUENCE \
                                                                                                                        --literal plain STANDARD_OUTPUT_SEQUENCE \
                                                                                                                        --literal plain TEMPORARY \
                                                                                                                        --literal plain PRINT_RELEASE_JSON \
                                                                                                                        --literal plain WC_SIX \
                                                                                                                        --literal plain WC_EIGHT \
                                                                                                                        --uuid 11009
                                                                                                                    wrap \
                                                                                                                        ${ true-true } \
                                                                                                                        true-true \
                                                                                                                        0500 \
                                                                                                                        --literal plain COUNT_5 \
                                                                                                                        --literal plain COUNT_7 \
                                                                                                                        --literal plain DIFF_SCRIPT \
                                                                                                                        --literal plain DIFF_STANDARD_ERROR \
                                                                                                                        --literal plain DIFF_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_RELEASE \
                                                                                                                        --literal plain EXPECTED_RELEASE_JSON \
                                                                                                                        --literal plain EXPECTED_SCRIPT \
                                                                                                                        --literal plain EXPECTED_STANDARD_ERROR \
                                                                                                                        --literal plain EXPECTED_STANDARD_OUTPUT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain EXPECTED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain EIGHT \
                                                                                                                        --literal plain OBSERVED_RELEASE \
                                                                                                                        --literal plain OBSERVED_RELEASE_JSON \
                                                                                                                        --literal plain OBSERVED_SCRIPT \
                                                                                                                        --literal plain OBSERVED_STANDARD_ERROR \
                                                                                                                        --literal plain OBSERVED_STANDARD_OUTPUT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_INVALID_RELEASE \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_STALE_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_INIT \
                                                                                                                        --literal plain OBSERVED_SUBSCRIBE_VALID_RELEASE \
                                                                                                                        --literal plain OUTPUT_FILE \
                                                                                                                        --literal plain OUTPUT_SEQUENCE \
                                                                                                                        --literal plain PATH \
                                                                                                                        --literal plain SIX \
                                                                                                                        --literal plain SCRIPT_SEQUENCE \
                                                                                                                        --literal plain STANDARD_ERROR_SEQUENCE \
                                                                                                                        --literal plain STANDARD_OUTPUT_SEQUENCE \
                                                                                                                        --literal plain TEMPORARY \
                                                                                                                        --literal plain PRINT_RELEASE_JSON \
                                                                                                                        --literal plain WC_SIX \
                                                                                                                        --literal plain WC_EIGHT \
                                                                                                                        --uuid 19713
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/init" ;
                                                                            targets = [ "false-false" "false-true" "true-false" "true-true" ] ;
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
                                                        checks =
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
                                                                                                                    touch /mount/11273
                                                                                                                    echo 30796
                                                                                                                    exit 191
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
                                                                                                                    echo 29589
                                                                                                                    exit 131
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/release" ;
                                                                                    targets = [ "11273" ] ;
                                                                                } ;
                                                                        # FIND ME
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
                                                                                                                    touch /mount/32051
                                                                                                                    echo 14060
                                                                                                                    exit 123
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/init" ;
                                                                                    init-resolutions =
                                                                                        {
                                                                                            b4a45784de5a710c =
                                                                                                {
                                                                                                    c5db23113303796b =
                                                                                                        { failure , pkgs , resources , seed , sequential , trace } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "resolve" ;
                                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    echo 3292477133481244
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/resolve" ;
                                                                                                } ;
                                                                                            d6f7e33e04336ec1 =
                                                                                                {
                                                                                                    f76cca72fe96d8d9 =
                                                                                                        { failure , pkgs , resources , seed , sequential , trace } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "resolve" ;
                                                                                                                            runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    echo 8473391382136319
                                                                                                                                    exit 15
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/resolve" ;
                                                                                                } ;
                                                                                        } ;
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
                                                                                                                    echo 18719
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/release" ;
                                                                                    targets = [ "32051" ] ;
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
                                                                                                                    touch 27630
                                                                                                                    echo 19414
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
                                                                                                                    echo 29410
                                                                                                                    exit 177
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/release" ;
                                                                                    targets = [ "27630" ] ;
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
                                                                                                                    touch /mount/31321
                                                                                                                    echo 14060
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
                                                                                                                    echo 18719
                                                                                                                '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/release" ;
                                                                                    targets = [ "31321" ] ;
                                                                                } ;
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
                                                                                                                                                    export TEMPORARY="/home/${ config.personal.name }/resources/mounts/$INDEX/temporary"
                                                                                                                                                '' ;
                                                                                                                                        } ;
                                                                                                                                in "${ application }/bin/envrc" ;
                                                                                                                        in
                                                                                                                            ''
                                                                                                                                CHECKS=${ resources.production.product.checks { failure = 23739 ; } }
                                                                                                                                gc-root "$CHECKS"
                                                                                                                                export BIN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/bin" ) [ "$CHECKS" ] ) }
                                                                                                                                export MAN_PATH=${ builtins.concatStringsSep ":" ( builtins.map ( x : "${ x }/share/man" ) [ "$CHECKS" ] ) }
                                                                                                                                mkdir --parents /mount/temporary
                                                                                                                                wrap ${ envrc } .envrc 0400 --inherit plain BIN_PATH --inherit plain INDEX --inherit plain MAN_PATH --uuid 24290
                                                                                                                            '' ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/init" ;
                                                                                        targets = [ ".envrc" "temporary" ] ;
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
                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.flock pkgs.jq pkgs.redis pkgs.yq-go ] ;
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
                                                                                                                            jq --arg CHANNEL "$CHANNEL" --argjson STAMP "$STAMP" '. + { "channel" : $CHANNEL , "stamp" : $STAMP }' <<< "$PAYLOAD" | flock /home/${ config.personal.name }/resources/locks/log -c 'yq eval --prettyPrint "[.]" >> /home/${ config.personal.name }/resources/logs/log.yaml'
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
                                                    factory.check { expected = "/nix/store/xrpm94j1hmcg247fb7yqf030apd4lz1y-setup/bin/setup" ; mkDerivation = pkgs.stdenv.mkDerivation ; } ;
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
#                                        resource-true-true =
#                                            pkgs.nixosTest
#                                                {
#                                                    name = "resource-true-true" ;
#                                                    nodes.machine =
#                                                        { ... } :
#                                                            {
#                                                                imports =
#                                                                    builtins.concatLists
#                                                                        [
#                                                                            [ user ]
#                                                                            private
#                                                                        ] ;
#                                                            } ;
#                                                    testScript =
#                                                        let
#                                                            test =
#                                                                let
#                                                                    application =
#                                                                        pkgs.writeShellApplication
#                                                                            {
#                                                                                name = "test" ;
#                                                                                runtimeInputs = [ pkgs.coreutils ] ;
#                                                                                text =
#                                                                                    ''
#                                                                                        PAD="$( resource --resource '["production","pad","checks"]' )"
#                                                                                        cd "$PAD"
#                                                                                        # shellcheck disable=SC1091
#                                                                                        source .envrc
#                                                                                        ${ pkgs.coreutils }/bin/timeout 2m true-true
#                                                                                    '' ;
#                                                                            } ;
#                                                                    in "${ application }/bin/test" ;
#                                                            in
#                                                                ''
#                                                                    machine.wait_for_unit("multi-user.target")
#                                                                    machine.wait_for_unit("network-online.target")
#                                                                    machine.succeed("runuser --login ${ testuser } -- ${ test }")
#                                                                '' ;
#                                                } ;
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
