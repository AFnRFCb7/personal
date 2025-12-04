{
    inputs =
        {
        } ;
    outputs =
        { self } :
            {
                lib =
                    {
                        dot-gnupg ,
                        dot-ssh ,
                        failure ,
                        fixture ,
                        git-repository ,
                        nixpkgs ,
                        private ,
                        resource ,
                        secret ,
                        secrets ,
                        string ,
                        system ,
                        visitor
                    } @primary :
                        let
                            _dot-gnupg = dot-gnupg.lib { } ;
                            _dot-ssh = dot-ssh.lib { failure = _failure.implementation "4e91ae89" ; visitor = _visitor.implementation ; } ;
                            _failure = failure.lib { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; visitor = visitor ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                            _fixture = fixture.lib { age = pkgs.age ; coreutils = pkgs.coreutils ; failure = _failure.implementation "6bf7303d" ; gnupg = pkgs.gnupg ; libuuid = pkgs.libuuid ; mkDerivation = pkgs.stdenv.mkDerivation ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _git-repository = git-repository.lib { string = _string.implementation ; visitor = _visitor.implementation ; } ;
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
                            _secret = secret.lib { failure = _failure.implementation "0b2945d8" ; } ;
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
                                                                    in r.implementation { init = point.init or null ; seed = { path = path ; release = point.release or null ; resolutions = point.resolutions or [ ] ; } ; targets = point.targets or [ ] ; transient = point.transient or false ; } ;
                                                }
                                                {
                                                    foobar =
                                                        {
                                                            dot-gnupg =
                                                                ignore :
                                                                    _dot-gnupg.implementation
                                                                        {
                                                                            ownertrust-fun = { mount , pkgs , resources } : ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/ownertrust.asc" ;
                                                                            secret-keys-fun = { mount , pkgs , resources } : ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/secret-keys.asc" ;
                                                                        } ;
                                                            dot-ssh =
                                                                ignore :
                                                                    _dot-ssh.implementation
                                                                        {
                                                                            configuration =
                                                                                {
                                                                                    github =
                                                                                        {
                                                                                            strict-host-key-checking = true ;
                                                                                            host-name = "github.com" ;
                                                                                        } ;
                                                                                    mobile =
                                                                                        {
                                                                                            strict-host-key-checking = true ;
                                                                                            host-name = "192.168.1.192" ;
                                                                                            port = 19952 ;
                                                                                        } ;
                                                                                } ;
                                                                        } ;
                                                            foobar =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { mount , pkgs , resources } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gnupg ( _failure.implementation "b9d858ef" ) ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        INIT=false
                                                                                                        RELEASE=false
                                                                                                        if [[ 2 -eq "$#" ]]
                                                                                                        then
                                                                                                            if [[ true == "$1" ]]
                                                                                                            then
                                                                                                                INIT=true
                                                                                                            fi
                                                                                                            if [[ true == "$2" ]]
                                                                                                            then
                                                                                                                RELEASE=true
                                                                                                            fi
                                                                                                        fi
                                                                                                        if "$INIT"
                                                                                                        then
                                                                                                            failure b9a218e1
                                                                                                        fi
                                                                                                        echo "$INIT" > /mount/init
                                                                                                        echo "$RELEASE" > /mount/release
                                                                                                        chmod 0400 /mount/init /mount/release
                                                                                                        DOT_GNUPG=${ resources.foobar.dot-gnupg ( setup : setup ) }
                                                                                                        root-resource "$DOT_GNUPG"
                                                                                                        root-store ${ pkgs.gnupg }
                                                                                                        ln --symbolic "$DOT_GNUPG/dot-gnupg" /mount
                                                                                                        DOT_SSH=${ resources.foobar.dot-ssh ( setup : setup ) }
                                                                                                        root-resource "$DOT_SSH"
                                                                                                        ln --symbolic "$DOT_SSH/config" /mount/dot-ssh
                                                                                                        GIT_REPOSITORY=${ resources.foobar.git-repository ( setup : setup ) }
                                                                                                        root-resource "$GIT_REPOSITORY"
                                                                                                        ln --symbolic "$GIT_REPOSITORY/git-repository" /mount
                                                                                                        SECRET=${ resources.foobar.secret ( setup : setup ) }
                                                                                                        root-resource "$SECRET"
                                                                                                        ln --symbolic "$SECRET/secret" /mount
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        release =
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "release" ;
                                                                                            runtimeInputs = [ ( _failure.implementation "f99f6e39" ) ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    RELEASE="$( cat /mount/release )" || failure cd544f8e
                                                                                                    if $RELEASE
                                                                                                    then
                                                                                                        exit 99
                                                                                                    fi
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/release" ;
                                                                        resolutions = { init = [ "alpha" "beta" ] ; release = [ "gamma" "delta" ] ; } ;
                                                                        targets = [ "dot-gnupg" "dot-ssh" "git-repository" "init" "release" "secret" ] ;
                                                                        transient = true ;
                                                                    } ;
                                                            git-repository = ignore : _git-repository.implementation { } ;
                                                            secret = ignore : _secret.implementation { encrypted = ignore : "${ _fixture.implementation }/age/encrypted/known-hosts.asc" ; identity = ignore : "${ _fixture.implementation }/age/identity/private" ; } ;
                                                        } ;
                                                    production =
                                                        {
                                                            alpha =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { mount , pkgs , resources } :
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
                                                            dot-gnupg =
                                                                ignore :
                                                                    _dot-gnupg.implementation
                                                                        {
                                                                            ownertrust-fun = { mount , pkgs , resources } : resources.production.secrets.ownertrust ;
                                                                            secret-keys-fun = { mount , pkgs , resources } : resources.production.secrets.secret-keys ;
                                                                        } ;
                                                            dot-ssh =
                                                                ignore :
                                                                    _dot-ssh.implementation
                                                                        {
                                                                            configuration =
                                                                                {
                                                                                    "github.com" =
                                                                                        {
                                                                                            host-name = "github.com" ;
                                                                                            identity-file = ignore : "secret" ;
                                                                                            strict-host-key-checking = true ;
                                                                                            user-known-hosts-file = ignore : "secret" ;
                                                                                            user = "git" ;
                                                                                        } ;
                                                                                    laptop =
                                                                                        {
                                                                                            host-name = "127.0.0.1" ;
                                                                                            identity-file = ignore : "identity" ;
                                                                                            strict-host-key-checking = false ;
                                                                                            user-known-hosts-file = ignore : "known-hosts" ;
                                                                                        } ;
                                                                                    mobile =
                                                                                        {
                                                                                            host-name = "192.168.1.192" ;
                                                                                            # host-name = "192.0.0.4" ;
                                                                                            identity-file = ignore : "secret" ;
                                                                                            port = 8022 ;
                                                                                            strict-host-key-checking = false ;
                                                                                            user-known-hosts-file = ignore : "known-hosts" ;
                                                                                        } ;
                                                                                } ;
                                                                            resources =
                                                                                {
                                                                                    "github.com" =
                                                                                        {
                                                                                            identity-file = { mount , pkgs , resources } : resources.production.secrets.dot-ssh.github.identity-file ( setup : setup ) ;
                                                                                            user-known-hosts-file = { mount , pkgs , resources } : resources.production.secrets.dot-ssh.github.user-known-hosts-file ( setup : setup ) ;
                                                                                        } ;
                                                                                    laptop =
                                                                                        {
                                                                                            identity-file = { mount , pkgs , resources } : resources.production.fixture.laptop ( setup : setup ) ;
                                                                                            user-known-hosts-file = { mount , pkgs , resources } : resources.production.fixture.laptop ( setup : setup ) ;
                                                                                        } ;
                                                                                    mobile =
                                                                                        {
                                                                                            identity-file = { mount , pkgs , resources } : resources.production.secrets.dot-ssh.mobile.identity-file ( setup : setup ) ;
                                                                                            user-known-hosts-file = { mount , pkgs , resources } : resources.production.fixture.laptop ( setup : setup ) ;
                                                                                        } ;
                                                                                } ;
                                                                        } ;
                                                            fixture =
                                                                {
                                                                    laptop =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        { mount , pkgs , resources } :
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
                                                                                    { mount , pkgs , resources } :
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
                                                                                    { mount , pkgs , resources } :
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
                                                            repository =
                                                                {
                                                                    snapshot =
	                                                                    ignore :
		                                                                    _git-repository.implementation
                                                                                {
				                                                                    configs =
					                                                                    {
						                                                                    "alias.flake-build-vm" = stage : "!${ stage }/flake-build-vm" ;
						                                                                    "alias.flake-build-vm-with-bootloader" = stage : "!${ stage }/flake-build-vm-with-bootloader" ;
						                                                                    "alias.flake-check" = stage : "!${ stage }/flake-check" ;
						                                                                    "alias.flake-switch" = stage : "!${ stage }/flake-switch" ;
						                                                                    "alias.flake-test" = stage : "!${ stage }/flake-test" ;
						                                                                    "alias.scratch" = stage : "!${ stage }/scratch" ;
					                                                                    } ;
                                                                                    email = config.personal.repository.private.email ;
                                                                                    name = config.personal.repository.private.name ;
                                                                                    post-setup =
                                                                                        { mount , pkgs , resources } :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "post-setup" ;
                                                                                                            runtimeInputs = [ ] ;
                                                                                                            text =
                                                                                                                let
												                                                                    flake-build-vm =
													                                                                    let
														                                                                    application =
															                                                                    pkgs.writeShellApplication
																                                                                    {
																	                                                                    name = "flake-build-vm" ;
																	                                                                    text =
																		                                                                    ''
																			                                                                    VM=${ resources.production.flake.build-vm ( setup : ''${ setup } "$MOUNT/repository"'' ) }
																			                                                                    STATUS="$( cat "$VM/status" )" || failure
																			                                                                    if [[ "0" == "$STATUS" ]]
																			                                                                    then
																				                                                                    export SHARED_DIR="$VM/shared"
																				                                                                    "$VM/result/bin/run-nixos-vm"
																			                                                                    else
																				                                                                    failure "$VM" "$STATUS"
																			                                                                    fi
																		                                                                    '' ;
                                                                                                                                    } ;
														                                                                        in "${ application }/bin/flake-build-vm" ;
												                                                                    flake-build-vm-with-bootloader =
													                                                                    let
														                                                                    application =
															                                                                    pkgs.writeShellApplication
																                                                                    {
																	                                                                    name = "flake-build-vm-with-bootloader" ;
																	                                                                    text =
																		                                                                    ''
																			                                                                    VM=${ resources.production.flake.build-vm-with-bootloader ( setup : ''${ setup } "$MOUNT/repository"'' ) }
																			                                                                    STATUS="$( cat "$VM/status" )" || failure
																			                                                                    if [[ "0" == "$STATUS" ]]
																			                                                                    then
																				                                                                    export SHARED_DIR="$VM/shared"
																				                                                                    "$VM/result/bin/run-nixos-vm"
																			                                                                    else
																				                                                                    failure "$VM" "$STATUS"
																			                                                                    fi
																		                                                                    '' ;
                                                                                                                                    } ;
														                                                                        in "${ application }/bin/flake-build-vm-with-bootloader" ;
												                                                                        flake-check =
													                                                                        let
														                                                                        application =
															                                                                        pkgs.writeShellApplication
																                                                                        {
																	                                                                        name = "flake-check" ;
                                                                                                                                            runtimeInputs = [ pkgs.nix ] ;
																	                                                                        text =
																		                                                                        ''
																			                                                                        nix flake check "$MOUNT/repository"
																		                                                                        '' ;
																                                                                        } ;
														                                                                            in "${ application }/bin/flake-check" ;
												                                                                        flake-switch =
													                                                                        let
														                                                                        application =
															                                                                        pkgs.writeShellApplication
																                                                                        {
																	                                                                        name = "flake-switch" ;
																	                                                                        runtimeInputs =
																	                                                                            [
																	                                                                                pkgs.btrfs-progs
																	                                                                                pkgs.findutils
																	                                                                                ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" )
																	                                                                                (
																	                                                                                    pkgs.writeShellApplication
																	                                                                                        {
																	                                                                                            name = "flake-switch-input" ;
																	                                                                                            runtimeInputs = [ pkgs.gh pkgs.git pkgs.yq-go ] ;
																	                                                                                            text =
                                                                                                                                                                    ''
                                                                                                                                                                        INPUT="$1"
                                                                                                                                                                        STATUS="$2"
                                                                                                                                                                        cleanup ( ) {
                                                                                                                                                                            EXIT_CODE="$?"
                                                                                                                                                                            if [[ 0 != "$EXIT_CODE" ]]
                                                                                                                                                                            then
                                                                                                                                                                                cat > "$STATUS/FLAG" <<EOF
                                                                                                                                                                        INPUT="$INPUT"
                                                                                                                                                                        EXIT_CODE="$EXIT_CODE"
                                                                                                                                                                        EOF
                                                                                                                                                                            fi
                                                                                                                                                                        }
                                                                                                                                                                        trap cleanup EXIT
                                                                                                                                                                        echo "starting INPUT $INPUT"
                                                                                                                                                                        cd "$INPUT"
                                                                                                                                                                        git fetch origin main
                                                                                                                                                                        if ! git diff --quiet origin/main || ! git diff --quiet --cached origin/main
                                                                                                                                                                        then
                                                                                                                                                                            echo "there is a difference in $INPUT"
                                                                                                                                                                            git scratch
                                                                                                                                                                            git reset --soft origin/main
                                                                                                                                                                            git commit -a --verbose
                                                                                                                                                                            git push origin HEAD
                                                                                                                                                                            echo "squashed the scratch $INPUT"
                                                                                                                                                                            BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure 92c1bf82
                                                                                                                                                                            TOKEN=${ resources.production.secrets.token ( setup : setup ) }
                                                                                                                                                                            gh auth login --with-token < "$TOKEN/secret"
                                                                                                                                                                            if ! gh label list --json name --jq '.[].name' | grep -qx snapshot
                                                                                                                                                                            then
                                                                                                                                                                                gh label create snapshot --color "#333333" --description "Scripted Snapshot PR"
                                                                                                                                                                            fi
                                                                                                                                                                            gh pr create --base main --head "$BRANCH" --label "snapshot"
                                                                                                                                                                            URL="$( gh pr view --json url --jq .url )" || failure 15f039fa
                                                                                                                                                                            gh pr merge "$URL" --rebase
                                                                                                                                                                            INPUT_NAME="$( basename "$INPUT" )" || failure 73ea774d
                                                                                                                                                                            cd "$MOUNT/repository"
                                                                                                                                                                            nix flake update --flake "$MOUNT/repository" --update-input "$INPUT_NAME"
                                                                                                                                                                            gh auth logout
                                                                                                                                                                            echo "PRed $INPUT"
                                                                                                                                                                        else
                                                                                                                                                                            echo "there is no difference in $INPUT"
                                                                                                                                                                        fi
                                                                                                                                                                    '' ;
																	                                                                                        }
																	                                                                                )
                                                                                                                                                ] ;
																	                                                                        text =
                                                                                                                                                ''
                                                                                                                                                    echo starting
                                                                                                                                                    if ! nix flake check "$MOUNT/repository"
                                                                                                                                                    then
                                                                                                                                                        failure 225a0019 "We will not switch unless checks pass"
                                                                                                                                                    fi
                                                                                                                                                    STATUS=${ resources.production.temporary ( setup : setup ) }
                                                                                                                                                    echo switching inputs
                                                                                                                                                    find "$MOUNT/repository/inputs" -mindepth 1 -maxdepth 1 -type d -exec flake-switch-input {} "$STATUS" \;
                                                                                                                                                    if [[ -f "$STATUS/FLAG" ]]
                                                                                                                                                    then
                                                                                                                                                        FAILURE="$( cat "$STATUS/FLAG" )" || failure c2363ef6
                                                                                                                                                        failure 67fc4ef0 "We observed a problem with one of the inputs" "$FAILURE"
                                                                                                                                                    fi
                                                                                                                                                    echo successfully switched inputs
                                                                                                                                                    nixos-rebuild switch --flake "$MOUNT/repository#user"
                                                                                                                                                    git fetch origin main
                                                                                                                                                    git scratch
                                                                                                                                                    git reset --soft origin/main
                                                                                                                                                    git commit -a --verbose
                                                                                                                                                    git push origin HEAD
                                                                                                                                                    echo squashed the scratch branch
                                                                                                                                                    COMMIT="$( git rev-parse HEAD )" || failure d44ce079
                                                                                                                                                    git checkout main
                                                                                                                                                    git rebase "$COMMIT"
                                                                                                                                                    git push origin HEAD
                                                                                                                                                    echo squashed the main branch
                                                                                                                                                    git scratch
                                                                                                                                                    echo scratched the main branch
                                                                                                                                                '' ;
																                                                                        } ;
														                                                                        in "${ application }/bin/flake-switch" ;
												                                                                        flake-test =
													                                                                        let
														                                                                        application =
															                                                                        pkgs.writeShellApplication
																                                                                        {
																	                                                                        name = "flake-test" ;
																	                                                                        runtimeInputs = [ pkgs.btrfs-progs ( password-less-wrap pkgs.nixos-rebuild "nixos-rebuild" ) ] ;
																	                                                                        text =
                                                                                                                                                ''
                                                                                                                                                    echo nixos-rebuild test --flake "$MOUNT/repository#user"
                                                                                                                                                    nixos-rebuild test --flake "$MOUNT/repository#user"
                                                                                                                                                '' ;
																                                                                        } ;
														                                                                        in "${ application }/bin/flake-test" ;
                                                                                                                        scratch =
                                                                                                                            let
                                                                                                                                application =
                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "scratch" ;
                                                                                                                                            runtimeInputs = [ pkgs.git pkgs.libuuid ( _failure.implementation "c12332c6" ) ] ;
                                                                                                                                            text =
                                                                                                                                                ''
                                                                                                                                                    UUID="$( uuidgen | sha512sum )" || failure 73096040
                                                                                                                                                    BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 96d8692e
                                                                                                                                                    git checkout -b "$BRANCH" 2>&1
                                                                                                                                                '' ;
                                                                                                                                        } ;
                                                                                                                                    in "${ application }/bin/scratch" ;
                                                                                                                    in
                                                                                                                        ''
                                                                                                                            make-wrapper ${ flake-build-vm } /mount/stage/flake-build-vm "${ mount }"
                                                                                                                            make-wrapper ${ flake-build-vm-with-bootloader } /mount/stage/flake-build-vm-with-bootloader "${ mount }"
                                                                                                                            make-wrapper ${ flake-check } /mount/stage/flake-check "${ mount }"
                                                                                                                            make-wrapper ${ flake-switch } /mount/stage/flake-switch "${ mount }"
                                                                                                                            make-wrapper ${ flake-test } /mount/stage/flake-test "${ mount }"
                                                                                                                            make-wrapper ${ scratch } /mount/stage/scratch "${ mount }"
                                                                                                                        '' ;
                                                                                                        } ;
                                                                                                    in "${ application }/bin/post-setup" ;
                                                                                    pre-setup =
					                                                                    { mount , pkgs , resources } :
						                                                                    let
							                                                                    application =
								                                                                    pkgs.writeShellApplication
									                                                                    {
										                                                                    name = "setup" ;
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
                                                                                                                                                    ssh -F "$MOUNT/stage/dot-ssh" "$@"
                                                                                                                                                '' ;
                                                                                                                                        } ;
                                                                                                                                in "${ application }/bin/ssh" ;
												                                                                        in
                                                                                                                            ''
                                                                                                                                STUDIO="$1"
                                                                                                                                COMMIT="$2"
                                                                                                                                DOT_SSH=${ resources.production.dot-ssh ( self : self ) }
                                                                                                                                make-wrapper ${ ssh } /mount/stage/ssh "${ mount }"
                                                                                                                                root-resource "$DOT_SSH"
                                                                                                                                ln --symbolic "$DOT_SSH/config" "${ mount }/stage/dot-ssh"
                                                                                                                                git fetch "$STUDIO/repository" "$COMMIT" 2>&1
                                                                                                                                git checkout "$COMMIT" 2>&1
                                                                                                                            '' ;
                                                                                                        } ;
							                                                                        in "${ application }/bin/setup" ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.private.remote ;
                                                                                        } ;
                                                                                    ssh = stage : "${ stage }/ssh" ;
                                                                                    submodules =
                                                                                        {
                                                                                            "inputs/dot-gnupg".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/dot-ssh".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/failure".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/fixture".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/git-repository".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/personal".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/resource".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/secret".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/secrets".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/string".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                            "inputs/visitor".configs."alias.scratch" = stage : "!${ stage }/scratch" ;
                                                                                        } ;
			                                                                    } ;
                                                                    studio =
                                                                        ignore :
                                                                            _git-repository.implementation
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "alias.mutable-hydrate" = stage : "!${ stage }/mutable-hydrate" ;
                                                                                            "alias.mutable-rebase" = stage : "!${ stage }/mutable-rebase" ;
                                                                                            "alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "alias.mutable-snapshot" = stage : "!${ stage }/mutable-snapshot" ;
                                                                                            "core.sshCommand" = stage : "${ stage }/ssh" ;
                                                                                        } ;
                                                                                    email = config.personal.repository.private.email ;
                                                                                    name = config.personal.repository.private.name ;
                                                                                    post-setup =
                                                                                        { mount , pkgs , resources } :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "post-setup" ;
                                                                                                            runtimeInputs = [ pkgs.git ] ;
                                                                                                            text =
                                                                                                                let
                                                                                                                    mutable-rebase =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "mutable-rebase" ;
                                                                                                                                        runtimeInputs =
                                                                                                                                            [
                                                                                                                                                pkgs.findutils
                                                                                                                                                pkgs.git
                                                                                                                                                ( _failure.implementation "000d52f4" )
                                                                                                                                                (
                                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                                        {
                                                                                                                                                            name = "mutable-rebase-input" ;
                                                                                                                                                            runtimeInputs = [ pkgs.git ] ;
                                                                                                                                                            text =
                                                                                                                                                                ''
                                                                                                                                                                    INPUT="$1"
                                                                                                                                                                    STATUS="$2"
                                                                                                                                                                    cleanup ( ) {
                                                                                                                                                                        EXIT_CODE="$?"
                                                                                                                                                                        if [[ 0 != "$EXIT_CODE" ]]
                                                                                                                                                                        then
                                                                                                                                                                            cat > "$STATUS/FLAG" <<EOF
                                                                                                                                                                    INPUT="$INPUT"
                                                                                                                                                                    EXIT_CODE="$EXIT_CODE"
                                                                                                                                                                    EOF
                                                                                                                                                                        fi
                                                                                                                                                                    }
                                                                                                                                                                    trap cleanup EXIT
                                                                                                                                                                    if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                    then
                                                                                                                                                                        git mutable-scratch
                                                                                                                                                                        git commit -a --verbose --allow-empty-message
                                                                                                                                                                        git push origin HEAD
                                                                                                                                                                    fi
                                                                                                                                                                    git fetch origin main
                                                                                                                                                                    if ! git diff --quiet origin/main || ! git diff --quiet --cached
                                                                                                                                                                    then
                                                                                                                                                                        git mutable-scratch
                                                                                                                                                                        git rebase -i origin/main
                                                                                                                                                                        git push origin HEAD
                                                                                                                                                                    fi
                                                                                                                                                                '' ;
                                                                                                                                                        }
                                                                                                                                                )
                                                                                                                                            ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                STATUS=${ resources.production.temporary ( setup : setup ) }
                                                                                                                                                find inputs -mindepth 1 -maxdepth 1 -type d -exec mutable-rebase-input {} "$STATUS" \;
                                                                                                                                                if [[ -f "$STATUS/FLAG" ]]
                                                                                                                                                then
                                                                                                                                                    FAILURE="$( cat "$STATUS/FLAG" )" || failure 68f97f84
                                                                                                                                                    failure 74c899c7 "$FAILURE"
                                                                                                                                                fi
                                                                                                                                                if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                then
                                                                                                                                                    git mutable-scratch
                                                                                                                                                    git commit -a --verbose --allow-empty
                                                                                                                                                    git push origin HEAD
                                                                                                                                                fi
                                                                                                                                                git fetch origin main
                                                                                                                                                if ! git diff --quiet origin/main || ! git diff --quiet --cached origin/main
                                                                                                                                                then
                                                                                                                                                    git mutable-scratch
                                                                                                                                                    git rebase -i origin/main
                                                                                                                                                    git push origin HEAD
                                                                                                                                                fi
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                                in "${ application }/bin/mutable-rebase" ;
                                                                                                                    mutable-snapshot =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "mutable-snapshot" ;
                                                                                                                                        runtimeInputs =
                                                                                                                                            [
                                                                                                                                                pkgs.findutils
                                                                                                                                                ( _failure.implementation "" )
                                                                                                                                                (
                                                                                                                                                    pkgs.writeShellApplication
                                                                                                                                                        {
                                                                                                                                                            name = "snapshot-input" ;
                                                                                                                                                            runtimeInputs = [ ( _failure.implementation "19ae7e3f" ) ] ;
                                                                                                                                                            text =
                                                                                                                                                                ''
                                                                                                                                                                    INPUT="$1"
                                                                                                                                                                    STATUS="$2"
                                                                                                                                                                    cleanup ( ) {
                                                                                                                                                                        EXIT_CODE="$?"
                                                                                                                                                                        if [[ "$EXIT_CODE" != 0 ]]
                                                                                                                                                                        then
                                                                                                                                                                            cat > "$STATUS/FLAG" <<EOF
                                                                                                                                                                    INPUT="$INPUT"
                                                                                                                                                                    EXIT_CODE="$EXIT_CODE"
                                                                                                                                                                    EOF
                                                                                                                                                                        fi
                                                                                                                                                                    }
                                                                                                                                                                    cd "$INPUT"
                                                                                                                                                                    if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                    then
                                                                                                                                                                        git mutable-scratch
                                                                                                                                                                        git commit -a --verbose --allow-empty-message
                                                                                                                                                                        INPUT_NAME="$( basename "$INPUT" )" || failure 4cf69f5f
                                                                                                                                                                        cd "$MOUNT/repository"
                                                                                                                                                                        nix flake update --flake "$MOUNT/repository" --update-input "$INPUT_NAME"
                                                                                                                                                                    fi
                                                                                                                                                                    if git symbolic-ref -q HEAD > /dev/null
                                                                                                                                                                    then
                                                                                                                                                                        git push origin HEAD
                                                                                                                                                                    fi
                                                                                                                                                                '' ;
                                                                                                                                                        }
                                                                                                                                                )
                                                                                                                                            ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                GIT_SSH_COMMAND="$( git config --get core.sshCommand )" || failure cbe949dd
                                                                                                                                                export GIT_SSH_COMMAND
                                                                                                                                                STATUS=${ resources.production.temporary ( setup : setup ) }
                                                                                                                                                find "$MOUNT/repository/inputs" -mindepth 1 -maxdepth 1 -type d -exec snapshot-input {} "$STATUS" \;
                                                                                                                                                if [[ -f "$STATUS/FLAG" ]]
                                                                                                                                                then
                                                                                                                                                    FAILURE="$( cat "$STATUS/FLAG" )" || failure 8a05e85a
                                                                                                                                                    failure 19245941 "$FAILURE"
                                                                                                                                                fi
                                                                                                                                                if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                then
                                                                                                                                                    git mutable-scratch
                                                                                                                                                    git commit -a --verbose --allow-empty-message
                                                                                                                                                fi
                                                                                                                                                if git symbolic-ref -q HEAD > /dev/null
                                                                                                                                                then
                                                                                                                                                    git push origin HEAD
                                                                                                                                                fi
                                                                                                                                                COMMIT="$( git rev-parse HEAD )" || failure ae181cdd
                                                                                                                                                SNAPSHOT=${ resources.production.repository.snapshot ( setup : ''${ setup } "$MOUNT" "$COMMIT"'' ) }
                                                                                                                                                echo "$SNAPSHOT/repository"
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                                in "${ application }/bin/mutable-snapshot" ;
                                                                                                                    mutable-scratch =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "mutable-scratch" ;
                                                                                                                                        runtimeInputs = [ pkgs.git pkgs.libuuid ( _failure.implementation "c12332c6" ) ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure 73096040
                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 96d8692e
                                                                                                                                                git checkout -b "$BRANCH" 2>&1
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                                in "${ application }/bin/mutable-scratch" ;
                                                                                                                    in
                                                                                                                        ''
                                                                                                                            make-wrapper ${ mutable-rebase } /mount/stage/mutable-rebase "${ mount }"
                                                                                                                            make-wrapper ${ mutable-scratch } /mount/stage/mutable-scratch "${ mount }"
                                                                                                                            make-wrapper ${ mutable-snapshot } /mount/stage/mutable-snapshot "${ mount }"
                                                                                                                        '' ;
                                                                                                        } ;
                                                                                                    in "${ application }/bin/post-setup" ;
                                                                                    pre-setup =
                                                                                        { mount , pkgs , resources } :
                                                                                            let
                                                                                                application =
                                                                                                    pkgs.writeShellApplication
                                                                                                        {
                                                                                                            name = "setup" ;
                                                                                                            runtimeInputs = [ pkgs.git ] ;
                                                                                                            text =
                                                                                                                let
                                                                                                                    mutable-hydrate =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "mutable-hydrate" ;
                                                                                                                                        runtimeInputs = [ pkgs.coreutils ( _failure.implementation "" ) ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                BRANCH="$1"
                                                                                                                                                GIT_SSH_COMMAND="$( git config --get core.sshCommand )" || failure cbe949dd
                                                                                                                                                export GIT_SSH_COMMAND
                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                git fetch origin "$BRANCH" 2>&1
                                                                                                                                                git checkout "origin/$BRANCH" 2>&1
                                                                                                                                                git submodule sync 2>&1
                                                                                                                                                git submodule update --init --recursive 2>&1
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                        in "${ application }/bin/mutable-hydrate" ;
                                                                                                                    ssh =
                                                                                                                        let
                                                                                                                            application =
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "ssh" ;
                                                                                                                                        runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                ssh -F "$MOUNT/stage/dot-ssh/config" "$@"
                                                                                                                                            '' ;
                                                                                                                                    } ;
                                                                                                                            in "${ application }/bin/ssh" ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        DOT_SSH=${ resources.production.dot-ssh ( setup : "echo | ${ setup }" ) }
                                                                                                                        ln --symbolic "$DOT_SSH" /mount/stage/dot-ssh
                                                                                                                        root-resource "$DOT_SSH"
                                                                                                                        make-wrapper ${ ssh } /mount/stage/ssh "${ mount }"
                                                                                                                        make-wrapper ${ mutable-hydrate } /mount/stage/mutable-hydrate "${ mount }"
                                                                                                                        git mutable-hydrate main
                                                                                                                    '' ;
                                                                                                        } ;
                                                                                                in "${ application }/bin/setup" ;
                                                                                    remotes =
                                                                                        {
                                                                                            origin = config.personal.repository.private.remote ;
                                                                                        } ;
                                                                                    ssh = stage : "${ stage }/ssh" ;
                                                                                    submodules =
                                                                                        {
                                                                                            "inputs/dot-gnupg".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/dot-ssh".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/failure".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/fixture".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/git-repository".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/personal".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/resource".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/secret".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/secrets".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/string".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                            "inputs/visitor".configs."alias.mutable-scratch" = stage : "!${ stage }/mutable-scratch" ;
                                                                                        } ;
                                                                                } ;
                                                                } ;
                                                            secrets =
                                                                {
                                                                    dot-ssh =
                                                                        {
                                                                            github =
                                                                                {
                                                                                    identity-file = ignore : _secret.implementation { encrypted = ignore : "${ secrets }/dot-ssh/boot/identity.asc.age" ; identity = ignore : config.personal.agenix ; } ;
                                                                                    user-known-hosts-file = ignore : _secret.implementation { encrypted = ignore : "${ secrets }/dot-ssh/boot/known-hosts.asc.age" ; identity = ignore : config.personal.agenix ; } ;
                                                                                } ;
                                                                            mobile =
                                                                                {
                                                                                    identity-file = ignore : _secret.implementation { encrypted = ignore : "${ secrets }/dot-ssh/boot/identity.asc.age" ; identity = ignore : config.personal.agenix ; } ;
                                                                                    user-known-hosts-file = ignore : _secret.implementation { encrypted = ignore : "${ secrets }/dot-ssh/boot/known-hosts.asc.age" ; identity = ignore : config.personal.agenix ; } ;
                                                                                } ;
                                                                        } ;
                                                                    ownertrust-fun = ignore : secret { encrypted = ignore : "${ secrets }/ownertrust.asc.age" ; identity-file = ignore : config.personal.agenix ; } ;
                                                                    secret-keys-fun = ignore : secret { encrypted = ignore : "${ secrets }/secret-keys.asc.age" ; identity-file = ignore : config.personal.agenix ; } ;
                                                                    token = ignore : _secret.implementation { encrypted = ignore : "${ secrets }/github-token.asc.age" ; identity = ignore : config.personal.agenix ; } ;
                                                                } ;
                                                            temporary =
                                                                ignore :
                                                                    {
                                                                        init = { mount , pkgs , resources } : "" ;
                                                                        transient = true ;
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
                                                        systemd.services =
                                                            {
                                                                resources-log-error =
                                                                    {
                                                                        after = [ "network.target" "redis.service" ] ;
                                                                        enable = true ;
                                                                        serviceConfig =
                                                                            {
                                                                                ExecStart =
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "ExecStart" ;
                                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.flock pkgs.gettext pkgs.gnutar pkgs.jq pkgs.redis pkgs.yq-go ( _failure.implementation "8dc4f9ef" ) ] ;
                                                                                                    text =
                                                                                                        let
                                                                                                            resolve =
                                                                                                                let
                                                                                                                    application =
                                                                                                                        pkgs.writeShellApplication
                                                                                                                            {
                                                                                                                                name = "resolve" ;
                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gnutar pkgs.gzip pkgs.jq pkgs.xz ( _failure.implementation "7a2359f4" ) ] ;
                                                                                                                                text =
                                                                                                                                    ''
                                                                                                                                        ARGUMENTS=( "$@" )
                                                                                                                                        # shellcheck disable=SC2034
                                                                                                                                        ARGUMENTS_JSON="$( printf '%s\n' "${ builtins.concatStringsSep "" [ "$" "{" "ARGUMENTS[@]" "}" ] }" | jq -R . | jq -s . )" || failure c4af4aef
                                                                                                                                        if [[ -t 0 ]]
                                                                                                                                        then
                                                                                                                                            HAS_STANDARD_INPUT=false
                                                                                                                                            STANDARD_INPUT=""
                                                                                                                                        else
                                                                                                                                            HAS_STANDARD_INPUT=true
                                                                                                                                            STANDARD_INPUT="$( cat )" || failure b78f1b75
                                                                                                                                        fi
                                                                                                                                        export HAS_STANDARD_INPUT
                                                                                                                                        export STANDARD_INPUT
                                                                                                                                        export RELEASE
                                                                                                                                        JSON="$(
                                                                                                                                            jq \
                                                                                                                                                --null-input \
                                                                                                                                                --compact-output \
                                                                                                                                                --argjson ARGUMENTS "$ARGUMENTS_JSON" \
                                                                                                                                                --arg HAS_STANDARD_INPUT "$HAS_STANDARD_INPUT" \
                                                                                                                                                --arg STANDARD_INPUT "$STANDARD_INPUT" \
                                                                                                                                                '
                                                                                                                                                    {
                                                                                                                                                        "arguments" : $ARGUMENTS ,
                                                                                                                                                        "has-standard-input" : ( $HAS_STANDARD_INPUT | test("true") ) ,
                                                                                                                                                        "index" : "$INDEX" ,
                                                                                                                                                        "mode" : ( "$MODE" | test("true") ) ,
                                                                                                                                                        "release" : "$RELEASE" ,
                                                                                                                                                        "resolution" : "$RESOLUTION" ,
                                                                                                                                                        "standard-input" : $STANDARD_INPUT ,
                                                                                                                                                        "type" : "$TYPE"
                                                                                                                                                    }
                                                                                                                                                '
                                                                                                                                        )" || failure 32dfb4b0
                                                                                                                                        redis-cli PUBLISH ${ config.personal.channel } "$JSON" > /dev/null
                                                                                                                                        yq eval --prettyPrint "." - <<< "$JSON"
                                                                                                                                        rm --force "/home/${ config.personal.name }/resources/quarantine/$INDEX/init/resolve.sh"
                                                                                                                                        rm --recursive --force "/home/${ config.personal.name }/resources/quarantine/$INDEX/init/resolve"
                                                                                                                                    '' ;
                                                                                                                            } ;
                                                                                                                    in "${ application }/bin/resolve" ;
                                                                                                            in
                                                                                                                ''
                                                                                                                    redis-cli SUBSCRIBE ${ config.personal.channel } | while true
                                                                                                                    do
                                                                                                                        read -r TYPE || failure 06eacbb5
                                                                                                                        read -r CHANNEL || failure 9f93effe
                                                                                                                        read -r PAYLOAD || failure ff164dbc
                                                                                                                        if [[ "$TYPE" == "message" ]] && [[ "${ config.personal.channel }" == "$CHANNEL" ]]
                                                                                                                        then
                                                                                                                            TYPE_="$( jq --raw-output ".type" - <<< "$PAYLOAD" )" || failure 36088760
                                                                                                                            if [[ "invalid" == "$TYPE_" ]]
                                                                                                                            then
                                                                                                                                INDEX="$( yq eval ".index | tostring " - <<< "$PAYLOAD" )" || failure d4682955
                                                                                                                                mkdir --parents "/home/${ config.personal.name }/resources/quarantine/$INDEX/init"
                                                                                                                                export ARGUMENTS="\$ARGUMENTS"
                                                                                                                                export ARGUMENTS_JSON="\$ARGUMENTS_JSON"
                                                                                                                                export INDEX
                                                                                                                                export JSON="\$JSON"
                                                                                                                                export HAS_STANDARD_INPUT="\$HAS_STANDARD_INPUT"
                                                                                                                                RELEASE="$( yq eval ".description.secondary.seed.release" - <<< "$PAYLOAD" )" || failure 574def49
                                                                                                                                export RELEASE
                                                                                                                                export STANDARD_INPUT="\$STANDARD_INPUT"
                                                                                                                                export TYPE="resolve-init"
                                                                                                                                yq eval --prettyPrint '.' - <<< "$PAYLOAD" > "/home/${ config.personal.name }/resources/quarantine/$INDEX/init.yaml"
                                                                                                                                chmod 0400 "/home/${ config.personal.name }/resources/quarantine/$INDEX/init.yaml"
                                                                                                                                MODE=false RESOLUTION=init envsubst < "${ resolve }" > "/home/${ config.personal.name }/resources/quarantine/$INDEX/init.sh"
                                                                                                                                chmod 0500 "/home/${ config.personal.name }/resources/quarantine/$INDEX/init.sh"
                                                                                                                                yq eval '.description.secondary.seed.resolutions.init // [] | .[]' - <<< "$PAYLOAD" | while IFS= read -r RESOLUTION
                                                                                                                                do
                                                                                                                                    export MODE=true
                                                                                                                                    export RESOLUTION
                                                                                                                                    envsubst < "${ resolve }" > "/home/${ config.personal.name }/resources/quarantine/$INDEX/init/$RESOLUTION"
                                                                                                                                    chmod 0500 "/home/${ config.personal.name }/resources/quarantine/$INDEX/init/$RESOLUTION"
                                                                                                                                done
                                                                                                                            fi
                                                                                                                        fi
                                                                                                                    done
                                                                                                                '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/ExecStart" ;
                                                                                User = config.personal.name ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                                resources-log-cleaner =
                                                                    {
                                                                        after = [ "network.target" "redis.service" ] ;
                                                                        enable = true ;
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
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.redis
                                                                                                            pkgs.yq-go
                                                                                                            (
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "iteration" ;
                                                                                                                        runtimeInputs =
                                                                                                                            [
                                                                                                                                pkgs.coreutils
                                                                                                                                pkgs.gettext
                                                                                                                                pkgs.gnutar
                                                                                                                                pkgs.jq
                                                                                                                                pkgs.redis
                                                                                                                                pkgs.yq-go
                                                                                                                                pkgs.xz
                                                                                                                                (
                                                                                                                                    pkgs.buildFHSUserEnv
                                                                                                                                        {
                                                                                                                                            name = "release-application" ;
                                                                                                                                            extraBwrapArgs =
                                                                                                                                                [
                                                                                                                                                    "--bind /home/${ config.personal.name }/resources/mounts/$INDEX /mount"
                                                                                                                                                    "--tmpfs /scratch"
                                                                                                                                                ] ;
                                                                                                                                            runScript =
                                                                                                                                                let
                                                                                                                                                    application =
                                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                                            {
                                                                                                                                                                name = "runScript" ;
                                                                                                                                                                text = "$RELEASE" ;
                                                                                                                                                            } ;
                                                                                                                                                    in "${ application }/bin/runScript" ;
                                                                                                                                        }
                                                                                                                                )
                                                                                                                                ( _failure.implementation "efe4b476" )
                                                                                                                            ] ;
                                                                                                                        text =
                                                                                                                            let
                                                                                                                                resolve =
                                                                                                                                    let
                                                                                                                                        application =
                                                                                                                                            pkgs.writeShellApplication
                                                                                                                                                {
                                                                                                                                                    name = "resolve" ;
                                                                                                                                                    runtimeInputs = [ ] ;
                                                                                                                                                    text =
                                                                                                                                                        ''
                                                                                                                                                            if [[ -t 0 ]]
                                                                                                                                                            then
                                                                                                                                                                HAS_STANDARD_INPUT=false
                                                                                                                                                                STANDARD_INPUT="$( cat )" || failure 3010bde7
                                                                                                                                                            else
                                                                                                                                                                HAS_STANDARD_INPUT=true
                                                                                                                                                                STANDARD_INPUT=
                                                                                                                                                            fi
                                                                                                                                                            ARGUMENTS=( "$@" )
                                                                                                                                                            ARGUMENTS_JSON="$( printf '%s\n' "${ builtins.concatStringsSep "" [ "$" "{" "ARGUMENTS[@]" "}" ] }" | jq -R . | jq -s . )" || failure 93afac56
                                                                                                                                                            export HAS_STANDARD_INPUT
                                                                                                                                                            export STANDARD_INPUT
                                                                                                                                                            export RELEASE
                                                                                                                                                            JSON="$(
                                                                                                                                                                jq \
                                                                                                                                                                    --null-input \
                                                                                                                                                                    --compact-output \
                                                                                                                                                                    --arg ARGUMENTS "$ARGUMENTS_JSON" \
                                                                                                                                                                    --arg HAS_STANDARD_INPUT "$HAS_STANDARD_INPUT" \
                                                                                                                                                                    --arg STANDARD_INPUT "$STANDARD_INPUT" \
                                                                                                                                                                    '
                                                                                                                                                                        {
                                                                                                                                                                            "arguments" : $ARGUMENTS ,
                                                                                                                                                                            "has-standard-input" : ( $HAS_STANDARD_INPUT | test("true") ) ,
                                                                                                                                                                            "index" : ( "$INDEX" | tostring ) ,
                                                                                                                                                                            "mode" : ( "$MODE" | test("true") ) ,
                                                                                                                                                                            "resolution" : "$RESOLUTION" ,
                                                                                                                                                                            "standard-input" : $STANDARD_INPUT ,
                                                                                                                                                                            "type" : "resolve-release"
                                                                                                                                                                        }
                                                                                                                                                                    '
                                                                                                                                                            )" || failure e6780fa1
                                                                                                                                                            redis-cli PUBLISH ${ config.personal.channel } "$JSON" > /dev/null
                                                                                                                                                            yq eval --prettyPrint "." - <<< "$JSON"
                                                                                                                                                            rm --force "/home/${ config.personal.name }/resources/quarantine/$INDEX/release.sh"
                                                                                                                                                            rm --recursive --force  "/home/${ config.personal.name }/resources/quarantine/$INDEX/release"
                                                                                                                                                        '' ;
                                                                                                                                                } ;
                                                                                                                                            in "${ application }/bin/resolve" ;
                                                                                                                                in
                                                                                                                                    ''
                                                                                                                                        INDEX=
                                                                                                                                        HASH=
                                                                                                                                        ORIGINATOR_PID=
                                                                                                                                        RELEASE=
                                                                                                                                        while [[ "$#" -gt 0 ]]
                                                                                                                                        do
                                                                                                                                            case "$1" in
                                                                                                                                                --index)
                                                                                                                                                    INDEX="$2"
                                                                                                                                                    shift 2
                                                                                                                                                    ;;
                                                                                                                                                --hash)
                                                                                                                                                    HASH="$2"
                                                                                                                                                    shift 2
                                                                                                                                                    ;;
                                                                                                                                                --originator-pid)
                                                                                                                                                    ORIGINATOR_PID="$2"
                                                                                                                                                    shift 2
                                                                                                                                                    ;;
                                                                                                                                                --release)
                                                                                                                                                    RELEASE="$2"
                                                                                                                                                    shift 2
                                                                                                                                                    ;;
                                                                                                                                                --resolution)
                                                                                                                                                    RESOLUTIONS+=("$2")
                                                                                                                                                    shift 2
                                                                                                                                                    ;;
                                                                                                                                                *)
                                                                                                                                                    failure 464417ef
                                                                                                                                                    ;;
                                                                                                                                            esac
                                                                                                                                        done
                                                                                                                                        export ORIGINATOR_PID
                                                                                                                                        if [[ -n "$ORIGINATOR_PID" ]]
                                                                                                                                        then
                                                                                                                                            tail --follow /dev/null --pid "$ORIGINATOR_PID"
                                                                                                                                        fi
                                                                                                                                        while find /home/${ config.personal.name }/resources/links -mindepth 2 -maxdepth 2 -type l -exec readlink -f {} \; | grep --quiet "/home/${ config.personal.name }/resources/mounts/$INDEX"
                                                                                                                                        do
                                                                                                                                            sleep 1
                                                                                                                                        done
                                                                                                                                        export HASH
                                                                                                                                        if [[ -n "$HASH" ]]
                                                                                                                                        then
                                                                                                                                            exec 203> "/home/${ config.personal.name }/resources/locks/$HASH.lock"
                                                                                                                                            flock -x 203
                                                                                                                                        fi
                                                                                                                                        export RELEASE
                                                                                                                                        STANDARD_OUTPUT_FILE="$( mktemp )" || failure 5e6fd302
                                                                                                                                        STANDARD_ERROR_FILE="$( mktemp )" || failure da84a50d
                                                                                                                                        if release-application > "$STANDARD_OUTPUT_FILE" 2> "$STANDARD_ERROR_FILE"
                                                                                                                                        then
                                                                                                                                            STATUS="$?"
                                                                                                                                        else
                                                                                                                                            STATUS="$?"
                                                                                                                                        fi
                                                                                                                                        if [[ 0 == "$STATUS" ]] && [[ -n "$STANDARD_ERROR_FILE" ]]
                                                                                                                                        then
                                                                                                                                            TEMPORARY="$( mktemp --suffix .xz.tar )" || failure 1e7a248a
                                                                                                                                            cd "/home/${ config.personal.name }"
                                                                                                                                            tar --create --file "$TEMPORARY" --xz "resources/locks/$INDEX" "resources/mounts/$INDEX" "resources/quarantine/$INDEX" ".gc-roots/$INDEX"
                                                                                                                                            rm --recursive --force "resources/locks/$INDEX" "resources/mounts/$INDEX" ".gc-roots/$INDEX"
                                                                                                                                        else
                                                                                                                                            mkdir --parents "/home/${ config.personal.name }/resources/quarantine/$INDEX/release"
                                                                                                                                            STANDARD_ERROR="$( cat "$STANDARD_ERROR_FILE" )" || failure be48c573
                                                                                                                                            STANDARD_OUTPUT="$( cat "$STANDARD_OUTPUT_FILE" )" || failure 83137e6b
                                                                                                                                            jq \
                                                                                                                                                --null-input \
                                                                                                                                                --arg HASH "$HASH" \
                                                                                                                                                --arg INDEX "$INDEX" \
                                                                                                                                                --arg ORIGINATOR_PID "$ORIGINATOR_PID" \
                                                                                                                                                --arg RELEASE "$RELEASE" \
                                                                                                                                                --arg STANDARD_ERROR "$STANDARD_ERROR" \
                                                                                                                                                --arg STANDARD_OUTPUT "$STANDARD_OUTPUT" \
                                                                                                                                                --arg STATUS "$STATUS" \
                                                                                                                                                '{
                                                                                                                                                    "hash" : $HASH ,
                                                                                                                                                    "index" : $INDEX ,
                                                                                                                                                    "originator-pid" : $ORIGINATOR_PID ,
                                                                                                                                                    "release" : $RELEASE ,
                                                                                                                                                    "standard-error" : $STANDARD_ERROR ,
                                                                                                                                                    "standard-output" : $STANDARD_OUTPUT ,
                                                                                                                                                    "status" : $STATUS
                                                                                                                                                }' | yq eval --prettyPrint '.' - > "/home/${ config.personal.name }/resources/quarantine/$INDEX/release.yaml"
                                                                                                                                            chmod 0400 "/home/${ config.personal.name }/resources/quarantine/$INDEX/release.yaml"
                                                                                                                                            export ARGUMENTS="\$ARGUMENTS"
                                                                                                                                            export ARGUMENTS_JSON="\$ARGUMENTS_JSON"
                                                                                                                                            export HAS_STANDARD_INPUT="\$HAS_STANDARD_INPUT"
                                                                                                                                            export INDEX
                                                                                                                                            export STANDARD_INPUT="\$STANDARD_INPUT"
                                                                                                                                            export TYPE="resolve-release"
                                                                                                                                            echo bda7721c
                                                                                                                                            MODE=false RESOLUTION=release envsubst ${ resolve } "/home/${ config.personal.name }/resources/quarantine/$INDEX/release.sh"
                                                                                                                                            echo b5ed86ee
                                                                                                                                            chmod 0500 "/home/${ config.personal.name }/resources/quarantine/$INDEX/release.sh"
                                                                                                                                            echo a8fb4cbf
                                                                                                                                            for RESOLUTION in "${ builtins.concatStringsSep "" [ "$" "{" "RESOLUTIONS[@]" "}" ] }"
                                                                                                                                            do
                                                                                                                                                envsubst ${ resolve } "/home/${ config.personal.name }/resources/quarantine/$INDEX/release/resolve/$RESOLUTION"
                                                                                                                                                chmod 0500 "/home/${ config.personal.name }/resources/quarantine/$INDEX/release/resolve/$RESOLUTION"
                                                                                                                                            done
                                                                                                                                        fi
                                                                                                                                        rm "$STANDARD_OUTPUT_FILE" "$STANDARD_ERROR_FILE"
                                                                                                                                    '' ;
                                                                                                                    }
                                                                                                            )
                                                                                                        ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            redis-cli SUBSCRIBE ${ config.personal.channel } | while read -r TYPE
                                                                                                            do
                                                                                                                if [[ "$TYPE" == "message" ]]
                                                                                                                then
                                                                                                                    read -r CHANNEL
                                                                                                                    if [[ ${ config.personal.channel } == "$CHANNEL" ]]
                                                                                                                    then
                                                                                                                        read -r PAYLOAD
                                                                                                                        TYPE_="$( yq eval ".type" <<< "$PAYLOAD" - )" || failure 2ee1309a
                                                                                                                        if [[ "valid" == "$TYPE_" ]]
                                                                                                                        then
                                                                                                                            INDEX="$( yq eval ".index | tostring" - <<< "$PAYLOAD" )" || failure d79eee6f
                                                                                                                            HASH="$( yq eval ".hash | tostring" - <<< "$PAYLOAD" )" || failure 7753e2d6
                                                                                                                            RELEASE="$( yq eval ".description.secondary.seed.release | tostring" - <<< "$PAYLOAD" )" || failure 784a6c15
                                                                                                                            RESOLUTIONS=()
                                                                                                                            yq eval '.description.secondary.seed.resolutions.init // [] | .[]' - <<< "$PAYLOAD" | while IFS= read -r RESOLUTION
                                                                                                                            do
                                                                                                                                RESOLUTIONS+=("--resolution $RESOLUTION")
                                                                                                                            done
                                                                                                                            iteration --hash "$HASH" --index "$INDEX" --release "$RELEASE" "${ builtins.concatStringsSep "" [ "$" "{" "RESOLUTION[@]" "}" ] }" &
                                                                                                                        elif [[ "resolve-init" == "$TYPE_" ]]
                                                                                                                        then
                                                                                                                            INDEX="$( yq eval ".index | tostring" - <<< "$PAYLOAD" )" || failure f3c64901
                                                                                                                            echo "588d0f7b INDEX=$INDEX"
                                                                                                                            echo
                                                                                                                            echo "21818743 PAYLOAD=$PAYLOAD"
                                                                                                                            RELEASE="$( yq eval ".description.secondary.seed.release" - <<< "$PAYLOAD" )" || failure 3ae6bdb4
                                                                                                                            RESOLUTIONS=()
                                                                                                                            yq eval '.description.secondary.seed.resolutions.init // [] | .[]' - <<< "$PAYLOAD" | while IFS= read -r RESOLUTION
                                                                                                                            do
                                                                                                                                RESOLUTIONS+=("--resolution $RESOLUTION")
                                                                                                                            done
                                                                                                                            iteration --index "$INDEX" --release "$RELEASE" "${ builtins.concatStringsSep "" [ "$" "{" "RESOLUTION[@]" "}" ] }" &
                                                                                                                        fi
                                                                                                                    fi
                                                                                                                fi
                                                                                                            done
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/ExecStart" ;
                                                                                User = config.personal.name ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
                                                                    } ;
                                                                resources-log-listener =
                                                                   {
                                                                        after = [ "network.target" "redis.service" ] ;
                                                                        enable = true ;
                                                                        requires = [ "redis.service" ] ;
                                                                        serviceConfig =
                                                                            {
                                                                                ExecStart =
                                                                                    let
                                                                                        application =
                                                                                            pkgs.writeShellApplication
                                                                                                {
                                                                                                    name = "log-event-listener" ;
                                                                                                    runtimeInputs =
                                                                                                        [
                                                                                                            pkgs.coreutils
                                                                                                            pkgs.flock
                                                                                                            pkgs.jq
                                                                                                            pkgs.redis
                                                                                                            pkgs.yq-go
                                                                                                            ( _failure.implementation "c5160404" )
                                                                                                            (
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "iteration" ;
                                                                                                                        runtimeInputs =
                                                                                                                            [
                                                                                                                                pkgs.flock
                                                                                                                            ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                CHANNEL="$1"
                                                                                                                                PAYLOAD="$2"
                                                                                                                                TIMESTAMP="$( date +%s )" || failure 9fc28e61
                                                                                                                                TEMPORARY="$( mktemp )" || failure db44ba4a
                                                                                                                                echo
                                                                                                                                echo IS PAYLOAD JSON?
                                                                                                                                echo "$PAYLOAD"
                                                                                                                                echo
                                                                                                                                echo "$PAYLOAD" | jq --arg TIMESTAMP "$TIMESTAMP" --arg CHANNEL "$CHANNEL" '{ "channel" : $CHANNEL , "payload" : . , "timestamp" : $TIMESTAMP }' > "$TEMPORARY"
                                                                                                                                mkdir --parents /home/${ config.personal.name }/resources/logs
                                                                                                                                exec 203> /home/${ config.personal.name }/resources/logs/lock
                                                                                                                                flock 203
                                                                                                                                yq eval --prettyPrint '[.]' "$TEMPORARY" >> /home/${ config.personal.name }/resources/logs/log.yaml
                                                                                                                                rm "$TEMPORARY"
                                                                                                                            '' ;
                                                                                                                    }
                                                                                                            )
                                                                                                        ] ;
                                                                                                    text =
                                                                                                        ''
                                                                                                            redis-cli SUBSCRIBE "${ config.personal.channel }" | while true
                                                                                                            do
                                                                                                                read -r TYPE || failure 0b15dfb6
                                                                                                                read -r CHANNEL || failure 6fc3955c
                                                                                                                read -r PAYLOAD || failure ef9e9b75
                                                                                                                if [[ "message" == "$TYPE" ]]
                                                                                                                then
                                                                                                                    export ARGUMENTS="\$ARGUMENTS"
                                                                                                                    export ARGUMENTS_JSON="\$ARGUMENTS_JSON"
                                                                                                                    export HAS_STANDARD_INPUT="\$HAS_STANDARD_INPUT"
                                                                                                                    export JSON="\$JSON"
                                                                                                                    iteration "$CHANNEL" "$PAYLOAD" &
                                                                                                                fi
                                                                                                            done
                                                                                                        '' ;
                                                                                                } ;
                                                                                        in "${ application }/bin/log-event-listener" ;
                                                                                User = config.personal.name ;
                                                                            } ;
                                                                        wantedBy = [ "multi-user.target" ] ;
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
                                                                                            STUDIO=${ resources__.production.repository.studio ( setup : ''${ setup } "$ARGUMENTS"'' ) }
                                                                                            if "$HAS_ARGUMENTS"
                                                                                            then
                                                                                                echo "$STUDIO/repository"
                                                                                            else
                                                                                                idea-community "$STUDIO/repository"
                                                                                            fi
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        pkgs.git
                                                                        pkgs.chromium
                                                                        pkgs.redis
                                                                        pkgs.yq-go
                                                                        pkgs.jq
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "foobar-read" ;
                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.jq ] ;
                                                                                    text =
                                                                                        ''
                                                                                            jq "." < /tmp/message
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "foobar-listen" ;
                                                                                    runtimeInputs = [ pkgs.redis ] ;
                                                                                    text =
                                                                                        ''
                                                                                            redis-cli SUBSCRIBE resource | while read -r MESSAGE
                                                                                            do
                                                                                                echo "$MESSAGE" > /tmp/message
                                                                                            done
                                                                                        '' ;
                                                                                }
                                                                        )
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "foobar" ;
                                                                                    runtimeInputs = [ ] ;
                                                                                    text =
                                                                                        ''
                                                                                            FOOBAR=${ resources__.foobar.foobar ( setup : ''${ setup } "$@"'' ) }
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
                                                                        failure =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                email = lib.mkOption { default = "emory.merryman@gmail.com" ; type = lib.types.str ; } ;
                                                                                name = lib.mkOption { default = "Emory Merryman" ; type = lib.types.str ; } ;
                                                                                owner = lib.mkOption { default = "AFnRFCb7" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/failure.git" ; type = lib.types.str ; } ;
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
                            apps =
                                {
                                    chromium =
                                        {
                                            type = "app" ;
                                            program = "${ pkgs.chromium }/bin/chromium" ;
                                        } ;
                                    pass =
                                        {
                                            type = "app" ;
                                            program = "${ pkgs.pass }/bin/pass" ;
                                        } ;
                                } ;
                            checks =
                                {
                                    dot-gnupg =
                                        _dot-gnupg.check
                                            {
                                                expected = "/nix/store/8llbrkb6by8r1051zyxdz526rsh4p8qm-init/bin/init" ;
                                                failure = _failure.implementation "dff7788e" ;
                                                ownertrust-fun = { mount , pkgs , resources } : ignore : "${ fixture }/gnupg/ownertrust.asc" ; pkgs = pkgs ;
                                                secret-keys-fun = { mount , pkgs , resources } : ignore : "${ fixture }/gnupg/secret-keys.asc" ;
                                            } ;
                                    dot-ssh =
                                        _dot-ssh.check
                                            {
                                                configuration =
                                                    {
                                                        f5d69296 =
                                                            {
                                                                user-known-hosts-file = ignore : "dfdad39d" ;
                                                                port = 25112 ;
                                                                strict-host-key-checking = true ;
                                                                host-name = "d860b627" ;
                                                            } ;
                                                        cb8e09cf =
                                                            {
                                                                user-known-hosts-file = ignore : "c2a91e38" ;
                                                                strict-host-key-checking = false ;
                                                                port = 12310 ;
                                                                # we are excluding believe because it kept changing
                                                                # we need a better way to test this
                                                                # identity-file = ./. ;
                                                                host-name = "eedaca3e" ;
                                                            } ;
                                                    } ;
                                                expected = "/nix/store/iflzzyzrlm9qy68gn6bay3v3vx9c04j4-init/bin/init" ;
                                                mount = "271a376c" ;
                                                pkgs = pkgs ;
                                                implementation-resources =
                                                    {
                                                        cb8e09cf =
                                                            {
                                                                user-known-hosts-file = { mount , pkgs , resources } : builtins.toString pkgs.coreutils ;
                                                            } ;
                                                        f5d69296 =
                                                            {
                                                                user-known-hosts-file = { mount , pkgs , resources } : builtins.toString pkgs.coreutils ;
                                                            } ;
                                                        b8b6ddc8 =
                                                            {
                                                                strict-host-key-checking = { mount , pkgs , resources } : builtins.toString pkgs.coreutils ;
                                                                user-known-hosts-file = { mount , pkgs , resources } : builtins.toString pkgs.coreutils ;
                                                            } ;
                                                    } ;
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
                                                expected = "/nix/store/02b3yhim10iiibrb9cfp9m81kv9vjngp-init/bin/init" ;
                                                failure = _failure.implementation "8a8f3b60" ;
                                                pkgs = pkgs ;
                                            } ;
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
                                                        expected-resource-dependencies = [ "f70dbffba5f85b11de293ea0f9383ff05f210b1bcca0443f79657db645a2187594511f7ce158302a8c7f249e8dc47128baa17302e96b3be43b6e33d26e822a77" ] ;
                                                        expected-store-dependencies = [ "bjb2xx943rkfl0r6x7wgp2069zym5wwi-cowsay-3.8.3" ] ;
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
                                                            { mount , pkgs , resources } :
                                                                let
                                                                    application =
                                                                        pkgs.writeShellApplication
                                                                            {
                                                                                name = "init" ;
                                                                                runtimeInputs = [ pkgs.coreutils pkgs.libuuid pkgs.cowsay ] ;
                                                                                text =
                                                                                    ''
                                                                                        cowsay f83f1836809a4c2148e7c4d4b3dc543d2d368085d786a49366fd8b36cd730d93502da258b69d1694f2a437efa86666cf44a72e2c574a4520440621e8dc2a9fc8
                                                                                        ${ resources.d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 }
                                                                                        echo "mount = ${ mount }"
                                                                                        echo 67db2c662c09536dece7b873915f72c7746539be90c282d1dfd0a00c08bed5070bc9fbe2bb5289bcf10563f9e5421edc5ff3323f87a5bed8a525ff96a13be13d > /mount/e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4
                                                                                        echo 99757ea5f69970ca7258207b42b7e76e09821b228db8906609699f0ed08191f606d6bdde022f8f158b9ecb7b4d70fdc8f520728867f5af35d1e189955d990a64 > /scratch/a127c8975e5203fd4d7ca6f7996aa4497b02fe90236d6aa830ca3add382084b24a3aeefb553874086c904196751b4e9fe17cfa51817e5ca441ef196738f698b5
                                                                                        root-resource ${ resources.d154b4d928d4df6e2f281414a142e96351ca55b7487330ce64fa596d0f64fb5147fc9acc7617a58701542c934b50466c6fe97805d01e357bcaae550862bd6266 }
                                                                                        root-store ${ pkgs.cowsay }
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
                                                     expected-resource-dependencies = [ "5552fc1d63b863ab116115819c2f0f2f2fb7e47fc59fd4ef3e99651b982f54b050afa38207f9d74d18a7f6e167debc1c9aad4962b22340091c45878cc1abd75c" ] ;
                                                     expected-store-dependencies = [ ] ;
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
                                                     expected-type = "invalid" ;
                                                     init =
                                                         { mount , pkgs , resources } :
                                                             let
                                                                 application =
                                                                     pkgs.writeShellApplication
                                                                         {
                                                                             name = "init" ;
                                                                             runtimeInputs = [ pkgs.coreutils pkgs.cowsay ] ;
                                                                             text =
                                                                                 ''
                                                                                     cowsay cfb1a86984144d2e4c03594b4299585aa6ec2f503a7b39b1385a5338c9fc314fd87bd904d01188b301b3cf641c4158b28852778515eba52ad7e4b148f216d1d5
                                                                                     ${ resources.fd8e39c7a8bb3055daa71667bb0f21120642956a6ea043d0fb28c48cddba6ed8acac09c4e130da9a5e638ea8553b6fa2f45bcdef92fe62c40b70d257cc19a379 }
                                                                                     echo "mount = ${ mount }"
                                                                                     echo ae7afb90a11109a5cb07209ec48fa2d376ca0338c14c9c505f465c7cb658091549ae5344378e229674606ff46fcaf3db24b2d2b0870587d67bcad79b358ec2b9 >&2
                                                                                     echo 97d4fec983cd3fd46ce371f0cff6f660f066924c8bd57704e2382fb0df84eb7c03e667cfb6837c2c3638dd6b5aea4f4b1c8e4fd8944de89c458313f31afa2d5b > /mount/3e30e86404135fc6036abb77e19e8cf73bb32074c07b3273a45e1262bb308f68d420d3549624ee2a44030ba23147465ed85b2c320d0661b1835627aeec050289
                                                                                     echo 8393b1c1c760a903ea3a17d3c5831b1ed7b16bbb6ff6d9ccb751406e1fbe7c416a39fc440baf1b4a660dd928e1c060c0c05220cae8028ffde038dba033d25046 > /scratch/ea7c5d3879f282c8d3a0a2c85c464d129bc9a034d2fc9287b6588a96d1659c46a04f0e5e23f4bddd67425cee44043e421420eed8ba7cf7d2d3ecb9d8efab9f37
                                                                                     root-resource ${ resources.fd8e39c7a8bb3055daa71667bb0f21120642956a6ea043d0fb28c48cddba6ed8acac09c4e130da9a5e638ea8553b6fa2f45bcdef92fe62c40b70d257cc19a379 }
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
                                        secret =
                                            _secret.check
                                                {
                                                    encrypted = ignore : "${ fixture }/age/encrypted/known-hosts.asc" ;
                                                    expected = "/nix/store/6hghn0kl1k9arrw0ycr3vf1qxcf2kfj6-init/bin/init" ;
                                                    identity = ignore : "${ fixture }/age/identity/private" ;
                                                    failure = _failure.implementation "a720a5e7" ;
                                                    pkgs = pkgs ;
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
