# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "C:/Espressif/frameworks/esp-idf-v5.1.2/components/bootloader/subproject"
  "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader"
  "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader-prefix"
  "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader-prefix/tmp"
  "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader-prefix/src/bootloader-stamp"
  "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader-prefix/src"
  "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader-prefix/src/bootloader-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader-prefix/src/bootloader-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "D:/Documents/Github/Thesis_SmartPole/NEMA_espApp/NBIOT-main/build/bootloader-prefix/src/bootloader-stamp${cfgdir}") # cfgdir has leading slash
endif()
