let
    pkgs = import <nixpkgs> {} ;
    in pkgs.mkShell
        {
            buildInputs =
                [
                    (
                        pkgs.writeShellApplication
                            {
                                name = "shellHook" ;
                                runtimeInputs = [ pkgs.coreutils pkgs.jq pkgs.redis pkgs.yg-go ] ;
                                text =
                                    ''
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
                                                mkdir --parents "$HOME/resources/logs"
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
                                                    | yq eval --prettyPrint '[.]' >> "$HOME/resources/logs/log.yaml" || failure 31275
                                            fi
                                        done
                                    '' ;
                            }
                    )
                ] ;
            shellHook = "shellHook" ;
        }