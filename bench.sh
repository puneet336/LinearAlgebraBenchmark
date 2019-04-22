#!/bin/bash
_SIZES="10 20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800 900 1000 1500 2000 2500 3000 3500 4000"

for _i in ${_SIZES}
do
    _TIME=$(./a.out $_i $_i $_i|grep "Elapsed:"|awk '{print $2}')
    echo "$_i $_TIME"
done
