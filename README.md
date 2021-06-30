#### Yet another sample resource
##### Allows for simple creation of threads in a single resource which we can then use to trigger events in other resources. I personally use it with modified versions of cosmo_hud, RealisticVehicleFailure, and my car locks resource.
##### Using a 600ms thread in this one resource allows me to enable the car hud, enable the seatbelt command, check if the player is driving or a passenger, and with my car locks to determine if I am on foot (trust me, it's important for optimisation).
##### I was able to strip 0.02ms off cosmo_hud by removing the vehicle check, reduce vehiclefailure by 0.01ms in a car and to 0ms while on foot - I would say the benefits are very noticeable.

##### The new SetInterval function is something I had thought of but didn't create until I saw the convenience of it in ESX Reborn.
##### Not having to define a function to create a thread containing a while loop saves a lot of hassle and it's simple enough to stop the interval and recreate it with different timers (though you could also take influence from the ClearInterval function to see how you could modify the time).
