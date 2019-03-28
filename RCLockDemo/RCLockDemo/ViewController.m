//
//  ViewController.m
//  RCLockDemo
//
//  Created by RongCheng on 2019/3/18.
//  Copyright © 2019年 RongCheng. All rights reserved.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread/pthread.h>
@interface ViewController ()
@property (nonatomic,copy)NSString *target;
@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    [self lockTest9];
    
}

- (void)lockTest0{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block OSSpinLock lock = OS_SPINLOCK_INIT;
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            OSSpinLockLock(&lock);
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            OSSpinLockUnlock(&lock);
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"OSSpinLock:           %8.2f ms",(end - begin) * 1000);
    });

}

- (void)lockTest1{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL,  DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block os_unfair_lock unfair_lock = OS_UNFAIR_LOCK_INIT;
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            os_unfair_lock_lock(&unfair_lock);
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            os_unfair_lock_unlock(&unfair_lock);
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"os_unfair_lock:           %8.2f ms",(end - begin) * 1000);
    });
    
}

- (void)lockTest2{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    dispatch_semaphore_t lock =  dispatch_semaphore_create(1);
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            dispatch_semaphore_signal(lock);
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"dispatch_semaphore:           %8.2f ms",(end - begin) * 1000);
    });
}

- (void)lockTest3{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block pthread_mutex_t lock;
    pthread_mutex_init(&lock, NULL);
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            pthread_mutex_lock(&lock);
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            pthread_mutex_unlock(&lock);
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"pthread_mutex:           %8.2f ms",(end - begin) * 1000);
    });
    
}

- (void)lockTest4{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block NSLock *lock = [[NSLock alloc]init];
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            [lock lock];
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            [lock unlock];
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"NSLock:           %8.2f ms",(end - begin) * 1000);
    });
}

- (void)lockTest5{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block NSCondition *condition= [[NSCondition alloc]init];
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            [condition lock];
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            [condition unlock];
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"NSCondition:           %8.2f ms",(end - begin) * 1000);
    });
}

- (void)lockTest6{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block NSConditionLock *condition = [[NSConditionLock alloc] initWithCondition:1];
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            [condition lock];
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            [condition unlock];
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"NSConditionLock:           %8.2f ms",(end - begin) * 1000);
    });
}

- (void)lockTest7{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block NSRecursiveLock *lock = [[NSRecursiveLock alloc]init];
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            [lock lock];
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            [lock unlock];
        });
        
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"NSRecursiveLock:           %8.2f ms",(end - begin) * 1000);
    });
}

- (void)lockTest8{
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    __block pthread_mutex_t lock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init(&lock, &attr);
    pthread_mutexattr_destroy(&attr);
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            pthread_mutex_lock(&lock);;
            self.target = [NSString stringWithFormat:@"target--%ld",i];
            pthread_mutex_unlock(&lock);
        });
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"pthread_mutex(recursive):           %8.2f ms",(end - begin) * 1000);
    });
}

- (void)lockTest9{
    
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    begin = CACurrentMediaTime();
    NSObject *lock = [NSObject new];
    for(NSInteger i = 0;i < count; i++){
        dispatch_group_async(group, queue, ^{
            @synchronized (lock) {
                self.target = [NSString stringWithFormat:@"target--%ld",i];
            }
        });
    }
    dispatch_group_notify(group, queue, ^{
        end = CACurrentMediaTime();
        NSLog(@"@synchronized:           %8.2f ms",(end - begin) * 1000);
    });
}



- (void)lockTest{
    
    double begin;
    __block double end;
    NSInteger count = 1000;
    
    dispatch_queue_t queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    
    
  
    {
        begin = CACurrentMediaTime();
        __block OSSpinLock lock = OS_SPINLOCK_INIT;
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                OSSpinLockLock(&lock);
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                OSSpinLockUnlock(&lock);
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"OSSpinLock:           %8.2f ms",(end - begin) * 1000);
        });
    }
   
  
    
    {
        begin = CACurrentMediaTime();
        __block os_unfair_lock unfair_lock = OS_UNFAIR_LOCK_INIT;
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                os_unfair_lock_lock(&unfair_lock);
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                os_unfair_lock_unlock(&unfair_lock);
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"os_unfair_lock:           %8.2f ms",(end - begin) * 1000);
        });
        
    }
    
    
    {
        begin = CACurrentMediaTime();
        dispatch_semaphore_t lock =  dispatch_semaphore_create(1);
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                dispatch_semaphore_signal(lock);
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"dispatch_semaphore:           %8.2f ms",(end - begin) * 1000);
        });
        
    }
    
    
    {
        begin = CACurrentMediaTime();
        __block pthread_mutex_t lock;
        pthread_mutex_init(&lock, NULL);
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                pthread_mutex_lock(&lock);
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                pthread_mutex_unlock(&lock);
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"pthread_mutex:           %8.2f ms",(end - begin) * 1000);
        });
        
        
    }
    
    
    {
        begin = CACurrentMediaTime();
        __block NSLock *lock = [[NSLock alloc]init];
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                [lock lock];
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                [lock unlock];
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"NSLock:           %8.2f ms",(end - begin) * 1000);
        });
        
        
    }
    
    {
        begin = CACurrentMediaTime();
        __block NSCondition *condition= [[NSCondition alloc]init];
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                [condition lock];
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                [condition unlock];
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"NSCondition:           %8.2f ms",(end - begin) * 1000);
        });
        
        
    }
    
    
    {
        begin = CACurrentMediaTime();
        __block NSConditionLock *condition = [[NSConditionLock alloc] initWithCondition:1];
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                [condition lock];
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                [condition unlock];
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"NSConditionLock:           %8.2f ms",(end - begin) * 1000);
        });
    }
    
    
    {
        begin = CACurrentMediaTime();
        __block NSRecursiveLock *lock = [[NSRecursiveLock alloc]init];
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                [lock lock];
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                [lock unlock];
            });
            
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"NSRecursiveLock:           %8.2f ms",(end - begin) * 1000);
        });
    }
    
    
    {
        begin = CACurrentMediaTime();
        __block pthread_mutex_t lock;
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&lock, &attr);
        pthread_mutexattr_destroy(&attr);
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                pthread_mutex_lock(&lock);;
                self.target = [NSString stringWithFormat:@"target--%ld",i];
                pthread_mutex_unlock(&lock);
            });
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"pthread_mutex(recursive):           %8.2f ms",(end - begin) * 1000);
        });
    }
    
    
    
    {
        begin = CACurrentMediaTime();
        NSObject *lock = [NSObject new];
        for(NSInteger i = 0;i < count; i++){
            dispatch_group_async(group, queue, ^{
                @synchronized (lock) {
                    self.target = [NSString stringWithFormat:@"target--%ld",i];
                }
            });
        }
        dispatch_group_notify(group, queue, ^{
            end = CACurrentMediaTime();
            NSLog(@"@synchronized:           %8.2f ms",(end - begin) * 1000);
        });
    }
    
}

@end
