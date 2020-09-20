# SafeDrive

SafeDrive is an application powered by **Cambridge Mobile Telematics (CMT)**, that allows the user to perform the following:
* Instantly **alert friends and family** in case of a road accident.
* Quickly file and manage **car insurance claims**.
* Get quick access to **medical help** and **legal advice**.
* View **accident report data** in the form of charts, maps and graphics, **enriched and processed** by exploiting **publically available data sources**.

## Frameworks and Services used
* The app is majorly built on the **Flutter** framework, along with **native Android** code.
* SafeDrive uses a **Node** server to handle requests from the application.
* The app uses a **MongoDB** database for storing user and crash report data.
* **OpenGL** has been used to render 3D graphics in the application, to show a vehicle with its damaged components.
* The app uses **Twilio Communication API** to send SMS messages directly.
* The app fetches the maps from **OpenStreetMap** to display mapviews for crash sites and trips.

## Data Sources
Except for data provided by CMT, SafeDrive exploits a range of data sources to present the most useful information to the user.
* **Foursquare Places API** has been used by us to fetch the coordinates of nearest hospitals and vehicle repair shops in case of an accident.
* **CarMD API** has been used by us to estimate the repair cost of an accident based on the damaged vehicle parts and other information provided by the user.
* **AirMap Elevation API** provides data for elevation/altitude. This has been used by us to figure out whether the vehicle was going uphill/downhill during the event.
* **CDC (Centre for Disease Control and Prevention) Data Sets** - We use a range of information from CDC datasets to estimate the "Road Safety Index" of a road.


## Actionability at the time of Accident
SafeDrive promises you the most fluid and actionable accident reporting service. At the time of reporting an accident - 
* The app detects the driver’s current location.
* The driver may type or speak the accident narrative. **Speech recognition** converts it to text.
* The driver may add any number of **photographs and videos** to the report.
* The application **alerts the driver’s friends and family via SMS**.
* SafeDrive provides the driver with **legal advice**.
* The driver can file an **insurance claim** on the spot, given that the driver has uploaded their **Driving License** and **Insurance Policy** on the application.
* The driver can give a digital signature through the application.
* SafeDrive displays the driver a map with the locations and contacts of **nearest hospitals and vehicle repair centres**.