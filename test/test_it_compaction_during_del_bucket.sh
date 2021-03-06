#!/bin/sh
# -*- tab-width:4;indent-tabs-mode:nil -*-
# ex: ts=4 sw=4 et
#======================================================================
#
# LeoFS / A Test Tool of Deletion Bucket for #725, #150
#
# Copyright (c) 2017 Rakuten, Inc.
#
# This file is provided to you under the Apache License,
# Version 2.0 (the "License"); you may not use this file
# except in compliance with the License.  You may obtain
# a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
#======================================================================

# Prepare this test
./bootstrap.sh start integration-test
sleep 5

# Put objects under 'test'
s3cmd mb s3://test
s3cmd sync deps/leo_commons s3://test/
s3cmd sync deps/leo_redundant_manager s3://test/
s3cmd sync deps/leo_backend_db s3://test/
s3cmd sync deps/leo_object_storage s3://test/

# Check the current state
leofs-adm du storage_0@127.0.0.1
leofs-adm du storage_1@127.0.0.1
leofs-adm du storage_2@127.0.0.1
leofs-adm du storage_3@127.0.0.1

# Remove one bucket
s3cmd rb s3://test
sleep 5

# Execute data-compaction
leofs-adm compact-start storage_0@127.0.0.1 all
leofs-adm compact-start storage_1@127.0.0.1 all
leofs-adm compact-start storage_2@127.0.0.1 all
leofs-adm compact-start storage_3@127.0.0.1 all

watch ./leofs-adm du storage_0@127.0.0.1
