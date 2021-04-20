#include <stdio.h>
#include <stdint.h>
#include <stdlib.h> 

// CUDA runtime
#include <cuda_runtime.h>



#define SIZE 100000000
#define THREADS_PER_BLOCK 1024

// Convert and mod
__global__ void add_kernel(uint32_t *d_c, uint32_t *d_a, uint32_t *d_b) {   
//  compute index = thread index in a block + block index * number of threads per block
	uint32_t idx = threadIdx.x + blockIdx.x * blockDim.x;
	// if SIZE mod THREADS PER BLOCK != 0 --> some index will not be available as one more block is used
	if(idx <= SIZE) d_c[idx] = d_a[idx] + d_b[idx];
}

int main(int argc, char* argv[]) {
    int i;
    uint32_t *h_a, *h_b, *h_c;  // host pointer
    uint32_t *d_a, *d_b, *d_c;  // device pointer

    cudaMallocHost((void**)&h_a, SIZE * sizeof(uint32_t));   
    cudaMallocHost((void**)&h_b, SIZE * sizeof(uint32_t));   
    cudaMallocHost((void**)&h_c, SIZE * sizeof(uint32_t));   
    cudaMalloc((void**)&d_a, SIZE * sizeof(uint32_t));   
    cudaMalloc((void**)&d_b, SIZE * sizeof(uint32_t));   
    cudaMalloc((void**)&d_c, SIZE * sizeof(uint32_t));   

    for(i=0; i<SIZE; i++) 
    {
      h_a[i] = i; 
      h_b[i] = i;
    }

    cudaMemcpy(d_a, h_a, SIZE * sizeof(uint32_t), cudaMemcpyHostToDevice);  
    cudaMemcpy(d_b, h_b, SIZE * sizeof(uint32_t), cudaMemcpyHostToDevice);     

//  <<< [Number of blocks], [Number of threads per block] >>>
    add_kernel<<<(SIZE / THREADS_PER_BLOCK) + 1, THREADS_PER_BLOCK>>>(d_c, d_a, d_b);
    cudaMemcpy(h_c, d_c, SIZE * sizeof(uint32_t), cudaMemcpyDeviceToHost);  

    printf("\n----------\nResults CPU:\n");
    for(i=0; i<SIZE; i++) printf("%u: %u ",i , h_c[i]);

    cudaFree(h_a);    cudaFree(h_b);        cudaFree(h_c);
    cudaFree(d_a);    cudaFree(d_b);        cudaFree(d_c);    
    cudaDeviceReset();
    return 0;
}

