#### Yet another sample resource
##### Just something I'm playing with to handle (simple) threads in a single place and allow easy creation and deletion of a thread.
##### This is intended for handling loops that are likely to be used in a multitude of resources, such as checking if the player is near certain locations, in a vehicle, in combat, etc.
##### The "Bool" thread type is intended for triggering a loop in another resource that needs to run frequently, thus we can cancel that loop when it doesn't need to be running.
##### "Update" threads will send an event when the result has changed, while the default thread just triggers an event at an interval.


##### The thread at the top is for handling all DisableControlActions in a single thread.
