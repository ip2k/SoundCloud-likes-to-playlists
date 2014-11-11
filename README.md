Likes to Playlists
===================

How 2
======
You'll need an app key and secret for this. Get that [here](http://soundcloud.com/you/apps/new).

Put those and your SoundCloud username / password in `oauth-config.yaml` in the same directory as this script. An example for you to edit is included as `oauth-config.yaml.dist`. This is the [OAuth Uesr Credentials Flow](https://developers.soundcloud.com/docs/api/guide#authentication) if you're wondering, and yes; this could be much simpler if SoundCloud had a web UI to generate OAuth user tokens for developers.

To base64-encode your password, do something like this: `echo -n 'your-password-here' |base64`

To install the requirements, a `bundle install` should do it. Built for Ruby 2.1.

This is quite rough right now, and there's an issue where if the thing you liked wasn't cerated in the past month, it won't be added. It looks like SoundCloud doesn't track the date of when you add something, so I'm not sure how to get around that. Please submit a PR if you have suggestions (line 50).
