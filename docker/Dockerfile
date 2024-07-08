#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start base image
#----
#---------------------------------------------------------------------------------------------------------------------------

FROM ros:humble-ros-base-jammy as base

## Parameters
ENV WORKSPACE_ROOT=/orbbec

#############################################################################################################################
#####
#####   Install Dependencies
#####
#############################################################################################################################

WORKDIR /

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends ros-dev-tools \
                                               libgflags-dev \
                                               nlohmann-json3-dev \
                                               libusb-1.0-0-dev \
                                               ros-$ROS_DISTRO-tf2-eigen \
                                               ros-$ROS_DISTRO-diagnostic-updater \
                                               ros-$ROS_DISTRO-diagnostic-msgs \
                                               ros-$ROS_DISTRO-image-transport \
                                               ros-$ROS_DISTRO-image-publisher \
                                               ros-$ROS_DISTRO-camera-info-manager \
                                               ros-$ROS_DISTRO-rmw-cyclonedds-cpp \
                                               udev

RUN apt-get clean

#############################################################################################################################
#####
#####   Install Orbbec packages
#####
#############################################################################################################################

WORKDIR ${WORKSPACE_ROOT}/src

RUN git clone https://github.com/orbbec/OrbbecSDK_ROS2.git

RUN rosdep install --from-paths ${WORKSPACE_ROOT}/src -y --ignore-src

WORKDIR ${WORKSPACE_ROOT}

RUN . /opt/ros/humble/setup.sh && colcon build

WORKDIR /

#############################################################################################################################
#####
#####   Remove workspace source and build files that are not relevent to running the system
#####
#############################################################################################################################

RUN rm -rf ${WORKSPACE_ROOT}/src
RUN rm -rf ${WORKSPACE_ROOT}/log
RUN rm -rf ${WORKSPACE_ROOT}/build

RUN apt-get purge --yes libgflags-dev \
                        nlohmann-json3-dev \
                        libusb-1.0-0-dev

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN apt-get clean

#---------------------------------------------------------------------------------------------------------------------------
#----
#----   Start final release image
#----
#---------------------------------------------------------------------------------------------------------------------------


FROM ros:humble-ros-base-jammy as final

## Parameters
ENV WORKSPACE_ROOT=/orbbec
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

WORKDIR /

COPY --from=base / /

RUN wget https://raw.githubusercontent.com/AIResearchLab/astra_legacy_ros/main/astra_camera/scripts/56-orbbec-usb.rules && \
    wget https://raw.githubusercontent.com/AIResearchLab/OrbbecSDK_ROS2/main/orbbec_camera/scripts/99-obsensor-libusb.rules && \
    cp 99-obsensor-libusb.rules /etc/udev/rules.d/99-obsensor-libusb.rules

COPY docker/workspace_entrypoint.sh /workspace_entrypoint.sh

RUN chmod +x /workspace_entrypoint.sh

ENTRYPOINT [ "/workspace_entrypoint.sh" ]

WORKDIR ${WORKSPACE_ROOT}
