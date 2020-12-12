# Some sharp corners with docker buildx (especially with qemu)

Have you been trying out Docker's wonderful new buildx with QEMU, but are getting an unexpected "exec user process caused: exec format error" or strange segfaults on ARM? If so, this short and sweet blog post is for you. I want to be clear: I think buildx with qemu is amazing, but there are some sharp edges to keep your eyes out on.


## Cross building sharp edges

First, there are some issues when using cgo (and less often gcc) with QEMU which can sometimes cause segfaults. For me this showed up as "qemu: uncaught target signal 4 (Illegal instruction) - core dumped." Future versions of cgo, gcc or QEMU may work around these issues, but if you find yourself getting errors while building what seems like a trivial example, there's a good chance you've run into this. I've dealt with this problem by using an actual ARM machine for my cross-building.

The other sharp edge is that you can accidentally build a native architecture Docker image labeled as the cross-architecture image, and only find out at runtime. This can happen when the FROM label in your Dockerfile specifies a specific hash. In this case, the easiest thing to do is specify a version tag instead. While it won't fix the problem, using an actual target architecture machine for your building will let you catch this earlier on.


## Solution

Don't despair, though, instead of QEMU, we can use remote contexts. First, get a machine based on your target architecture. If you don't have one handy, some cloud providers offer a variety of architectures. Then, if your machine doesn't already have Docker on it, install Docker. Once you've set up docker on the remote machine, you can create a docker context for it. In my case, I have ssh access (with keys) as the root user to a jetson nano at 192.168.3.125, so I create my context as:

[source, bash]
----
docker context create jetson-nano-ctx --docker host=ssh://root@192.168.3.125
----

Once you have a remote context, you can use it in a "build instance." If you have QEMU locally, as I do, it's important that the remote context is set to be used, since otherwise, we will still try to build with emulation.

[source, bash]
----
docker buildx create --use --name mybuild-combined-builder jetson-nano-ctx 

docker buildx create --append --name mybuild-combined-builder
----

Another random sharp edge that I've run into with Docker buildx is a lot of transient issues seem to go away when I rerun the same command (e.g., "failed to solve: rpc error: code = Unknown desc = failed commit on ref"). I imagine this might be due to a race condition because when I rerun it, Docker buildx uses caching -- but that's just a hunch.


## Conclusion

Another option, especially for GO, is to do your build on your source arch targeting your target arch. There is a Docker blog post [on that approach here.](https://www.docker.com/blog/containerize-your-go-developer-environment-part-1/) Cross-building C libraries is also an option, but more complicated.

Now you're ready to go off to the races and build with your remote machine. Don't worry you can change your build instance back to your local context (use `docker buildx ls` to see your contexts). Happy porting, everyone!

Have you run into additional sharp corners with QEMU & buildx? Let me know and I'll update this post :)
