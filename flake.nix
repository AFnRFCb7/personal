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
                            _dot-ssh = dot-ssh.lib { visitor = _visitor.implementation ; } ;
                            _failure = failure.lib { coreutils = pkgs.coreutils ; jq = pkgs.jq ; mkDerivation = pkgs.stdenv.mkDerivation ; visitor = visitor ; writeShellApplication = pkgs.writeShellApplication ; yq-go = pkgs.yq-go ; } ;
                            _fixture = fixture.lib { age = pkgs.age ; coreutils = pkgs.coreutils ; failure = _failure.implementation "6bf7303d" ; gnupg = pkgs.gnupg ; libuuid = pkgs.libuuid ; mkDerivation = pkgs.stdenv.mkDerivation ; writeShellApplication = pkgs.writeShellApplication ; } ;
                            _git-repository = git-repository.lib { visitor = _visitor.implementation ; } ;
                            _resource =
                                {
                                    resources-directory ,
                                    resources ,
                                    store-garbage-collection-root
                                } :
                                    resource.lib
                                        {
                                            buildFHSUserEnv = pkgs.buildFHSUserEnv ;
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
                            _secret = secret.lib { } ;
                            _string = string.lib { visitor = _visitor.implementation ; } ;
                            _visitor = visitor.lib { } ;
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
                                                                            resources = resources__ ;
                                                                            resources-directory = "/home/${ config.personal.name }/resources" ;
                                                                            store-garbage-collection-root = "/home/${ config.personal.name }/.gc-roots" ;
                                                                        } ;
                                                                    in r.implementation { init = point.init or null ; seed = path ; targets = point.targets or [ ] ; transient = point.transient or false ; } ;
                                                }
                                                {
                                                    foobar =
                                                        {
                                                            dot-gnupg = ignore : _dot-gnupg.implementation { ownertrust-fun = { pkgs , resources , self } : ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/ownertrust.asc" ; secret-keys-fun = { pkgs , resources , self } : ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/secret-keys.asc" ; } ;
                                                            dot-ssh =
                                                                ignore :
                                                                    _dot-ssh.implementation
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
                                                                                    port = 8022 ;
                                                                                } ;
                                                                        } ;
                                                            foobar =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { pkgs , resources , self } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gnupg ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        DOT_GNUPG=${ resources.foobar.dot-gnupg ( setup : setup ) }
                                                                                                        root-resource "$DOT_GNUPG"
                                                                                                        root-store ${ pkgs.gnupg }
                                                                                                        ln --symbolic "$DOT_GNUPG/dot-gnupg" /mount
                                                                                                        DOT_SSH=${ resources.foobar.dot-ssh ( setup : setup ) }
                                                                                                        root-resource "$DOT_SSH"
                                                                                                        ln --symbolic "$DOT_SSH/dot-ssh" /mount
                                                                                                        GIT_REPOSITORY=${ resources.foobar.git-repository ( setup : setup ) }
                                                                                                        root-resource "$GIT_REPOSITORY"
                                                                                                        ln --symbolic "$GIT_REPOSITORY/git-repository" /mount
                                                                                                        SECRET=${ resources.foobar.secret ( setup : setup ) }
                                                                                                        root-resource "$SECRET"
                                                                                                        ln --symbolic "$SECRET/secret" /mount
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        targets = [ "dot-gnupg" "dot-ssh" "git-repository" "secret" ] ;
                                                                        transient = true ;
                                                                    } ;
                                                            git-repository = ignore : _git-repository.implementation { } ;
                                                            secret = ignore : _secret.implementation { encrypted = ignore : "${ _fixture.implementation }/age/encrypted/known-hosts.asc" ; identity = ignore : "${ _fixture.implementation }/age/identity/private" ; } ;
                                                        } ;
                                                    production =
                                                        {
                                                            dot-gnupg =
                                                                ignore :
                                                                    _dot-gnupg.implementation
                                                                        {
                                                                            ownertrust-fun = { pkgs , resources , self } : resources.production.secrets.ownertrust ;
                                                                            secret-keys-fun = { pkgs , resources , self } : resources.production.secrets.secret-keys ;
                                                                        } ;
                                                            dot-ssh =
                                                                ignore :
                                                                    _dot-ssh.implementation
                                                                        {
                                                                            "github.com" =
                                                                                {
                                                                                    host-name = "github.com" ;
                                                                                    identity-file = { pkgs , resources , self } : { directory = resources.production.secrets.dot-ssh.github.identity-file ( setup : setup ) ; file = "secret" ; } ;
                                                                                    strict-host-key-checking = true ;
                                                                                    user-known-hosts-file = { pkgs , resources , self } : { directory = resources.production.secrets.dot-ssh.github.user-known-hosts-file ( setup : setup ) ; file = "secret" ; } ;
                                                                                    user = "git" ;
                                                                                } ;
                                                                            mobile =
                                                                                {
                                                                                    host-name = "192.168.1.192" ;
                                                                                    identity-file = { pkgs , resources , self } : { directory = resources.production.secrets.dot-ssh.mobile.identity-file ( setup : setup ) ; file = "secret" ; } ;
                                                                                    port = 8022 ;
                                                                                    strict-host-key-checking = true ;
                                                                                    user-known-hosts-file = { pkgs , resources , self } : { directory = resources.production.secrets.dot-ssh.mobile.user-known-hosts-file ( setup : setup ) ; file = "secret" ; } ;
                                                                                } ;
                                                                        } ;
                                                            nix =
                                                                {
                                                                    build =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { pkgs , resources , self } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.findutils pkgs.git pkgs.nixos-rebuild ( _failure.implementation "e8f7af55" ) ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                in
                                                                                                                    ''
                                                                                                                        DIRECTORY="$1"
                                                                                                                        FILE="$2"
                                                                                                                        cd /mount
                                                                                                                        root-store "$DIRECTORY"
                                                                                                                        INPUTS=()
                                                                                                                        while IFS= read -r INPUT
                                                                                                                        do
                                                                                                                            INPUT_NAME="$( basename "$INPUT" )" || failure e661dd72
                                                                                                                            INPUT_REMOTE="$( git -C "$INPUT" remote get-url origin )" || failure d6230040
                                                                                                                            INPUT_COMMIT="$( git -C "$INPUT" rev-parse HEAD )" || failure 081de42a
                                                                                                                            INPUTS+=( "--override-input" )
                                                                                                                            INPUTS+=( "$INPUT_NAME" )
                                                                                                                            INPUTS+=( "git+ssh://${ builtins.concatStringsSep "" [ "$" "{" "INPUT_REMOTE/:/\/" "}" ] }?rev=$INPUT_COMMIT" )
                                                                                                                        done < <( find "$DIRECTORY/git-repository/inputs" -mindepth 1 -maxdepth 1 -type d | sort )
                                                                                                                        GIT_SSH_COMMAND="$( git -C "$FILE" config --get core.sshCommand )" || failure "332ea582"
                                                                                                                        cat > /mount/command <<EOF
                                                                                                                        export GIT_SSH_COMMAND="$GIT_SSH_COMMAND"
                                                                                                                        nixos-rebuild build --flake "$FILE#user" ${ builtins.concatStringsSep "" [ "$" "{" "INPUTS[*]" "}" ] }
                                                                                                                        EOF
                                                                                                                        chmod 0500 /mount/command
                                                                                                                        TOKEN_FILE=${ resources.production.secrets.token ( setup : setup ) }
                                                                                                                        cat > /mount/switch <<EOF
                                                                                                                        set -euo pipefail
                                                                                                                        export PATH=\$PATH:${ _failure.implementation "f3b796fb" }/bin
                                                                                                                        export GIT_SSH_COMMAND="$GIT_SSH_COMMAND"
                                                                                                                        gh auth login --with-token < "$TOKEN_FILE/secret"
                                                                                                                        find $FILE/inputs -mindepth 1 -maxdepth 1 -type d | sort | while read -r INPUT
                                                                                                                        do
                                                                                                                            if ! git -C "\$INPUT" diff --quiet || ! git -C "\$INPUT" diff --cached --quiet
                                                                                                                            then
                                                                                                                                cd "\$INPUT"
                                                                                                                                BRANCH="\$( git rev-parse --abbrev-ref HEAD )" || failure 1fbb747d
                                                                                                                                LAST_COMMIT_MESSAGE="\$( git log -1 --pretty=%B )" || failure dec8cece
                                                                                                                                URL="\$( gh pr create --base main --head "\$BRANCH" --title "\$LAST_COMMIT_MESSAGE" --body-file <( echo "\$LAST_COMMIT_MESSAGE" ) )" || failure a2f8c05a
                                                                                                                                gh pr merge "\$URL" --squash
                                                                                                                            fi
                                                                                                                        done
                                                                                                                        gh auth logout
                                                                                                                        cd "$FILE"
                                                                                                                        git fetch origin main
                                                                                                                        if ! git diff --quiet origin/main || ! git diff origin/main --cached --quiet
                                                                                                                        then
                                                                                                                            git checkout -b scratch/$( uuidgen )
                                                                                                                            git rm flake.lock
                                                                                                                            nixos-rebuild build --flake "$FILE#user"
                                                                                                                            sudo --preserve-env=GIT_SSH_COMMAND nixos-rebuild switch --flake "$FILE#user"
                                                                                                                            git reset --soft origin/main
                                                                                                                            git commit --no-verify -a --verbose
                                                                                                                            COMMIT="\$( git rev-parse HEAD )" || failure 82c1414a
                                                                                                                            git push origin HEAD
                                                                                                                            git checkout main
                                                                                                                            git rebase origin "\$COMMIT"
                                                                                                                            git push origin main
                                                                                                                        fi
                                                                                                                        EOF
                                                                                                                        chmod 0500 /mount/switch
                                                                                                                        cat > /mount/test <<EOF
                                                                                                                        export GIT_SSH_COMMAND="$GIT_SSH_COMMAND"
                                                                                                                        sudo --preserve-env=GIT_SSH_COMMAND nixos-rebuild test --flake "$FILE#user" ${ builtins.concatStringsSep "" [ "$" "{" "INPUTS[*]" "}" ] }
                                                                                                                        EOF
                                                                                                                        chmod 0500 /mount/test
                                                                                                                        if /mount/command > /mount/standard-output 2> /mount/standard-error
                                                                                                                        then
                                                                                                                            echo "$?" > /mount/status
                                                                                                                        else
                                                                                                                            echo "$?" > /mount/status
                                                                                                                            touch /mount/result
                                                                                                                        fi
                                                                                                                        mkdir /mount/shared
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "command" "result" "shared" "standard-error" "standard-output" "status" "switch" "test" ] ;
                                                                            } ;
                                                                    build-vm =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { pkgs , resources , self } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nixos-rebuild ( _failure.implementation "e8f7af55" ) ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                start =
                                                                                                                    let
                                                                                                                        application =
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "start" ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            export SHARED_DIR="${ self }/shared"
                                                                                                                                            "${ self }/result/bin/run-nixos-vm"
                                                                                                                                        '' ;
                                                                                                                                } ;
                                                                                                                        in "${ application }/bin/start" ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        DIRECTORY="$1"
                                                                                                                        FILE="$2"
                                                                                                                        cd /mount
                                                                                                                        root-store "$DIRECTORY"
                                                                                                                        INPUTS=()
                                                                                                                        while IFS= read -r INPUT
                                                                                                                        do
                                                                                                                            INPUT_NAME="$( basename "$INPUT" )" || failure e661dd72
                                                                                                                            INPUT_REMOTE="$( git -C "$INPUT" remote get-url origin )" || failure d6230040
                                                                                                                            INPUT_COMMIT="$( git -C "$INPUT" rev-parse HEAD )" || failure 081de42a
                                                                                                                            INPUTS+=( "--override-input $INPUT_NAME git+ssh://${ builtins.concatStringsSep "" [ "$" "{" "INPUT_REMOTE/:/\/" "}" ] }?rev=$INPUT_COMMIT" )
                                                                                                                        done < <( find "$DIRECTORY/git-repository/inputs" -mindepth 1 -maxdepth 1 -type d | sort )
                                                                                                                        GIT_SSH_COMMAND="$( git -C "$FILE" config --get core.sshCommand )" || failure "332ea582"
                                                                                                                        cat > /mount/command <<EOF
                                                                                                                        export GIT_SSH_COMMAND="$GIT_SSH_COMMAND"
                                                                                                                        nixos-rebuild build-vm --flake "$FILE#user" ${ builtins.concatStringsSep "" [ "$" "{" "INPUTS[*]" "}" ] }
                                                                                                                        EOF
                                                                                                                        chmod 0500 /mount/command
                                                                                                                        if /mount/command > /mount/standard-output 2> /mount/standard-error
                                                                                                                        then
                                                                                                                            echo "$?" > /mount/status
                                                                                                                        else
                                                                                                                            echo "$?" > /mount/status
                                                                                                                            touch /mount/result
                                                                                                                        fi
                                                                                                                        ln --symbolic ${ start } /mount/start
                                                                                                                        mkdir /mount/shared
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "command" "result" "shared" "standard-error" "standard-output" "start" "status" ] ;
                                                                            } ;
                                                                    build-vm-with-bootloader =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { pkgs , resources , self } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nixos-rebuild ( _failure.implementation "6554d957" ) ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                start =
                                                                                                                    let
                                                                                                                        application =
                                                                                                                            pkgs.writeShellApplication
                                                                                                                                {
                                                                                                                                    name = "start" ;
                                                                                                                                    text =
                                                                                                                                        ''
                                                                                                                                            export SHARED_DIR="${ self }/shared"
                                                                                                                                            "${ self }/result/bin/run-nixos-vm"
                                                                                                                                        '' ;
                                                                                                                                } ;
                                                                                                                        in "${ application }/bin/start" ;
                                                                                                                in
                                                                                                                    ''
                                                                                                                        DIRECTORY="$1"
                                                                                                                        FILE="$2"
                                                                                                                        cd /mount
                                                                                                                        root-store "$DIRECTORY"
                                                                                                                        INPUTS=()
                                                                                                                        while IFS= read -r INPUT
                                                                                                                        do
                                                                                                                            INPUT_NAME="$( basename "$INPUT" )" || failure 62be64a5
                                                                                                                            INPUT_REMOTE="$( git -C "$INPUT" remote get-url origin )" || failure 7b24bffe
                                                                                                                            INPUT_COMMIT="$( git -C "$INPUT" rev-parse HEAD )" || failure 1ba4a40c
                                                                                                                            INPUTS+=( "--override-input" )
                                                                                                                            INPUTS+=( "$INPUT_NAME" )
                                                                                                                            INPUTS+=( "git+ssh://${ builtins.concatStringsSep "" [ "$" "{" "INPUT_REMOTE/:/\/" "}" ] }?rev=$INPUT_COMMIT" )
                                                                                                                        done < <( find "$DIRECTORY/git-repository/inputs" -mindepth 1 -maxdepth 1 -type d | sort )
                                                                                                                        GIT_SSH_COMMAND="$( git -C "$FILE" config --get core.sshCommand )" || failure c1173d09
                                                                                                                        cat > /mount/command <<EOF
                                                                                                                        export GIT_SSH_COMMAND="$GIT_SSH_COMMAND"
                                                                                                                        nixos-rebuild build-vm-with-bootloader --flake "$FILE#user" ${ builtins.concatStringsSep "" [ "$" "{" "INPUTS[*]" "}" ] }
                                                                                                                        EOF
                                                                                                                        chmod 0500 /mount/command
                                                                                                                        if /mount/command > /mount/standard-output 2> /mount/standard-error
                                                                                                                        then
                                                                                                                            echo "$?" > /mount/status
                                                                                                                        else
                                                                                                                            echo "$?" > /mount/status
                                                                                                                            touch /mount/result
                                                                                                                        fi
                                                                                                                        ln --symbolic ${ start } /mount/start
                                                                                                                        mkdir /mount/shared
                                                                                                                        if [ ! -e /mount/result ]
                                                                                                                        then
                                                                                                                            date > /mount/result
                                                                                                                        fi
                                                                                                                    '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "command" "result" "shared" "standard-error" "standard-output" "start" "status" ] ;
                                                                            } ;
                                                                    check =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { pkgs , resources , self } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.nix ( _failure.implementation "218458ec" ) ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                DIRECTORY="$1"
                                                                                                                FILE="$2"
                                                                                                                root-store "$DIRECTORY"
                                                                                                                INPUTS=()
                                                                                                                while IFS= read -r INPUT
                                                                                                                do
                                                                                                                    INPUT_NAME="$( basename "$INPUT" )" || failure ca043af2
                                                                                                                    INPUT_REMOTE="$( git -C "$INPUT" remote get-url origin )" || failure 0d6dfe6a
                                                                                                                    INPUT_COMMIT="$( git -C "$INPUT" rev-parse HEAD )" || failure d44daf9d
                                                                                                                    INPUTS+=( "--override-input" )
                                                                                                                    INPUTS+=( "$INPUT_NAME" )
                                                                                                                    INPUTS+=( "git+ssh://${ builtins.concatStringsSep "" [ "$" "{" "INPUT_REMOTE/:/\/" "}" ] }?rev=$INPUT_COMMIT" )
                                                                                                                done < <( find "$DIRECTORY/git-repository/inputs" -mindepth 1 -maxdepth 1 -type d | sort )
                                                                                                                GIT_SSH_COMMAND="$( git -C "$FILE" config --get core.sshCommand )" || failure 9d73c5ec
                                                                                                                cat > /mount/command <<EOF
                                                                                                                export GIT_SSH_COMMAND="$GIT_SSH_COMMAND"
                                                                                                                nix flake check "$FILE" ${ builtins.concatStringsSep "" [ "$" "{" "INPUTS[*]" "}" ] }
                                                                                                                EOF
                                                                                                                chmod 0500 /mount/command
                                                                                                                if /mount/command > /mount/standard-output 2> /mount/standard-error
                                                                                                                then
                                                                                                                    echo "$?" > /mount/status
                                                                                                                else
                                                                                                                    echo "$?" > /mount/status
                                                                                                                fi
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "command" "standard-error" "standard-output" "status" ] ;
                                                                            } ;
                                                                } ;
                                                            repository =
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
                                                                                                    sleep 1s
                                                                                                done
                                                                                            '' ;
                                                                                    } ;
                                                                            in "${ application }/bin/post-commit" ;
                                                                    ssh =
                                                                        { pkgs , resources , self } :
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "ssh" ;
                                                                                            runtimeInputs = [ pkgs.openssh ];
                                                                                            text =
                                                                                                ''
                                                                                                    if [[ -t 0 ]]
                                                                                                    then
                                                                                                        ssh -F "$DOT_SSH/dot-ssh" "$@"
                                                                                                    else
                                                                                                        cat | ssh -F "$DOT_SSH/dot-ssh" "$@"
                                                                                                    fi
                                                                                                '' ;
                                                                                        } ;
                                                                                in "${ application }/bin/ssh" ;
                                                                    in
                                                                        {
                                                                            snapshot =
                                                                                ignore :
                                                                                    _git-repository.implementation
                                                                                        {
                                                                                            configs =
                                                                                                {
                                                                                                    "alias.secret" =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "secret" ;
                                                                                                                        runtimeInputs = [ pkgs.age ( _failure.implementation "919121ca" ) ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                TOKEN="$1"
                                                                                                                                RECIPIENT="$( age-keygen -y ${ config.personal.agenix } )" || failure 53cf8277
                                                                                                                                echo -n "$TOKEN" | age --encrypt --recipient "$RECIPIENT" --output "inputs/secrets/github-token.asc.age"
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                            in "${ application }/bin/secret" ;
                                                                                                    "alias.scratch" =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "scratch" ;
                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( _failure.implementation "185363fa " ) ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                UUID="$( uuidgen | sha512sum | cut --characters 1-64 )" || failure 1e8f4371
                                                                                                                                git checkout -b "scratch/$UUID" 2>&1
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                            in "!${ application }/bin/scratch" ;
                                                                                                    "alias.build" =
                                                                                                        { pkgs , resources , self } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "build" ;
                                                                                                                            runtimeInputs = [ pkgs.nix ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    FILE="$( git rev-parse --show-toplevel )" || failure 4af6f905
                                                                                                                                    DIRECTORY="$( dirname "$FILE" )" || failure 6ee2312e
                                                                                                                                    BUILD=${ resources.production.nix.build ( setup : ''${ setup } "$DIRECTORY" "$FILE"'' ) }
                                                                                                                                    echo "$BUILD"
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "!${ application }/bin/build" ;
                                                                                                    "alias.build-vm" =
                                                                                                        { pkgs , resources , self } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "build-vm" ;
                                                                                                                            runtimeInputs = [ pkgs.nix ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    FILE="$( git rev-parse --show-toplevel )" || failure 4af6f905
                                                                                                                                    DIRECTORY="$( dirname "$FILE" )" || failure 6ee2312e
                                                                                                                                    BUILD_VM=${ resources.production.nix.build-vm ( setup : ''${ setup } "$DIRECTORY" "$FILE"'' ) }
                                                                                                                                    echo "$BUILD_VM"
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "!${ application }/bin/build-vm" ;
                                                                                                    "alias.build-vm-with-bootloader" =
                                                                                                        { pkgs , resources , self } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "build-vm-with-bootloader" ;
                                                                                                                            runtimeInputs = [ pkgs.nix ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    FILE="$( git rev-parse --show-toplevel )" || failure a612c90b
                                                                                                                                    DIRECTORY="$( dirname "$FILE" )" || failure 5183bdb8
                                                                                                                                    BUILD_VM_WITH_BOOTLOADER=${ resources.production.nix.build-vm-with-bootloader ( setup : ''${ setup } "$DIRECTORY" "$FILE"'' ) }
                                                                                                                                    echo "$BUILD_VM_WITH_BOOTLOADER"
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "!${ application }/bin/build-vm-with-bootloader" ;
                                                                                                    "alias.check" =
                                                                                                        { pkgs , resources , self } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "check" ;
                                                                                                                            runtimeInputs = [ pkgs.nix ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    FILE="$( git rev-parse --show-toplevel )" || failure 4084df8a
                                                                                                                                    DIRECTORY="$( dirname "$FILE" )" || failure b3b73c3c
                                                                                                                                    CHECK=${ resources.production.nix.check ( setup : ''${ setup } "$DIRECTORY" "$FILE"'' ) }
                                                                                                                                    echo "$CHECK"
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "!${ application }/bin/check" ;
                                                                                                    "core.sshCommand" =
                                                                                                        { pkgs , resources , self } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "ssh" ;
                                                                                                                            runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    DOT_SSH=${ resources.production.dot-ssh ( setup : "echo | ${ setup }" ) }
                                                                                                                                    ssh -F "$DOT_SSH/dot-ssh" "$@"
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/ssh" ;
                                                                                                    "user.email" = config.personal.repository.private.email ;
                                                                                                    "user.name" = config.personal.repository.private.name ;
                                                                                                } ;
                                                                                            hooks =
                                                                                                {
                                                                                                    pre-commit =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "pre-commit" ;
                                                                                                                        runtimeInputs = [ ( _failure.implementation "70006125" ) ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                failure be1e88e9 "This is a read-only git repository"
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                                in "${ application }/bin/pre-commit" ;
                                                                                                } ;
                                                                                            remotes =
                                                                                                {
                                                                                                    origin = config.personal.repository.private.remote ;
                                                                                                } ;
                                                                                            setup =
                                                                                                { pkgs , resources , self } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "setup" ;
                                                                                                                    runtimeInputs = [ pkgs.git ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            USER_EMAIL="$( git config --get user.email )" || failure "7644d0fd"
                                                                                                                            USER_NAME="$( git config --get "user.name" )" || failure "88ebeba0"
                                                                                                                            GIT_SSH_COMMAND="$( git config --get "core.sshCommand" )" || failure "31dba1df"
                                                                                                                            export GIT_SSH_COMMAND
                                                                                                                            SCRATCH="$( git config --get "alias.scratch" )" || failure "65cb6383"
                                                                                                                            COMMANDS=()
                                                                                                                            OVERRIDE_INPUTS=()
                                                                                                                            append() {
                                                                                                                                local CMD=( "$@" )
                                                                                                                                COMMANDS+=( "$( printf '%s\037' "${ builtins.concatStringsSep "" [ "$" "{" "CMD[@]" "}" ] }" )" )
                                                                                                                            }
                                                                                                                            while [[ "$#" -gt 0 ]]
                                                                                                                            do
                                                                                                                                case "$1" in
                                                                                                                                    --branch)
                                                                                                                                        BRANCH="$2"
                                                                                                                                        shift 2
                                                                                                                                        ;;
                                                                                                                                    --commit)
                                                                                                                                        COMMIT="$2"
                                                                                                                                        shift 2
                                                                                                                                        ;;
                                                                                                                                    --input)
                                                                                                                                        INPUT_NAME="$2"
                                                                                                                                        INPUT_REMOTE="3"
                                                                                                                                        INPUT_BRANCH="$4"
                                                                                                                                        INPUT_COMMIT="$5"
                                                                                                                                        append git -C "inputs/$INPUT_NAME" config alias.scratch "$SCRATCH"
                                                                                                                                        append git -C "inputs/$INPUT_NAME" config core.sshCommand "$GIT_SSH_COMMAND"
                                                                                                                                        append git -C "inputs/$INPUT_NAME" config user.email "$USER_EMAIL"
                                                                                                                                        append git -C "inputs/$INPUT_NAME" config user.name "$USER_NAME"
                                                                                                                                        append git -C "inputs/$INPUT_NAME" fetch origin "$INPUT_BRANCH"
                                                                                                                                        append git -C "inputs/$INPUT_NAME" checkout "$INPUT_COMMIT"
                                                                                                                                        OVERRIDE_INPUTS+=( "--override-input $INPUT_NAME git+ssh://${ builtins.concatStringsSep "" [ "$" "{" "INPUT_REMOTE/:/\/" "}" ] }?rev=$INPUT_COMMIT" )
                                                                                                                                        shift 5
                                                                                                                                        ;;
                                                                                                                                    *)
                                                                                                                                        failure 6e18cb53 "$1"
                                                                                                                                        ;;
                                                                                                                                esac
                                                                                                                            done
                                                                                                                            if [[ -n "$BRANCH" ]] && [[ -n "$COMMIT" ]]
                                                                                                                            then
                                                                                                                                git fetch origin "$BRANCH" 2>&1
                                                                                                                                git checkout "$COMMIT" 2>&1
                                                                                                                                git submodule init 2>&1
                                                                                                                                git submodule update --recursive 2>&1
                                                                                                                                for SERIALIZED in "${ builtins.concatStringsSep "" [ "$" "{" "COMMANDS[@]" "}" ] }"
                                                                                                                                do
                                                                                                                                    IFS=$'\037' read -r -a CMD <<<"$SERIALIZED"
                                                                                                                                    "${ builtins.concatStringsSep "" [ "$" "{" "CMD[@]" "}" ] }" 2>&1
                                                                                                                                done
                                                                                                                            else
                                                                                                                                failure 1da13d01
                                                                                                                            fi
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/setup" ;
                                                                                        } ;
                                                                            studio =
                                                                                ignore :
                                                                                    _git-repository.implementation
                                                                                        {
                                                                                            configs =
                                                                                                {
                                                                                                    "alias.inherit" =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "inherit" ;
                                                                                                                        runtimeInputs = [ pkgs.findutils ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                USER_NAME="$( git config --get user.name )" || failure "b0a3ba6f"
                                                                                                                                USER_EMAIL="$( git config --get user.email )" || failure "cc7c46fb"
                                                                                                                                GIT_SSH_COMMAND="$( git config --get core.sshCommand )" || failure "99619549"
                                                                                                                                export GIT_SSH_COMMAND
                                                                                                                                SCRATCH="$( git config --get alias.scratch )" || failure "7c276c3a"
                                                                                                                                mkdir --parents inputs
                                                                                                                                if [[ ! -d inputs/dot-gnupg ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/9dbfd2d15c48d454c62cc0496f4834ae0252976be1519d85656fb github.com:AFnRFCb7/dot-gnupg inputs/dot-gnupg 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/dot-ssh ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/52b11d85efc7a21d375fd0d5098a34cfd5181e6a78f35cf422e9d github.com:AFnRFCb7/dot-ssh inputs/dot-ssh 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/failure ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/890e3c5ea2c888b4cf9a88e596582d489b3d007ce7255fd873540 github.com:AFnRFCb7/failure inputs/failure 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/fixture ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/42489785564458bb4f544d872bca6fcbb9f60a67cc8d911bf0666 github.com:AFnRFCb7/fixture inputs/fixture 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/git-repository ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/a54526fe0456c67a62b985bf2dd791fea9ef0a8837d6f36726840 github.com:AFnRFCb7/git-repository inputs/git-repository 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/personal ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/8862d6b14bbbf0bf2f9fe16622a6c119f489e71088bb271767aaa github.com:AFnRFCb7/personal inputs/personal 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/resource ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/b5c9d9c7a6a8e073a36b878c79d90014ee5c7b8b55e3bfadc08e7 github.com:AFnRFCb7/resource inputs/resource 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/secret ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/e462517fa0f57fef49dd5505ec1bf20fc5632195cb72732983d5a github.com:AFnRFCb7/secret inputs/secret 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/secrets ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/ca29db94562095bbb5b9854119e289763d3720f7e647e8dc8fb12 github.com:AFnRFCb7/12e5389b-8894-4de5-9cd2-7dab0678d22b inputs/secrets 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/string ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/752fa5f771ae7b8d9f736d9037d8f6c9274f326cd2be294c44602 github.com:AFnRFCb7/string inputs/string 2>&1
                                                                                                                                fi
                                                                                                                                if [[ ! -d inputs/visitor ]]
                                                                                                                                then
                                                                                                                                    git submodule add --branch submodules/10c57e23120e45d5af754934243d3bd50c4d7a2bb8ce3581323d4 github.com:AFnRFCb7/visitor inputs/visitor 2>&1
                                                                                                                                fi
                                                                                                                                git add .gitmodules
                                                                                                                                git commit -am "" --allow-empty --allow-empty-message 2>&1
                                                                                                                                git push origin HEAD 2>&1
                                                                                                                                find inputs -mindepth 1 -maxdepth 1 -type d | while read -r INPUT
                                                                                                                                do
                                                                                                                                    git -C "$INPUT" config user.name "$USER_NAME"
                                                                                                                                    git -C "$INPUT" config user.email "$USER_EMAIL"
                                                                                                                                    git -C "$INPUT" config alias.scratch "$SCRATCH"
                                                                                                                                    git -C "$INPUT" config alias.scratch "$SCRATCH"
                                                                                                                                    git -C "$INPUT" config core.sshCommand "$GIT_SSH_COMMAND"
                                                                                                                                    git -C "$INPUT" scratch
                                                                                                                                done
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                                in "!${ application }/bin/inherit" ;
                                                                                                    "alias.scratch" =
                                                                                                        let
                                                                                                            application =
                                                                                                                pkgs.writeShellApplication
                                                                                                                    {
                                                                                                                        name = "scratch" ;
                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( _failure.implementation "185363fa " ) ] ;
                                                                                                                        text =
                                                                                                                            ''
                                                                                                                                UUID="$( uuidgen | sha512sum | cut --characters 1-64 )" || failure 0a36ac2f
                                                                                                                                git checkout -b "scratch/$UUID" 2>&1
                                                                                                                            '' ;
                                                                                                                    } ;
                                                                                                            in "!${ application }/bin/scratch" ;
                                                                                                    "alias.snapshot" =
                                                                                                        { pkgs , resources , self } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "snapshot" ;
                                                                                                                            runtimeInputs = [ pkgs.coreutils pkgs.findutils pkgs.git ( _failure.implementation "0eb2ec6d" ) ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    TOP_LEVEL="$( git rev-parse --show-toplevel )" || failure 6a4becc8
                                                                                                                                    INPUTS=()
                                                                                                                                    while IFS= read -r INPUT
                                                                                                                                    do
                                                                                                                                        if ! git -C "$INPUT" diff --quiet || ! git -C "$INPUT" diff --cached --quiet
                                                                                                                                        then
                                                                                                                                            git -C "$INPUT" commit -am "" --allow-empty-message
                                                                                                                                        fi
                                                                                                                                        git -C "$INPUT" push origin HEAD 2>&1
                                                                                                                                        NAME="$( basename "$INPUT" )" || failure d6990665
                                                                                                                                        REMOTE="$( git -C "$INPUT" remote get-url origin )" || failure 0d6dfe6a
                                                                                                                                        BRANCH="$( git -C "$INPUT" rev-parse --abbrev-ref HEAD )" || failure d9c84600
                                                                                                                                        COMMIT="$( git -C "$INPUT" rev-parse HEAD )" || failure aaed95d6
                                                                                                                                        INPUTS+=( "--input" "$NAME" "$REMOTE" "$BRANCH" "$COMMIT" )
                                                                                                                                    done < <( find "$TOP_LEVEL/inputs" -mindepth 1 -maxdepth 1 -type d | sort )
                                                                                                                                    if ! git -C "$TOP_LEVEL" diff --quiet || ! git -C "$TOP_LEVEL" diff --cached --quiet
                                                                                                                                    then
                                                                                                                                        git -C "$TOP_LEVEL" commit -am "" --allow-empty-message
                                                                                                                                    fi
                                                                                                                                    git -C "$TOP_LEVEL" push origin HEAD 2>&1
                                                                                                                                    BRANCH="$( git -C "$TOP_LEVEL" rev-parse --abbrev-ref HEAD )" || failure 82a96f2f
                                                                                                                                    COMMIT="$( git -C "$TOP_LEVEL" rev-parse HEAD )" || failure 508b2be6
                                                                                                                                    RESOURCE=${ resources.production.repository.snapshot ( setup : ''${ setup } --branch "$BRANCH" --commit "$COMMIT" "${ builtins.concatStringsSep "" [ "$" "{" "INPUTS[@]" "}" ] }"'' ) }
                                                                                                                                    echo "$RESOURCE/git-repository"
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "!${ application }/bin/snapshot" ;
                                                                                                    "core.sshCommand" =
                                                                                                        { pkgs , resources , self } :
                                                                                                            let
                                                                                                                application =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "ssh" ;
                                                                                                                            runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    DOT_SSH=${ resources.production.dot-ssh ( setup : "echo | ${ setup }" ) }
                                                                                                                                    ssh -F "$DOT_SSH/dot-ssh" "$@"
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/ssh" ;
                                                                                                    "user.email" = config.personal.repository.private.email ;
                                                                                                    "user.name" = config.personal.repository.private.name ;
                                                                                                } ;
                                                                                            hooks =
                                                                                                {
                                                                                                    post-commit = post-commit ;
                                                                                                } ;
                                                                                            remotes =
                                                                                                {
                                                                                                    origin = config.personal.repository.private.remote ;
                                                                                                } ;
                                                                                            setup =
                                                                                                { pkgs , resources , self } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "setup" ;
                                                                                                                    runtimeInputs = [ pkgs.findutils pkgs.git ] ;
                                                                                                                    text =
                                                                                                                        ''
                                                                                                                            git fetch origin main 2>&1
                                                                                                                            git checkout origin/main 2>&1
                                                                                                                            git scratch
                                                                                                                            git inherit
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/setup" ;
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
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ password-less-core pkgs.nix "nix-collect-garbage" }/src/nix-collect-garbage
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ password-less-core pkgs.nixos-rebuild "nixos-rebuild" }/src/nixos-rebuild
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
                                                        # systemd.services.resources-log-listener =
                                                        #    {
                                                        #         after = [ "network.target" ] ;
                                                        #         serviceConfig =
                                                        #             {
                                                        #                 ExecStart =
                                                        #                     let
                                                        #                         log-event-listener =
                                                        #                             resources.lib.listeners.log-event-listener
                                                        #                                 {
                                                        #                                     coreutils = pkgs.coreutils ;
                                                        #                                     flock = pkgs.flock ;
                                                        #                                     redis = pkgs.redis ;
                                                        #                                     resources-directory = "/home/${ config.personal. name }/resources" ;
                                                        #                                     writeShellApplication = pkgs.writeShellApplication ;
                                                        #                                     yq-go = pkgs.yq-go ;
                                                        #                                 } ;
                                                        #                         in "${ log-event-listener.implementation }/bin/log-event-listener" ;
                                                        #                 User = config.personal.name ;
                                                        #             } ;
                                                        #         wantedBy = [ "multi-user.target" ] ;
                                                        #     } ;
                                                        time.timeZone = "America/New_York" ;
                                                        users.users.user =
                                                            {
                                                                description = config.personal.description ;
                                                                extraGroups = [ "wheel" ] ;
                                                                isNormalUser = true ;
                                                                name = config.personal.name ;
                                                                packages =
                                                                    [
                                                                        pkgs.gh
                                                                        (
                                                                            pkgs.writeShellApplication
                                                                                {
                                                                                    name = "studio" ;
                                                                                    runtimeInputs = [ pkgs.coreutils pkgs.jetbrains.idea-community ] ;
                                                                                    text =
                                                                                        ''
                                                                                            STUDIO=${ resources__.production.repository.studio ( setup : "${ setup } 1f2bc9ee" ) }
                                                                                            idea-community "$STUDIO/git-repository"
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
                                                                                            FOOBAR=${ resources__.foobar.foobar ( setup : "${ setup }" ) }
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
                                    dot-gnupg = _dot-gnupg.check { expected = "/nix/store/8llbrkb6by8r1051zyxdz526rsh4p8qm-init/bin/init" ; failure = _failure.implementation "dff7788e" ; ownertrust-fun = { pkgs , resources , self } : ignore : "${ fixture }/gnupg/ownertrust.asc" ; pkgs = pkgs ; secret-keys-fun = { pkgs , resources , self } : ignore : "${ fixture }/gnupg/secret-keys.asc" ; } ;
                                    dot-ssh =
                                        _dot-ssh.check
                                            {
                                                configuration =
                                                    {
                                                        b-mobile =
                                                            {
                                                                strict-host-key-checking = true ;
                                                                host-name = "192.168.1.192" ;
                                                                identity-file = { pkgs , resources , self } :
                                                                    {
                                                                        directory = resources.directory ;
                                                                        file = resources.file ;
                                                                    } ;
                                                                port = 8022 ;
                                                                user = "git" ;
                                                            } ;
                                                        a-mobile =
                                                            {
                                                                strict-host-key-checking = true ;
                                                                host-name = "192.168.1.202" ;
                                                                identity-file =
                                                                    { pkgs , resources , self } :
                                                                        {
                                                                            directory = resources.directory ;
                                                                            file = resources.file ;
                                                                        } ;
                                                                port = 8022 ;
                                                                user = "git" ;
                                                            } ;
                                                    } ;
                                                expected = "/nix/store/ygkmvyd5d4snw0i7k1j7iycjcyyl25ai-init/bin/init" ;
                                                failure = _failure.implementation "8bc0fd4b" ;
                                                pkgs = pkgs ;
                                                resources =
                                                    {
                                                        directory = "8fc5318ded93faad225f0a476792c71f33b244d0bb6bc72a4f4e52b7d1d05d04f73d4c9df8d51551ee3103a583147e4f704d39fb5330ead882155b8288d5df13" ;
                                                        file = "0aafe25583f5d05bcac9292354f28cf3010a84015ffebd0abb61cf712123133f14a909abf08c17be1ec7f0c8c9f13a4afab7e25056609457d5e7959b2d5612d9" ;
                                                    } ;
                                                self = "50a6090ed9d519bef70bc48269f1ae80065a778abdb0dbb4aa709a82636adefd39e1e32cea576c5202ef2fc8b1a96df9b911cd8eeecacef1320a7a84afba186c" ;
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
                                                expected = "/nix/store/wm2hnfhij3d1av2zkkjld4k1a4kfj1jw-init/bin/init" ;
                                                failure = _failure.implementation "8a8f3b60" ;
                                                pkgs = pkgs ;
                                            } ;
                                    resource-happy =
                                        let
                                            factory =
                                                _resource
                                                    {
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
                                                                self = /build/resources/mounts/0000000311691948
                                                            '' ;
                                                        expected-status = 0 ;
                                                        expected-targets =
                                                                [
                                                                    "e070e8bd478692185ce2719cc2710a19cb7a8155f15f8df7cc3f7dfa0545c2e0054ed82f9ca817198fea290d4438a7445a739e7d280bcf1b55693d8629768ba4"
                                                                ] ;
                                                            expected-transient = -1 ;
                                                        init =
                                                            { pkgs , resources , self } :
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
                                                                                        echo "self = ${ self }"
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
                                                                self = /build/resources/mounts/0000000437766789
                                                           '' ;
                                                     expected-status = 70 ;
                                                     expected-targets =
                                                         [
                                                             "3e30e86404135fc6036abb77e19e8cf73bb32074c07b3273a45e1262bb308f68d420d3549624ee2a44030ba23147465ed85b2c320d0661b1835627aeec050289"
                                                         ] ;
                                                     expected-transient = -1 ;
                                                     init =
                                                         { pkgs , resources , self } :
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
                                                                                     echo "self = ${ self }"
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
                                                    expected = "/nix/store/gciqcwms4g5z2imjafmpgd203adss1sw-init/bin/init" ;
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
                                                                    set = { one = 1 ; } ;
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
