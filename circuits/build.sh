#!/bin/bash
# Iterating all directories under circuit
# setup circuit only matched name directory & code file.

TARGET_DIR=${1:-*/}

for d in $TARGET_DIR ; do
    DIR=$(basename $d)

    CODE_FILE=${DIR}.code
    TEST_FILE=${DIR}.test.code
    cd $DIR

    if [[ ! -z "${TEST}" ]]; then
        if [ -f "$TEST_FILE" ]; then
            echo "Testing $DIR... "
            RUST_BACKTRACE=1 ../../zokrates compile -i $TEST_FILE # 1> /dev/null
        else
            echo "No test file exists"
            exit -1
        fi
        # continue
    elif [ -f "$CODE_FILE" ]; then
        echo "Working on $DIR"
        rm -rf out*
        rm -rf *.key

        echo "Compilling $DIR... "
        RUST_BACKTRACE=1 ../../zokrates compile -i $DIR.code

        echo "Setting proving scheme..."
        ../../zokrates setup --proving-scheme pghr13

        echo "Exporting verifier contract..."
        ../../zokrates export-verifier --proving-scheme pghr13 --output "${DIR}_Verifier.sol" --contract-name "${DIR}_Verifier"

        if [ -f "${DIR}_Verifier.sol" ]; then
            echo "Move verifier contract"
            mv "${DIR}_Verifier.sol"  "../../contracts/verifiers/${DIR}_Verifier.sol"
        fi

        echo "$DIR initialized"
        echo ""
    fi
    cd ..
done
