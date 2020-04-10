This folder contains the MATLAB script, simulate_robot.m, used to create a real-time simulation of myoelectric control.

The four files sEMG_3_XBee_accel.m, sEMG_4_XBee_accel.m, sEMG_4_XBee.m, and sEMG_4.m, are used to train an LDA classifier.

The function acquire_data is used to read data from the serial port and extract features from the incoming EMG signals. These features are passed into the LDA classifier, and the outputted prediction is used to control the simulated robot.