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
			            secret ,
                        secrets ,
                        private ,
                        system ,
                        visitor
                    } :
                        let
                            user =
                                { config , lib , pkgs , ... } :
                                    let
                                        _secrets =
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
                                        resources =
                                            let
                                                checkout =
                                                    let
                                                        checkout =
                                                            pkgs.writeShellApplication
                                                                {
                                                                    name = "checkout" ;
                                                                    runtimeInputs = [ pkgs.git ] ;
                                                                    text =
                                                                        ''
                                                                            MILESTONE="$( ${ milestone } )"
                                                                            if git fetch origin "$MILESTONE"
                                                                            then
                                                                                git checkout "origin/$MILESTONE"
                                                                            else
                                                                                git fetch origin main
                                                                                git checkout origin/main
                                                                                git checkout -b "$MILESTONE"
                                                                                git push -u origin "$MILESTONE"
                                                                            fi
                                                                            git checkout -b "scratch/$( uuidgen )"
                                                                        '' ;
                                                                } ;
                                                        in "${ checkout }/bin/checkout" ;
                                                git =
                                                    {
                                                        configs ? { } ,
                                                        environments ? { } ,
                                                        hooks ? { } ,
                                                        remotes ? { } ,
                                                        setup ? null ,
                                                        release-inputs ? [ ] ,
                                                        release-text ? null
                                                    } : ignore :
                                                        {
                                                            init-inputs = [ pkgs.coreutils pkgs.git ] ;
                                                            init-text =
                                                                ''
                                                                    echo "f5c38f20-6d3f-4eda-9a9a-887d7290d785 \"$*\"" >> /tmp/DEBUG
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''${ name }="${ value }"'' ) environments ) ) }
                                                                    echo "3dd9d7e3-973c-4b81-85fc-998f8e98d392 \"$*\"" >> /tmp/DEBUG
                                                                    # ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''export ${ name }="${ builtins.concatStringsSep "" [ "$" "{" name "}" ] }"'' ) environments ) ) }
                                                                    export GIT_DIR="$SELF/git"
                                                                    echo "42d82e23-3b53-478e-a23e-f00467a48f03 \"$*\"" >> /tmp/DEBUG
                                                                    export GIT_WORK_TREE="$SELF/work-tree"
                                                                    echo "e0f67777-994e-4cfe-b346-149a3f7fbdf9 \"$*\"" >> /tmp/DEBUG
                                                                    HOMEY="$SELF/home"
                                                                    echo "6ccfc082-6ef4-4f29-aee8-850733d237b3 \"$*\"" >> /tmp/DEBUG
                                                                    mkdir --parents "$GIT_DIR"
                                                                    echo "f279e9f5-fd5f-45c9-bf27-7a905c7e4faf \"$*\"" >> /tmp/DEBUG
                                                                    mkdir --parents "$GIT_WORK_TREE"
                                                                    echo "859182e1-af67-4641-89d1-f2ae46fae1d0 \"$*\"" >> /tmp/DEBUG
                                                                    mkdir --parents "$HOMEY"
                                                                    echo "8c14c42e-a6e0-4918-924f-621b1779327a \"$*\"" >> /tmp/DEBUG
                                                                    cat > "$SELF/.envrc" <<EOF
                                                                    export GIT_DIR="$GIT_DIR"
                                                                    export GIT_WORK_TREE="$GIT_WORK_TREE"
                                                                    export HOME="$HOMEY"
                                                                    export SELF="$SELF"
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''export ${ name }="${ builtins.concatStringsSep "" [ "$" "{" name "}" ] }"'' ) environments ) ) }
                                                                    EOF
                                                                    echo "377f944c-b542-40a6-a358-6fb8a078f089 \"$*\"" >> /tmp/DEBUG
                                                                    git init
                                                                    echo "47407102-4ef3-4ece-8a29-29b2667c3a9e \"$*\"" >> /tmp/DEBUG
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git config "${ name }" "${ value }"'' ) configs ) ) }
                                                                    echo "0e229449-fd20-4140-a7f3-d18872a559d9 \"$*\"" >> /tmp/DEBUG
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''ln --symbolic "${ value }" "$GIT_DIR/hooks/${ name }"'' ) hooks ) ) }
                                                                    echo "a8eb6c30-b8c1-4c7a-8102-47a9bccb02de \"$*\"" >> /tmp/DEBUG
                                                                    ${ builtins.concatStringsSep "\n" ( builtins.attrValues ( builtins.mapAttrs ( name : value : ''git remote add "${ name }" "${ value }"'' ) remotes ) ) }
                                                                    echo "9f99cc1f-a175-45b3-be5d-249458847c5a \"$*\"" >> /tmp/DEBUG
                                                                    ${ if builtins.typeOf setup == "string" then "exec ${ setup } \"$@\"" else "" }
                                                                '' ;
                                                            release-inputs = release-inputs ;
                                                            release-text = release-text ;
                                                        } ;
                                                milestone =
                                                    let
                                                        milestone =
                                                            pkgs.writeShellApplication
                                                                {
                                                                    name = "milestone" ;
                                                                    runtimeInputs = [ pkgs.coreutils ] ;
                                                                    text =
                                                                        ''
                                                                            date --date "@$(( ${ builtins.toString config.personal.milestone.epoch } * ( "$( date +%s )" / ${ builtins.toString config.personal.milestone.epoch } ) ))" "+${ config.personal.milestone.format }"
                                                                        '' ;
                                                                } ;
                                                            in "${ milestone }/bin/milestone" ;
                                                post-commit =
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
                                                                                sleep 1m
                                                                            done
                                                                        '' ;
                                                                } ;
                                                            in "${ post-commit }/bin/post-commit" ;
                                                ssh =
                                                    let
                                                        ssh =
                                                            pkgs.stdenv.mkDerivation
                                                                {
                                                                    installPhase =
                                                                        ''
                                                                            mkdir --parents $out/bin
                                                                            makeWrapper \
                                                                                ${ pkgs.openssh }/bin/ssh \
                                                                                $out/bin/ssh \
                                                                                --run "DOT_SSH=\"\$( ${ resources.dot-ssh } )\" || exit 64" \
                                                                                --add-flags "-F \$DOT_SSH/config"
                                                                        '' ;
                                                                    name = "ssh" ;
                                                                    nativeBuildInputs = [ pkgs.coreutils pkgs.makeWrapper ] ;
                                                                    src = ./. ;
                                                                } ;
                                                        in "${ ssh }/bin/ssh" ;
                                                tree =
                                                    {
                                                        dot-gnupg =
                                                            path :
                                                                {
                                                                    init-inputs = [ pkgs.coreutils pkgs.gnupg ] ;
                                                                    init-text =
                                                                        ''
                                                                            export GNUPGHOME="$SELF/dot-gnupg"
                                                                            mkdir "$GNUPGHOME"
                                                                            chmod 0700 "$GNUPGHOME"
                                                                            gpg --homedir "$GNUPGHOME" --batch --yes --import ${ _secrets."secret-keys.asc.age" }
                                                                            gpg --homedir "$GNUPGHOME" --batch --yes --import-ownertrust ${ _secrets."ownertrust.asc.age" }
                                                                            gpg --homedir "$GNUPGHOME" --batch --yes --update-trustdb
                                                                        '' ;
                                                                } ;
                                                        dot-ssh =
                                                            path :
                                                                {
                                                                    init-inputs = [ pkgs.coreutils ] ;
                                                                    init-text =
                                                                        ''
                                                                            cat ${ _secrets.dot-ssh.boot."identity.asc.age" } > "$SELF/identity"
                                                                            cat ${ _secrets.dot-ssh.boot."known-hosts.asc.age" } > "$SELF/known-hosts"
                                                                            cat > "$SELF/config" <<EOF
                                                                            Host github.com
                                                                                HostName github.com
                                                                                IdentityFile $SELF/identity
                                                                                UserKnownHostsFile $SELF/known-hosts
                                                                                StrictHostKeyChecking yes
                                                                                BatchMode yes
                                                                            Host mobile
                                                                                HostName 192.168.1.202
                                                                                IdentityFile $SELF/identity
                                                                                UserKnownHostsFile $SELF/known-hosts
                                                                                Port 8022
                                                                                StrictHostKeyChecking yes
                                                                                BatchMode yes
                                                                            EOF
                                                                            chmod 0400 "$SELF/config" "$SELF/identity" "$SELF/known-hosts"
                                                                        '' ;
                                                                } ;
                                                        dot-pass =
                                                            git
                                                                {
                                                                    configs =
                                                                        {
                                                                            "core.sshCommand" = ssh ;
                                                                            "user.email" = config.personal.email ;
                                                                            "user.name" = config.personal.description ;
                                                                        } ;
                                                                    hooks = { post-commit = post-commit ; } ;
                                                                    remotes = { origin = config.personal.pass.remote ; } ;
                                                                    setup =
                                                                        let
                                                                            setup =
                                                                                pkgs.writeShellApplication
                                                                                    {
                                                                                        name = "setup" ;
                                                                                        runtimeInputs = [ pkgs.git ] ;
                                                                                        text =
                                                                                            ''
                                                                                                git fetch origin ${ config.personal.pass.branch }
                                                                                                git checkout ${ config.personal.pass.branch }
                                                                                            '' ;
                                                                                    } ;
                                                                            in "${ setup }/bin/setup" ;
                                                                } ;
                                                        milestone =
                                                            {
                                                                lock = ignore : { } ;
                                                                repository =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    core.sshCommand = ssh ;
                                                                                    user.name = config.personal.name ;
                                                                                    user.email = config.personal.email ;
                                                                                } ;
                                                                            remotes =
                                                                                {
                                                                                    origin = "$1" ;
                                                                                } ;
                                                                            setup =
                                                                                let
                                                                                    setup =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "setup" ;
                                                                                                runtimeInputs = [ ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        MILESTONE="$2"
                                                                                                        SCRATCH="$3"
                                                                                                        BRANCH="$4"
                                                                                                        COMMIT="$5"
                                                                                                        while ! git fetch origin "$MILESTONE"
                                                                                                        do
                                                                                                            sleep 1s
                                                                                                        done
                                                                                                        while ! git fetch origin "$BRANCH"
                                                                                                        do
                                                                                                            sleep 1s
                                                                                                        done
                                                                                                        git checkout "$COMMIT"
                                                                                                        sed -i -E "s#ref=.*\"#ref=$SCRATCH#" "$GIT_WORK_TREE/flake.nix"
                                                                                                        git checkout -b "$SCRATCH"
                                                                                                        git rebase "origin/$MILESTONE"
                                                                                                        git commit -am "" --allow-empty --allow-empty-message
                                                                                                        while ! git push -u origin "$SCRATCH"
                                                                                                        do
                                                                                                            sleep 1s
                                                                                                        done
                                                                                                        git checkout "$MILESTONE"
                                                                                                        git rebase "$SCRATCH"
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ setup }/bin/setup" ;
                                                                        } ;
                                                            } ;
                                                        repository =
                                                            {
                                                                applications =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.applications.remote ; } ;
                                                                            setup =
                                                                                let
                                                                                    setup =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "setup" ;
                                                                                                runtimeInputs = [ ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ setup }/bin/setup" ;
                                                                        } ;
                                                                personal =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.personal.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                                private =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "alias.asyncronous-promote" =
                                                                                        let
                                                                                            asyncronous-promote-pre =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "asyncronous-promote-pre" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid pkgs.nix pkgs.nixos-rebuild ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                MILESTONE="$( ${ milestone } )" || exit 64
                                                                                                                SCRATCH="scratch/$( uuidgen )" || exit 64
                                                                                                                git add .
                                                                                                                git commit -am "" --allow-empty --allow-empty-message
                                                                                                                while ! git push origin HEAD
                                                                                                                do
                                                                                                                    sleep 1s
                                                                                                                done
                                                                                                                ROOT_NAME="root"
                                                                                                                ROOT_REMOTE="$( git remote --verbose | head --lines 1 | sed -E "s#[[:space:]]+# #g" | cut --fields 1 --delimiter " " )" || exit 64
                                                                                                                ROOT_BRANCH="$( git rev-parse --abbrev-ref HEAD )" || exit 64
                                                                                                                ROOT_COMMIT="$( git rev-parse HEAD )" || exit 64
                                                                                                                INPUT_FLAGS=( )
                                                                                                                find "$SELF/inputs" -mindepth 1 -maxdepth 1 -type l | while read -r INPUT
                                                                                                                do
                                                                                                                    GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git add .
                                                                                                                    GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git commit -am "" --allow-empty --allow-empty-message
                                                                                                                    while ! GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git push origin HEAD
                                                                                                                    do
                                                                                                                        sleep 1s
                                                                                                                    done
                                                                                                                    INPUT_REMOTE="$( GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" remote --verbose | head --lines 1 | sed -E "s#[[:space:]]+# #g" | cut --fields 1 --delimiter " " )" || exit 64
                                                                                                                    INPUT_NAME="$( basename "$INPUT" )" || exit 64
                                                                                                                    INPUT_BRANCH="$( GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" rev-parse --abbrev-ref HEAD )" || exit 64
                                                                                                                    INPUT_COMMIT="$( GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" rev-parse HEAD )" || exit 64
                                                                                                                    INPUT_FLAGS+=( "--flake" "input" "$INPUT_REMOTE" "$INPUT_NAME" "$MILESTONE" "$SCRATCH" "$INPUT_BRANCH" "$INPUT_COMMIT" )
                                                                                                                done
                                                                                                                nohup nice --adjustment 19 ${ "asyncronous-promote-post" }/bin/asynchronous-promote-post "--flake" "root" "$ROOT_REMOTE" "$ROOT_NAME" "$MILESTONE" "$SCRATCH" "$ROOT_BRANCH" "$ROOT_COMMIT" "${ builtins.concatStringsSep "" [ "$" "{" "INPUT_FLAGS[@]" "}" ] }" &
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            asyncronous-promote-post =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "asynchronous-promote-post" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.flock ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                UNO="$( ${ resources.milestone.lock } )" || exit 63
                                                                                                                exec 201> "$UNO/lock"
                                                                                                                TIMESTAMP="$( date +%s.%N )" || exit 64
                                                                                                                flock 201
                                                                                                                FLAKES=( )
                                                                                                                while [ "$#" -gt 0 ]
                                                                                                                do
                                                                                                                    case "$1" in
                                                                                                                        --flake)
                                                                                                                            TYPE="$2"
                                                                                                                            NAME="$3"
                                                                                                                            REMOTE="$4"
                                                                                                                            MILESTONE="$5"
                                                                                                                            SCRATCH="$6"
                                                                                                                            NAME="$7"
                                                                                                                            BRANCH="$8"
                                                                                                                            COMMIT="$9"
                                                                                                                            echo "$NAME"
                                                                                                                            REPOSITORY="$( ${ resources.milestone.repository } "$MILESTONE" "SCRATCH" "$REMOTE" "$BRANCH" "$COMMIT" )" || exit 64
                                                                                                                            if [[ "$TYPE" == "root" ]]
                                                                                                                            then
                                                                                                                                ROOT="$REPOSITORY"
                                                                                                                            fi
                                                                                                                            FLAKES+=( "$REPOSITORY" )
                                                                                                                            shift 8
                                                                                                                            ;;
                                                                                                                        *)
                                                                                                                            shift
                                                                                                                            ;;
                                                                                                                    esac
                                                                                                                done
                                                                                                                timeout ${ builtins.toString config.personal.milestone.timeout } nix flake check "$ROOT/work-tree/flake.nix"
                                                                                                                VM="$UNO/vm"
                                                                                                                rm --recursive --force "$VM"
                                                                                                                mkdir --parents "$VM"
                                                                                                                cd "$VM"
                                                                                                                if ! timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build-vm --flake "$ROOT/work-tree#tester"
                                                                                                                then
                                                                                                                    exit 64
                                                                                                                fi
                                                                                                                SHARED_DIR="$VM/test"
                                                                                                                export SHARED_DIR
                                                                                                                mkdir --parents "$SHARED_DIR"
                                                                                                                if ! "$VM/result/bin/run-nixos-vm" -nographic
                                                                                                                then
                                                                                                                    exit 64
                                                                                                                fi
                                                                                                                if ! ( [[ -f "$SHARED_DIR/status" ]] && [[ "$( < "$SHARED_DIR/status" )" == 0 ]] )
                                                                                                                then
                                                                                                                    exit 64
                                                                                                                fi
                                                                                                                VM_WITH_BOOTLOADER="$UNO/vm-with-bootloader"
                                                                                                                rm --recursive--force "$VM_WITH_BOOTLOADER"
                                                                                                                mkdir --parents "$VM_WITH_BOOTLOADER"
                                                                                                                cd "$VM_WITH_BOOTLOADER"
                                                                                                                if ! timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build-vm-with-bootloader --flake "$ROOT/work-tree#tester"
                                                                                                                then
                                                                                                                    exit 64
                                                                                                                fi
                                                                                                                SHARED_DIR="$VM_WITH_BOOTLOADER/test"
                                                                                                                export SHARED_DIR
                                                                                                                mkdir --parents "$SHARED_DIR
                                                                                                                if ! "$VM_WITH_BOOTLOADER/result/bin/run-nixos-vm" -nographic
                                                                                                                then
                                                                                                                    exit 64
                                                                                                                fi
                                                                                                                if ! ( [[ -f "$SHARED_DIR/status" ]] && [[ "$( < "$SHARED_DIR/status" )" == 0 ]] )
                                                                                                                then
                                                                                                                    exit 64
                                                                                                                fi
                                                                                                                if ! timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build --flake "$ROOT/work-tree#user"
                                                                                                                then
                                                                                                                   exit 64
                                                                                                                fi
                                                                                                                if timeout ${ builtins.toString config.personal.milestone.timeout } sudo ${ pkgs.nixos-rebuild }/bin/nixos-rebuild test --flake "$ROOT/work-tree#user"
                                                                                                                then
                                                                                                                    exit 64
                                                                                                                fi
                                                                                                                for FLAKE in "${ builtins.concatStringsSep "" [ "$" "{" "FLAKES[@]" "}" ] }"
                                                                                                                do
                                                                                                                    while ! GIT_DIR="$FLAKE/git" GIT_WORK_TREE="$FLAKE/work-tree" git push origin HEAD
                                                                                                                    do
                                                                                                                        sleep 1s
                                                                                                                    done
                                                                                                                done
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "!${ asyncronous-promote-pre }/bin/asyncronous-promote-pre" ;
                                                                                    "alias.syncronous-promote" =
                                                                                        let
                                                                                            syncronous-promote =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "syncronous-promote" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.libuuid pkgs.nix pkgs.nixos-rebuild ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                elapsed ( )
                                                                                                                    {
                                                                                                                        STOP="$( date +%s )"
                                                                                                                        ELAPSED=$(( STOP - START ))
                                                                                                                        echo -n "elapsed $ELAPSED"
                                                                                                                    }
                                                                                                                START=$( date +%s ) || exit 64
                                                                                                                echo "Starting $( date )"
                                                                                                                mkdir --parents "$SELF/promote"
                                                                                                                ROOT="$( mktemp --directory "$SELF/promote/XXXXXXXX" )"
                                                                                                                export NIX_SHOW_STATS=5
                                                                                                                export NIX_DEBUG=1
                                                                                                                export NIX_SHOW_TRACE=1
                                                                                                                export NIX_LOG=stderr
                                                                                                                date +%s > "$GIT_WORK_TREE/current-time.nix"
                                                                                                                find "$SELF/inputs" -mindepth 1 -maxdepth 1 -type l | while read -r LINK
                                                                                                                do
                                                                                                                    NAME="$( basename "$LINK" )"
                                                                                                                    GIT_DIR="$LINK/git" GIT_WORK_TREE="$LINK/work-tree" git add .
                                                                                                                    GIT_DIR="$LINK/git" GIT_WORK_TREE="$LINK/work-tree" git commit -am "" --allow-empty --allow-empty-message
                                                                                                                    while ! GIT_DIR="$LINK/git" GIT_WORK_TREE="$LINK/work-tree" git push origin HEAD
                                                                                                                    do
                                                                                                                        echo "waiting to push $NAME"
                                                                                                                        sleep 1
                                                                                                                    done
                                                                                                                    COMMIT_HASH="$( GIT_DIR="$LINK/git" GIT_WORK_TREE="$LINK/work-tree" git rev-parse HEAD )" || exit 64
                                                                                                                    sed -i -E "s#($NAME\.url[^?]*\?ref=).*(\")#\1$COMMIT_HASH\2#" "$SELF/work-tree/flake.nix"
                                                                                                                    echo "Finished preparing source input $NAME $( date ) $( elapsed )"
                                                                                                                done
                                                                                                                git commit -am "" --allow-empty --allow-empty-message
                                                                                                                while ! git push origin HEAD
                                                                                                                do
                                                                                                                    echo waiting to push
                                                                                                                    sleep 1
                                                                                                                done
                                                                                                                echo "Finished preparing source root $( date ) $( elapsed )"
                                                                                                                (
                                                                                                                    mkdir --parents "$ROOT/check"
                                                                                                                    if timeout ${ builtins.toString config.personal.milestone.timeout } nix --log-format raw --show-trace -vvv flake check ./work-tree > "$ROOT/check/standard-output" 2> "$ROOT/check/standard-error"
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/check/status"
                                                                                                                        echo "Passed checks $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "$?" > "$ROOT/check/status"
                                                                                                                        echo "Failed checks $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                )
                                                                                                                (
                                                                                                                    mkdir --parents "$ROOT/vm/build"
                                                                                                                    cd "$ROOT/vm/build"
                                                                                                                    if timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build-vm --flake "$SELF/work-tree#tester" --verbose --show-trace > "$ROOT/vm/build/standard-output" 2> "$ROOT/vm/build/standard-error"
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/vm/build/status"
                                                                                                                        echo "Built vm $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "$?" > "$ROOT/vm/build/status"
                                                                                                                        echo "Failed to build vm $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                )
                                                                                                                (
                                                                                                                    SHARED_DIR="$ROOT/vm/run/test"
                                                                                                                    export SHARED_DIR
                                                                                                                    mkdir --parents "$SHARED_DIR"
                                                                                                                    cd "$ROOT/vm/run"
                                                                                                                    if "$ROOT/vm/build/result/bin/run-nixos-vm" -nographic > "$ROOT/vm/run/standard-output" 2> "$ROOT/vm/run/standard-error"
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/vm/run/status"
                                                                                                                        echo "Ran vm $( date ) $( elapsed )"
                                                                                                                    elif [[ "$?" == 124 ]]
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/vm/run/status"
                                                                                                                        echo "Timed out vm $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "$?" > "$ROOT/vm/run/status"
                                                                                                                        echo "Failed to run vm $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                    if [[ -f "$ROOT/vm/run/test/status" ]] && [[ "$( < "$ROOT/vm/run/test/status" )" == 0 ]]
                                                                                                                    then
                                                                                                                        echo "vm passed $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "vm failed $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                )
                                                                                                                (
                                                                                                                    mkdir --parents "$ROOT/vm-with-bootloader/build"
                                                                                                                    cd "$ROOT/vm-with-bootloader/build"
                                                                                                                    if timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build-vm-with-bootloader --flake "$SELF/work-tree#tester" --verbose --show-trace > "$ROOT/vm-with-bootloader/build/standard-output" 2> "$ROOT/vm-with-bootloader/build/standard-error"
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/vm-with-bootloader/build/status"
                                                                                                                        echo "Built vm-with-bootloader $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "$?" > "$ROOT/vm-with-bootloader/build/status"
                                                                                                                        echo "Failed to build vm-with-bootloader $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                )
                                                                                                                (
                                                                                                                    SHARED_DIR="$ROOT/vm-with-bootloader/run/test"
                                                                                                                    export SHARED_DIR
                                                                                                                    mkdir --parents "$SHARED_DIR"
                                                                                                                    cd "$ROOT/vm-with-bootloader/run"
                                                                                                                    if "$ROOT/vm-with-bootloader/build/result/bin/run-nixos-vm" -nographic > "$ROOT/vm-with-bootloader/run/standard-output" 2> "$ROOT/vm-with-bootloader/run/standard-error"
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/vm-with-bootloader/run/status"
                                                                                                                        echo "Ran vm-with-bootloader $( date ) $( elapsed )"
                                                                                                                    elif [[ "$?" == 124 ]]
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/vm-with-bootloader/run/status"
                                                                                                                        echo "Timed out vm-with-bootloader $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "$?" > "$ROOT/vm-with-bootloader/run/status"
                                                                                                                        echo "Failed to run vm-with-bootloader $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                    if [[ -f "$ROOT/vm-with-bootloader/run/test/status" ]] && [[ "$( < "$ROOT/vm-with-bootloader/run/status" )" == 0 ]]
                                                                                                                    then
                                                                                                                        echo "vm-with-bootloader passed $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "vm-with-bootloader failed $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                )
                                                                                                                (
                                                                                                                    mkdir --parents "$ROOT/build"
                                                                                                                    cd "$ROOT/build"
                                                                                                                    if timeout ${ builtins.toString config.personal.milestone.timeout } nixos-rebuild build --flake "$SELF/work-tree#user" --verbose --show-trace > "$ROOT/build/standard-output" 2> "$ROOT/build/standard-error"
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/build/status"
                                                                                                                        echo "Built $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "$?" > "$ROOT/build/status"
                                                                                                                        echo "Failed to build $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                )
                                                                                                                (
                                                                                                                    mkdir --parents "$ROOT/test"
                                                                                                                    cd "$ROOT/test"
                                                                                                                    if timeout ${ builtins.toString config.personal.milestone.timeout } sudo ${ pkgs.nixos-rebuild }/bin/nixos-rebuild test --flake "$SELF/work-tree#user" --verbose --show-trace | tee > "$ROOT/test/standard-output" 2> "$ROOT/test/standard-error"
                                                                                                                    then
                                                                                                                        echo "$?" > "$ROOT/test/status"
                                                                                                                        echo "Tested $( date ) $( elapsed )"
                                                                                                                    else
                                                                                                                        echo "$?" > "$ROOT/test/status"
                                                                                                                        echo "Failed to test $( date ) $( elapsed )"
                                                                                                                        exit 64
                                                                                                                    fi
                                                                                                                )
                                                                                                                MILESTONE="$( ${ milestone } )" || exit 64
                                                                                                                SCRATCH="scratch/$( uuidgen )" || exit 64
                                                                                                                find "$SELF/inputs" -mindepth 1 -maxdepth 1 -type l | while read -r INPUT
                                                                                                                do
                                                                                                                    BRANCH="$( GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git rev-parse --abbrev-ref HEAD )" || exit 64
                                                                                                                    GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git fetch origin "$MILESTONE"
                                                                                                                    GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git merge -X ours "origin/$MILESTONE" -m "Merge $MILESTONE into $BRANCH preferring $BRANCH"
                                                                                                                    GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git branch -f "$MILESTONE" HEAD
                                                                                                                    GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git push origin "$MILESTONE"
                                                                                                                    GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git checkout -b "$SCRATCH"
                                                                                                                    while ! GIT_DIR="$INPUT/git" GIT_WORK_TREE="$INPUT/work-tree" git push -u origin "$SCRATCH"
                                                                                                                    do
                                                                                                                        echo "waiting to push $INPUT"
                                                                                                                        sleep 1
                                                                                                                    done
                                                                                                                    NAME="$( basename "$INPUT" )" || exit 64
                                                                                                                    echo "Pushed changes to input $NAME to $MILESTONE $( date )"
                                                                                                                done
                                                                                                                BRANCH="$( git rev-parse --abbrev-ref HEAD )" || exit 64
                                                                                                                git fetch origin "$MILESTONE"
                                                                                                                git merge -X ours "origin/$MILESTONE" -m "Merge $MILESTONE into $BRANCH preferring $BRANCH"
                                                                                                                git branch -f "$MILESTONE" HEAD
                                                                                                                while ! git push origin "$MILESTONE"
                                                                                                                do
                                                                                                                    echo waiting to push
                                                                                                                    sleep 1s
                                                                                                                done
                                                                                                                git checkout -b "$SCRATCH"
                                                                                                                git push -u origin "$SCRATCH"
                                                                                                                echo "Pushed changes to root to $MILESTONE $( date ) $( elapsed )"
                                                                                                                STOP="$( date +%s )" || exit 64
                                                                                                                TIME="$(( STOP - START ))" || exit 64
                                                                                                                echo "Promoted in $TIME at $( date )"
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "!${ syncronous-promote }/bin/syncronous-promote" ;
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.private.remote ; } ;
                                                                            setup =
                                                                                let
                                                                                    setup =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "setup" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git ] ;
                                                                                                text =
                                                                                                    ''
                                                                                                        echo e6904d58-dabc-46ba-8f06-8cd11d838e3c > /tmp/DEBUG
                                                                                                        MILESTONE="$( ${ milestone } )"
                                                                                                        echo 781cec98-98fe-48fa-8561-397c86e6559e >> /tmp/DEBUG
                                                                                                        if git fetch origin "$MILESTONE"
                                                                                                        then
                                                                                                            echo 26a909c5-b4d1-42fd-9ac2-21b4fe679027 >> /tmp/DEBUG
                                                                                                            git checkout "origin/$MILESTONE"
                                                                                                            echo 90760b41-ff8c-472b-98e9-78a9e9290d70 >> /tmp/DEBUG
                                                                                                        else
                                                                                                            echo 85852679-fbff-4df6-8a7a-c5acf52c8618 >> /tmp/DEBUG
                                                                                                            git fetch origin main
                                                                                                            echo 541baa9a-e64f-4b99-b0ef-e8f142a90452 >> /tmp/DEBUG
                                                                                                            git checkout origin/main
                                                                                                            echo da8b6154-54cb-4001-98d7-7b25f942eb51 >> /tmp/DEBUG
                                                                                                            git checkout -b "$MILESTONE"
                                                                                                            echo c9e986b1-4354-4b70-88d6-d5a07296b505 >> /tmp/DEBUG
                                                                                                            git push -u origin "$MILESTONE"
                                                                                                            echo 03b9e515-13f1-41d0-805d-d7fa99081d7a >> /tmp/DEBUG
                                                                                                        fi
                                                                                                        echo 17060d98-1997-47cc-9245-cfa1b2c1b0db >> /tmp/DEBUG
                                                                                                        git checkout -b "scratch/$( uuidgen )"
                                                                                                        echo 77062af7-0b9b-4303-b33a-52333ba0d8a9 >> /tmp/DEBUG
                                                                                                        mkdir --parents "$SELF/inputs"
                                                                                                        echo fb1b6039-e97b-4e1f-9773-59ff6a3a0cf6 >> /tmp/DEBUG
                                                                                                        PERSONAL="$( ${ resources.repository.personal } "$@" )" || exit 64
                                                                                                        ln --symbolic "$PERSONAL" "$SELF/inputs/personal"
                                                                                                        echo 6105aa25-0db5-48f7-9455-75061c414941 >> /tmp/DEBUG
                                                                                                        SECRETX="$( ${ resources.repository.secret } "$@" )" || exit 64
                                                                                                        ln --symbolic "$SECRETX" "$SELF/inputs/secret"
                                                                                                        echo bdec44ba-c1bc-4371-9b62-9979a0364863 >> /tmp/DEBUG
                                                                                                        SECRETS="$( ${ resources.repository.secrets } "$@" )" || exit 6
                                                                                                        ln --symbolic "$SECRETS" "$SELF/inputs/secrets"
                                                                                                        echo 553fb241-28b2-4fc8-bd25-e2652035fde9 >> /tmp/DEBUG
                                                                                                        VISITOR="$( ${ resources.repository.visitor } "$@" )" || exit 64
                                                                                                        ln --symbolic "$VISITOR" "$SELF/inputs/visitor"
                                                                                                        echo 06ed1bc1-ad48-43d4-afcc-47c333b5e343 >> /tmp/DEBUG
                                                                                                    '' ;
                                                                                            } ;
                                                                                        in "${ setup }/bin/setup" ;
                                                                        } ;
                                                                secret =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.secret.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                                secrets =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.secrets.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                                visitor =
                                                                    git
                                                                        {
                                                                            configs =
                                                                                {
                                                                                    "core.sshCommand" = ssh ;
                                                                                    "user.email" = config.personal.email ;
                                                                                    "user.name" = config.personal.description ;
                                                                                } ;
                                                                            hooks = { post-commit = post-commit ; } ;
                                                                            remotes = { origin = config.personal.repository.visitor.remote ; } ;
                                                                            setup = checkout ;
                                                                        } ;
                                                            } ;
                                                    } ;
							                    in visitor.lib.implementation { lambda = path : value : secret.lib.implementation ( { nixpkgs = nixpkgs ; path = path ; secret-directory = "/home/${ config.personal.name }/resources" ; seed = [ nixpkgs path private self secret system visitor ] ; system = system ; } // ( value path ) ) ; } tree ;
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
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.umount }/bin/umount
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.mount }/bin/mount
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nixos-rebuild }/bin/nixos-rebuild
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.unixtools.fsck }/bin/fsck
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.e2fsprogs }/bin/mkfs.ext4
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.coreutils }/bin/chown
                                                                        %wheel ALL=(ALL) NOPASSWD: ${ pkgs.nixos-rebuild }/bin/nixos-rebuild
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
                                                                                ( studio "studio-personal" resources.repository.personal )
                                                                                ( studio "studio-private" resources.repository.private )
                                                                                ( studio "studio-secret" resources.repository.secret )
                                                                                ( studio "studio-secrets" resources.repository.secrets )
                                                                                ( studio "studio-visitor" resources.repository.visitor )
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
                                                                        timeout = lib.mkOption { default = 60 * 10 ; type = lib.types.int ; } ;
                                                                        timeout2 = lib.mkOption { default = 60 ; type = lib.types.int ; } ;
                                                                    } ;
                                                                name = lib.mkOption { type = lib.types.str ; } ;
                                                                pass =
                                                                    {
                                                                        branch = lib.mkOption { default = "scratch/8060776f-fa8d-443e-9902-118cf4634d9e" ; type = lib.types.str ; } ;
                                                                        character-set = lib.mkOption { default = ".,_=2345ABCDEFGHJKLMabcdefghjkmn" ; type = lib.types.str ; } ;
                                                                        character-set-no-symbols = lib.mkOption { default = "6789NPQRSTUVWXYZpqrstuvwxyz" ; type = lib.types.str ; } ;
                                                                        deadline = lib.mkOption { default = 60 * 60 * 24 * 366 ; type = lib.types.int ; } ;
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
                                                                                remote = lib.mkOption { default = "mobile:private" ; type = lib.types.str ; } ;
                                                                            } ;
                                                                        secret =
                                                                            {
                                                                                branch = lib.mkOption { default = "main" ; type = lib.types.str ; } ;
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/secret.git" ; type = lib.types.str ; } ;
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
                                            pkgs = builtins.getAttr system nixpkgs.legacyPackages ;
					                        in
						                        {
						                            foobar =
						                                pkgs.stdenv.mkDerivation
						                                    {
						                                        installPhase =
						                                            ''
						                                                touch $out
						                                                exit 0
						                                            '' ;
                                                                name = "foobar" ;
                                                                src = ./. ;
						                                    } ;
                                                } ;
                                } ;
            } ;
}
