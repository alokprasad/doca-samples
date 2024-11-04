# NVIDIA DOCA Reference Applications
![DOCA software Stack](doca-software.jpg "DOCA Software Stack")
DOCA reference applications and samples are an educational resource provided as a guide on how to program on the NVIDIA BlueField networking platform using DOCA API.

For instructions regarding the development environment and installation, refer to the [NVIDIA DOCA Developer Guide](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Developer+Guide) and the [NVIDIA DOCA Installation Guide for Linux](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Installation+Guide+for+Linux) respectively.

##  Installation

DOCA applications are installed under /opt/mellanox/doca/applications with each application having its own dedicated folder. Each directory contains the source code and compilation files for the matching application.


##  Prerequisites

The DOCA SDK references (samples and applications) require the use of [meson](https://mesonbuild.com/), with a minimal version requirement of 0.61.2. Since this version is usually more advanced than what is provided by the distribution provider, it is recommended to install meson directly through pip instead of through upstream packages:

    $ sudo pip3 install meson==0.61.2


## Compilation

As applications are shipped alongside their sources, developers may want to modify some of the code during their development process and then recompile the applications. The files required for the compilation are the following:

    /opt/mellanox/doca/applications/meson.build – main compilation file for a project that contains all the applications
    
    /opt/mellanox/doca/applications/meson_options.txt – configuration file for the compilation process
    
    /opt/mellanox/doca/applications/<application_name>/meson.build – application-specific compilation definitions

To recompile all the reference applications:

Move to the applications directory:

    cd /opt/mellanox/doca/applications


Prepare the compilation definitions:

    meson /tmp/build


Compile all the applications:

    ninja -C /tmp/build


Info
    The generated applications are located under the /tmp/build/ directory, using the following path /tmp/build/<application_name>/doca_<application_name>.


Note
    Compilation against DOCA's SDK relies on environment variables which are automatically defined per user session upon login. For more information, please refer to section "Meson Complains About Missing Dependencies" in the [NVIDIA DOCA Troubleshooting Guide](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Troubleshooting+Guide#src-2957507292_id-.NVIDIADOCATroubleshootingGuidev2.8.0-FailuretoSetHugePages).




## Developer Configurations
When recompiling the reference applications, meson compiles them by default in "debug" mode. Therefore, the binaries would not be optimized for performance as they would include the debug symbol. For comparison, the application binaries shipped as part of DOCA's installation are compiled in "release" mode. To compile the applications in something other than debug, please consult Meson's configuration guide.

The reference applications also offer developers the ability to use the DOCA log's TRACE level (DOCA_LOG_TRC) on top of the existing DOCA log levels. Enabling the TRACE log level during compilation activates various developer log messages left out of the release compilation. Activating the TRACE log level may be done through enable_trace_log in the meson_options.txt file, or directly from the command line:

Prepare the compilation definitions to use the trace log level:

    meson /tmp/build -Denable_trace_log=true


Compile the applications:

    ninja -C /tmp/build



## Reference Applications

Reference applications are located in the `applications` directory. Documentation can be found on the [DOCA SDK Applications Page](https://docs.nvidia.com/doca/sdk/index.html#applications)

* `app_shield_agent` - [The DOCA App Shield Agent application](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+App+Shield+Agent+Application+Guide) describes how to build secure process monitoring and is based on the DOCA APSH library, which leverages DPU capabilities such as regular expression (RXP) acceleration engine, hardware-based DMA, and more.
* `dma_copy` - [The DOCA DMA Copy application](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+DMA+Copy+Application+Guide) describes how to transfer files between the DPU and the host. The application is based on the direct memory access (DMA) library, which leverages hardware acceleration for data copy for both local and remote memory.
* `dpa_all_to_all` - The DOCA DPA All-to-all application is a collective operation that allows data to be copied between multiple processes. This application is implemented using DOCA DPA, which leverages the d ata path accelerator (DPA ) inside of the BlueField-3 which offloads the copying of the data to the DPA and leaves the CPU free for other computations.
* `east_west_overlay_encryption` - [The DOCA East-West Overlay Encryption application ](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-East-WestOverlayEncryption)(IPsec) sets up encrypted connections between different devices and works by encrypting IP packets and authenticating the packets' originator. It is based on a strongSwan solution which is an open-source IPsec-based VPN solution.
* `eth_l2_fwd` - [The DOCA Ethernet L2 Forwarding application](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Eth+L2+Forwarding+Application+Guide) is a DOCA Ethernet based application that forwards traffic from a single RX port to a single TX port and vice versa, leveraging DOCA's task/event batching feature for enhanced performance.
* `file_compression` -[ The DOCA File Compression application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-FileCompression) shows how to compress and decompress data using hardware acceleration and to send and receive it. The application is based on the DOCA Compress and DOCA Comm-Channel libraries.
* `file_integrity` - [The DOCA File Integrity application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-FileIntegrity) shows how to send and receive files in a secure way using the hardware Crypto engine. It is based on the DOCA SHA and DOCA Comm-Channel libraries.
* `gpu_packet_processing` - [The DOCA GPU Packet Processing application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-GPUPacketProcessing) shows how to combine DOCA GPUNetIO, DOCA Ethernet, and DOCA Flow to manage ICMP, UDP, TCP and HTTP connections with a GPU-centric approach using CUDA kernels without involving the CPU in the main data path.
* `ipsec_security_gw` - [The DOCA IPsec Gateway application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-IPsecGateway) demonstrates how to insert rules related to IPsec encryption and decryption based on the DOCA Flow and IPsec libraries, which leverage the DPU's hardware capability for secure network communication.
* `nvme_emulation` -
* `pcc` - [The DOCA Programmable Congestion Control application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-ProgrammableCongestionControl), programmable congestion control, is based on the DOCA PCC library and allows users to design and implement their own congestion control algorithm, giving them good flexibility to work out an optimal solution to handle congestion in their clusters.
* `psp_gateway` - [The DOCA PSP Gateway application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-PSPGateway) demonstrates how to exchange keys between application instances and insert rules controlling PSP encryption and decryption using the DOCA Flow library.
* `secure_channel` - [The DOCA Secure Channel application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-SecureChannel) is used to establish a secure, network-independent communication channel between the host and the DPU based on the DOCA Comm Channel library.
* `simple_fwd_vnf` - [The DOCA Simple Forward VNF application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-SimpleForwardVNF) is a forwarding application that takes VXLAN traffic from a single RX port and transmits it on a single TX port. It is based on the DOCA Flow library which leverages DPU capabilities such as building generic execution pipes in the hardware, and more.
* `storage` -
* `switch` - [The DOCA Switch application](https://docs.nvidia.com/doca/sdk/doca+applications/index.html#src-2827901294_id-.DOCAApplicationsv2.8.0-Switch) is used to establish internal switching between representor ports on the DPU. It is based on the DOCA Flow library which leverages DPU capabilities such as building generic execution pipes in the hardware, and more.
* `urom_rdmo` - 
