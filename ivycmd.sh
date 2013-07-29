#!/bin/bash -e

###########
# 
#  This script installs an deobfuscated minecraft.jar in your local ivy repo.
#   Along with sources, and a retroguard.srg file for reobfuscation.
#  
# Then you should be able to add this dependency to your maven file 
#  <dependency>
#    <groupId>de.ocean-labs.mcp</groupId>
#    <artifactId>minecraft</artifactId>
#    <version>$MC_VERSION</version>
#  </dependency>
#
# USEAGE:
#
# Copy this script and the ivy.xml files to your mcp folder.
# run decompile.sh and recompile.sh
# Then change $MC_VERSION to latest version number.
# Run
#
# AUTHOR Nicholas Marshall <nmarshall23@gmail.com>

MC_VERSION=1.5.2

IVY=ivy.xml

SRC_JAR_NAME=minecraft-source-src.jar

CLEAN_JAR_NAME=minecraft-jar.jar

RETROGUARD_SRG_NAME=retroguard-srg.srg

DECOMPILED_CLIENT_JAR=temp/minecraft_rg.jar

ORG_SRC=temp/client_ro.srg

#####
#
# Setup commands

CREATE_SRC_JAR_CMD= $(command -p jar cf temp/$SRC_JAR_NAME -C src/minecraft . )

RENAME_JAR= $(cp $DECOMPILED_CLIENT_JAR temp/$CLEAN_JAR_NAME)

RENAME_SRG= $(cp $ORG_SRC temp/$RETROGUARD_SRG_NAME)

# Do them

$CREATE_SRC_JAR_CMD; $RENAME_JAR; $RENAME_SRG; 

#####
#
# publish to local ivy 
#
#####
command -p java -jar /usr/share/java/ivy.jar -ivy $IVY -publishpattern "temp/[artifact]-[type].[ext]" -publish local -revision ${MC_VERSION} -overwrite
