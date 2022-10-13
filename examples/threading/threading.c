#include "threading.h"
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <time.h>
// Optional: use these functions to add debug or error prints to your application
#define DEBUG_LOG(msg,...)
//#define DEBUG_LOG(msg,...) printf("threading: " msg "\n" , ##__VA_ARGS__)
#define ERROR_LOG(msg,...) printf("threading ERROR: " msg "\n" , ##__VA_ARGS__)

struct data
    {
        pthread_t *thread;
        pthread_mutex_t *mutex;
        int wait_to_obtain_ms;
        int wait_to_release_ms;
        bool success;
    };
    int msleep(long tms)
{
    struct timespec ts;
    int ret;
    printf("in msleep");
    if (tms < 0)
    {
        errno = EINVAL;
        return -1;
    }

    ts.tv_sec = tms / 1000;
    ts.tv_nsec = (tms % 1000) * 1000000;

    do {
        ret = nanosleep(&ts, &ts);
    } while (ret && errno == EINTR);
    printf("\nleaving msleep\n");
    return ret;
}
void* threadfunc(void* thread_param)
{
    // printf("times %d, %d", &thread_param.wait_to_obtain_ms);
    struct thread_data* thread_func_args = (struct thread_data *) thread_param;
    // printf("\nthread data now\n");
    // pthread_detach(pthread_self());
    // int wait = thread_func_args->wait_to_obtain_ms;
    // printf("\nstruct data %d\n\n", thread_func_args->wait_to_obtain_ms);
    thread_func_args->thread_complete_success = true;
    printf("\nstruct data %d\n", thread_func_args->wait_to_release_ms);
    int rc = msleep(thread_func_args->wait_to_obtain_ms);
    printf("\nafter usleep %d\n", rc);
    // usl
    // pthread_mutex_t mutex;
    rc = pthread_mutex_lock(thread_func_args->mutex);
    if (rc != 0) {
        printf("\nmutex lock failed with %d\n",rc);
    } else {
        usleep(thread_func_args->wait_to_release_ms);
        rc = pthread_mutex_unlock(thread_func_args->mutex);
        if (rc != 0) {
        printf("\nmutex lock failed with %d\n",rc);
        }
    }
    // pthread_exit(NULL);	
    // rc = (thread_func_args->wait_to_release_ms);
    // printf("%s", thread_func_args);
    // TODO: wait, obtain mutex, wait, release mutex as described by thread_data structure
    // hint: use a cast like the one below to obtain thread arguments from your parameter
    //struct thread_data* thread_func_args = (struct thread_data *) thread_param;

    return thread_param;
}
bool start_thread_obtaining_mutex(pthread_t *thread, pthread_mutex_t *mutex,int wait_to_obtain_ms, int wait_to_release_ms)
{
    // pthread_t t = thread;
    bool success = false;
    printf("in start thread obtaining mutex\n");
    // int rc = pthread_mutex_lock(mutex);
    /**
     * TODO: allocate memory for thread_data, setup mutex and wait arguments, pass thread_data to created thread
     * using threadfunc() as entry point.
     *
     * return true if successful.
     *
     * See implementation details in threading.h file comment block
     */
    // pthread_t **thread_array;
    struct thread_data* thread_data_params = (struct thread_data*) malloc(sizeof(struct thread_data));
    if (thread_data_params == NULL) {
        printf("not enough mem");
        return ENOMEM;
    }
    struct data t1;
    t1.thread = thread;
    t1.mutex=mutex;
    t1.wait_to_obtain_ms= wait_to_obtain_ms;
    t1.wait_to_release_ms=wait_to_release_ms;
    t1.success = false;
    printf("\n working %d\n", t1.wait_to_obtain_ms);
    // thread = malloc(size_t t1);
    // int rc = 0;
    thread_data_params->wait_to_obtain_ms = wait_to_obtain_ms;
	thread_data_params->wait_to_release_ms = wait_to_release_ms;
	thread_data_params->mutex = mutex;
    int x = pthread_create(thread, NULL, threadfunc, thread_data_params);
    printf("thread started with %d\n", x);
    // void* point = &t1;
    // point = threadfunc(&t1);
    // printf("success %s", point);
    // if (point != 0) {
            // printf("mutex lock failed with %d",rc);
        // }
    // else {
    //     printf("wohoo it worked");
    // }
    // if (thread == NULL) {
    //     printf("memory allocation failed for thread");
    // }
    // else {
    if (x != 0) {
        success = false;
    } else {
    success = true;
    }
    // printf("\nwaiting to obrain lock %d\n", wait_to_obtain_ms);
    // usleep(wait_to_obtain_ms);
    // printf("\nwaited to obrain lock %d\n", wait_to_obtain_ms);
    // // rc = pthread_mutex_lock(mutex);
    // if (rc != 0) {
    //     printf("mutex lock failed with %d",rc);
    // }
    // //     rc = pthread_create(thread,
    // //                                 NULL, // Use default attributes
    // //                                 threadfunc,
    // //                                 "whatup");
    // //             if ( rc != 0 ) {
    // //                 // printf("pthread_create failed with error %d creating thread %u\n",rc,thread);
    // //                 success = false;
    // //             }
    // //             printf("Started thread");
    //     // rc = pthread_mutex_unlock(mutex);
    //     if (rc != 0) {
    //         printf("unlock failed with %d", rc);
    //     }
        
    //         }
    return success;
    
}

