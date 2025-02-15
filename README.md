# Welcome to AppDynamics .NET Agent for Linux

Make sure to always download the latest agent version.
For details and documentation, visit: https://docs.appdynamics.com/

## Setup

- Extract archive to some folder
- Rename AppDynamicsConfig.json.template to AppDynamicsConfig.json and update values in the file or set environment variables with controller details
- Set these environment variables to enable the agent (use libappdprofiler.so for x64 or libappdprofiler_arm64.so for arm64 as profiler in full_path_to_profiler):

```sh
CORECLR_PROFILER={57e1aa68-2229-41aa-9931-a6e93bbc64d8}
CORECLR_ENABLE_PROFILING=1
CORECLR_PROFILER_PATH=<full_path_to_profiler>
```

- For Alpine distribution, set additional environment variable:
```sh
LD_LIBRARY_PATH=<full_path_to_agent_folder>
```

## Sample Dockerfile for CentOS/Ubuntu/Debian/RHEL and Alpine

```sh
# Copy agent binaries to the image from current folder
RUN mkdir -p /opt/appdynamics/dotnet
ADD libappdprofiler.so /opt/appdynamics/dotnet/
ADD libappdprofiler_musl.so /opt/appdynamics/dotnet/
ADD libappdprofiler_glibc.so /opt/appdynamics/dotnet/
ADD AppDynamics.Agent.netstandard.dll /opt/appdynamics/dotnet/

# Mandatory settings required to attach the agent to the .NET application
ENV CORECLR_PROFILER={57e1aa68-2229-41aa-9931-a6e93bbc64d8} \
    CORECLR_ENABLE_PROFILING=1 \
    CORECLR_PROFILER_PATH=/opt/appdynamics/dotnet/libappdprofiler.so

# For Alpine, you must also set the following Environment Variable
# ENV LD_LIBRARY_PATH=/opt/appdynamics/dotnet

# Configure connection to the controller
ENV APPDYNAMICS_CONTROLLER_HOST_NAME=controller.saas.appdynamics.com
ENV APPDYNAMICS_CONTROLLER_PORT=443
ENV APPDYNAMICS_CONTROLLER_SSL_ENABLED=true
ENV APPDYNAMICS_AGENT_ACCOUNT_NAME=
ENV APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=

# Configure application identity in AppDynamics
ENV APPDYNAMICS_AGENT_APPLICATION_NAME=
ENV APPDYNAMICS_AGENT_TIER_NAME=
ENV APPDYNAMICS_AGENT_NODE_NAME=
```

For arm64 docker, use libappdprofiler_arm64.so, libappdprofiler_musl_arm64.so and libappdprofiler_glibc_arm64.so instead of libappdprofiler.so, libappdprofiler_musl.so and libappdprofiler_glibc.so