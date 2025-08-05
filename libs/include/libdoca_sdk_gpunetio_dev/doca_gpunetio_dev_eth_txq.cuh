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
 * @file doca_gpunetio_dev_eth_txq.cuh
 * @page DOCA_GPUNetIO CUDA Device functions
 * @defgroup DOCA_GPUNETIO_DEV_ETH_TXQ DOCA GPUNetIO Device - Ethernet TXQ
 * @ingroup DOCA_GPUNETIO
 * DOCA GPUNetio device library header to be included in CUDA .cu files.
 * All functions listed here must be called from a GPU CUDA kernel, they won't work from CPU.
 * All functions listed here should be considered as experimental.
 * For more details please refer to the user guide on DOCA devzone.
 *
 * @{
 */
#ifndef DOCA_GPUNETIO_DEVICE_ETH_TXQ_H
#define DOCA_GPUNETIO_DEVICE_ETH_TXQ_H

#include <stdint.h>
#include <doca_gpunetio.h>
#include <doca_error.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Opaque structures representing Ethernet send object.
 */
struct doca_gpu_eth_txq;

/**
 * Set of properties to enable when pushing a new element in a send queue.
 */
enum doca_gpu_send_flags {
	DOCA_GPU_SEND_FLAG_NONE = 0,	    /**< No specific property must be enabled.
					     *  Best configuration to enhance the performance.
					     */
	DOCA_GPU_SEND_FLAG_NOTIFY = 1 << 0, /**< Return a notification when a send or wait item is actually executed.
					     *  Please note this is requires the DOCA PE on the CPU side to check
					     *  the Eth Txq context (send queue) and cleanup every notification
					     *  (can be set via doca_eth_txq_gpu_event_notify_send_packet_register
					     * function). For this reason, this flag should be set mostly for debugging
					     * purposes as it may affect the overall performance if CPU is not fast
					     * enough to query and cleanup the notifications.
					     */
};

/**
 * Eth Txq wait modes
 */
 enum doca_gpu_dev_eth_txq_wait_flags {
	DOCA_GPU_ETH_TXQ_WAIT_FLAG_NB = 0, /**< Non-Blocking mode: the wait completion function
					      * doca_gpu_dev_eth_txq_wait_completion checks if the input number of send operations
					      * completed (data has been sent) and exit from the function. If
					      * nothing has been sent, the function doesn't block the execution.
					      */
	DOCA_GPU_ETH_TXQ_WAIT_FLAG_B = 1,  /**< Blocking mode: the wait completion function
					      * doca_gpu_dev_eth_txq_wait_completion blocks the execution waiting for all the
					      * input send operations to be completed.
					      */
};

/*********************************************************************************************************************
 * Utility functions
 *********************************************************************************************************************/

/**
 * @brief Similarly to doca_eth_txq_calculate_timestamp() it returns the wait on time
 * value to use with doca_gpu_dev_eth_txq_wait_time_enqueue_* functions.
 * It works only if wait on time support on the txq is DOCA_ETH_WAIT_ON_TIME_TYPE_NATIVE.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 * @param [in] timestamp_ns
 * UTC timestampt to convert
 * @param [out] wait_on_time_value
 * Wait on time value
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_NOT_SUPPORTED - wait on time support is not NATIVE
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_calculate_timestamp(const struct doca_gpu_eth_txq *eth_txq,
								 const uint64_t timestamp_ns,
								 uint64_t *wait_on_time_value);

/*********************************************************************************************************************
 * Ethernet Send -- Strong pattern
 *********************************************************************************************************************/

/**
 * @brief Enqueue a new packet on the send queue using the GPU handler of an Ethernet txq object.
 * This function must be invoked per-thread.
 * Each invocation of this function will reserve the next descriptor
 * of the send queue for the doca_gpu_buf that must be sent.
 * With this "strong" version, developer doesn't have to worry about send queue management.
 * Multiple threads can invoke this function on the same queue to enqueue multiple packets simultaneously.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 * @param [in] buf_ptr
 * doca_gpu_buf to send
 * @param [in] nbytes
 * Number of bytes to send from the doca_gpu_buf
 * @param [in] flags_bitmask
 * Combination of flags from the enum doca_gpu_send_flags.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_send_enqueue_strong(struct doca_gpu_eth_txq *eth_txq,
								 const struct doca_gpu_buf *buf_ptr,
								 const uint32_t nbytes,
								 const uint32_t flags_bitmask);

/**
 * @brief Enqueue a time barrier in the send queue: packets enqueue after this point will be sent by the
 * network card in the future at the specified timestamp.
 * This function must be invoked per-thread.
 * With this "strong" version, developer doesn't have to worry about send queue management.
 * Multiple threads can invoke this function on the same queue to enqueue barriers simultaneously.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 * @param [in] wait_on_time_value
 * Wait on time value returned by doca_gpu_dev_eth_txq_calculate_timestamp or doca_eth_txq_calculate_timestamp
 * @param [in] flags_bitmask
 * Combination of flags from the enum doca_gpu_send_flags.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_wait_time_enqueue_strong(struct doca_gpu_eth_txq *eth_txq,
								      const uint64_t wait_on_time_value,
								      const uint32_t flags_bitmask);

/**
 * @brief Create a commit point in the send queue.
 * Must be invoked after enqueuing multiple items in the send queue with doca_gpu_dev_eth_txq_*_enqueue_strong()
 * functions. After this function the doca_gpu_dev_eth_txq_push should be invoked. It's discouraged but not prohibited
 * to invoke more doca_gpu_dev_eth_txq_send_enqueue_strong() and then another doca_gpu_dev_eth_txq_commit_strong() right
 * after. Only one thread can invoke this function after a sequence of doca_gpu_dev_eth_txq_send_enqueue_strong()
 * invoked by multiple threads.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_commit_strong(struct doca_gpu_eth_txq *eth_txq);

/*********************************************************************************************************************
 * Ethernet Send -- Weak pattern
 *********************************************************************************************************************/

/**
 * @brief Enqueue a time barrier in the send queue: packets enqueue after this point will be sent by the
 * network card in the future at the specified timestamp.
 * This function must be invoked per-thread.
 * Reserved for advanced developers as it allows to specify at which position the barrier should be placed in the send
 * queue. It's developer responsibility to enqueue barrier in sequential position wrt other doca_gpu_buf or barriers
 * avoiding empty elements in the queue. Multiple threads can invoke this function on the same queue to enqueue barriers
 * simultaneously in different positions.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 * @param [in] wait_on_time_value
 * Wait on time value returned by doca_gpu_dev_eth_txq_calculate_timestamp or doca_eth_txq_calculate_timestamp
 * @param [in] position
 * Position (index) of the barrier in the send queue.
 * @param [in] flags_bitmask
 * Combination of flags from the enum doca_gpu_send_flags.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_wait_time_enqueue_weak(struct doca_gpu_eth_txq *eth_txq,
								    const uint64_t wait_on_time_value,
								    const uint32_t position,
								    const uint32_t flags_bitmask);

/**
 * @brief Enqueue a new packets on the send queue using the GPU handler of an Ethernet txq object.
 * This function must be invoked per-thread.
 * Reserved for advanced developers as it allows to specify at which position the doca_gpu_buf should be placed in the
 * send queue. It's developer responsibility to enqueue the doca_gpu_buf in sequential position with respect to other
 * doca_gpu_buf or barriers enqueued by other CUDA threads in the queue. Multiple CUDA threads can invoke this function
 * on the same queue to enqueue doca_gpu_buf simultaneously in different positions.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 * @param [in] buf_ptr
 * doca_gpu_buf to send
 * @param [in] nbytes
 * Number of bytes to send from the doca_gpu_buf
 * @param [in] position
 * Position (index) of the doca_gpu_buf in the send queue.
 * @param [in] flags_bitmask
 * Combination of flags from the enum doca_gpu_send_flags.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_send_enqueue_weak(const struct doca_gpu_eth_txq *eth_txq,
							       const struct doca_gpu_buf *buf_ptr,
							       const uint32_t nbytes,
							       const uint32_t position,
							       const uint32_t flags_bitmask);

/**
 * @brief Create a commit point in the send queue.
 * Must be invoked after enqueuing multiple items in the send queue with doca_gpu_dev_eth_txq_*_enqueue_weak()
 * functions. After this function the doca_gpu_dev_eth_txq_push should be invoked. It's discouraged but not prohibited
 * to invoke more doca_gpu_dev_eth_txq_send_enqueue_weak() and then another doca_gpu_dev_eth_txq_commit_weak() right
 * after. Only one thread can invoke this function after a sequence of doca_gpu_dev_eth_txq_send_enqueue_weak() invoked
 * by multiple threads.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 * @param [in] elements
 * Number of elements pushed in the queue since last commit.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_commit_weak(struct doca_gpu_eth_txq *eth_txq, const uint32_t elements);

/*********************************************************************************************************************
 * Ethernet Send -- Flush queue
 *********************************************************************************************************************/

/**
 * @brief Flush the queue sending packets enqueued.
 * Must be invoked right after doca_gpu_dev_eth_txq_commit_strong() or doca_gpu_dev_eth_txq_commit_weak().
 * Only one thread can invoke this function.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_push(struct doca_gpu_eth_txq *eth_txq);

/**
 * @brief Get latest occupied position in the send queue and max position index
 * that can be used in the queue. Highly recommended to use in case of weak send pattern.
 * Please ensure to query this function before starting to enqueue packets in weak mode.
 * The library updated the curr_position value after every doca_gpu_dev_eth_txq_commit_*()
 * The position index should be always masked with mask_max_position value.
 *
 * @param [in] eth_txq
 * GPU handler for Ethernet send queue.
 * @param [in] curr_position
 * Next available packet position in the queue.
 * @param [in] mask_max_position
 * Mask of the max index position usable in this queue.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 *
 */
__device__ doca_error_t doca_gpu_dev_eth_txq_get_info(struct doca_gpu_eth_txq *eth_txq,
						      uint32_t *curr_position,
						      uint32_t *mask_max_position);


/**
 * @brief Wait for the completion an input number of Eth Txq send operations in blocking or non-blocking mode.
 *
 * Only one CUDA thread can invoke this function after doca_gpu_dev_rdma_commit().
 *
 * @param[in] eth_txq - Eth Txq GPU handle
 * @param[in] num_sends - Number of sends operations to wait.
 * @param[in] wait_mode - Mode of waiting.
 * @param[out] num_completed - Number of sends operations completed.
 *
 * @return
 * DOCA_SUCCESS - in case of success.
 * doca_error code - in case of failure:
 * - DOCA_ERROR_INVALID_VALUE - arguments are invalid.
 */
 __device__ doca_error_t doca_gpu_dev_eth_txq_wait_completion(struct doca_gpu_eth_txq *eth_txq, uint32_t num_sends, enum doca_gpu_dev_eth_txq_wait_flags wait_mode, uint32_t *num_completed);
#ifdef __cplusplus
} /* extern "C" */
#endif

#endif /* DOCA_GPUNETIO_DEVICE_ETH_TXQ_H */

/** @} */
