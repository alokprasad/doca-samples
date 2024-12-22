# DOCA Comch Data Path Client

This sample sets up a client-server connection between the host and BlueField Arm.

The connection is used to create a producer and consumer on both sides and pass a message across the two fastpath connections.

The sample logic includes:

1. Locates the DOCA device.
2. Initializes the core DOCA structures.
3. Initializes and configures client/server contexts.
4. Initializes and configures producer/consumer contexts on top of an established connection.
5. Submits post-receive tasks for population by producers.
6. Submits send tasks from producers to write to consumers.
7. Stops and destroys producer/consumer objects.
8. Stops and destroys client/server objects.

## References

- `/opt/mellanox/doca/samples/doca_comch/comch_data_path_high_speed_client/comch_data_path_high_speed_client_main.c`
- `/opt/mellanox/doca/samples/doca_comch/comch_data_path_high_speedclient/comch_data_path_high_speed_client_sample.c`
