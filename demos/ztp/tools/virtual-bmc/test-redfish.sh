#!/bin/bash

curl http://localhost:8000/redfish/v1/Systems/

# You can also try to start a VM (change the ID by your VM's ID)
# curl -d '{"ResetType":"On"}' -H "Content-Type: application/json" -X POST http://localhost:8000/redfish/v1/Systems/b6c92bbb-1e87-4972-b17a-12def3948890/Actions/ComputerSystem.Reset

# ...or power it off
#curl -d '{"ResetType":"ForceOff"}' -H "Content-Type: application/json" -X POST http://localhost:8000/redfish/v1/Systems/b6c92bbb-1e87-4972-b17a-12def3948890/Actions/ComputerSystem.Reset