# DMA Copy DPU

**Note**: This sample should be run first. It is user responsibility to transfer the two configuration files (descriptor and buffer) to the DPU and provide their path to the DMA Copy DPU sample.

This sample illustrates how to allow memory copy with DMA from the x86 host into the DPU. 

This sample should be run on the host.

### The sample logic includes

1. Locates the DOCA device.
2. Initializes the necessary DOCA core structures.
3. Populates the DOCA memory map with the source buffer.
4. Exports the memory map.
5. Saves the export descriptor and local DMA buffer information into files. These files should be transferred to the DPU before running the DPU sample.
6. Waits until the DPU DMA sample has finished.
7. Destroys all DMA and DOCA core structures.

## References

- `dma_copy_host_sample.c`
- `dma_copy_host_main.c`
- `meson.build`
