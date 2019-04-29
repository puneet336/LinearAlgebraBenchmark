#!/bin/bash
_SIZES="10 20 30 40 50 60 70 80 90 100 200 300 400 500 600 700 800 900 1000 1500 2000 2500 3000 3500 4000"
OPT_FLAGS="-fomit-frame-pointer -funroll-loops -W -Wall -fopenmp -O3 -ffast-math -ftree-vectorize -march=znver1 -mtune=znver1 -mfma -mavx2 -m3dnow -mavx -fprefetch-loop-arrays -mprefetchwt1"
module load gcc


#LIB="-L/home/puneet2/MySoftwares/LIBRARY/BLIS/1.3_mt_precompiled_amd/lib/ -L/home/puneet2/MySoftwares/LIBRARY/AMD-LIBM/lib/static/ -lblis-mt -lblis -lm"
echo "MESSAGE: BLIS $(date) start"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/puneet2/MySoftwares/LIBRARY/BLIS/1.3_mt_precompiled_amd/lib/"
LIB="-L/home/puneet2/MySoftwares/LIBRARY/BLIS/1.3_mt_precompiled_amd/lib/  -lblis-mt -lblis -lm"
gcc $OPT_FLAGS mxm.c -o blis.exe $LIB
 for _i in ${_SIZES}
 do
    ./blis.exe $_i $_i $_i > temp.txt
    STAT1=$(echo $?)
    grep "Error" temp.txt 2>/dev/null 1>/dev/null
    STAT2=$(echo $?)
    if [[ $STAT1 -ne 0  ]] && [[ $STAT2 -eq 0  ]]
    then
           echo "Error"
           exit 1
    fi
    _TIME=$(grep "Elapsed:" temp.txt|awk '{print $2}')
    mv temp.txt archive/blis_${_i}_$(date +%Y%m%d_%H%M%S)
    echo "RESULT:blis $_i $_TIME"
 done


echo "MESSAGE: BLAS $(date) start"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/puneet2/MySoftwares/LIBRARY/LAPACK/3.8.0_gcc7.2.0/lib64/"
LIB="-L/home/puneet2/MySoftwares/LIBRARY/LAPACK/3.8.0_gcc7.2.0/lib64/ -lblas -lgfortran -lm"
gcc $OPT_FLAGS  mxm.c -o blas.exe $LIB
 for _i in ${_SIZES}
 do
    ./blas.exe $_i $_i $_i > temp.txt
    STAT1=$(echo $?)
    grep "Error" temp.txt 2>/dev/null 1>/dev/null
    STAT2=$(echo $?)
    if [[ $STAT1 -ne 0  ]] && [[ $STAT2 -eq 0  ]]
    then
           echo "Error"
           exit 1
    fi
    _TIME=$(grep "Elapsed:" temp.txt|awk '{print $2}')
    mv temp.txt archive/blas_${_i}_$(date +%Y%m%d_%H%M%S)
    echo "RESULT:blas.exe $_i $_TIME"
 done

echo "MESSAGE: ATLAS $(date) start"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/puneet2/MySoftwares/LIBRARY/LIBATLAS/3.10.3_gcc7.2.0/lib/"
LIB="-L/home/puneet2/MySoftwares/LIBRARY/LIBATLAS/3.10.3_gcc7.2.0/lib/ -lptf77blas -latlas -lgfortran -lpthread -lm"
gcc $OPT_FLAGS mxm.c -o atlas.exe $LIB
 for _i in ${_SIZES}
 do
    ./atlas.exe $_i $_i $_i > temp.txt
    STAT1=$(echo $?)
    grep "Error" temp.txt 2>/dev/null 1>/dev/null
    STAT2=$(echo $?)
    if [[ $STAT1 -ne 0  ]] && [[ $STAT2 -eq 0  ]]
    then
           echo "Error"
           exit 1
    fi
    _TIME=$(grep "Elapsed:" temp.txt|awk '{print $2}')
    mv temp.txt archive/atlas_${_i}_$(date +%Y%m%d_%H%M%S)
    echo "RESULT:atlas $_i $_TIME"
 done

echo "MESSAGE: OBLAS $(date) start"
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/puneet2/MySoftwares/LIBRARY/OPENBLAS/0.2.20_gcc7.2.0/lib/"
LIB="-L/home/puneet2/MySoftwares/LIBRARY/OPENBLAS/0.2.20_gcc7.2.0/lib/ -lopenblas -lgfortran -lm"
gcc $OPT_FLAGS  mxm.c -o oblas.exe $LIB
 for _i in ${_SIZES}
 do
    ./oblas.exe $_i $_i $_i > temp.txt
    STAT1=$(echo $?)
    grep "Error" temp.txt 2>/dev/null 1>/dev/null
    STAT2=$(echo $?)
    if [[ $STAT1 -ne 0  ]] && [[ $STAT2 -eq 0  ]]
    then
           echo "Error"
           exit 1
    fi
    _TIME=$(grep "Elapsed:" temp.txt|awk '{print $2}')
    mv temp.txt archive/oblas_${_i}_$(date +%Y%m%d_%H%M%S)
    echo "RESULT:oblas $_i $_TIME"
 done



echo "MESSAGE: MKL $(date) start"
source /home/puneet2/MySoftwares/COMPILER/MPI/INTELMPI/2019_U2/compilers_and_libraries_2019/linux/mkl/bin/mklvars.sh intel64
LIB="-Wl,--no-as-needed -lmkl_gf_lp64 -Wl,--start-group -lmkl_gnu_thread  -lmkl_core  -Wl,--end-group -fopenmp  -ldl -lpthread -lm"
gcc $OPT_FLAGS  mxm.c -o mkl.exe $LIB
 for _i in ${_SIZES}
 do
    ./mkl.exe $_i $_i $_i  > temp.txt
    STAT1=$(echo $?)
    grep "Error" temp.txt 2>/dev/null 1>/dev/null
    STAT2=$(echo $?)
    if [[ $STAT1 -ne 0  ]] && [[ $STAT2 -eq 0  ]]
    then
           echo "Error"
           exit 1
    fi
    _TIME=$(grep "Elapsed:" temp.txt|awk '{print $2}')
    mv temp.txt archive/mkl_${_i}_$(date +%Y%m%d_%H%M%S)
    echo "RESULT:mkl $_i $_TIME"
    
 done




