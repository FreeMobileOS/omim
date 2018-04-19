#!/bin/bash
# Please run this script to configure the repository after cloning it.

# When configuring with private repository, the following override hierarchy is used:
# - commandline parameters - most specific, always wins.
# - stdin parameters.
# - saved repository - least specific, if present.
# - fallback to opensource mode.

# Stop on the first error.
set -e -u

BASE_PATH=$(cd "$(dirname "$0")"; pwd)

PRIVATE_HEADER="$BASE_PATH/private.h"
DEFAULT_PRIVATE_HEADER="$BASE_PATH/private_default.h"
PRIVATE_CAR_MODEL_COEFS="$BASE_PATH/routing_common/car_model_coefs.hpp"
DEFAULT_PRIVATE_CAR_MODEL_COEFS="$BASE_PATH/routing_common/car_model_coefs_default.hpp"

PRIVATE_PROPERTIES="$BASE_PATH/android/secure.properties"
PRIVATE_FABRIC_PROPERTIES="$BASE_PATH/android/fabric.properties"
PRIVATE_PUSHWOOSH_PROPERTIES="$BASE_PATH/android/pushwoosh.properties"
PRIVATE_NETWORK_CONFIG="$BASE_PATH/android/res/xml/network_security_config.xml"
SAVED_PRIVATE_REPO_FILE="$BASE_PATH/.private_repository_url"
SAVED_PRIVATE_BRANCH_FILE="$BASE_PATH/.private_repository_branch"
TMP_REPO_DIR="$BASE_PATH/.tmp.private.repo"

usage() {
  echo "This tool configures omim with private repository or as an opensource build"
  echo "Usage:"
  echo "  $0 private_repo_url [private_repo_branch]  - to configure with private repository"
  echo "  echo '[private_repo_url] [private_repo_branch]' | $0  - alternate invocation for private repository configuration"
  echo "  $0  - to use with saved repository url and branch or to set up an open source build if nothing is saved"
  echo ""
}

if [ -f "$SAVED_PRIVATE_REPO_FILE" ]; then
  PRIVATE_REPO=`cat "$SAVED_PRIVATE_REPO_FILE"`
  echo "Using stored private repository URL: $PRIVATE_REPO"
else
  echo "If you are developer from MAPS.ME team, please specify a private repository url here."
  echo "If not [yet :)], then just press Enter."
  echo -n "> "
  read PRIVATE_REPO
  if [ -z "$PRIVATE_REPO" ]; then
    echo "Initializing repository with default values in Open-Source mode."
    echo '
#pragma once
#define GOOGLE_WEB_CLIENT_ID ""
#define ALOHALYTICS_URL ""
#define FLURRY_KEY "12345678901234567890"
#define APPSFLYER_KEY ""
#define APPSFLYER_APP_ID_IOS ""
#define MY_TRACKER_KEY ""
#define MY_TARGET_KEY 0
#define MY_TARGET_RB_KEY 0
#define PUSHWOOSH_APPLICATION_ID ""
#define OSM_CONSUMER_KEY ""
#define OSM_CONSUMER_SECRET ""
#define MWM_GEOLOCATION_SERVER ""
#define OSRM_ONLINE_SERVER_URL ""
#define RESOURCES_METASERVER_URL ""
#define METASERVER_URL ""
#define DIFF_LIST_URL ""
#define DEFAULT_URLS_JSON ""
#define AD_PERMISION_SERVER_URL ""
#define AD_PERMISION_CHECK_DURATION 2 * 60 * 60
#define HOCKEY_APP_KEY ""
#define HOCKEY_APP_BETA_KEY ""
#define CRASHLYTICS_IOS_KEY ""
#define BOOKING_AFFILIATE_ID ""
#define BOOKING_KEY ""
#define BOOKING_SECRET ""
#define UBER_SERVER_TOKEN ""
#define UBER_CLIENT_ID ""
#define OPENTABLE_AFFILATE_ID ""
#define TRACKING_REALTIME_HOST ""
#define TRACKING_REALTIME_PORT 0
#define TRACKING_HISTORICAL_HOST ""
#define TRACKING_HISTORICAL_PORT 0
#define TRAFFIC_DATA_BASE_URL ""
#define LOCAL_ADS_SERVER_URL ""
#define LOCAL_ADS_STATISTICS_SERVER_URL ""
#define LOCAL_ADS_COMPANY_PAGE_URL ""
#define VIATOR_API_KEY_EN ""
#define VIATOR_API_KEY_DE ""
#define VIATOR_API_KEY_FR ""
#define VIATOR_API_KEY_ES ""
#define VIATOR_API_KEY_PT ""
#define VIATOR_API_KEY_IT ""
#define VIATOR_API_KEY_NL ""
#define VIATOR_API_KEY_SV ""
#define VIATOR_API_KEY_JA ""
#define VIATOR_ACCOUNT_ID_EN ""
#define VIATOR_ACCOUNT_ID_DE ""
#define VIATOR_ACCOUNT_ID_FR ""
#define VIATOR_ACCOUNT_ID_ES ""
#define VIATOR_ACCOUNT_ID_PT ""
#define VIATOR_ACCOUNT_ID_IT ""
#define VIATOR_ACCOUNT_ID_NL ""
#define VIATOR_ACCOUNT_ID_SV ""
#define VIATOR_ACCOUNT_ID_JA ""
#define YANDEX_CLIENT_ID ""
#define YANDEX_API_KEY ""
#define YANDEX_TRACKING_ID ""
#define LOCALS_API_KEY ""
#define LOCALS_API_URL ""
#define LOCALS_PAGE_URL ""
#define PASSPORT_URL ""
#define PASSPORT_APP_NAME ""
#define UGC_URL ""
#define CLOUD_URL ""
#define MAXIM_CLIENT_ID ""
#define MAXIM_SERVER_TOKEN ""
#define BOOKMARKS_CATALOG_FRONT_URL ""
#define BOOKMARKS_CATALOG_DOWNLOAD_URL ""
#define BOOKMARKS_CATALOG_EDITOR_URL ""
#define DLINK_URL ""
#define GOOGLE_WEB_CLIENT_ID ""
#define RUTAXI_APP_TOKEN ""
#define ADS_REMOVAL_SERVER_ID ""
#define ADS_REMOVAL_VENDOR ""
#define PURCHASE_SERVER_URL ""
#define ADS_REMOVAL_YEARLY_PRODUCT_ID ""
#define ADS_REMOVAL_MONTHLY_PRODUCT_ID ""
#define ADS_REMOVAL_WEEKLY_PRODUCT_ID ""
#define USER_BINDING_REQUEST_URL ""
#define USER_BINDING_PKCS12 ""
#define USER_BINDING_PKCS12_PASSWORD ""
#define BOOKMARKS_VENDOR ""
#define ADS_REMOVAL_NOT_USED_LIST {}

