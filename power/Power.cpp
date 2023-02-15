/*
 * Copyright (C) 2020 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Power.h"
#include "libpowerhal.h"

#include <android-base/file.h>
#include <android-base/logging.h>

#include <linux/input.h>

constexpr int kWakeupModeOff = 4;
constexpr int kWakeupModeOn = 5;

namespace aidl {
namespace android {
namespace hardware {
namespace power {
namespace impl {
namespace mediatek {

Power::Power() { libpowerhal_Init(1); }

Power::~Power() { }

static int open_ts_input() {
    int fd = -1;
    DIR *dir = opendir("/dev/input");

    if (dir != NULL) {
        struct dirent *ent;

        while ((ent = readdir(dir)) != NULL) {
            if (ent->d_type == DT_CHR) {
                char absolute_path[PATH_MAX] = {0};
                char name[80] = {0};

                strcpy(absolute_path, "/dev/input/");
                strcat(absolute_path, ent->d_name);

                fd = open(absolute_path, O_RDWR);
                if (ioctl(fd, EVIOCGNAME(sizeof(name) - 1), &name) > 0) {
                    if (strcmp(name, "fts_ts") == 0 ||
                            strcmp(name, "NVTCapacitiveTouchScreen") == 0)
                        break;
                }

                close(fd);
                fd = -1;
            }
        }

        closedir(dir);
    }

    return fd;
}

ndk::ScopedAStatus Power::setMode(Mode type, bool enabled) {
    LOG(VERBOSE) << "Power setMode: " << static_cast<int32_t>(type) << " to: " << enabled;

    switch (type) {
        case Mode::LAUNCH:
        {
            if (this->handle != 0) {
                libpowerhal_LockRel(this->handle);
                this->handle = 0;
            }

            if (enabled)
                this->handle = libpowerhal_CusLockHint(11, 30000, getpid());

            break;
        }
        case Mode::INTERACTIVE:
        {
            if (enabled)
                /* Device now in interactive state,
                   restore all currently held hints. */
                libpowerhal_UserScnRestoreAll();
            else
                /* Device entering non interactive state,
                   disable all hints to save power. */
                libpowerhal_UserScnDisableAll();
            break;
        }
        case Mode::DOUBLE_TAP_TO_WAKE:
        {
            int fd = open_ts_input();
            if (fd == -1)
                return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);

            struct input_event ev = {
                .type = EV_SYN,
                .code = SYN_CONFIG,
                .value = (enabled ? kWakeupModeOn : kWakeupModeOff),
             };
             write(fd, &ev, sizeof(ev));
             close(fd);
             break;
        }
        default:
            break;
    }
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Power::isModeSupported(Mode type, bool* _aidl_return) {
    LOG(INFO) << "Power isModeSupported: " << static_cast<int32_t>(type);
    *_aidl_return = true;

    if (type == Mode::DOUBLE_TAP_TO_WAKE) {
        int fd = open_ts_input();
        if (fd == -1) {
            LOG(WARNING) << "Could not open TS input device"
                         << ", reporting DOUBLE_TAP_TO_WAKE"
                         << " as unsupported.";
            *_aidl_return = false;
        }
        else {
            // Probably not the best idea to
            // leave an open file descriptor.
            close(fd);
        }
    }

    if (type >= Mode::CAMERA_STREAMING_HIGH) {
        *_aidl_return = false;
    }
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Power::setBoost(Boost type, int32_t durationMs) {
    int32_t intType = static_cast<int32_t>(type);

    // Avoid boosts with 0 duration, as those will run indefinitely
    if (type == Boost::INTERACTION && durationMs < 1)
        durationMs = 80;

    LOG(VERBOSE) << "Power setBoost: " << intType
                 << ", duration: " << durationMs;

    libpowerhal_CusLockHint(intType, durationMs, getpid());
    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Power::isBoostSupported(Boost type, bool* _aidl_return) {
    LOG(INFO) << "Power isBoostSupported: " << static_cast<int32_t>(type);
    *_aidl_return = true;

    if (type >= Boost::CAMERA_SHOT) {
        *_aidl_return = false;
    }
    return ndk::ScopedAStatus::ok();
}

}  // namespace mediatek
}  // namespace impl
}  // namespace power
}  // namespace hardware
}  // namespace android
}  // namespace aidl