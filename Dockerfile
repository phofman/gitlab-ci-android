FROM openjdk:8-jdk
LABEL maintainer="CodeTitans"

# setup environment variables
ENV ANDROID_COMPILE_SDK "29"
ENV ANDROID_BUILD_TOOLS "29.0.2"
ENV ANDROID_HOME "/android_sdk"

# install required tools
RUN apt-get --quiet update --yes
RUN apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 build-essential ruby ruby-dev libgmp-dev xxd

# install Android SDK
RUN wget --quiet --output-document=android-sdk.zip https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip && \
    unzip -qq android-sdk.zip -d ${ANDROID_HOME} && \
    rm -v android-sdk.zip
ENV PATH "$PATH:${ANDROID_HOME}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg

# accept all Android licenses
RUN mkdir -p ${ANDROID_HOME}/licenses
RUN printf "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e\n24333f8a63b6825ea9c5514f83c2829b004d1fee" > ${ANDROID_HOME}/licenses/android-sdk-license
RUN printf "84831b9409646a918e30573bab4c9c91346d8abd" > ${ANDROID_HOME}/licenses/android-sdk-preview-license
RUN sdkmanager --update > /dev/null
RUN sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}" > /dev/null
RUN sdkmanager "platform-tools" > /dev/null
RUN sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}" > /dev/null
RUN sdkmanager "extras;android;m2repository" > /dev/null
RUN sdkmanager "extras;google;m2repository" > /dev/null
RUN sdkmanager "extras;google;google_play_services" > /dev/null

# install fastline
RUN ruby -v
RUN which ruby
RUN echo 'source "https://rubygems.org"\ngem "fastlane"\n' > Gemfile
RUN gem install bundle
RUN bundle update
RUN bundle install

