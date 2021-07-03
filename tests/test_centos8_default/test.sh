#!/bin/bash
STEP=""
LIST=0
result=0
trap 'result=1' ERR
function usage {
    echo "Usage: $0 [-l] [-r <stage/all>] [-a]"
}
while getopts ":lr:af" opt; do
  case ${opt} in
    l )
        LIST=1
        STEP=all
      ;;
    r )
        if [ -z "$OPTARG" ]; then
            echo "usage $0 -r <stage>"
            exit 1
        fi
        STEP=$OPTARG
      ;;
    a )
        STEP=all
        echo "run all"
      ;;
    \? )
        usage
        exit 0
      ;;
  esac
done
if [ -z "$STEP" ]; then
    usage
fi
if [ "$STEP" == "prepare" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo prepare haltOnFailure || ./prepare_env.sh
fi
if [ "$STEP" == "dependency" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo dependency haltOnFailure || bash -c "source venv/bin/activate && ./dependency.sh"
fi
if [ "$STEP" == "lint" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo lint haltOnFailure || bash -c "source venv/bin/activate && ./lint.sh"
fi
if [ "$STEP" == "converge" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo converge haltOnFailure || bash -c "source venv/bin/activate && ./converge.sh"
fi
if [ "$STEP" == "converge2" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo converge2 haltOnFailure || bash -c "source venv/bin/activate && ./converge.sh"
fi
if [ "$STEP" == "idempotency" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo idempotency haltOnFailure || bash -c "source venv/bin/activate && ./idempotency.sh"
fi
if [ "$STEP" == "check_mode" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo check_mode haltOnFailure || bash -c "source venv/bin/activate && ./check_mode.sh"
fi
if [ "$STEP" == "verify" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo verify haltOnFailure || bash -c "source venv/bin/activate && ./verify.sh"
fi
if [ "$STEP" == "reboot" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo reboot haltOnFailure || bash -c "source venv/bin/activate && ./reboot.sh"
fi
if [ "$STEP" == "idempotency2" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo idempotency2 haltOnFailure || bash -c "source venv/bin/activate && ./idempotency.sh"
fi
if [ "$STEP" == "verify2" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo verify2 haltOnFailure || bash -c "source venv/bin/activate && ./verify.sh"
fi
if [ "$STEP" == "destroy" ] || [ "$STEP" == "all" ]; then
    [ $LIST -eq 1 ] && echo destroy alwaysRun || ./destroy.sh
fi
exit $result
