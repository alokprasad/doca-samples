# DMA Local Copy

This sample illustrates how to locally copy memory with DMA from one buffer to another on the DPU.

This sample should be run on the DPU.

### The sample logic includes:

1. Locates the DOCA device.
2. Initializes the necessary DOCA core structures.
3. Populates the DOCA memory map with two relevant buffers.
4. Allocates an element in the DOCA buffer inventory for each buffer.
5. Initializes the DOCA DMA memory copy task object.
6. Submits the DMA task.
7. Handles task completion once it is done.
8. Checks the task result.
9. Destroys all DMA and DOCA core structures.

## References
- `dma_local_copy_sample.c`
- `dma_local_copy_main.c`
- `meson.build`
