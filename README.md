Docker Image that provides the Collabtive Groupware in Version 2.0 (http://collabtive.o-dyn.de).

Login is (admin/admin).

```
docker run --privileged -d -v /dev/urandom:/dev/urandom \
           -v /dev/random:/dev/random -v /dev/null:/dev/null \
           -p 8181:80 qnib/collabtive
```

#### Common Issue [Github Issue about it](https://github.com/ChristianKniep/docker-collabtive/issues/3)

If you got the following error message while starting 

```
Unable to find image ' -v' locally
```

please check the linebreaks within your command. This just means that the bash discovered the ```-v``` as an argument and not an option.
The docker CLI treats the first argument as the docker image to be started.


The DB-Passwords are randomized within the Image, who cares about them, right?
Missing piece is the backup script. [Github Issue about that][1]

Please open issues instead of commenting here... :)
[Click to create new Issue][2]


  [1]: https://github.com/ChristianKniep/docker-collabtive/issues/1
  [2]: https://github.com/ChristianKniep/docker-collabtive/issues/new
