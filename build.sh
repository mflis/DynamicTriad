pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

set -e

filedir=$(dirname $(readlink -f $0))
echo entering $filedir
pushd $filedir

ask() {
    local ret
    echo -n "$1 (default: $2, use a space ' ' to leave it empty) " 1>&2
    read ret
    if [ -z "$ret" ]; then
        ret=$2
    elif [ "$ret" == " " ]; then
        ret=""
    fi
    echo $ret
}

export EIGEN3_INCLUDE_DIR=" /home/ubuntu/anaconda3/envs/tensorflow_p27/include/eigen3"



echo building mygraph module ...
rm -rf core/mygraph-build
mkdir -p core/mygraph-build
pushd core/mygraph-build
cmake ../graph
make && ln -sf mygraph-build/mygraph.so ../mygraph.so 
popd

echo building c extensions for dynamic triad ...
pushd core/algorithm
rm -rf build && mkdir build && cd build
cmake ..
make && make install
popd

popd
