#!/bin/bash

oc apply ../bootstrap/infra/

oc apply ../bootstrap/configure/

oc apply ../bootstrap/deploy/
