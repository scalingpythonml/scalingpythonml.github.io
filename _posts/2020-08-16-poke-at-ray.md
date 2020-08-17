# A First (Brief) Look at Ray on Kubernetes

	After my motorcycle/Vespa crash last year I took some time away from work. While I was out and trying to practice getting my typing speed back up, I decided to play with Ray, which was pretty cool. Ray comes out of the same[^lab] research lab that created the initial work that became the basis of Apache Spark. Like Spark, the primary authors have now started a company (Anyscale) to grow Ray. Unlike Spark, Ray is a Python first library and does not depend on the Java Virtual Machine (JVM) -- and as someone who's spent way more time than she would like getting the JVM and Python to play together, Ray and it's cohort seem quite promising.

This blog does not represent any of my employers, past or present, and does not represent any of the software projects or foundations I'm involved with. I am one of the developers of Apache Spark [and have some books published on the topic](https://amzn.to/2O6KYYH) that may influence my views, but my views do not represent the project.

## Installing Ray

[Installing Ray](https://docs.ray.io/en/latest/installation.html) was fairly simple, especially due to its lack of JVM dependencies. The one weird thing I encountered while I was installing Ray is the fact that its developers decided to "vendor" Apache Arrow. This was disappointing because I'm interested in using Arrow to get some of these tools to play together and vendored libraries could make it a bit harder. I filed an issue with the ray-project folks, and they quickly responded that they were working on it and then resolved it, so this is something I want to come back to.

## Running Ray on K8s

Since I had not yet built my dedicated test cluster, I decided to give Ray on Kubernetes a shot. The documentation had some room for improvement and I got lost a few times along the way, but on my second try a few days later using the nightly builds I managed to get it running.

## Fault Tolerance

Fault tolerance is especially important in distributed systems like Spark and Ray since as we add more and more computers the chance of one of them failing, or having the network between them fail increases. Different distributed systems take different approaches to fault tolerance, Map-Reduce achieves its fault tolerance by using distributed persistent storage and Spark uses recompute on failures.[^fault_tol]

## Fault Tolerance Limitations

One of the things that really excites me about Ray is its actor model for state. This is really important for some machine learning algorithms, and in Spark, our limitations around handling state (like model weights) have made streaming machine learning algorithms very challenging. One of the big reasons for the limitations around how state is handled is fault tolerance.

To simulate a failure I created an actor and then killed the pod that was running the actor. Ray did not seem to have any automatic recovery here, which could be the right answer. In the future, I want to experiment and see if there is a way to pair Ray with a durable distributed database (or another system) to allow the recovery of actors.


I want to be clear: This is about the same as in Spark. Spark only[^spark_state] allows state to accrue on the driver, and recovery of state on the failure of the driver requires some additional custom code.

## What's next?

The ray-project looks really interesting. Along with Dask and other new Python-first tools we're entering a new era of options for scaling our Python ML code. Seeing Apache Arrow inside of Ray is reassuring since one of my considerations is how we can make our tools work together, and I think Arrow has the potential to serve as a bridge between the different parts of our ecosystem. Up next I'm going to try and set up Dask on my new K8s cluster, and then also re-create this initial experiment on physical hardware instead of Minikube. If you've got thoughts or suggestions for what you'd like to see next, please do send me an e-mail and file an issue against the webpage on GitHub.

You can also follow along with my streams around [distributed computing and open-source on my YouTube channel](https://www.youtube.com/user/holdenkarau). The two videos for this post are [Installing & Poking at Ray](https://www.youtube.com/watch?v=WBNmF-wyAlE) and [Trying the Ray Project on Kubernetes](https://www.youtube.com/watch?v=IUI5okVvgbQ).

If your interested in learning more about Ray and don't want to wait for me, there is a [great collection of tutorials in the project](https://github.com/ray-project/tutorial/pull/173).

[^lab]: Well… same-ish. It's technically a bit more complicated because of the way the professors choose to run their labs, but if you look at the advisors you'll notice a lot of overlap.

[^fault_tol]: Technically it's a bit more complicated, and Spark can use a hybrid of these two models. In some internal places (like it's ALS implementation and other iterative algorithms), Spark uses distributed persistent storage for fault tolerance.

[^spark_state]: Streaming Spark is a bit different