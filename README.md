### Yet another sample resource
Just something I'm playing with to handle (simple) threads in a single place and allow easy creation and deletion of a thread.

The "Bool" thread type is intended for triggering a loop in another resource that needs to run frequently, thus we can cancel that loop when it doesn't need to be running.

"Update" threads will send an event when the result has changed, while the default thread just triggers an event at an interval.

At the top is a separate thread for handling all DisableControlAction functions that need to occur on frame, able to easily take in more values if needed.
