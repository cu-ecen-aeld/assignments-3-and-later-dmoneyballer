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

void* threadfunc(void* thread_param)
{
    struct thread_data* thread_func_args = (struct thread_data *) thread_param;
    printf("thread data now");
    // int wait = thread_func_args->wait_to_obtain_ms;
    printf("struct data %d", thread_func_args->wait_to_obtain_ms);
    // printf("%s", thread_func_args);
    // TODO: wait, obtain mutex, wait, release mutex as described by thread_data structure
    // hint: use a cast like the one below to obtain thread arguments from your parameter
    //struct thread_data* thread_func_args = (struct thread_data *) thread_param;

    return 0;
}

int msleep(long tms)
{
    struct timespec ts;
    int ret;

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

    return ret;
}
bool start_thread_obtaining_mutex(pthread_t *thread, pthread_mutex_t *mutex,int wait_to_obtain_ms, int wait_to_release_ms)
{
    // pthread_t t = thread;
    bool success = false;
    printf("in start thread obtaining mutex\n\n\n");
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
    struct data
    {
        pthread_t *thread;
        pthread_mutex_t *mutex;
        int wait_to_obtain_ms;
        int wait_to_release_ms;
    };
    struct data t1;
    t1.thread =thread;
    t1.mutex=mutex;
    t1.wait_to_obtain_ms= wait_to_obtain_ms;
    t1.wait_to_release_ms=wait_to_release_ms;
    printf("\n working %d\n", t1.wait_to_obtain_ms);
    // thread = malloc(size_t t1);
    int rc = 0;
    // threadfunc(&t1);
    if (rc != 0) {
            printf("mutex lock failed with %d",rc);
        }
    // else {
    //     printf("wohoo it worked");
    // }
    // if (thread == NULL) {
    //     printf("memory allocation failed for thread");
    // }
    // else {
    success = true;
    printf("\nwaiting to obrain lock %d\n", wait_to_obtain_ms);
    usleep(wait_to_obtain_ms);
    printf("\nwaited to obrain lock %d\n", wait_to_obtain_ms);
    rc = pthread_mutex_lock(mutex);
    if (rc != 0) {
        printf("mutex lock failed with %d",rc);
    }
    //     rc = pthread_create(thread,
    //                                 NULL, // Use default attributes
    //                                 threadfunc,
    //                                 "whatup");
    //             if ( rc != 0 ) {
    //                 // printf("pthread_create failed with error %d creating thread %u\n",rc,thread);
    //                 success = false;
    //             }
    //             printf("Started thread");
        rc = pthread_mutex_unlock(mutex);
        if (rc != 0) {
            printf("unlock failed with %d", rc);
        }
        
    //         }
    return success;
    
}

