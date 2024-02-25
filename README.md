# mep
MEP (Maps for Environmental Problems):

This app is a mobile application designed to enable citizens to inform local authorities about environmental problems in their territory.The app consists five main components: account creation, report creation, displaying and providing location info for reports, profile page.

Project Description:

MEP, enables users to create reports on environmental issues like air and land pollution. These reports are sent directly to relevant local authorities for action. Users can also track the progress of their reports within the app.
 This app's architecture consists of a backend and frontend component. The backend, powered by Firebase, handles data processing, storage, and user authentication. The frontend, developed using Flutter, provides the user interface for creating reports and allows local authorities to access relevant data. Google Maps API is integrated for report monitoring and location selection. Backend technologies include Firebase for data storage and JavaScript/TypeScript for Cloud Functions. Dart is used for frontend development with Flutter. Tools include Google Maps API for location services, Firebase for data storage, and Flutter SDK for app development. IDEs like Android Studio and Git for version control are utilized for efficient development.

 Firebase is chosen for its robust backend services, including real-time database, user authentication, and cloud functions, which streamline development and scalability. Flutter was selected for frontend development due to its cross-platform capabilities, allowing us to reach Android users with a single codebase and other plaforms for future plans. Google Maps API was integrated to provide location services essential for report monitoring and selection. These platforms offer a seamless and integrated environment, enabling efficient development and deployment of our app across various devices and platforms.

One challenge we encountered was optimizing the performance of the MEP app, particularly when handling large volumes of user-generated data and processing real-time updates. This posed a significant technical challenge due to the need to balance responsiveness with efficient resource utilization.

To address this issue, we employed several strategies:

Database Optimization: We fine-tuned our Firebase database structure and indexing to optimize query performance. This involved carefully designing data models and indexing relevant fields to ensure fast and efficient data retrieval.

Asynchronous Processing: We leveraged asynchronous programming techniques, such as asynchronous tasks and background processing, to offload intensive data processing tasks from the main application thread. By decoupling time-consuming operations from the user interface, we maintained app responsiveness while efficiently utilizing system resources.

Performance Monitoring: We continuously monitored app performance using tools like Firebase Performance Monitoring and integrated analytics. This allowed us to identify performance bottlenecks, track key performance metrics, and iteratively optimize our codebase for improved efficiency.

How to run MEP?:

You can simply run main.dart file in main branch to start Mep.

How to use Mep?:

In Mep we have 2 types of accounts and each account type have its own versions of pages and its own features.
To experience informant(people who send reports to authorities) Users can easily create their own account on Sign up screen.
For Local authority experience we have three pilot municipalities: Avcılar municipality , Küçükçekmece municipality and Kadıköy municipality.

For Avcılar account : email: avcilar@gmail.com ,password: avcilar
For Küçükçekmece account : email: kucukcekmece@gmail.com ,password: avcilar
For Kadıköy account : email: kadikoy@gmail.com ,password: kadikoy 

Sign up page:
It's a regular sign up page, type in required information to sign up a new account(pilot authorities can skip to Sign in page)

Sign in page: 
It's a regular sign in page, type in required information to sign in your account(for authority use the given information above)

Home page: 
Home page includes a map which informants required to select location of their reports. After selecting location informants must press "create a report button" to be navigated to Create a report page where more info about report is requested from informants.For authority accounts home page is the page where municipalities display reports that made by informants. Each report displayed as a marker on map and user taps a marker user will be directed to reports detail page where contains more detail about report and buttons to edit reports.

Create a report page: 
This page only available for informants. Informants fills detail of their report such as : report detail, municipality which will address the pollution(only pilot municipalities can be selected for now), pollution type, report detail, location of the scene(this information took from home screen via map) and add a photo of the scene. After that they complete and create a report by pressing "complete report" button.  If any of there details are not provided app will return a warning about it.When report is successfully created a dialog message pops up and users can navigate to home page by continue button on dialog

Public reports/Reports sent to you page(In authority version of public reports):
 In this page reports sent by informants are displayed with their brief information and image of the scene on a report card . For informants this page includes all of the reports created by other informants. When it comes authority version of the page only reports that the logged in municipality tagged in is displayed.(For example: In Avcılar account there will be only reports which are relevant to Avcılar). If reports card are pressed users will be directed to the detail page of relevant report.

Reports detail page: 
This page contains every information that is typed in create a report page except location and image of the scene. Current status of the report is displayed in this page . There are for states for states of a report: "received", "addressed", "can't solve due to a technical problem" and "resolved". Authority accounts can change status of a report by edit button on authority version of this page.There are other buttons such as refresh,share,location and delete.
Share location enables users to share report scene other people via social media to raise awareness,Delete button deletes the report and finally location button displays pollution scene on google maps app.

Profile page: 
Profile page is the page which user's nickname and e mail is displayed. Users can log out via log out button in this page.








