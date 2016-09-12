# CareCloud Appointment API

This is a restful API, that allows a user to show, create, update, or delete an appointment, or to list a number of stored appointments.

Responses are returned as JSON objects. The base url, which will be referenced below, is:
```
https://carecloudappapi.herokuapp.com/
```

### Show Appointment
Individual appointments can be returned by passing in the ID of the appointment. Since the user may not know the ID of the appointment they wish to view, the search feature under the **List Appointments** can help.
To view an individual appointment, add `/appointments/'id'` where 'id' is the appointment's ID:

```
https://carecloudappapi.herokuapp.com/appointments/1
```
will return the appointment listed at id 1.

Your browser will automatically send a GET request, but if you are using Postman, you need to indicate it is a GET request. If you are using curl, it will also assume a GET request, so a simple curl will work fine:
```bash
curl "https://carecloudappapi.herokuapp.com/appointments/1"
```

### List Appointments
While the show, create, update, and delete methods will only work with one appointment, the list method will return however many appointments meet the search criteria.
Valid search criteria are as follows:
* first_name: any string
* last_name: any string
* start_time: (M/D/Y H:M) or (M/D/Y)
* end_time: (M/D/Y H:M) or (M/D/Y)

Start time and end time are not used for searching for a specific start or end time, but rather all appointments that begin or end within the range between them. If no hours/minutes are provided, we assume the beginning of the day for start time and the end of the day for end time. All search criteria are optional. If none are given, all appointments are returned.
If a start time is given without an end time, we search for all appointments after the start time. Conversely, if an end time is given, but no start time, we search for all appointments before the end time.
Example url:
```
https://carecloudappapi.herokuapp.com/appointments?first_name=angelique&last_name=quinones&start_time=11/7/13
```
Since it is also a simple GET request, the curl command is again simple:
```bash
curl "https://carecloudappapi.herokuapp.com/appointments?first_name=angelique&last_name=quinones&start_time=11/7/13"
```
This will fetch all appointments with the given names after and including 11/7/13.

### Create Appointments
Creating an appointment works by sending a POST request to the base url + '/appointments' like so:
```
https://carecloudappapi.herokuapp.com/appointments?first_name=sandi&last_name=metz&start_time=12/10/2018 10:00&end_time=12/10/2018 11:00&comments=OOP is good
```
Appointments are validated in a number of ways to protect from bad data.
New appointments must:
+ have a first name, last name, start time, and end time.
+ occur in the future
+ not overlap an existing appointment
+ have an end time after the start time

Since it will be a POST request, this has to be indicated in the curl command:
```bash
curl -X POST "https://carecloudappapi.herokuapp.com/appointments?first_name=sandi&last_name=metz&start_time=12/10/2018%2010:00&end_time=12/10/2018%2011:00&comments=OOP%20is%20good"
```
You'll notice in the above example, you need to use '%20' instead of spaces. This is because curl doesn't handle spaces as well as your browser.

Alternatively, you can format your POST request using curl's --data option:
```bash
curl --data "first_name=sandi&last_name=metz&start_time=12/10/2018%2010:00&end_time=12/10/2018%2011:00&comments=OOP%20is%20good" "https://carecloudappapi.herokuapp.com/appointments"
```

### Delete an Appointment
The delete methods only works for one appointment at a time because it is highly destructive. Forcing the user to use the list method search to find an appointment's id and then sending the DELETE request separately acts as a sort of built in confirmation to prevent accidental data destruction.

The delete method works the same as the get method, but using a DELETE request instead of a GET request:
```
https://carecloudappapi.herokuapp.com/appointments/1
```

using curl:
```bash
curl -X DELETE "https://carecloudappapi.herokuapp.com/appointments/1"
```

### Update an Appointment
The update method is a bit unique in that it takes two sets of parameters: an id to indicate which appointment to update, and a list of keys and values for the attributes to actually be updated. It is simpler than it sounds. Here's an example url:
```
https://carecloudappapi.herokuapp.com/appointments/1?first_name=doug&last_name=jenkins
```

This would update the first and last names of the appointment at id 1.

The HTTP request for an update is PUT. Here is an example curl command:
```bash
curl -X PUT "https://carecloudappapi.herokuapp.com/appointments/1?first_name=doug&last_name=jenkins"
```

Remember, the id before the query string is for the appointment to be updated and all attributes to be updated are listed after the "?".
