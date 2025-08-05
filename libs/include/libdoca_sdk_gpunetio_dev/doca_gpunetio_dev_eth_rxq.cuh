/*
 * Copyright (c) 2023 NVIDIA CORPORATION & AFFILIATES, ALL RIGHTS RESERVED.
 *
 * This software product is a proprietary product of NVIDIA CORPORATION &
 * AFFILIATES (the "Company") and all right, title, and interest in and to the
 * software product, including all associated intellectual property rights, are
 * and shall remain exclusively with the Company.
 *
 * This software product is governed by the End User License Agreement
 * provided with the software product.
 *
 */

/**
 * @file doca_gpunetio_dev_eth_rxq.cuh
 * @page DOCA_GPUNetIO CUDA Device functions
 * @defgroup DOCA_GPUNETIO_DEV_ETH_RXQ DOCA GPUNetIO Device - Ethernet RXQ
 * @ingroup DOCA_GPUNETIO
 * DOCA GPUNetio device library header to be included in CUDA .cu files.
 * All functions listed here must be called from a GPU CUDA kernel, they won't work from CPU.
 * All functions listed here should be considered as experimental.
 * For more details please refer to the user guide on DOCA devzone.
 *
 * @{
 */
#ifndef DOCA_GPUNETIO_DEVICE_ETH_RXQ_H
#define DOCA_GPUNETIO_DEVICE_ETH_RXQ_H

#include <stdint.h>
#include <doca_gpunetio.h>
#include <doca_error.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Opaque structures representing Ethernet receive object.
 */
struct doca_gpu_eth_rxq;

/*********************************************************************************************************************
 * Ethernet Receive
 *********************************************************************************************************************/

/**
 * @brief Receive packets through the GPU handler of an Ethernet rxq object.
 * This function must be invoked per-block.
 * It's developer responsibility to ensure each block invoking this function operates on a different Ethernet receive
 * object. Function will return upon receiving the indicated maximum number of packets or waiting the indicated number
 * of nanoseconds. If maximum number of packets is 0, it's ignored and only the timeout indicates the exit condition. If
 * timeout is 0, it's ignored and only the maximum number of packets indicates the exit condition. If both are 0, the
 * function will never return.
 *
 * @param [in] eth_rxq
 * GPU handler for Ethernet receive queue.
 * @param [in] max_rx_pkts
 * Max number of packets to receive.
 * @param [in] timeout_ns
 * Max number of ns to wait before returning.
 * If 0, timeout is not considered.
 * @param [out] num_rx_pkts
 * Number of actually received packets.
 * @param [out] doca_gpu_buf_idx
 * Index of the doca_gpu_buf used to receive the very first packet.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_rxq_receive_block(struct doca_gpu_eth_rxq *eth_rxq,
							   uint32_t max_rx_pkts,
							   uint64_t timeout_ns,
							   uint32_t *num_rx_pkts,
							   uint64_t *doca_gpu_buf_idx);

/**
 * @brief Receive packets through the GPU handler of an Ethernet rxq object.
 * This function must be invoked per-warp.
 * It's developer responsibility to ensure each warp invoking this function operates on a different Ethernet receive
 * object. Function will return upon receiving the indicated maximum number of packets or waiting the indicated number
 * of nanoseconds. If timeout is 0, it's ignored and only the maximum number of packets indicates the exit condition.
 *
 * @param [in] eth_rxq
 * GPU handler for Ethernet receive queue.
 * @param [in] max_rx_pkts
 * Max number of packets to receive. Can't be 0.
 * @param [in] timeout_ns
 * Max number of ns to wait before returning.
 * If 0, timeout is not considered.
 * @param [out] num_rx_pkts
 * Number of actually received packets.
 * @param [out] doca_gpu_buf_idx
 * Index of the doca_gpu_buf used to receive the very first packet.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_rxq_receive_warp(struct doca_gpu_eth_rxq *eth_rxq,
							  uint32_t max_rx_pkts,
							  uint64_t timeout_ns,
							  uint32_t *num_rx_pkts,
							  uint64_t *doca_gpu_buf_idx);

/**
 * @brief Receive packets through the GPU handler of an Ethernet rxq object.
 * This function must be invoked per-thread.
 * It's developer responsibility to ensure each thread invoking this function operates on a different Ethernet receive
 * object. Function will return upon receiving the indicated maximum number of packets or waiting the indicated number
 * of nanoseconds. If timeout is 0, it's ignored and only the maximum number of packets indicates the exit condition.
 *
 * @param [in] eth_rxq
 * GPU handler for Ethernet receive queue.
 * @param [in] max_rx_pkts
 * Max number of packets to receive. Can't be 0.
 * @param [in] timeout_ns
 * Max number of ns to wait before returning.
 * If 0, timeout is not considered.
 * @param [out] num_rx_pkts
 * Number of actually received packets.
 * @param [out] doca_gpu_buf_idx
 * Index of the doca_gpu_buf used to receive the very first packet.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_rxq_receive_thread(struct doca_gpu_eth_rxq *eth_rxq,
							    uint32_t max_rx_pkts,
							    uint64_t timeout_ns,
							    uint32_t *num_rx_pkts,
							    uint64_t *doca_gpu_buf_idx);

/**
 * @brief Retrieve a specific doca_gpu_buf pointer from Ethernet receive object.
 *
 * WARNING: to decrease latency and speed-up data path, this function doesn't test if
 * input arguments are valid. It relies on the application for it.
 *
 * @param [in] eth_rxq
 * GPU handler for Ethernet receive queue.
 * @param [in] doca_gpu_buf_idx
 * Index of the doca_gpu_buf to retrieve from the receive queue.
 * @param [out] buf
 * doca_gpu_buf pointer.
 *
 * @return
 *
 */
__device__ void doca_gpu_dev_eth_rxq_get_buf(struct doca_gpu_eth_rxq *eth_rxq,
						     uint64_t doca_gpu_buf_idx,
						     struct doca_gpu_buf **buf);

/**
 * @brief Return packet timestamp associated to a received doca_gpu_buf
 *
 * @param [in] eth_rxq
 * GPU handler for Ethernet receive queue.
 * @param [in] doca_gpu_buf_idx
 * Index of the doca_gpu_buf to retrieve from the receive queue.
 * @param [out] timestamp_ns
 * Received timestamp of the packet in doca_gpu_buf
 *
 * @return
 *
 */
__device__ void doca_gpu_dev_eth_rxq_get_buf_timestamp(const struct doca_gpu_eth_rxq *eth_rxq,
							       uint64_t doca_gpu_buf_idx,
							       uint64_t *timestamp_ns);

/**
 * @brief Return packet bytes associated to a received doca_gpu_buf
 *
 * @param [in] eth_rxq
 * GPU handler for Ethernet receive queue.
 * @param [in] doca_gpu_buf_idx
 * Index of the doca_gpu_buf to retrieve from the receive queue.
 * @param [out] nbytes
 * Received number of bytes of the packet in doca_gpu_buf
 *
 * @return
 *
 */
__device__ void doca_gpu_dev_eth_rxq_get_buf_bytes(const struct doca_gpu_eth_rxq *eth_rxq,
							   uint64_t doca_gpu_buf_idx,
							   uint32_t *nbytes);

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* DOCA_GPUNETIO_DEVICE_ETH_RXQ_H */

/** @} */
