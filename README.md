# GPU-Computing
Practical exercises within GPU Computing course at OTH taught by Wai-Kong Lee from Gachon University, South Korea.

The code is written using CUDA in C/C++ or PTX pseudo assembly. One may need to adjust the architecture targeted in the Makefiles to fit ones CPU. Here usually one of either "sm_75" for RTX 2080 (), or "sm_61" for GTX 1060 (Pascal Arch) is used. 
All code was written on and executed on Ubuntu 20.10 x86_64 using CUDA version 11.2. Adjustments for other platforms may need to be performed. 

## Getting started with CUDA
To get started with CUDA follow the instructions for [Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html) ro [Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html)
All documentation for CUDA by NVIDIA can be found [here](https://docs.nvidia.com/cuda/)