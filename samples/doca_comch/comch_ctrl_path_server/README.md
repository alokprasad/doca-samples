# DOCA Comch Control Path Server

**Note**: `doca_comch_ctrl_path_server` must be run on the BlueField Arm side and started before `doca_comch_ctrl_path_client` is started on the host.

This sample sets up a client-server connection between the host and BlueField Arm cores.

The connection is used to pass two messages: the first sent by the client when the connection is established, and the second sent by the server upon receipt of the client's message.

The sample logic includes:

1. Locates the DOCA device.
2. Initializes the core DOCA structures.
3. Initializes and configures client/server contexts.
4. Registers tasks and events for sending/receiving messages and tracking connection changes.
5. Allocates and submits tasks for sending control path messages.
6. Handles event completions for receiving messages.
7. Stops and destroys client/server objects.

## References

- `comch_ctrl_path_server_main.c`
- `comch_ctrl_path_server_sample.c`
