// You need to write a simple program to perform computation with 1D array in CPU and GPU, then compare the result.

// includes, system
#include <stdio.h>
#include <assert.h>
#include <cuda_runtime.h>

// Simple utility function to check for CUDA runtime errors
void checkCUDAError(const char *msg);

// Part 3 of 5: implement the kernel
__global__ void calculate1DKernel(int *d_a)
{
  	int idx = threadIdx.x + blockIdx.x * blockDim.x;
	d_a[idx] = 1000 * blockIdx.x + threadIdx.x;
	printf("%u:  \t %u = 1000 * %u + %u\n", idx, d_a[idx] , blockIdx.x, threadIdx.x);
}

////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////
int main( int argc, char** argv) 
{
    // pointer for host memory
    int *h_a;

    // pointer for device memory
    int *d_a;

    // define grid and block size
    int numBlocks = 8;
    int numThreadsPerBlock = 8;

    // Part 1 of 5: allocate host and device memory
    size_t size = numBlocks * numThreadsPerBlock * sizeof(int);
    cudaMallocHost((void **)&h_a, size);
    cudaMalloc((void **)&d_a, size);


    // Part 2 of 5: launch kernel
    cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
    calculate1DKernel<<<numBlocks, numThreadsPerBlock>>>(d_a);    

    // block until the device has completed
    cudaThreadSynchronize();

    // check if kernel execution generated an error
    checkCUDAError("kernel execution");

    // Part 4 of 5: device to host copy
    cudaMemcpy(h_a, d_a, size, cudaMemcpyDeviceToHost);

    // Check for any CUDA errors
    checkCUDAError("cudaMemcpy");

    // Part 5 of 5: verify the data returned to the host is correct
    // i represents blockIdx.x
    for(int i = 0; i < numBlocks; i++){
	// j represents threadIdx.x    
    	for(int j = 0; j < numThreadsPerBlock; j++){
		int idx = i * numThreadsPerBlock + j;
		printf("%u\n", idx);
		assert(h_a[idx] == (1000 * i + j));
	}	
    }

    // free device memory
    cudaFree(d_a);

    // free host memory
    cudaFreeHost(h_a);

    // If the program makes it this far, then the results are correct and
    // there are no run-time errors.  Good work!
    printf("Correct!\n");

    return 0;
}

void checkCUDAError(const char *msg)
{
    cudaError_t err = cudaGetLastError();
    if( cudaSuccess != err) 
    {
        fprintf(stderr, "Cuda error: %s: %s.\n", msg, cudaGetErrorString( err) );
        exit(-1);
    }                         
}
