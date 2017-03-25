# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""
from tensorflow.examples.tutorials.mnist import input_data
import numpy as np

mnist = input_data.read_data_sets('MNIST_data', one_hot=True)

import tensorflow as tf

with tf.Graph().as_default():
    x  = tf.placeholder(tf.float64, shape=[784, None])
    y_ = tf.placeholder(tf.float64, shape=[10, None])
    
    Rnp = np.eye(783)
    Rnp = np.hstack( ( np.zeros([783,1]), Rnp) )
    last_row = np.zeros([1,784])
    last_row[0][0] = 1
    Rnp = np.vstack((Rnp,last_row))
    Rnp = Rnp.T
    
    # Trying FFT based approach
    c = tf.Variable(tf.random_normal([784, 1], stddev=0.1, dtype=tf.float64))  # first column of the circulant matrix
    b = tf.Variable(tf.constant(0.1, shape=[10, 1], dtype=tf.float64))
    R = tf.constant(Rnp)
    #W = tf.Variable(tf.truncated_normal([10, 784],  stddev=0.1, dtype=tf.float64))
    
    init_W = tf.truncated_normal([10, 784],  stddev=0.1, dtype=tf.float64)
    W = tf.get_variable(name='weights1', initializer=init_W, regularizer=tf.contrib.layers.l1_regularizer(scale=2.9)) 
    
    c_list = [c]
    for i in np.arange(783):
        c_list.append(tf.matmul(R, c_list[-1]))
    
    C = tf.reshape(tf.stack(c_list), [784,784])
    y = tf.nn.softmax(tf.matmul(W, tf.matmul(C, x)) + b)
    
    cross_entropy = tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y)
    loss = cross_entropy + sum(tf.get_collection(tf.GraphKeys.REGULARIZATION_LOSSES))
    
    # Operation defining the optimization procedor
    train_step = tf.train.AdamOptimizer(0.001).minimize(loss)

    W_local = np.zeros([10,784])
    b_local = np.zeros([10,1])
    c_local = np.zeros([784,1])
    C_local = np.zeros([784,784])
    
    with tf.Session() as sess:
        init = tf.global_variables_initializer()
        sess.run(init)
        train_xs, train_ys = mnist.train.next_batch(mnist.train.num_examples)
        
        for i in range(100):    
            batch_xs, batch_ys = mnist.train.next_batch(1000)
            batch_xs_T, batch_ys_T = batch_xs.T,  batch_ys.T
            
            sess.run(train_step, feed_dict={x: batch_xs_T, y_:batch_ys_T})
            if i%10 == 0:
                print c.eval(session=sess)
                asd = W.eval(session=sess)
                print asd
                asd[asd != 0] = 1
                print asd.sum()
        
        W_local = W.eval(session=sess)
        b_local = b.eval(session=sess)
        c_local = c.eval(session=sess)
        C_local = C.eval(session=sess)
    
    
            