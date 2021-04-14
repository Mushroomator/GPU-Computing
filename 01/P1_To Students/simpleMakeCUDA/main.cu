#include <stdio.h>
#include <stdint.h>
#include <stdlib.h> 

#define SIZE 10

// Convert and mod
__global__ void add_kernel(uint32_t *d_c, uint32_t *d_a, uint32_t *d_b) {   
   uint32_t tid = threadIdx.x;

   d_c[tid] = d_a[tid] + d_b[tid];
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

    add_kernel<<<1, SIZE>>>(d_c, d_a, d_b);
    cudaMemcpy(h_c, d_c, SIZE * sizeof(uint32_t), cudaMemcpyDeviceToHost);  

    printf("Results:\n");
    for(i=0; i<SIZE; i++) printf("%u ", h_c[i]);

    cudaFree(h_a);    cudaFree(h_b);        cudaFree(h_c);
    cudaFree(d_a);    cudaFree(d_b);        cudaFree(d_c);    
    cudaDeviceReset();
    return 0;
}

