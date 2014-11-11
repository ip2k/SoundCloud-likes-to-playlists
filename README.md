Likes to Playlists
===================

How 2
======
You'll need an app key and secret for this. Get that [here](http://soundcloud.com/you/apps/new).

Put it all in a file called `oauth-details.yaml` in the same directory as this script.

Like this:

```
client_id: your-big-long-client-id
client_secret: impressively-large-client-secret
username: your-soundcloud-username
password_base64: base64'd version of your password
```

This is quite rough right now, and there's an issue where if the thing you liked wasn't cerated in the past month, it won't be added. It looks like SoundCloud doesn't track the date of when you add something, so I'm not sure how to get around that. Please submit a PR if you have suggestions (line 50).
