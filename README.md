# Foam Maps
Flutter based Mobile application for FOAM Maps.<br/></br>
<img src="assets/blumark.png" width="120" height="150"><br/></br>
This application utlizes FOAM contracts and api for POIs and has a second contract on Matic layer2 for reporting opening and closing times. Layer 2 has been chosen to reduce onboarding fiction, lesser amount of gas fee can be easily handled with gas stations. Users can check and report opening and closing times without haveing any foam tokens or eth.
## Features
- Check opening and closing time of a POI.
- Submit opening and closing time of a POI.
- Upvote and downvote opening and closing time of a POI.
- Custodial Wallet Services.
- Custodial service can be used to send meta tx or airdrop some eth to minimize user fiction.
- Use of Layer 2 based Contracts
- Adding New POI.
- If user has zero eth, user still can submit opening and closing times(Thanks to Matic layer 2).
- If user has zero FOAM tokens it shows user a link to guide to get started.
- Users get a notification if they are near any Point of intrest(to keep it battery friendly it checks only if user moves significantly, for testing(111km approx, change of 1 Latitude or 1 Longitude), so create a POI on rinkeby before you initially start app or force stop application and start application again)
- Users can view all POIs , Maps loads dynamically as user moves through map.
- Users can Challenge POIs.
- Users can Access their dashboard and manage FOAM token allowences.
- Users get option to choose not to enter private key stragiht away and is prompted to enter it when it is required.
- Checks to ensure that Users previous transaction is merged.
## Technical Specifications
- Built Using flutter, thus Going Cross platform (Specifcally iOS) is extremely easy.
- Minimal use of native channels thus easier support for different platforms.
- Application Uses rinkeby.
- Opening and closing time contract is on Matic side chain.
## What is left?
- Adding feature to Vote for POI.
- Some bug fixes and exception handling.
- Adding webSockets support dynamic refresh.
##### Note :- You can use `6843DC59D41289CC20E905180F6702621DCB9798B4413C031F8CB6EF0D9FC3E0` it has FOAM tokens on rinkeby.
##### Note :- Please refrain from entering exceptional values, proper exception handling might not be present everywhere.
##### Note :-If your last transaction is merged by making new transaction still gives you pending transaction, hit the transaction button again.
## Screenshots
|<img src="Screenshots/1.jpg" width="400">|<img src="Screenshots/2.jpg" width="400">
|<img src="Screenshots/3.jpg" width="400">|<img src="Screenshots/4.jpg" width="400">
|<img src="Screenshots/5.jpg" width="400">|<img src="Screenshots/6.jpg" width="400">
|<img src="Screenshots/8.jpg" width="400">|<img src="Screenshots/7.jpg" width="400">
|<img src="Screenshots/9.jpg" width="400">|<img src="Screenshots/10.jpg" width="400">
