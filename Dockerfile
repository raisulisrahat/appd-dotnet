# Use a base image for ASP.NET Core
FROM mcr.microsoft.com/dotnet/samples:aspnetapp

# docker run --rm --env-file .env -p 8000:80 appdynamicstest:latest

# Set root user for administrative actions
USER root

# Create directory for AppDynamics agent binaries
RUN mkdir -p /opt/appdynamics/dotnet

# Copy agent binaries from the current folder to the image
ADD libappdprofiler.so /opt/appdynamics/dotnet/
ADD libappdprofiler_glibc.so /opt/appdynamics/dotnet/
ADD libappdprofiler_musl.so /opt/appdynamics/dotnet/
ADD AppDynamics.Agent.netstandard.dll /opt/appdynamics/dotnet/

# Copy the AppDynamics configuration file (if using) 
ADD AppDynamicsConfig.json /opt/appdynamics/dotnet/

# Set mandatory settings required to attach the agent to the .NET application
# These values will be fetched from the environment, including the .env file
ENV CORECLR_PROFILER=${CORECLR_PROFILER} \
    CORECLR_ENABLE_PROFILING=${CORECLR_ENABLE_PROFILING} \
    CORECLR_PROFILER_PATH=${CORECLR_PROFILER_PATH} \
    APPDYNAMICS_CONTROLLER_HOST_NAME=${APPDYNAMICS_CONTROLLER_HOST_NAME} \
    APPDYNAMICS_CONTROLLER_PORT=${APPDYNAMICS_CONTROLLER_PORT} \
    APPDYNAMICS_CONTROLLER_SSL_ENABLED=${APPDYNAMICS_CONTROLLER_SSL_ENABLED} \
    APPDYNAMICS_AGENT_ACCOUNT_NAME=${APPDYNAMICS_AGENT_ACCOUNT_NAME} \
    APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY=${APPDYNAMICS_AGENT_ACCOUNT_ACCESS_KEY} \
    APPDYNAMICS_AGENT_APPLICATION_NAME=${APPDYNAMICS_AGENT_APPLICATION_NAME} \
    APPDYNAMICS_AGENT_TIER_NAME=${APPDYNAMICS_AGENT_TIER_NAME} \
    APPDYNAMICS_AGENT_REUSE_NODE_NAME=${APPDYNAMICS_AGENT_REUSE_NODE_NAME} \
    APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX=${APPDYNAMICS_AGENT_REUSE_NODE_NAME_PREFIX}

# Change ownership of directories
RUN chown -R app:app /opt/appdynamics /app

# Switch to a non-root user
USER 1654

# Set the entrypoint for the application
CMD ["/bin/sh"]
ENTRYPOINT ["./aspnetapp"]