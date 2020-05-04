# BUG 2020-04-01 #1
Problem: Can't get Travis CI to build the very simple version

2020-04-01: npm install -g elm@1.19.1 fails. 1.19.0 version currently works.

2020-04-24: DnDList requires elm 0.19.1. Travis CI breaks again.

2020-04-27: Found a solution on GitHub issues. The version should be latest-0.19.1. Building on Travis CI now.


# BUG 2020-04-12 #2
Problem: If quantity is illegal number, "sometimes" parser wouldn't read the rest at all.

2020-04-12: Works if the quantity is missing altogether. Still returns rest="" if there is number but it's wrong (e.g. 2.2.4 cups of water)

2020-04-15: Solved with the addition backtrackable to facilitate number words functionality


# BUG 2020-04-21 #3
Problem: DnDList messes up the rest of interface.

2020-04-21: DnDList examples only work with elm-ui's Elements, but using Element totally messes up the interaction with the interface. Currently reverted to original viewButton. Will try to go through itemView and then ghostView to remove all Elements.

2020-04-22: Converted UI Elements to Html elements. The interface is working again, but rearranging still doesn't work. 

2020-04-23: Rewrote the code from scratch, copying small chunks over. Problem solved.