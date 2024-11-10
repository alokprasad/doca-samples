# NVIDIA DOCA Samples
![DOCA software Stack](doca-software.jpg "DOCA Software Stack")

##  Purpose

The DOCA samples repository is an educational resource provided as a guide on how to program on the NVIDIA BlueField networking platform using DOCA API.

The repository consist of 2 parts:
* [Samples](https://github.com/NVIDIA-DOCA/doca-samples-demo/tree/main/samples):  simplistic code snippets that demonstrate the API usage 
* [Applications](https://github.com/NVIDIA-DOCA/doca-samples-demo/tree/main/applications): Advanced samples that implements a logic that might cross different SDK libs.



For instructions regarding the development environment and installation, refer to the [NVIDIA DOCA Developer Guide](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Developer+Guide) and the [NVIDIA DOCA Installation Guide for Linux](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Installation+Guide+for+Linux) respectively.

##  Installation

DOCA applications are installed under /opt/mellanox/doca/applications with each application having its own dedicated folder. Each directory contains the source code and compilation files for the matching application.


##  Prerequisites

The DOCA SDK references (samples and applications) require the use of [meson](https://mesonbuild.com/), with a minimal version requirement of 0.61.2. Since this version is usually more advanced than what is provided by the distribution provider, it is recommended to install meson directly through pip instead of through upstream packages:

    sudo pip3 install meson==0.61.2


## Compilation

As applications are shipped alongside their sources, developers may want to modify some of the code during their development process and then recompile the applications. The files required for the compilation are the following:

    /opt/mellanox/doca/applications/meson.build – main compilation file for a project that contains all the applications
    
    /opt/mellanox/doca/applications/meson_options.txt – configuration file for the compilation process
    
    /opt/mellanox/doca/applications/<application_name>/meson.build – application-specific compilation definitions

To recompile all the reference applications:

Move to the applications directory:

    cd applications


Prepare the compilation definitions:

    meson /tmp/build

Compile all the applications:

    ninja -C /tmp/build

Info
    The generated applications are located under the /tmp/build/ directory, using the following path /tmp/build/<application_name>/doca_<application_name>.

Note
    Compilation against DOCA's SDK relies on environment variables which are automatically defined per user session upon login. For more information, please refer to section "Meson Complains About Missing Dependencies" in the [NVIDIA DOCA Troubleshooting Guide](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Troubleshooting+Guide#src-2957507292_id-.NVIDIADOCATroubleshootingGuidev2.8.0-FailuretoSetHugePages).


## Developer Configurations
When recompiling the reference applications, meson compiles them by default in "debug" mode. Therefore, the binaries would not be optimized for performance as they would include the debug symbol. For comparison, the programs binaries shipped as part of DOCA's installation are compiled in "release" mode. To compile the applications in something other than debug, please consult Meson's configuration guide.

The reference applications also offer developers the ability to use the DOCA log's TRACE level (DOCA_LOG_TRC) on top of the existing DOCA log levels. Enabling the TRACE log level during compilation activates various developer log messages left out of the release compilation. Activating the TRACE log level may be done through enable_trace_log in the meson_options.txt file, or directly from the command line:

[Meson configuration guide](https://mesonbuild.com/)

Prepare the compilation definitions to use the trace log level:

    meson /tmp/build -Denable_trace_log=true


Compile the applications:

    ninja -C /tmp/build


## Reference Applications

Reference applications documentation can be found on the [DOCA SDK Applications Page](https://docs.nvidia.com/doca/sdk/index.html#applications)

