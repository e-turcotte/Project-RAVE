Combinational Logic Generation Tool

In a clean linux environment, do the following:
1. Make a new directory and enter the folder. Enter the following commands
    1. mkdir combLogGen
    2. cd combLogGen

2. Import all the following 6 files:
    1. combLogGen.py
    2. node.py
    3. genNode.py
    4. genTree.py
    5. espresso.linux
    6. example_comb.in (or whatever your preferred name is with a file type '.in', [fileName].in)

2.5 What are valid truth tables?
    1. For the most part, any truth table that is valid with the espresso tool is valid with this tool. See: https://users.ece.utexas.edu/~patt/24s.382N/tools/espresso_manual.html
    2. However, the one change is that input/output variable names cannot have their first character be an '*'. Other than that, everything is the same as with espresso.

3. In order to make the espresso.linux file usable, run the follwoing command:
    1. chmod +x espresso.linux

4. Install Python3 to your Linux environment (Specifically for Ubuntu linux). Use the following commands:
    1. sudo apt-get update
    2. sudo apt-get install python3.6
    3. For non-ubuntu users, see here: https://docs.python-guide.org/starting/install3/linux/

5. Exectute the code    
    1. python3 combLogGen.py example_comb.in

6. The results are stored into "example_comb.v", or if you provided a custom file [fileName], it will be in [fileName].v

7. The resulting file can now be added to any project as a functinal model. If you only want the code though, the file can be opened with your choice of file editor and its contents copied.