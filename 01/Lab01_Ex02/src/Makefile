all: Ex2_Lab1.cu
	/usr/local/cuda-11.2/bin/nvcc -o gpuApp -arch=sm_61 Ex2_Lab1.cu
	# This is to compile with RTX 2080 GPU (C. Capability 7.5)
	# if you are using other GPU, please change the -arch=sm_ to the suitable compute capability.

clean:
	rm -f gpuApp


