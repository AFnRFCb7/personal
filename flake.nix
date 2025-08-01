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
                                                                                --add-flags "-F \$( ${ resources.dot-ssh } )/config"
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
                                                                build =
                                                                    ignore :
                                                                        {
                                                                            init-inputs = [ pkgs.nixos-rebuild ];
                                                                            init-text =
                                                                                ''
                                                                                    export NIX_SHOW_STATS=5
                                                                                    export NIX_DEBUG=1
                                                                                    nixos-rebuild build --flake "$( ${ resources.milestone.source.root } "$@" )/work-tree#tester" --verbose --show-trace
                                                                                '' ;
                                                                        } ;
                                                                check =
                                                                    ignore :
                                                                        {
                                                                            init-inputs = [ pkgs.nix ] ;
                                                                            init-text =
                                                                                ''
                                                                                    export NIX_DEBUG=1
                                                                                    export NIX_SHOW_STATS=1
                                                                                    export NIX_SHOW_TRACE=1
                                                                                    export NIX_LOG=stderr
                                                                                    if nix --log-format raw --show-trace -vvv flake check "$( ${ resources.milestone.source.root } "$@" )/work-tree" > "$SELF/standard-output" 2> "$SELF/standard-error"
                                                                                    then
                                                                                        echo "$?" > "$SELF/status"
                                                                                    else
                                                                                        echo "$?" > "$SELF/status"
                                                                                    fi
                                                                                '' ;
                                                                        } ;
                                                                snapshot =
                                                                    ignore :
                                                                        {
                                                                            init-inputs = [ pkgs.coreutils ] ;
                                                                            init-text =
                                                                                ''
                                                                                    while [[ "$#" -gt 0 ]]
                                                                                    do
                                                                                        case "$1" in
                                                                                            --link)
                                                                                                TYPE="$2"
                                                                                                DIR="$3"
                                                                                                COMMIT="$4"
                                                                                                NAME="$( basename "$DIR" )"
                                                                                                if [[ "$TYPE" == "root" ]]
                                                                                                then
                                                                                                    ROOT="$SELF/root"
                                                                                                else
                                                                                                    ROOT="$SELF/inputs/$NAME"
                                                                                                fi
                                                                                                mkdir --parents "$ROOT"
                                                                                                GIT_DIR="$DIR/git" GIT_WORK_TREE="$DIR/work-tree" git rev-parse --abbrev-ref HEAD > "$ROOT/branch"
                                                                                                echo "b81ae091-bfef-48db-b81b-33379ec5a61f \"$*\"" >> /tmp/DEBUG
                                                                                                GIT_DIR="$DIR/git" GIT_WORK_TREE="$DIR/work-tree" git push origin HEAD
                                                                                                echo "efd58d64-30dd-4468-9599-ba665dd6f996 \"$*\"" >> /tmp/DEBUG
                                                                                                echo "$COMMIT" > "$ROOT/commit"
                                                                                                echo "$NAME" > "$ROOT/name"
                                                                                                ln --symbolic "$DIR" "$ROOT/local"
                                                                                                GIT_DIR="$DIR/git" GIT_WORK_TREE="$DIR/work-tree" git remote --verbose | head --lines 1 | sed -E "s#[[:space:]]+#_#g" | cut --delimiter "_" --fields 2 > "$ROOT/remote"
                                                                                                shift 4
                                                                                                ;;
                                                                                            *)
                                                                                                mkdir --parents "$SELF/garbage"
                                                                                                echo "$1" > "$( mktemp "$SELF/garbage/XXXXXXXX" )"
                                                                                                shift
                                                                                                ;;
                                                                                        esac
                                                                                    done
                                                                                '' ;
                                                                            lease = 60 * 60 ;
                                                                        } ;
                                                                source =
                                                                    {
                                                                        input =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "core.sshCommand" = ssh ;
                                                                                            "user.email" = config.personal.email ;
                                                                                            "user.name" = config.personal.description ;
                                                                                        } ;
                                                                                    remotes =
                                                                                        {
                                                                                            remote = "$1" ;
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
                                                                                                                echo 8793c25a-ada2-4738-b35b-46ac64b5a159 >> /tmp/DEBUG
                                                                                                                # REMOTE="$1"
                                                                                                                # echo 1a042782-21c2-4cf0-909f-9bcd40de5dc3 >> /tmp/DEBUG
                                                                                                                BRANCH="$2"
                                                                                                                echo d4150d3c-ed90-47d1-b475-21e78f5a3a62 >> /tmp/DEBUG
                                                                                                                COMMIT="$3"
                                                                                                                echo "826aff17-307b-4d28-9dcd-ccc78ef0aaea \"$*\"" >> /tmp/DEBUG
                                                                                                                git fetch remote "$( ${ milestone } )"
                                                                                                                git fetch remote "$BRANCH" >> /tmp/DEBUG 2>&1
                                                                                                                git checkout "$COMMIT"
                                                                                                                git checkout -b "$BRANCH"
                                                                                                                git rebase "remote/$( ${ milestone } )" >> /tmp/DEBUG 2>&1
                                                                                                                git commit -am "" --allow-empty --allow-empty-message
                                                                                                                git push -u remote "$BRANCH" >> /tmp/DEBUG 2>&1
                                                                                                                echo ca13f5fb-ebb3-4aae-8052-3ec844cadfd0 >> /tmp/DEBUG
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ setup }/bin/setup" ;
                                                                                } ;
                                                                        root =
                                                                            git
                                                                                {
                                                                                    configs =
                                                                                        {
                                                                                            "core.sshCommand" = ssh ;
                                                                                            "user.email" = config.personal.email ;
                                                                                            "user.name" = config.personal.description ;
                                                                                        } ;
                                                                                    # environments =
                                                                                    #     {
                                                                                    #         LOCO1 = builtins.trace resources.milestone.snapshot resources.milestone.snapshot ;
                                                                                    #         LOCO = ''$( ${ resources.milestone.snapshot } "$@" )'' ;
                                                                                    #         ZBRANCH = ''$( < "$LOCO/root/branch" )'' ;
                                                                                    #         ZCOMMIT = ''$( cat "$LOCO/root/commit" )'' ;
                                                                                    #     } ;
                                                                                    remotes =
                                                                                        {
                                                                                            remote = ''$( < "$( ${ resources.milestone.snapshot } "$@" )/root/remote" )'' ;
                                                                                        } ;
                                                                                    setup =
                                                                                        let
                                                                                            setup =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "setup" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.findutils pkgs.git pkgs.gnused ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                echo "af20862a-d41e-46fa-a06d-50602c219a6f \"$*\"" >> /tmp/DEBUG
                                                                                                                LOCO20="$( ${ resources.milestone.snapshot } "$@" )"
                                                                                                                echo "049f6057-caba-4667-9718-4803af90fde3 \"$*\"" >> /tmp/DEBUG
                                                                                                                BRANCH="$( < "$LOCO20/root/branch" )"
                                                                                                                echo "1a2e8339-4f59-4a31-82a0-88720d11b12f \"$*\"" >> /tmp/DEBUG
                                                                                                                COMMIT="$( < "$LOCO20/root/commit" )"
                                                                                                                echo "be948699-a478-49a1-97fa-f590809998b1 \"$*\"" >> /tmp/DEBUG
                                                                                                                git fetch remote "$( ${ milestone } )"
                                                                                                                # echo "9fe3ab15-dcb8-4c20-9b10-acf2ae03a832 \"$*\"" >> /tmp/DEBUG
                                                                                                                git fetch remote "$BRANCH" >> /tmp/DEBUG 2>&1
                                                                                                                # echo "7e2eb856-cc20-4d75-89be-7a3bf88c5670 \"$*\"" >> /tmp/DEBUG
                                                                                                                git checkout "$COMMIT"
                                                                                                                echo "247980e6-bc8f-4b5d-a05c-12025a1f0a45 \"$*\"" >> /tmp/DEBUG
                                                                                                                find "$LOCO20/inputs" -mindepth 1 -maxdepth 1 -type d | while read -r DIR
                                                                                                                do
                                                                                                                    echo "b807ca77-cf45-4937-aa5c-07fa6312bafa \"$*\"" >> /tmp/DEBUG
                                                                                                                    REMOTE="$( < "$DIR/remote" )"
                                                                                                                    echo "3636e66b-9f29-44fe-a054-549c2be606e6 \"$*\"" >> /tmp/DEBUG
                                                                                                                    NAME="$( < "$DIR/name" )"
                                                                                                                    echo "ba974033-5f0a-4a1f-b1c3-b26ee62c713b \"$*\"" >> /tmp/DEBUG
                                                                                                                    BRANCH="$( < "$DIR/branch" )"
                                                                                                                    echo "470125f2-b9bd-4ce0-8798-6816eb6739f4 BRANCH=$BRANCH" >> /tmp/DEBUG
                                                                                                                    COMMIT="$( < "$DIR/commit" )"
                                                                                                                    echo "129e0f61-21b3-42c1-a3c5-84b324eb7221 ${ resources.milestone.source.input } $REMOTE $BRANCH $COMMIT" >> /tmp/DEBUG
                                                                                                                    REPO="$( ${ resources.milestone.source.input } "$REMOTE" "$BRANCH" "$COMMIT" )"
                                                                                                                    echo 7258034d-fa07-4e1a-8e32-99fcbc143a60 >> /tmp/DEBUG
                                                                                                                    Z_COMMIT="$( GIT_DIR="$REPO/git" GIT_WORK_TREE="$REPO/work-tree" git rev-parse HEAD )"
                                                                                                                    cat >> /tmp/DEBUG <<EOF
                                                                                                                    b4902496-27b4-4743-87b8-820709c4500c
                                                                                                                sed -i "s#\($NAME\.url.*?ref=\).*\"#\1$Z_COMMIT\"#" "$GIT_WORK_TREE/flake.nix" >> /tmp/DEBUG2 2>&1
                                                                                                                EOF
                                                                                                                    sed -i "s#\($NAME\.url.*?ref=\).*\"#\1$Z_COMMIT\"#" "$GIT_WORK_TREE/flake.nix" >> /tmp/DEBUG2 2>&1
                                                                                                                    echo "2c0c3a84-0e53-4ef4-b315-b1716662a48c \"$*\"" >> /tmp/DEBUG
                                                                                                                done
                                                                                                                date +%s > "$GIT_WORK_TREE/current-time.nix"
                                                                                                                git commit -am "" --allow-empty-message
                                                                                                                git rebase "remote/$( ${ milestone } )"
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ setup }/bin/setup" ;
                                                                                } ;
                                                                    } ;
                                                                virtual-machines =
                                                                    let
                                                                        virtual-machine =
                                                                            bootloader : ignore :
                                                                                {
                                                                                    init-inputs = [ pkgs.nixos-rebuild ] ;
                                                                                    init-text =
                                                                                        ''
                                                                                            cd "$SELF"
                                                                                            CHECK="$( ${ resources.milestone.check } "$@" )"
                                                                                            STATUS="$( < "$CHECK/status" )"
                                                                                            if [[ "$STATUS" != 0 ]]
                                                                                            then
                                                                                                exit 64
                                                                                            else
                                                                                                export NIX_SHOW_STATS=5
                                                                                                export NIX_DEBUG=1
                                                                                                nixos-rebuild build-vm${ if bootloader then "-with-bootloader" else "" } --flake "$( ${ resources.milestone.source.root } "$@" )/work-tree#tester" --verbose --show-trace
                                                                                                SHARED_DIR="$SELF/test"
                                                                                                export SHARED_DIR
                                                                                                mkdir --parents "$SHARED_DIR"
                                                                                                "$SELF/result/bin/run-nixos-vm" -nographic >> /tmp/DEBUG 2>&1
                                                                                            fi
                                                                                        '' ;
                                                                                } ;
                                                                        in
                                                                            {
                                                                                virtual-machine = virtual-machine false ;
                                                                                virtual-machine-with-bootloader = virtual-machine true ;
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
                                                                                    "alias.promote" =
                                                                                        let
                                                                                            promote =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "promote" ;
                                                                                                        runtimeInputs = [ pkgs.coreutils ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                echo "3b7de200-6e7b-4e34-b14e-6b98e7b91fc9 \"$*\"" >> /tmp/DEBUG
                                                                                                                mkdir --parents "$SELF/promote"
                                                                                                                echo "627ac449-a60d-4c35-94f7-107c573aa511 \"$*\"" >> /tmp/DEBUG
                                                                                                                ROOT="$( mktemp --directory "$SELF/promote/XXXXXXXX" )"
                                                                                                                echo "e9a79846-6bfd-4fb8-a891-0a99971501dc \"$*\"" >> /tmp/DEBUG
                                                                                                                commit ( )
                                                                                                                    {
                                                                                                                        REPO="$1"
                                                                                                                        GIT_DIR="$REPO/git" GIT_WORK_TREE="$REPO/work-tree" git rev-parse HEAD
                                                                                                                        echo "69e1c788-3d03-432b-a4e7-1e8314813a50 \"$*\"" >> /tmp/DEBUG
                                                                                                                    }
                                                                                                                mkdir --parents "$SELF/promote"
                                                                                                                echo "5bd81eaf-1485-481d-b8d4-a1531694eec2 \"$*\"" >> /tmp/DEBUG
                                                                                                                if [[ ! -e "$SELF/promote/snapshot" ]]
                                                                                                                then
                                                                                                                    SNAPSHOT="$( ${ resources.milestone.snapshot } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$SNAPSHOT" "$ROOT/snapshot"
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/source" ]]
                                                                                                                then
                                                                                                                    SOURCE="$( ${ resources.milestone.source.root } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$SOURCE" "$ROOT/source"
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/check" ]]
                                                                                                                then
                                                                                                                    CHECK="$( ${ resources.milestone.check } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$CHECK" "$ROOT/check"
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/vm" ]]
                                                                                                                then
                                                                                                                    VM="$( ${ resources.milestone.virtual-machines.virtual-machine } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$VM" "$ROOT/vm"
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/vm-with-bootloader" ]]
                                                                                                                then
                                                                                                                    VM_WITH_BOOTLOADER="$( ${ resources.milestone.virtual-machines.virtual-machine-with-bootloader } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$VM_WITH_BOOTLOADER" "$ROOT/vm-with-booloader"
                                                                                                                fi
                                                                                                                if [[ ! -e "$SELF/promote/build" ]]
                                                                                                                then
                                                                                                                    BUILD="$( ${ resources.milestone.build } --link root "$SELF" "$( commit "$SELF" )" --link input "$SELF/inputs/personal" "$( commit "$SELF/inputs/personal" )" --link input "$SELF/inputs/secret" "$( commit "$SELF/inputs/secret" )" )"
                                                                                                                    ln --symbolic "$BUILD" "$ROOT/build"
                                                                                                                fi
                                                                                                            '' ;

                                                                                                    } ;
                                                                                            in "!${ promote }/bin/promote" ;
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
                                                                                                        ln --symbolic "$( ${ resources.repository.personal } "$@" )" "$SELF/inputs/personal"
                                                                                                        echo 6105aa25-0db5-48f7-9455-75061c414941 >> /tmp/DEBUG
                                                                                                        ln --symbolic "$( ${ resources.repository.secret } "$@" )" "$SELF/inputs/secret"
                                                                                                        echo bdec44ba-c1bc-4371-9b62-9979a0364863 >> /tmp/DEBUG
                                                                                                        ln --symbolic "$( ${ resources.repository.secrets } "$@" )" "$SELF/inputs/secrets"
                                                                                                        echo 553fb241-28b2-4fc8-bd25-e2652035fde9 >> /tmp/DEBUG
                                                                                                        ln --symbolic "$( ${ resources.repository.visitor } "$@" )" "$SELF/inputs/visitor"
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
                                                                                                makeWrapper ${ pkgs.jetbrains.idea-community }/bin/idea-community $out/bin/${ name } --add-flags '$( ${ repository } )'
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
                                                                                remote = lib.mkOption { default = "git@github.com:AFnRFCb7/secret" ; type = lib.types.str ; } ;
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
