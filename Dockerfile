FROM mcr.microsoft.com/dotnet/core/samples:aspnetapp

####### Requirements
# Have the following files alongside the Dockerfile:
# * libappdprofiler.so
# * AppDynamics.Agent.netstandard.dll

####### Instructions
# Building image: docker build --rm -t appdynamicstest:latest .
# Running container: docker run --rm -p 8000:80 appdynamicstest:latest
# Open the application using http://localhost:8000/

# Copy agent binaries to the image from current folder
RUN mkdir -p /opt/appdynamics/dotnet
ADD libappdprofiler.so /opt/appdynamics/dotnet/
ADD libappdprofiler_glibc.so /opt/appdynamics/dotnet/
ADD libappdprofiler_musl.so /opt/appdynamics/dotnet/
ADD AppDynamics.Agent.netstandard.dll /opt/appdynamics/dotnet/

# Mandatory settings required to attach the agent to the .NET application
ENV CORECLR_PROFILER={57e1aa68-2229-41aa-9931-a6e93bbc64d8} \
    CORECLR_ENABLE_PROFILING=1 \
    CORECLR_PROFILER_PATH=/opt/appdynamics/dotnet/libappdprofiler.so

# Configure connection to the controller
ENV APPDYNAMICS_CONTROLLER_HOST_NAME=twin202412261749031.saas.appdynamics.com
ENV APPDYNAMICS_CONTROLLER_PORT=443
ENV APPDYNAMICS_CONTROLLER_SSL_ENABLED=true
ENV APPDYNAMICS_AGENT_ACCOUNT_NAME=twin202412261749031
ENV APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=xe47cib4sf7m

# Configure application identity in AppDynamics
ENV APPDYNAMICS_AGENT_APPLICATION_NAME="DotNetApplication"
ENV APPDYNAMICS_AGENT_TIER_NAME="linuxagent"
ENV APPDYNAMICS_AGENT_REUSE_NODE_NAME=true
ENV APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX="Instance"

# It is possible to configure .NET agent using AppDynamicsConfig.json configuration file instead of environment variables
ADD AppDynamicsConfig.json /opt/appdynamics/dotnet/