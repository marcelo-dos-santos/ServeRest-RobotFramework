# ServeRest - Robot Framework API Testing  !

This repository was created for the purpose of performing tests for a api called serverest. This test consists of performing test cases for the ServeRest API on the 
https://serverest.dev/#/ website and automating them using Robot Framework and Python/Selenium

Automation was created using Python 3.11.2 with Robot Framework 6.0.2 and Requests Library majoritary.

Links to the tools used and their documentation.

[Python](https://www.python.org)

[Robot Framework](https://robotframework.org):

```
pip install robotframework
```
# Libraries :

[Selenium Library](https://github.com/robotframework/SeleniumLibrary/):
```
pip install robotframework-seleniumlibrary
```
[Requests Library](https://github.com/MarketSquare/robotframework-requests#readme):
```
pip install robotframework-requests
```
[RPAJSON Library](https://robocorp.com/docs/libraries/rpa-framework/rpa-json):
```
pip install rpaframework
```
[Faker Library](https://guykisel.github.io/robotframework-faker/):
```
pip install robotframework-faker
```

>After cloning the repository, open it in your desired text editor, in my case I will be using VScode.

With the repository downloaded and the libraries installed, Now inside VSCode, when opening the terminal we can run our automation using the command:
```
robot -d Results  .\tests\
```
It will start the automation of the test, automatically in the terminal and run the entire process of the automated test flow, and finally after 30 seconds it will finish the process and run the simple report in the terminal itself and on the Results folder that the program created.

![image](https://user-images.githubusercontent.com/108106559/229638591-3aa8ee4e-76a7-4cd5-b6f6-5496adbf3772.png)



It will cause the scripts inside the Resources folder file  to run, running the 4 test scenarios which are:

✔Scenario 1: Cart

✔Scenario 2: Login

✔Scenario 3: Products

✔Scenario 4: Users


The test scenarios will be inside the test folder where they will be referenced and it is also possible to see all the bdds and their steps in full.

![image](https://user-images.githubusercontent.com/108106559/229638954-d06cac97-fc9e-4f71-a940-b9ace81310fb.png)


Also in the Resources folder, we can also see the code referenced in the main test  where we will create the custom commands to be used for each BDD in the main automation sheet.

![image](https://user-images.githubusercontent.com/108106559/229638994-2ab67f45-848a-4333-ab58-c051512bbd94.png)


After finishing the automation process, you will see that the Results folder is populated with prints and XML files, allowing for a report of the automation and prints of when the step is finished.

![image](https://user-images.githubusercontent.com/108106559/229639214-45518331-37da-476c-8d13-997390e61651.png)


Having accomplished all this process, your automation will already be functional and with reports available on the log on Results folder and with the scripts oriented to BDD, step for step. if you have any questions I'll be available! 😁

![image](https://user-images.githubusercontent.com/108106559/229639302-0034599d-c1c6-40eb-bc33-81966b8862c6.png)



