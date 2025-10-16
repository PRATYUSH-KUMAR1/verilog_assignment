Design Specification Document
=============================

Introduction
------------

.. image:: images/system.png
    :alt: Traffic Light System
    :width: 400px
    :align: center
Fig:1- Traffic lignt system

The work is divided into three different stages as there are three 'intelligent' behaviour that the system needs to perform.

1. In this we design a normal traffic system that is only for the vehicles.There is no intelligent behaviour.

2. Here we add the first intelligent behaviour in the traffic system which consists the i/p(input) from the pedesterian button in 0's and 1's.

3. In last stage we add the two final behaviour related to the magnetic sensor and upgrade the pedesterian system. 

States
------

Implementation Stages
---------------------

Traffic Light System for Vehicles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/state_dia_1.png
    :alt: Vehicle Traffic Sequence
    :width: 400px
    :align: center
Fig:2- Vehicle Traffic Squence

In the above image, different state for the traffic (only for Vehicels) is shown consedering the following as the states:-

(assuming green=G, yellow=Y, red=R.)

 S0 : the Esat-West{MR-OBH} traffic (both direction) for G=20 sec, Y=4 sec, R=2 sec.   

 S1 : the MR-PMC traffic for G=10 sec, Y=4 sec, R=2 sec.

 S2 : the OBH-PMC traffic for G=10 sec, Y=4 sec, R=2 sec. 

+-----+-----+----+--------+  
| OBH | PMC | MR | Output | 
+=====+=====+====+========+   
|  1  |  0  |  1 |   S0   |
+-----+-----+----+--------+
|  0  |  1  |  1 |   S1   |
+-----+-----+----+--------+
|  1  |  1  |  1 |   S2   |
+-----+-----+----+--------+
The above table show the state and there respective traffic where 1's are for the traffic to operate and 0's for traffic to halt in that state.


+-------+-------+-------+-------+-------+-------+--------+
| OBH(↑)| OBH(→)| OBH(←)| PMC(→)| PMC(↑)| PMC(←)| Output |
+=======+=======+=======+=======+=======+=======+========+
|   1   |   0   |   0   |   0   |   1   |   0   |  S0    |
+-------+-------+-------+-------+-------+-------+--------+
|   0   |   0   |   0   |   1   |   0   |   1   |  S1    |
+-------+-------+-------+-------+-------+-------+--------+
|   0   |   1   |   1   |   0   |   0   |   0   |  S2    |
+-------+-------+-------+-------+-------+-------+--------+
This table is the extended version in which the direction of the traffic flow is shown in different states. the directions are considered taking the prespective of the driver looking at there respective traffic light.




Pedestrian Crossing Sequence
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: images/state_dia_2.png
    :alt: Pedestrian crossing sequence
    :width: 400px
    :align: center
Fig: 3

The sequence for the pedestrian is considered new state S3.

Note:- Once the pedestrian botton is pressed all the vehicle traffic goes red and also did not take any other i/p from the button during the sequence. The pedestrian button i/p only taken when there is the traffc sequence not at all red.

The above state diagram is discribed as :-

 For S0→S1→S2 there is no i/p from the button.

 For S0→S3 or S1→S3 or S2→S3 there is i/p from the button.

where as when S3 compleat the sequence went back to S0 and goes-on.

Assuming button pressed as B(1) and not pressed as B'(0). Shown in the following table

+-----------------+-----+
| i/p from button | o/p |
+=================+=====+
|      0          |  B' |
+-----------------+-----+
|      1          |  B  |
+-----------------+-----+

The following table table shows the relation between the states and the traffic :-

+----+----+----+----+--------+
| S0 | S1 | S2 | S3 |   O/P  |
+====+====+====+====+========+
| 1  | 0  | 0  | 0  | OBH-MR |
+----+----+----+----+--------+
| 0  | 1  | 0  | 0  | MR-PMC |
+----+----+----+----+--------+
| 0  | 0  | 1  | 0  |OBH-PMC |
+----+----+----+----+--------+
| X  | X  | X  | 1  | HUMAN  |
+----+----+----+----+--------+

The last two intelligent behavior that consists the integration of the magneic sensor and its configuration with the above designed system.

In this Fig:3 using as state diagram where the conditions to change the state depends upon the both the i/p of the magnetic sensor as well as the i/p from the pedestrian button. The i/p table from the magnetic sencor is shown below :

+--------------------------+-----+
| I/P from magnetic sensor | o/p |
+==========================+=====+
|        o                 |  V  |
+--------------------------+-----+
|       1                  |  V' |
+--------------------------+-----+

The relation between magnetic sensor and pedestrian button i/p table shown below :-


+------+------+------+
|   V  |  B   |  O/P |
+------+------+------+
|  0   |  X   |  S3  |
+------+------+------+
|  X   |  0   |  S3  |
+------+------+------+


Combining all multiple behaviour in a table that shows current state, inputs, next-state :-

.. table:: State Transition Table (Based on V and B Inputs)


   +----------------+-----+-----+----------------+
   | Current State  |  S  |  B  | Next State (S’)|
   +================+=====+=====+================+
   | S0             |  0  |  X  | S3             |
   +----------------+-----+-----+----------------+
   | S0             |  1  |  0  | S1             |
   +----------------+-----+-----+----------------+
   | S0             |  X  |  1  | S3             |
   +----------------+-----+-----+----------------+
   | S1             |  0  |  X  | S3             |
   +----------------+-----+-----+----------------+
   | S1             |  1  |  0  | S2             |
   +----------------+-----+-----+----------------+
   | S1             |  X  |  1  | S3             |
   +----------------+-----+-----+----------------+
   | S2             |  0  |  X  | S3             |
   +----------------+-----+-----+----------------+
   | S2             |  1  |  0  | S0             |
   +----------------+-----+-----+----------------+
   | S2             |  X  |  1  | S3             |
   +----------------+-----+-----+----------------+

Converting the state into binery encoding:-

.. table:: State Encoding Table

   +--------+-----------+
   | State  | Encoding  |
   +========+===========+
   | S0     | 00        |
   +--------+-----------+
   | S1     | 01        |
   +--------+-----------+
   | S2     | 10        |
   +--------+-----------+
   | S3     | 11        |
   +--------+-----------+

After combining the encding state to the table :-

+----+----+---+---+-----+-----+
| current |  I/P  |   O/P     |
+----+----+---+---+-----+-----+
| S0 | S1 | V | B | S’0 | S’1 |
+====+====+===+===+=====+=====+
| 0  | 0  | 0 | X | 1   | 1   |
+----+----+---+---+-----+-----+
| 0  | 0  | 1 | 0 | 0   | 1   |
+----+----+---+---+-----+-----+
| 0  | 0  | X | 1 | 1   | 1   |
+----+----+---+---+-----+-----+
| 0  | 1  | 0 | X | 1   | 1   |
+----+----+---+---+-----+-----+
| 0  | 1  | 1 | 0 | 1   | 0   |
+----+----+---+---+-----+-----+
| 0  | 1  | X | 1 | 1   | 1   |
+----+----+---+---+-----+-----+
| 1  | 0  | 0 | X | 1   | 1   |
+----+----+---+---+-----+-----+
| 1  | 0  | 1 | 0 | 0   | 0   |
+----+----+---+---+-----+-----+
| 1  | 0  | X | 1 | 1   | 1   |
+----+----+---+---+-----+-----+



Intelligent Behaviour
^^^^^^^^^^^^^^^^^^^^^



Implementation Guide
--------------------

Integration Guide
-----------------
