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
                        private-reporter ,
                        resource ,
                        resource-logger ,
                        resource-releaser ,
                        resource-reporter ,
                        resource-resolver ,
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
                                                                    in
                                                                        r.implementation
                                                                            {
                                                                                follow-parent = point.follow-parent or false ;
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
                                                            dot-gnupg =
                                                                ignore :
                                                                    _dot-gnupg.implementation
                                                                        {
                                                                            ownertrust-fun = { mount , pkgs , resources , root , wrap } : ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/ownertrust.asc" ;
                                                                            secret-keys-fun = { mount , pkgs , resources , root , wrap } : ignore : "${ _fixture.implementation }/gnupg/dot-gnupg/secret-keys.asc" ;
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
                                                                            { mount , pkgs , resources , root , wrap } :
                                                                                let
                                                                                    application =
                                                                                        pkgs.writeShellApplication
                                                                                            {
                                                                                                name = "init" ;
                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gnupg root ( _failure.implementation "b9d858ef" ) ] ;
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
                                                                                                        echo "$INIT" > /mount/init
                                                                                                        echo "$RELEASE" > /mount/release
                                                                                                        if "$INIT"
                                                                                                        then
                                                                                                            failure b9a218e1
                                                                                                        fi
                                                                                                        chmod 0400 /mount/init /mount/release
                                                                                                        DOT_GNUPG=${ resources.foobar.dot-gnupg ( setup : setup ) }
                                                                                                        root "$DOT_GNUPG"
                                                                                                        root ${ pkgs.gnupg }
                                                                                                        ln --symbolic "$DOT_GNUPG/dot-gnupg" /mount
                                                                                                        DOT_SSH=${ resources.foobar.dot-ssh ( setup : setup ) }
                                                                                                        root "$DOT_SSH"
                                                                                                        ln --symbolic "$DOT_SSH/config" /mount/dot-ssh
                                                                                                        GIT_REPOSITORY=${ resources.foobar.git-repository ( setup : setup ) }
                                                                                                        root "$GIT_REPOSITORY"
                                                                                                        ln --symbolic "$GIT_REPOSITORY/git-repository" /mount
                                                                                                        SECRET=${ resources.foobar.secret ( setup : setup ) }
                                                                                                        root "$SECRET"
                                                                                                        ln --symbolic "$SECRET/secret" /mount
                                                                                                    '' ;
                                                                                            } ;
                                                                                    in "${ application }/bin/init" ;
                                                                        follow-parent = true ;
                                                                        release =
                                                                            let
                                                                                application =
                                                                                    pkgs.writeShellApplication
                                                                                        {
                                                                                            name = "release" ;
                                                                                            runtimeInputs = [ pkgs.coreutils ( _failure.implementation "f99f6e39" ) ] ;
                                                                                            text =
                                                                                                ''
                                                                                                    echo d9ee4b5f
                                                                                                    RELEASE="$( cat /mount/release )" || failure "6e02a8fe"
                                                                                                    if $RELEASE
                                                                                                    then
                                                                                                        failure e82ab2c6
                                                                                                    fi
                                                                                                '' ;
                                                                                        } ;
                                                                                    in "${ application }/bin/release" ;
                                                                        seed =
                                                                            {
                                                                                release = "${ pkgs.coreutils }/bin/true" ;
                                                                                resolutions =
                                                                                    {
                                                                                        init = [ "alpha" "beta" ] ;
                                                                                        release = [ "gamma" "delta" ] ;
                                                                                    } ;
                                                                            } ;
                                                                        targets = [ "dot-gnupg" "dot-ssh" "git-repository" "init" "release" "secret" ] ;
                                                                        transient = true ;
                                                                    } ;
                                                            git-repository = ignore : _git-repository.implementation { follow-parent = false ; resolutions = [ ] ; setup = null ; } ;
                                                            secret = ignore : _secret.implementation { encrypted = ignore : "${ _fixture.implementation }/age/encrypted/known-hosts.asc" ; identity = ignore : "${ _fixture.implementation }/age/identity/private" ; } ;
                                                        } ;
                                                    production =
                                                        {
                                                            age =
                                                                {
                                                                    public =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { mount , pkgs , resources , root , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ pkgs.age ] ;
                                                                                                        text =
                                                                                                            ''
                                                                                                                age-keygen -y ${ config.personal.agenix } > /mount/public
                                                                                                                chmod 0400 /mount/public
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "public" ] ;
                                                                            } ;
                                                                } ;
                                                            alpha =
                                                                ignore :
                                                                    {
                                                                        init =
                                                                            { mount , pkgs , resources , root , wrap } :
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
                                                                            ownertrust-fun = { mount , pkgs , resources , root , wrap } : resources.production.secrets.ownertrust ;
                                                                            secret-keys-fun = { mount , pkgs , resources , root , wrap } : resources.production.secrets.secret-keys ;
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
                                                                                            identity-file = { mount , pkgs , resources , root , wrap } : resources.production.secrets.dot-ssh.github.identity-file ( setup : "echo | ${ setup }" ) ;
                                                                                            user-known-hosts-file = { mount , pkgs , resources , root , wrap } : resources.production.secrets.dot-ssh.github.user-known-hosts-file ( setup : "echo | ${ setup }" ) ;
                                                                                        } ;
                                                                                    laptop =
                                                                                        {
                                                                                            identity-file = { mount , pkgs , resources , root , wrap } : resources.production.fixture.laptop ( setup : "echo | ${ setup }" ) ;
                                                                                            user-known-hosts-file = { mount , pkgs , resources , root , wrap } : resources.production.fixture.laptop ( setup : "echo | ${ setup }" ) ;
                                                                                        } ;
                                                                                    mobile =
                                                                                        {
                                                                                            identity-file = { mount , pkgs , resources , root , wrap } : resources.production.secrets.dot-ssh.mobile.identity-file ( setup : "echo | ${ setup }" ) ;
                                                                                            user-known-hosts-file = { mount , pkgs , resources , root , wrap } : resources.production.fixture.laptop ( setup : "echo | ${ setup }" ) ;
                                                                                        } ;
                                                                                } ;
                                                                        } ;
                                                            fixture =
                                                                {
                                                                    laptop =
                                                                            ignore :
                                                                                {
                                                                                    init =
                                                                                        { mount , pkgs , resources , root , wrap } :
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
                                                                                    { mount , pkgs , resources , root , wrap } :
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
                                                                                    { mount , pkgs , resources , root , wrap } :
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
                                                                    studio =
                                                                        {
                                                                            entry =
                                                                                ignore :
                                                                                    _git-repository.implementation
                                                                                        {
                                                                                            follow-parent = true ;
                                                                                            resolutions = [ ] ;
                                                                                            setup =
                                                                                                { mount , resources , pkgs , root , wrap } :
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
                                                                                                                            wrap
                                                                                                                            ( _failure.implementation "6e3e1011" )
                                                                                                                            (
                                                                                                                                pkgs.writeShellApplication
                                                                                                                                    {
                                                                                                                                        name = "submodule" ;
                                                                                                                                        runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( _failure.implementation "3410b891" ) ] ;
                                                                                                                                        text =
                                                                                                                                            ''
                                                                                                                                                git config alias.mutable-snapshot "$MOUNT/alias/submodule/mutable-snapshot"
                                                                                                                                                git config alias.mutable-squash "$MOUNT/alias/submodule/mutable-squash"
                                                                                                                                                git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                                git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                                git config core.sshCommand "$MOUNT/ssh/command"
                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure 48cb787a
                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 348ef190
                                                                                                                                                git checkout -b "$BRANCH"
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
                                                                                                                                                            git -C "$MUTABLE_SNAPSHOT" mutable-${ command }
                                                                                                                                                        '' ;
                                                                                                                                                } ;
                                                                                                                                        in "${ application }/bin/mutable-${ command }";
                                                                                                                            mutable-mirror =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "mutable-mirror" ;
                                                                                                                                                runtimeInputs = [ pkgs.git ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        BRANCH="$1"
                                                                                                                                                        git fetch origin "$BRANCH"
                                                                                                                                                        git checkout "origin/$BRANCH"
                                                                                                                                                        git submodule update --init --recursive
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/mutable-mirror" ;
                                                                                                                            mutable-rebase =
                                                                                                                                let
                                                                                                                                    application = pkgs.writeShellApplication
                                                                                                                                        {
                                                                                                                                            name = "mutable-rebase" ;
                                                                                                                                            runtimeInputs = [ pkgs.git "$MOUNT/stage" root ] ;
                                                                                                                                            text =
                                                                                                                                                ''
                                                                                                                                                    export INDEX="$INDEX"
                                                                                                                                                    # shellcheck disable=SC2016
                                                                                                                                                    git submodule foreach '
                                                                                                                                                        git fetch origin main
                                                                                                                                                        if ! git diff origin/main --quiet || ! git diff origin/main --quiet --cached
                                                                                                                                                        then
                                                                                                                                                            : "${ builtins.concatStringsSep "" [ "$" "{" "name:?name must be set" "}" ] }"
                                                                                                                                                            cd "$MOUNT/repository/$name"
                                                                                                                                                            UUID="$( uuidgen | sha512sum )" || failure f192db0b
                                                                                                                                                            BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure 54d22bae
                                                                                                                                                            git checkout -b "$BRANCH"
                                                                                                                                                            git rebase -i origin/main
                                                                                                                                                            git push origin HEAD
                                                                                                                                                            TOKEN_DIRECTORY=${ resources.production.secrets.token ( setup : setup ) }
                                                                                                                                                            TOKEN="$( cat "$TOKEN_DIRECTORY/secret" )" || failure df9bf681
                                                                                                                                                            export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                                            NAME="$( basename "$name" )" || failure 9a285a44
                                                                                                                                                            cd "$MOUNT/repository"
                                                                                                                                                            nix flake update --flake "$MOUNT/repository" "$NAME"
                                                                                                                                                        fi
                                                                                                                                                    ' >&2
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
                                                                                                                                                    MUTABLE_SNAPSHOT=${ resources.production.repository.studio.snapshot ( setup : ''${ setup } "$BRANCH" "$COMMIT"'' ) }
                                                                                                                                                    root "$MUTABLE_SNAPSHOT"
                                                                                                                                                    echo "$MUTABLE_SNAPSHOT"
                                                                                                                                                '' ;
                                                                                                                                        } ;
                                                                                                                                    in "${ application }/bin/mutable-rebase" ;
                                                                                                                            mutable-snapshot =
                                                                                                                                {
                                                                                                                                    root =
                                                                                                                                        let
                                                                                                                                            application =
                                                                                                                                                pkgs.writeShellApplication
                                                                                                                                                    {
                                                                                                                                                        name = "mutable-snapshot" ;
                                                                                                                                                        runtimeInputs = [ pkgs.git root ] ;
                                                                                                                                                        text =
                                                                                                                                                            ''
                                                                                                                                                                cd "$MOUNT/repository"
                                                                                                                                                                git submodule foreach --quiet "git mutable-snapshot"
                                                                                                                                                                BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure 84ef6d86
                                                                                                                                                                if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                                                then
                                                                                                                                                                    git commit -a --verbose --allow-empty-message >&2
                                                                                                                                                                fi
                                                                                                                                                                git push origin HEAD >&2
                                                                                                                                                                COMMIT="$( git rev-parse HEAD )" || failure 79d3c8d2
                                                                                                                                                                MUTABLE_SNAPSHOT=${ resources.production.repository.studio.snapshot ( setup : ''${ setup } "$BRANCH" "$COMMIT"'' ) }
                                                                                                                                                                root "$MUTABLE_SNAPSHOT"
                                                                                                                                                                echo "$MUTABLE_SNAPSHOT"
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                            in "${ application }/bin/mutable-snapshot/repository" ;
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
                                                                                                                                                                    git commit -a --verbose --allow-empty-message
                                                                                                                                                                    git push origin HEAD
                                                                                                                                                                    TOKEN_DIRECTORY=${ resources.production.secrets.token ( setup : setup ) }
                                                                                                                                                                    TOKEN="$( cat "$TOKEN_DIRECTORY/secret" )" || failure 320e0c68
                                                                                                                                                                    export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                                                    NAME="$( basename "$name" )" || failure 8c4f2fea
                                                                                                                                                                    cd "$toplevel"
                                                                                                                                                                    nix flake update --flake "$MOUNT/repository" "$NAME"
                                                                                                                                                                fi
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
                                                                                                                                                        NAME="$( basename "$name" )" || failure 694203c3
                                                                                                                                                        nix flake update --flake "$toplevel" "$NAME"
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/mutable-squash" ;
                                                                                                                            ssh-command =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "ssh-command" ;
                                                                                                                                                runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        ssh -F "$MOUNT/stage/ssh/config" "$@"
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/ssh-command" ;
                                                                                                                            in
                                                                                                                        ''
                                                                                                                            git config alias.mutable-build-vm = "!${ mount }/stage/alias/root/mutable-build-vm"
                                                                                                                            git config alias.mutable-build-vm-with-bootloader = "!${ mount }/stage/alias/root/mutable-build-vm-with-bootloader"
                                                                                                                            git config alias.mutable-check = "!${ mount }/stage/alias/rootmutable-check" ;
                                                                                                                            git config alias.mutable-mirror = "!${ mount }/stage/alias/rootmutable-mirror" ;
                                                                                                                            git config alias.mutable-promote = "!${ mount }/stage/alias/rootmutable-promote" ;
                                                                                                                            git config alias.mutable-rebase = "!${ mount }/stage/alias/rootmutable-rebase" ;
                                                                                                                            git config alias.mutable-snapshot = "!${ mount }/stage/alias/rootmutable-snapshot" ;
                                                                                                                            git config alias.mutable-switch = "!${ mount }/stage/mutable-switch" ;
                                                                                                                            git config alias.mutable-test = "!${ mount }/stage/alias/rootmutable-test" ;
                                                                                                                            git config core.sshCommand = "${ mount }/stage/ssh/command" ;
                                                                                                                            git config user.email "${ config.personal.repository.private.email }"
                                                                                                                            git config user.name "${ config.personal.repository.private.name }"
                                                                                                                            git remote add origin config.personal.repository.private.remote ;
                                                                                                                            wrap ${ mutable- "build-vm" } stage/alias/root/mutable-build-vm 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable- "build-vm-with-bootloader" } stage/alias/root/mutable-build-vm-with-bootloader 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable- "check" } stage/alias/root/mutable-check 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable-mirror } stage/alias/root/mutable-mirror 0500 --literal BRANCH
                                                                                                                            wrap ${ mutable- "promote" } stage/alias/root/mutable-promote 0500 --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable-rebase } stage/alias/root/mutable-rebase 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable- "mutable-snapshot" } stage/alias/root/mutable-snapshot 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable-squash } stage/alias/root/mutable-squash 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable- "switch" } stage/alias/root/mutable-switch 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable- "test" } stage/alias/root/mutable-test 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ ssh-command } stage/ssh/command 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            wrap ${ mutable-snapshot.submodule } stage/alias.submodule/mutable-switch 0500 --inherit INDEX --set-plain MOUNT "${ mount }"
                                                                                                                            DOT_SSH=${ resources.production.dot-ssh ( setup : setup ) }
                                                                                                                            root "$DOT_SSH"
                                                                                                                            wrap "$DOT_SSH/config" stage/ssh/config 0400
                                                                                                                            git fetch origin main 2>&1
                                                                                                                            git checkout origin/main 2>&1
                                                                                                                            UUID="$( uuidgen | sha512sum )" || failure 22985e16
                                                                                                                            BRANCH="$( echo "scratch/$UUID" | sha512sum )" || failure 87fa1efd
                                                                                                                            git checkout -b "$BRANCH" 2>&1
                                                                                                                            git submodule foreach submodule
                                                                                                                        '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/setup" ;
                                                                                        } ;
                                                                            snapshot =
                                                                                ignore :
                                                                                    _git-repository.implementation
                                                                                        {
                                                                                            follow-parent = false ;
                                                                                            resolutions = [ ] ;
                                                                                            setup =
                                                                                                { mount , pkgs , resources , root , wrap } :
                                                                                                    let
                                                                                                        application =
                                                                                                            pkgs.writeShellApplication
                                                                                                                {
                                                                                                                    name = "setup" ;
                                                                                                                    runtimeInputs = [ pkgs.git root wrap ] ;
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
                                                                                                                                                            export SHARED_DIR="$MOUNT/artifacts/${ vm }/shared"
                                                                                                                                                            "$MOUNT/repository/result/bin/run-nixos-vm"
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
                                                                                                                                                        nix flake check "$MOUNT/repository#user"
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/mutable-build-vm" ;
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
                                                                                                                                                        ( _failure.implementation "171dfff6" )
                                                                                                                                                    ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        cd "$MOUNT/stage/artifacts/promote"
                                                                                                                                                        PARENT_1="$MOUNT"
                                                                                                                                                        STUDIO_1="$PARENT_1/repository"
                                                                                                                                                        BIN_1="$PARENT_1/stage/bin"
                                                                                                                                                        git -C "$STUDIO_1" mutable-snapshot
                                                                                                                                                        if git -C "$STUDIO_1" mutable-check
                                                                                                                                                        then
                                                                                                                                                            echo "✅ the zeroth checks passed"
                                                                                                                                                        else
                                                                                                                                                            failure 352cc13a "❌ the zeroth checks failed"
                                                                                                                                                        fi
                                                                                                                                                        git -C "$STUDIO_1" mutable-snapshot
                                                                                                                                                        git -C "$STUDIO_1" mutable-rebase
                                                                                                                                                        git -C "$STUDIO_1" mutable-snapshot
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
                                                                                                                                                        BRANCH="$( git -C "$STUDIO_1" rev-parse --abbrev-ref HEAD )" || failure 9cc2d040
                                                                                                                                                        UUID="$( uuidgen )" || failure fa8428cb
                                                                                                                                                        STUDIO_2="$( studio "$UUID" )" || failure 9a39c637
                                                                                                                                                        PARENT_2="$( dirname "$STUDIO_2" )" || failure 0db898ea
                                                                                                                                                        BIN_2="$PARENT_2/stage/bin"
                                                                                                                                                        git -C "$STUDIO_2" mutable-mirror "$BRANCH"
                                                                                                                                                        if diff --recursive --exclude .git --exclude .idea "$STUDIO_1" "$STUDIO_2"
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
                                                                                                                                                                cd "$MOUNT/repository/stage/artifacts/switch"
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" submodule foreach "git mutable-switch"
                                                                                                                                                                UUID="$( uuidgen | sha512sum )" || failure 0f1227b6
                                                                                                                                                                BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure d5910859
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" checkout -b "$BRANCH"
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" commit -am "" --allow-empty --allow-empty-message
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" fetch origin main
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" reset --soft origin/main
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" commit -a --verbose
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" push origin HEAD
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" checkout main
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" rebase "$BRANCH"
                                                                                                                                                                git -C "$MUTABLE_SNAPSHOT/repository" push origin main
                                                                                                                                                                nixos-rebuild switch --flake "$MUTABLE_SNAPSHOT/repository#user" --show-trace
                                                                                                                                                            '' ;
                                                                                                                                                    } ;
                                                                                                                                                in "${ application }/bin/mutable-switch" ;
                                                                                                                                    submodule =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "mutable-switch" ;
                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.gh pkgs.git pkgs.nix ( _failure.implementation "c0f7e8f6" ) ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        cd "$MOUNT/repository
                                                                                                                                                        git fetch origin main
                                                                                                                                                        if ! git diff origin/main --quiet || ! git diff origin/main --quiet --cached
                                                                                                                                                        then
                                                                                                                                                            BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure b7fb71d9
                                                                                                                                                            TOKEN=${ resources.production.secrets.token ( setup : setup ) }
                                                                                                                                                            gh auth login --with-token < "$TOKEN/secret"
                                                                                                                                                            if ! gh label list --json name --jq '.[].name' | grep -qx snapshot
                                                                                                                                                            then
                                                                                                                                                                gh label create snapshot --color "#333333" --description "Scripted Snapshot PR"
                                                                                                                                                            fi
                                                                                                                                                            gh pr create --base main --head "$BRANCH" --label "snapshot"
                                                                                                                                                            URL="$( gh pr view --json url --jq .url )" || failure 31ccb1f3
                                                                                                                                                            gh pr merge "$URL" --rebase
                                                                                                                                                            gh auth logout
                                                                                                                                                            : "${ builtins.concatStringsSep "" [ "$" "{" "toplevel:?name must be set" "}" ] }"
                                                                                                                                                            : "${ builtins.concatStringsSep "" [ "$" "{" "name:?name must be set" "}" ] }"
                                                                                                                                                            NAME="$( basename "$name" )" || failure 368e7b07
                                                                                                                                                            nix flake update --flake "$toplevel" "$NAME"
                                                                                                                                                        fi
                                                                                                                                                    '' ;
                                                                                                                                            } ;
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
                                                                                                                                                        nixos-rebuild test --flake "$MOUNT/repository#user"
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/mutable-test" ;
                                                                                                                            ssh-command =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "ssh-command" ;
                                                                                                                                                runtimeInputs = [ pkgs.openssh ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        ssh -F "$MOUNT/stage/ssh/config" "$@"
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/ssh" ;
                                                                                                                            submodules =
                                                                                                                                let
                                                                                                                                    application =
                                                                                                                                        pkgs.writeShellApplication
                                                                                                                                            {
                                                                                                                                                name = "submodules" ;
                                                                                                                                                runtimeInputs = [ pkgs.coreutils pkgs.git pkgs.libuuid ( _failure.implementation "aa2cc832" ) ] ;
                                                                                                                                                text =
                                                                                                                                                    ''
                                                                                                                                                        git config alias.mutable-switch "${ mount }/alias/submodule/mutable-switch"
                                                                                                                                                        git config core.sshCommand "${ mount }/stage/ssh/command"
                                                                                                                                                        git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                                        git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                                        UUID="$( uuidgen | sha512sum )" || failure a25716db
                                                                                                                                                        BRANCH="$( echo "scratch/$UUID" | cut --characters 1-64 )" || failure 89ef1ef5
                                                                                                                                                        git checkout -b "$BRANCH"
                                                                                                                                                    '' ;
                                                                                                                                            } ;
                                                                                                                                    in "${ application }/bin/submodules" ;
                                                                                                                            in
                                                                                                                                ''
                                                                                                                                    BRANCH="$1"
                                                                                                                                    COMMIT="$2"
                                                                                                                                    git config alias.mutable-build-vm "!${ mount }/stage/alias/root/mutable-build-vm"
                                                                                                                                    git config alias.mutable-build-vm-with-bootloader "!${ mount }/stage/alias/root/mutable-build-vm-with-bootloader"
                                                                                                                                    git config alias.mutable-check "!${ mount }/stage/alias/root/mutable-check"
                                                                                                                                    git config alias.mutable-switch "!${ mount }/stage/alias/root/mutable-switch"
                                                                                                                                    git config alias.mutable-test "!${ mount }/stage/alias/root/mutable-test"
                                                                                                                                    git config user.email "${ config.personal.repository.private.email }"
                                                                                                                                    git config user.name "${ config.personal.repository.private.name }"
                                                                                                                                    git config core.sshCommand "${ mount }/stage/ssh/command"
                                                                                                                                    wrap ${ mutable-build-vm "build-vm" } stage/alias/root/build-vm 0500 --set-plain MOUNT "${ mount }"
                                                                                                                                    wrap ${ mutable-build-vm "build-vm-with-bootloader" } stage/alias/root/build-vm-with-bootloader 0500 --set-plain MOUNT "${ mount }"
                                                                                                                                    wrap ${ mutable-check } stage/alias/root/mutable-check 0500 --set-plain MOUNT "${ mount }"
                                                                                                                                    wrap ${ mutable-promote } stage/alias/root/mutable-promote 0500 --set-plain MOUNT "${ mount }"
                                                                                                                                    wrap ${ mutable-switch.root } stage/alias/root/mutable-switch 0500 --set-plain MOUNT "${ mount }"
                                                                                                                                    wrap ${ mutable-test } stage/alias/root/mutable-test 0500 --set-plain MOUNT "${ mount }"
                                                                                                                                    wrap ${ ssh-command } stage/bin/ssh 0500 --literal "@" --set-plain MOUNT "${ mount }"
                                                                                                                                    DOT_SSH=${ resources.production.dot-ssh ( setup : setup ) }
                                                                                                                                    root "$DOT_SSH"
                                                                                                                                    wrap "$DOT_SSH/config" stage/
                                                                                                                                    ssh/config 0400
                                                                                                                                    git remote add origin "${ config.personal.repository.private.remote }"
                                                                                                                                    git fetch origin "$BRANCH" 2>&1
                                                                                                                                    git checkout "$COMMIT" 2>&1
                                                                                                                                    mkdir --parents /mount/stage/artifacts/build-vm/shared
                                                                                                                                    mkdir --parents /mount/stage/artifacts/build-vm-with-bootloader/shared
                                                                                                                                    mkdir --parents /mount/stage/artificats/promote
                                                                                                                                    mkdir --parents /mount/stage/artifacts/check
                                                                                                                                    mkdir --parents /mount/stage/artifacts/test
                                                                                                                                    mkdir --parents /mount/stage/artifacts/switch
                                                                                                                                    git submodule foreach "submodule"
                                                                                                                                '' ;
                                                                                                                } ;
                                                                                                        in "${ application }/bin/pre-setup" ;
                                                                                        } ;
                                                                        } ;
                                                                } ;
                                                            scripts =
                                                                {
                                                                    snapshot =
                                                                        ignore :
                                                                            {
                                                                                init =
                                                                                    { mount , pkgs , resources , root , wrap } :
                                                                                        let
                                                                                            application =
                                                                                                pkgs.writeShellApplication
                                                                                                    {
                                                                                                        name = "init" ;
                                                                                                        runtimeInputs = [ ] ;
                                                                                                        text =
                                                                                                            let
                                                                                                                snapshot =
                                                                                                                    pkgs.writeShellApplication
                                                                                                                        {
                                                                                                                            name = "snapshot" ;
                                                                                                                            runtimeInputs = [ pkgs.git ( _failure.implementation "5afc908c" ) ] ;
                                                                                                                            text =
                                                                                                                                ''
                                                                                                                                    if ! git diff --quiet || ! git diff --quiet --cached
                                                                                                                                    then
                                                                                                                                        if git symbolic-ref -q HEAD
                                                                                                                                        then
                                                                                                                                            BRANCH="$( git rev-parse --abbrev-ref HEAD )" || failure 96acc6a6
                                                                                                                                        else
                                                                                                                                            UUID="$( uuidgen | sha512sum )" || failure d3737ca3
                                                                                                                                            BRANCH="$( echo "scratch/$UUID" | cut --bytes 1-64 )" || failure 78dc2d70
                                                                                                                                            git checkout -b "$BRANCH"
                                                                                                                                        fi
                                                                                                                                        git commit --verbose --allow-empty --allow-empty-message
                                                                                                                                        NAME="$( basename "$name" )" || failure e006c4e7
                                                                                                                                        git push origin HEAD
                                                                                                                                        TOKEN_DIRECTORY=${ resources.production.secrets.token ( setup : setup ) }
                                                                                                                                        TOKEN="$( cat "$TOKEN_DIRECTORY/secret" )" || failure 320e0c68
                                                                                                                                        export NIX_CONFIG="access-tokens = github.com=$TOKEN"
                                                                                                                                        nix flake update --flake "$MOUNT/repository" "$NAME"
                                                                                                                                    fi
                                                                                                                                '' ;
                                                                                                                        } ;
                                                                                                                in "${ application }/bin/snapshot"
                                                                                                            ''
                                                                                                                NAME="$1"
                                                                                                                wrap ${ snapshot } script 0500 --literal BRANCH --literal UUID --
                                                                                                            '' ;
                                                                                                    } ;
                                                                                            in "${ application }/bin/init" ;
                                                                                targets = [ "script" ] ;
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
                                                                        init = { mount , pkgs , resources , root , wrap } : "" ;
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
                                                        systemd.services =
                                                            let
                                                                fun =
                                                                    text :
                                                                        {
                                                                            name = builtins.hashString "sha512" text ;
                                                                            value =
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
                                                                                                                runtimeInputs = [ ] ;
                                                                                                                text = text ;
                                                                                                            } ;
                                                                                                    in "${ application }/bin/ExecStart" ;
                                                                                            User = config.personal.name ;
                                                                                        } ;
                                                                                    wantedBy = [ "multi-user.target" ] ;
                                                                                } ;
                                                                        } ;
                                                                resource-reporter =
                                                                    organization : repository : resolution :
                                                                        {
                                                                            after = [ "network.target" "redis.service" ] ;
                                                                            enable = true ;
                                                                            serviceConfig =
                                                                                {
                                                                                    ExecStart =
                                                                                        _resource-reporter.implementation
                                                                                            {
                                                                                                channel = config.personal.channel ;
                                                                                                organization = organization ;
                                                                                                repository = repository ;
                                                                                                resolution = resolution ;
                                                                                                token = resources__.production.secrets.token ( setup : setup ) ;
                                                                                            } ;
                                                                                    User = config.personal.name ;
                                                                                } ;
                                                                            wantedBy = [ "multi-user.target" ] ;
                                                                        } ;
                                                                in
                                                                    builtins.listToAttrs
                                                                        (
                                                                            [
                                                                                ( fun ( _resource-logger.implementation { log-directory = "/home/${ config.personal.name }/resources/log" ; } ) )
                                                                                # (
                                                                                #     fun
                                                                                #         (
                                                                                #             _resource-releaser.implementation
                                                                                #                 {
                                                                                #                     gc-roots-directory = "/home/${ config.personal.name }/.gc-roots" ;
                                                                                #                     locks-directory = "/home/${ config.personal.name }/resources/locks" ;
                                                                                #                     mounts-directory = "/home/${ config.personal.name }/resources/mounts" ;
                                                                                #                     quarantine-directory = "/home/${ config.personal.name }/resources/quarantine" ;
                                                                                #                 }
                                                                                #         )
                                                                                # )
                                                                                (
                                                                                    fun
                                                                                        (
                                                                                            _resource-reporter.implementation
                                                                                                {
                                                                                                    organization = config.personal.repository.personal.organization ;
                                                                                                    repository = config.personal.repository.personal.repository ;
                                                                                                    resolution = "personal" ;
                                                                                                    token = resources__.production.secrets.token ( setup : setup ) ;
                                                                                                }
                                                                                        )
                                                                                )
                                                                                ( fun ( _resource-resolver.implementation { quarantine-directory = "/home/${ config.personal.name }/resources/quarantine" ; } ) )
                                                                            ]
                                                                        ) ;
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
                                                                                            STUDIO=${ resources__.production.repository.studio.entry ( setup : ''${ setup } "$HAS_ARGUMENTS" "$ARGUMENTS"'' )}
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
                                                ownertrust-fun = { mount , pkgs , resources , root , wrap } : ignore : "${ fixture }/gnupg/ownertrust.asc" ; pkgs = pkgs ;
                                                secret-keys-fun = { mount , pkgs , resources , root , wrap } : ignore : "${ fixture }/gnupg/secret-keys.asc" ;
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
                                                expected = "/nix/store/9h0nwla2hw0zlcb1zwiawc5i3d22vvrl-init/bin/init" ;
                                                mount = "271a376c" ;
                                                pkgs = pkgs ;
                                                implementation-resources =
                                                    {
                                                        cb8e09cf =
                                                            {
                                                                user-known-hosts-file = { mount , pkgs , resources , root , wrap } : builtins.toString pkgs.coreutils ;
                                                            } ;
                                                        f5d69296 =
                                                            {
                                                                user-known-hosts-file = { mount , pkgs , resources , root , wrap } : builtins.toString pkgs.coreutils ;
                                                            } ;
                                                        b8b6ddc8 =
                                                            {
                                                                strict-host-key-checking = { mount , pkgs , resources , root , wrap } : builtins.toString pkgs.coreutils ;
                                                                user-known-hosts-file = { mount , pkgs , resources , root , wrap } : builtins.toString pkgs.coreutils ;
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
                                                            { mount , pkgs , resources , root , wrap } :
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
                                                                                        echo "mount = ${ mount }"
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
                                                     expected-type = "invalid" ;
                                                     init =
                                                         { mount , pkgs , resources , root , wrap } :
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
                                                                                     echo "mount = ${ mount }"
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
                                        resource-logger = _resource-logger.check { expected = "/nix/store/6iyrf556ps24jvigrx7jgfvyi4jvrlmk-resource-logger/bin/resource-logger" ; } ;
                                        # resource-releaser = _resource-releaser.check { expected = "/nix/store/b8xr2kiqawqp3gmg1h18zg5q5r7jvzpv-resource-releaser/bin/resource-releaser" ; } ;
                                        resource-reporter = _resource-reporter.check { expected = "/nix/store/nn3aj176h78zd4nbbwbvbkj85dw43lqf-resource-reporter/bin/resource-reporter" ; } ;
                                        resource-resolver = _resource-resolver.check { expected = "/nix/store/qfmq26b2x9x66n3fc4bfqxvm0r1amiag-resource-resolver/bin/resource-resolver" ; } ;
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
