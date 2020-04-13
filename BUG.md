# BUG 2020-04-01 #1
Problem: Can't get Travis CI to build the very simple version

2020-04-01: npm install -g elm@1.19.1 fails. 1.19.0 version currently works.


# BUG 2020-04-12 #2
Problem: If quantity is illegal number, "sometimes" parser wouldn't read the rest at all.

2020-04-12: Works if the quantity is missing altogether. Still returns rest="" if there is number but it's wrong (e.g. 2.2.4 cups of water)