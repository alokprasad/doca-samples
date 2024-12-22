# NVIDIA DOCA Samples

##  Prerequisites

The DOCA SDK references (samples and applications) require the use of [meson](https://mesonbuild.com/), with a minimal version requirement of 0.61.2. Since this version is usually more advanced than what is provided by the distribution provider, it is recommended to install meson directly through pip instead of through upstream packages:

    sudo pip3 install meson==0.61.2

## Compilation

To compile all the reference applications:

Move to the applications directory:

    cd applications


Prepare the compilation definitions:

    meson /tmp/build

Compile all the applications:

    ninja -C /tmp/build

For more information, please refer to section "Meson Complains About Missing Dependencies" in the [NVIDIA DOCA Troubleshooting Guide](https://docs.nvidia.com/doca/sdk/NVIDIA+DOCA+Troubleshooting+Guide#src-2957507292_id-.NVIDIADOCATroubleshootingGuidev2.8.0-FailuretoSetHugePages).

## Reference Applications

Reference applications documentation can be found on the [DOCA SDK Applications Page](https://docs.nvidia.com/doca/sdk/index.html#applications)