setup_opensource() {
  echo "Initializing repository with default values in Open-Source mode."
  cat "$DEFAULT_PRIVATE_HEADER" > "$PRIVATE_HEADER"
  cat "$DEFAULT_PRIVATE_CAR_MODEL_COEFS" > "$PRIVATE_CAR_MODEL_COEFS"
  echo 'ext {
  spropStoreFile = "../tools/android/debug.keystore"
  spropStorePassword = "12345678"
  spropKeyAlias = "debug"
  spropKeyPassword = "12345678"
}
' > "$PRIVATE_PROPERTIES"

  echo 'apiSecret=0000000000000000000000000000000000000000000000000000000000000000
apiKey=0000000000000000000000000000000000000000
' > "$PRIVATE_FABRIC_PROPERTIES"
  echo 'pwAppId=XXXXX
pwProjectId=A123456789012
' > "$PRIVATE_PUSHWOOSH_PROPERTIES"
  echo '<?xml version="1.0" encoding="utf-8"?>
<network-security-config/>
' > "$PRIVATE_NETWORK_CONFIG"
}

setup_private() {
  echo "Setting up private configuration: repo '$PRIVATE_REPO', branch '$PRIVATE_BRANCH'"
  if git clone --depth 1 --no-single-branch "$PRIVATE_REPO" "$TMP_REPO_DIR"; then
    echo "$PRIVATE_REPO" > "$SAVED_PRIVATE_REPO_FILE"
    echo "$PRIVATE_BRANCH" > "$SAVED_PRIVATE_BRANCH_FILE"
    echo "Saved private repository url '$PRIVATE_REPO' to '$SAVED_PRIVATE_REPO_FILE'"
    echo "Saved private branch '$PRIVATE_BRANCH' to '$SAVED_PRIVATE_BRANCH_FILE'"
    (cd $TMP_REPO_DIR && git checkout $PRIVATE_BRANCH)
    rm -rf "$TMP_REPO_DIR/.git" "$TMP_REPO_DIR/README.md"
    cp -Rv "$TMP_REPO_DIR"/* "$BASE_PATH"
    rm -rf "$TMP_REPO_DIR"
    echo "Private files have been updated."
  fi
}

if [ "${1-}" = "-h" -o "${1-}" = "--help" ]; then
  usage
  exit 1
fi

ARGS_PRIVATE_REPO=${1-}
ARGS_PRIVATE_BRANCH=${2-}

if [ -n "$ARGS_PRIVATE_REPO" ]; then
  PRIVATE_REPO=$ARGS_PRIVATE_REPO
  if [ -n "$ARGS_PRIVATE_BRANCH" ]; then
    PRIVATE_BRANCH=$ARGS_PRIVATE_BRANCH
  else
    PRIVATE_BRANCH=master
  fi
else
  read -t 1 READ_PRIVATE_REPO READ_PRIVATE_BRANCH || true
  if [ -n "${READ_PRIVATE_REPO-}" ]; then
    PRIVATE_REPO=$READ_PRIVATE_REPO
    if [ -n "${READ_PRIVATE_BRANCH-}" ]; then
      PRIVATE_BRANCH=$READ_PRIVATE_BRANCH
    else
      PRIVATE_BRANCH=master
    fi
  elif [ -f "$SAVED_PRIVATE_REPO_FILE" ]; then
    PRIVATE_REPO=`cat "$SAVED_PRIVATE_REPO_FILE"`
    echo "Using stored private repository URL: $PRIVATE_REPO"
    if [ -f "$SAVED_PRIVATE_BRANCH_FILE" ]; then
      PRIVATE_BRANCH=`cat "$SAVED_PRIVATE_BRANCH_FILE"`
      echo "Using stored private branch: $PRIVATE_BRANCH"
    else
      PRIVATE_BRANCH=master
    fi
  else
    PRIVATE_REPO=""
  fi
fi

if [ -n "$PRIVATE_REPO" ]; then
  setup_private
else
  setup_opensource
fi

# TODO: Remove these lines when XCode project is finally generated by CMake. 
if [ ! -d "$BASE_PATH/3party/boost/" ]; then
  echo "You need to have boost submodule present to run bootstrap.sh"
  echo "Try 'git submodule update --init --recursive'"
  exit 1
fi
if [ ! -d "$BASE_PATH/3party/boost/tools" ]; then
  echo "Boost's submodule tools is not present, but required for bootstrap"
  echo "Try 'git submodule update --init --recursive'"
  exit 1
fi
cd $BASE_PATH/3party/boost/
./bootstrap.sh
./b2 headers
cd $BASE_PATH
